From: Andy Grover <agrover@redhat.com>
Subject: [RFC 2/2] target: Add a user-passthrough backstore
Date: Tue,  1 Jul 2014 12:11:15 -0700
Message-ID: <1404241875-29164-3-git-send-email-agrover@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a LIO storage engine that presents commands to userspace for execution.
This would allow more complex backstores to be implemented out-of-kernel,
and also make experimentation a-la FUSE (but at the SCSI level -- "SUSE"?)
possible.

It uses a mmap()able UIO device per LUN to share a command ring and data
area. The commands are raw SCSI CDBs and iovs for in/out data. The command
ring is also reused for scsi command status and sense data, if present.

This implementation is based on Shaohua Li's earlier version but heavily
modified. Differences include:

* Shared memory allocated by kernel, not locked-down user pages
* Single ring for command request and response
* Offsets instead of embedded pointers
* Generic SCSI CDB passthrough instead of per-cmd specialization in ring
  format.
* Uses UIO device instead of anon_file passed in mailbox.
* Optional in-kernel handling of some commands.

The main reason for these differences is to permit greater resiliency
if the user process dies or hangs.

Things not yet implemented (on purpose):

* Zero copy. The data area is flexible enough to allow page flipping or
  backend-allocated pages to be used by fabrics, but it's not clear these
  are performance wins. Can come later.
* Out-of-order command completion by userspace. Possible to add by just
  allowing userspace to change cmd_id in rsp cmd entries, but currently
  not supported.
* No locks between kernel cmd submission and completion routines. Sounds
  like it's possible, but this can come later.
* Sparse allocation of mmaped area. Current code vmallocs the whole thing.
  If the mapped area was larger and not fully mapped then the driver would
  have more freedom to change cmd and data area sizes based on demand.

Current code open issues:

* The use of idrs may be overkill -- we maybe can replace them with a
  simple counter to generate cmd_ids, and a hash table to get a cmd_id's
  associated pointer.
* Use of a free-running counter for cmd ring instead of explicit modulo
  math. This would require power-of-2 cmd ring size.
* Random printks in code, still.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1078 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_user.h      |  126 ++++
 5 files changed, 1214 insertions(+)
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 drivers/target/target_core_user.h

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index dc2d84a..b03a845 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -31,6 +31,11 @@ config TCM_PSCSI
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device
 
+config TCM_USER
+	tristate "TCM/USER Subsystem Plugin for Linux"
+	help
+	Say Y here to enable the TCM/USER subsystem plugin
+
 source "drivers/target/loopback/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
 source "drivers/target/iscsi/Kconfig"
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 85b012d..bbb4a7d 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
 obj-$(CONFIG_TCM_IBLOCK)	+= target_core_iblock.o
 obj-$(CONFIG_TCM_FILEIO)	+= target_core_file.o
 obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
+obj-$(CONFIG_TCM_USER)		+= target_core_user.o
 
 # Fabric modules
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fa62fc..f018a8c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -232,6 +232,10 @@ void transport_subsystem_check_init(void)
 	if (ret != 0)
 		pr_err("Unable to load target_core_pscsi\n");
 
+	ret = request_module("target_core_user");
+	if (ret != 0)
+		pr_err("Unable to load target_core_user\n");
+
 	sub_api_initialized = 1;
 }
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
new file mode 100644
index 0000000..544f3c5
--- /dev/null
+++ b/drivers/target/target_core_user.c
@@ -0,0 +1,1078 @@
+/*
+ * Copyright (C) 2013 Shaohua Li <shli@kernel.org>
+ * Copyright (C) 2014 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/timer.h>
+#include <linux/parser.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <linux/uio_driver.h>
+#include <target/target_core_base.h>
+#include <target/target_core_backend.h>
+#include "target_core_user.h"
+
+/*
+ * Define a shared-memory interface for LIO to pass SCSI commands and
+ * data to userspace for processing. This is to allow backends that
+ * are too complex for in-kernel support to be possible.
+ *
+ * It uses the UIO framework to do a lot of the device-creation and
+ * introspection work for us.
+ *
+ * See the .h file for how the ring is laid out. Note that while the
+ * command ring is defined, the particulars of the data area are
+ * not. Offset values in the command entry point to other locations
+ * internal to the mmap()ed area. There is separate space outside the
+ * command ring for data buffers. This leaves maximum flexibility for
+ * moving buffer allocations, or even page flipping or other
+ * allocation techniques, without altering the command ring layout.
+ *
+ * SECURITY:
+ * The user process must be assumed to be malicious. There's no way to
+ * prevent it breaking the command ring protocol if it wants, but in
+ * order to prevent other issues we must only ever read *data* from
+ * the shared memory area, not offsets or sizes. This applies to
+ * command ring entries as well as the mailbox. Extra code needed for
+ * this may have a 'UAM' comment.
+ */
+
+
+#define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
+
+#define CMDR_SIZE (16 * 4096)
+#define DATA_SIZE (256 * 4096)
+
+#define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
+
+
+struct device *tcmu_root_device;
+
+struct tcmu_host {
+	u32 dev_id_count;
+	u32 host_id;
+};
+
+/* User wants just r/w cmds, or all sbc cmds, or all SCSI cmds */
+enum passthru_level {
+	TCMU_PASS_RW = 0,
+	TCMU_PASS_SBC,
+	TCMU_PASS_SPC,
+	TCMU_PASS_INVALID,
+};
+
+#define TCMU_CONFIG_LEN 256
+
+#define TCMU_BIT_OPEN 0
+#define TCMU_BIT_BROKEN 1
+
+struct tcmu_dev {
+	struct se_device se_dev;
+	u32 dev_id;
+	enum passthru_level pass_level;
+	unsigned long flags;
+
+	struct uio_info uio_info;
+
+	struct tcmu_mailbox *mb_addr;
+	size_t dev_size;
+	u32 cmdr_size;
+	u32 cmdr_last_cleaned;
+	/* Offset of data ring from start of mb */
+	size_t data_off;
+	size_t data_size;
+	/* Ring head + tail values. */
+	/* Must add data_off and mb_addr to get the address */
+	size_t data_head;
+	size_t data_tail;
+
+	wait_queue_head_t wait_cmdr;
+	/* TODO should this be a mutex? */
+	spinlock_t cmdr_lock;
+
+	struct idr commands;
+	spinlock_t commands_lock;
+
+	struct timer_list timeout;
+
+	struct kref ref;
+
+	char dev_config[TCMU_CONFIG_LEN];
+};
+
+#define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
+
+#define CMDR_OFF sizeof(struct tcmu_mailbox)
+
+struct tcmu_cmd {
+	struct se_cmd *se_cmd;
+	struct tcmu_dev *tcmu_dev;
+
+	uint16_t cmd_id;
+
+	/* Can't use se_cmd->data_length when cleaning up expired cmds, because if
+	   cmd has been completed then accessing se_cmd is off limits */
+	size_t data_length;
+
+	unsigned long deadline;
+	unsigned long flags;
+};
+
+enum {
+	TCMU_CMD_EXPIRED = (1 << 0),
+};
+
+static struct kmem_cache *tcmu_cmd_cache;
+
+static void tcmu_destroy_device(struct kref *kref)
+{
+	struct tcmu_dev *udev = container_of(kref, struct tcmu_dev, ref);
+
+	kfree(udev);
+}
+
+static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	struct tcmu_cmd *tcmu_cmd;
+	int cmd_id;
+
+	tcmu_cmd = kmem_cache_alloc(tcmu_cmd_cache, GFP_KERNEL);
+	if (!tcmu_cmd)
+		return NULL;
+
+	tcmu_cmd->se_cmd = se_cmd;
+	tcmu_cmd->tcmu_dev = udev;
+	tcmu_cmd->data_length = se_cmd->data_length;
+
+	tcmu_cmd->deadline = jiffies + msecs_to_jiffies(TCMU_TIME_OUT);
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&udev->commands_lock);
+	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 0,
+		USHRT_MAX, GFP_NOWAIT);
+	spin_unlock_irq(&udev->commands_lock);
+	idr_preload_end();
+
+	if (cmd_id < 0) {
+		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+		return NULL;
+	}
+	tcmu_cmd->cmd_id = cmd_id;
+
+	return tcmu_cmd;
+}
+
+static inline void flush_dcache_range(void *vaddr, size_t size)
+{
+	unsigned long offset = (unsigned long) vaddr & ~PAGE_MASK;
+
+	size = round_up(size+offset, PAGE_SIZE);
+	vaddr -= offset;
+
+	while (size) {
+		flush_dcache_page(virt_to_page(vaddr));
+		size -= PAGE_SIZE;
+	}
+}
+
+/*
+ * Some ring helper functions. We don't assume size is a power of 2 so
+ * we can't use circ_buf.h.
+ */
+static inline size_t spc_used(size_t head, size_t tail, size_t size)
+{
+	int diff = head - tail;
+
+	if (diff >= 0)
+		return diff;
+	else
+		return size + diff;
+}
+
+static inline size_t spc_free(size_t head, size_t tail, size_t size)
+{
+	/* Keep 1 byte unused or we can't tell full from empty */
+	return (size - spc_used(head, tail, size) - 1);
+}
+
+static inline size_t head_to_end(size_t head, size_t size)
+{
+	return size - head;
+}
+
+#define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
+
+/*
+ * We can't queue a command until we have space available on the cmd ring *and* space
+ * space avail on the data ring.
+ *
+ * Called with ring lock held.
+ */
+static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_needed, size_t data_needed)
+{
+	struct tcmu_mailbox *mb = udev->mb_addr;
+	size_t space;
+	u32 cmd_head;
+
+	flush_dcache_range(mb, sizeof(*mb));
+
+	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+
+	space = spc_free(cmd_head, udev->cmdr_last_cleaned, udev->cmdr_size);
+	if (space < cmd_needed) {
+		pr_err("no cmd space: %u %u %u\n", cmd_head,
+		       udev->cmdr_last_cleaned, udev->cmdr_size);
+		return false;
+	}
+
+	space = spc_free(udev->data_head, udev->data_tail, udev->data_size);
+	if (space < data_needed) {
+		pr_err("no data space: %zu %zu %zu\n", udev->data_head,
+		       udev->data_tail, udev->data_size);
+		return false;
+	}
+
+	return true;
+}
+
+static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
+{
+	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	size_t base_command_size, command_size;
+	size_t cmdr_space_needed;
+	struct tcmu_mailbox *mb;
+	DEFINE_WAIT(__wait);
+	int ret = 0;
+	size_t pad_size;
+	struct tcmu_cmd_entry *entry;
+	int i;
+	struct scatterlist *sg;
+	struct iovec *iov;
+	int iov_cnt = 0;
+	uint64_t cmd_head;
+	uint64_t cdb_off;
+
+	if (test_bit(TCMU_BIT_BROKEN, &udev->flags))
+		return -EINVAL;
+
+	/*
+	 * Must be a certain minimum size for response sense info, but
+	 * also may be larger if the iov array is large.
+	 *
+	 * iovs = sgl_nents+1, for end-of-ring case, plus another 1
+	 * b/c size == offsetof one-past-element.
+	*/
+	base_command_size = max(offsetof(struct tcmu_cmd_entry,
+					 req.iov[se_cmd->t_data_nents + 2]),
+				sizeof(struct tcmu_cmd_entry));
+	command_size = base_command_size
+		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
+
+	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
+
+	mb = udev->mb_addr;
+
+	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+
+	spin_lock_irq(&udev->cmdr_lock);
+
+	if ((command_size > (udev->cmdr_size / 2))
+	    || tcmu_cmd->data_length > (udev->data_size - 1))
+		pr_warn("TCMU: Request of size %zu/%zu may be too big for %u/%zu "
+			"cmd/data ring buffers\n", command_size, tcmu_cmd->data_length,
+			udev->cmdr_size, udev->data_size);
+
+	/*
+	 * Cmd end-of-ring space is too small so we need space for a NOP plus orig.
+	 * cmd. (Data ring can split, so it gets split logic instead of pad logic.)
+	 */
+	if (head_to_end(cmd_head, udev->cmdr_size) >= command_size)
+		pad_size = 0;
+	else
+		pad_size = head_to_end(cmd_head, udev->cmdr_size);
+	cmdr_space_needed = command_size + pad_size;
+
+	while (!is_ring_space_avail(udev, cmdr_space_needed, tcmu_cmd->data_length)) {
+
+		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
+
+		printk("sleeping for ring space\n");
+		spin_unlock_irq(&udev->cmdr_lock);
+		ret = schedule_timeout(msecs_to_jiffies(TCMU_TIME_OUT));
+		finish_wait(&udev->wait_cmdr, &__wait);
+		if (!ret) {
+			pr_warn("tcmu: command timed out\n");
+			return -ETIMEDOUT;
+		}
+
+		spin_lock_irq(&udev->cmdr_lock);
+	}
+
+	if (pad_size) {
+		printk("pad inserted %zu bytes\n", pad_size);
+		entry = (void *) mb + CMDR_OFF + cmd_head;
+		flush_dcache_range(entry, sizeof(*entry));
+		tcmu_hdr_set_op(&entry->hdr, TCMU_OP_PAD);
+		tcmu_hdr_set_len(&entry->hdr, pad_size);
+
+		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
+
+		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+		WARN_ON(cmd_head != 0);
+	}
+
+	entry = (void *) mb + CMDR_OFF + cmd_head;
+	flush_dcache_range(entry, sizeof(*entry));
+	tcmu_hdr_set_op(&entry->hdr, TCMU_OP_CMD);
+	tcmu_hdr_set_len(&entry->hdr, command_size);
+	entry->cmd_id = tcmu_cmd->cmd_id;
+
+	/* Fix up iovecs, handling possibly discontiguous data buffer */
+	iov = &entry->req.iov[0];
+	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
+		size_t copy_bytes = min((size_t)sg->length,
+				     head_to_end(udev->data_head, udev->data_size));
+		void *from = kmap_atomic(sg_page(sg)) + sg->offset;
+		void *to = mb + udev->data_off + udev->data_head;
+
+		if (tcmu_cmd->se_cmd->data_direction == DMA_TO_DEVICE) {
+			memcpy(to, from, copy_bytes);
+			flush_dcache_range(to, copy_bytes);
+		}
+
+		/* Even iov_base is relative to mb_addr */
+		iov->iov_len = copy_bytes;
+		iov->iov_base = (void *) udev->data_off + udev->data_head;
+		iov_cnt++;
+		iov++;
+
+		UPDATE_HEAD(udev->data_head, copy_bytes, udev->data_size);
+
+		/* Uh oh, we wrapped the buffer. Must split sg across 2 iovs. */
+		if (sg->length != copy_bytes) {
+			from += copy_bytes;
+			copy_bytes = sg->length - copy_bytes;
+
+			iov->iov_len = copy_bytes;
+			iov->iov_base = (void *) udev->data_off + udev->data_head;
+
+			if (se_cmd->data_direction == DMA_TO_DEVICE) {
+				memcpy((void *) mb + udev->data_off + udev->data_head,
+				       from, copy_bytes);
+				flush_dcache_range(to, copy_bytes);
+			}
+
+			printk("SECOND alloced %zu from data ring\n", copy_bytes);
+
+			iov_cnt++;
+			iov++;
+
+			UPDATE_HEAD(udev->data_head, copy_bytes, udev->data_size);
+		}
+
+		kunmap_atomic(from);
+	}
+	entry->req.iov_cnt = iov_cnt;
+
+	/* All offsets relative to mb_addr, not start of entry! */
+	cdb_off = CMDR_OFF + cmd_head + base_command_size;
+	memcpy((void *)mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
+	entry->req.cdb_off = cdb_off;
+	flush_dcache_range(entry, sizeof(*entry));
+
+	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
+	flush_dcache_range(mb, sizeof(*mb));
+
+	spin_unlock_irq(&udev->cmdr_lock);
+
+	/* TODO: only if FLUSH and FUA? */
+	uio_event_notify(&udev->uio_info);
+	printk("userspace poked\n");
+
+	mod_timer(&udev->timeout,
+		round_jiffies_up(jiffies + msecs_to_jiffies(TCMU_TIME_OUT)));
+
+	return ret;
+}
+
+static int tcmu_queue_cmd(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	struct tcmu_cmd *tcmu_cmd;
+	int ret;
+
+	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
+	if (!tcmu_cmd)
+		return -ENOMEM;
+
+	ret = tcmu_queue_cmd_ring(tcmu_cmd);
+	if (ret < 0) {
+		pr_err("TCMU: Could not queue command\n");
+		spin_lock_irq(&udev->commands_lock);
+		idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+		spin_unlock_irq(&udev->commands_lock);
+
+		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+	}
+
+	return ret;
+}
+
+static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
+{
+	struct se_cmd *se_cmd = cmd->se_cmd;
+	struct tcmu_dev *udev = cmd->tcmu_dev;
+
+	if (cmd->flags & TCMU_CMD_EXPIRED) {
+		/* cmd has been completed already from timeout, just reclaim data
+		   ring space */
+		UPDATE_HEAD(udev->data_tail, cmd->data_length, udev->data_size);
+		return;
+	}
+
+	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+		struct scatterlist *sg;
+		int i;
+
+		/* It'd be easier to look at entry's iovec again, but UAM */
+		for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
+			size_t copy_bytes;
+			void *to;
+			void *from;
+
+			copy_bytes = min((size_t)sg->length,
+					 head_to_end(udev->data_head, udev->data_size));
+
+			to = kmap_atomic(sg_page(sg)) + sg->offset;
+			from = (void *) udev->mb_addr + udev->data_off + udev->data_tail;
+			flush_dcache_range(from, copy_bytes);
+			memcpy(to, from, copy_bytes);
+
+			UPDATE_HEAD(udev->data_tail, copy_bytes, udev->data_size);
+
+			/* Uh oh, wrapped the data buffer for this sg's data */
+			if (sg->length != copy_bytes) {
+				from = (void *) udev->mb_addr + udev->data_off + udev->data_tail;
+				WARN_ON(udev->data_tail);
+				to += copy_bytes;
+				copy_bytes = sg->length - copy_bytes;
+				flush_dcache_range(from, copy_bytes);
+				memcpy(to, from, copy_bytes);
+
+				UPDATE_HEAD(udev->data_tail, copy_bytes, udev->data_size);
+			}
+
+			kunmap_atomic(to);
+		}
+
+	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
+		UPDATE_HEAD(udev->data_tail, cmd->data_length, udev->data_size);
+	} else {
+		pr_warn("TCMU: data direction was %d!\n", se_cmd->data_direction);
+	}
+
+	if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION)
+		memcpy(se_cmd->sense_buffer, entry->rsp.sense_buffer,
+		       se_cmd->scsi_sense_length);
+
+	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
+	cmd->se_cmd = NULL;
+}
+
+static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+{
+	struct tcmu_mailbox *mb;
+	LIST_HEAD(cpl_cmds);
+	unsigned long flags;
+	int handled = 0;
+
+	if (test_bit(TCMU_BIT_BROKEN, &udev->flags)) {
+		pr_err("ring broken, not handling completions\n");
+		return 0;
+	}
+
+	spin_lock_irqsave(&udev->cmdr_lock, flags);
+
+	mb = udev->mb_addr;
+	flush_dcache_range(mb, sizeof(*mb));
+
+	while (udev->cmdr_last_cleaned != ACCESS_ONCE(mb->cmd_tail)) {
+
+		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
+		struct tcmu_cmd *cmd;
+
+		flush_dcache_range(entry, sizeof(*entry));
+
+		if (tcmu_hdr_get_op(&entry->hdr) == TCMU_OP_PAD) {
+			UPDATE_HEAD(udev->cmdr_last_cleaned, tcmu_hdr_get_len(&entry->hdr), udev->cmdr_size);
+			continue;
+		}
+		WARN_ON(tcmu_hdr_get_op(&entry->hdr) != TCMU_OP_CMD);
+
+		spin_lock(&udev->commands_lock);
+		cmd = idr_find(&udev->commands, entry->cmd_id);
+		if (cmd)
+			idr_remove(&udev->commands, cmd->cmd_id);
+		spin_unlock(&udev->commands_lock);
+
+		if (!cmd) {
+			pr_err("cmd_id not found, ring is broken\n");
+			set_bit(TCMU_BIT_BROKEN, &udev->flags);
+			break;
+		}
+
+		tcmu_handle_completion(cmd, entry);
+
+		kmem_cache_free(tcmu_cmd_cache, cmd);
+
+		UPDATE_HEAD(udev->cmdr_last_cleaned, tcmu_hdr_get_len(&entry->hdr), udev->cmdr_size);
+
+		handled++;
+	}
+
+	if (mb->cmd_tail == mb->cmd_head)
+		del_timer(&udev->timeout); /* no more pending cmds */
+
+	spin_unlock_irqrestore(&udev->cmdr_lock, flags);
+
+	wake_up(&udev->wait_cmdr);
+
+	return handled;
+}
+
+static int tcmu_check_expired_cmd(int id, void *p, void *data)
+{
+	struct tcmu_cmd *cmd = p;
+
+	if (cmd->flags & TCMU_CMD_EXPIRED)
+		return 0;
+
+	if (time_after(cmd->deadline, jiffies))
+		return 0;
+
+	cmd->flags |= TCMU_CMD_EXPIRED;
+	target_complete_cmd(cmd->se_cmd, SAM_STAT_TASK_ABORTED);
+	cmd->se_cmd = NULL;
+
+	return 0;
+}
+
+static void tcmu_device_timedout(unsigned long data)
+{
+	struct tcmu_dev *udev = (struct tcmu_dev *)data;
+	unsigned long flags;
+	int handled;
+
+	handled = tcmu_handle_completions(udev);
+
+	printk("%d completions handled from timeout\n", handled);
+
+	spin_lock_irqsave(&udev->commands_lock, flags);
+	idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
+	spin_unlock_irqrestore(&udev->commands_lock, flags);
+
+	/*
+	 * We don't need to wakeup threads on wait_cmdr since they have their
+	 * own timeout.
+	 */
+}
+
+static int tcmu_attach_hba(struct se_hba *hba, u32 host_id)
+{
+	struct tcmu_host *tcmu_host;
+
+	tcmu_host = kzalloc(sizeof(struct tcmu_host), GFP_KERNEL);
+	if (!tcmu_host)
+		return -ENOMEM;
+
+	tcmu_host->host_id = host_id;
+
+	hba->hba_ptr = tcmu_host;
+
+	return 0;
+}
+
+static void tcmu_detach_hba(struct se_hba *hba)
+{
+	struct tcmu_host *tcmu_host = hba->hba_ptr;
+
+	kfree(tcmu_host);
+	hba->hba_ptr = NULL;
+}
+
+static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
+{
+	struct tcmu_dev *udev;
+
+	udev = kzalloc(sizeof(struct tcmu_dev), GFP_KERNEL);
+	if (!udev)
+		return NULL;
+
+	init_waitqueue_head(&udev->wait_cmdr);
+	spin_lock_init(&udev->cmdr_lock);
+
+	idr_init(&udev->commands);
+	spin_lock_init(&udev->commands_lock);
+
+	setup_timer(&udev->timeout, tcmu_device_timedout,
+		(unsigned long)udev);
+
+	udev->pass_level = TCMU_PASS_RW;
+
+	kref_init(&udev->ref);
+
+	return &udev->se_dev;
+}
+
+static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
+{
+	struct tcmu_dev *tcmu_dev = container_of(info, struct tcmu_dev, uio_info);
+	int handled;
+
+	handled = tcmu_handle_completions(tcmu_dev);
+
+	printk("%d completions handled\n", handled);
+
+	return 0;
+}
+
+/*
+ * mmap code from uio.c. Copied here because we want to hook mmap()
+ * and this stuff must come along.
+ */
+static int tcmu_find_mem_index(struct vm_area_struct *vma)
+{
+	struct tcmu_dev *udev = vma->vm_private_data;
+	struct uio_info *info = &udev->uio_info;
+
+	if (vma->vm_pgoff < MAX_UIO_MAPS) {
+		if (info->mem[vma->vm_pgoff].size == 0)
+			return -1;
+		return (int)vma->vm_pgoff;
+	}
+	return -1;
+}
+
+static int tcmu_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct tcmu_dev *udev = vma->vm_private_data;
+	struct uio_info *info = &udev->uio_info;
+	struct page *page;
+	unsigned long offset;
+	void *addr;
+
+	int mi = tcmu_find_mem_index(vma);
+	if (mi < 0)
+		return VM_FAULT_SIGBUS;
+
+	/*
+	 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
+	 * to use mem[N].
+	 */
+	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
+
+	addr = (void *)(unsigned long)info->mem[mi].addr + offset;
+	if (info->mem[mi].memtype == UIO_MEM_LOGICAL)
+		page = virt_to_page(addr);
+	else
+		page = vmalloc_to_page(addr);
+	get_page(page);
+	vmf->page = page;
+	return 0;
+}
+
+static const struct vm_operations_struct tcmu_vm_ops = {
+	.fault = tcmu_vma_fault,
+};
+
+static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
+{
+	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &tcmu_vm_ops;
+
+	vma->vm_private_data = udev;
+
+	/* Ensure the mmap is exactly the right size */
+	if (vma_pages(vma) != (TCMU_RING_SIZE >> PAGE_SHIFT))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int tcmu_open(struct uio_info *info, struct inode *inode)
+{
+	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+
+	/* O_EXCL not supported for char devs, so fake it? */
+	if (test_and_set_bit(TCMU_BIT_OPEN, &udev->flags))
+		return -EBUSY;
+
+	return 0;
+}
+
+static int tcmu_release(struct uio_info *info, struct inode *inode)
+{
+	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+
+	clear_bit(TCMU_BIT_OPEN, &udev->flags);
+
+	return 0;
+}
+
+static int tcmu_configure_device(struct se_device *dev)
+{
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+	struct uio_info *info;
+	struct tcmu_mailbox *mb;
+	size_t size;
+	int ret = 0;
+	char *str;
+
+	info = &udev->uio_info;
+
+	size = strlen(udev->dev_config) + 9; /* for 'tcm-user' + '+' + '\0' */
+	str = kmalloc(size, GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	snprintf(str, size, "tcm-user");
+	if (udev->dev_config[0])
+		snprintf(str + 7, size - 7, "+%s", udev->dev_config);
+	info->name = str;
+
+	udev->mb_addr = vzalloc(TCMU_RING_SIZE);
+	if (!udev->mb_addr) {
+		kfree(info->name);
+		return -ENOMEM;
+	}
+
+	/* mailbox fits in first part of CMDR space */
+	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
+	udev->data_off = CMDR_SIZE;
+	udev->data_size = TCMU_RING_SIZE - CMDR_SIZE;
+
+	mb = udev->mb_addr;
+	mb->version = 1;
+	mb->cmdr_off = CMDR_OFF;
+	mb->cmdr_size = udev->cmdr_size;
+
+	WARN_ON(!PAGE_ALIGNED(udev->data_off));
+	WARN_ON(udev->data_size % PAGE_SIZE);
+
+	info->version = "1";
+
+	info->mem[0].name = "tcm-user command & data buffer";
+	info->mem[0].addr = (phys_addr_t) udev->mb_addr;
+	info->mem[0].size = TCMU_RING_SIZE;
+	info->mem[0].memtype = UIO_MEM_VIRTUAL;
+
+	info->irqcontrol = tcmu_irqcontrol;
+	info->irq = UIO_IRQ_CUSTOM;
+
+	info->mmap = tcmu_mmap;
+	info->open = tcmu_open;
+	info->release = tcmu_release;
+
+	ret = uio_register_device(tcmu_root_device, info);
+	if (ret) {
+		kfree(info->name);
+		vfree(udev->mb_addr);
+		return ret;
+	}
+
+	/* Other attributes can be configured in userspace */
+	dev->dev_attrib.hw_block_size = 4096;
+	dev->dev_attrib.hw_max_sectors = 64;
+	dev->dev_attrib.hw_queue_depth = 64;
+
+	return ret;
+}
+
+static int tcmu_check_pending_cmd(int id, void *p, void *data)
+{
+	struct tcmu_cmd *cmd = p;
+
+	if (cmd->flags & TCMU_CMD_EXPIRED)
+		return 0;
+	return -EINVAL;
+}
+
+static void tcmu_free_device(struct se_device *dev)
+{
+	int i;
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	del_timer_sync(&udev->timeout);
+
+	vfree(udev->mb_addr);
+
+	/* upper layer should drain all requests before calling this */
+	spin_lock_irq(&udev->commands_lock);
+	i = idr_for_each(&udev->commands, tcmu_check_pending_cmd, NULL);
+	idr_destroy(&udev->commands);
+	spin_unlock_irq(&udev->commands_lock);
+	WARN_ON(i);
+
+	uio_unregister_device(&udev->uio_info);
+
+	kfree(udev->uio_info.name);
+
+	kref_put(&udev->ref, tcmu_destroy_device);
+}
+
+enum {
+	Opt_dev_config, Opt_dev_size, Opt_err, Opt_pass_level
+};
+
+static match_table_t tokens = {
+	{Opt_dev_config, "dev_config=%s"},
+	{Opt_dev_size, "dev_size=%u"},
+	{Opt_pass_level, "pass_level=%u"},
+	{Opt_err, NULL}
+};
+
+static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
+		const char *page, ssize_t count)
+{
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+	char *orig, *ptr, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, token;
+	int arg;
+
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+
+	orig = opts;
+
+	while ((ptr = strsep(&opts, ",\n")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_dev_config:
+			if (match_strlcpy(udev->dev_config, &args[0],
+				TCMU_CONFIG_LEN) == 0) {
+				ret = -EINVAL;
+				break;
+			}
+			pr_debug("TCMU: Referencing Path: %s\n", udev->dev_config);
+			break;
+		case Opt_dev_size:
+			match_int(args, &arg);
+			pr_debug("TCMU: Setting dev_size to %d\n", arg);
+			udev->dev_size = arg;
+			break;
+		case Opt_pass_level:
+			match_int(args, &arg);
+			if (arg >= TCMU_PASS_INVALID) {
+				pr_warn("TCMU: Invalid pass_level: %d\n", arg);
+				break;
+			}
+
+			pr_debug("TCMU: Setting pass_level to %d\n", arg);
+			udev->pass_level = arg;
+			break;
+		default:
+			break;
+		}
+	}
+
+	kfree(orig);
+	return (!ret) ? count : ret;
+}
+
+static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
+{
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+	ssize_t bl = 0;
+
+	bl = sprintf(b + bl, "Config: %s", udev->dev_config[0] ? udev->dev_config : "NULL");
+	bl += sprintf(b + bl, " Mailbox_size: %zu Dev_size: %zu Pass_level: %u\n",
+		      CMDR_OFF, udev->dev_size, udev->pass_level);
+
+	return bl;
+}
+
+static sector_t tcmu_get_blocks(struct se_device *dev)
+{
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	return div_u64(udev->dev_size, dev->dev_attrib.block_size);
+}
+
+/* could be execute_cmd if we wanted to open it up a bit */
+static sense_reason_t
+tcmu_execute_rw(struct se_cmd *se_cmd, struct scatterlist *sgl, u32 sgl_nents,
+		enum dma_data_direction data_direction)
+{
+	int ret;
+
+	ret = tcmu_queue_cmd(se_cmd);
+
+	if (ret != 0)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	else
+		return TCM_NO_SENSE;
+}
+
+static sense_reason_t
+tcmu_pass_op(struct se_cmd *se_cmd)
+{
+	int ret;
+
+	printk("in tcmu_pass_op\n");
+
+	ret = tcmu_queue_cmd(se_cmd);
+
+	if (ret != 0)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	else
+		return TCM_NO_SENSE;
+}
+
+
+static struct sbc_ops tcmu_sbc_rw = {
+	.execute_rw = tcmu_execute_rw
+};
+
+static struct sbc_ops tcmu_sbc_all = {
+	.execute_rw = tcmu_execute_rw,
+	.execute_sync_cache	= tcmu_pass_op,
+	.execute_write_same	= tcmu_pass_op,
+	.execute_write_same_unmap = tcmu_pass_op,
+	.execute_unmap		= tcmu_pass_op,
+};
+
+static sense_reason_t
+tcmu_parse_cdb(struct se_cmd *cmd)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	sense_reason_t ret = TCM_NO_SENSE;
+	unsigned char *cdb = cmd->t_task_cdb;
+
+	switch (udev->pass_level) {
+	case TCMU_PASS_RW:
+		ret = sbc_parse_cdb(cmd, &tcmu_sbc_rw);
+		break;
+	case TCMU_PASS_SBC:
+		ret = sbc_parse_cdb(cmd, &tcmu_sbc_all);
+		break;
+	case TCMU_PASS_SPC:
+		/* We're just like pscsi, then */
+		/*
+		 * For REPORT LUNS we always need to emulate the response, for everything
+		 * else, pass it up.
+		 */
+		switch (cdb[0]) {
+		case REPORT_LUNS:
+			cmd->execute_cmd = spc_emulate_report_luns;
+			break;
+		case READ_6:
+		case READ_10:
+		case READ_12:
+		case READ_16:
+		case WRITE_6:
+		case WRITE_10:
+		case WRITE_12:
+		case WRITE_16:
+		case WRITE_VERIFY:
+			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
+			/* FALLTHROUGH */
+		default:
+			cmd->execute_cmd = tcmu_pass_op;
+		}
+		break;
+	default:
+		pr_err("Unknown tcm-user pass level %d\n", udev->pass_level);
+		ret = TCM_CHECK_CONDITION_ABORT_CMD;
+	}
+
+	return ret;
+}
+
+static struct se_subsystem_api tcmu_template = {
+	.name			= "user",
+	.inquiry_prod		= "USER",
+	.inquiry_rev		= TCMU_VERSION,
+	.owner			= THIS_MODULE,
+	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
+	.attach_hba		= tcmu_attach_hba,
+	.detach_hba		= tcmu_detach_hba,
+	.alloc_device		= tcmu_alloc_device,
+	.configure_device	= tcmu_configure_device,
+	.free_device		= tcmu_free_device,
+	.parse_cdb		= tcmu_parse_cdb,
+	.set_configfs_dev_params = tcmu_set_configfs_dev_params,
+	.show_configfs_dev_params = tcmu_show_configfs_dev_params,
+	.get_device_type	= sbc_get_device_type,
+	.get_blocks		= tcmu_get_blocks,
+};
+
+static int __init tcmu_module_init(void)
+{
+	int ret;
+
+	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
+
+	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
+				sizeof(struct tcmu_cmd),
+				__alignof__(struct tcmu_cmd),
+				0, NULL);
+	if (!tcmu_cmd_cache)
+		return -ENOMEM;
+
+	tcmu_root_device = root_device_register("tcm_user");
+	if (IS_ERR(tcmu_root_device)) {
+		kmem_cache_destroy(tcmu_cmd_cache);
+		return PTR_ERR(tcmu_root_device);
+	}
+
+	ret = transport_subsystem_register(&tcmu_template);
+	if (ret) {
+		root_device_unregister(tcmu_root_device);
+		kmem_cache_destroy(tcmu_cmd_cache);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit tcmu_module_exit(void)
+{
+	kmem_cache_destroy(tcmu_cmd_cache);
+	root_device_unregister(tcmu_root_device);
+	transport_subsystem_release(&tcmu_template);
+}
+
+MODULE_DESCRIPTION("TCM USER subsystem plugin");
+MODULE_AUTHOR("Shaohua Li <shli@kernel.org>");
+MODULE_AUTHOR("Andy Grover <agrover@redhat.com>");
+MODULE_LICENSE("GPL");
+
+module_init(tcmu_module_init);
+module_exit(tcmu_module_exit);
diff --git a/drivers/target/target_core_user.h b/drivers/target/target_core_user.h
new file mode 100644
index 0000000..07078e7
--- /dev/null
+++ b/drivers/target/target_core_user.h
@@ -0,0 +1,126 @@
+#ifndef __TARGET_CORE_USER_H
+#define __TARGET_CORE_USER_H
+
+/* This header will be used by application too */
+
+#include <linux/types.h>
+#include <linux/uio.h>
+
+#ifndef __packed
+#define __packed                        __attribute__((packed))
+#endif
+
+#define TCMU_VERSION "1.0"
+
+/*
+ * Ring Design
+ * -----------
+ *
+ * The mmaped area is divided into three parts:
+ * 1) The mailbox (struct tcmu_mailbox, below)
+ * 2) The command ring
+ * 3) Everything beyond the command ring (data)
+ *
+ * The mailbox tells userspace the offset of the command ring from the
+ * start of the shared memory region, and how big the command ring is.
+ *
+ * The kernel passes SCSI commands to userspace by putting a struct
+ * tcmu_cmd_entry in the ring, updating mailbox->cmd_head, and poking
+ * userspace via uio's interrupt mechanism.
+ *
+ * tcmu_cmd_entry contains a header. If the header type is PAD,
+ * userspace should skip hdr->length bytes (mod cmdr_size) to find the
+ * next cmd_entry.
+ *
+ * Otherwise, the entry will contain offsets into the mmaped area that
+ * contain the cdb and data buffers -- the latter accessible via the
+ * iov array. iov addresses are also offsets into the shared area.
+ *
+ * When userspace is completed handling the command, set
+ * entry->rsp.scsi_status, fill in rsp.sense_buffer if appropriate,
+ * and also set mailbox->cmd_tail equal to the old cmd_tail plus
+ * hdr->length, mod cmdr_size. If cmd_tail doesn't equal cmd_head, it
+ * should process the next packet the same way, and so on.
+ */
+
+#define TCMU_MAILBOX_VERSION 1
+#define ALIGN_SIZE 64 /* Should be enough for most CPUs */
+
+struct tcmu_mailbox {
+	__u16 version;
+	__u16 flags;
+	__u32 cmdr_off;
+	__u32 cmdr_size;
+
+	__u32 cmd_head;
+
+	/* Updated by user. On its own cacheline */
+	__u32 cmd_tail __attribute__((__aligned__(ALIGN_SIZE)));
+
+} __packed;
+
+enum tcmu_opcode {
+	TCMU_OP_PAD = 0,
+	TCMU_OP_CMD,
+};
+
+/*
+ * Only a few opcodes, and length is 8-byte aligned, so use low bits for opcode.
+ */
+struct tcmu_cmd_entry_hdr {
+		__u32 len_op;
+} __packed;
+
+#define TCMU_OP_MASK 0x7
+
+static inline enum tcmu_opcode tcmu_hdr_get_op(struct tcmu_cmd_entry_hdr *hdr)
+{
+	return hdr->len_op & TCMU_OP_MASK;
+}
+
+static inline void tcmu_hdr_set_op(struct tcmu_cmd_entry_hdr *hdr, enum tcmu_opcode op)
+{
+	hdr->len_op &= ~TCMU_OP_MASK;
+	hdr->len_op |= (op & TCMU_OP_MASK);
+}
+
+static inline __u32 tcmu_hdr_get_len(struct tcmu_cmd_entry_hdr *hdr)
+{
+	return hdr->len_op & ~TCMU_OP_MASK;
+}
+
+static inline void tcmu_hdr_set_len(struct tcmu_cmd_entry_hdr *hdr, __u32 len)
+{
+	hdr->len_op &= TCMU_OP_MASK;
+	hdr->len_op |= len;
+}
+
+/* Currently the same as SCSI_SENSE_BUFFERSIZE */
+#define TCMU_SENSE_BUFFERSIZE 96
+
+struct tcmu_cmd_entry {
+	struct tcmu_cmd_entry_hdr hdr;
+
+	uint16_t cmd_id;
+	uint16_t __pad1;
+
+	union {
+		struct {
+			uint64_t cdb_off;
+			uint64_t iov_cnt;
+			struct iovec iov[0];
+		} req;
+		struct {
+			uint8_t scsi_status;
+			uint8_t __pad1;
+			uint16_t __pad2;
+			uint32_t __pad3;
+			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
+		} rsp;
+	};
+
+} __packed;
+
+#define TCMU_OP_ALIGN_SIZE sizeof(uint64_t)
+
+#endif
-- 
1.9.3

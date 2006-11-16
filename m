From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/8] scsi tgt: scsi target user and kernel communication
 interface
Date: Thu, 16 Nov 2006 19:24:16 +0900
Message-ID: <20061116192416P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:36326 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1423648AbWKPKYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:24:13 -0500
Received: from mfs4.rdh.ecl.ntt.co.jp (mfs4.rdh.ecl.ntt.co.jp [129.60.39.113])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO9QQ002504
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:09 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs4.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO8OB023574
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:08 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO8ld013182
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:08 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The user-space daemon and tgt kernel module need bi-directional
kernel/user high-performance interface, however, mainline provides no
standard interface like that.

This patch adds shared memory interface between kernel and user spaces
like some other drivers do by using own character device. The
user-space daemon and tgt kernel module creates shared memory via mmap
and use it like ring buffer. poll (kernel to user) and write (user to
kernel) system calls are used for notification.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/scsi_tgt_if.c |  350 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_tgt_if.h |   90 +++++++++++
 2 files changed, 440 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
new file mode 100644
index 0000000..28fd222
--- /dev/null
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -0,0 +1,350 @@
+/*
+ * SCSI target kernel/user interface functions
+ *
+ * Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/miscdevice.h>
+#include <linux/file.h>
+#include <net/tcp.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tgt.h>
+#include <scsi/scsi_tgt_if.h>
+
+#include "scsi_tgt_priv.h"
+
+struct tgt_ring {
+	u32 tr_idx;
+	unsigned long tr_pages[TGT_RING_PAGES];
+	spinlock_t tr_lock;
+};
+
+/* tx_ring : kernel->user, rx_ring : user->kernel */
+static struct tgt_ring tx_ring, rx_ring;
+static DECLARE_WAIT_QUEUE_HEAD(tgt_poll_wait);
+
+static inline void tgt_ring_idx_inc(struct tgt_ring *ring)
+{
+	if (ring->tr_idx == TGT_MAX_EVENTS - 1)
+		ring->tr_idx = 0;
+	else
+		ring->tr_idx++;
+}
+
+static struct tgt_event *tgt_head_event(struct tgt_ring *ring, u32 idx)
+{
+	u32 pidx, off;
+
+	pidx = idx / TGT_EVENT_PER_PAGE;
+	off = idx % TGT_EVENT_PER_PAGE;
+
+	return (struct tgt_event *)
+		(ring->tr_pages[pidx] + sizeof(struct tgt_event) * off);
+}
+
+static int tgt_uspace_send_event(u32 type, struct tgt_event *p)
+{
+	struct tgt_event *ev;
+	struct tgt_ring *ring = &tx_ring;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&ring->tr_lock, flags);
+
+	ev = tgt_head_event(ring, ring->tr_idx);
+	if (!ev->hdr.status)
+		tgt_ring_idx_inc(ring);
+	else
+		err = -BUSY;
+
+	spin_unlock_irqrestore(&ring->tr_lock, flags);
+
+	if (err)
+		return err;
+
+	memcpy(ev, p, sizeof(*ev));
+	ev->hdr.type = type;
+	mb();
+	ev->hdr.status = 1;
+
+	flush_dcache_page(virt_to_page(ev));
+
+	wake_up_interruptible(&tgt_poll_wait);
+
+	return 0;
+}
+
+int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun, u64 tag)
+{
+	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
+	struct tgt_event ev;
+	int err;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.p.cmd_req.host_no = shost->host_no;
+	ev.p.cmd_req.data_len = cmd->request_bufflen;
+	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
+	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
+	ev.p.cmd_req.attribute = cmd->tag;
+	ev.p.cmd_req.tag = tag;
+
+	dprintk("%p %d %u %x %llx\n", cmd, shost->host_no,
+		ev.p.cmd_req.data_len, cmd->tag,
+		(unsigned long long) ev.p.cmd_req.tag);
+
+	err = tgt_uspace_send_event(TGT_KEVENT_CMD_REQ, &ev);
+	if (err)
+		eprintk("tx buf is full, could not send\n");
+
+	return err;
+}
+
+int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag)
+{
+	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
+	struct tgt_event ev;
+	int err;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.p.cmd_done.host_no = shost->host_no;
+	ev.p.cmd_done.tag = tag;
+	ev.p.cmd_done.result = cmd->result;
+
+	dprintk("%p %d %llu %u %x\n", cmd, shost->host_no,
+		(unsigned long long) ev.p.cmd_req.tag,
+		ev.p.cmd_req.data_len, cmd->tag);
+
+	err = tgt_uspace_send_event(TGT_KEVENT_CMD_DONE, &ev);
+	if (err)
+		eprintk("tx buf is full, could not send\n");
+
+	return err;
+}
+
+int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
+				  struct scsi_lun *scsilun, void *data)
+{
+	struct tgt_event ev;
+	int err;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.p.tsk_mgmt_req.host_no = host_no;
+	ev.p.tsk_mgmt_req.function = function;
+	ev.p.tsk_mgmt_req.tag = tag;
+	memcpy(ev.p.tsk_mgmt_req.lun, scsilun, sizeof(ev.p.tsk_mgmt_req.lun));
+	ev.p.tsk_mgmt_req.mid = (u64) (unsigned long) data;
+
+	dprintk("%d %x %llx %llx\n", host_no, function, (unsigned long long) tag,
+		(unsigned long long) ev.p.tsk_mgmt_req.mid);
+
+	err = tgt_uspace_send_event(TGT_KEVENT_TSK_MGMT_REQ, &ev);
+	if (err)
+		eprintk("tx buf is full, could not send\n");
+
+	return err;
+}
+
+static int event_recv_msg(struct tgt_event *ev)
+{
+	int err = 0;
+
+	switch (ev->hdr.type) {
+	case TGT_UEVENT_CMD_RSP:
+		err = scsi_tgt_kspace_exec(ev->p.cmd_rsp.host_no,
+					   ev->p.cmd_rsp.tag,
+					   ev->p.cmd_rsp.result,
+					   ev->p.cmd_rsp.len,
+					   ev->p.cmd_rsp.uaddr,
+					   ev->p.cmd_rsp.rw);
+		break;
+	case TGT_UEVENT_TSK_MGMT_RSP:
+		err = scsi_tgt_kspace_tsk_mgmt(ev->p.tsk_mgmt_rsp.host_no,
+					       ev->p.tsk_mgmt_rsp.mid,
+					       ev->p.tsk_mgmt_rsp.result);
+		break;
+	default:
+		eprintk("unknown type %d\n", ev->hdr.type);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static ssize_t tgt_write(struct file *file, const char __user * buffer,
+			 size_t count, loff_t * ppos)
+{
+	struct tgt_event *ev;
+	struct tgt_ring *ring = &rx_ring;
+
+	while (1) {
+		ev = tgt_head_event(ring, ring->tr_idx);
+		/* do we need this? */
+		flush_dcache_page(virt_to_page(ev));
+
+		if (!ev->hdr.status)
+			break;
+
+		tgt_ring_idx_inc(ring);
+		event_recv_msg(ev);
+		ev->hdr.status = 0;
+	};
+
+	return count;
+}
+
+static unsigned int tgt_poll(struct file * file, struct poll_table_struct *wait)
+{
+	struct tgt_event *ev;
+	struct tgt_ring *ring = &tx_ring;
+	unsigned long flags;
+	unsigned int mask = 0;
+	u32 idx;
+
+	poll_wait(file, &tgt_poll_wait, wait);
+
+	spin_lock_irqsave(&ring->tr_lock, flags);
+
+	idx = ring->tr_idx ? ring->tr_idx - 1 : TGT_MAX_EVENTS - 1;
+	ev = tgt_head_event(ring, idx);
+	if (ev->hdr.status)
+		mask |= POLLIN | POLLRDNORM;
+
+	spin_unlock_irqrestore(&ring->tr_lock, flags);
+
+	return mask;
+}
+
+static int uspace_ring_map(struct vm_area_struct *vma, unsigned long addr,
+			   struct tgt_ring *ring)
+{
+	int i, err;
+
+	for (i = 0; i < TGT_RING_PAGES; i++) {
+		struct page *page = virt_to_page(ring->tr_pages[i]);
+		err = vm_insert_page(vma, addr, page);
+		if (err)
+			return err;
+		addr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+static int tgt_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	unsigned long addr;
+	int err;
+
+	if (vma->vm_pgoff)
+		return -EINVAL;
+
+	if (vma->vm_end - vma->vm_start != TGT_RING_SIZE * 2) {
+		eprintk("mmap size must be %lu, not %lu \n",
+			TGT_RING_SIZE * 2, vma->vm_end - vma->vm_start);
+		return -EINVAL;
+	}
+
+	addr = vma->vm_start;
+	err = uspace_ring_map(vma, addr, &tx_ring);
+	if (err)
+		return err;
+	err = uspace_ring_map(vma, addr + TGT_RING_SIZE, &rx_ring);
+
+	return err;
+}
+
+static int tgt_open(struct inode *inode, struct file *file)
+{
+	tx_ring.tr_idx = rx_ring.tr_idx = 0;
+
+	return 0;
+}
+
+static struct file_operations tgt_fops = {
+	.owner		= THIS_MODULE,
+	.open		= tgt_open,
+	.poll		= tgt_poll,
+	.write		= tgt_write,
+	.mmap		= tgt_mmap,
+};
+
+static struct miscdevice tgt_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "tgt",
+	.fops = &tgt_fops,
+};
+
+static void tgt_ring_exit(struct tgt_ring *ring)
+{
+	int i;
+
+	for (i = 0; i < TGT_RING_PAGES; i++)
+		free_page(ring->tr_pages[i]);
+}
+
+static int tgt_ring_init(struct tgt_ring *ring)
+{
+	int i;
+
+	spin_lock_init(&ring->tr_lock);
+
+	for (i = 0; i < TGT_RING_PAGES; i++) {
+		ring->tr_pages[i] = get_zeroed_page(GFP_KERNEL);
+		if (!ring->tr_pages[i]) {
+			eprintk("out of memory\n");
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+void scsi_tgt_if_exit(void)
+{
+	tgt_ring_exit(&tx_ring);
+	tgt_ring_exit(&rx_ring);
+	misc_deregister(&tgt_miscdev);
+}
+
+int scsi_tgt_if_init(void)
+{
+	int err;
+
+	err = tgt_ring_init(&tx_ring);
+	if (err)
+		return err;
+
+	err = tgt_ring_init(&rx_ring);
+	if (err)
+		goto free_tx_ring;
+
+	err = misc_register(&tgt_miscdev);
+	if (err)
+		goto free_rx_ring;
+
+	return 0;
+free_rx_ring:
+	tgt_ring_exit(&rx_ring);
+free_tx_ring:
+	tgt_ring_exit(&tx_ring);
+
+	return err;
+}
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
new file mode 100644
index 0000000..46d5e70
--- /dev/null
+++ b/include/scsi/scsi_tgt_if.h
@@ -0,0 +1,90 @@
+/*
+ * SCSI target kernel/user interface
+ *
+ * Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#ifndef __SCSI_TARGET_IF_H
+#define __SCSI_TARGET_IF_H
+
+/* user -> kernel */
+#define	TGT_UEVENT_CMD_RSP	0x0001
+#define	TGT_UEVENT_TSK_MGMT_RSP	0x0002
+
+/* kernel -> user */
+#define	TGT_KEVENT_CMD_REQ	0x1001
+#define	TGT_KEVENT_CMD_DONE	0x1002
+#define	TGT_KEVENT_TSK_MGMT_REQ	0x1003
+
+struct tgt_event_hdr {
+	uint16_t version;
+	uint16_t status;
+	uint16_t type;
+	uint16_t len;
+} __attribute__ ((aligned (sizeof(uint64_t))));
+
+struct tgt_event {
+	struct tgt_event_hdr hdr;
+
+	union {
+		/* user-> kernel */
+		struct {
+			int host_no;
+			uint32_t len;
+			int result;
+			aligned_u64 uaddr;
+			uint8_t rw;
+			aligned_u64 tag;
+		} cmd_rsp;
+		struct {
+			int host_no;
+			aligned_u64 mid;
+			int result;
+		} tsk_mgmt_rsp;
+
+
+		/* kernel -> user */
+		struct {
+			int host_no;
+			uint32_t data_len;
+			uint8_t scb[16];
+			uint8_t lun[8];
+			int attribute;
+			aligned_u64 tag;
+		} cmd_req;
+		struct {
+			int host_no;
+			aligned_u64 tag;
+			int result;
+		} cmd_done;
+		struct {
+			int host_no;
+			int function;
+			aligned_u64 tag;
+			uint8_t lun[8];
+			aligned_u64 mid;
+		} tsk_mgmt_req;
+	} p;
+} __attribute__ ((aligned (sizeof(uint64_t))));
+
+#define TGT_RING_SIZE (1UL << 16)
+#define TGT_RING_PAGES (TGT_RING_SIZE >> PAGE_SHIFT)
+#define TGT_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct tgt_event))
+#define TGT_MAX_EVENTS (TGT_EVENT_PER_PAGE * TGT_RING_PAGES)
+
+#endif
-- 
1.4.3.2


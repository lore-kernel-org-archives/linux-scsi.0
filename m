From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.20 1/2] iop13xx: add base support for the imu
Date: Tue, 13 Feb 2007 09:47:10 -0700
Message-ID: <20070213164710.10432.83601.stgit@dwillia2-linux.ch.intel.com>
References: <20070213164517.10432.76264.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXBMQrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Feb 2007 11:47:32 -0500
In-Reply-To: <20070213164517.10432.76264.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@arm.linux.org.uk, James.Bottomley@HansenPartnership.com
Cc: greg.b.tucker@intel.com, linux-scsi@vger.kernel.org, linux-arm.kernel@lists.arm.linux.org.uk

From: Greg Tucker <greg.b.tucker@intel.com>

The interprocessor messaging unit supports mailbox style communication
between the two Xscale cores on iop342.
    
Changelog:
* cleaned up static functions and exports

Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/mach-iop13xx/Kconfig      |    2 
 arch/arm/mach-iop13xx/Makefile     |    1 
 arch/arm/mach-iop13xx/imu/Kconfig  |   19 ++
 arch/arm/mach-iop13xx/imu/Makefile |    3 
 arch/arm/mach-iop13xx/imu/common.c |  294 ++++++++++++++++++++++++
 arch/arm/mach-iop13xx/imu/dev.c    |  438 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-iop13xx/imu/imu.c    |   95 ++++++++
 include/asm-arm/arch-iop13xx/imu.h |  366 ++++++++++++++++++++++++++++++
 8 files changed, 1218 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-iop13xx/Kconfig b/arch/arm/mach-iop13xx/Kconfig
index 40c2d68..27c1c2c 100644
--- a/arch/arm/mach-iop13xx/Kconfig
+++ b/arch/arm/mach-iop13xx/Kconfig
@@ -16,5 +16,7 @@ config MACH_IQ81340MC
 	  Say Y here if you want to support running on the Intel IQ81340MC
 	  evaluation kit.
 
+source "arch/arm/mach-iop13xx/imu/Kconfig"
+
 endmenu
 endif
diff --git a/arch/arm/mach-iop13xx/Makefile b/arch/arm/mach-iop13xx/Makefile
index 4185e05..7937d73 100644
--- a/arch/arm/mach-iop13xx/Makefile
+++ b/arch/arm/mach-iop13xx/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_ARCH_IOP13XX) += pci.o
 obj-$(CONFIG_ARCH_IOP13XX) += io.o
 obj-$(CONFIG_MACH_IQ81340SC) += iq81340sc.o
 obj-$(CONFIG_MACH_IQ81340MC) += iq81340mc.o
+obj-$(CONFIG_IOP_IMU) += imu/
diff --git a/arch/arm/mach-iop13xx/imu/Kconfig b/arch/arm/mach-iop13xx/imu/Kconfig
new file mode 100644
index 0000000..ee49b37
--- /dev/null
+++ b/arch/arm/mach-iop13xx/imu/Kconfig
@@ -0,0 +1,19 @@
+#
+# IOP13xx IMU Support
+#
+
+menu "IOP13XX IMU Support"
+
+config IOP_IMU
+	tristate "IOP IMU support"
+	depends on EXPERIMENTAL
+	---help---
+	This includes support functions for the IMU.
+
+config IOP_IMU_DEV
+	tristate "IOP IMU char driver"
+	depends on IOP_IMU
+	---help---
+	This is a char driver that passes messages throught the IMU.
+
+endmenu
diff --git a/arch/arm/mach-iop13xx/imu/Makefile b/arch/arm/mach-iop13xx/imu/Makefile
new file mode 100644
index 0000000..e149b07
--- /dev/null
+++ b/arch/arm/mach-iop13xx/imu/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IOP_IMU)      += imu_layer.o
+obj-$(CONFIG_IOP_IMU_DEV)  += dev.o
+imu_layer-objs	:= common.o imu.o
diff --git a/arch/arm/mach-iop13xx/imu/common.c b/arch/arm/mach-iop13xx/imu/common.c
new file mode 100644
index 0000000..1f9628e
--- /dev/null
+++ b/arch/arm/mach-iop13xx/imu/common.c
@@ -0,0 +1,294 @@
+/*
+ * arch/arm/mach-iop13xx/imu/common.c
+ *
+ * Interface functions for comunication using IMU hardware on the IOP1342
+ *
+ * Copyright (C) 2005, Intel Corporation.
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
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Author: Greg Tucker <greg.b.tucker@intel.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <asm/arch/imu.h>
+
+imu_handler *imu_irq_table[NR_IMU_DOORBELLS + NR_IMU_QUEUE_IRQS];
+struct imu_queue_params imu_queue[NR_IMU_QUEUES];
+
+
+/**
+ ****************************************************************************
+ * @iop_doorbell_reg_callback
+ * @brief
+ *   Register the callback function for a particular doorbell.
+ * @param  IN: int doorbell - doorbell number
+ * @param  IN: void * callback(void) - pointer to callback function
+ * @return NONE
+ *****************************************************************************/
+int iop_doorbell_reg_callback(int doorbell, void (*callback) (int))
+{
+	if ((doorbell >= 0) && (doorbell <= IMU_DB_RQ3NE)) {
+		imu_irq_table[doorbell] = (imu_handler *) callback;
+		return 0;
+	} else
+		return 1;
+}
+
+
+/**
+ ****************************************************************************
+ * @iop_queue_init
+ * @brief
+ *   Initialize circular queue.
+ *
+ *   Sets up a circular queue with memory for the queue buffers and
+ *   callback function for received messages.  Caller must first
+ *   allocate memory of appropriate size and type for the queue.  The
+ *   queue is of fixed size (msg_size * num_items) bytes.
+ *
+ *   @todo List restrictions on the memory type (dma-able, etc.)
+ *
+ * @param  IN: int queueid - queue identifier
+ * @param  IN: void * phys_base - physical base pointer to pre-allocated memory
+ * @param  IN: void * virt_base - virtual base pointer to pre-allocated memory
+ * @param  IN: int msg_size - size of fixed messages in bytes
+ * @param  IN: int num_items - max number of items in the queue
+ * @param  IN: void * callback(int) - pointer to callback function
+ * @param  IN: void * error_callback(int) - pointer to error function
+ * @return 0: success
+ *****************************************************************************/
+int
+iop_queue_init(int queueid, void *phys_base, void *virt_base, int msg_size,
+	       int num_items, void (*rcd_callback) (int),
+	       void (*error_callback) (int))
+{
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	if (queueid > 3 || num_items > ((1 << 16) - 1))
+		return 1;
+
+	/* init send queue pointers */
+	queue_hw->sqcr = (1 << 31)	/* reset send queue get/put pointers */
+	    |num_items;		/* set size */
+	queue_hw->rqcr = (1 << 31);	/* reset receive queue get/put pointers */
+	queue_hw->sqlbar = (int)phys_base;
+	queue_hw->squbar = 0;	/* assuming 32 bit address space */
+
+	imu_queue[queueid].txbase = virt_base;
+	imu_queue[queueid].msg_size = msg_size;
+	imu_queue[queueid].items = num_items;
+	imu_queue[queueid].alloc = queue_hw->sqpg >> 16;	/* alloc=get */
+
+	/* Register callback */
+	imu_irq_table[NR_IMU_DOORBELLS - 1 +
+		      (IMU_DB_RQ0NE - IMU_DB_QUEUE_IRQ_OFF) + (queueid * 2)] =
+	    (imu_handler *) rcd_callback;
+	/* Enable receive interrupt */
+	iop_doorbell_enable(IMU_DB_RQ0NE + (queueid * 2));
+
+	return 0;
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_allocate
+ * @brief
+ *   Return pointer to next free buffer queue.
+ * @param  IN: int queueid - queue identifier
+ * @return buffer pointer to fill with message
+ *****************************************************************************/
+void *iop_queue_allocate(int queueid)
+{
+	void *ret = NULL;
+	int alloc, get, items_m1, next_alloc;
+
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	if (queueid > 3)
+		return NULL;
+
+	alloc = queue->alloc;
+	get = queue_hw->sqpg >> 16;
+	items_m1 = queue->items - 1;
+	next_alloc = (alloc == items_m1) ? 0 : alloc + 1;
+
+	if (next_alloc != get) {	/* not full */
+		ret = (void *)(queue->txbase + (queue->msg_size * alloc));
+		queue->alloc = next_alloc;
+	}
+
+	return ret;
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_postmsg
+ * @brief
+ *   Post (send) all buffers up to message identified by message pointer.
+ * @param  IN: int queueid - queue identifier
+ * @param  IN: void * msg_adr - pointer to last message to post
+ * @return NONE
+ *****************************************************************************/
+int iop_queue_postmsg(int queueid, void *msg_adr)
+{
+	int offset, items, items_m1, put, alloc, index;
+
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	offset = (int)(msg_adr - queue->txbase);
+
+	items = queue->items;
+	items_m1 = items - 1;
+
+	/* Check if it is in range for this queue */
+	if (offset < 0 || offset > (queue->msg_size * items))
+		return 1;
+
+	put = queue_hw->sqpg & 0xffff;
+	alloc = queue->alloc;
+	index = offset / queue->msg_size;
+
+	/* todo: Check if allocated? */
+	/* don't post something already posted */
+
+	if (alloc >= put) {
+		if (index < put || index >= alloc)
+			return 1;	/* already posted or not allocated */
+	} else {
+		if (index < put && index >= alloc)
+			return 1;	/* already posted or not allocated */
+	}
+
+	queue_hw->sqpg = (index == items_m1) ? 0 : index + 1;
+
+	return 0;
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_rx_not_empty
+ * @brief
+ *   Check rx queue for not empty status.
+ * @param  IN: int queueid - queue identifier
+ * @return
+ *    0: rx queue empty
+ *    other: rx queue not empty
+ *****************************************************************************/
+int iop_queue_rx_not_empty(int queueid)
+{
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	int rqpg = queue_hw->rqpg;
+	int put = rqpg & 0xffff;
+	int get = rqpg >> 16;
+	return get - put;
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_tx_not_full
+ * @brief
+ *   Check tx queue for full status
+ * @param  IN: int queueid - queue identifier
+ * @return
+ *    0: tx queue full
+ *    other: rx queue not full
+ *****************************************************************************/
+int iop_queue_tx_not_full(int queueid)
+{
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	int get = queue_hw->sqpg >> 16;
+	int next_alloc = queue->alloc + 1;
+	next_alloc = (next_alloc == queue->items) ? 0 : next_alloc;
+
+	return next_alloc - get;
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_getmsg
+ * @brief
+ *   Get next available message.
+ *
+ *   Get a pointer to the next available message in the recieve queue.
+ *   Subsequent calls will return the same value until the message is freed.
+ *
+ * @param  IN: int queueid - queue identifier
+ * @return buffer pointer to next available message
+ *****************************************************************************/
+void *iop_queue_getmsg(int queueid)
+{
+
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	int rqpg = queue_hw->rqpg;
+	void *base = queue->rxbase;
+	int put = rqpg & 0xffff;
+	int get = rqpg >> 16;
+
+	if (!base || put == get)
+		return 0;
+
+	return base + (get * queue->msg_size);
+}
+
+/**
+ ****************************************************************************
+ * @iop_queue_rxfree
+ * @brief
+ *   Free a buffer in the receive queue that has already been processed.
+ *
+ *   Free the buffer that includes msg_addr.  Also frees all prior
+ *  messages in the queue.
+ *
+ * @param  IN: int queueid - queue identifier
+ * @param  IN: void * msg_addr - pointer to data within message to free
+ * @return buffer pointer to next available message
+ *****************************************************************************/
+int iop_queue_rxfree(int queueid, void *msg_adr)
+{
+	int rq_items, offset, index;
+
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	rq_items = queue_hw->rqcr & 0xffff;
+	offset = (int)(msg_adr - queue->rxbase);
+
+	/* Check if it is in range for this queue */
+	if (offset < 0 || offset > (queue->msg_size * rq_items)) {
+		return 1;
+	}
+
+	index = (offset / queue->msg_size) + 1;
+	index = (index == rq_items) ? 0 : index;
+	queue_hw->rqpg = index << 16;	/* update get pointer */
+
+	return 0;
+}
diff --git a/arch/arm/mach-iop13xx/imu/dev.c b/arch/arm/mach-iop13xx/imu/dev.c
new file mode 100644
index 0000000..38b1d80
--- /dev/null
+++ b/arch/arm/mach-iop13xx/imu/dev.c
@@ -0,0 +1,438 @@
+/*
+ * arch/arm/mach-iop13xx/imu/iop1340-imu-dev.c
+ *
+ * Char driver for user-space access to IMU inter-core messaging.
+ *
+ * Copyright (C) 2005, Intel Corporation.
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
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Author: Greg Tucker <greg.b.tucker@intel.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/poll.h>
+#include <linux/cdev.h>
+#include <linux/jiffies.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <asm/arch/imu.h>
+
+#define MODULE_VERS "1.0"
+#define MODULE_NAME "IMUdev"
+//#define IMU_MAJOR       245
+#define IMU_MAJOR         0
+#define IMU_MAX_MINORS    4
+#define IMU_FIRST_MINOR   1
+
+#define Q_MSG_SIZE   64
+#define Q_MSG_ITEMS  16
+#define Q_PHYS_BASE  (128*1024*1024)
+#define Q_SIZE       (Q_MSG_ITEMS*Q_MSG_SIZE)
+#define MSG_HEADER_SIZE   4
+
+#define IMU_WRITE_TIMEOUT 1000
+
+struct imu_dev {
+	struct cdev cdev;
+	wait_queue_head_t rq;
+	wait_queue_head_t wq;
+	size_t rq_leftover;
+	char *rq_leftover_ptr;
+	atomic_t read_available;
+	atomic_t write_available;
+};
+
+static struct imu_dev imu[IMU_MAX_MINORS];
+static int imu_major = IMU_MAJOR;
+
+void queue_rq_callback(int queueid)
+{
+	struct imu_dev *imui = &imu[queueid];
+
+	pr_debug("queue_rq_callback %d\n", queueid);
+	wake_up_interruptible(&imui->rq);
+	iop_doorbell_disable(IMU_DB_RQ0NE + (queueid * 2));
+}
+
+void queue_wq_callback(int queueid)
+{
+	struct imu_dev *imui = &imu[queueid];
+
+	pr_debug("wq callback on not full q=%d\n", queueid);
+	wake_up_interruptible(&imui->wq);
+	iop_doorbell_disable(IMU_DB_SQ0NF + (queueid * 2));
+}
+
+extern struct imu_queue_params imu_queue[];
+
+/*
+ * init_callback only called on the first rx to map the base
+ */
+
+#define has_overlap(a,b,c,d) (((c<=a) && (d>a))||((c<b) && (d>=b))||((c>=a) && (d<=b)))
+
+void init_callback(int queueid)
+{
+	int i, qi_rxitems, err = 0;
+	struct imu_queue_params *qi;
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *qi_hw;
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	int phy_rxbase = queue_hw->rqlbar;
+	int rq_items = queue_hw->rqcr & 0xffff;
+
+	// check if overlap
+
+	for (i = 0; i < 4; i++) {
+		qi = &imu_queue[i];
+		qi_hw = (struct imu_queue *)
+		    (IMU_Q0_BASE + (i * sizeof(struct imu_queue)));
+		qi_rxitems = qi_hw->rqcr & 0xffff;
+
+		if (i != queueid &&	// check overlap with other registered rx
+		    qi->rxbase && qi->msg_size &&
+		    has_overlap(phy_rxbase,
+				phy_rxbase + (rq_items * qi->msg_size),
+				(int)qi->rxbase,
+				(int)qi->rxbase +
+				(qi_rxitems * qi->msg_size))) {
+			err = 1;
+		}
+
+		if (qi->txbase && qi->msg_size &&	// check overlap with tx queues
+		    has_overlap(phy_rxbase,
+				phy_rxbase + (rq_items * qi->msg_size),
+				(int)qi->txbase,
+				(int)qi->txbase + (qi->items * qi->msg_size))) {
+			err = 1;
+		}
+	}
+
+	if (err) {
+		printk(KERN_WARNING
+		       "overlap found in IMU rx queue request 0x%x\n",
+		       (int)phy_rxbase);
+	}
+
+	queue->rxbase = ioremap(phy_rxbase, rq_items * Q_MSG_SIZE);
+
+	// switch to regular callback and call
+	iop_doorbell_reg_callback(NR_IMU_DOORBELLS - 1 +
+				  (IMU_DB_RQ0NE - IMU_DB_QUEUE_IRQ_OFF) +
+				  (queueid * 2), queue_rq_callback);
+
+	printk
+	    ("init_callback registerd q=%d rxbase=0x%x rxphy=0x%x size=0x%x\n",
+	     queueid, (int)queue->rxbase, phy_rxbase, rq_items * Q_MSG_SIZE);
+	queue_rq_callback(queueid);
+}
+
+void error_callback(int queueid)
+{
+}
+
+static int imu_open(struct inode *inode, struct file *file)
+{
+	struct imu_dev *imui;
+	int queueid = iminor(file->f_dentry->d_inode);
+
+	imui = &imu[queueid];
+
+	switch (file->f_flags & O_ACCMODE) {
+	case O_RDWR:
+		if (!atomic_dec_and_test(&imui->read_available)) {
+			atomic_inc(&imui->read_available);
+			return -EBUSY;
+		}
+		if (!atomic_dec_and_test(&imui->write_available)) {
+			atomic_inc(&imui->write_available);
+			atomic_inc(&imui->read_available);
+			return -EBUSY;
+		}
+		break;
+	case O_WRONLY:
+		if (!atomic_dec_and_test(&imui->write_available)) {
+			atomic_inc(&imui->write_available);
+			return -EBUSY;
+		}
+		break;
+	case O_RDONLY:
+		if (!atomic_dec_and_test(&imui->read_available)) {
+			atomic_inc(&imui->read_available);
+			return -EBUSY;
+		}
+		break;
+
+	}
+	return 0;
+}
+
+static int imu_release(struct inode *inode, struct file *file)
+{
+	struct imu_dev *imui;
+	int queueid = iminor(file->f_dentry->d_inode);
+
+	imui = &imu[queueid];
+
+	switch (file->f_flags & O_ACCMODE) {
+	case O_RDWR:
+		atomic_inc(&imui->read_available);	// fall through
+	case O_WRONLY:
+		atomic_inc(&imui->write_available);
+		break;
+	case O_RDONLY:
+		atomic_inc(&imui->read_available);
+		break;
+	}
+	return 0;
+}
+
+static ssize_t
+imu_read(struct file *file, char __user * buf, size_t count, loff_t * f_pos)
+{
+	struct imu_dev *imui;
+	char *dat;
+	int queueid = iminor(file->f_dentry->d_inode);
+
+	imui = &imu[queueid];
+
+	pr_debug("imu_read count=%d ", count);
+
+	while (1) {
+		if (imui->rq_leftover) {
+			pr_debug("%d leftover ", imui->rq_leftover);
+			count = min(count, imui->rq_leftover);
+			if (copy_to_user(buf, imui->rq_leftover_ptr, count))
+				return -EFAULT;
+			imui->rq_leftover -= count;
+			pr_debug(" %d left \n", imui->rq_leftover);
+			if (imui->rq_leftover == 0)
+				iop_queue_rxfree(queueid,
+						 imui->rq_leftover_ptr);
+			imui->rq_leftover_ptr += count;
+			return count;
+		}
+
+		while (!iop_queue_rx_not_empty(queueid)) {
+			DECLARE_WAITQUEUE(wait, current);
+
+			if (file->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			pr_debug("imu_read: empty going to sleep\n");
+
+			add_wait_queue(&imui->rq, &wait);
+			set_current_state(TASK_INTERRUPTIBLE);
+			iop_doorbell_enable(IMU_DB_RQ0NE + (queueid * 2));
+			schedule_timeout(IMU_WRITE_TIMEOUT);
+
+			remove_wait_queue(&imui->rq, &wait);
+			if (signal_pending(current)) {
+				return -ERESTARTSYS;
+			}
+		}
+
+		// new message
+		dat = iop_queue_getmsg(queueid);
+
+		pr_debug("imu_read: got a new message at 0x%x\n", (int)dat);
+		if (NULL == dat)
+			return -EFAULT;
+
+#if MSG_HEADER_SIZE > 0
+		imui->rq_leftover = *((int *)dat);
+#else
+		imui->rq_leftover = 4;
+#endif
+		if (imui->rq_leftover > Q_MSG_SIZE)
+			imui->rq_leftover = 0;
+
+		imui->rq_leftover_ptr = dat + MSG_HEADER_SIZE;
+
+		pr_debug("imu_read: msg size=%d\n", imui->rq_leftover);
+		if (!imui->rq_leftover)
+			iop_queue_rxfree(queueid, imui->rq_leftover_ptr);
+	}
+
+}
+static ssize_t
+imu_write(struct file *file, const char __user * buf, size_t count,
+	  loff_t * f_pos)
+{
+	void *msg;
+	struct imu_dev *imui;
+	int queueid = iminor(file->f_dentry->d_inode);
+
+	imui = &imu[queueid];
+
+	count = min(count, (size_t) (Q_MSG_SIZE - MSG_HEADER_SIZE));
+
+	while (NULL == (msg = iop_queue_allocate(queueid))) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		pr_debug("imu_write sleeping\n");
+
+		add_wait_queue(&imui->wq, &wait);
+		set_current_state(TASK_INTERRUPTIBLE);
+		iop_doorbell_enable(IMU_DB_SQ0NF + (queueid * 2));
+		schedule_timeout(IMU_WRITE_TIMEOUT);
+
+		remove_wait_queue(&imui->wq, &wait);
+		if (signal_pending(current)) {
+			return -ERESTARTSYS;
+		}
+
+	}
+
+	if (copy_from_user(msg + MSG_HEADER_SIZE, buf, count))
+		return -EFAULT;
+#if  MSG_HEADER_SIZE > 0
+	*((int *)msg) = count;
+#endif
+
+	iop_queue_postmsg(queueid, msg);
+
+	pr_debug("imu_write sent q=%d count=%d msg=0x%x\n", queueid, count,
+		 (int)msg);
+	return count;
+}
+
+static unsigned int imu_poll(struct file *file, poll_table * wait)
+{
+	struct imu_dev *imui;
+	unsigned int mask = 0;
+	int queueid = iminor(file->f_dentry->d_inode);
+
+	imui = &imu[queueid];
+	poll_wait(file, &imui->rq, wait);
+	poll_wait(file, &imui->wq, wait);
+
+	if (iop_queue_rx_not_empty(queueid))
+		mask |= POLLIN | POLLRDNORM;
+	if (iop_queue_tx_not_full(queueid))
+		mask |= POLLOUT | POLLWRNORM;
+
+	return mask;
+}
+
+static struct file_operations imu_fops = {
+	.owner = THIS_MODULE,
+	.read = imu_read,
+	.write = imu_write,
+	.poll = imu_poll,
+	.open = imu_open,
+	.release = imu_release,
+};
+
+static int __init imu_dev_init(void)
+{
+	dev_t dev;
+	// struct class_simple *imu_class;
+	int err, i;
+	char *queue_base;
+
+	if (imu_major) {
+		dev = MKDEV(imu_major, 0);
+		err = register_chrdev_region(dev, IMU_MAX_MINORS, "imu");
+	} else {
+		err = alloc_chrdev_region(&dev, IMU_FIRST_MINOR,
+					  IMU_MAX_MINORS, "imu");
+		imu_major = MAJOR(dev);
+	}
+	if (err < 0) {
+		printk(KERN_WARNING "imu: can't get major %d\n", imu_major);
+		return err;
+	}
+	//todo: update imu_class = class_simple_create(THIS_MODULE, "imu");
+
+	for (i = IMU_FIRST_MINOR; i < IMU_MAX_MINORS; i++) {
+		cdev_init(&imu[i].cdev, &imu_fops);
+		if (cdev_add(&imu[i].cdev, MKDEV(imu_major, i), 1)) {
+			printk(KERN_WARNING "Error cdev_add imu%i\n", i);
+			continue;
+		}
+
+		imu[i].rq_leftover = 0;
+		atomic_set(&imu[i].read_available, 1);
+		atomic_set(&imu[i].write_available, 1);
+		init_waitqueue_head(&imu[i].rq);
+		init_waitqueue_head(&imu[i].wq);
+		imu_queue[i].rxbase = 0;
+
+		queue_base = ioremap(Q_PHYS_BASE + (i * Q_SIZE), Q_SIZE);
+		// todo: see about changing to one of following
+		// non-shared device tex.cb = 0x010.00
+		// shared device     tex.cb = 0x001.01
+
+		err = iop_queue_init(i,
+				     (void *)Q_PHYS_BASE + (i * Q_SIZE),
+				     queue_base,
+				     Q_MSG_SIZE,
+				     Q_MSG_ITEMS,
+				     init_callback, error_callback);
+		if (err) {
+			printk(KERN_WARNING "could not init imu queue %d\n", i);
+			continue;
+		}
+		iop_doorbell_reg_callback(NR_IMU_DOORBELLS - 1 +
+					  (IMU_DB_SQ0NF -
+					   IMU_DB_QUEUE_IRQ_OFF) + (i * 2),
+					  queue_wq_callback);
+		printk(KERN_INFO
+		       "IMU Queue %d initialized major=%d minor=%d base=0x%x\n",
+		       i, imu_major, i, (int)queue_base);
+
+	}
+
+	return 0;
+}
+
+static void __exit imu_dev_cleanup(void)
+{
+	int i;
+
+	for (i = IMU_FIRST_MINOR; i < IMU_MAX_MINORS; i++) {
+		cdev_del(&imu[i].cdev);
+		iop_doorbell_disable(IMU_DB_RQ0NE + (i * 2));
+		iop_doorbell_disable(IMU_DB_SQ0NF + (i * 2));
+		iounmap(imu_queue[i].txbase);
+		if (imu_queue[i].rxbase) {
+			iounmap(imu_queue[i].rxbase);
+			imu_queue[i].rxbase = 0;
+		}
+	}
+
+	//todo: update  class_simple_device_remove(MKDEV(imu_major, 0));
+	unregister_chrdev_region(MKDEV(imu_major, 0), IMU_MAX_MINORS);
+
+	printk(KERN_INFO "%s driver ver %s removed\n",
+	       MODULE_NAME, MODULE_VERS);
+}
+
+module_init(imu_dev_init);
+module_exit(imu_dev_cleanup);
+
+MODULE_AUTHOR("Greg Tucker");
+MODULE_DESCRIPTION("IMU dev interface");
diff --git a/arch/arm/mach-iop13xx/imu/imu.c b/arch/arm/mach-iop13xx/imu/imu.c
new file mode 100644
index 0000000..690fae8
--- /dev/null
+++ b/arch/arm/mach-iop13xx/imu/imu.c
@@ -0,0 +1,95 @@
+/*
+ * arch/arm/mach-iop13xx/imu/iop1340-imu.c
+ *
+ * Support for IMU communication for the Intel IOP1340 chipset
+ *
+ * Copyright (C) 2005, Intel Corporation.
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
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Author: Greg Tucker <greg.b.tucker@intel.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <asm/arch/imu.h>
+
+extern imu_handler *imu_irq_table[];
+extern struct imu_queue_params imu_queue[];
+
+static irqreturn_t imu_interrupt(int irq, void *dev_id)
+{
+	unsigned int doorbell, queue;
+	unsigned int dbcr = *(volatile int *)IMU_DBCR;
+
+	pr_debug("got imu interrupt. IMU_DBCR=0x%x\n", dbcr);
+
+	do {
+		doorbell = dbcr >> 28;
+		queue = (dbcr >> 24) & 0xf;
+
+		if (doorbell != 0xf && imu_irq_table[doorbell]) {
+			imu_irq_table[doorbell] (doorbell);
+			*(volatile int *)IMU_DBCR = 1 << doorbell;	// clear status
+		}
+
+		if (queue != 0xf
+		    && imu_irq_table[(NR_IMU_DOORBELLS - 1) + queue])
+			imu_irq_table[(NR_IMU_DOORBELLS - 1) +
+				      queue] (queue / 2);
+
+		dbcr = *(volatile int *)IMU_DBCR;
+
+	} while ((dbcr >> 24) != 0xff);
+
+	return IRQ_HANDLED;
+}
+
+static int __init iop_imu_init(void)
+{
+	int i, err;
+
+	for (i = 0; i < NR_IMU_DOORBELLS + NR_IMU_QUEUE_IRQS; i++)
+		imu_irq_table[i] = 0;
+
+	err = request_irq(IRQ_IOP13XX_IMU, imu_interrupt,
+			  IRQF_DISABLED, "imu interrupt", NULL);
+
+	printk(KERN_INFO "IOP 8134x IMU driver\n");
+	return err;
+}
+
+static void __exit iop_imu_exit(void)
+{
+	free_irq(IRQ_IOP13XX_IMU, NULL);
+	return;
+}
+
+EXPORT_SYMBOL(iop_doorbell_reg_callback);
+EXPORT_SYMBOL(iop_queue_init);
+EXPORT_SYMBOL(iop_queue_allocate);
+EXPORT_SYMBOL(iop_queue_postmsg);
+EXPORT_SYMBOL(iop_queue_getmsg);
+EXPORT_SYMBOL(iop_queue_rxfree);
+EXPORT_SYMBOL(iop_queue_rx_not_empty);
+EXPORT_SYMBOL(iop_queue_tx_not_full);
+EXPORT_SYMBOL(imu_queue);
+
+module_init(iop_imu_init);
+module_exit(iop_imu_exit);
+
+MODULE_AUTHOR("Greg Tucker");
+MODULE_DESCRIPTION("IMU interface");
diff --git a/include/asm-arm/arch-iop13xx/imu.h b/include/asm-arm/arch-iop13xx/imu.h
new file mode 100644
index 0000000..5346bd9
--- /dev/null
+++ b/include/asm-arm/arch-iop13xx/imu.h
@@ -0,0 +1,366 @@
+/*
+ * include/asm-arm/arch-iop13xx/iop1340-imu.h
+ *
+ * IMU hardware support on IOP342
+ *
+ * Copyright (C) 2005, Intel Corporation.
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
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Author: Greg Tucker <greg.b.tucker@intel.com>
+ *
+ */
+
+#ifndef IOP34X_H
+#define IOP34X_H
+
+#include <asm/arch/iop13xx.h>
+
+typedef int imu_handler(int);
+
+
+int iop_queue_init(int queueid, void *phys_base, void *vert_base,
+		   int msg_size, int num_items,
+		   void (*rcd_callback) (int), void (*error_callback) (int));
+void *iop_queue_allocate(int queueid);
+int iop_queue_postmsg(int queueid, void *msg_adr);
+void *iop_queue_getmsg(int queueid);
+int iop_queue_rxfree(int queueid, void *msg_adr);
+int iop_queue_rx_not_empty(int queueid);
+int iop_queue_tx_not_full(int queueid);
+int iop_doorbell_reg_callback(int doorbell, void (*callback) (int));
+
+/* --------------------------------------------------------------------------
+ * IMU/IMM registers
+ */
+
+/* Reset cause status - RCSR */
+
+#define RCSR_READ()  \
+   ({unsigned _val_; asm volatile("mrc\tp6, 0, %0, c0, c1, 0" : "=r" (_val_));_val_;})
+#define RCSR_MU_RESET       (1<<21)
+#define RCSR_TMPI3_RESET    (1<<18)
+#define RCSR_TMPI2_RESET    (1<<15)
+#define RCSR_TMPI1_RESET    (1<<12)
+#define RCSR_TMPI0_RESET    (1<<9)
+#define RCSR_WATCHDOG_RESET (1<<5)
+#define RCSR_TARGETED_RESET (1<<4)
+#define RCSR_ID_RESET_MASK  (0xf)
+#define RCSR_SYSTEM_RESET_MASK (RCSR_MU_RESET | RCSR_TARGETED_RESET | RCSR_TMPI3_RESET | \
+				RCSR_TMPI2_RESET | RCSR_TMPI1_RESET | RCSR_TMPI0_RESET | \
+				RCSR_WATCHDOG_RESET | RCSR_TARGETED_RESET)
+
+/* #define is_sys_reset() ((RCSR_READ() & RCSR_SYSTEM_RESET_MASK) == 0)  currently  not working in simulator */
+#define is_sys_reset() 1
+
+/* Software Interrupt Generation Register - SINTGENR */
+
+#define SINTGENR_READ()  \
+   ({  unsigned _val_;asm volatile("mrc\tp6, 0, %0, c1, c1, 0" : "=r" (_val_));_val_;})
+#define SINTGENR_WRITE(val) \
+   ({ asm volatile("mcr\tp6, 0, %0, c1, c1, 0" : : "r" (val)); })
+
+/* Targeted Reset Register - TARRSTR */
+
+# define TARRSTR_WRITE(val) \
+   ({ asm volatile("mcr\tp6, 0, %0, c2, c1, 0" : : "r" (val)); })
+
+#ifdef linux
+# define IMU_BASE    IOP13XX_PMMR_VIRT_MEM_BASE
+#else
+# define IMU_BASE    0xffd80000
+#endif
+
+/* IMU doorbell registers */
+
+#define IMU_DBCR   (IMU_BASE+0xa00)
+#define IMU_DBER   (IMU_BASE+0xa04)
+#define IMU_DBAR   (IMU_BASE+0xa10)
+#define IMU_DBEOR  (IMU_BASE+0xa14)
+#define NR_IMU_DOORBELLS   14
+
+/* Conventions on doorbell use */
+
+#define IMU_RESET_DOORBELL  3
+
+/* IMU send queue */
+
+#define IMU_Q0_BASE (IMU_BASE+0xa20)
+#define IMU_Q1_BASE (IMU_BASE+0xa40)
+#define IMU_Q2_BASE (IMU_BASE+0xa60)
+#define IMU_Q3_BASE (IMU_BASE+0xa80)
+
+#define IMU_SQPG0    (IMU_Q0_BASE+0x0)
+#define IMU_SQCR0    (IMU_Q0_BASE+0x4)
+#define IMU_SQLBAR0  (IMU_Q0_BASE+0x8)
+#define IMU_SQUBAR0  (IMU_Q0_BASE+0xc)
+#define IMU_RQPG0    (IMU_Q0_BASE+0x10)
+#define IMU_RQCR0    (IMU_Q0_BASE+0x14)
+#define IMU_RQLBAR0  (IMU_Q0_BASE+0x18)
+#define IMU_RQUBAR0  (IMU_Q0_BASE+0x1c)
+
+#define IMU_SQPG1    (IMU_Q1_BASE+0x0)
+#define IMU_SQCR1    (IMU_Q1_BASE+0x4)
+#define IMU_SQLBAR1  (IMU_Q1_BASE+0x8)
+#define IMU_SQUBAR1  (IMU_Q1_BASE+0xc)
+#define IMU_RQPG1    (IMU_Q1_BASE+0x10)
+#define IMU_RQCR1    (IMU_Q1_BASE+0x14)
+#define IMU_RQLBAR1  (IMU_Q1_BASE+0x18)
+#define IMU_RQUBAR1  (IMU_Q1_BASE+0x1c)
+
+#define IMU_SQPG2    (IMU_Q2_BASE+0x0)
+#define IMU_SQCR2    (IMU_Q2_BASE+0x4)
+#define IMU_SQLBAR2  (IMU_Q2_BASE+0x8)
+#define IMU_SQUBAR2  (IMU_Q2_BASE+0xc)
+#define IMU_RQPG2    (IMU_Q2_BASE+0x10)
+#define IMU_RQCR2    (IMU_Q2_BASE+0x14)
+#define IMU_RQLBAR2  (IMU_Q2_BASE+0x18)
+#define IMU_RQUBAR2  (IMU_Q2_BASE+0x1c)
+
+#define IMU_SQPG3    (IMU_Q3_BASE+0x0)
+#define IMU_SQCR3    (IMU_Q3_BASE+0x4)
+#define IMU_SQLBAR3  (IMU_Q3_BASE+0x8)
+#define IMU_SQUBAR3  (IMU_Q3_BASE+0xc)
+#define IMU_RQPG3    (IMU_Q3_BASE+0x10)
+#define IMU_RQCR3    (IMU_Q3_BASE+0x14)
+#define IMU_RQLBAR3  (IMU_Q3_BASE+0x18)
+#define IMU_RQUBAR3  (IMU_Q3_BASE+0x1c)
+#define NR_IMU_QUEUES       3
+
+/* IMU queue interrupts */
+
+#define IMU_DB_SQ0NF 16
+#define IMU_DB_RQ0NE 17
+#define IMU_DB_SQ1NF 18
+#define IMU_DB_RQ1NE 19
+#define IMU_DB_SQ2NF 20
+#define IMU_DB_RQ2NE 21
+#define IMU_DB_SQ3NF 22
+#define IMU_DB_RQ3NE 23
+#define IMU_DB_QUEUE_IRQ_OFF 16
+#define NR_IMU_QUEUE_IRQS     8
+
+#ifndef __ASSEMBLER__
+struct imu_queue {
+	unsigned int sqpg;	/* Send queue put/get register */
+	unsigned int sqcr;	/* Send queue control register */
+	unsigned int sqlbar;	/* Send queue lower base address reg */
+	unsigned int squbar;	/* Send queue upper base address reg */
+	unsigned int rqpg;	/* Receive queue put/get register */
+	unsigned int rqcr;	/* Receive queue control register */
+	unsigned int rqlbar;	/* Receive queue lower base address reg */
+	unsigned int rqubar;	/* Receive queue upper base address reg */
+};
+
+struct imu_queue_params {
+	void *txbase;
+	void *rxbase;
+	int alloc;
+	int msg_size;
+	int items;
+};
+#endif
+
+/* Test and set semaphore registers */
+
+#define IMU_TSR_BASE (IMU_BASE+0xb00)
+#define IMU_TSR(x)   ((volatile char*)(IMU_TSR_BASE+x))
+
+/* Some conventions on the semaphores */
+
+#define HW_MUTEX_FLASH_READ_CORE0 0
+#define HW_MUTEX_FLASH_READ_CORE1 1
+
+/**
+ ****************************************************************************
+ * @iop_doorbell_ring
+ * @brief
+ *   Ring specified hw doorbell.
+ *
+ *   Will cause an interrupt on the other processor if enabled.
+ *
+ * @param IN: int doorbell - doorbell number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_ring(int doorbell)
+{
+	*((volatile int *)IMU_DBAR) = (1 << doorbell);
+}
+
+/**
+ ****************************************************************************
+ * @iop_wait_on_doorbell
+ * @brief
+ *   Spin until doorbell asserted.
+ * @param  IN: int doorbell - doorbell number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_wait_on_doorbell(int doorbell)
+{
+	while (0 == (*((volatile int *)IMU_DBCR) & (1 << doorbell))) ;
+}
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_clear_status
+ * @brief
+ *   Clear doorbell status bit so future doorbells can interrupt.
+ * @param  IN: int doorbell - doorbell number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_clear_status(int doorbell)
+{
+	*((volatile int *)IMU_DBCR) = (1 << doorbell) & ((1 << 16) - 1);
+}
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_check_status
+ * @brief
+ *   Check if doorbell is active.
+ * @param  IN: int doorbell - doorbell number
+ * @return
+ *   0: doorbell not active
+ *   other: doorbell active
+ *****************************************************************************/
+static inline int iop_doorbell_check_status(int doorbell)
+{
+	return *((volatile int *)IMU_DBCR) & (1 << doorbell);
+}
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_enable
+ * @brief
+ *   Enable this doorbell to interrupt processor.
+ * @param  IN: int doorbell - doorbell number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_enable(int doorbell)
+{
+	*((volatile int *)IMU_DBER) |= (1 << doorbell);
+}
+
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_disable
+ * @brief
+ *   Disable particular doorbell.
+ * @param  IN: int doorbell - doorbell number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_disable(int doorbell)
+{
+	*((volatile int *)IMU_DBER) &= ~(1 << doorbell);
+}
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_mask
+ * @brief
+ *   Mask/Disable doorbells corresponding to mask.
+ * @param  IN: int mask - vector of doorbells to disable
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_mask(int mask)
+{
+	*((volatile int *)IMU_DBER) &= ~(mask);
+}
+
+/**
+ ******************************************************************************
+ * @iop_doorbell_unmask
+ * @brief
+ *   Unmask/Enable doorbells corresponding to mask.
+ * @param  IN: int mask - vector of doorbells to enable
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_doorbell_unmask(int mask)
+{
+	*((volatile int *)IMU_DBER) &= mask;
+}
+
+/**
+ ******************************************************************************
+ * @iop_mutex_lock
+ * @brief
+ *   Block until mutex is granted.
+ *
+ *   Checks if current core has been granted access to the hw mutex.
+ *   Does not check if it's the current thread that has access or
+ *   another thread on the same processor.  Only binary mutex is
+ *   supported.
+ *
+ * @param  IN: mutex - mutex number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_mutex_lock(int mutex)
+{
+	int trymutex = *IMU_TSR(mutex);
+	int corenum = (1 << iop13xx_cpu_id());
+
+	while (trymutex != 0 && trymutex != corenum) {
+		trymutex = *IMU_TSR(mutex);
+	}
+}
+
+/**
+ ****************************************************************************
+ * @iop_mutex_trylock
+ * @brief
+ *   Non-blocking attempt to get mutex.
+ *
+ *   Checks if current core has been granted access to the hw mutex.
+ *   Does not check if it's the current thread that has access or
+ *   another thread on the same processor.  Only binary mutex is
+ *   supported.
+ *
+ * @param IN: int mutex - mutex number
+ * @return
+ *   0: success
+ *   1: other core has lock
+ *****************************************************************************/
+static inline int iop_mutex_trylock(int mutex)
+{
+	int trymutex = *IMU_TSR(mutex);
+	int coreid = iop13xx_cpu_id();
+
+	if (trymutex == 0 || (trymutex ^ (1 << coreid)) == 0)
+		return 0;
+	else
+		return 1;
+}
+
+/**
+ ****************************************************************************
+ * @iop_mutex_unlock
+ * @brief
+ *   Unlock/free the given mutex.
+ *
+ *   Does not first check if the mutex is locked.  Assumes that the
+ *   calling thread ownes the mutex.  Currently only binary mutex is
+ *   supported so does not keep a lock count.
+ *
+ * @param  IN: int mutex - mutex number
+ * @return NONE
+ *****************************************************************************/
+static inline void iop_mutex_unlock(int mutex)
+{
+	/* assert(iop_mutex_trylock(mutex)); */
+	*IMU_TSR(mutex) = 0x0;
+}
+
+
+#endif				/* IOP34X_H */

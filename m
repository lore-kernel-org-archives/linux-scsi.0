From: jeykholt@cisco.com
Subject: [RFC][PATCH 1/6] fnic: add main file with module infrastructure, etc.
Date: Fri, 22 Aug 2008 19:52:11 -0700
Message-ID: <20080823025211.13569.94965.stgit@feynman.nuovasystems.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58506 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYHWCwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 22:52:18 -0400
In-Reply-To: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jre@nuovasystems.com, ajoglekar@nuovasystems.com

fnic: add main file with module infrastructure, etc.

fnic_main.c includes the module load and unload, PCI device probe,
SCSI-ML registration, scsi_transport_fc functions, and libfc template.
Also includes stats and link notification.

fnic.h has the fnic structure definition and function prototypes..

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  233 ++++++++++
 drivers/scsi/fnic/fnic_main.c |  918 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1151 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic.h
 create mode 100644 drivers/scsi/fnic/fnic_main.c


diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
new file mode 100644
index 0000000..10c29d0
--- /dev/null
+++ b/drivers/scsi/fnic/fnic.h
@@ -0,0 +1,233 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef _FNIC_H_
+#define _FNIC_H_
+
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/libfc/libfc.h>
+#include "fnic_io.h"
+#include "fnic_res.h"
+#include "vnic_dev.h"
+#include "vnic_wq.h"
+#include "vnic_rq.h"
+#include "vnic_cq.h"
+#include "vnic_wq_copy.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "vnic_scsi.h"
+
+#define DRV_NAME		"fnic"
+#define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
+#define DRV_VERSION		"0.01"
+#define PFX			DRV_NAME ": "
+#define DFX                     DRV_NAME "%d: "
+
+#define vnic_fc_config  vnic_scsi_config
+
+#define DESC_CLEAN_LOW_WATERMARK 8
+#define FNIC_MAX_IO_REQ		2048		/* scsi_cmnd tag map entries */
+#define	FNIC_IO_LOCKS		32		/* I/O locks: power of 2 */
+#define FNIC_DFLT_QUEUE_DEPTH	32
+#define	FNIC_STATS_RATE_LIMIT	4		/* max stats requests per sec */
+
+/*
+ * Tag bits used for special requests.
+ */
+#define FNIC_TAG_ABORT		BIT(30)		/* tag bit indicating abort */
+#define FNIC_TAG_DEV_RST	BIT(29)		/* indicates device reset */
+#define FNIC_TAG_MASK		(BIT(24) - 1)	/* mask for lookup */
+
+#define FNIC_LUN_RESET_TIMEOUT	     10000	/* mSec */
+#define FNIC_HOST_RESET_TIMEOUT	     10000	/* mSec */
+#define FNIC_RMDEVICE_TIMEOUT        1000       /* mSec */
+
+#define	FNIC_MAX_LUN            1023
+#define FNIC_MAX_FCP_TARGET     256
+
+extern const char *fnic_state_str[];
+
+enum fnic_intx_intr_index {
+	FNIC_INTX_WQ_RQ_COPYWQ,
+	FNIC_INTX_ERR,
+	FNIC_INTX_NOTIFY,
+	FNIC_INTX_INTR_MAX,
+};
+
+enum fnic_msix_intr_index {
+	FNIC_MSIX_RQ,
+	FNIC_MSIX_WQ,
+	FNIC_MSIX_WQ_COPY,
+	FNIC_MSIX_ERR_NOTIFY,
+	FNIC_MSIX_INTR_MAX,
+};
+
+struct fnic_msix_entry {
+	int requested;
+	char devname[IFNAMSIZ];
+	irqreturn_t (*isr)(int, void *);
+	void *devid;
+};
+
+enum fnic_state {
+	FNIC_IN_FC_MODE = 0,
+	FNIC_IN_FC_TRANS_ETH_MODE,
+	FNIC_IN_ETH_MODE,
+	FNIC_IN_ETH_TRANS_FC_MODE,
+};
+
+#define FNIC_WQ_COPY_MAX 1
+#define FNIC_WQ_MAX 1
+#define FNIC_RQ_MAX 1
+#define FNIC_CQ_MAX (FNIC_WQ_COPY_MAX + FNIC_WQ_MAX + FNIC_RQ_MAX)
+
+/* Per-instance private data structure */
+struct fnic {
+	struct fc_lport *lport;
+	struct vnic_dev_bar bar0;
+
+	struct msix_entry msix_entry[FNIC_MSIX_INTR_MAX];
+	struct fnic_msix_entry msix[FNIC_MSIX_INTR_MAX];
+
+	struct vnic_stats *stats;
+	unsigned long stats_time;	/* time of stats update */
+	struct vnic_nic_cfg *nic_cfg;
+	char name[IFNAMSIZ];
+	u32 fnic_no;
+	struct timer_list notify_timer; /* used for MSI interrupts */
+
+	unsigned int err_intr_offset;
+	unsigned int link_intr_offset;
+
+	unsigned int wq_count;
+	unsigned int cq_count;
+
+	u32 fcoui_mode:1;		/* use fcoui address*/
+	u32 vlan_hw_insert:1;	        /* let hw insert the tag */
+
+	struct completion *remove_wait; /* device remove thread blocks */
+	struct completion *reset_wait;  /* host reset thread blocks */
+
+	struct fc_frame *flogi;
+	struct fc_frame *flogi_resp;
+	u16 flogi_oxid;
+	unsigned long s_id;
+	enum fnic_state state;
+	spinlock_t fnic_lock;
+
+	u16 vlan_id;	                /* VLAN tag including priority */
+	u8 mac_addr[ETH_ALEN];
+	u8 dest_addr[ETH_ALEN];
+	u8 data_src_addr[ETH_ALEN];
+	u64 fcp_input_bytes;		/* internal statistic */
+	u64 fcp_output_bytes;		/* internal statistic */
+
+	struct pci_dev *pdev;
+	struct vnic_fc_config config;
+	struct vnic_dev *vdev;
+	unsigned int raw_wq_count;
+	unsigned int wq_copy_count;
+	unsigned int rq_count;
+	int fw_ack_index[FNIC_WQ_COPY_MAX];
+	unsigned short fw_ack_recd[FNIC_WQ_COPY_MAX];
+	unsigned short wq_copy_desc_low[FNIC_WQ_COPY_MAX];
+	unsigned int intr_count;
+	u32 __iomem *legacy_pba;
+	mempool_t *io_req_pool;
+	mempool_t *io_sgl_pool[FNIC_SGL_NUM_CACHES];
+	spinlock_t io_req_lock[FNIC_IO_LOCKS];	/* locks for scsi cmnds */
+
+	/* copy work queue cache line section */
+	____cacheline_aligned struct vnic_wq_copy wq_copy[FNIC_WQ_COPY_MAX];
+	/* completion queue cache line section */
+	____cacheline_aligned struct vnic_cq cq[FNIC_CQ_MAX];
+
+	spinlock_t wq_copy_lock[FNIC_WQ_COPY_MAX];
+
+	/* work queue cache line section */
+	____cacheline_aligned struct vnic_wq wq[FNIC_WQ_MAX];
+	spinlock_t wq_lock[FNIC_WQ_MAX];
+
+	/* receive queue cache line section */
+	____cacheline_aligned struct vnic_rq rq[FNIC_RQ_MAX];
+
+	/* interrupt resource cache line section */
+	____cacheline_aligned struct vnic_intr intr[FNIC_MSIX_INTR_MAX];
+};
+
+/* This is used to pass incoming frames, link notifications from ISR
+ * to fnic thread
+ */
+enum fnic_thread_event_type {
+	EV_TYPE_LINK_DOWN = 0,
+	EV_TYPE_LINK_UP,
+	EV_TYPE_FRAME,
+};
+
+/* ISR allocates and inserts an event into a list.
+ * Fnic thread processes the event
+ */
+struct fnic_event {
+	/* list head has to the first field*/
+	struct list_head list;
+	struct fc_frame *fp;
+	struct fnic *fnic;
+	enum   fnic_thread_event_type ev_type;
+	u32    is_flogi_resp_frame:1;
+};
+
+/* Fnic Thread for handling FCS Rx Frames*/
+extern struct task_struct *fnic_thread;
+extern struct list_head   fnic_eventlist;
+extern spinlock_t         fnic_eventlist_lock;
+extern struct kmem_cache   *fnic_ev_cache;
+extern struct kmem_cache   *fnic_fc_frame_cache;
+extern struct device_attribute *fnic_attrs[];
+
+void fnic_clear_intr_mode(struct fnic *fnic);
+int fnic_set_intr_mode(struct fnic *fnic);
+void fnic_free_intr(struct fnic *fnic);
+int fnic_request_intr(struct fnic *fnic);
+
+int fnic_send(struct fc_lport *, struct fc_frame *);
+int fnic_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+int fnic_abort_cmd(struct scsi_cmnd *);
+int fnic_device_reset(struct scsi_cmnd *);
+int fnic_host_reset(struct scsi_cmnd *);
+int fnic_reset(struct Scsi_Host *);
+void fnic_scsi_cleanup(struct fc_lport *);
+void fnic_scsi_abort_io(struct fc_lport *);
+int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int);
+int fnic_wq_cmpl_handler(struct fnic *fnic, int);
+int fnic_flogi_reg_handler(struct fnic *fnic);
+void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
+				  struct fcpio_host_req *desc);
+int fnic_fw_reset_handler(struct fnic *fnic);
+
+void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf);
+
+int fnic_fc_thread(void *arg);
+int fnic_rq_cmpl_handler(struct fnic *fnic, int);
+int fnic_alloc_rq_frame(struct vnic_rq *rq);
+void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf);
+
+void fnic_log_q_error(struct fnic *fnic);
+void fnic_notify_check(struct fnic *fnic);
+int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp);
+
+#endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
new file mode 100644
index 0000000..56467be
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -0,0 +1,918 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/kthread.h>
+#include <asm/atomic.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/libfc/libfc.h>
+#include <scsi/libfc/fc_frame.h>
+#include "vnic_dev.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "fnic_io.h"
+#include "fnic.h"
+
+/* timer to poll notification area for events. Used in case of MSI
+ * interrupts being used by the device
+ */
+#define FNIC_NOTIFY_TIMER_PERIOD	(2 * HZ)
+
+/* Cache to pass events from ISR to fnic Thread */
+struct kmem_cache         *fnic_ev_cache;
+
+static struct kmem_cache *fnic_sgl_cache[FNIC_SGL_NUM_CACHES];
+static struct kmem_cache *fnic_io_req_cache;
+static atomic_t fnic_no;
+
+/* Supported devices by fnic module */
+static struct pci_device_id fnic_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_FNIC) },
+	{ 0, }	/* end of table */
+};
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_AUTHOR("Abhijeet Joglekar <abjoglek@cisco.com>, "
+	      "Joseph R. Eykholt <jeykholt@cisco.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, fnic_id_table);
+
+/* Exported to LibFC layer */
+static struct libfc_function_template fnic_transport_template = {
+	.frame_send = fnic_send,
+	.scsi_abort_io = fnic_scsi_abort_io,
+	.scsi_cleanup = fnic_scsi_cleanup
+};
+
+static int fnic_slave_alloc(struct scsi_device *sdev)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+
+	sdev->tagged_supported = 1;
+
+	if (!rport || fc_remote_port_chkready(rport))
+		return -ENXIO;
+
+	scsi_activate_tcq(sdev, FNIC_DFLT_QUEUE_DEPTH);
+
+	return 0;
+}
+
+static struct scsi_host_template fnic_host_template = {
+	.module = THIS_MODULE,
+	.name = DRV_NAME,
+	.queuecommand = fnic_queuecommand,
+	.eh_abort_handler = fnic_abort_cmd,
+	.eh_device_reset_handler = fnic_device_reset,
+	.eh_host_reset_handler = fnic_host_reset,
+	.slave_alloc = fnic_slave_alloc,
+	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_type = fc_change_queue_type,
+	.this_id = -1,
+	.cmd_per_lun = 3,
+	.can_queue = FNIC_MAX_IO_REQ,
+	.use_clustering = ENABLE_CLUSTERING,
+	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
+	.max_sectors = 0xffff,
+	.shost_attrs = fnic_attrs,
+};
+
+static struct scsi_transport_template *fnic_fc_transport;
+static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *);
+
+static struct fc_function_template fnic_fc_functions = {
+
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+
+	.get_host_port_id = fc_get_host_port_id,
+	.show_host_port_id = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.get_host_port_type = fc_get_host_port_type,
+	.show_host_port_type = 1,
+	.show_host_symbolic_name = 1,
+
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.get_host_fabric_name = fc_get_host_fabric_name,
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+
+	.issue_fc_host_lip = fnic_reset,
+	.get_fc_host_stats = fnic_get_stats,
+	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+};
+
+const char *fnic_state_str[] = {
+	[FNIC_IN_FC_MODE] =           "FNIC_IN_FC_MODE",
+	[FNIC_IN_FC_TRANS_ETH_MODE] = "FNIC_IN_FC_TRANS_ETH_MODE",
+	[FNIC_IN_ETH_MODE] =          "FNIC_IN_ETH_MODE",
+	[FNIC_IN_ETH_TRANS_FC_MODE] = "FNIC_IN_ETH_TRANS_FC_MODE",
+};
+
+
+static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
+{
+	int ret;
+	struct fc_lport *lp = shost_priv(host);
+	struct fnic *fnic = lp->drv_priv;
+	struct fc_host_statistics *stats = &lp->host_stats;
+	struct vnic_stats *vs;
+	unsigned long flags;
+
+	if (time_before(jiffies, fnic->stats_time + HZ / FNIC_STATS_RATE_LIMIT))
+		return stats;
+	fnic->stats_time = jiffies;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	ret = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	if (ret) {
+		printk(KERN_DEBUG DFX "fnic: Get vnic stats failed"
+		       " 0x%x", fnic->fnic_no, ret);
+		return stats;
+	}
+	vs = fnic->stats;
+	stats->tx_frames = vs->tx.tx_unicast_frames_ok;
+	stats->tx_words  = vs->tx.tx_unicast_bytes_ok / 4;
+	stats->rx_frames = vs->rx.rx_unicast_frames_ok;
+	stats->rx_words  = vs->rx.rx_unicast_bytes_ok / 4;
+	stats->error_frames = vs->tx.tx_errors + vs->rx.rx_errors;
+	stats->dumped_frames = vs->tx.tx_drops + vs->rx.rx_drop;
+	stats->invalid_crc_count = vs->rx.rx_crc_errors;
+	stats->seconds_since_last_reset = (jiffies - lp->boot_time) / HZ;
+	stats->fcp_input_megabytes = fnic->fcp_input_bytes / 1000000;
+	stats->fcp_output_megabytes = fnic->fcp_output_bytes / 1000000;
+
+	return stats;
+}
+
+void fnic_log_q_error(struct fnic *fnic)
+{
+	unsigned int i;
+	u32 error_status;
+
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		error_status = ioread32(&fnic->wq[i].ctrl->error_status);
+		if (error_status)
+			printk(KERN_ERR DFX "WQ[%d] error_status"
+			       " %d\n", fnic->fnic_no, i, error_status);
+	}
+
+	for (i = 0; i < fnic->rq_count; i++) {
+		error_status = ioread32(&fnic->rq[i].ctrl->error_status);
+		if (error_status)
+			printk(KERN_ERR DFX "RQ[%d] error_status"
+			       " %d\n", fnic->fnic_no, i, error_status);
+	}
+
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		error_status = ioread32(&fnic->wq_copy[i].ctrl->error_status);
+		if (error_status)
+			printk(KERN_ERR DFX "CWQ[%d] error_status"
+			       " %d\n", fnic->fnic_no, i, error_status);
+	}
+}
+
+static void fnic_handle_link_event(struct fnic *fnic)
+{
+	int link_status = vnic_dev_link_status(fnic->vdev);
+	struct fnic_event *event;
+	u8 list_was_empty;
+	unsigned long flags;
+
+	printk(KERN_DEBUG DFX "link %s\n", fnic->fnic_no,
+	       (link_status ? "up" : "down"));
+
+	event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
+	if (!event) {
+		printk(KERN_DEBUG DFX "Cannot allocate a event, "
+		       "cannot indicate link down to FCS\n", fnic->fnic_no);
+		return;
+	}
+
+	/* Pass the event to thread */
+	memset(event, 0, sizeof(struct fnic_event));
+	event->fnic = fnic;
+	event->ev_type = EV_TYPE_LINK_UP;
+	if (!link_status) {
+		event->ev_type = EV_TYPE_LINK_DOWN;
+		fnic->lport->host_stats.link_failure_count++;
+	}
+
+	spin_lock_irqsave(&fnic_eventlist_lock, flags);
+	list_was_empty = list_empty(&fnic_eventlist);
+	list_add_tail(&event->list, &fnic_eventlist);
+	spin_unlock_irqrestore(&fnic_eventlist_lock, flags);
+	if (list_was_empty)
+		wake_up_process(fnic_thread);
+
+	return;
+}
+
+void fnic_notify_check(struct fnic *fnic)
+{
+	fnic_handle_link_event(fnic);
+}
+
+static int fnic_notify_set(struct fnic *fnic)
+{
+	int err;
+
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_INTX:
+		err = vnic_dev_notify_set(fnic->vdev, FNIC_INTX_NOTIFY);
+		break;
+	case VNIC_DEV_INTR_MODE_MSI:
+		err = vnic_dev_notify_set(fnic->vdev, -1);
+		break;
+	case VNIC_DEV_INTR_MODE_MSIX:
+		err = vnic_dev_notify_set(fnic->vdev, FNIC_MSIX_ERR_NOTIFY);
+		break;
+	default:
+		printk(KERN_ERR DFX "Interrupt mode should be set up"
+		       " before devcmd notify set %d\n", fnic->fnic_no,
+		       vnic_dev_get_intr_mode(fnic->vdev));
+		err = -1;
+		BUG();
+		break;
+	}
+
+	return err;
+}
+
+static void fnic_notify_timer(unsigned long data)
+{
+	struct fnic *fnic = (struct fnic *)data;
+
+	fnic_notify_check(fnic);
+	mod_timer(&fnic->notify_timer, jiffies + FNIC_NOTIFY_TIMER_PERIOD);
+}
+
+static void fnic_notify_timer_start(struct fnic *fnic)
+{
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_MSI:
+		mod_timer(&fnic->notify_timer, jiffies);
+		break;
+	default:
+		/* Using intr for notification for INTx/MSI-X */
+		break;
+	};
+}
+
+static int fnic_dev_wait(struct vnic_dev *vdev,
+			 int (*start)(struct vnic_dev *, int),
+			 int (*finished)(struct vnic_dev *, int *),
+			 int arg)
+{
+	unsigned long time;
+	int done;
+	int err;
+
+	BUG_ON(in_interrupt());
+	err = start(vdev, arg);
+	if (err)
+		return err;
+
+	/* Wait for func to complete...2 seconds max */
+	time = jiffies + (HZ * 2);
+	do {
+		err = finished(vdev, &done);
+		if (err)
+			return err;
+		if (done)
+			return 0;
+		schedule_timeout_uninterruptible(HZ / 10);
+	} while (time_after(time, jiffies));
+
+	return -ETIMEDOUT;
+}
+
+static int fnic_dev_open(struct fnic *fnic)
+{
+	int err;
+
+	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
+			    vnic_dev_open_done, 0);
+	if (err)
+		printk(KERN_ERR DFX
+		       "vNIC device open failed, err %d.\n",
+		       fnic->fnic_no, err);
+
+	return err;
+}
+
+static int fnic_cleanup(struct fnic *fnic)
+{
+	unsigned int i;
+	int err;
+
+	del_timer_sync(&fnic->notify_timer);
+
+	vnic_dev_disable(fnic->vdev);
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_mask(&fnic->intr[i]);
+
+	for (i = 0; i < fnic->rq_count; i++) {
+		err = vnic_rq_disable(&fnic->rq[i]);
+		if (err)
+			return err;
+	}
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		err = vnic_wq_disable(&fnic->wq[i]);
+		if (err)
+			return err;
+	}
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		err = vnic_wq_copy_disable(&fnic->wq_copy[i]);
+		if (err)
+			return err;
+	}
+
+	/* Clean up completed IOs and FCS frames */
+	fnic_wq_copy_cmpl_handler(fnic, -1);
+	fnic_wq_cmpl_handler(fnic, -1);
+	fnic_rq_cmpl_handler(fnic, -1);
+
+	/* Clean up the IOs and FCS frames that have not completed */
+	for (i = 0; i < fnic->raw_wq_count; i++)
+		vnic_wq_clean(&fnic->wq[i], fnic_free_wq_buf);
+	for (i = 0; i < fnic->rq_count; i++)
+		vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
+	for (i = 0; i < fnic->wq_copy_count; i++)
+		vnic_wq_copy_clean(&fnic->wq_copy[i],
+				   fnic_wq_copy_cleanup_handler);
+
+	for (i = 0; i < fnic->cq_count; i++)
+		vnic_cq_clean(&fnic->cq[i]);
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_clean(&fnic->intr[i]);
+
+	mempool_destroy(fnic->io_req_pool);
+	for (i = 0; i < FNIC_SGL_NUM_CACHES; i++)
+		mempool_destroy(fnic->io_sgl_pool[i]);
+
+	return 0;
+}
+
+static void fnic_iounmap(struct fnic *fnic)
+{
+	if (fnic->bar0.vaddr)
+		iounmap(fnic->bar0.vaddr);
+}
+
+/*
+ * Allocate element for mempools requiring GFP_DMA flag.
+ * Otherwise, checks in kmem_flagcheck() hit BUG_ON().
+ */
+static void *fnic_alloc_slab_dma(gfp_t gfp_mask, void *pool_data)
+{
+	struct kmem_cache *mem = pool_data;
+
+	return kmem_cache_alloc(mem, gfp_mask | GFP_ATOMIC | GFP_DMA);
+}
+
+static int __devinit fnic_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct Scsi_Host *host;
+	struct fc_lport *lp;
+	struct fnic *fnic;
+	mempool_t *pool;
+	int err;
+	int i;
+
+	host = scsi_host_alloc(&fnic_host_template,
+			       sizeof(struct fc_lport) + sizeof(struct fnic));
+	if (!host) {
+		printk(KERN_ERR PFX "Unable to alloc SCSI host\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+	lp = shost_priv(host);
+	lp->host = host;
+	lp->drv_priv = (void *)(lp + 1);
+	fnic = lp->drv_priv;
+	fnic->lport = lp;
+	lp->tt = fnic_transport_template;
+
+	BUG_ON(!fnic_fc_transport);
+
+	host->transportt = fnic_fc_transport;
+	host->max_lun = FNIC_MAX_LUN;
+	host->max_id = FNIC_MAX_FCP_TARGET;
+
+	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+				    FCPIO_HOST_EXCH_RANGE_START,
+				    FCPIO_HOST_EXCH_RANGE_END,
+				    0);
+	if (!lp->emp) {
+		err = -ENOMEM;
+		goto err_out_free_hba;
+	}
+
+	lp->max_retry_count = 3;
+	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
+			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
+	lp->boot_time = jiffies;
+
+	/* Start with link down */
+	lp->link_status = 0;
+
+	/* Initialize most of libfc */
+	fc_exch_init(lp);
+	fc_lport_init(lp);
+	fc_rport_init(lp);
+	fc_ns_init(lp);
+
+	/* Finish fc_lport configuration */
+	fc_lport_config(lp);
+
+	/* fnic number starts from 0 onwards */
+	fnic->fnic_no = atomic_add_return(1, &fnic_no);
+	snprintf(lp->ifname, sizeof(lp->ifname) - 1, "%s%d", DRV_NAME,
+		 fnic->fnic_no);
+	err = scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
+	if (err)
+		goto err_out_free_exch_mgr;
+
+	/* Setup PCI resources */
+	pci_set_drvdata(pdev, fnic);
+
+	fnic->pdev = pdev;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR DFX "Cannot enable PCI device, aborting.\n",
+		       fnic->fnic_no);
+		goto err_out_free_exch_mgr;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		printk(KERN_ERR DFX "Cannot enable PCI resources, aborting\n",
+		       fnic->fnic_no);
+		goto err_out_disable_device;
+	}
+
+	pci_set_master(pdev);
+
+	/* Query PCI controller on system for DMA addressing
+	 * limitation for the device.  Try 40-bit first, and
+	 * fail to 32-bit.
+	 */
+	err = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
+	if (err) {
+		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (err) {
+			printk(KERN_ERR DFX "No usable DMA configuration "
+			       "aborting\n", fnic->fnic_no);
+			goto err_out_release_regions;
+		}
+		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (err) {
+			printk(KERN_ERR DFX "Unable to obtain 32-bit DMA "
+			       "for consistent allocations, aborting.\n",
+			       fnic->fnic_no);
+			goto err_out_release_regions;
+		}
+	} else {
+		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
+		if (err) {
+			printk(KERN_ERR DFX "Unable to obtain 40-bit DMA "
+			       "for consistent allocations, aborting.\n",
+			       fnic->fnic_no);
+			goto err_out_release_regions;
+		}
+	}
+
+	/* Map vNIC resources from BAR0 */
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
+		printk(KERN_ERR DFX "BAR0 not memory-map'able, aborting.\n",
+		       fnic->fnic_no);
+		err = -ENODEV;
+		goto err_out_release_regions;
+	}
+
+	fnic->bar0.vaddr = pci_iomap(pdev, 0, 0);
+	fnic->bar0.bus_addr = pci_resource_start(pdev, 0);
+	fnic->bar0.len = pci_resource_len(pdev, 0);
+
+	if (!fnic->bar0.vaddr) {
+		printk(KERN_ERR DFX "Cannot memory-map BAR0 res hdr, "
+		       "aborting.\n", fnic->fnic_no);
+		err = -ENODEV;
+		goto err_out_release_regions;
+	}
+
+	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
+	if (!fnic->vdev) {
+		printk(KERN_ERR DFX "vNIC registration failed, "
+		       "aborting.\n", fnic->fnic_no);
+		err = -ENODEV;
+		goto err_out_iounmap;
+	}
+
+	err = fnic_dev_open(fnic);
+	if (err) {
+		printk(KERN_ERR DFX
+		       "vNIC dev open failed, aborting.\n", fnic->fnic_no);
+		goto err_out_vnic_unregister;
+	}
+
+	err = vnic_dev_init(fnic->vdev, 0);
+	if (err) {
+		printk(KERN_ERR DFX
+		       "vNIC dev init failed, aborting.\n", fnic->fnic_no);
+		goto err_out_dev_close;
+	}
+
+	err = vnic_dev_mac_addr(fnic->vdev, fnic->mac_addr);
+	if (err) {
+		printk(KERN_ERR DFX "vNIC get MAC addr failed \n",
+		       fnic->fnic_no);
+		goto err_out_dev_close;
+	}
+
+	/* Get vNIC configuration */
+	err = fnic_get_vnic_config(fnic);
+	if (err) {
+		printk(KERN_ERR DFX "Get vNIC configuration failed, "
+		       "aborting.\n", fnic->fnic_no);
+		goto err_out_dev_close;
+	}
+
+	fnic_get_res_counts(fnic);
+
+	err = fnic_set_intr_mode(fnic);
+	if (err) {
+		printk(KERN_ERR DFX "Failed to set intr mode, "
+		  "aborting.\n", fnic->fnic_no);
+		goto err_out_dev_close;
+	}
+
+	err = fnic_request_intr(fnic);
+	if (err) {
+		printk(KERN_ERR DFX "Unable to request irq.\n", fnic->fnic_no);
+		goto err_out_clear_intr;
+	}
+
+	err = fnic_alloc_vnic_resources(fnic);
+	if (err) {
+		printk(KERN_ERR DFX "Failed to alloc vNIC resources, "
+		       "aborting.\n", fnic->fnic_no);
+		goto err_out_free_intr;
+	}
+
+
+	/* initialize all fnic locks */
+	spin_lock_init(&fnic->fnic_lock);
+
+	for (i = 0; i < FNIC_WQ_MAX; i++)
+		spin_lock_init(&fnic->wq_lock[i]);
+
+	for (i = 0; i < FNIC_WQ_COPY_MAX; i++) {
+		spin_lock_init(&fnic->wq_copy_lock[i]);
+		fnic->wq_copy_desc_low[i] = DESC_CLEAN_LOW_WATERMARK;
+		fnic->fw_ack_recd[i] = 0;
+		fnic->fw_ack_index[i] = -1;
+	}
+
+	for (i = 0; i < FNIC_IO_LOCKS; i++)
+		spin_lock_init(&fnic->io_req_lock[i]);
+
+	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
+	if (!fnic->io_req_pool)
+		goto err_out_free_resources;
+
+	pool = mempool_create(2, fnic_alloc_slab_dma, mempool_free_slab,
+			      (void *)fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
+	if (!pool)
+		goto err_out_free_ioreq_pool;
+	fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
+
+	pool = mempool_create(2, fnic_alloc_slab_dma, mempool_free_slab,
+			      (void *)fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
+	if (!pool)
+		goto err_out_free_dflt_pool;
+	fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX] = pool;
+
+	/* Initialize local port config */
+	lp->e_d_tov = fnic->config.ed_tov;
+	lp->r_a_tov = fnic->config.ra_tov;
+	fc_set_wwnn(lp, fnic->config.node_wwn);
+	fc_set_wwpn(lp, fnic->config.port_wwn);
+	if (fc_set_mfs(lp, fnic->config.maxdatafieldsize +
+		       sizeof(struct fc_frame_header))) {
+		err = -EINVAL;
+		goto err_out_free_max_pool;
+	}
+
+
+	/* setup vlan config, hw inserts vlan header */
+	fnic->vlan_hw_insert = 1;
+	fnic->vlan_id = 0;
+
+	fnic->flogi_oxid = FC_XID_UNKNOWN;
+	fnic->flogi = NULL;
+	fnic->flogi_resp = NULL;
+
+	/* Enable hardware stripping of vlan header on ingress */
+	fnic_set_nic_cfg(fnic, 0, 0, 0, 0, 0, 0, 1);
+
+	/* Setup notification buffer area */
+	err = fnic_notify_set(fnic);
+	if (err) {
+		printk(KERN_ERR DFX
+		       "Failed to alloc notify buffer, aborting.\n",
+		       fnic->fnic_no);
+		goto err_out_free_max_pool;
+	}
+
+	/* Setup notify timer when using MSI interrupts */
+	setup_timer(&fnic->notify_timer,
+		    fnic_notify_timer, (unsigned long)fnic);
+
+	printk(KERN_DEBUG DFX "host no %d\n", fnic->fnic_no, host->host_no);
+
+	/* allocate RQ buffers and post them to RQ*/
+	for (i = 0; i < fnic->rq_count; i++) {
+		err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
+		if (err) {
+			printk(KERN_ERR DFX "fnic_alloc_rq_frame can't alloc "
+			       "frame\n", fnic->fnic_no);
+			goto err_out_free_rq_buf;
+		}
+	}
+
+	/* Initialization done with PCI system, hardware, firmware.
+	 * Add host to SCSI
+	 */
+	err = scsi_add_host(lp->host, &pdev->dev);
+	if (err) {
+		printk(KERN_ERR DFX "fnic: scsi_add_host failed...exiting\n",
+		       fnic->fnic_no);
+		goto err_out_free_rq_buf;
+	}
+
+	/* Enable queues*/
+	for (i = 0; i < fnic->raw_wq_count; i++)
+		vnic_wq_enable(&fnic->wq[i]);
+	for (i = 0; i < fnic->rq_count; i++)
+		vnic_rq_enable(&fnic->rq[i]);
+	for (i = 0; i < fnic->wq_copy_count; i++)
+		vnic_wq_copy_enable(&fnic->wq_copy[i]);
+
+	sprintf(fc_host_symbolic_name(lp->host),
+		DRV_NAME " v" DRV_VERSION " over %s", lp->ifname);
+
+	fnic->state = FNIC_IN_FC_MODE;
+
+	fc_attr_init(lp);
+
+	fc_fabric_login(lp);
+
+	vnic_dev_enable(fnic->vdev);
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_unmask(&fnic->intr[i]);
+
+	fnic_notify_timer_start(fnic);
+
+	return 0;
+
+err_out_free_rq_buf:
+	for (i = 0; i < fnic->rq_count; i++)
+		vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
+	vnic_dev_notify_unset(fnic->vdev);
+err_out_free_max_pool:
+	mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX]);
+err_out_free_dflt_pool:
+	mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
+err_out_free_ioreq_pool:
+	mempool_destroy(fnic->io_req_pool);
+err_out_free_resources:
+	fnic_free_vnic_resources(fnic);
+err_out_free_intr:
+	fnic_free_intr(fnic);
+err_out_clear_intr:
+	fnic_clear_intr_mode(fnic);
+err_out_dev_close:
+	vnic_dev_close(fnic->vdev);
+err_out_vnic_unregister:
+	vnic_dev_unregister(fnic->vdev);
+err_out_iounmap:
+	fnic_iounmap(fnic);
+err_out_release_regions:
+	pci_release_regions(pdev);
+err_out_disable_device:
+	pci_disable_device(pdev);
+err_out_free_exch_mgr:
+	fc_exch_mgr_free(lp->emp);
+err_out_free_hba:
+	scsi_host_put(lp->host);
+err_out:
+	return err;
+}
+
+static void __devexit fnic_remove(struct pci_dev *pdev)
+{
+	struct fnic *fnic = pci_get_drvdata(pdev);
+
+	fc_lport_destroy(fnic->lport);
+	fc_exch_mgr_free(fnic->lport->emp);
+	fnic_cleanup(fnic);
+	fc_remove_host(fnic->lport->host);
+	scsi_remove_host(fnic->lport->host);
+	vnic_dev_notify_unset(fnic->vdev);
+	fnic_free_vnic_resources(fnic);
+	fnic_free_intr(fnic);
+	fnic_clear_intr_mode(fnic);
+	vnic_dev_close(fnic->vdev);
+	vnic_dev_unregister(fnic->vdev);
+	fnic_iounmap(fnic);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	scsi_host_put(fnic->lport->host);
+}
+
+static struct pci_driver fnic_driver = {
+	.name = DRV_NAME,
+	.id_table = fnic_id_table,
+	.probe = fnic_probe,
+	.remove = __devexit_p(fnic_remove),
+};
+
+static int __init fnic_init_module(void)
+{
+	size_t len;
+	int err = 0;
+
+	printk(KERN_INFO PFX "%s, ver %s\n", DRV_DESCRIPTION, DRV_VERSION);
+
+	/* Create a cache for allocation of default size sgls */
+	len = sizeof(struct fnic_dflt_sgl_list);
+	fnic_sgl_cache[FNIC_SGL_CACHE_DFLT] = kmem_cache_create
+		("fnic_sgl_dflt", len, FNIC_SG_DESC_ALIGN,
+		 SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA,
+		 NULL);
+	if (!fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]) {
+		printk(KERN_ERR PFX "failed to create fnic dflt sgl slab\n");
+		err = -ENOMEM;
+		goto err_create_fnic_sgl_slab_dflt;
+	}
+
+	/* Create a cache for allocation of max size sgls*/
+	len = sizeof(struct fnic_sgl_list);
+	fnic_sgl_cache[FNIC_SGL_CACHE_MAX] = kmem_cache_create
+		("fnic_sgl_max", len, FNIC_SG_DESC_ALIGN,
+		 SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA,
+		 NULL);
+	if (!fnic_sgl_cache[FNIC_SGL_CACHE_MAX]) {
+		printk(KERN_ERR PFX "failed to create fnic max sgl slab\n");
+		err = -ENOMEM;
+		goto err_create_fnic_sgl_slab_max;
+	}
+
+	/* Create a cache of objects to wrap frames/events sent to openfc*/
+	len = sizeof(struct fnic_event);
+	fnic_ev_cache = kmem_cache_create("fnic_event", len,
+					  0, 0, NULL);
+	if (!fnic_ev_cache) {
+		printk(KERN_ERR PFX "failed to create fnic event slab\n");
+		err = -ENOMEM;
+		goto err_create_fnic_ev_slab;
+	}
+
+	/* Create a cache of io_req structs for use via mempool */
+	fnic_io_req_cache = kmem_cache_create("fnic_io_req",
+					      sizeof(struct fnic_io_req),
+					      0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fnic_io_req_cache) {
+		printk(KERN_ERR PFX "failed to create fnic io_req slab\n");
+		err = -ENOMEM;
+		goto err_create_fnic_ioreq_slab;
+	}
+
+	/* initialize the Inbound FC Events list spinlock */
+	spin_lock_init(&fnic_eventlist_lock);
+
+	/* Create a thread for handling FCS Events */
+	fnic_thread = kthread_create(fnic_fc_thread,
+				     NULL,
+				     "fnicthread");
+
+	if (!IS_ERR(fnic_thread)) {
+		wake_up_process(fnic_thread);
+	} else {
+		printk(KERN_ERR PFX "fnic thread create failed\n");
+		err = -ENOMEM;
+		goto err_create_fnic_thread;
+	}
+
+	/* initialize fnic_no to -1, the first device is numbered 0 */
+	atomic_set(&fnic_no, -1);
+
+	fnic_fc_transport = fc_attach_transport(&fnic_fc_functions);
+	if (!fnic_fc_transport) {
+		printk(KERN_ERR PFX "fc_attach_transport error\n");
+		err = -ENOMEM;
+		goto err_fc_transport;
+	}
+
+	/* register the driver with PCI system */
+	err = pci_register_driver(&fnic_driver);
+	if (err < 0) {
+		printk(KERN_ERR PFX "pci register error\n");
+		goto err_pci_register;
+	}
+	return err;
+
+err_pci_register:
+	fc_release_transport(fnic_fc_transport);
+err_fc_transport:
+	kthread_stop(fnic_thread);
+err_create_fnic_thread:
+	kmem_cache_destroy(fnic_io_req_cache);
+err_create_fnic_ioreq_slab:
+	kmem_cache_destroy(fnic_ev_cache);
+err_create_fnic_ev_slab:
+	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
+err_create_fnic_sgl_slab_max:
+	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
+err_create_fnic_sgl_slab_dflt:
+	return err;
+}
+
+static void __exit fnic_cleanup_module(void)
+{
+	struct fnic_event *event;
+	unsigned long flags;
+
+	pci_unregister_driver(&fnic_driver);
+
+	kthread_stop(fnic_thread);
+
+	/* Cleanup the Inbound FCS events list */
+	spin_lock_irqsave(&fnic_eventlist_lock, flags);
+	while (!list_empty(&fnic_eventlist)) {
+		event = list_first_entry(&fnic_eventlist,
+					 struct fnic_event, list);
+		list_del(&event->list);
+		kmem_cache_free(fnic_ev_cache, event);
+	}
+	spin_unlock_irqrestore(&fnic_eventlist_lock, flags);
+
+	/* release memory for all global caches */
+	kmem_cache_destroy(fnic_ev_cache);
+	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
+	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
+	kmem_cache_destroy(fnic_io_req_cache);
+
+	fc_release_transport(fnic_fc_transport);
+}
+
+module_init(fnic_init_module);
+module_exit(fnic_cleanup_module);
+



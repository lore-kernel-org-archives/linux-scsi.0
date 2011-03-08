From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 6/8] fnic: Convert to new FC Sysfs infrastructure
Date: Mon, 07 Mar 2011 18:32:15 -0800
Message-ID: <20110308023215.6205.21535.stgit@localhost6.localdomain6>
References: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16650 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab1CHCcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 21:32:16 -0500
In-Reply-To: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

This patch converts the fnic driver to use the
new FC Sysfs infrastructure by removing the existing
FC transport and replacing it. This patch was only
compile tested due to not having hardware.

One open that I have is that most of fnic_get_fcport_speed
is currently commented out. The function receives a
fcport as an argument, but the speed information is
stored in a fnic instance. I'm not sure how to get from
the fcport to the fnic. Since fnic allocates a fcvport
at the same time it allocates/adds a fcport we could
put a pointer to the root fcvport in the fcport or maybe
just make it private data on the end of the fcport since
libfc doesn't need an N_Port fcvport pointer in the
fcport.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/Kconfig          |    1 
 drivers/scsi/fnic/fnic.h      |   33 ++-
 drivers/scsi/fnic/fnic_fcs.c  |   32 ++-
 drivers/scsi/fnic/fnic_isr.c  |   13 +
 drivers/scsi/fnic/fnic_main.c |  412 +++++++++++++++++++++++------------------
 drivers/scsi/fnic/fnic_res.c  |   47 ++---
 drivers/scsi/fnic/fnic_scsi.c |  193 ++++++++++---------
 7 files changed, 400 insertions(+), 331 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6b91d11..608ba3f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -700,6 +700,7 @@ config FCOE
 config FCOE_FNIC
 	tristate "Cisco FNIC Driver"
 	depends on PCI && X86
+	select SCSI_FCP_ATTRS
 	select LIBFCOE
 	help
 	  This is support for the Cisco PCI-Express FCoE HBA.
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 671cde9..48e4faf 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -89,21 +89,28 @@ do {								\
 		} while (0);					\
 } while (0)
 
-#define FNIC_MAIN_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
+#define FNIC_MAIN_DBG(kern_level, lport, fmt, args...)			\
+	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,				\
+			   printk(KERN_INFO "fcport%u: " fmt,		\
+				  fc_port_id((lport)->fcport),		\
+				  ##args);)
 
-#define FNIC_FCS_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
+#define FNIC_FCS_DBG(kern_level, lport, fmt, args...)			\
+	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,				\
+			   printk(KERN_INFO "fcport%u: " fmt,		\
+				  fc_port_id((lport)->fcport),		\
+				  ##args);)
 
-#define FNIC_SCSI_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
+#define FNIC_SCSI_DBG(kern_level, host, fmt, args...)			\
+	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,				\
+			   shost_printk(kern_level, host, fmt, ##args);)
+
+#define FNIC_ISR_DBG(kern_level, lport, fmt, args...)			\
+	FNIC_CHECK_LOGGING(FNIC_ISR_LOGGING,				\
+			   printk(KERN_INFO "fcport%u: " fmt,		\
+				  fc_port_id((lport)->fcport),		\
+				  ##args);)
 
-#define FNIC_ISR_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_ISR_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
 
 extern const char *fnic_state_str[];
 
@@ -250,7 +257,7 @@ int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
 int fnic_host_reset(struct scsi_cmnd *);
-int fnic_reset(struct Scsi_Host *);
+int fnic_fcvport_reset(struct fc_vport *);
 void fnic_scsi_cleanup(struct fc_lport *);
 void fnic_scsi_abort_io(struct fc_lport *);
 void fnic_empty_scsi_cleanup(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 2b48d79..28298a0 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -41,6 +41,9 @@ static void fnic_set_eth_mode(struct fnic *);
 void fnic_handle_link(struct work_struct *work)
 {
 	struct fnic *fnic = container_of(work, struct fnic, link_work);
+	struct fc_lport *lport = fnic->lport;
+	struct fcp_init *fcpinit = lport->fcpinit;
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
 	unsigned long flags;
 	int old_link_status;
 	u32 old_link_down_cnt;
@@ -64,12 +67,12 @@ void fnic_handle_link(struct work_struct *work)
 		else {
 			if (old_link_down_cnt != fnic->link_down_cnt) {
 				/* UP -> DOWN -> UP */
-				fnic->lport->host_stats.link_failure_count++;
+				si->fcpinit_stats.link_failure_count++;
 				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 					     "link down\n");
 				fcoe_ctlr_link_down(&fnic->ctlr);
-				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 					     "link up\n");
 				fcoe_ctlr_link_up(&fnic->ctlr);
 			} else
@@ -79,13 +82,13 @@ void fnic_handle_link(struct work_struct *work)
 	} else if (fnic->link_status) {
 		/* DOWN -> UP */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link up\n");
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport, "link up\n");
 		fcoe_ctlr_link_up(&fnic->ctlr);
 	} else {
 		/* UP -> DOWN */
-		fnic->lport->host_stats.link_failure_count++;
+		si->fcpinit_stats.link_failure_count++;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link down\n");
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport, "link down\n");
 		fcoe_ctlr_link_down(&fnic->ctlr);
 	}
 
@@ -194,7 +197,7 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 		new = ctl;
 	if (!compare_ether_addr(data, new))
 		return;
-	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "update_mac %pM\n", new);
+	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport, "update_mac %pM\n", new);
 	if (!is_zero_ether_addr(data) && compare_ether_addr(data, ctl))
 		vnic_dev_del_addr(fnic->vdev, data);
 	memcpy(data, new, ETH_ALEN);
@@ -236,7 +239,7 @@ void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
 	u8 *mac;
 	int ret;
 
-	FNIC_FCS_DBG(KERN_DEBUG, lport->host, "set port_id %x fp %p\n",
+	FNIC_FCS_DBG(KERN_DEBUG, lport, "set port_id %x fp %p\n",
 		     port_id, fp);
 
 	/*
@@ -263,7 +266,7 @@ void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
 	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
 	else {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 			     "Unexpected fnic state %s while"
 			     " processing flogi resp\n",
 			     fnic_state_to_str(fnic->state));
@@ -344,7 +347,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		eth_hdrs_stripped = 0;
 		skb_trim(skb, bytes_written);
 		if (!fcs_ok) {
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 				     "fcs error.  dropping packet.\n");
 			goto drop;
 		}
@@ -353,13 +356,13 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 	} else {
 		/* wrong CQ type*/
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->lport->fcpinit->shost,
 			     "fnic rq_cmpl wrong cq type x%x\n", type);
 		goto drop;
 	}
 
 	if (!fcs_ok || packet_error || !fcoe_fc_crc_ok || fcoe_enc_error) {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 			     "fnic rq_cmpl fcoe x%x fcsok x%x"
 			     " pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err"
 			     " x%x\n",
@@ -410,7 +413,8 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 		if (cur_work_done) {
 			err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 			if (err)
-				shost_printk(KERN_ERR, fnic->lport->host,
+				shost_printk(KERN_ERR,
+					     fnic->lport->fcpinit->shost,
 					     "fnic_alloc_rq_frame cant alloc"
 					     " frame\n");
 		}
@@ -435,7 +439,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	len = FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
 	skb = dev_alloc_skb(len);
 	if (!skb) {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport,
 			     "Unable to allocate RQ sk_buff\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 5c1f223..41f7720 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -197,9 +197,10 @@ int fnic_request_intr(struct fnic *fnic)
 					  fnic->msix[i].devname,
 					  fnic->msix[i].devid);
 			if (err) {
-				shost_printk(KERN_ERR, fnic->lport->host,
-					     "MSIX: request_irq"
-					     " failed %d\n", err);
+				printk(KERN_ERR "fcport%u: MSIX: request_irq"
+				       " failed %d\n",
+				       fc_port_id(fnic->lport->fcport),
+				       err);
 				fnic_free_intr(fnic);
 				break;
 			}
@@ -249,7 +250,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 			fnic->intr_count = n + m + o + 1;
 			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
 
-			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport,
 				     "Using MSI-X Interrupts\n");
 			vnic_dev_set_intr_mode(fnic->vdev,
 					       VNIC_DEV_INTR_MODE_MSIX);
@@ -276,7 +277,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->intr_count = 1;
 		fnic->err_intr_offset = 0;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport,
 			     "Using MSI Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
 
@@ -302,7 +303,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->cq_count = 3;
 		fnic->intr_count = 3;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport,
 			     "Using Legacy Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index bb63f1a..a302c94 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -27,14 +27,15 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/if_ether.h>
-#include <scsi/fc/fc_fip.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
+
 #include <scsi/scsi_tcq.h>
+#include <scsi/fc/fc_fip.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
 
+#include <fc/fc.h>
+#include <scsi/scsi_transport_fcp.h>
+
 #include "vnic_dev.h"
 #include "vnic_intr.h"
 #include "vnic_stats.h"
@@ -68,6 +69,8 @@ unsigned int fnic_log_level;
 module_param(fnic_log_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_log_level, "bit mask of fnic logging levels");
 
+static void fnic_get_fcport_speed(struct fc_port *fcport);
+static void fnic_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout);
 
 static struct libfc_function_template fnic_transport_template = {
 	.frame_send = fnic_send,
@@ -79,7 +82,9 @@ static struct libfc_function_template fnic_transport_template = {
 
 static int fnic_slave_alloc(struct scsi_device *sdev)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct scsi_target *starget = scsi_target(sdev);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
 
 	sdev->tagged_supported = 1;
 
@@ -90,23 +95,110 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template fnic_host_template = {
-	.module = THIS_MODULE,
-	.name = DRV_NAME,
-	.queuecommand = fnic_queuecommand,
-	.eh_abort_handler = fnic_abort_cmd,
-	.eh_device_reset_handler = fnic_device_reset,
-	.eh_host_reset_handler = fnic_host_reset,
-	.slave_alloc = fnic_slave_alloc,
-	.change_queue_depth = fc_change_queue_depth,
-	.change_queue_type = fc_change_queue_type,
-	.this_id = -1,
-	.cmd_per_lun = 3,
-	.can_queue = FNIC_MAX_IO_REQ,
-	.use_clustering = ENABLE_CLUSTERING,
-	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
-	.max_sectors = 0xffff,
-	.shost_attrs = fnic_attrs,
+static void fnic_fcpinit_add(struct fcp_init *fcpinit)
+{
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lport = fcpinit_to_lport(fcpinit);
+	struct fnic *fnic = lport_priv(lport);
+	int err;
+
+	err = scsi_init_shared_tag_map(si->host, FNIC_MAX_IO_REQ);
+	if (err)
+		shost_printk(KERN_ERR, si->host,
+			     "Unable to alloc shared tag map\n");
+
+	si->host->max_lun = fnic->config.luns_per_tgt;
+	si->host->max_id = FNIC_MAX_FCP_TARGET;
+	si->host->max_cmd_len = FCOE_MAX_CMD_LEN;
+}
+
+static void fnic_fcpinit_del(struct fcp_init *fcpinit)
+{
+	/* TODO: Anything to clean up here? */
+}
+
+static struct fcp_template fnic_fcp_template = {
+	.fcpinit_priv_size = sizeof(struct fc_fcp_internal),
+	.fcp_fcpinit_add = fnic_fcpinit_add,
+	.fcp_fcpinit_del = fnic_fcpinit_del,
+
+	.shost_template = {
+		.module = THIS_MODULE,
+		.name = DRV_NAME,
+		.queuecommand = fnic_queuecommand,
+		.eh_abort_handler = fnic_abort_cmd,
+		.eh_device_reset_handler = fnic_device_reset,
+		.eh_host_reset_handler = fnic_host_reset,
+		.slave_alloc = fnic_slave_alloc,
+		.change_queue_depth = fc_change_queue_depth,
+		.change_queue_type = fc_change_queue_type,
+		.this_id = -1,
+		.cmd_per_lun = 3,
+		.can_queue = FNIC_MAX_IO_REQ,
+		.use_clustering = ENABLE_CLUSTERING,
+		.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
+		.max_sectors = 0xffff,
+		.shost_attrs = fnic_attrs,
+	},
+
+	.show_fcpinit_port_state = 1,
+	.get_fcpinit_stats = fc_get_fcpinit_stats,
+	.bsg_request = fc_lport_bsg_request,
+};
+
+struct fc_port_function_template fnic_fcport_fcn_tmpl = {
+	.show_fcport_system_hostname = 1,
+	.show_fcport_fab_dev_loss_tmo = 1,
+	.show_fcport_maxframe_size = 1,
+	.show_fcport_supported_speeds = 1,
+	.show_fcport_supported_classes = 1,
+	.show_fcport_speed = 1,
+	.show_fcport_supported_fc4s = 1,
+	.show_fcport_active_fc4s = 1,
+	.show_fcport_serial_number = 1,
+	.show_fcport_hbaapi_lib = 1,
+
+	.get_fcport_speed = fnic_get_fcport_speed,
+
+	.show_fcport_enode_mac_address = 1,
+	.show_fcport_vlan_id = 1,
+
+	.fcvport_f = {
+		.show_fcvport_port_id = 1,
+		.show_fcvport_symbolic_name = 1,
+		.show_fcvport_node_name = 1,
+		.show_fcvport_port_name = 1,
+		.show_fcvport_port_type = 1,
+
+		.issue_fcvport_lip = fnic_fcvport_reset,
+
+		.get_fcvport_port_state = fc_get_fcvport_port_state,
+		.dd_fcvport_size = (sizeof(struct fc_lport) +
+				    (sizeof(struct fnic))),
+
+		.fcrport_f = {
+			.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+			.show_rport_maxframe_size = 1,
+			.show_rport_supported_classes = 1,
+			.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
+			.show_rport_dev_loss_tmo = 1,
+			.terminate_rport_io = fnic_terminate_rport_io,
+		},
+	},
+};
+
+struct fc_fabric_function_template fnic_fcfabric_fcn_tmpl = {
+	.fabric_match = fcoe_fcf_match,
+
+	.show_fcfabric_fabric_name = 1,
+	.show_fcfabric_dev_loss_tmo = 1,
+	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
+
+	.show_fcfabric_fc_map = 1,
+	.show_fcfabric_vfid = 1,
+	.show_fcfabric_mac_address = 1,
+	.show_fcfabric_priority = 1,
+	.show_fcfabric_fka_period = 1,
 };
 
 static void
@@ -118,48 +210,21 @@ fnic_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 		rport->dev_loss_tmo = 1;
 }
 
-static void fnic_get_host_speed(struct Scsi_Host *shost);
-static struct scsi_transport_template *fnic_fc_transport;
-static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *);
-
-static struct fc_function_template fnic_fc_functions = {
-
-	.show_host_node_name = 1,
-	.show_host_port_name = 1,
-	.show_host_supported_classes = 1,
-	.show_host_supported_fc4s = 1,
-	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
-	.show_host_port_id = 1,
-	.show_host_supported_speeds = 1,
-	.get_host_speed = fnic_get_host_speed,
-	.show_host_speed = 1,
-	.show_host_port_type = 1,
-	.get_host_port_state = fc_get_host_port_state,
-	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
-	.show_rport_dev_loss_tmo = 1,
-	.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
-	.issue_fc_host_lip = fnic_reset,
-	.get_fc_host_stats = fnic_get_stats,
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
-	.terminate_rport_io = fnic_terminate_rport_io,
-	.bsg_request = fc_lport_bsg_request,
-};
-
-static void fnic_get_host_speed(struct Scsi_Host *shost)
+static void fnic_get_fcport_speed(struct fc_port *fcport)
 {
+/*
+TODO readd
+
+problem is that fnic needs to get to a sub lport struct
+and all we have is the fcport with no priv data to get
+to that sub lport struct
+
+
 	struct fc_lport *lp = shost_priv(shost);
 	struct fnic *fnic = lport_priv(lp);
 	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
 
-	/* Add in other values as they get defined in fw */
+	 Add in other values as they get defined in fw
 	switch (port_speed) {
 	case 10000:
 		fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
@@ -168,14 +233,16 @@ static void fnic_get_host_speed(struct Scsi_Host *shost)
 		fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
 		break;
 	}
+*/
 }
 
-static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
+struct fcp_init_statistics *fnic_get_fcpinit_stats(struct fcp_init *fcpinit)
 {
 	int ret;
-	struct fc_lport *lp = shost_priv(host);
+	struct fc_lport *lp = fcpinit_to_lport(fcpinit);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
 	struct fnic *fnic = lport_priv(lp);
-	struct fc_host_statistics *stats = &lp->host_stats;
+	struct fcp_init_statistics *stats = &si->fcpinit_stats;
 	struct vnic_stats *vs;
 	unsigned long flags;
 
@@ -188,8 +255,7 @@ static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
-			      "fnic: Get vnic stats failed"
+		FNIC_MAIN_DBG(KERN_DEBUG, lp, "fnic: Get vnic stats failed"
 			      " 0x%x", ret);
 		return stats;
 	}
@@ -216,25 +282,22 @@ void fnic_log_q_error(struct fnic *fnic)
 	for (i = 0; i < fnic->raw_wq_count; i++) {
 		error_status = ioread32(&fnic->wq[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "WQ[%d] error_status"
-				     " %d\n", i, error_status);
+			printk(KERN_ERR "fcport%u: WQ[%d] error_status %d\n",
+			       fnic->lport->fcport->id, i, error_status);
 	}
 
 	for (i = 0; i < fnic->rq_count; i++) {
 		error_status = ioread32(&fnic->rq[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "RQ[%d] error_status"
-				     " %d\n", i, error_status);
+			printk(KERN_ERR "fcport%u: RQ[%d] error_status %d\n",
+			       fnic->lport->fcport->id, i, error_status);
 	}
 
 	for (i = 0; i < fnic->wq_copy_count; i++) {
 		error_status = ioread32(&fnic->wq_copy[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "CWQ[%d] error_status"
-				     " %d\n", i, error_status);
+			printk(KERN_ERR "fcport%u: CWQ[%d] error_status %d\n",
+			       fnic->lport->fcport->id, i, error_status);
 	}
 }
 
@@ -268,10 +331,10 @@ static int fnic_notify_set(struct fnic *fnic)
 		err = vnic_dev_notify_set(fnic->vdev, FNIC_MSIX_ERR_NOTIFY);
 		break;
 	default:
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Interrupt mode should be set up"
-			     " before devcmd notify set %d\n",
-			     vnic_dev_get_intr_mode(fnic->vdev));
+		printk(KERN_ERR "fcport%u: Interrupt mode should be set up"
+		       " before devcmd notify set %d\n",
+		       fc_port_id(fnic->lport->fcport),
+		       vnic_dev_get_intr_mode(fnic->vdev));
 		err = -1;
 		break;
 	}
@@ -413,7 +476,10 @@ static u8 *fnic_get_mac(struct fc_lport *lport)
 static int __devinit fnic_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	struct Scsi_Host *host;
+	struct fc_port *fcport;
+	struct fc_vport *fcvport;
+	struct fc_vport_identifiers ids;
+	struct fc_port_fcoe_attrs fcoe_attrs;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	mempool_t *pool;
@@ -421,32 +487,45 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	int i;
 	unsigned long flags;
 
-	/*
-	 * Allocate SCSI Host and set up association between host,
-	 * local port, and fnic
-	 */
-	lp = libfc_host_alloc(&fnic_host_template, sizeof(struct fnic));
-	if (!lp) {
-		printk(KERN_ERR PFX "Unable to alloc libfc local port\n");
+	fcport = fc_port_add(&pdev->dev, &fnic_fcport_fcn_tmpl,
+			     &fnic_fcp_template, &fcoe_attrs);
+	if (!fcport) {
+		printk(KERN_ERR PFX "Unable to alloc fc port\n");
 		err = -ENOMEM;
 		goto err_out;
 	}
-	host = lp->host;
+
+	fcvport = fc_vport_alloc(NULL, &ids,
+				 &fnic_fcport_fcn_tmpl.fcvport_f,
+				 0, FC4_FCP_INITIATOR);
+	if (!fcvport) {
+		printk(KERN_ERR PFX "Unable to alloc fc vport\n");
+		err = -ENOMEM;
+		goto err_out_free_port;
+	}
+
+	lp = fc_vport_priv(fcvport);
 	fnic = lport_priv(lp);
-	fnic->lport = lp;
-	fnic->ctlr.lp = lp;
 
-	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
-		 host->host_no);
+	/* Configure the fcport */
+	fc_port_maxframe_size(fcport) = lp->mfs;
+	strncpy(fc_port_hbaapi_lib(fcport), LIBHBALINUX,
+		strlen(LIBHBALINUX));
 
-	host->transportt = fnic_fc_transport;
+	/* Configure the fcvport */
+	fc_vport_port_type(fcvport) = FC_PORTTYPE_NPORT;
+	fc_vport_rport_dev_loss_tmo(fcvport) =
+		fnic->config.port_down_timeout / 1000;
 
-	err = scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Unable to alloc shared tag map\n");
-		goto err_out_free_hba;
-	}
+	/* Configure the lport */
+	lp->fcport = fcport;
+	fc_lport_port_config(fcport);
+
+	/* Configure the fnic */
+	fnic->lport = lp;
+	fnic->ctlr.lp = lp;
+	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
+		 fcport->id);
 
 	/* Setup PCI resources */
 	pci_set_drvdata(pdev, fnic);
@@ -455,15 +534,15 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot enable PCI device, aborting.\n");
-		goto err_out_free_hba;
+		printk(KERN_ERR "fcport%u: Cannot enable PCI device, aborting.\n",
+		       fc_port_id(fcport));
+		goto err_out_free_vport;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot enable PCI resources, aborting\n");
+		printk(KERN_ERR "fcport%u: Cannot enable PCI resources, aborting\n",
+		       fc_port_id(fcport));
 		goto err_out_disable_device;
 	}
 
@@ -477,32 +556,31 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	if (err) {
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "No usable DMA configuration "
-				     "aborting\n");
+			printk(KERN_ERR "fcport%u: No usable DMA configuration "
+			       "aborting\n", fc_port_id(fcport));
 			goto err_out_release_regions;
 		}
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "Unable to obtain 32-bit DMA "
-				     "for consistent allocations, aborting.\n");
+			printk(KERN_ERR "fcport%u: Unable to obtain 32-bit DMA "
+			       "for consistent allocations, aborting.\n",
+			       fc_port_id(fcport));
 			goto err_out_release_regions;
 		}
 	} else {
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40));
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "Unable to obtain 40-bit DMA "
-				     "for consistent allocations, aborting.\n");
+			printk(KERN_ERR "fcport%u: Unable to obtain 40-bit DMA "
+			       "for consistent allocations, aborting.\n",
+			       fc_port_id(fcport));
 			goto err_out_release_regions;
 		}
 	}
 
 	/* Map vNIC resources from BAR0 */
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "BAR0 not memory-map'able, aborting.\n");
+		printk(KERN_ERR "fcport%u: BAR0 not memory-map'able, aborting.\n",
+		       fc_port_id(fcport));
 		err = -ENODEV;
 		goto err_out_release_regions;
 	}
@@ -512,18 +590,16 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fnic->bar0.len = pci_resource_len(pdev, 0);
 
 	if (!fnic->bar0.vaddr) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot memory-map BAR0 res hdr, "
-			     "aborting.\n");
+		printk(KERN_ERR "fcport%u: Cannot memory-map BAR0 res hdr, "
+		       "aborting.\n", fc_port_id(fcport));
 		err = -ENODEV;
 		goto err_out_release_regions;
 	}
 
 	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
 	if (!fnic->vdev) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC registration failed, "
-			     "aborting.\n");
+		printk(KERN_ERR "fcport%u: vNIC registration failed, "
+		       "aborting.\n", fc_port_id(fcport));
 		err = -ENODEV;
 		goto err_out_iounmap;
 	}
@@ -531,22 +607,22 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
 			    vnic_dev_open_done, 0);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC dev open failed, aborting.\n");
+		printk(KERN_ERR "fcport%u: vNIC dev open failed, aborting.\n",
+		       fc_port_id(fcport));
 		goto err_out_vnic_unregister;
 	}
 
 	err = vnic_dev_init(fnic->vdev, 0);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC dev init failed, aborting.\n");
+		printk(KERN_ERR "fcport%u: vNIC dev init failed, aborting.\n",
+		       fc_port_id(fcport));
 		goto err_out_dev_close;
 	}
 
 	err = vnic_dev_mac_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC get MAC addr failed \n");
+		printk(KERN_ERR "fcport%u: vNIC get MAC addr failed.\n",
+		       fc_port_id(fcport));
 		goto err_out_dev_close;
 	}
 	/* set data_src for point-to-point mode and to keep it non-zero */
@@ -555,34 +631,27 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	/* Get vNIC configuration */
 	err = fnic_get_vnic_config(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Get vNIC configuration failed, "
-			     "aborting.\n");
+		printk(KERN_ERR "fcport%u: Get vNIC configuration failed, "
+		       "aborting.\n", fc_port_id(fcport));
 		goto err_out_dev_close;
 	}
-	host->max_lun = fnic->config.luns_per_tgt;
-	host->max_id = FNIC_MAX_FCP_TARGET;
-	host->max_cmd_len = FCOE_MAX_CMD_LEN;
 
 	fnic_get_res_counts(fnic);
 
 	err = fnic_set_intr_mode(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to set intr mode, "
-			     "aborting.\n");
+		printk(KERN_ERR "fcport%u: Failed to set intr mode, "
+		       "aborting.\n", fc_port_id(fcport));
 		goto err_out_dev_close;
 	}
 
 	err = fnic_alloc_vnic_resources(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to alloc vNIC resources, "
-			     "aborting.\n");
+		printk(KERN_ERR "fcport%u: Failed to alloc vNIC resources, "
+		       "aborting.\n", fc_port_id(fcport));
 		goto err_out_clear_intr;
 	}
 
-
 	/* initialize all fnic locks */
 	spin_lock_init(&fnic->fnic_lock);
 
@@ -624,16 +693,16 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fnic->ctlr.update_mac = fnic_update_mac;
 	fnic->ctlr.get_src_addr = fnic_get_mac;
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
-		shost_printk(KERN_INFO, fnic->lport->host,
-			     "firmware supports FIP\n");
+		printk(KERN_INFO "fcport%u: firmware supports FIP\n",
+		       fc_port_id(fcport));
 		/* enable directed and multicast */
 		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
 		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
 		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
 		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
 	} else {
-		shost_printk(KERN_INFO, fnic->lport->host,
-			     "firmware uses non-FIP mode\n");
+		printk(KERN_INFO "fcport%u: firmware uses non-FIP mode\n",
+		       fc_port_id(fcport));
 		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
 	}
 	fnic->state = FNIC_IN_FC_MODE;
@@ -644,8 +713,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	/* Setup notification buffer area */
 	err = fnic_notify_set(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to alloc notify buffer, aborting.\n");
+		printk(KERN_ERR "fcport%u: Failed to alloc notify "
+		       "buffer, aborting.\n", fc_port_id(fcport));
 		goto err_out_free_max_pool;
 	}
 
@@ -658,24 +727,12 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	for (i = 0; i < fnic->rq_count; i++) {
 		err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "fnic_alloc_rq_frame can't alloc "
-				     "frame\n");
+			printk(KERN_ERR "fcport%u: fnic_alloc_rq_frame "
+			       "can't alloc frame\n", fc_port_id(fcport));
 			goto err_out_free_rq_buf;
 		}
 	}
 
-	/*
-	 * Initialization done with PCI system, hardware, firmware.
-	 * Add host to SCSI
-	 */
-	err = scsi_add_host(lp->host, &pdev->dev);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "fnic: scsi_add_host failed...exiting\n");
-		goto err_out_free_rq_buf;
-	}
-
 	/* Start local port initiatialization */
 
 	lp->link_up = 0;
@@ -690,16 +747,16 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	lp->boot_time = jiffies;
 	lp->e_d_tov = fnic->config.ed_tov;
 	lp->r_a_tov = fnic->config.ra_tov;
-	lp->link_supported_speeds = FC_PORTSPEED_10GBIT;
+	fc_port_supported_speeds(fcport) = FC_PORTSPEED_10GBIT;
 	fc_set_wwnn(lp, fnic->config.node_wwn);
 	fc_set_wwpn(lp, fnic->config.port_wwn);
 
-	fcoe_libfc_config(lp, &fnic->ctlr, &fnic_transport_template, 0);
+	fcoe_libfc_config(lp, &fnic->ctlr, &fnic_transport_template);
 
 	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCPIO_HOST_EXCH_RANGE_START,
 			       FCPIO_HOST_EXCH_RANGE_END, NULL)) {
 		err = -ENOMEM;
-		goto err_out_remove_scsi_host;
+		goto err_out_free_rq_buf;
 	}
 
 	fc_lport_init_stats(lp);
@@ -711,10 +768,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		err = -EINVAL;
 		goto err_out_free_exch_mgr;
 	}
-	fc_host_maxframe_size(lp->host) = lp->mfs;
-	fc_host_dev_loss_tmo(lp->host) = fnic->config.port_down_timeout / 1000;
 
-	sprintf(fc_host_symbolic_name(lp->host),
+	sprintf(fc_vport_symbolic_name(fcvport),
 		DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
 
 	spin_lock_irqsave(&fnic_list_lock, flags);
@@ -740,8 +795,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 	err = fnic_request_intr(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Unable to request irq.\n");
+		printk(KERN_ERR "fcport%u: Unable to request irq.\n",
+		       fc_port_id(fcport));
 		goto err_out_free_exch_mgr;
 	}
 
@@ -754,9 +809,6 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 err_out_free_exch_mgr:
 	fc_exch_mgr_free(lp);
-err_out_remove_scsi_host:
-	fc_remove_host(lp->host);
-	scsi_remove_host(lp->host);
 err_out_free_rq_buf:
 	for (i = 0; i < fnic->rq_count; i++)
 		vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
@@ -781,8 +833,10 @@ err_out_release_regions:
 	pci_release_regions(pdev);
 err_out_disable_device:
 	pci_disable_device(pdev);
-err_out_free_hba:
-	scsi_host_put(lp->host);
+err_out_free_vport:
+	fc_vport_free(fcvport);
+err_out_free_port:
+	fc_port_del(fcport);
 err_out:
 	return err;
 }
@@ -791,6 +845,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 {
 	struct fnic *fnic = pci_get_drvdata(pdev);
 	struct fc_lport *lp = fnic->lport;
+	struct fc_port *fcport = lp->fcport;
 	unsigned long flags;
 
 	/*
@@ -842,8 +897,6 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	list_del(&fnic->list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
-	fc_remove_host(fnic->lport->host);
-	scsi_remove_host(fnic->lport->host);
 	fc_exch_mgr_free(fnic->lport);
 	vnic_dev_notify_unset(fnic->vdev);
 	fnic_free_intr(fnic);
@@ -855,7 +908,8 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
-	scsi_host_put(lp->host);
+	fc_vport_free(lport_to_fcvport(lp));
+	fc_port_del(fcport);
 }
 
 static struct pci_driver fnic_driver = {
@@ -916,13 +970,6 @@ static int __init fnic_init_module(void)
 	spin_lock_init(&fnic_list_lock);
 	INIT_LIST_HEAD(&fnic_list);
 
-	fnic_fc_transport = fc_attach_transport(&fnic_fc_functions);
-	if (!fnic_fc_transport) {
-		printk(KERN_ERR PFX "fc_attach_transport error\n");
-		err = -ENOMEM;
-		goto err_fc_transport;
-	}
-
 	/* register the driver with PCI system */
 	err = pci_register_driver(&fnic_driver);
 	if (err < 0) {
@@ -932,8 +979,6 @@ static int __init fnic_init_module(void)
 	return err;
 
 err_pci_register:
-	fc_release_transport(fnic_fc_transport);
-err_fc_transport:
 	destroy_workqueue(fnic_event_queue);
 err_create_fnic_workq:
 	kmem_cache_destroy(fnic_io_req_cache);
@@ -952,7 +997,6 @@ static void __exit fnic_cleanup_module(void)
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	kmem_cache_destroy(fnic_io_req_cache);
-	fc_release_transport(fnic_fc_transport);
 }
 
 module_init(fnic_init_module);
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 50488f8..db60467 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -36,17 +36,17 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	struct vnic_fc_config *c = &fnic->config;
 	int err;
 
-#define GET_CONFIG(m) \
-	do { \
-		err = vnic_dev_spec(fnic->vdev, \
+#define GET_CONFIG(m)							\
+	do {								\
+		err = vnic_dev_spec(fnic->vdev,				\
 				    offsetof(struct vnic_fc_config, m), \
-				    sizeof(c->m), &c->m); \
-		if (err) { \
-			shost_printk(KERN_ERR, fnic->lport->host, \
-				     "Error getting %s, %d\n", #m, \
-				     err); \
-			return err; \
-		} \
+				    sizeof(c->m), &c->m);		\
+		if (err) {						\
+			shost_printk(KERN_ERR, fnic->lport->fcpinit->shost, \
+				     "Error getting %s, %d\n", #m,	\
+				     err);				\
+			return err;					\
+		}							\
 	} while (0);
 
 	GET_CONFIG(node_wwn);
@@ -143,34 +143,34 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	c->intr_timer = min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
 	c->intr_timer_type = c->intr_timer_type;
 
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC MAC addr %pM "
 		     "wq/wq_copy/rq %d/%d/%d\n",
 		     fnic->ctlr.ctl_src_addr,
 		     c->wq_enet_desc_count, c->wq_copy_desc_count,
 		     c->rq_desc_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC node wwn %llx port wwn %llx\n",
 		     c->node_wwn, c->port_wwn);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC ed_tov %d ra_tov %d\n",
 		     c->ed_tov, c->ra_tov);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC mtu %d intr timer %d\n",
 		     c->maxdatafieldsize, c->intr_timer);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC flags 0x%x luns per tgt %d\n",
 		     c->flags, c->luns_per_tgt);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC flogi_retries %d flogi timeout %d\n",
 		     c->flogi_retries, c->flogi_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC plogi retries %d plogi timeout %d\n",
 		     c->plogi_retries, c->plogi_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC io throttle count %d link dn timeout %d\n",
 		     c->io_throttle_count, c->link_down_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
+	shost_printk(KERN_INFO, fnic->lport->fcpinit->shost,
 		     "vNIC port dn io retries %d port dn timeout %d\n",
 		     c->port_down_io_retries, c->port_down_timeout);
 
@@ -229,6 +229,7 @@ void fnic_free_vnic_resources(struct fnic *fnic)
 
 int fnic_alloc_vnic_resources(struct fnic *fnic)
 {
+	struct Scsi_Host *shost = fnic->lport->fcpinit->shost;
 	enum vnic_dev_intr_mode intr_mode;
 	unsigned int mask_on_assertion;
 	unsigned int interrupt_offset;
@@ -240,13 +241,13 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 
 	intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
 
-	shost_printk(KERN_INFO, fnic->lport->host, "vNIC interrupt mode: %s\n",
+	shost_printk(KERN_INFO, shost, "vNIC interrupt mode: %s\n",
 		     intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
 		     intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
 		     intr_mode == VNIC_DEV_INTR_MODE_MSIX ?
 		     "MSI-X" : "unknown");
 
-	shost_printk(KERN_INFO, fnic->lport->host, "vNIC resources avail: "
+	shost_printk(KERN_INFO, shost, "vNIC resources avail: "
 		     "wq %d cp_wq %d raw_wq %d rq %d cq %d intr %d\n",
 		     fnic->wq_count, fnic->wq_copy_count, fnic->raw_wq_count,
 		     fnic->rq_count, fnic->cq_count, fnic->intr_count);
@@ -322,7 +323,7 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 				RES_TYPE_INTR_PBA_LEGACY, 0);
 
 	if (!fnic->legacy_pba && intr_mode == VNIC_DEV_INTR_MODE_INTX) {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, shost,
 			     "Failed to hook legacy pba resource\n");
 		err = -ENODEV;
 		goto err_out_cleanup;
@@ -426,7 +427,7 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 	/* init the stats memory by making the first call here */
 	err = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, shost,
 			     "vnic_dev_stats_dump failed - x%x\n", err);
 		goto err_out_cleanup;
 	}
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 22d0240..0c6b77a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -191,10 +191,10 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 
 	if (!ret)
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "Issued fw reset\n");
 	else
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "Failed to issue fw reset\n");
 	return ret;
 }
@@ -236,13 +236,13 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 						fc_id, gw_mac,
 						fnic->data_src_addr,
 						lp->r_a_tov, lp->e_d_tov);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
 			      fc_id, fnic->data_src_addr, gw_mac);
 	} else {
 		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
 						  format, fc_id, gw_mac);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "FLOGI reg issued fcid %x map %d dest %pM\n",
 			      fc_id, fnic->ctlr.map_dest, gw_mac);
 	}
@@ -262,8 +262,10 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					  struct scsi_cmnd *sc,
 					  int sg_count)
 {
+	struct scsi_target *starget = scsi_target(sc->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
 	struct scatterlist *sg;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
 	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct host_sg_desc *desc;
 	u8 pri_tag = 0;
@@ -351,8 +353,12 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
  */
 static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
-	struct fc_lport *lp;
-	struct fc_rport *rport;
+	struct scsi_target *starget = scsi_target(sc->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+	struct fcp_init *fcpinit = shost_priv(sc->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lp = si->lport;
 	struct fnic_io_req *io_req;
 	struct fnic *fnic;
 	struct vnic_wq_copy *wq;
@@ -361,7 +367,6 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	unsigned long flags;
 	unsigned long ptr;
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
 		sc->result = ret;
@@ -378,7 +383,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	 * Don't re-enable interrupts in case they were disabled prior to the
 	 * caller disabling them.
 	 */
-	spin_unlock(lp->host->host_lock);
+	spin_unlock(lp->fcpinit->shost->host_lock);
 
 	/* Get a new io_req for this SCSI IO */
 	fnic = lport_priv(lp);
@@ -453,7 +458,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	}
 out:
 	/* acquire host lock before returning to SCSI */
-	spin_lock(lp->host->host_lock);
+	spin_lock(lp->fcpinit->shost->host_lock);
 	return ret;
 }
 
@@ -483,13 +488,13 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) {
 		/* Check status of reset completion */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 				      "reset cmpl success\n");
 			/* Ready to send flogi out */
 			fnic->state = FNIC_IN_ETH_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
-				      fnic->lport->host,
+				      fnic->lport->fcpinit->shost,
 				      "fnic fw_reset : failed %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 
@@ -504,7 +509,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 		}
 	} else {
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
+			      fnic->lport->fcpinit->shost,
 			      "Unexpected state %s while processing"
 			      " reset cmpl\n", fnic_state_to_str(fnic->state));
 		ret = -1;
@@ -554,19 +559,19 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 
 		/* Check flogi registration completion status */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 				      "flog reg succeeded\n");
 			fnic->state = FNIC_IN_FC_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
-				      fnic->lport->host,
+				      fnic->lport->fcpinit->shost,
 				      "fnic flogi reg :failed %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 			fnic->state = FNIC_IN_ETH_MODE;
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "Unexpected fnic state %s while"
 			      " processing flogi reg completion\n",
 			      fnic_state_to_str(fnic->state));
@@ -639,8 +644,11 @@ static inline void fnic_fcpio_ack_handler(struct fnic *fnic,
  * Routine to handle icmnd completions
  */
 static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
-					 struct fcpio_fw_req *desc)
+					  struct fcpio_fw_req *desc)
 {
+	struct fc_lport *lport = fnic->lport;
+	struct fcp_init *fcpinit = lport->fcpinit;
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
 	u8 type;
 	u8 hdr_status;
 	struct fcpio_tag tag;
@@ -659,7 +667,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	if (id >= FNIC_MAX_IO_REQ)
 		return;
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_host_find_tag(si->host, id);
 	WARN_ON_ONCE(!sc);
 	if (!sc)
 		return;
@@ -720,7 +728,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 					if (qd == -1)
 						qd = t_sdev->host->cmd_per_lun;
 					shost_printk(KERN_INFO,
-						     fnic->lport->host,
+						     si->host,
 						     "scsi[%d:%d:%d:%d"
 						     "] queue full detected,"
 						     "new depth = %d\n",
@@ -757,7 +765,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	case FCPIO_MSS_INVALID:      /* request was aborted due to mss error */
 	case FCPIO_FW_ERR:           /* request was terminated due fw error */
 	default:
-		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
+		shost_printk(KERN_ERR, si->host, "hdr status = %s\n",
 			     fnic_fcpio_status_to_str(hdr_status));
 		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
@@ -773,13 +781,13 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	mempool_free(io_req, fnic->io_req_pool);
 
 	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
-		fnic->lport->host_stats.fcp_input_requests++;
+		si->fcpinit_stats.fcp_input_requests++;
 		fnic->fcp_input_bytes += xfer_len;
 	} else if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		fnic->lport->host_stats.fcp_output_requests++;
+		si->fcpinit_stats.fcp_output_requests++;
 		fnic->fcp_output_bytes += xfer_len;
 	} else
-		fnic->lport->host_stats.fcp_control_requests++;
+		si->fcpinit_stats.fcp_control_requests++;
 
 	/* Call SCSI completion function to complete the IO */
 	if (sc->scsi_done)
@@ -791,8 +799,9 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
  * Routine to handle itmf completions
  */
 static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
-					struct fcpio_fw_req *desc)
+					 struct fcpio_fw_req *desc)
 {
+	struct Scsi_Host *shost = fnic->lport->fcpinit->shost;
 	u8 type;
 	u8 hdr_status;
 	struct fcpio_tag tag;
@@ -808,7 +817,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 	if ((id & FNIC_TAG_MASK) >= FNIC_MAX_IO_REQ)
 		return;
 
-	sc = scsi_host_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
+	sc = scsi_host_find_tag(shost, id & FNIC_TAG_MASK);
 	WARN_ON_ONCE(!sc);
 	if (!sc)
 		return;
@@ -832,7 +841,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_ABTS_STATUS(sc) = hdr_status;
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, shost,
 			      "abts cmpl recd. id %d status %s\n",
 			      (int)(id & FNIC_TAG_MASK),
 			      fnic_fcpio_status_to_str(hdr_status));
@@ -846,7 +855,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			complete(io_req->abts_done);
 			spin_unlock_irqrestore(io_lock, flags);
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			FNIC_SCSI_DBG(KERN_DEBUG, shost,
 				      "abts cmpl, completing IO\n");
 			CMD_SP(sc) = NULL;
 			sc->result = (DID_ERROR << 16);
@@ -863,7 +872,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		/* Completion of device reset */
 		CMD_LR_STATUS(sc) = hdr_status;
 		CMD_STATE(sc) = FNIC_IOREQ_CMD_COMPLETE;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, shost,
 			      "dev reset cmpl recd. id %d status %s\n",
 			      (int)(id & FNIC_TAG_MASK),
 			      fnic_fcpio_status_to_str(hdr_status));
@@ -872,7 +881,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		spin_unlock_irqrestore(io_lock, flags);
 
 	} else {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, shost,
 			     "Unexpected itmf io state %s tag %x\n",
 			     fnic_ioreq_state_to_str(CMD_STATE(sc)), id);
 		spin_unlock_irqrestore(io_lock, flags);
@@ -914,7 +923,7 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	default:
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "firmware completion type %d\n",
 			      desc->hdr.type);
 		break;
@@ -955,7 +964,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		if (i == exclude_id)
 			continue;
 
-		sc = scsi_host_find_tag(fnic->lport->host, i);
+		sc = scsi_host_find_tag(fnic->lport->fcpinit->shost, i);
 		if (!sc)
 			continue;
 
@@ -980,8 +989,8 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 
 cleanup_scsi_cmd:
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "fnic_cleanup_io:"
-			      " DID_TRANSPORT_DISRUPTED\n");
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
+			      "fnic_cleanup_io: DID_TRANSPORT_DISRUPTED\n");
 
 		/* Complete the command to SCSI */
 		if (sc->scsi_done)
@@ -1006,7 +1015,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	if (id >= FNIC_MAX_IO_REQ)
 		return;
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_host_find_tag(fnic->lport->fcpinit->shost, id);
 	if (!sc)
 		return;
 
@@ -1032,8 +1041,8 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 
 wq_copy_cleanup_scsi_cmd:
 	sc->result = DID_NO_CONNECT << 16;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
-		      " DID_NO_CONNECT\n");
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
+		      "wq_copy_cleanup_handler: DID_NO_CONNECT\n");
 
 	if (sc->scsi_done)
 		sc->scsi_done(sc);
@@ -1074,7 +1083,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	enum fnic_ioreq_state old_ioreq_state;
 
 	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
+		      fnic->lport->fcpinit->shost,
 		      "fnic_rport_reset_exch called portid 0x%06x\n",
 		      port_id);
 
@@ -1082,7 +1091,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		return;
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_host_find_tag(fnic->lport->fcpinit->shost, tag);
 		if (!sc)
 			continue;
 
@@ -1110,7 +1119,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 		BUG_ON(io_req->abts_done);
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "fnic_rport_reset_exch: Issuing abts\n");
 
 		spin_unlock_irqrestore(io_lock, flags);
@@ -1140,20 +1149,24 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 void fnic_terminate_rport_io(struct fc_rport *rport)
 {
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
+	struct fcp_init *fcpinit = lport->fcpinit;
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fnic *fnic = lport_priv(lport);
+	struct scsi_target *cmd_starget;
+	struct fcp_targ *cmd_fcptarg;
+	struct fc_rport *cmd_rport;
 	int tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	struct fc_lport *lport = rdata->local_port;
-	struct fnic *fnic = lport_priv(lport);
-	struct fc_rport *cmd_rport;
 	enum fnic_ioreq_state old_ioreq_state;
 
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host, "fnic_terminate_rport_io called"
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host,
+		      "fnic_terminate_rport_io called"
 		      " wwpn 0x%llx, wwnn0x%llx, portid 0x%06x\n",
 		      rport->port_name, rport->node_name,
 		      rport->port_id);
@@ -1162,11 +1175,13 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		return;
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_host_find_tag(si->host, tag);
 		if (!sc)
 			continue;
 
-		cmd_rport = starget_to_rport(scsi_target(sc->device));
+		cmd_starget = scsi_target(sc->device);
+		cmd_fcptarg = starget_to_fcptarg(cmd_starget);
+		cmd_rport = cmd_fcptarg->rport;
 		if (rport != cmd_rport)
 			continue;
 
@@ -1195,7 +1210,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		BUG_ON(io_req->abts_done);
 
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
+			      fnic->lport->fcpinit->shost,
 			      "fnic_terminate_rport_io: Issuing abts\n");
 
 		spin_unlock_irqrestore(io_lock, flags);
@@ -1230,10 +1245,14 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
  */
 int fnic_abort_cmd(struct scsi_cmnd *sc)
 {
-	struct fc_lport *lp;
-	struct fnic *fnic;
+	struct scsi_target *starget = scsi_target(sc->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+	struct fcp_init *fcpinit = shost_priv(sc->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lp = si->lport;
+	struct fnic *fnic = lport_priv(lp);
 	struct fnic_io_req *io_req;
-	struct fc_rport *rport;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	int ret = SUCCESS;
@@ -1242,16 +1261,11 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
-
-	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	fcp_block_scsi_eh(sc);
 
-	fnic = lport_priv(lp);
-	rport = starget_to_rport(scsi_target(sc->device));
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
-			rport->port_id, sc->device->lun, sc->request->tag);
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host,
+		      "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
+		      rport->port_id, sc->device->lun, sc->request->tag);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
 		ret = FAILED;
@@ -1363,7 +1377,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	mempool_free(io_req, fnic->io_req_pool);
 
 fnic_abort_cmd_end:
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host,
 		      "Returning from abort cmd %s\n",
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -1423,7 +1437,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_host_find_tag(fnic->lport->fcpinit->shost, tag);
 		/*
 		 * ignore this lun reset cmd or cmds that do not belong to
 		 * this lun
@@ -1445,7 +1459,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 * Found IO that is still pending with firmware and
 		 * belongs to the LUN that we are resetting
 		 */
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 			      "Found IO in %s on lun\n",
 			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
@@ -1509,10 +1523,14 @@ clean_pending_aborts_end:
  */
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
-	struct fc_lport *lp;
+	struct scsi_target *starget = scsi_target(sc->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+	struct fcp_init *fcpinit = shost_priv(sc->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lp = si->lport;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req;
-	struct fc_rport *rport;
 	int status;
 	int ret = FAILED;
 	spinlock_t *io_lock;
@@ -1520,17 +1538,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
-
-	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	fcp_block_scsi_eh(sc);
 
 	fnic = lport_priv(lp);
 
-	rport = starget_to_rport(scsi_target(sc->device));
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"Device reset called FCID 0x%x, LUN 0x%x\n",
-			rport->port_id, sc->device->lun);
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host,
+		      "Device reset called FCID 0x%x, LUN 0x%x\n",
+		      rport->port_id, sc->device->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
@@ -1562,7 +1576,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %d\n",
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host, "TAG %d\n",
 		      sc->request->tag);
 
 	/*
@@ -1600,7 +1614,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * gets cleaned up during higher levels of EH
 	 */
 	if (status == FCPIO_INVALID_CODE) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, si->host,
 			      "Device reset timed out\n");
 		goto fnic_device_reset_end;
 	}
@@ -1608,8 +1622,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	/* Completed, but not successful, clean up the io_req, return fail */
 	if (status != FCPIO_SUCCESS) {
 		spin_lock_irqsave(io_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, si->host,
 			      "Device reset completed - failed\n");
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		goto fnic_device_reset_clean;
@@ -1625,7 +1638,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, si->host,
 			      "Device reset failed"
 			      " since could not abort all IOs\n");
 		goto fnic_device_reset_clean;
@@ -1650,7 +1663,7 @@ fnic_device_reset_clean:
 	}
 
 fnic_device_reset_end:
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	FNIC_SCSI_DBG(KERN_DEBUG, si->host,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -1658,16 +1671,12 @@ fnic_device_reset_end:
 }
 
 /* Clean up all IOs, clean up libFC local port */
-int fnic_reset(struct Scsi_Host *shost)
+int fnic_fcvport_reset(struct fc_vport *fcvport)
 {
-	struct fc_lport *lp;
-	struct fnic *fnic;
+	struct fc_lport *lp = fc_vport_priv(fcvport);
 	int ret = SUCCESS;
 
-	lp = shost_priv(shost);
-	fnic = lport_priv(lp);
-
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	FNIC_SCSI_DBG(KERN_DEBUG, lp->fcpinit->shost,
 		      "fnic_reset called\n");
 
 	/*
@@ -1677,7 +1686,7 @@ int fnic_reset(struct Scsi_Host *shost)
 	if (lp->tt.lport_reset(lp))
 		ret = FAILED;
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	FNIC_SCSI_DBG(KERN_DEBUG, lp->fcpinit->shost,
 		      "Returning from fnic reset %s\n",
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -1696,17 +1705,19 @@ int fnic_reset(struct Scsi_Host *shost)
  */
 int fnic_host_reset(struct scsi_cmnd *sc)
 {
+	struct fcp_init *fcpinit = shost_priv(sc->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lp = si->lport;
+	struct fc_vport *fcvport = lport_to_fcvport(lp);
 	int ret;
 	unsigned long wait_host_tmo;
-	struct Scsi_Host *shost = sc->device->host;
-	struct fc_lport *lp = shost_priv(shost);
 
 	/*
 	 * If fnic_reset is successful, wait for fabric login to complete
 	 * scsi-ml tries to send a TUR to every device if host reset is
 	 * successful, so before returning to scsi, fabric should be up
 	 */
-	ret = fnic_reset(shost);
+	ret = fnic_fcvport_reset(fcvport);
 	if (ret == SUCCESS) {
 		wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
 		ret = FAILED;
@@ -1758,7 +1769,7 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->remove_wait = NULL;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->fcpinit->shost,
 		      "fnic_scsi_abort_io %s\n",
 		      (fnic->state == FNIC_IN_ETH_MODE) ?
 		      "SUCCESS" : "FAILED");


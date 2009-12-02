From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/3] qla2xxx: Queue depth ramp up/down modification changes.
Date: Wed,  2 Dec 2009 10:36:54 -0800
Message-ID: <1259779016-1762-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45734 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752839AbZLBSm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 13:42:59 -0500
In-Reply-To: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Removed the module parameters ql2xqfulltracking and ql2xqfullrampup
since the queue depth ramp up/down functionality is moved to scsi-ml.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 -
 drivers/scsi/qla2xxx/qla_gbl.h |    2 -
 drivers/scsi/qla2xxx/qla_isr.c |   92 ----------------------------------------
 drivers/scsi/qla2xxx/qla_os.c  |   69 ++++++++++++++++++++++--------
 4 files changed, 51 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6b9bf23..7a81e98 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1570,9 +1570,6 @@ typedef struct fc_port {
 	struct fc_rport *rport, *drport;
 	u32 supported_classes;
 
-	unsigned long last_queue_full;
-	unsigned long last_ramp_up;
-
 	uint16_t vp_idx;
 } fc_port_t;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e218513..0b6801f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,8 +72,6 @@ extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
-extern int ql2xqfullrampup;
-extern int ql2xqfulltracking;
 extern int ql2xiidmaenable;
 extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8049873..bc07d83 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -811,78 +811,6 @@ skip_rio:
 		qla2x00_alert_all_vps(rsp, mb);
 }
 
-static void
-qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
-{
-	fc_port_t *fcport = data;
-	struct scsi_qla_host *vha = fcport->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = NULL;
-
-	if (!ql2xqfulltracking)
-		return;
-
-	req = vha->req;
-	if (!req)
-		return;
-	if (req->max_q_depth <= sdev->queue_depth)
-		return;
-
-	if (sdev->ordered_tags)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
-		    sdev->queue_depth + 1);
-	else
-		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
-		    sdev->queue_depth + 1);
-
-	fcport->last_ramp_up = jiffies;
-
-	DEBUG2(qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-up to %d.\n",
-	    fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
-	    sdev->queue_depth));
-}
-
-static void
-qla2x00_adjust_sdev_qdepth_down(struct scsi_device *sdev, void *data)
-{
-	fc_port_t *fcport = data;
-
-	if (!scsi_track_queue_full(sdev, sdev->queue_depth - 1))
-		return;
-
-	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
-	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
-	    fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
-	    sdev->queue_depth));
-}
-
-static inline void
-qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, struct req_que *req,
-								srb_t *sp)
-{
-	fc_port_t *fcport;
-	struct scsi_device *sdev;
-
-	if (!ql2xqfulltracking)
-		return;
-
-	sdev = sp->cmd->device;
-	if (sdev->queue_depth >= req->max_q_depth)
-		return;
-
-	fcport = sp->fcport;
-	if (time_before(jiffies,
-	    fcport->last_ramp_up + ql2xqfullrampup * HZ))
-		return;
-	if (time_before(jiffies,
-	    fcport->last_queue_full + ql2xqfullrampup * HZ))
-		return;
-
-	starget_for_each_device(sdev->sdev_target, fcport,
-	    qla2x00_adjust_sdev_qdepth_up);
-}
-
 /**
  * qla2x00_process_completed_request() - Process a Fast Post response.
  * @ha: SCSI driver HA context
@@ -913,8 +841,6 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
-
-		qla2x00_ramp_up_queue_depth(vha, req, sp);
 		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld) Req:%d: Invalid ISP SCSI completion"
@@ -1435,13 +1361,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			    "scsi(%ld): QUEUE FULL status detected "
 			    "0x%x-0x%x.\n", vha->host_no, comp_status,
 			    scsi_status));
-
-			/* Adjust queue depth for all luns on the port. */
-			if (!ql2xqfulltracking)
-				break;
-			fcport->last_queue_full = jiffies;
-			starget_for_each_device(cp->device->sdev_target,
-			    fcport, qla2x00_adjust_sdev_qdepth_down);
 			break;
 		}
 		if (lscsi_status != SS_CHECK_CONDITION)
@@ -1516,17 +1435,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				    "scsi(%ld): QUEUE FULL status detected "
 				    "0x%x-0x%x.\n", vha->host_no, comp_status,
 				    scsi_status));
-
-				/*
-				 * Adjust queue depth for all luns on the
-				 * port.
-				 */
-				if (!ql2xqfulltracking)
-					break;
-				fcport->last_queue_full = jiffies;
-				starget_for_each_device(
-				    cp->device->sdev_target, fcport,
-				    qla2x00_adjust_sdev_qdepth_down);
 				break;
 			}
 			if (lscsi_status != SS_CHECK_CONDITION)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 58edc0d..2f873d2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -78,21 +78,6 @@ module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
 
-int ql2xqfulltracking = 1;
-module_param(ql2xqfulltracking, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xqfulltracking,
-		"Controls whether the driver tracks queue full status "
-		"returns and dynamically adjusts a scsi device's queue "
-		"depth.  Default is 1, perform tracking.  Set to 0 to "
-		"disable dynamic tracking and adjustment of queue depth.");
-
-int ql2xqfullrampup = 120;
-module_param(ql2xqfullrampup, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(ql2xqfullrampup,
-		"Number of seconds to wait to begin to ramp-up the queue "
-		"depth for a device after a queue-full condition has been "
-		"detected.  Default is 120 seconds.");
-
 int ql2xiidmaenable=1;
 module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xiidmaenable,
@@ -1217,13 +1202,61 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
+static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
+{
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
+
+	if (!scsi_track_queue_full(sdev, qdepth))
+		return;
+
+	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
+		"scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
+		fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
+		sdev->queue_depth));
+}
+
+static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
+{
+	fc_port_t *fcport = sdev->hostdata;
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = NULL;
+
+	req = vha->req;
+	if (!req)
+		return;
+
+	if (req->max_q_depth <= sdev->queue_depth || req->max_q_depth < qdepth)
+		return;
+
+	if (sdev->ordered_tags)
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, qdepth);
+	else
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
+
+	DEBUG2(qla_printk(KERN_INFO, ha,
+	       "scsi(%ld:%d:%d:%d): Queue depth adjusted-up to %d.\n",
+	       fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
+	       sdev->queue_depth));
+}
+
 static int
 qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		qla2x00_handle_queue_full(sdev, qdepth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
+		break;
+	default:
+		return EOPNOTSUPP;
+	}
 
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
 
-- 
1.6.2.rc1.30.gd43c


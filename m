From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 4/4] drivers: convert fc drivers calling scsi_track_queue_full
Date: Tue, 19 May 2009 00:52:47 -0500
Message-ID: <1242712370737-git-send-email-michaelc@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
 <12427123683166-git-send-email-michaelc@cs.wisc.edu>
 <1242712369913-git-send-email-michaelc@cs.wisc.edu>
 <12427123692457-git-send-email-michaelc@cs.wisc.edu>
 <1242712370448-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZESFww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:52 -0400
In-Reply-To: <1242712370448-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts the fc drivers that were using scsi_track_queue_full
to track the queue full from the change_queue_depth callback.

I have not yet tested the qla2xxx or lpfc parts.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_fcp.c    |   28 ++++++---------
 drivers/scsi/lpfc/lpfc_scsi.c  |   75 ++++++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_isr.c |   28 ---------------
 drivers/scsi/qla2xxx/qla_os.c  |   29 ++++++++++++++-
 include/scsi/libfc.h           |    2 +-
 5 files changed, 80 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 521f996..5b10f37 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1848,21 +1848,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			sc_cmd->result = DID_OK << 16;
 			if (fsp->scsi_resid)
 				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
-		} else if (fsp->cdb_status == QUEUE_FULL) {
-			struct scsi_device *tmp_sdev;
-			struct scsi_device *sdev = sc_cmd->device;
-
-			shost_for_each_device(tmp_sdev, sdev->host) {
-				if (tmp_sdev->id != sdev->id)
-					continue;
-
-				if (tmp_sdev->queue_depth > 1) {
-					scsi_track_queue_full(tmp_sdev,
-							      tmp_sdev->
-							      queue_depth - 1);
-				}
-			}
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
 		} else {
 			/*
 			 * transport level I/O was ok but scsi
@@ -2090,9 +2075,18 @@ int fc_slave_alloc(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(fc_slave_alloc);
 
-int fc_change_queue_depth(struct scsi_device *sdev, int qdepth)
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	switch (reason) {
+	case SCSI_QDEPTH_SYSFS_REQ:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, qdepth);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(fc_change_queue_depth);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 167b66d..f0c9904 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1694,7 +1694,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	int result;
 	struct scsi_device *tmp_sdev;
-	int depth = 0;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost = cmd->device->host;
@@ -1893,39 +1892,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	}
 
 	/*
-	 * Check for queue full.  If the lun is reporting queue full, then
-	 * back off the lun queue depth to prevent target overloads.
-	 */
-	if (result == SAM_STAT_TASK_SET_FULL && pnode &&
-	    NLP_CHK_NODE_ACT(pnode)) {
-		pnode->last_q_full_time = jiffies;
-
-		shost_for_each_device(tmp_sdev, shost) {
-			if (tmp_sdev->id != scsi_id)
-				continue;
-			depth = scsi_track_queue_full(tmp_sdev,
-					tmp_sdev->queue_depth - 1);
-		}
-		/*
-		 * The queue depth cannot be lowered any more.
-		 * Modify the returned error code to store
-		 * the final depth value set by
-		 * scsi_track_queue_full.
-		 */
-		if (depth == -1)
-			depth = shost->cmd_per_lun;
-
-		if (depth) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
-					 "0711 detected queue full - lun queue "
-					 "depth adjusted to %d.\n", depth);
-			lpfc_send_sdev_queuedepth_change_event(phba, vport,
-				pnode, 0xFFFFFFFF,
-				depth+1, depth);
-		}
-	}
-
-	/*
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
 	 */
@@ -2922,6 +2888,45 @@ lpfc_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static int lpfc_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				   int reason)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_rport_data *rdata = sdev->hostdata;
+	struct lpfc_nodelist *pnode = rdata->pnode;
+	int depth;
+
+	if (reason != SCSI_QDEPTH_QFULL)
+		return -EOPNOTSUPP;
+
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+		return -EINVAL;
+
+	pnode->last_q_full_time = jiffies;
+
+	depth = scsi_track_queue_full(sdev, queue_depth);
+	/*
+	 * The queue depth cannot be lowered any more.
+	 * Modify the returned error code to store
+	 * the final depth value set by
+	 * scsi_track_queue_full.
+	 */
+	if (depth == -1)
+		depth = shost->cmd_per_lun;
+
+	if (depth) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+				 "0711 detected queue full - lun queue "
+				 "depth adjusted to %d.\n", depth);
+		lpfc_send_sdev_queuedepth_change_event(phba, vport,
+						       pnode, 0xFFFFFFFF,
+						       depth + 1, depth);
+	}
+	return sdev->queue_depth;
+}
+
 /**
  * lpfc_slave_destroy - slave_destroy entry point of SHT data structure
  * @sdev: Pointer to scsi_device.
@@ -2944,6 +2949,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler= lpfc_device_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.change_queue_depth	= lpfc_change_queue_depth,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
@@ -2964,6 +2970,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler= lpfc_device_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.change_queue_depth	= lpfc_change_queue_depth,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d049818..fd359b3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -787,20 +787,6 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 	    sdev->queue_depth));
 }
 
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
 static inline void
 qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, struct req_que *req,
 								srb_t *sp)
@@ -1119,11 +1105,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			    "scsi(%ld): QUEUE FULL status detected "
 			    "0x%x-0x%x.\n", vha->host_no, comp_status,
 			    scsi_status));
-
-			/* Adjust queue depth for all luns on the port. */
-			fcport->last_queue_full = jiffies;
-			starget_for_each_device(cp->device->sdev_target,
-			    fcport, qla2x00_adjust_sdev_qdepth_down);
 			break;
 		}
 		if (lscsi_status != SS_CHECK_CONDITION)
@@ -1174,15 +1155,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				    "scsi(%ld): QUEUE FULL status detected "
 				    "0x%x-0x%x.\n", vha->host_no, comp_status,
 				    scsi_status));
-
-				/*
-				 * Adjust queue depth for all luns on the
-				 * port.
-				 */
-				fcport->last_queue_full = jiffies;
-				starget_for_each_device(
-				    cp->device->sdev_target, fcport,
-				    qla2x00_adjust_sdev_qdepth_down);
 				break;
 			}
 			if (lscsi_status != SS_CHECK_CONDITION)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e4fdcda..e9af1bc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1141,10 +1141,35 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
+static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
+{
+	fc_port_t *fcport = (struct fc_port *) sdev->device->hostdata;
+
+	fcport->last_queue_full = jiffies;
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
 static int
-qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth)
+qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	switch (reason) {
+	case SCSI_QDEPTH_SYSFS_REQ:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		qla2x00_handle_queue_full(sdev, qdepth);
+		break;
+	default:
+		return EOPNOTSUPP;
+	}
+
 	return sdev->queue_depth;
 }
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 45f9cc6..ae1a07f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -868,7 +868,7 @@ int fc_slave_alloc(struct scsi_device *sdev);
 /*
  * Adjust the queue depth.
  */
-int fc_change_queue_depth(struct scsi_device *sdev, int qdepth);
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason);
 
 /*
  * Change the tag type.
-- 
1.6.0.6


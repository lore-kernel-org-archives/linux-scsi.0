From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 04/10] drivers: convert fc drivers calling
	scsi_track_queue_full
Date: Thu, 03 Sep 2009 15:22:47 -0700
Message-ID: <20090903222247.24946.60577.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52072 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbZICWWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:45 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts the fc drivers that were using scsi_track_queue_full
to track the queue full from the change_queue_depth callback.

I have not yet tested the qla2xxx or lpfc parts.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--
Adds check to ignore SCSI_QDEPTH_QFULL in case the
ql2xqfulltracking is not set.
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c    |   26 +++++---------
 drivers/scsi/lpfc/lpfc_scsi.c  |   75 ++++++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_isr.c |   32 -----------------
 drivers/scsi/qla2xxx/qla_os.c  |   30 ++++++++++++++--
 4 files changed, 77 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 20b88cd..d919c2a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1814,21 +1814,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
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
@@ -2064,9 +2049,16 @@ EXPORT_SYMBOL(fc_slave_alloc);
 
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, qdepth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	}
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(fc_change_queue_depth);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 61d0897..2d39d84 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2189,7 +2189,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	int result;
 	struct scsi_device *tmp_sdev;
-	int depth = 0;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost = cmd->device->host;
@@ -2388,39 +2387,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
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
@@ -3551,6 +3517,45 @@ lpfc_slave_configure(struct scsi_device *sdev)
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
@@ -3574,6 +3579,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.change_queue_depth	= lpfc_change_queue_depth,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
@@ -3596,6 +3602,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.change_queue_depth	= lpfc_change_queue_depth,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 74fa6f9..66fda3a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -836,20 +836,6 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
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
@@ -1176,13 +1162,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
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
@@ -1233,17 +1212,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
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
index c05c460..9652aac 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1222,12 +1222,36 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
+static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
+{
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
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
 qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		if (!ql2xqfulltracking)
+			qla2x00_handle_queue_full(sdev, qdepth);
+		break;
+	default:
+		return EOPNOTSUPP;
+	}
+
 	return sdev->queue_depth;
 }
 


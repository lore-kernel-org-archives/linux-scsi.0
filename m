From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/35] zfcp: use scsi device as argument for zfcp_task_mgmt_function()
Date: Fri, 23 Jun 2017 15:02:52 +0200
Message-ID: <1498222975-71858-33-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32870 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754195AbdFWNDa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:30 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

zfcp_task_mgmt_function() is only used for lun and device reset,
so it should be using the scsi device as an argument, not the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/s390/scsi/zfcp_ext.h  |  2 +-
 drivers/s390/scsi/zfcp_fc.h   |  9 +--------
 drivers/s390/scsi/zfcp_fsf.c  | 21 +++++++++++----------
 drivers/s390/scsi/zfcp_scsi.c | 12 ++++++------
 4 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 57f1d4a..64d4db7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -117,7 +117,7 @@ extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
 			     struct zfcp_fsf_ct_els *, unsigned int);
 extern int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
-extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *, u8);
+extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *, u8);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index df2b541..f08eaf9 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -206,19 +206,12 @@ struct zfcp_fc_wka_ports {
  * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
  * @fcp: fcp_cmnd to setup
  * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
- * @tm: task management flags to setup task management command
  */
 static inline
-void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
-			 u8 tm_flags)
+void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
 {
 	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
 
-	if (unlikely(tm_flags)) {
-		fcp->fc_tm_flags = tm_flags;
-		return;
-	}
-
 	fcp->fc_pri_ta = FCP_PTA_SIMPLE;
 
 	if (scsi->sc_data_direction == DMA_FROM_DEVICE)
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 27ff38f..c4bd3d4 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2036,10 +2036,9 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 			    sizeof(blktrc));
 }
 
-static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
+static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req,
+					struct scsi_device *sdev)
 {
-	struct scsi_cmnd *scmnd = req->data;
-	struct scsi_device *sdev = scmnd->device;
 	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
@@ -2120,7 +2119,7 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	zfcp_fsf_fcp_handler_common(req);
+	zfcp_fsf_fcp_handler_common(req, scpnt->device);
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
@@ -2256,7 +2255,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 		goto failed_scsi_cmnd;
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
-	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd, 0);
+	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
 	if (scsi_prot_sg_count(scsi_cmnd)) {
 		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
@@ -2296,8 +2295,9 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
 {
 	struct fcp_resp_with_ext *fcp_rsp;
 	struct fcp_resp_rsp_info *rsp_info;
+	struct scsi_device *sdev = req->data;
 
-	zfcp_fsf_fcp_handler_common(req);
+	zfcp_fsf_fcp_handler_common(req, sdev);
 
 	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
 	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
@@ -2313,12 +2313,12 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
  * @tm_flags: unsigned byte for task management flags
  * Returns: on success pointer to struct fsf_req, NULL otherwise
  */
-struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
+struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 					    u8 tm_flags)
 {
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd *fcp_cmnd;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
 
 	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
@@ -2338,7 +2338,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 		goto out;
 	}
 
-	req->data = scmnd;
+	req->data = sdev;
 	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
@@ -2349,7 +2349,8 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
-	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
+	int_to_scsilun(sdev->lun, (struct scsi_lun *)&fcp_cmnd->fc_lun);
+	fcp_cmnd->fc_tm_flags = tm_flags;
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 5fada93..dd7bea0 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -259,17 +259,17 @@ static void zfcp_scsi_forget_cmnds(struct zfcp_scsi_dev *zsdev, u8 tm_flags)
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 }
 
-static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
+static int zfcp_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
-	struct fc_port *rport = zfcp_sdev->port->rport;
+	struct fc_rport *rport = zfcp_sdev->port->rport;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
 
 	while (retry--) {
-		fsf_req = zfcp_fsf_fcp_task_mgmt(scpnt, tm_flags);
+		fsf_req = zfcp_fsf_fcp_task_mgmt(sdev, tm_flags);
 		if (fsf_req)
 			break;
 
@@ -306,12 +306,12 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_TMF_LUN_RESET);
+	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
 }
 
 static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
+	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_TGT_RESET);
 }
 
 static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
-- 
1.8.5.6

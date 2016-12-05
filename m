From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 03/12] be2iscsi: Take iscsi_task ref in abort handler
Date: Mon,  5 Dec 2016 13:36:42 +0530
Message-ID: <1480925211-13223-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33158 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:12 -0500
Received: by mail-qk0-f180.google.com with SMTP id x190so338335302qkb.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:11 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Hold the reference of iscsi_task till invalidation completes.
This prevents use of ICD when invalidation of that ICD is being processed.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 45 +++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d86de5d..6eaa78bd 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -218,47 +218,40 @@ static int beiscsi_slave_configure(struct scsi_device *sdev)
 
 static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 {
+	struct iscsi_task *abrt_task = (struct iscsi_task *)sc->SCp.ptr;
 	struct iscsi_cls_session *cls_session;
-	struct iscsi_task *aborted_task = (struct iscsi_task *)sc->SCp.ptr;
-	struct beiscsi_io_task *aborted_io_task;
-	struct iscsi_conn *conn;
+	struct beiscsi_io_task *abrt_io_task;
 	struct beiscsi_conn *beiscsi_conn;
-	struct beiscsi_hba *phba;
 	struct iscsi_session *session;
 	struct invldt_cmd_tbl inv_tbl;
-	unsigned int cid;
+	struct beiscsi_hba *phba;
+	struct iscsi_conn *conn;
 	int rc;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (!aborted_task || !aborted_task->sc) {
-		/* we raced */
-		spin_unlock_bh(&session->frwd_lock);
-		return SUCCESS;
-	}
-
-	aborted_io_task = aborted_task->dd_data;
-	if (!aborted_io_task->scsi_cmnd) {
-		/* raced or invalid command */
-		spin_unlock_bh(&session->frwd_lock);
+	/* check if we raced, task just got cleaned up under us */
+	spin_lock_bh(&session->back_lock);
+	if (!abrt_task || !abrt_task->sc) {
+		spin_unlock_bh(&session->back_lock);
 		return SUCCESS;
 	}
-	spin_unlock_bh(&session->frwd_lock);
-
-	conn = aborted_task->conn;
+	/* get a task ref till FW processes the req for the ICD used */
+	__iscsi_get_task(abrt_task);
+	abrt_io_task = abrt_task->dd_data;
+	conn = abrt_task->conn;
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
-	/* Invalidate WRB Posted for this Task */
+	/* mark WRB invalid which have been not processed by FW yet */
 	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-		      aborted_io_task->pwrb_handle->pwrb,
-		      1);
-	/* invalidate iocb */
-	cid = beiscsi_conn->beiscsi_conn_cid;
-	inv_tbl.cid = cid;
-	inv_tbl.icd = aborted_io_task->psgl_handle->sgl_index;
+		      abrt_io_task->pwrb_handle->pwrb, 1);
+	inv_tbl.cid = beiscsi_conn->beiscsi_conn_cid;
+	inv_tbl.icd = abrt_io_task->psgl_handle->sgl_index;
+	spin_unlock_bh(&session->back_lock);
+
 	rc = beiscsi_mgmt_invalidate_icds(phba, &inv_tbl, 1);
+	iscsi_put_task(abrt_task);
 	if (rc) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
 			    "BM_%d : sc %p invalidation failed %d\n",
-- 
1.8.3.1


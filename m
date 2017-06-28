From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/47] zfcp: do not rely on scsi command for debugging message
Date: Wed, 28 Jun 2017 10:32:49 +0200
Message-ID: <1498638793-44672-24-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751681AbdF1IdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:22 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When generating debugging messages the code should not rely on
a scsi command to be present.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/s390/scsi/zfcp_dbf.c  | 28 ++++++++++++++--------------
 drivers/s390/scsi/zfcp_dbf.h  | 10 +++++++---
 drivers/s390/scsi/zfcp_ext.h  |  4 ++--
 drivers/s390/scsi/zfcp_scsi.c |  9 ++++++---
 4 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index d5bf36e..f825a30 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -535,11 +535,10 @@ void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
  * @sc: pointer to struct scsi_cmnd
  * @fsf: pointer to struct zfcp_fsf_req
  */
-void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
-		   struct zfcp_fsf_req *fsf)
+void zfcp_dbf_scsi(struct zfcp_adapter *adapter, char *tag, int level,
+		   int scsi_id, u64 scsi_lun,
+		   struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf)
 {
-	struct zfcp_adapter *adapter =
-		(struct zfcp_adapter *) sc->device->host->hostdata[0];
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_scsi *rec = &dbf->scsi_buf;
 	struct fcp_resp_with_ext *fcp_rsp;
@@ -551,17 +550,18 @@ void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
 
 	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
 	rec->id = ZFCP_DBF_SCSI_CMND;
-	rec->scsi_result = sc->result;
-	rec->scsi_retries = sc->retries;
-	rec->scsi_allowed = sc->allowed;
-	rec->scsi_id = sc->device->id;
+	rec->scsi_id = scsi_id;
 	/* struct zfcp_dbf_scsi needs to be updated to handle 64bit LUNs */
-	rec->scsi_lun = (u32)sc->device->lun;
-	rec->host_scribble = (unsigned long)sc->host_scribble;
-
-	memcpy(rec->scsi_opcode, sc->cmnd,
-	       min((int)sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
-
+	rec->scsi_lun = (u32)scsi_lun;
+	if (sc) {
+		rec->scsi_result = sc->result;
+		rec->scsi_retries = sc->retries;
+		rec->scsi_allowed = sc->allowed;
+		rec->host_scribble = (unsigned long)sc->host_scribble;
+
+		memcpy(rec->scsi_opcode, sc->cmnd,
+		       min((int)sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
+	}
 	if (fsf) {
 		rec->fsf_req_id = fsf->req_id;
 		fcp_rsp = (struct fcp_resp_with_ext *)
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index db186d4..09a9524 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -352,7 +352,8 @@ void _zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *scmd,
 					scmd->device->host->hostdata[0];
 
 	if (debug_level_enabled(adapter->dbf->scsi, level))
-		zfcp_dbf_scsi(tag, level, scmd, req);
+		zfcp_dbf_scsi(adapter, tag, level, scmd->device->id,
+			      scmd->device->lun, scmd, req);
 }
 
 /**
@@ -401,17 +402,20 @@ void zfcp_dbf_scsi_abort(char *tag, struct scsi_cmnd *scmd,
  * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
  */
 static inline
-void zfcp_dbf_scsi_devreset(char *tag, struct scsi_cmnd *scmnd, u8 flag)
+void zfcp_dbf_scsi_devreset(struct zfcp_adapter *adapter, char *tag,
+			    int id, u64 lun, u8 flag)
 {
 	char tmp_tag[ZFCP_DBF_TAG_LEN];
 
+	if (!debug_level_enabled(adapter->dbf->scsi, 1))
+		return;
 	if (flag == FCP_TMF_TGT_RESET)
 		memcpy(tmp_tag, "tr_", 3);
 	else
 		memcpy(tmp_tag, "lr_", 3);
 
 	memcpy(&tmp_tag[3], tag, 4);
-	_zfcp_dbf_scsi(tmp_tag, 1, scmnd, NULL);
+	zfcp_dbf_scsi(adapter, tmp_tag, 1, id, lun, NULL, NULL);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 9afdbc3..57f1d4a 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -47,8 +47,8 @@ extern void zfcp_dbf_rec_run_lvl(int level, char *tag,
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_in_els(char *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_scsi(char *, int, struct scsi_cmnd *,
-			  struct zfcp_fsf_req *);
+extern void zfcp_dbf_scsi(struct zfcp_adapter *, char *, int, int,
+			  u64, struct scsi_cmnd *, struct zfcp_fsf_req *);
 
 /* zfcp_erp.c */
 extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index e3160fc..5fada93 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -280,7 +280,8 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_dbf_scsi_devreset("nres", scpnt, tm_flags);
+			zfcp_dbf_scsi_devreset(adapter, "nres", sdev->id,
+					       sdev->lun, tm_flags);
 			return SUCCESS;
 		}
 	}
@@ -290,10 +291,12 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 	wait_for_completion(&fsf_req->completion);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
-		zfcp_dbf_scsi_devreset("fail", scpnt, tm_flags);
+		zfcp_dbf_scsi_devreset(adapter, "fail", sdev->id,
+				       sdev->lun, tm_flags);
 		retval = FAILED;
 	} else {
-		zfcp_dbf_scsi_devreset("okay", scpnt, tm_flags);
+		zfcp_dbf_scsi_devreset(adapter, "okay", sdev->id,
+				       sdev->lun, tm_flags);
 		zfcp_scsi_forget_cmnds(zfcp_sdev, tm_flags);
 	}
 
-- 
1.8.5.6

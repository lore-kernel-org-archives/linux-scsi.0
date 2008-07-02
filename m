From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/11] zfcp: Move status accessors from zfcp to SCSI include file.
Date: Wed, 02 Jul 2008 10:56:35 +0200
Message-ID: <20080702085950.136709000@de.ibm.com>
References: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:6146 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbYGBJAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 05:00:41 -0400
Content-Disposition: inline; filename=zfcp_scsi_set_byte.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

Move the accessor functions for the scsi_cmnd status from zfcp to the
SCSI include file. Change the interface to the functions to pass the
scsi_cmnd pointer instead of the status pointer.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  |    2 --
 drivers/s390/scsi/zfcp_fsf.c  |   20 ++++++++++----------
 drivers/s390/scsi/zfcp_scsi.c |   24 +-----------------------
 include/scsi/scsi.h           |   17 +++++++++++++++++
 4 files changed, 28 insertions(+), 35 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:27:00.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:27:13.000000000 +0200
@@ -103,8 +103,6 @@ extern int  zfcp_adapter_scsi_register(s
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
 extern void zfcp_set_fcp_dl(struct fcp_cmnd_iu *, fcp_dl_t);
 extern char *zfcp_get_fcp_rsp_info_ptr(struct fcp_rsp_iu *);
-extern void set_host_byte(int *, char);
-extern void set_driver_byte(int *, char);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
 extern fcp_dl_t zfcp_get_fcp_dl(struct fcp_cmnd_iu *);
 
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-07-02 10:19:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-07-02 10:27:13.000000000 +0200
@@ -107,28 +107,6 @@ zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_
 	*zfcp_get_fcp_dl_ptr(fcp_cmd) = fcp_dl;
 }
 
-/*
- * note: it's a bit-or operation not an assignment
- * regarding the specified byte
- */
-static inline void
-set_byte(int *result, char status, char pos)
-{
-	*result |= status << (pos * 8);
-}
-
-void
-set_host_byte(int *result, char status)
-{
-	set_byte(result, status, 2);
-}
-
-void
-set_driver_byte(int *result, char status)
-{
-	set_byte(result, status, 3);
-}
-
 static int
 zfcp_scsi_slave_alloc(struct scsi_device *sdp)
 {
@@ -196,7 +174,7 @@ zfcp_scsi_slave_configure(struct scsi_de
 static void
 zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
-	set_host_byte(&scpnt->result, result);
+	set_host_byte(scpnt, result);
 	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
 		zfcp_scsi_dbf_event_result("fail", 4,
 			(struct zfcp_adapter*) scpnt->device->host->hostdata[0],
--- a/include/scsi/scsi.h	2008-07-02 10:19:22.000000000 +0200
+++ b/include/scsi/scsi.h	2008-07-02 10:27:13.000000000 +0200
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <scsi/scsi_cmnd.h>
 
 /*
  * The maximum number of SG segments that we will put inside a
@@ -425,6 +426,22 @@ struct scsi_lun {
 #define driver_byte(result) (((result) >> 24) & 0xff)
 #define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
 
+static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
+{
+	cmd->result |= status << 8;
+}
+
+static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
+{
+	cmd->result |= status << 16;
+}
+
+static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
+{
+	cmd->result |= status << 24;
+}
+
+
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
 #define sense_valid(sense)  ((sense) & 0x80);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-07-02 10:19:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-07-02 10:27:13.000000000 +0200
@@ -3040,18 +3040,18 @@ zfcp_fsf_send_fcp_command_task_handler(s
 		 *        DID_SOFT_ERROR by retrying the request for devices
 		 *        that allow retries.
 		 */
-		set_host_byte(&scpnt->result, DID_SOFT_ERROR);
-		set_driver_byte(&scpnt->result, SUGGEST_RETRY);
+		set_host_byte(scpnt, DID_SOFT_ERROR);
+		set_driver_byte(scpnt, SUGGEST_RETRY);
 		goto skip_fsfstatus;
 	}
 
 	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		set_host_byte(&scpnt->result, DID_ERROR);
+		set_host_byte(scpnt, DID_ERROR);
 		goto skip_fsfstatus;
 	}
 
 	/* set message byte of result in SCSI command */
-	scpnt->result |= COMMAND_COMPLETE << 8;
+	set_msg_byte(scpnt, COMMAND_COMPLETE);
 
 	/*
 	 * copy SCSI status code of FCP_STATUS of FCP_RSP IU to status byte
@@ -3067,23 +3067,23 @@ zfcp_fsf_send_fcp_command_task_handler(s
 		switch (fcp_rsp_info[3]) {
 		case RSP_CODE_GOOD:
 			/* ok, continue */
-			set_host_byte(&scpnt->result, DID_OK);
+			set_host_byte(scpnt, DID_OK);
 			break;
 		case RSP_CODE_LENGTH_MISMATCH:
 			/* hardware bug */
-			set_host_byte(&scpnt->result, DID_ERROR);
+			set_host_byte(scpnt, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_FIELD_INVALID:
 			/* driver or hardware bug */
-			set_host_byte(&scpnt->result, DID_ERROR);
+			set_host_byte(scpnt, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_RO_MISMATCH:
 			/* hardware bug */
-			set_host_byte(&scpnt->result, DID_ERROR);
+			set_host_byte(scpnt, DID_ERROR);
 			goto skip_fsfstatus;
 		default:
 			/* invalid FCP response code */
-			set_host_byte(&scpnt->result, DID_ERROR);
+			set_host_byte(scpnt, DID_ERROR);
 			goto skip_fsfstatus;
 		}
 	}
@@ -3104,7 +3104,7 @@ zfcp_fsf_send_fcp_command_task_handler(s
 		scsi_set_resid(scpnt, fcp_rsp_iu->fcp_resid);
 		if (scsi_bufflen(scpnt) - scsi_get_resid(scpnt) <
 		    scpnt->underflow)
-			set_host_byte(&scpnt->result, DID_ERROR);
+			set_host_byte(scpnt, DID_ERROR);
 	}
 
  skip_fsfstatus:

-- 

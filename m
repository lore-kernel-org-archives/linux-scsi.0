From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 5/7] bnx2fc: Remove explicit logouts.
Date: Mon, 19 Oct 2015 15:40:39 -0400
Message-ID: <1445283641-7358-6-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:46350 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbbJSUTo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:44 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Explicit logouts from bnx2fc were causing race conditions in either returning
stale SCSI commands or not allowing a target to log back in.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |    1 -
 drivers/scsi/bnx2fc/bnx2fc_els.c |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c  |   85 ++++---------------------------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    6 ---
 4 files changed, 11 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 0e2aa65..d46267d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -303,7 +303,6 @@ struct bnx2fc_rport {
 #define BNX2FC_FLAG_OFLD_REQ_CMPL	0x5
 #define BNX2FC_FLAG_CTX_ALLOC_FAILURE	0x6
 #define BNX2FC_FLAG_UPLD_REQ_COMPL	0x7
-#define BNX2FC_FLAG_EXPL_LOGO		0x8
 #define BNX2FC_FLAG_DISABLE_FAILED	0x9
 #define BNX2FC_FLAG_ENABLED		0xa
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 0d0ab2e..5beea77 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -689,8 +689,7 @@ static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
 		rc = -EINVAL;
 		goto els_err;
 	}
-	if (!(test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) ||
-	     (test_bit(BNX2FC_FLAG_EXPL_LOGO, &tgt->flags))) {
+	if (!(test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags))) {
 		printk(KERN_ERR PFX "els 0x%x: tgt not ready\n", op);
 		rc = -EINVAL;
 		goto els_err;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 877a79a..3b4e00a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -40,11 +40,8 @@ static void bnx2fc_cmd_timeout(struct work_struct *work)
 {
 	struct bnx2fc_cmd *io_req = container_of(work, struct bnx2fc_cmd,
 						 timeout_work.work);
-	struct fc_lport *lport;
-	struct fc_rport_priv *rdata;
 	u8 cmd_type = io_req->cmd_type;
 	struct bnx2fc_rport *tgt = io_req->tgt;
-	int logo_issued;
 	int rc;
 
 	BNX2FC_IO_DBG(io_req, "cmd_timeout, cmd_type = %d,"
@@ -80,25 +77,14 @@ static void bnx2fc_cmd_timeout(struct work_struct *work)
 					io_req->refcount.refcount.counter);
 			if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
 					       &io_req->req_flags))) {
-
-				lport = io_req->port->lport;
-				rdata = io_req->tgt->rdata;
-				logo_issued = test_and_set_bit(
-						BNX2FC_FLAG_EXPL_LOGO,
-						&tgt->flags);
+				/*
+				 * Cleanup and return original command to
+				 * mid-layer.
+				 */
+				bnx2fc_initiate_cleanup(io_req);
 				kref_put(&io_req->refcount, bnx2fc_cmd_release);
 				spin_unlock_bh(&tgt->tgt_lock);
 
-				/* Explicitly logo the target */
-				if (!logo_issued) {
-					BNX2FC_IO_DBG(io_req, "Explicit "
-						   "logo - tgt flags = 0x%lx\n",
-						   tgt->flags);
-
-					mutex_lock(&lport->disc.disc_mutex);
-					lport->tt.rport_logoff(rdata);
-					mutex_unlock(&lport->disc.disc_mutex);
-				}
 				return;
 			}
 		} else {
@@ -116,28 +102,10 @@ static void bnx2fc_cmd_timeout(struct work_struct *work)
 				rc = bnx2fc_initiate_abts(io_req);
 				if (rc == SUCCESS)
 					goto done;
-				/*
-				 * Explicitly logo the target if
-				 * abts initiation fails
-				 */
-				lport = io_req->port->lport;
-				rdata = io_req->tgt->rdata;
-				logo_issued = test_and_set_bit(
-						BNX2FC_FLAG_EXPL_LOGO,
-						&tgt->flags);
+
 				kref_put(&io_req->refcount, bnx2fc_cmd_release);
 				spin_unlock_bh(&tgt->tgt_lock);
 
-				if (!logo_issued) {
-					BNX2FC_IO_DBG(io_req, "Explicit "
-						   "logo - tgt flags = 0x%lx\n",
-						   tgt->flags);
-
-
-					mutex_lock(&lport->disc.disc_mutex);
-					lport->tt.rport_logoff(rdata);
-					mutex_unlock(&lport->disc.disc_mutex);
-				}
 				return;
 			} else {
 				BNX2FC_IO_DBG(io_req, "IO already in "
@@ -152,22 +120,9 @@ static void bnx2fc_cmd_timeout(struct work_struct *work)
 
 			if (!test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
 					      &io_req->req_flags)) {
-				lport = io_req->port->lport;
-				rdata = io_req->tgt->rdata;
-				logo_issued = test_and_set_bit(
-						BNX2FC_FLAG_EXPL_LOGO,
-						&tgt->flags);
 				kref_put(&io_req->refcount, bnx2fc_cmd_release);
 				spin_unlock_bh(&tgt->tgt_lock);
 
-				/* Explicitly logo the target */
-				if (!logo_issued) {
-					BNX2FC_IO_DBG(io_req, "Explicitly logo"
-						   "(els)\n");
-					mutex_lock(&lport->disc.disc_mutex);
-					lport->tt.rport_logoff(rdata);
-					mutex_unlock(&lport->disc.disc_mutex);
-				}
 				return;
 			}
 		} else {
@@ -1112,18 +1067,11 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
-int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd *io_req)
+int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
-	struct fc_rport_priv *rdata = tgt->rdata;
-	int logo_issued;
 	int rc = SUCCESS;
-	int wait_cnt = 0;
 
-	BNX2FC_IO_DBG(io_req, "Expl logo - tgt flags = 0x%lx\n",
-		      tgt->flags);
-	logo_issued = test_and_set_bit(BNX2FC_FLAG_EXPL_LOGO,
-				       &tgt->flags);
 	io_req->wait_for_comp = 1;
 	bnx2fc_initiate_cleanup(io_req);
 
@@ -1136,21 +1084,8 @@ int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd *io_req)
 	 * release the reference taken in eh_abort to allow the
 	 * target to re-login after flushing IOs
 	 */
-	 kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 
-	if (!logo_issued) {
-		clear_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags);
-		mutex_lock(&lport->disc.disc_mutex);
-		lport->tt.rport_logoff(rdata);
-		mutex_unlock(&lport->disc.disc_mutex);
-		do {
-			msleep(BNX2FC_RELOGIN_WAIT_TIME);
-			if (wait_cnt++ > BNX2FC_RELOGIN_WAIT_CNT) {
-				rc = FAILED;
-				break;
-			}
-		} while (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags));
-	}
 	spin_lock_bh(&tgt->tgt_lock);
 	return rc;
 }
@@ -1252,7 +1187,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		if (cancel_delayed_work(&io_req->timeout_work))
 			kref_put(&io_req->refcount,
 				 bnx2fc_cmd_release); /* drop timer hold */
-		rc = bnx2fc_expl_logo(lport, io_req);
+		rc = bnx2fc_abts_cleanup(io_req);
 		/* This only occurs when an task abort was requested while ABTS
 		   is in progress.  Setting the IO_CLEANUP flag will skip the
 		   RRQ process in the case when the fw generated SCSI_CMD cmpl
@@ -1291,7 +1226,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		/* Let the scsi-ml try to recover this command */
 		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
 		       io_req->xid);
-		rc = bnx2fc_expl_logo(lport, io_req);
+		rc = bnx2fc_abts_cleanup(io_req);
 		goto out;
 	} else {
 		/*
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 30a8788..08ec318 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -560,12 +560,6 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 		    (hba->num_ofld_sess == 0)) {
 			wake_up_interruptible(&hba->shutdown_wait);
 		}
-		if (test_bit(BNX2FC_FLAG_EXPL_LOGO, &tgt->flags)) {
-			printk(KERN_ERR PFX "Relogin to the tgt\n");
-			mutex_lock(&lport->disc.disc_mutex);
-			lport->tt.rport_login(rdata);
-			mutex_unlock(&lport->disc.disc_mutex);
-		}
 		mutex_unlock(&hba->hba_mutex);
 
 		break;
-- 
1.7.7


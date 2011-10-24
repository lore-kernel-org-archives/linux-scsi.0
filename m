From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/3] bnx2fc: Handle ABTS timeout during ulp timeout
Date: Sun, 23 Oct 2011 23:23:56 -0700
Message-ID: <1319437438-7596-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1699 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab1JXGYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2011 02:24:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com

If the IO and the corresponding ABTS are not responded by a target, cleanup the
IO and issue explicit logout when ulp timer expires while waiting for ABTS to
complete. Wait for the session to be ready before returning to the SCSI layer.
If the session is not ready let the SCSI-ml escalate the error recovery.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h    |    3 +++
 drivers/scsi/bnx2fc/bnx2fc_io.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index d882a2d..969ae03 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -145,6 +145,9 @@
 #define REC_RETRY_COUNT			1
 #define BNX2FC_NUM_ERR_BITS		63
 
+#define BNX2FC_RELOGIN_WAIT_TIME	200
+#define BNX2FC_RELOGIN_WAIT_CNT		10
+
 /* bnx2fc driver uses only one instance of fcoe_percpu_s */
 extern struct fcoe_percpu_s bnx2fc_global;
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0c64d18..84a78af 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1103,7 +1103,10 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct bnx2fc_cmd *io_req;
 	struct fc_lport *lport;
+	struct fc_rport_priv *rdata;
 	struct bnx2fc_rport *tgt;
+	int logo_issued;
+	int wait_cnt = 0;
 	int rc = FAILED;
 
 
@@ -1192,8 +1195,40 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	} else {
 		printk(KERN_ERR PFX "eh_abort: io_req (xid = 0x%x) "
 				"already in abts processing\n", io_req->xid);
+		if (cancel_delayed_work(&io_req->timeout_work))
+			kref_put(&io_req->refcount,
+				 bnx2fc_cmd_release); /* drop timer hold */
+		bnx2fc_initiate_cleanup(io_req);
+
+		spin_unlock_bh(&tgt->tgt_lock);
+
+		wait_for_completion(&io_req->tm_done);
+
+		spin_lock_bh(&tgt->tgt_lock);
+		io_req->wait_for_comp = 0;
+		rdata = io_req->tgt->rdata;
+		logo_issued = test_and_set_bit(BNX2FC_FLAG_EXPL_LOGO,
+					       &tgt->flags);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
 		spin_unlock_bh(&tgt->tgt_lock);
+
+		if (!logo_issued) {
+			BNX2FC_IO_DBG(io_req, "Expl logo - tgt flags = 0x%lx\n",
+				      tgt->flags);
+			mutex_lock(&lport->disc.disc_mutex);
+			lport->tt.rport_logoff(rdata);
+			mutex_unlock(&lport->disc.disc_mutex);
+			do {
+				msleep(BNX2FC_RELOGIN_WAIT_TIME);
+				/*
+				 * If session not recovered, let SCSI-ml
+				 * escalate error recovery.
+				 */
+				if (wait_cnt++ > BNX2FC_RELOGIN_WAIT_CNT)
+					return FAILED;
+			} while (!test_bit(BNX2FC_FLAG_SESSION_READY,
+					   &tgt->flags));
+		}
 		return SUCCESS;
 	}
 	if (rc == FAILED) {
@@ -1275,6 +1310,8 @@ void bnx2fc_process_cleanup_compl(struct bnx2fc_cmd *io_req,
 		   io_req->refcount.refcount.counter, io_req->cmd_type);
 	bnx2fc_scsi_done(io_req, DID_ERROR);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	if (io_req->wait_for_comp)
+		complete(&io_req->tm_done);
 }
 
 void bnx2fc_process_abts_compl(struct bnx2fc_cmd *io_req,
-- 
1.7.0.6



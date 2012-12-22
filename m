From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 5/8] bnx2fc: Map the doorbell register between offload
 and enable requests
Date: Fri, 21 Dec 2012 19:40:31 -0800
Message-ID: <1356147634-17252-6-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4561 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2LVDko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:44 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

We used to map doorbell register after FW enable request is complete.
This causes a race condition when unsolicited event is received, and FW
sends a CQE for it. Since the doorbell is not mapped, driver does not
arm CQ, which means FW will not notify the driver for further CQ
completions.  To resolve this, map the doorbell between offload and
enable, so that driver is ready to receive the unsolicited packets and
arm the CQ as soon as FW enable is performed.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |    3 +++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   25 ++++++-------------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |   26 +++++++++++++++++---------
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 3486845..6c9e717 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -280,6 +280,7 @@ struct bnx2fc_rport {
 #define BNX2FC_FLAG_UPLD_REQ_COMPL	0x7
 #define BNX2FC_FLAG_EXPL_LOGO		0x8
 #define BNX2FC_FLAG_DISABLE_FAILED	0x9
+#define BNX2FC_FLAG_ENABLED		0xa
 
 	u8 src_addr[ETH_ALEN];
 	u32 max_sqes;
@@ -468,6 +469,8 @@ int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba);
 int bnx2fc_send_fw_fcoe_destroy_msg(struct bnx2fc_hba *hba);
 int bnx2fc_send_session_ofld_req(struct fcoe_port *port,
 					struct bnx2fc_rport *tgt);
+int bnx2fc_send_session_enable_req(struct fcoe_port *port,
+					struct bnx2fc_rport *tgt);
 int bnx2fc_send_session_disable_req(struct fcoe_port *port,
 				    struct bnx2fc_rport *tgt);
 int bnx2fc_send_session_destroy_req(struct bnx2fc_hba *hba,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index c31523b..46163e2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -347,7 +347,7 @@ int bnx2fc_send_session_ofld_req(struct fcoe_port *port,
  * @port:		port structure pointer
  * @tgt:		bnx2fc_rport structure pointer
  */
-static int bnx2fc_send_session_enable_req(struct fcoe_port *port,
+int bnx2fc_send_session_enable_req(struct fcoe_port *port,
 					struct bnx2fc_rport *tgt)
 {
 	struct kwqe *kwqe_arr[2];
@@ -1120,7 +1120,6 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 	struct bnx2fc_interface		*interface;
 	u32				conn_id;
 	u32				context_id;
-	int				rc;
 
 	conn_id = ofld_kcqe->fcoe_conn_id;
 	context_id = ofld_kcqe->fcoe_conn_context_id;
@@ -1149,17 +1148,10 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 				"resources\n");
 			set_bit(BNX2FC_FLAG_CTX_ALLOC_FAILURE, &tgt->flags);
 		}
-		goto ofld_cmpl_err;
 	} else {
-
-		/* now enable the session */
-		rc = bnx2fc_send_session_enable_req(port, tgt);
-		if (rc) {
-			printk(KERN_ERR PFX "enable session failed\n");
-			goto ofld_cmpl_err;
-		}
+		/* FW offload request successfully completed */
+		set_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
 	}
-	return;
 ofld_cmpl_err:
 	set_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
 	wake_up_interruptible(&tgt->ofld_wait);
@@ -1206,15 +1198,9 @@ static void bnx2fc_process_enable_conn_cmpl(struct bnx2fc_hba *hba,
 		printk(KERN_ERR PFX "bnx2fc-enbl_cmpl: HBA mis-match\n");
 		goto enbl_cmpl_err;
 	}
-	if (ofld_kcqe->completion_status)
-		goto enbl_cmpl_err;
-	else {
+	if (!ofld_kcqe->completion_status)
 		/* enable successful - rport ready for issuing IOs */
-		set_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
-		set_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
-		wake_up_interruptible(&tgt->ofld_wait);
-	}
-	return;
+		set_bit(BNX2FC_FLAG_ENABLED, &tgt->flags);
 
 enbl_cmpl_err:
 	set_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
@@ -1247,6 +1233,7 @@ static void bnx2fc_process_conn_disable_cmpl(struct bnx2fc_hba *hba,
 		/* disable successful */
 		BNX2FC_TGT_DBG(tgt, "disable successful\n");
 		clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
+		clear_bit(BNX2FC_FLAG_ENABLED, &tgt->flags);
 		set_bit(BNX2FC_FLAG_DISABLED, &tgt->flags);
 		set_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags);
 		wake_up_interruptible(&tgt->upld_wait);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index cc4a4fd..1d4c56e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -33,6 +33,7 @@ static void bnx2fc_upld_timer(unsigned long data)
 	BNX2FC_TGT_DBG(tgt, "upld_timer - Upload compl not received!!\n");
 	/* fake upload completion */
 	clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
+	clear_bit(BNX2FC_FLAG_ENABLED, &tgt->flags);
 	set_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags);
 	wake_up_interruptible(&tgt->upld_wait);
 }
@@ -55,6 +56,7 @@ static void bnx2fc_ofld_timer(unsigned long data)
 	 * resources are freed up in bnx2fc_offload_session
 	 */
 	clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
+	clear_bit(BNX2FC_FLAG_ENABLED, &tgt->flags);
 	set_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
 	wake_up_interruptible(&tgt->ofld_wait);
 }
@@ -135,14 +137,23 @@ retry_ofld:
 	}
 	if (bnx2fc_map_doorbell(tgt)) {
 		printk(KERN_ERR PFX "map doorbell failed - no mem\n");
-		/* upload will take care of cleaning up sess resc */
-		lport->tt.rport_logoff(rdata);
+		goto ofld_err;
+	}
+	clear_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
+	rval = bnx2fc_send_session_enable_req(port, tgt);
+	if (rval) {
+		pr_err(PFX "enable session failed\n");
+		goto ofld_err;
 	}
+	bnx2fc_ofld_wait(tgt);
+	if (!(test_bit(BNX2FC_FLAG_ENABLED, &tgt->flags)))
+		goto ofld_err;
 	return;
 
 ofld_err:
 	/* couldn't offload the session. log off from this rport */
 	BNX2FC_TGT_DBG(tgt, "bnx2fc_offload_session - offload error\n");
+	clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
 	/* Free session resources */
 	bnx2fc_free_session_resc(hba, tgt);
 tgt_init_err:
@@ -476,7 +487,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 		tgt = (struct bnx2fc_rport *)&rp[1];
 
 		/* This can happen when ADISC finds the same target */
-		if (test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags)) {
+		if (test_bit(BNX2FC_FLAG_ENABLED, &tgt->flags)) {
 			BNX2FC_TGT_DBG(tgt, "already offloaded\n");
 			mutex_unlock(&hba->hba_mutex);
 			return;
@@ -491,11 +502,8 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 		BNX2FC_TGT_DBG(tgt, "OFFLOAD num_ofld_sess = %d\n",
 			hba->num_ofld_sess);
 
-		if (test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags)) {
-			/*
-			 * Session is offloaded and enabled. Map
-			 * doorbell register for this target
-			 */
+		if (test_bit(BNX2FC_FLAG_ENABLED, &tgt->flags)) {
+			/* Session is offloaded and enabled.  */
 			BNX2FC_TGT_DBG(tgt, "sess offloaded\n");
 			/* This counter is protected with hba mutex */
 			hba->num_ofld_sess++;
@@ -532,7 +540,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 		 */
 		tgt = (struct bnx2fc_rport *)&rp[1];
 
-		if (!(test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags))) {
+		if (!(test_bit(BNX2FC_FLAG_ENABLED, &tgt->flags))) {
 			mutex_unlock(&hba->hba_mutex);
 			break;
 		}
-- 
1.7.0.6



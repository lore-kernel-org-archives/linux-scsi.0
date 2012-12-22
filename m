From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 4/8] bnx2fc: Move offload/upload wait logic into a
 function
Date: Fri, 21 Dec 2012 19:40:30 -0800
Message-ID: <1356147634-17252-5-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4578 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2LVDko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:44 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Moved the 'waiting for upload/offload completion' logic to respective
functions as it is called in multiple places. Also this is done in
preperation for the next patch.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |   65 +++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 4998b69..cc4a4fd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -59,6 +59,20 @@ static void bnx2fc_ofld_timer(unsigned long data)
 	wake_up_interruptible(&tgt->ofld_wait);
 }
 
+static void bnx2fc_ofld_wait(struct bnx2fc_rport *tgt)
+{
+	setup_timer(&tgt->ofld_timer, bnx2fc_ofld_timer, (unsigned long)tgt);
+	mod_timer(&tgt->ofld_timer, jiffies + BNX2FC_FW_TIMEOUT);
+
+	wait_event_interruptible(tgt->ofld_wait,
+				 (test_bit(
+				  BNX2FC_FLAG_OFLD_REQ_CMPL,
+				  &tgt->flags)));
+	if (signal_pending(current))
+		flush_signals(current);
+	del_timer_sync(&tgt->ofld_timer);
+}
+
 static void bnx2fc_offload_session(struct fcoe_port *port,
 					struct bnx2fc_rport *tgt,
 					struct fc_rport_priv *rdata)
@@ -103,17 +117,7 @@ retry_ofld:
 	 * wait for the session is offloaded and enabled. 3 Secs
 	 * should be ample time for this process to complete.
 	 */
-	setup_timer(&tgt->ofld_timer, bnx2fc_ofld_timer, (unsigned long)tgt);
-	mod_timer(&tgt->ofld_timer, jiffies + BNX2FC_FW_TIMEOUT);
-
-	wait_event_interruptible(tgt->ofld_wait,
-				 (test_bit(
-				  BNX2FC_FLAG_OFLD_REQ_CMPL,
-				  &tgt->flags)));
-	if (signal_pending(current))
-		flush_signals(current);
-
-	del_timer_sync(&tgt->ofld_timer);
+	bnx2fc_ofld_wait(tgt);
 
 	if (!(test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags))) {
 		if (test_and_clear_bit(BNX2FC_FLAG_CTX_ALLOC_FAILURE,
@@ -259,6 +263,19 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 	spin_unlock_bh(&tgt->tgt_lock);
 }
 
+static void bnx2fc_upld_wait(struct bnx2fc_rport *tgt)
+{
+	setup_timer(&tgt->upld_timer, bnx2fc_upld_timer, (unsigned long)tgt);
+	mod_timer(&tgt->upld_timer, jiffies + BNX2FC_FW_TIMEOUT);
+	wait_event_interruptible(tgt->upld_wait,
+				 (test_bit(
+				  BNX2FC_FLAG_UPLD_REQ_COMPL,
+				  &tgt->flags)));
+	if (signal_pending(current))
+		flush_signals(current);
+	del_timer_sync(&tgt->upld_timer);
+}
+
 static void bnx2fc_upload_session(struct fcoe_port *port,
 					struct bnx2fc_rport *tgt)
 {
@@ -279,19 +296,8 @@ static void bnx2fc_upload_session(struct fcoe_port *port,
 	 * wait for upload to complete. 3 Secs
 	 * should be sufficient time for this process to complete.
 	 */
-	setup_timer(&tgt->upld_timer, bnx2fc_upld_timer, (unsigned long)tgt);
-	mod_timer(&tgt->upld_timer, jiffies + BNX2FC_FW_TIMEOUT);
-
 	BNX2FC_TGT_DBG(tgt, "waiting for disable compl\n");
-	wait_event_interruptible(tgt->upld_wait,
-				 (test_bit(
-				  BNX2FC_FLAG_UPLD_REQ_COMPL,
-				  &tgt->flags)));
-
-	if (signal_pending(current))
-		flush_signals(current);
-
-	del_timer_sync(&tgt->upld_timer);
+	bnx2fc_upld_wait(tgt);
 
 	/*
 	 * traverse thru the active_q and tmf_q and cleanup
@@ -308,24 +314,13 @@ static void bnx2fc_upload_session(struct fcoe_port *port,
 		bnx2fc_send_session_destroy_req(hba, tgt);
 
 		/* wait for destroy to complete */
-		setup_timer(&tgt->upld_timer,
-			    bnx2fc_upld_timer, (unsigned long)tgt);
-		mod_timer(&tgt->upld_timer, jiffies + BNX2FC_FW_TIMEOUT);
-
-		wait_event_interruptible(tgt->upld_wait,
-					 (test_bit(
-					  BNX2FC_FLAG_UPLD_REQ_COMPL,
-					  &tgt->flags)));
+		bnx2fc_upld_wait(tgt);
 
 		if (!(test_bit(BNX2FC_FLAG_DESTROYED, &tgt->flags)))
 			printk(KERN_ERR PFX "ERROR!! destroy timed out\n");
 
 		BNX2FC_TGT_DBG(tgt, "destroy wait complete flags = 0x%lx\n",
 			tgt->flags);
-		if (signal_pending(current))
-			flush_signals(current);
-
-		del_timer_sync(&tgt->upld_timer);
 
 	} else if (test_bit(BNX2FC_FLAG_DISABLE_FAILED, &tgt->flags)) {
 		printk(KERN_ERR PFX "ERROR!! DISABLE req failed, destroy"
-- 
1.7.0.6



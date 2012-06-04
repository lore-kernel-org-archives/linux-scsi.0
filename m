From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 5/6] bnx2fc: use list_entry instead of explicit cast
Date: Mon, 4 Jun 2012 16:15:46 -0700
Message-ID: <1338851747-7240-6-git-send-email-bprakash@broadcom.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3121 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761200Ab2FDXQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2012 19:16:01 -0400
In-Reply-To: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Use list_for_each_entry_safe() instead of explicit cast to avoid relying on
struct layout

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +----
 drivers/scsi/bnx2fc/bnx2fc_io.c   |   21 +++++++--------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   17 ++++++-----------
 3 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f75308c..2fd7c26 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2151,13 +2151,10 @@ mod_err:
  **/
 static struct bnx2fc_hba *bnx2fc_find_hba_for_cnic(struct cnic_dev *cnic)
 {
-	struct list_head *list;
-	struct list_head *temp;
 	struct bnx2fc_hba *hba;
 
 	/* Called with bnx2fc_dev_lock held */
-	list_for_each_safe(list, temp, &adapter_list) {
-		hba = (struct bnx2fc_hba *)list;
+	list_for_each_entry(hba, &adapter_list, list) {
 		if (hba->cnic == cnic)
 			return hba;
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4f7453b..1dfe5ee 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -405,11 +405,10 @@ free_cmd_pool:
 		goto free_cmgr;
 
 	for (i = 0; i < num_possible_cpus() + 1; i++)  {
-		struct list_head *list;
-		struct list_head *tmp;
+		struct bnx2fc_cmd *tmp, *io_req;
 
-		list_for_each_safe(list, tmp, &cmgr->free_list[i]) {
-			struct bnx2fc_cmd *io_req = (struct bnx2fc_cmd *)list;
+		list_for_each_entry_safe(io_req, tmp,
+					 &cmgr->free_list[i], link) {
 			list_del(&io_req->link);
 			kfree(io_req);
 		}
@@ -1436,9 +1435,7 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 {
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 	struct bnx2fc_rport *tgt = io_req->tgt;
-	struct list_head *list;
-	struct list_head *tmp;
-	struct bnx2fc_cmd *cmd;
+	struct bnx2fc_cmd *cmd, *tmp;
 	int tm_lun = sc_cmd->device->lun;
 	int rc = 0;
 	int lun;
@@ -1449,9 +1446,8 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 	 * Walk thru the active_ios queue and ABORT the IO
 	 * that matches with the LUN that was reset
 	 */
-	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+	list_for_each_entry_safe(cmd, tmp, &tgt->active_cmd_queue, link) {
 		BNX2FC_TGT_DBG(tgt, "LUN RST cmpl: scan for pending IOs\n");
-		cmd = (struct bnx2fc_cmd *)list;
 		lun = cmd->sc_cmd->device->lun;
 		if (lun == tm_lun) {
 			/* Initiate ABTS on this cmd */
@@ -1476,9 +1472,7 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 static void bnx2fc_tgt_reset_cmpl(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
-	struct list_head *list;
-	struct list_head *tmp;
-	struct bnx2fc_cmd *cmd;
+	struct bnx2fc_cmd *cmd, *tmp;
 	int rc = 0;
 
 	/* called with tgt_lock held */
@@ -1487,9 +1481,8 @@ static void bnx2fc_tgt_reset_cmpl(struct bnx2fc_cmd *io_req)
 	 * Walk thru the active_ios queue and ABORT the IO
 	 * that matches with the LUN that was reset
 	 */
-	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+	list_for_each_entry_safe(cmd, tmp, &tgt->active_cmd_queue, link) {
 		BNX2FC_TGT_DBG(tgt, "TGT RST cmpl: scan for pending IOs\n");
-		cmd = (struct bnx2fc_cmd *)list;
 		/* Initiate ABTS */
 		if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
 							&cmd->req_flags)) {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index e71c254..43f8e42 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -150,8 +150,7 @@ tgt_init_err:
 void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 {
 	struct bnx2fc_cmd *io_req;
-	struct list_head *list;
-	struct list_head *tmp;
+	struct bnx2fc_cmd *tmp;
 	int rc;
 	int i = 0;
 	BNX2FC_TGT_DBG(tgt, "Entered flush_active_ios - %d\n",
@@ -160,9 +159,8 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 	spin_lock_bh(&tgt->tgt_lock);
 	tgt->flush_in_prog = 1;
 
-	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+	list_for_each_entry_safe(io_req, tmp, &tgt->active_cmd_queue, link) {
 		i++;
-		io_req = (struct bnx2fc_cmd *)list;
 		list_del_init(&io_req->link);
 		io_req->on_active_queue = 0;
 		BNX2FC_IO_DBG(io_req, "cmd_queue cleanup\n");
@@ -191,9 +189,8 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 		}
 	}
 
-	list_for_each_safe(list, tmp, &tgt->active_tm_queue) {
+	list_for_each_entry_safe(io_req, tmp, &tgt->active_tm_queue, link) {
 		i++;
-		io_req = (struct bnx2fc_cmd *)list;
 		list_del_init(&io_req->link);
 		io_req->on_tmf_queue = 0;
 		BNX2FC_IO_DBG(io_req, "tm_queue cleanup\n");
@@ -201,9 +198,8 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 			complete(&io_req->tm_done);
 	}
 
-	list_for_each_safe(list, tmp, &tgt->els_queue) {
+	list_for_each_entry_safe(io_req, tmp, &tgt->els_queue, link) {
 		i++;
-		io_req = (struct bnx2fc_cmd *)list;
 		list_del_init(&io_req->link);
 		io_req->on_active_queue = 0;
 
@@ -227,9 +223,8 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 		}
 	}
 
-	list_for_each_safe(list, tmp, &tgt->io_retire_queue) {
+	list_for_each_entry_safe(io_req, tmp, &tgt->io_retire_queue, link) {
 		i++;
-		io_req = (struct bnx2fc_cmd *)list;
 		list_del_init(&io_req->link);
 
 		BNX2FC_IO_DBG(io_req, "retire_queue flush\n");
@@ -335,7 +330,7 @@ static void bnx2fc_upload_session(struct fcoe_port *port,
 	} else if (test_bit(BNX2FC_FLAG_DISABLE_FAILED, &tgt->flags))
 		printk(KERN_ERR PFX "ERROR!! DISABLE req failed, destroy"
 				" not sent to FW\n");
-	} else
+	else
 		printk(KERN_ERR PFX "ERROR!! DISABLE req timed out, destroy"
 				" not sent to FW\n");
 
-- 
1.7.0.6



From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/5] bnx2fc: Fix race condition between IO completion
 and abort
Date: Fri, 8 Mar 2013 13:28:52 -0800
Message-ID: <1362778134-21045-4-git-send-email-bprakash@broadcom.com>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1915 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab3CHV2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Mar 2013 16:28:50 -0500
In-Reply-To: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When IO is successfully completed while an abort is pending, eh_abort
incorrectly assumes that abort failed and performes recovery by issuing
cleanup. Howerver, cleanup timesout as the firmware has no clue about
this IO. Fix this by checking if the IO has already completed.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 60798e8..539b95b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1269,8 +1269,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 
 	spin_lock_bh(&tgt->tgt_lock);
 	io_req->wait_for_comp = 0;
-	if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
-				    &io_req->req_flags))) {
+	if (test_bit(BNX2FC_FLAG_IO_COMPL, &io_req->req_flags)) {
+		BNX2FC_IO_DBG(io_req, "IO completed in a different context\n");
+		rc = SUCCESS;
+	} else if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
+				      &io_req->req_flags))) {
 		/* Let the scsi-ml try to recover this command */
 		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
 		       io_req->xid);
-- 
1.7.1



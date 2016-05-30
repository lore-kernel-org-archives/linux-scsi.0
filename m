From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] bnx2fc: replace printk() with BNX2FC_IO_DBG()
Date: Mon, 30 May 2016 10:41:01 +0200
Message-ID: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbcE3IlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 04:41:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, loberman@redhat.com

The "fcp_rsp_code = %d" message isn't an error, it's meant to
be informative only.
This patch prevents a flood of such messages in some situations.

Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 026f394..8f24d60 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1758,7 +1758,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 		if ((fcp_rsp_len == 4) || (fcp_rsp_len == 8)) {
 			/* Only for task management function */
 			io_req->fcp_rsp_code = rq_data[3];
-			printk(KERN_ERR PFX "fcp_rsp_code = %d\n",
+			BNX2FC_IO_DBG(io_req, "fcp_rsp_code = %d\n",
 				io_req->fcp_rsp_code);
 		}
 
-- 
Maurizio Lombardi


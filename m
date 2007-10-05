From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/17] sym53c8xx: Remove unnecessary check in queuecommand
Date: Fri,  5 Oct 2007 15:55:01 -0400
Message-ID: <11916141141543-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52920 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152AbXJETzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:20 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

The midlayer won't scan the host ID, so we don't need to check.
This is the only caller of sym_xpt_done2, so remove that too.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 924b5dd..d614a9c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -151,13 +151,6 @@ void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 	cmd->scsi_done(cmd);
 }
 
-static void sym_xpt_done2(struct sym_hcb *np, struct scsi_cmnd *cmd, int cam_status)
-{
-	sym_set_cam_status(cmd, cam_status);
-	sym_xpt_done(np, cmd);
-}
-
-
 /*
  *  Tell the SCSI layer about a BUS RESET.
  */
@@ -324,15 +317,6 @@ static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
 	int	order;
 
 	/*
-	 *  Minimal checkings, so that we will not 
-	 *  go outside our tables.
-	 */
-	if (sdev->id == np->myaddr) {
-		sym_xpt_done2(np, cmd, DID_NO_CONNECT);
-		return 0;
-	}
-
-	/*
 	 *  Retrieve the target descriptor.
 	 */
 	tp = &np->target[sdev->id];
@@ -537,7 +521,7 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
 
-	cmd->scsi_done     = done;
+	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
 	/*
-- 
1.4.4.2


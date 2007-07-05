From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH] stex: use resid for xfer len information
Date: Thu, 5 Jul 2007 12:09:06 -0700
Message-ID: <NONAMEBYIqAFoXu4S910000013c@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:43084 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758028AbXGETG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 15:06:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.Bottomley" <james.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


The original implementation in stex_ys_commands() is inappropriate.
For xfer len information, we should use resid instead.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index adda296..72f6d80 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -719,8 +719,8 @@ static void stex_ys_commands(struct st_h
 
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
-		scsi_bufflen(ccb->cmd) =
-			le32_to_cpu(*(__le32 *)&resp->variable[0]);
+		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
+			le32_to_cpu(*(__le32 *)&resp->variable[0]));
 		return;
 	}
 



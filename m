From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/5] hpsa: check for null device pointers
Date: Fri, 9 Sep 2016 16:30:23 -0500
Message-ID: <147345662327.19269.7832239672257530411.stgit@brunhilda>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0047.outbound.protection.outlook.com ([104.47.38.47]:55974
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753269AbcIIVal (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 17:30:41 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

A device can be deleted causing NULL pointer issues.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 332ff1a..97f50c7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2388,7 +2388,8 @@ static void hpsa_cmd_free_and_done(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd)
 {
 	hpsa_cmd_resolve_and_free(h, c);
-	cmd->scsi_done(cmd);
+	if (cmd && cmd->scsi_done)
+		cmd->scsi_done(cmd);
 }
 
 static void hpsa_retry_cmd(struct ctlr_info *h, struct CommandList *c)
@@ -2489,6 +2490,12 @@ static void complete_scsi_command(struct CommandList *cp)
 	ei = cp->err_info;
 	cmd = cp->scsi_cmd;
 	h = cp->h;
+
+	if (!cmd->device) {
+		cmd->result = DID_NO_CONNECT << 16;
+		return hpsa_cmd_free_and_done(h, cp, cmd);
+	}
+
 	dev = cmd->device->hostdata;
 	c2 = &h->ioaccel2_cmd_pool[cp->cmdindex];
 
@@ -2504,8 +2511,15 @@ static void complete_scsi_command(struct CommandList *cp)
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
 
-	if (cp->cmd_type == CMD_IOACCEL2 || cp->cmd_type == CMD_IOACCEL1)
-		atomic_dec(&cp->phys_disk->ioaccel_cmds_out);
+	if (cp->cmd_type == CMD_IOACCEL2 || cp->cmd_type == CMD_IOACCEL1) {
+		if (dev->physical_device && dev->expose_device &&
+			dev->removed) {
+			cmd->result = DID_NO_CONNECT << 16;
+			return hpsa_cmd_free_and_done(h, cp, cmd);
+		}
+		if (likely(cp->phys_disk != NULL))
+			atomic_dec(&cp->phys_disk->ioaccel_cmds_out);
+	}
 
 	/*
 	 * We check for lockup status here as it may be set for


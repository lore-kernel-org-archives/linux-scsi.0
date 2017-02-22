From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 2/3] cciss: Fix checkpatch OPEN_BRACE
Date: Wed, 22 Feb 2017 16:49:10 +1100
Message-ID: <1487742551-10839-3-git-send-email-me@tobin.cc>
References: <1487742551-10839-1-git-send-email-me@tobin.cc>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46355 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754094AbdBVFt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 00:49:27 -0500
In-Reply-To: <1487742551-10839-1-git-send-email-me@tobin.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>

Checkpatch emits ERROR:OPEN_BRACE: that open brace { should be on the
previous line.

Move open brace to new line. Also add space after if/switch statement
since we introduce more checkpatch errors if not fixed at the same
time.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/block/cciss_scsi.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 2b8cfd4..f5c21f3 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -699,10 +699,8 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 			ei->SenseLen);
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
-	if(ei->CommandStatus != 0)
-	{ /* an error has occurred */
-		switch(ei->CommandStatus)
-		{
+	if (ei->CommandStatus != 0) { /* an error has occurred */
+		switch (ei->CommandStatus) {
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
 				if (!ei->ScsiStatus) {
@@ -902,8 +900,7 @@ cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
 	ErrorInfo_struct *ei;
 
 	ei = c->err_info;
-	switch(ei->CommandStatus)
-	{
+	switch (ei->CommandStatus) {
 		case CMD_TARGET_STATUS:
 			dev_warn(&h->pdev->dev,
 				"cmd %p has completed with errors\n", c);
@@ -1182,8 +1179,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 		cciss_scsi_get_device_id(h, scsi3addr,
 			this_device->device_id, sizeof(this_device->device_id));
 
-		switch (this_device->devtype)
-		{
+		switch (this_device->devtype) {
 		  case 0x05: /* CD-ROM */ {
 
 			/* We don't *really* support actual CD-ROM devices,
@@ -1414,8 +1410,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 	memcpy(c->Request.CDB, cmd->cmnd, cmd->cmd_len);
 	c->Request.Type.Type = TYPE_CMD;
 	c->Request.Type.Attribute = ATTR_SIMPLE;
-	switch(cmd->sc_data_direction)
-	{
+	switch (cmd->sc_data_direction) {
 	  case DMA_TO_DEVICE:
 		c->Request.Type.Direction = XFER_WRITE;
 		break;
-- 
2.7.4

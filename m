From: tom.ty89@gmail.com
Subject: [PATCH 2/2] libata-scsi: do not response with "invalid field" for FORMAT UNIT
Date: Tue,  5 Jul 2016 04:53:35 +0800
Message-ID: <577accda.46c0620a.65070.ffffec86@mx.google.com>
References: <20160704205335.5484-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36765 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbcGDUxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2016 16:53:47 -0400
In-Reply-To: <20160704205335.5484-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

It does not make sense and is confusing to response with "Invalid
field in cbd" while we have no support at all implemented for
FORMAT UNIT. It is decent to let it go to the default, which
will response with "Invalid command operation code" instead.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 80d732c..f70f9d1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4045,11 +4045,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 	args.done = cmd->scsi_done;
 
 	switch(scsicmd[0]) {
-	/* TODO: worth improving? */
-	case FORMAT_UNIT:
-		ata_scsi_invalid_field(dev, cmd, 0);
-		break;
-
 	case INQUIRY:
 		if (scsicmd[1] & 2)		   /* is CmdDt set?  */
 		    ata_scsi_invalid_field(dev, cmd, 1);
-- 
2.9.0


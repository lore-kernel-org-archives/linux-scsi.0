From: tom.ty89@gmail.com
Subject: [PATCH v2 2/2] libata-scsi: do not respond with "invalid field" for FORMAT UNIT
Date: Tue,  5 Jul 2016 14:45:56 +0800
Message-ID: <577b57b3.5b4c620a.37648.6c91@mx.google.com>
References: <20160705064556.909-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34303 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbcGEGqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 02:46:12 -0400
In-Reply-To: <20160705064556.909-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

It does not make sense and is confusing to respond with "Invalid
field in CDB" while we have no support at all implemented for
FORMAT UNIT. It is decent to let it go to the default, which
will respond with "Invalid command operation code" instead.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 029e738..ac5676e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -307,7 +307,7 @@ static void ata_scsi_set_invalid_field(struct ata_device *dev,
 				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
 	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
-	/* "Invalid field in cbd" */
+	/* "Invalid field in CDB" */
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, bit, 1);
 }
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


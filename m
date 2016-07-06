From: tom.ty89@gmail.com
Subject: [PATCH resend 1/2] libata-scsi: do not respond with "invalid field" for FORMAT UNIT
Date: Thu,  7 Jul 2016 01:13:08 +0800
Message-ID: <577d3c35.949b620a.2f8b5.ffffb1c4@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

It does not make sense and is confusing to respond with "Invalid
field in CDB" while we have no support at all implemented for
FORMAT UNIT. It is decent to let it go to the default, which
will respond with "Invalid command operation code" instead.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..f1125fd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4039,11 +4039,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
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


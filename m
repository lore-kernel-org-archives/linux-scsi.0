From: tom.ty89@gmail.com
Subject: [PATCH v2] libata-scsi: set correct VERSION field for ZAC devices
Date: Tue, 12 Jul 2016 22:12:01 +0800
Message-ID: <5784fab7.1641620a.9a531.ffff8dae@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, shaun.tancheff@seagate.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Commit 856c46639309 ("libata: support device-managed ZAC devices")
had the line that "bumps" the VERSION field in standard INQUIRY data
removed. Add it back and claim SPC-5 version compatibility, which
matches with the current version descriptor "SPC-5 (no version claimed)"
that is used for ZAC devices.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..27e29e1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2109,8 +2109,10 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 	    (args->dev->link->ap->pflags & ATA_PFLAG_EXTERNAL))
 		hdr[1] |= (1 << 7);
 
-	if (args->dev->class == ATA_DEV_ZAC)
+	if (args->dev->class == ATA_DEV_ZAC) {
 		hdr[0] = TYPE_ZBC;
+		hdr[2] = 0x7; /* claim SPC-5 version compatibility */
+	}
 
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
-- 
2.9.0


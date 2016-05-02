From: tom.ty89@gmail.com
Subject: [PATCH 1/3] libata-scsi: Set CmdQue=1 when NCQ is enabled
Date: Tue,  3 May 2016 04:13:19 +0800
Message-ID: <5727b4e8.c923620a.641f4.17a2@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

https://bugzilla.kernel.org/show_bug.cgi?id=105931

This might look trivial at first sight. However, it can be
important to have the bit set accordingly when the device/SATL is
SCSI-passthrough'd to a virtual machine with scsi-block in qemu:

https://github.com/YanVugenfirer/kvm-guest-drivers-windows/issues/63#issuecomment-216199929
Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 567859c..cd30f11 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2007,7 +2007,10 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		0,
 		0x5,	/* claim SPC-3 version compatibility */
 		2,
-		95 - 4
+		95 - 4,
+		0,
+		0,
+		0
 	};
 
 	VPRINTK("ENTER\n");
@@ -2024,6 +2027,9 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
 	}
 
+	if (ata_ncq_enabled(args->dev))
+		hdr[7] |= (1 << 1);
+
 	memcpy(rbuf, hdr, sizeof(hdr));
 	memcpy(&rbuf[8], "ATA     ", 8);
 	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
-- 
2.8.2


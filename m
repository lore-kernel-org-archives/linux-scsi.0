From: tom.ty89@gmail.com
Subject: [PATCH] libata-scsi: fix D_SENSE bit relection in control mode page
Date: Wed, 13 Jul 2016 01:35:58 +0800
Message-ID: <57852a86.460b420a.faeba.0b28@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

The bit should always be set to 1 when the requested version of
page is "changeable" because we've made it so in ata_mselect_control().
Also, it should always be set to 1 if ATA_DFLAG_D_SENSE is set (when
the requested version of page is "current" or "default").

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..7e24f0a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2446,7 +2446,7 @@ static unsigned int ata_msense_ctl_mode(struct ata_device *dev, u8 *buf,
 					bool changeable)
 {
 	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
-	if (changeable && (dev->flags & ATA_DFLAG_D_SENSE))
+	if (changeable || (dev->flags & ATA_DFLAG_D_SENSE))
 		buf[2] |= (1 << 2);	/* Descriptor sense requested */
 	return sizeof(def_control_mpage);
 }
-- 
2.9.0


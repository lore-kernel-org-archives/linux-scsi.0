From: tom.ty89@gmail.com
Subject: [PATCH 3/3] libata-scsi: Do not partially report ATA read look-ahead
Date: Tue,  3 May 2016 04:13:21 +0800
Message-ID: <5727b4ef.c923620a.641f4.17b3@mx.google.com>
References: <1462220001-2566-1-git-send-email-me>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1462220001-2566-1-git-send-email-me>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Nothing in the kernel actually makes use of the DRA bit in SCSI
MODE SENSE. Neither is there a sysfs file (like 'cache_type' for
WCE) that allows users to change the bit nor SCSI-ATA Translation
that can toggle the ATA feature.

Hence removing the MODE SENSE SCSI-ATA Translation that is only
triggered by the change of WCE to avoid silliness like this:
https://bugzilla.kernel.org/show_bug.cgi?id=105861#c2

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0295c38..8c07db8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2316,8 +2316,6 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
 	if (changeable || ata_id_wcache_enabled(id))
 		buf[2] |= (1 << 2);	/* write cache enable */
-	if (!changeable && !ata_id_rahead_enabled(id))
-		buf[12] |= (1 << 5);	/* disable read ahead */
 	return sizeof(def_cache_mpage);
 }
 
-- 
2.8.2


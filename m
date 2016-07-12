From: tom.ty89@gmail.com
Subject: [PATCH v2 2/2] libata-scsi: better style in ata_msense_caching()
Date: Tue, 12 Jul 2016 21:28:23 +0800
Message-ID: <5784f087.465c620a.e5292.ffffbf31@mx.google.com>
References: <20160712132823.1765-1-me>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160712132823.1765-1-me>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..6f7c626 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2424,10 +2424,13 @@ static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
 static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 {
 	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
-	if (changeable || ata_id_wcache_enabled(id))
-		buf[2] |= (1 << 2);	/* write cache enable */
-	if (!changeable && !ata_id_rahead_enabled(id))
-		buf[12] |= (1 << 5);	/* disable read ahead */
+	if (changeable) {
+		buf[2] |= 1 << 2; /* ata_mselect_caching() */
+	}
+	else {
+		buf[2] |= ata_id_wcache_enabled(id) << 2;	/* write cache enable */
+		buf[12] |= !ata_id_rahead_enabled(id) << 5;	/* disable read ahead */
+	}
 	return sizeof(def_cache_mpage);
 }
 
-- 
2.9.0


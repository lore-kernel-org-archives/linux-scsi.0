From: tom.ty89@gmail.com
Subject: [PATCH 2/2] libata-scsi: better style in ata_msense_caching()
Date: Thu,  7 Jul 2016 09:43:34 +0800
Message-ID: <577db3cf.0a6a620a.c3774.1508@mx.google.com>
References: <20160707014334.1031-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35134 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbcGGBno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 21:43:44 -0400
In-Reply-To: <20160707014334.1031-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..e3f5751 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2424,10 +2424,12 @@ static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
 static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 {
 	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
-	if (changeable || ata_id_wcache_enabled(id))
-		buf[2] |= (1 << 2);	/* write cache enable */
-	if (!changeable && !ata_id_rahead_enabled(id))
-		buf[12] |= (1 << 5);	/* disable read ahead */
+	if (changeable)
+		buf[2] |= (1 << 2); /* ata_mselect_caching() */
+	else {
+		buf[2] |= (ata_id_wcache_enabled(id) << 2);	/* write cache enable */
+		buf[12] |= (!ata_id_rahead_enabled(id) << 5);	/* disable read ahead */
+	}
 	return sizeof(def_cache_mpage);
 }
 
-- 
2.9.0


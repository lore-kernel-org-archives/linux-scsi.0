From: tom.ty89@gmail.com
Subject: [PATCH v4] libata-scsi: better style in ata_msense_*()
Date: Wed, 20 Jul 2016 04:39:28 +0800
Message-ID: <578e9008.4500420a.2d828.d131@mx.google.com>
References: <5784f28c.c4d0620a.69372.3df2@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35788 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbcGSUjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 16:39:51 -0400
In-Reply-To: <5784f28c.c4d0620a.69372.3df2@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

`changeable` is the "version" of mode page requested by the user.
It will be less confusing/misleading if we do not check it
"together" with the setting bits of the drive.

Not to mention that we currently have ata_mselect_*() implemented
in a way that each of them will serve exclusively a particular bit
on each page. The old style will hence make the condition look even
more unnecessarily arcane if the ata_msense_*() is reflecting more
than one bit.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bf4cb21..b00521b 100644
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
+	if (changeable) {
+		buf[2] |= (1 << 2);	/* ata_mselect_caching() */
+	} else {
+		buf[2] |= (ata_id_wcache_enabled(id) << 2);	/* write cache enable */
+		buf[12] |= (!ata_id_rahead_enabled(id) << 5);	/* disable read ahead */
+	}
 	return sizeof(def_cache_mpage);
 }
 
@@ -2446,8 +2448,13 @@ static unsigned int ata_msense_control(struct ata_device *dev, u8 *buf,
 					bool changeable)
 {
 	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
-	if (changeable || (dev->flags & ATA_DFLAG_D_SENSE))
-		buf[2] |= (1 << 2);	/* Descriptor sense requested */
+	if (changeable) {
+		buf[2] |= (1 << 2);	/* ata_mselect_control() */
+	} else {
+		bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
+
+		buf[2] |= (d_sense << 2);	/* descriptor format sense data */
+	}
 	return sizeof(def_control_mpage);
 }
 
-- 
2.9.0


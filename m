From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: sd_dif.c use unaligned access helpers
Date: Wed, 23 Jul 2008 16:07:40 -0700
Message-ID: <1216854460.30386.32.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:12689 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGWXHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 19:07:48 -0400
Received: by yx-out-2324.google.com with SMTP id 8so477836yxm.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 16:07:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This code should be looked at carefully, while this patch doesn't
change any behaviour, the handling of app_tag, ref_tag seems odd.
The struct defines both as __be16/32 but in these locations it is
read in/written out as cpu-byteorder.

It looks like they should actually be u16/u32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/sd_dif.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 4d17f3d..e54711e 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -22,6 +22,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -142,11 +143,10 @@ static int sd_dif_type1_verify_ip(struct blk_integrity_exchg *bix)
 static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		sdt->app_tag = tag[j] << 8 | tag[j+1];
+		sdt->app_tag = get_unaligned_be16(tag_buf + j);
 		BUG_ON(sdt->app_tag == 0xffff);
 	}
 }
@@ -154,13 +154,10 @@ static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors
 static void sd_dif_type1_get_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
 	unsigned int i, j;
 
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		tag[j] = (sdt->app_tag & 0xff00) >> 8;
-		tag[j+1] = sdt->app_tag & 0xff;
-	}
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++)
+		put_unaligned_be16(sdt->app_tag, tag_buf + j);
 }
 
 static struct blk_integrity dif_type1_integrity_crc = {
@@ -256,29 +253,22 @@ static int sd_dif_type3_verify_ip(struct blk_integrity_exchg *bix)
 static void sd_dif_type3_set_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 6, sdt++) {
-		sdt->app_tag = tag[j] << 8 | tag[j+1];
-		sdt->ref_tag = tag[j+2] << 24 | tag[j+3] << 16 |
-			tag[j+4] << 8 | tag[j+5];
+		sdt->app_tag = get_unaligned_be16(tag_buf + j);
+		sdt->ref_tag = get_unaligned_be32(tag_buf + 2 + j);
 	}
 }
 
 static void sd_dif_type3_get_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
-		tag[j] = (sdt->app_tag & 0xff00) >> 8;
-		tag[j+1] = sdt->app_tag & 0xff;
-		tag[j+2] = (sdt->ref_tag & 0xff000000) >> 24;
-		tag[j+3] = (sdt->ref_tag & 0xff0000) >> 16;
-		tag[j+4] = (sdt->ref_tag & 0xff00) >> 8;
-		tag[j+5] = sdt->ref_tag & 0xff;
+		put_unaligned_be16(sdt->app_tag, tag_buf + j);
+		put_unaligned_be32(sdt->ref_tag, tag_buf + 2 + j);
 		BUG_ON(sdt->app_tag == 0xffff || sdt->ref_tag == 0xffffffff);
 	}
 }
-- 
1.5.6.4.570.g052e




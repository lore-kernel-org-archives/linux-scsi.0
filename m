From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH] [SCSI] Fix T10-DIF-TYPE3 get_tag handler for multi-sector bios
Date: Wed, 28 May 2014 18:24:53 +0200
Message-ID: <1401294293-18770-1-git-send-email-andreas.gruenbacher@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59787 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaE1QZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 12:25:11 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so4063038wiw.15
        for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 09:25:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

The combined tag size in this case is 6 bytes; fix the loop.

Signed-off-by: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
---
 drivers/scsi/sd_dif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index a7a691d..d657a8c 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -264,7 +264,7 @@ static void sd_dif_type3_get_tag(void *prot, void *tag_buf, unsigned int sectors
 	u8 *tag = tag_buf;
 	unsigned int i, j;
 
-	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 6, sdt++) {
 		tag[j] = (sdt->app_tag & 0xff00) >> 8;
 		tag[j+1] = sdt->app_tag & 0xff;
 		tag[j+2] = (sdt->ref_tag & 0xff000000) >> 24;
-- 
1.8.3.1


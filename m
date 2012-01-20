From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] hpsa: use find_first_zero_bit
Date: Sat, 21 Jan 2012 00:15:27 +0900
Message-ID: <1327072528-8479-5-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2ATPPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2012 10:15:34 -0500
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Use find_first_zero_bit to find the first cleared bit in a memory region.

This also includes the following minor changes.
- Use bitmap_zero
- Reduce unnecessary atomic bitops usage

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7d14443..7f79ed8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -577,21 +577,19 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 	int i, found = 0;
 	DECLARE_BITMAP(lun_taken, HPSA_MAX_DEVICES);
 
-	memset(&lun_taken[0], 0, HPSA_MAX_DEVICES >> 3);
+	bitmap_zero(lun_taken, HPSA_MAX_DEVICES);
 
 	for (i = 0; i < h->ndevices; i++) {
 		if (h->dev[i]->bus == bus && h->dev[i]->target != -1)
-			set_bit(h->dev[i]->target, lun_taken);
+			__set_bit(h->dev[i]->target, lun_taken);
 	}
 
-	for (i = 0; i < HPSA_MAX_DEVICES; i++) {
-		if (!test_bit(i, lun_taken)) {
-			/* *bus = 1; */
-			*target = i;
-			*lun = 0;
-			found = 1;
-			break;
-		}
+	i = find_first_zero_bit(lun_taken, HPSA_MAX_DEVICES);
+	if (i < HPSA_MAX_DEVICES) {
+		/* *bus = 1; */
+		*target = i;
+		*lun = 0;
+		found = 1;
 	}
 	return !found;
 }
-- 
1.7.4.4


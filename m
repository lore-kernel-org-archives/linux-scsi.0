From: akpm@linux-foundation.org
Subject: [patch 4/4] drivers/scsi/hpsa.c: use find_first_zero_bit()
Date: Wed, 08 Feb 2012 12:52:22 -0800
Message-ID: <20120208205222.C6A22A04FD@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46254 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2BHUwX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 15:52:23 -0500
Received: by yenm1 with SMTP id m1so100149yen.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2012 12:52:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, JBottomley@parallels.com, scameron@beardog.cce.hp.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()

Use find_first_zero_bit to find the first cleared bit in a memory region.

This also includes the following minor changes.
- Use bitmap_zero
- Reduce unnecessary atomic bitops usage

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-use-find_first_zero_bit drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-use-find_first_zero_bit
+++ a/drivers/scsi/hpsa.c
@@ -577,21 +577,19 @@ static int hpsa_find_target_lun(struct c
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
_

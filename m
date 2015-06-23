From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] scsi: remove redundant NULL check before kfree
Date: Tue, 23 Jun 2015 09:12:30 +0530
Message-ID: <1435030950-35999-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38277 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbFWDoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 23:44:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, hare@suse.de, hch@lst.de, michaelc@cs.wisc.edu, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

There is no need of NULL check before kfree,
So removing the same.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Rohit Thapliyal <r.thapliyal@samsung.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 4b135cc..a449fde 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -589,8 +589,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in

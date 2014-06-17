From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/aic94xx/aic94xx_init.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:17:15 +0200
Message-ID: <1403032635-5621-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index c56741f..0bfdcba 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -597,8 +597,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
-- 
1.8.4.5

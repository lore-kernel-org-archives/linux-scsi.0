From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: aic94xx: Remove unnecessary null check
Date: Thu, 11 Jul 2019 22:15:39 +0800
Message-ID: <20190711141539.13892-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de, dan.carpenter@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

kmem_cache_destroy() can handle NULL pointer correctly, so there is
no need to check NULL pointer before calling kmem_cache_destroy().

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 261d8e4..f5781e3 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -565,8 +565,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
@@ -641,12 +640,10 @@ static int asd_create_global_caches(void)
 
 static void asd_destroy_global_caches(void)
 {
-	if (asd_dma_token_cache)
-		kmem_cache_destroy(asd_dma_token_cache);
+	kmem_cache_destroy(asd_dma_token_cache);
 	asd_dma_token_cache = NULL;
 
-	if (asd_ascb_cache)
-		kmem_cache_destroy(asd_ascb_cache);
+	kmem_cache_destroy(asd_ascb_cache);
 	asd_ascb_cache = NULL;
 }
 
-- 
2.7.4

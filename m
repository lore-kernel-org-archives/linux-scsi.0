From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: NULL check before some freeing functions is not
 needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930051-1215258621-7-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -584,8 +584,7 @@ static void asd_destroy_ha_caches(struct
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
@@ -660,12 +659,10 @@ Err:
 
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
 

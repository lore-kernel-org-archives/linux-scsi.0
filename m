From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH] scsi: mpt3sas: use zalloc function for alloc and  memset
Date: Wed, 29 Aug 2018 11:06:13 +0800
Message-ID: <1535511973-25199-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

use dma_pool_zalloc replace dma_pool_alloc and memset

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59d7844..d7ef671 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4516,7 +4516,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	i = 0;
 	do {
 		ioc->reply_post[i].reply_post_free =
-		    dma_pool_alloc(ioc->reply_post_free_dma_pool,
+		    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
 		    GFP_KERNEL,
 		    &ioc->reply_post[i].reply_post_free_dma);
 		if (!ioc->reply_post[i].reply_post_free) {
@@ -4525,7 +4525,6 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 			ioc->name);
 			goto out;
 		}
-		memset(ioc->reply_post[i].reply_post_free, 0, sz);
 		dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		    "reply post free pool (0x%p): depth(%d),"
 		    "element_size(%d), pool_size(%d kB)\n", ioc->name,
@@ -4852,14 +4851,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 			ioc->name);
 		goto out;
 	}
-	ioc->reply_free = dma_pool_alloc(ioc->reply_free_dma_pool, GFP_KERNEL,
+	ioc->reply_free = dma_pool_zalloc(ioc->reply_free_dma_pool, GFP_KERNEL,
 	    &ioc->reply_free_dma);
 	if (!ioc->reply_free) {
 		pr_err(MPT3SAS_FMT "reply_free pool: dma_pool_alloc failed\n",
 			ioc->name);
 		goto out;
 	}
-	memset(ioc->reply_free, 0, sz);
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "reply_free pool(0x%p): " \
 	    "depth(%d), element_size(%d), pool_size(%d kB)\n", ioc->name,
 	    ioc->reply_free, ioc->reply_free_queue_depth, 4, sz/1024));
-- 
1.9.1

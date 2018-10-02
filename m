From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi/mpt3sas: Use dma_pool_zalloc
Date: Tue, 2 Oct 2018 11:18:04 +0530
Message-ID: <20181002054804.GA11315@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, brajeswar.linux@gmail.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replaced dma_pool_alloc + memset with dma_pool_zalloc.

Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
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

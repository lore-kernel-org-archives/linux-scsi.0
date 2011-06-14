From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 1/2] fnic: fix incorrect use of SLAB_CACHE_DMA flag
Date: Mon, 13 Jun 2011 21:21:01 -0700
Message-ID: <20110614042025.5915.89621.stgit@localhost.localdomain>
References: <20110614041741.5915.8518.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47145 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1FNEVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2011 00:21:05 -0400
In-Reply-To: <20110614041741.5915.8518.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, abjoglek@cisco.com
Cc: vbhamidi@cisco.com, buchino@cisco.com

Driver was incorrectly using the SLAB_CACHE_DMA flag when creating a cache
for SGLs. fnic device does not have 24-bit DMA restrictions. Remove the flag
and allocations from ZONE_DMA.

Thanks to Roland Dreier and David Rientjes for pointing out the bug.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_main.c |   21 ++++-----------------
 drivers/scsi/fnic/fnic_scsi.c |    2 +-
 3 files changed, 6 insertions(+), 19 deletions(-)


diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 671cde9..95a5ba2 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -37,7 +37,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.5.0.1"
+#define DRV_VERSION		"1.5.0.2"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index bb63f1a..fc98eb6 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -388,17 +388,6 @@ static void fnic_iounmap(struct fnic *fnic)
 		iounmap(fnic->bar0.vaddr);
 }
 
-/*
- * Allocate element for mempools requiring GFP_DMA flag.
- * Otherwise, checks in kmem_flagcheck() hit BUG_ON().
- */
-static void *fnic_alloc_slab_dma(gfp_t gfp_mask, void *pool_data)
-{
-	struct kmem_cache *mem = pool_data;
-
-	return kmem_cache_alloc(mem, gfp_mask | GFP_ATOMIC | GFP_DMA);
-}
-
 /**
  * fnic_get_mac() - get assigned data MAC address for FIP code.
  * @lport: 	local port.
@@ -603,14 +592,12 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;
 
-	pool = mempool_create(2, fnic_alloc_slab_dma, mempool_free_slab,
-			      fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
+	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	if (!pool)
 		goto err_out_free_ioreq_pool;
 	fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
 
-	pool = mempool_create(2, fnic_alloc_slab_dma, mempool_free_slab,
-			      fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
+	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	if (!pool)
 		goto err_out_free_dflt_pool;
 	fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX] = pool;
@@ -876,7 +863,7 @@ static int __init fnic_init_module(void)
 	len = sizeof(struct fnic_dflt_sgl_list);
 	fnic_sgl_cache[FNIC_SGL_CACHE_DFLT] = kmem_cache_create
 		("fnic_sgl_dflt", len + FNIC_SG_DESC_ALIGN, FNIC_SG_DESC_ALIGN,
-		 SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA,
+		 SLAB_HWCACHE_ALIGN,
 		 NULL);
 	if (!fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]) {
 		printk(KERN_ERR PFX "failed to create fnic dflt sgl slab\n");
@@ -888,7 +875,7 @@ static int __init fnic_init_module(void)
 	len = sizeof(struct fnic_sgl_list);
 	fnic_sgl_cache[FNIC_SGL_CACHE_MAX] = kmem_cache_create
 		("fnic_sgl_max", len + FNIC_SG_DESC_ALIGN, FNIC_SG_DESC_ALIGN,
-		 SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA,
+		 SLAB_HWCACHE_ALIGN,
 		 NULL);
 	if (!fnic_sgl_cache[FNIC_SGL_CACHE_MAX]) {
 		printk(KERN_ERR PFX "failed to create fnic max sgl slab\n");
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 538b31c..c40ce52 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -406,7 +406,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (sg_count) {
 		io_req->sgl_list =
 			mempool_alloc(fnic->io_sgl_pool[io_req->sgl_type],
-				      GFP_ATOMIC | GFP_DMA);
+				      GFP_ATOMIC);
 		if (!io_req->sgl_list) {
 			ret = SCSI_MLQUEUE_HOST_BUSY;
 			scsi_dma_unmap(sc);



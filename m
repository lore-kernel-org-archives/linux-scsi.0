From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 2/5] crypto: scompress - use sgl_alloc() and sgl_free()
Date: Fri,  5 Jan 2018 08:26:47 -0800
Message-ID: <20180105162650.31083-3-bart.vanassche@wdc.com>
References: <20180105162650.31083-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12110 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbeAEQ0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 11:26:52 -0500
In-Reply-To: <20180105162650.31083-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>

Use the sgl_alloc() and sgl_free() functions instead of open coding
these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Kconfig     |  1 +
 crypto/scompress.c | 51 ++-------------------------------------------------
 2 files changed, 3 insertions(+), 49 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f7911963bb79..20360e040425 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -106,6 +106,7 @@ config CRYPTO_KPP
 config CRYPTO_ACOMP2
 	tristate
 	select CRYPTO_ALGAPI2
+	select SGL_ALLOC
 
 config CRYPTO_ACOMP
 	tristate
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 2075e2c4e7df..968bbcf65c94 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -140,53 +140,6 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 	return ret;
 }
 
-static void crypto_scomp_sg_free(struct scatterlist *sgl)
-{
-	int i, n;
-	struct page *page;
-
-	if (!sgl)
-		return;
-
-	n = sg_nents(sgl);
-	for_each_sg(sgl, sgl, n, i) {
-		page = sg_page(sgl);
-		if (page)
-			__free_page(page);
-	}
-
-	kfree(sgl);
-}
-
-static struct scatterlist *crypto_scomp_sg_alloc(size_t size, gfp_t gfp)
-{
-	struct scatterlist *sgl;
-	struct page *page;
-	int i, n;
-
-	n = ((size - 1) >> PAGE_SHIFT) + 1;
-
-	sgl = kmalloc_array(n, sizeof(struct scatterlist), gfp);
-	if (!sgl)
-		return NULL;
-
-	sg_init_table(sgl, n);
-
-	for (i = 0; i < n; i++) {
-		page = alloc_page(gfp);
-		if (!page)
-			goto err;
-		sg_set_page(sgl + i, page, PAGE_SIZE, 0);
-	}
-
-	return sgl;
-
-err:
-	sg_mark_end(sgl + i);
-	crypto_scomp_sg_free(sgl);
-	return NULL;
-}
-
 static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
@@ -220,7 +173,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 					      scratch_dst, &req->dlen, *ctx);
 	if (!ret) {
 		if (!req->dst) {
-			req->dst = crypto_scomp_sg_alloc(req->dlen, GFP_ATOMIC);
+			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
 			if (!req->dst)
 				goto out;
 		}
@@ -274,7 +227,7 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 
 	crt->compress = scomp_acomp_compress;
 	crt->decompress = scomp_acomp_decompress;
-	crt->dst_free = crypto_scomp_sg_free;
+	crt->dst_free = sgl_free;
 	crt->reqsize = sizeof(void *);
 
 	return 0;
-- 
2.15.1

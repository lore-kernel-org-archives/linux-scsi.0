From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel
Date: Thu, 10 Mar 2011 00:21:12 -0800
Message-ID: <1299745272-25477-3-git-send-email-nab@linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.216]:40769 "HELO
	nm21-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752292Ab1CJIVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 03:21:31 -0500
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Herbert Xu <herbert@gondor.apana.org.au>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds crc32c_cra_check_optimized() for use by the new
struct crypto_alg->cra_check_optimized() API caller in order to
call request_module() to load crc32c_intel.ko for CRC32C instruction
offload when available on CONFIG_X86 w/ SSE v4.2 compatiable hardware.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/crc32c.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index de9e55c..3f1d3a3 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -44,6 +44,8 @@
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
 
+static int crc32c_offload_enabled;
+
 struct chksum_ctx {
 	u32 key;
 };
@@ -221,6 +223,24 @@ static int crc32c_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crc32c_cra_check_optimized(struct crypto_alg *alg)
+{
+	if (crc32c_offload_enabled)
+		return;
+#ifdef CONFIG_X86
+	/*
+	 * For cpu_has_xmm4_2 go ahead and load crc32c_intel.ko in order so
+	 * crypto_alloc_hash("crc32c", ...) will automatically use SSE v4.2
+	 * CRC32C instruction offload.
+	 */
+	if (cpu_has_xmm4_2) {
+		int rc = request_module("crc32c_intel");
+		if (rc == 0)
+			crc32c_offload_enabled = 1;
+	}
+#endif
+}
+
 static struct shash_alg alg = {
 	.digestsize		=	CHKSUM_DIGEST_SIZE,
 	.setkey			=	chksum_setkey,
@@ -239,11 +259,14 @@ static struct shash_alg alg = {
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
 		.cra_init		=	crc32c_cra_init,
+		.cra_check_optimized	=	crc32c_cra_check_optimized,
 	}
 };
 
 static int __init crc32c_mod_init(void)
 {
+	crc32c_offload_enabled = 0;
+
 	return crypto_register_shash(&alg);
 }
 
-- 
1.5.6.5


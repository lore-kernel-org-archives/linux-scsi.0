From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v2 1/4] Wrap crc_t10dif function all to use crypto
 transform framework
Date: Thu, 25 Apr 2013 10:28:30 -0700
Message-ID: <1366910910.27102.126.camel@schen9-DESK>
References: <cover.1366214842.git.tim.c.chen@linux.intel.com>
	 <ea4271721b5ca130849b03da4f172f12f66e5628.1366214842.git.tim.c.chen@linux.intel.com>
	 <20130425132203.GA29501@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20130425132203.GA29501@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-04-25 at 21:22 +0800, Herbert Xu wrote:

> Please wrap the generic implementation as we do for crc32c.
> 

Herbert,

I've updated this patch to add the generic crct10dif transform (see
below).  Let me know if this address your comment.  Thanks.

Tim

When CRC T10 DIF is calculated using the crypto transform framework, we
wrap the crc_t10dif function call to utilize it.  This allows us to
take advantage of any accelerated CRC T10 DIF transform that is
plugged into the crypto framework.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Makefile            |   1 +
 crypto/crct10dif.c         | 126 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crc-t10dif.h |  10 ++++
 lib/crc-t10dif.c           |  96 ++++++++++++++++++++++++++++++++++
 4 files changed, 233 insertions(+)
 create mode 100644 crypto/crct10dif.c

diff --git a/crypto/Makefile b/crypto/Makefile
index a8e9b0f..62af87d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
diff --git a/crypto/crct10dif.c b/crypto/crct10dif.c
new file mode 100644
index 0000000..76b059a
--- /dev/null
+++ b/crypto/crct10dif.c
@@ -0,0 +1,126 @@
+/*
+ * Cryptographic API.
+ *
+ * T10 Data Integrity Field CRC16 Crypto Xform
+ *
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/crc-t10dif.h>
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+struct chksum_desc_ctx {
+	__u16 crc;
+};
+
+/*
+ * Steps through buffer one byte at at time, calculates reflected
+ * crc using table.
+ */
+
+static int chksum_init(struct shash_desc *desc)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = 0;
+
+	return 0;
+}
+
+static int chksum_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
+	return 0;
+}
+
+static int chksum_final(struct shash_desc *desc, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	*(__u16 *)out = ctx->crc;
+	return 0;
+}
+
+static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
+			u8 *out)
+{
+	*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
+	return 0;
+}
+
+static int chksum_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksum_finup(&ctx->crc, data, len, out);
+}
+
+static int chksum_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksum_finup(&ctx->crc, data, length, out);
+}
+
+static struct shash_alg alg = {
+	.digestsize		=	CRC_T10DIF_DIGEST_SIZE,
+	.init		=	chksum_init,
+	.update		=	chksum_update,
+	.final		=	chksum_final,
+	.finup		=	chksum_finup,
+	.digest		=	chksum_digest,
+	.descsize		=	sizeof(struct chksum_desc_ctx),
+	.base			=	{
+		.cra_name		=	"crct10dif",
+		.cra_driver_name	=	"crct10dif-generic",
+		.cra_priority		=	100,
+		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
+	}
+};
+
+static int __init crct10dif_mod_init(void)
+{
+	int ret;
+
+	ret = crypto_register_shash(&alg);
+	return ret;
+}
+
+static void __exit crct10dif_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(crct10dif_mod_init);
+module_exit(crct10dif_mod_fini);
+
+MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
+MODULE_DESCRIPTION("T10 DIF CRC calculation.");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index a9c96d8..f0eb4d5 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -3,6 +3,16 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_CRYPTO_CRCT10DIF
+
+#define CRC_T10DIF_DIGEST_SIZE 2
+#define CRC_T10DIF_BLOCK_SIZE 1
+
+__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len);
+void crc_t10dif_update_lib(void);
+
+#endif /* CONFIG_CRYPTO_CRCT10DIF */
+
 __u16 crc_t10dif(unsigned char const *, size_t);
 
 #endif
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fbbd66e..41f469a 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -11,6 +11,9 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc-t10dif.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <crypto/hash.h>
 
 /* Table generated using the following polynomium:
  * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
@@ -51,6 +54,98 @@ static const __u16 t10_dif_crc_table[256] = {
 	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
 };
 
+#ifdef CONFIG_CRYPTO_CRCT10DIF
+
+static struct crypto_shash *crct10dif_tfm;
+
+/* flag to indicate update to new algorithm in progress*/
+static bool crc_t10dif_newalg;
+
+__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
+{
+	unsigned int i;
+
+	for (i = 0 ; i < len ; i++)
+		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
+
+	return crc;
+}
+EXPORT_SYMBOL(crc_t10dif_generic);
+
+/*
+ * If we have defined crypto transform for CRC-T10DIF, use that instead.
+ * This allows us to plug in fast version of CRC-T10DIF when available.
+ */
+
+void crc_t10dif_update_lib()
+{
+	struct crypto_shash *old_tfm, *new_tfm;
+
+	old_tfm = crct10dif_tfm;
+	crc_t10dif_newalg = true;
+	/* make sure new alg flag is turned on before starting to switch tfm */
+	mb();
+
+	new_tfm = crypto_alloc_shash("crct10dif", 0, 0);
+	if (IS_ERR(new_tfm))
+		goto done;
+
+	if (old_tfm)
+		if (crypto_tfm_alg_priority(&old_tfm->base) >=
+		    crypto_tfm_alg_priority(&new_tfm->base)) {
+			crypto_free_shash(new_tfm);
+			goto done;
+		}
+	crct10dif_tfm = new_tfm;
+	/* make sure update to tfm pointer is completed */
+	mb();
+	crypto_free_shash(old_tfm);
+
+done:
+	crc_t10dif_newalg = false;
+}
+EXPORT_SYMBOL(crc_t10dif_update_lib);
+
+__u16 crc_t10dif(const unsigned char *buffer, size_t len)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[2];
+	} desc;
+	int err;
+
+	/* plugging in new alg or not using a tfm? */
+	if (unlikely(crc_t10dif_newalg) || (!crct10dif_tfm))
+		return crc_t10dif_generic(0, buffer, len);
+
+	desc.shash.tfm = crct10dif_tfm;
+	desc.shash.flags = 0;
+	*(__u16 *)desc.ctx = 0;
+
+	err = crypto_shash_update(&desc.shash, buffer, len);
+	BUG_ON(err);
+
+	return *(__u16 *)desc.ctx;
+}
+EXPORT_SYMBOL(crc_t10dif);
+
+static int __init crc_t10dif_mod_init(void)
+{
+	crct10dif_tfm = NULL;
+	crc_t10dif_newalg = false;
+	return 0;
+}
+
+static void __exit crc_t10dif_mod_fini(void)
+{
+	if (crct10dif_tfm)
+		crypto_free_shash(crct10dif_tfm);
+}
+
+module_init(crc_t10dif_mod_init);
+module_exit(crc_t10dif_mod_fini);
+
+#else
 __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 {
 	__u16 crc = 0;
@@ -62,6 +157,7 @@ __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 	return crc;
 }
 EXPORT_SYMBOL(crc_t10dif);
+#endif
 
 MODULE_DESCRIPTION("T10 DIF CRC calculation");
 MODULE_LICENSE("GPL");
-- 
1.7.11.7

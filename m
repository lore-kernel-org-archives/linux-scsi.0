From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 1/4] Wrap crc_t10dif function all to use crypto transform framework
Date: Tue, 16 Apr 2013 09:20:48 -0700
Message-ID: <ea4271721b5ca130849b03da4f172f12f66e5628.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965658Ab3DPXZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Apr 2013 19:25:23 -0400
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org

When CRC T10 DIF is calculated using the crypto transform framework, we
wrap the crc_t10dif function call to utilize it.  This allows us to
take advantage of any accelerated CRC T10 DIF transform that is
plugged into the crypto framework.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Keith Busch <keith.busch@intel.com>
---
 include/linux/crc-t10dif.h | 10 +++++
 lib/crc-t10dif.c           | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

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


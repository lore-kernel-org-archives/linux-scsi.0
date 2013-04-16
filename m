From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 3/4] Glue code to cast accelerated CRCT10DIF assembly as a crypto transform
Date: Tue, 16 Apr 2013 09:20:50 -0700
Message-ID: <e86109045ffb315699cf9aa9c4d82f29c9039529.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Glue code that plugs the PCLMULQDQ accelerated CRC T10 DIF hash into the
crypto framework.  The config CRYPTO_CRCT10DIF_PCLMUL should be turned
on to enable the feature.  The crc_t10dif crypto library function will
use this faster algorithm when crct10dif_pclmul module is loaded.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Keith Busch <keith.busch@intel.com>
---
 arch/x86/crypto/Makefile                |   2 +
 arch/x86/crypto/crct10dif-pclmul_glue.c | 153 ++++++++++++++++++++++++++++++++
 crypto/Kconfig                          |  21 +++++
 3 files changed, 176 insertions(+)
 create mode 100644 arch/x86/crypto/crct10dif-pclmul_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 03cd731..d544a66 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
@@ -70,3 +71,4 @@ crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
 crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
 sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
+crct10dif-pclmul-y := crct10dif-pcl-asm_64.o crct10dif-pclmul_glue.o
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
new file mode 100644
index 0000000..e87f8d8
--- /dev/null
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -0,0 +1,153 @@
+/*
+ * Cryptographic API.
+ *
+ * T10 Data Integrity Field CRC16 Crypto Xform using PCLMULQDQ Instructions
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
+#include <asm/i387.h>
+#include <asm/cpufeature.h>
+
+asmlinkage __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
+				size_t len);
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
+	if (irq_fpu_usable()) {
+		kernel_fpu_begin();
+		ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
+		kernel_fpu_end();
+	} else
+		ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
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
+	if (irq_fpu_usable()) {
+		kernel_fpu_begin();
+		*(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
+		kernel_fpu_end();
+	} else
+		*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
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
+		.cra_driver_name	=	"crct10dif-pclmul",
+		.cra_priority		=	200,
+		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
+	}
+};
+
+static int __init crct10dif_intel_mod_init(void)
+{
+	int ret;
+
+	ret = 0;
+	if (cpu_has_pclmulqdq) {
+		ret = crypto_register_shash(&alg);
+		if (!ret)
+			crc_t10dif_update_lib();
+	}
+	return ret;
+}
+
+static void __exit crct10dif_intel_mod_fini(void)
+{
+	/* switch crc_t10dif library back to generic algorithm */
+	if (cpu_has_pclmulqdq) {
+		crypto_unregister_shash(&alg);
+		crc_t10dif_update_lib();
+	}
+}
+
+module_init(crct10dif_intel_mod_init);
+module_exit(crct10dif_intel_mod_fini);
+
+MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
+MODULE_DESCRIPTION("T10 DIF CRC calculation accelerated with PCLMULQDQ.");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("crct10dif");
+MODULE_ALIAS("crct10dif-pclmul");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0e7a237..f69b045 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -376,6 +376,27 @@ config CRYPTO_CRC32_PCLMUL
 	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
 	  and gain better performance as compared with the table implementation.
 
+config CRYPTO_CRCT10DIF
+	bool "CRCT10DIF algorithm"
+	select CRYPTO_HASH
+	select CRC_T10DIF
+	help
+	  CRC T10 Data Integrity Field computation is being cast as
+	  a crypto transform.  This allows for faster crc t10 diff
+	  transforms to be used if they are available.
+
+config CRYPTO_CRCT10DIF_PCLMUL
+	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
+	depends on X86 && 64BIT
+	select CRYPTO_HASH
+	select CRYPTO_CRCT10DIF
+	help
+	  For x86_64 processors with SSE4.2 and PCLMULQDQ supported,
+	  CRC T10 DIF PCLMULQDQ computation can be hardware
+	  accelerated PCLMULQDQ instruction. This option will create
+	  'crct10dif-plcmul' module, which is faster when computing the
+	  crct10dif checksum compared to the generic table implementation.
+
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
 	select CRYPTO_GF128MUL
-- 
1.7.11.7

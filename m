From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 3/3] crc-t10dif: Allow current transform to be inspected in sysfs
Date: Thu, 30 Aug 2018 11:00:16 -0400
Message-ID: <20180830150016.15661-3-martin.petersen@oracle.com>
References: <20180827060918.tfz7ljufqhlej4kq@gondor.apana.org.au>
 <20180830150016.15661-1-martin.petersen@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830150016.15661-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Add a way to print the currently active CRC algorithm in:

	/sys/module/crc_t10dif/parameters/transform

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 lib/crc-t10dif.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 52f577a3868d..6507fa101eff 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -107,6 +107,17 @@ static void __exit crc_t10dif_mod_fini(void)
 module_init(crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_fini);
 
+static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
+{
+	if (static_key_false(&crct10dif_fallback))
+		return sprintf(buffer, "fallback\n");
+
+	return sprintf(buffer, "%s\n",
+		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
+}
+
+module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
+
 MODULE_DESCRIPTION("T10 DIF CRC calculation");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: crct10dif");
-- 
2.17.1

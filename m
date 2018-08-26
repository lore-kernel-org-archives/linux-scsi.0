From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/4] crc-t10dif: Pick better transform if one becomes
 available
Date: Sat, 25 Aug 2018 19:40:04 -0700 (PDT)
Message-ID: <20180826024006.13800-2-martin.petersen@oracle.com>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
 <20180826024006.13800-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180826024006.13800-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

T10 CRC library is linked into the kernel thanks to block and SCSI. The
crypto accelerators are typically loaded later as modules and are
therefore not available when the T10 CRC library is initialized.

Use the crypto notifier facility to trigger a switch to a better algorithm
if one becomes available after the initial hash has been registered. Use
RCU to protect the original transform while the new one is being set up.

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/crc-t10dif.h |  1 +
 lib/crc-t10dif.c           | 46 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 1fe0cfcdea30..6bb0c0bf357b 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -6,6 +6,7 @@
 
 #define CRC_T10DIF_DIGEST_SIZE 2
 #define CRC_T10DIF_BLOCK_SIZE 1
+#define CRC_T10DIF_STRING "crct10dif"
 
 extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
 				size_t len);
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 1ad33e555805..72076a902df5 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -14,10 +14,47 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <crypto/hash.h>
+#include <crypto/algapi.h>
 #include <linux/static_key.h>
+#include <linux/notifier.h>
 
-static struct crypto_shash *crct10dif_tfm;
+static struct crypto_shash __rcu *crct10dif_tfm;
 static struct static_key crct10dif_fallback __read_mostly;
+DEFINE_SPINLOCK(crc_t10dif_mutex);
+
+static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct crypto_alg *alg = data;
+	struct crypto_shash *new, *old;
+
+	if (val != CRYPTO_MSG_ALG_LOADED ||
+	    static_key_false(&crct10dif_fallback) ||
+	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
+		return 0;
+
+	spin_lock(&crc_t10dif_mutex);
+	old = rcu_dereference_protected(crct10dif_tfm,
+					lockdep_is_held(&crc_t10dif_mutex));
+	if (!old) {
+		spin_unlock(&crc_t10dif_mutex);
+		return 0;
+	}
+	new = crypto_alloc_shash("crct10dif", 0, 0);
+	if (IS_ERR(new)) {
+		spin_unlock(&crc_t10dif_mutex);
+		return 0;
+	}
+	rcu_assign_pointer(crct10dif_tfm, new);
+	spin_unlock(&crc_t10dif_mutex);
+
+	synchronize_rcu();
+	crypto_free_shash(old);
+	return 0;
+}
+
+static struct notifier_block crc_t10dif_nb = {
+	.notifier_call = crc_t10dif_rehash,
+};
 
 __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 {
@@ -30,11 +67,14 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 	if (static_key_false(&crct10dif_fallback))
 		return crc_t10dif_generic(crc, buffer, len);
 
-	desc.shash.tfm = crct10dif_tfm;
+	rcu_read_lock();
+	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
 	desc.shash.flags = 0;
 	*(__u16 *)desc.ctx = crc;
 
 	err = crypto_shash_update(&desc.shash, buffer, len);
+	rcu_read_unlock();
+
 	BUG_ON(err);
 
 	return *(__u16 *)desc.ctx;
@@ -49,6 +89,7 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	crypto_register_notifier(&crc_t10dif_nb);
 	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
 	if (IS_ERR(crct10dif_tfm)) {
 		static_key_slow_inc(&crct10dif_fallback);
@@ -59,6 +100,7 @@ static int __init crc_t10dif_mod_init(void)
 
 static void __exit crc_t10dif_mod_fini(void)
 {
+	crypto_unregister_notifier(&crc_t10dif_nb);
 	crypto_free_shash(crct10dif_tfm);
 }
 
-- 
2.17.1

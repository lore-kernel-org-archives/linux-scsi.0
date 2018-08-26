From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/4] crypto: Introduce notifier for new crypto algorithms
Date: Sat, 25 Aug 2018 22:40:03 -0400
Message-ID: <20180826024006.13800-1-martin.petersen@oracle.com>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Introduce a facility that can be used to receive a notification
callback when a new algorithm becomes available. This can be used by
existing crypto registrations to trigger a switch from a software-only
algorithm to a hardware-accelerated version.

A new CRYPTO_MSG_ALG_LOADED state is introduced to the existing crypto
notification chain, and the register/unregister functions are exported
so they can be called by subsystems outside of crypto.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c         |  7 +++----
 crypto/algboss.c        |  2 ++
 crypto/internal.h       |  8 --------
 include/crypto/algapi.h | 10 ++++++++++
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c0755cf4f53f..87abad3cc322 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -361,15 +361,12 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
 	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
 	if (err != NOTIFY_STOP) {
 		if (WARN_ON(err != NOTIFY_DONE))
-			goto out;
+			return;
 		crypto_alg_tested(larval->alg.cra_driver_name, 0);
 	}
 
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
-
-out:
-	crypto_larval_kill(&larval->alg);
 }
 
 int crypto_register_alg(struct crypto_alg *alg)
@@ -390,6 +387,8 @@ int crypto_register_alg(struct crypto_alg *alg)
 		return PTR_ERR(larval);
 
 	crypto_wait_for_test(larval);
+	crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
+	crypto_larval_kill(&larval->alg);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 5e6df2a087fa..527b44d0af21 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -274,6 +274,8 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 		return cryptomgr_schedule_probe(data);
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
+	case CRYPTO_MSG_ALG_LOADED:
+		break;
 	}
 
 	return NOTIFY_DONE;
diff --git a/crypto/internal.h b/crypto/internal.h
index 9a3f39939fba..ef769b5e8ad3 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,12 +26,6 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 
-/* Crypto notification events. */
-enum {
-	CRYPTO_MSG_ALG_REQUEST,
-	CRYPTO_MSG_ALG_REGISTER,
-};
-
 struct crypto_instance;
 struct crypto_template;
 
@@ -90,8 +84,6 @@ struct crypto_alg *crypto_find_alg(const char *alg_name,
 void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask);
 
-int crypto_register_notifier(struct notifier_block *nb);
-int crypto_unregister_notifier(struct notifier_block *nb);
 int crypto_probing_notify(unsigned long val, void *v);
 
 unsigned int crypto_alg_extsize(struct crypto_alg *alg);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index bd5e8ccf1687..807501a4a754 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -425,4 +425,14 @@ static inline void crypto_yield(u32 flags)
 #endif
 }
 
+int crypto_register_notifier(struct notifier_block *nb);
+int crypto_unregister_notifier(struct notifier_block *nb);
+
+/* Crypto notification events. */
+enum {
+	CRYPTO_MSG_ALG_REQUEST,
+	CRYPTO_MSG_ALG_REGISTER,
+	CRYPTO_MSG_ALG_LOADED,
+};
+
 #endif	/* _CRYPTO_ALGAPI_H */
-- 
2.17.1

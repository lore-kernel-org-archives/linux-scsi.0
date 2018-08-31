From: Jeffrey Lien <Jeff.Lien@wdc.com>
Subject: RE: [PATCH v2 1/3] crypto: Introduce notifier for new crypto
 algorithms
Date: Fri, 31 Aug 2018 17:17:34 +0000
Message-ID: <SN1PR04MB18242CFC7BBA2A40495FA9BCEA0F0@SN1PR04MB1824.namprd04.prod.outlook.com>
References: <20180827060918.tfz7ljufqhlej4kq@gondor.apana.org.au>
 <20180830150016.15661-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830150016.15661-1-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, David Darrington <david.darrington@wdc.com>, "hch@infradead.org" <hch@infradead.org>, Jeff Furlong <jeff.furlong@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Martin,
I tried out this latest series of patches on my system and the performance =
is matches what I saw with CONFIG_CRYPTO_CRCT10DIF_PCLMUL=3DY, as expected.=
  =20

In this case, I applied your patches and built with CONFIG_CRYPTO_CRCT10DIF=
_PCLMUL=3Dm.  =20

Is there anything else I should be checking or verifying?  =20


Jeff Lien

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]=20
Sent: Thursday, August 30, 2018 10:00 AM
To: herbert@gondor.apana.org.au
Cc: Jeffrey Lien <Jeff.Lien@wdc.com>; ard.biesheuvel@linaro.org; David Darr=
ington <david.darrington@wdc.com>; hch@infradead.org; Jeff Furlong <jeff.fu=
rlong@wdc.com>; linux-block@vger.kernel.org; linux-crypto@vger.kernel.org; =
linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; martin.petersen@o=
racle.com; tim.c.chen@linux.intel.com
Subject: [PATCH v2 1/3] crypto: Introduce notifier for new crypto algorithm=
s

Introduce a facility that can be used to receive a notification callback wh=
en a new algorithm becomes available. This can be used by existing crypto r=
egistrations to trigger a switch from a software-only algorithm to a hardwa=
re-accelerated version.

A new CRYPTO_MSG_ALG_LOADED state is introduced to the existing crypto noti=
fication chain, and the register/unregister functions are exported so they =
can be called by subsystems outside of crypto.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c         |  2 ++
 crypto/algboss.c        |  2 ++
 crypto/internal.h       |  8 --------
 include/crypto/algapi.h | 10 ++++++++++
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c index c0755cf4f53f..33522a14=
7412 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -367,6 +367,8 @@ static void crypto_wait_for_test(struct crypto_larval *=
larval)
=20
 	err =3D wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
+	if (!err)
+		crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
=20
 out:
 	crypto_larval_kill(&larval->alg);
diff --git a/crypto/algboss.c b/crypto/algboss.c index 5e6df2a087fa..527b44=
d0af21 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -274,6 +274,8 @@ static int cryptomgr_notify(struct notifier_block *this=
, unsigned long msg,
 		return cryptomgr_schedule_probe(data);
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
+	case CRYPTO_MSG_ALG_LOADED:
+		break;
 	}
=20
 	return NOTIFY_DONE;
diff --git a/crypto/internal.h b/crypto/internal.h index 9a3f39939fba..ef76=
9b5e8ad3 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,12 +26,6 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
=20
-/* Crypto notification events. */
-enum {
-	CRYPTO_MSG_ALG_REQUEST,
-	CRYPTO_MSG_ALG_REGISTER,
-};
-
 struct crypto_instance;
 struct crypto_template;
=20
@@ -90,8 +84,6 @@ struct crypto_alg *crypto_find_alg(const char *alg_name, =
 void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask);
=20
-int crypto_register_notifier(struct notifier_block *nb); -int crypto_unreg=
ister_notifier(struct notifier_block *nb);  int crypto_probing_notify(unsig=
ned long val, void *v);
=20
 unsigned int crypto_alg_extsize(struct crypto_alg *alg); diff --git a/incl=
ude/crypto/algapi.h b/include/crypto/algapi.h index bd5e8ccf1687..807501a4a=
754 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -425,4 +425,14 @@ static inline void crypto_yield(u32 flags)  #endif  }
=20
+int crypto_register_notifier(struct notifier_block *nb); int=20
+crypto_unregister_notifier(struct notifier_block *nb);
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

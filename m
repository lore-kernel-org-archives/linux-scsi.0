From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 4/4] Simple correctness and speed test for CRCT10DIF hash
Date: Tue, 16 Apr 2013 09:20:51 -0700
Message-ID: <de2e172b3c5b5d2ce77978be56aaa8b84272f5d6.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660Ab3DPXZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Apr 2013 19:25:24 -0400
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
In-Reply-To: <cover.1366120266.git.tim.c.chen@linux.intel.com>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org

These are simple tests to do sanity check of CRC T10 DIF hash.  The
correctness of the transform can be checked with the command
	modprobe tcrypt mode=47
The speed of the transform can be evaluated with the command
	modprobe tcrypt mode=320

Set the cpu frequency to constant and turn turbo off when running the
speed test so the frequency governor will not tweak the frequency and
affects the measurements.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Keith Busch <keith.busch@intel.com>
---
 crypto/tcrypt.c  |  8 ++++++++
 crypto/testmgr.c | 10 ++++++++++
 crypto/testmgr.h | 24 ++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 24ea7df..5e95722 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1174,6 +1174,10 @@ static int do_test(int m)
 		ret += tcrypt_test("ghash");
 		break;
 
+	case 47:
+		ret += tcrypt_test("crct10dif");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -1498,6 +1502,10 @@ static int do_test(int m)
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 320:
+		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3807084..b165316 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1944,6 +1944,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "crct10dif",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = {
+				.vecs = crct10dif_tv_template,
+				.count = CRCT10DIF_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "cryptd(__driver-cbc-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d503660..6262b74 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -450,6 +450,30 @@ static struct hash_testvec rmd320_tv_template[] = {
 	}
 };
 
+#define CRCT10DIF_TEST_VECTORS	2
+static struct hash_testvec crct10dif_tv_template[] = {
+	{
+		.plaintext = "abc",
+		.psize  = 3,
+#ifdef __LITTLE_ENDIAN
+		.digest = "\x3b\x44",
+#else
+		.digest = "\x44\x3b",
+#endif
+	}, {
+		.plaintext =
+		"abcddddddddddddddddddddddddddddddddddddddddddddddddddddd",
+		.psize  = 56,
+#ifdef __LITTLE_ENDIAN
+		.digest = "\xe3\x9c",
+#else
+		.digest = "\x9c\xe3",
+#endif
+		.np     = 2,
+		.tap    = { 28, 28 }
+	}
+};
+
 /*
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
-- 
1.7.11.7


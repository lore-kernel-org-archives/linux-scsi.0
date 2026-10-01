Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AF25B0B8;
	Thu,  1 Oct 2026 04:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830385; cv=none; b=cOdarI0Ei2tMWg5WfF5Is+cAzPjSG97otGJnCtldqaAAbl3pwEiSCfsh8Loj5fIZ94dMZM5ZkKHa1aQC6a23J2frvSLxKGUsXdjeF2rUTZqs97z53APzAbbEtqNLFp/y/kx5S7Gv/u8LO3//Wy2Tl8KKPpIfdTiKyFRICJ8J3rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830385; c=relaxed/simple;
	bh=RJHfrMQOzeHasJQc11GC2/zOmdRNEZMzbZObrLV+tv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ti2yoXBLLurijdWVt5yh25Hxf5yi93IOLq/nqibbYS717fWgzlDxEGM6gGU5W0hHMX3Y0wS7A4xT3QHskyLwSaa5Iltb/Ek4LDvcCOfrTmbQOG1qcK4evMS8Scih6acFzokoJjM0xmAlpEAX8PDNjfwUYBn7Wc0Zpln8NVW3sPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXa+yI/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXa+yI/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219E51F000FF;
	Thu,  1 Oct 2026 04:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790830383;
	bh=ZPNVNGCC7+f9k0tOjdVXJLDay1HZfqVmIkEgdHRNsSM=;
	h=From:To:Cc:Subject:Date;
	b=IXa+yI/2dJzK3DRrTuM1gC/qt2/shJYyH47ay7PLkiM5azSKrPlb0rEWDyh5bhuFj
	 r6CYwB0TFVgcSWrbeNWYgLG4ekanEszPAsoV9WJDVlmL8/d+qVYn3t1Xw3EZ+xT9Vx
	 Uu5V2Brgi2o6WjQuc8toibWGG8djO6J77BtY00WIXu0XjbEHsWUlDS4jB6xGRAy7cf
	 tdV13CxBzb8o7dBxHe2o/YqRWa8eukeft/NGvHOEt5BTr9SvKqFWTyGvaLq+rSorf8
	 zM0VJnYmlo6d9PnqLGaVul8eUyvaEclaP5l/tP0y855pbniz3Ko1+Wwf4Wx32+R2SH
	 fouJ+x2XiOd5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] scsi: target: iscsi: Use crypto library API
Date: Wed, 30 Sep 2026 21:48:57 -0700
Message-ID: <20261001044857.169487-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make iscsi_target_auth.c call into the crypto library directly instead
of going through crypto_shash.  This is simpler and much more efficient,
as it avoids overhead of the crypto_shash layer.  The hash computation
itself also no longer has error codes that need to be checked.

For simplicity, still do a memory allocation per operation to buffer the
data (which is typically less than 50 bytes here) so that the one-shot
digest functions can be used.  It's still much more efficient than doing
the super slow crypto_alloc_shash().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/target/iscsi/Kconfig             |   7 +-
 drivers/target/iscsi/iscsi_target_auth.c | 192 +++++++++--------------
 drivers/target/iscsi/iscsi_target_auth.h |   8 +-
 3 files changed, 78 insertions(+), 129 deletions(-)

diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index 70d76f3dd693..44bbf1f32859 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -3,8 +3,11 @@ config ISCSI_TARGET
 	tristate "SCSI Target Mode Stack"
 	depends on INET
 	select CRC32
-	select CRYPTO
-	select CRYPTO_HASH
+	select CRYPTO_LIB_MD5
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA3
+	select CRYPTO_LIB_UTILS
 	help
 	Say M to enable the SCSI target mode stack. A SCSI target mode stack
 	is software that makes local storage available over a storage network
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index f3c0cdd31830..945dd6409723 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -8,31 +8,73 @@
  *
  ******************************************************************************/
 
-#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <crypto/sha3.h>
 #include <crypto/utils.h>
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/err.h>
 #include <linux/hex.h>
 #include <linux/random.h>
-#include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_nego.h"
 #include "iscsi_target_auth.h"
 
-static char *chap_get_digest_name(const int digest_type)
+static const struct {
+	const char *digest_name; /* Used only in log messages */
+	unsigned int digest_size;
+} chap_digest_algs[] = {
+	[CHAP_DIGEST_MD5] = {
+		.digest_name = "md5",
+		.digest_size = MD5_DIGEST_SIZE,
+	},
+	[CHAP_DIGEST_SHA1] = {
+		.digest_name = "sha1",
+		.digest_size = SHA1_DIGEST_SIZE,
+	},
+	[CHAP_DIGEST_SHA256] = {
+		.digest_name = "sha256",
+		.digest_size = SHA256_DIGEST_SIZE,
+	},
+	[CHAP_DIGEST_SHA3_256] = {
+		.digest_name = "sha3-256",
+		.digest_size = SHA3_256_DIGEST_SIZE,
+	},
+};
+
+static int chap_digest(int digest_type, u8 chap_id, const char *password,
+		       const u8 *challenge, size_t challenge_len,
+		       u8 *out_digest)
 {
+	size_t pass_len = strlen(password);
+	size_t data_len = 1 + pass_len + challenge_len;
+	u8 *data __free(kfree_sensitive) = kmalloc(data_len, GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+	data[0] = chap_id;
+	memcpy(&data[1], password, pass_len);
+	memcpy(&data[1 + pass_len], challenge, challenge_len);
+
 	switch (digest_type) {
 	case CHAP_DIGEST_MD5:
-		return "md5";
+		md5(data, data_len, out_digest);
+		return 0;
 	case CHAP_DIGEST_SHA1:
-		return "sha1";
+		sha1(data, data_len, out_digest);
+		return 0;
 	case CHAP_DIGEST_SHA256:
-		return "sha256";
+		sha256(data, data_len, out_digest);
+		return 0;
 	case CHAP_DIGEST_SHA3_256:
-		return "sha3-256";
+		sha3_256(data, data_len, out_digest);
+		return 0;
 	default:
-		return NULL;
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
 }
 
@@ -72,21 +114,9 @@ static int chap_gen_challenge(
 	return ret;
 }
 
-static int chap_test_algorithm(const char *name)
-{
-	struct crypto_shash *tfm;
-
-	tfm = crypto_alloc_shash(name, 0, 0);
-	if (IS_ERR(tfm))
-		return -1;
-
-	crypto_free_shash(tfm);
-	return 0;
-}
-
 static int chap_check_algorithm(const char *a_str)
 {
-	char *tmp, *orig, *token, *digest_name;
+	char *tmp, *orig, *token;
 	long digest_type;
 	int r = CHAP_DIGEST_UNKNOWN;
 
@@ -113,17 +143,17 @@ static int chap_check_algorithm(const char *a_str)
 		if (kstrtol(token, 10, &digest_type))
 			continue;
 
-		digest_name = chap_get_digest_name(digest_type);
-		if (!digest_name)
+		if (fips_enabled && digest_type == CHAP_DIGEST_MD5)
 			continue;
 
-		pr_debug("Selected %s Algorithm\n", digest_name);
-		if (chap_test_algorithm(digest_name) < 0) {
-			pr_err("failed to allocate %s algo\n", digest_name);
-		} else {
-			r = digest_type;
-			goto out;
-		}
+		if (digest_type < 0 ||
+		    digest_type >= ARRAY_SIZE(chap_digest_algs) ||
+		    chap_digest_algs[digest_type].digest_name == NULL)
+			continue;
+		pr_debug("Selected %s Algorithm\n",
+			 chap_digest_algs[digest_type].digest_name);
+		r = digest_type;
+		goto out;
 	}
 out:
 	kfree(orig);
@@ -159,27 +189,15 @@ static struct iscsi_chap *chap_server_open(
 
 	chap = conn->auth_protocol;
 	digest_type = chap_check_algorithm(a_str);
-	switch (digest_type) {
-	case CHAP_DIGEST_MD5:
-		chap->digest_size = MD5_SIGNATURE_SIZE;
-		break;
-	case CHAP_DIGEST_SHA1:
-		chap->digest_size = SHA1_SIGNATURE_SIZE;
-		break;
-	case CHAP_DIGEST_SHA256:
-		chap->digest_size = SHA256_SIGNATURE_SIZE;
-		break;
-	case CHAP_DIGEST_SHA3_256:
-		chap->digest_size = SHA3_256_SIGNATURE_SIZE;
-		break;
-	case CHAP_DIGEST_UNKNOWN:
-	default:
+	if (digest_type == CHAP_DIGEST_UNKNOWN) {
 		pr_err("Unsupported CHAP_A value\n");
 		chap_close(conn);
 		return NULL;
 	}
 
-	chap->digest_name = chap_get_digest_name(digest_type);
+	chap->digest_name = chap_digest_algs[digest_type].digest_name;
+	chap->digest_type = digest_type;
+	chap->digest_size = chap_digest_algs[digest_type].digest_size;
 
 	/* Tie the challenge length to the digest size */
 	chap->challenge_len = chap->digest_size;
@@ -247,7 +265,6 @@ static int chap_server_compute_hash(
 	unsigned int *nr_out_len)
 {
 	unsigned long id;
-	unsigned char id_as_uchar;
 	unsigned char type;
 	unsigned char identifier[10], *initiatorchg = NULL;
 	unsigned char *initiatorchg_binhex = NULL;
@@ -258,8 +275,6 @@ static int chap_server_compute_hash(
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
 	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
-	struct crypto_shash *tfm = NULL;
-	struct shash_desc *desc = NULL;
 	int auth_ret = -1, ret, initiatorchg_len;
 
 	digest = kzalloc(chap->digest_size, GFP_KERNEL);
@@ -364,44 +379,10 @@ static int chap_server_compute_hash(
 
 	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
 
-	tfm = crypto_alloc_shash(chap->digest_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		tfm = NULL;
-		pr_err("Unable to allocate struct crypto_shash\n");
-		goto out;
-	}
-
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
-	if (!desc) {
-		pr_err("Unable to allocate struct shash_desc\n");
-		goto out;
-	}
-
-	desc->tfm = tfm;
-
-	ret = crypto_shash_init(desc);
-	if (ret < 0) {
-		pr_err("crypto_shash_init() failed\n");
-		goto out;
-	}
-
-	ret = crypto_shash_update(desc, &chap->id, 1);
-	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for id\n");
-		goto out;
-	}
-
-	ret = crypto_shash_update(desc, (char *)&auth->password,
-				  strlen(auth->password));
-	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for password\n");
-		goto out;
-	}
-
-	ret = crypto_shash_finup(desc, chap->challenge,
-				 chap->challenge_len, server_digest);
+	ret = chap_digest(chap->digest_type, chap->id, auth->password,
+			  chap->challenge, chap->challenge_len, server_digest);
 	if (ret < 0) {
-		pr_err("crypto_shash_finup() failed for challenge\n");
+		pr_err("chap_digest() failed\n");
 		goto out;
 	}
 
@@ -530,40 +511,12 @@ static int chap_server_compute_hash(
 	/*
 	 * Generate CHAP_N and CHAP_R for mutual authentication.
 	 */
-	ret = crypto_shash_init(desc);
+	ret = chap_digest(chap->digest_type, id, auth->password_mutual,
+			  initiatorchg_binhex, initiatorchg_len, digest);
 	if (ret < 0) {
-		pr_err("crypto_shash_init() failed\n");
+		pr_err("chap_digest() failed\n");
 		goto out;
 	}
-
-	/* To handle both endiannesses */
-	id_as_uchar = id;
-	ret = crypto_shash_update(desc, &id_as_uchar, 1);
-	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for id\n");
-		goto out;
-	}
-
-	ret = crypto_shash_update(desc, auth->password_mutual,
-				  strlen(auth->password_mutual));
-	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for"
-				" password_mutual\n");
-		goto out;
-	}
-	/*
-	 * Convert received challenge to binary hex.
-	 */
-	ret = crypto_shash_finup(desc, initiatorchg_binhex, initiatorchg_len,
-				 digest);
-	if (ret < 0) {
-		pr_err("crypto_shash_finup() failed for ma challenge\n");
-		goto out;
-	}
-
-	/*
-	 * Generate CHAP_N and CHAP_R.
-	 */
 	*nr_out_len = sprintf(nr_out_ptr, "CHAP_N=%s", auth->userid_mutual);
 	*nr_out_len += 1;
 	pr_debug("[server] Sending CHAP_N=%s\n", auth->userid_mutual);
@@ -577,9 +530,6 @@ static int chap_server_compute_hash(
 	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
 	auth_ret = 0;
 out:
-	kfree_sensitive(desc);
-	if (tfm)
-		crypto_free_shash(tfm);
 	kfree(initiatorchg);
 	kfree(initiatorchg_binhex);
 	kfree(digest);
diff --git a/drivers/target/iscsi/iscsi_target_auth.h b/drivers/target/iscsi/iscsi_target_auth.h
index ceb9b7754770..7ed288936af2 100644
--- a/drivers/target/iscsi/iscsi_target_auth.h
+++ b/drivers/target/iscsi/iscsi_target_auth.h
@@ -15,11 +15,6 @@
 #define MAX_RESPONSE_LENGTH	128	/* sufficient for SHA3 256 */
 #define	MAX_CHAP_N_SIZE		512
 
-#define MD5_SIGNATURE_SIZE	16	/* 16 bytes in a MD5 message digest */
-#define SHA1_SIGNATURE_SIZE	20	/* 20 bytes in a SHA1 message digest */
-#define SHA256_SIGNATURE_SIZE	32	/* 32 bytes in a SHA256 message digest */
-#define SHA3_256_SIGNATURE_SIZE	32	/* 32 bytes in a SHA3 256 message digest */
-
 #define CHAP_STAGE_CLIENT_A	1
 #define CHAP_STAGE_SERVER_AIC	2
 #define CHAP_STAGE_CLIENT_NR	3
@@ -36,7 +31,8 @@ struct iscsi_chap {
 	unsigned char	id;
 	unsigned char	challenge[MAX_CHAP_CHALLENGE_LEN];
 	unsigned int	challenge_len;
-	unsigned char	*digest_name;
+	const char	*digest_name;
+	int		digest_type;
 	unsigned int	digest_size;
 	unsigned int	authenticate_target;
 	unsigned int	chap_state;

base-commit: 551c722f40809618230001baccf219193e22fc5a
-- 
2.56.0


From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/8] target/iscsi: Less function calls in
 chap_server_compute_md5() after error detection
Date: Tue, 12 Dec 2017 22:42:49 +0100
Message-ID: <5a981970-0474-52a4-5415-bedda030f17a@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 18:00:41 +0100

The functions "crypto_free_shash", "kfree" and "kzfree" were called
in a few cases by the chap_server_compute_md5() function during error
handling even if the passed variable contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Delete initialisations for the variables "challenge", "challenge_binhex",
  "desc" and "tfm" at the beginning which became unnecessary
  with this refactoring.

Fixes: 69110e3cedbb8aad1c70d91ed58a9f4f0ed9eec6 ("iscsi-target: Use shash and ahash")
Fixes: e48354ce078c079996f89d715dfa44814b4eba01 ("iscsi-target: Add iSCSI fabric support for target v4.1")

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_auth.c | 71 +++++++++++++++++---------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index f9bc8ec6fb6b..94b011fe74e8 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -186,15 +186,15 @@ static int chap_server_compute_md5(
 	unsigned char id_as_uchar;
 	unsigned char digest[MD5_SIGNATURE_SIZE];
 	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
-	unsigned char identifier[10], *challenge = NULL;
-	unsigned char *challenge_binhex = NULL;
+	unsigned char identifier[10], *challenge;
+	unsigned char *challenge_binhex;
 	unsigned char client_digest[MD5_SIGNATURE_SIZE];
 	unsigned char server_digest[MD5_SIGNATURE_SIZE];
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
 	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
-	struct crypto_shash *tfm = NULL;
-	struct shash_desc *desc = NULL;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
 	int auth_ret = -1, ret, challenge_len;
 
 	memset(identifier, 0, 10);
@@ -208,13 +208,13 @@ static int chap_server_compute_md5(
 	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge) {
 		pr_err("Unable to allocate challenge buffer\n");
-		goto out;
+		goto exit;
 	}
 
 	challenge_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge_binhex) {
 		pr_err("Unable to allocate challenge_binhex buffer\n");
-		goto out;
+		goto free_challenge;
 	}
 	/*
 	 * Extract CHAP_N.
@@ -222,18 +222,18 @@ static int chap_server_compute_md5(
 	if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
 				&type) < 0) {
 		pr_err("Could not find CHAP_N.\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 	if (type == HEX) {
 		pr_err("Could not find CHAP_N.\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 
 	/* Include the terminating NULL in the compare */
 	compare_len = strlen(auth->userid) + 1;
 	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
 		pr_err("CHAP_N values do not match!\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 	pr_debug("[server] Got CHAP_N=%s\n", chap_n);
 	/*
@@ -242,11 +242,11 @@ static int chap_server_compute_md5(
 	if (extract_param(nr_in_ptr, "CHAP_R", MAX_RESPONSE_LENGTH, chap_r,
 				&type) < 0) {
 		pr_err("Could not find CHAP_R.\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 	if (type != HEX) {
 		pr_err("Could not find CHAP_R.\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 
 	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
@@ -254,15 +254,14 @@ static int chap_server_compute_md5(
 
 	tfm = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(tfm)) {
-		tfm = NULL;
 		pr_err("Unable to allocate struct crypto_shash\n");
-		goto out;
+		goto free_challenge_binhex;
 	}
 
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
 	if (!desc) {
 		pr_err("Unable to allocate struct shash_desc\n");
-		goto out;
+		goto free_shash;
 	}
 
 	desc->tfm = tfm;
@@ -271,27 +270,27 @@ static int chap_server_compute_md5(
 	ret = crypto_shash_init(desc);
 	if (ret < 0) {
 		pr_err("crypto_shash_init() failed\n");
-		goto out;
+		goto free_desc;
 	}
 
 	ret = crypto_shash_update(desc, &chap->id, 1);
 	if (ret < 0) {
 		pr_err("crypto_shash_update() failed for id\n");
-		goto out;
+		goto free_desc;
 	}
 
 	ret = crypto_shash_update(desc, (char *)&auth->password,
 				  strlen(auth->password));
 	if (ret < 0) {
 		pr_err("crypto_shash_update() failed for password\n");
-		goto out;
+		goto free_desc;
 	}
 
 	ret = crypto_shash_finup(desc, chap->challenge,
 				 CHAP_CHALLENGE_LENGTH, server_digest);
 	if (ret < 0) {
 		pr_err("crypto_shash_finup() failed for challenge\n");
-		goto out;
+		goto free_desc;
 	}
 
 	chap_binaryhex_to_asciihex(response, server_digest, MD5_SIGNATURE_SIZE);
@@ -299,7 +298,7 @@ static int chap_server_compute_md5(
 
 	if (memcmp(server_digest, client_digest, MD5_SIGNATURE_SIZE) != 0) {
 		pr_debug("[server] MD5 Digests do not match!\n\n");
-		goto out;
+		goto free_desc;
 	} else
 		pr_debug("[server] MD5 Digests match, CHAP connection"
 				" successful.\n\n");
@@ -309,14 +308,14 @@ static int chap_server_compute_md5(
 	 */
 	if (!auth->authenticate_target) {
 		auth_ret = 0;
-		goto out;
+		goto free_desc;
 	}
 	/*
 	 * Get CHAP_I.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type) < 0) {
 		pr_err("Could not find CHAP_I.\n");
-		goto out;
+		goto free_desc;
 	}
 
 	if (type == HEX)
@@ -326,11 +325,11 @@ static int chap_server_compute_md5(
 
 	if (ret < 0) {
 		pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret);
-		goto out;
+		goto free_desc;
 	}
 	if (id > 255) {
 		pr_err("chap identifier: %lu greater than 255\n", id);
-		goto out;
+		goto free_desc;
 	}
 	/*
 	 * RFC 1994 says Identifier is no more than octet (8 bits).
@@ -342,23 +341,23 @@ static int chap_server_compute_md5(
 	if (extract_param(nr_in_ptr, "CHAP_C", CHAP_CHALLENGE_STR_LEN,
 			challenge, &type) < 0) {
 		pr_err("Could not find CHAP_C.\n");
-		goto out;
+		goto free_desc;
 	}
 
 	if (type != HEX) {
 		pr_err("Could not find CHAP_C.\n");
-		goto out;
+		goto free_desc;
 	}
 	pr_debug("[server] Got CHAP_C=%s\n", challenge);
 	challenge_len = chap_string_to_hex(challenge_binhex, challenge,
 				strlen(challenge));
 	if (!challenge_len) {
 		pr_err("Unable to convert incoming challenge\n");
-		goto out;
+		goto free_desc;
 	}
 	if (challenge_len > 1024) {
 		pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
-		goto out;
+		goto free_desc;
 	}
 	/*
 	 * During mutual authentication, the CHAP_C generated by the
@@ -368,7 +367,7 @@ static int chap_server_compute_md5(
 	if (!memcmp(challenge_binhex, chap->challenge, CHAP_CHALLENGE_LENGTH)) {
 		pr_err("initiator CHAP_C matches target CHAP_C, failing"
 		       " login attempt\n");
-		goto out;
+		goto free_desc;
 	}
 	/*
 	 * Generate CHAP_N and CHAP_R for mutual authentication.
@@ -376,7 +375,7 @@ static int chap_server_compute_md5(
 	ret = crypto_shash_init(desc);
 	if (ret < 0) {
 		pr_err("crypto_shash_init() failed\n");
-		goto out;
+		goto free_desc;
 	}
 
 	/* To handle both endiannesses */
@@ -384,7 +383,7 @@ static int chap_server_compute_md5(
 	ret = crypto_shash_update(desc, &id_as_uchar, 1);
 	if (ret < 0) {
 		pr_err("crypto_shash_update() failed for id\n");
-		goto out;
+		goto free_desc;
 	}
 
 	ret = crypto_shash_update(desc, auth->password_mutual,
@@ -392,7 +391,7 @@ static int chap_server_compute_md5(
 	if (ret < 0) {
 		pr_err("crypto_shash_update() failed for"
 				" password_mutual\n");
-		goto out;
+		goto free_desc;
 	}
 	/*
 	 * Convert received challenge to binary hex.
@@ -401,7 +400,7 @@ static int chap_server_compute_md5(
 				 digest);
 	if (ret < 0) {
 		pr_err("crypto_shash_finup() failed for ma challenge\n");
-		goto out;
+		goto free_desc;
 	}
 
 	/*
@@ -419,11 +418,15 @@ static int chap_server_compute_md5(
 	*nr_out_len += 1;
 	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
 	auth_ret = 0;
-out:
+free_desc:
 	kzfree(desc);
+free_shash:
 	crypto_free_shash(tfm);
-	kfree(challenge);
+free_challenge_binhex:
 	kfree(challenge_binhex);
+free_challenge:
+	kfree(challenge);
+exit:
 	return auth_ret;
 }
 
-- 
2.15.1

Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F18C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89626205ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfH2P7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30515 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2P7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:59:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C514111A3CA;
        Thu, 29 Aug 2019 15:59:37 +0000 (UTC)
Received: from manaslu.redhat.com (unknown [10.35.206.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AB1851961;
        Thu, 29 Aug 2019 15:59:34 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     cleech@redhat.com
Cc:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 1/4] target-iscsi: CHAP: add support to SHA1 and SHA3-256 hash functions
Date:   Thu, 29 Aug 2019 17:59:26 +0200
Message-Id: <20190829155929.27701-2-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
References: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Thu, 29 Aug 2019 15:59:37 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patches modifies the chap_server_compute_hash() function
to make it agnostic to the choice of hash algorithm that is used.
It also adds support to two new hash algorithms: SHA1 and SHA3-256

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 135 +++++++++++++++++------
 drivers/target/iscsi/iscsi_target_auth.h |   9 +-
 2 files changed, 108 insertions(+), 36 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 51ddca2033e0..3d1e94333835 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -46,9 +46,22 @@ static int chap_gen_challenge(
 	return 0;
 }
 
+static int chap_test_algorithm(const char *name)
+{
+	struct crypto_shash *tfm;
+
+	tfm = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(tfm))
+		return -1;
+
+	crypto_free_shash(tfm);
+	return 0;
+}
+
 static int chap_check_algorithm(const char *a_str)
 {
 	char *tmp, *orig, *token;
+	int r = CHAP_DIGEST_UNKNOWN;
 
 	tmp = kstrdup(a_str, GFP_KERNEL);
 	if (!tmp) {
@@ -72,13 +85,33 @@ static int chap_check_algorithm(const char *a_str)
 
 		if (!strncmp(token, "5", 1)) {
 			pr_debug("Selected MD5 Algorithm\n");
-			kfree(orig);
-			return CHAP_DIGEST_MD5;
+			if (chap_test_algorithm("md5") < 0) {
+				pr_err("failed to allocate md5 algo\n");
+				continue;
+			}
+			r = CHAP_DIGEST_MD5;
+			goto out;
+		} else if (!strncmp(token, "6", 1)) {
+			pr_debug("Selected SHA1 Algorithm\n");
+			if (chap_test_algorithm("sha1") < 0) {
+				pr_err("failed to allocate sha1 algo\n");
+				continue;
+			}
+			r = CHAP_DIGEST_SHA;
+			goto out;
+		} else if (!strncmp(token, "7", 1)) {
+			pr_debug("Selected SHA3-256 Algorithm\n");
+			if (chap_test_algorithm("sha3-256") < 0) {
+				pr_err("failed to allocate sha3-256 algo\n");
+				continue;
+			}
+			r = CHAP_DIGEST_SHA3_256;
+			goto out;
 		}
 	}
 out:
 	kfree(orig);
-	return CHAP_DIGEST_UNKNOWN;
+	return r;
 }
 
 static void chap_close(struct iscsi_conn *conn)
@@ -94,7 +127,7 @@ static struct iscsi_chap *chap_server_open(
 	char *aic_str,
 	unsigned int *aic_len)
 {
-	int ret;
+	int digest_type;
 	struct iscsi_chap *chap;
 
 	if (!(auth->naf_flags & NAF_USERID_SET) ||
@@ -109,17 +142,19 @@ static struct iscsi_chap *chap_server_open(
 		return NULL;
 
 	chap = conn->auth_protocol;
-	ret = chap_check_algorithm(a_str);
-	switch (ret) {
+	digest_type = chap_check_algorithm(a_str);
+	switch (digest_type) {
 	case CHAP_DIGEST_MD5:
-		pr_debug("[server] Got CHAP_A=5\n");
-		/*
-		 * Send back CHAP_A set to MD5.
-		*/
-		*aic_len = sprintf(aic_str, "CHAP_A=5");
-		*aic_len += 1;
-		chap->digest_type = CHAP_DIGEST_MD5;
-		pr_debug("[server] Sending CHAP_A=%d\n", chap->digest_type);
+		chap->digest_size = MD5_SIGNATURE_SIZE;
+		chap->digest_name = "md5";
+		break;
+	case CHAP_DIGEST_SHA:
+		chap->digest_size = SHA_SIGNATURE_SIZE;
+		chap->digest_name = "sha1";
+		break;
+	case CHAP_DIGEST_SHA3_256:
+		chap->digest_size = SHA3_256_SIGNATURE_SIZE;
+		chap->digest_name = "sha3-256";
 		break;
 	case CHAP_DIGEST_UNKNOWN:
 	default:
@@ -128,6 +163,11 @@ static struct iscsi_chap *chap_server_open(
 		return NULL;
 	}
 
+	pr_debug("[server] Got CHAP_A=%d\n", digest_type);
+	*aic_len = sprintf(aic_str, "CHAP_A=%d", digest_type);
+	*aic_len += 1;
+	pr_debug("[server] Sending CHAP_A=%d\n", digest_type);
+
 	/*
 	 * Set Identifier.
 	 */
@@ -146,7 +186,7 @@ static struct iscsi_chap *chap_server_open(
 	return chap;
 }
 
-static int chap_server_compute_md5(
+static int chap_server_compute_hash(
 	struct iscsi_conn *conn,
 	struct iscsi_node_auth *auth,
 	char *nr_in_ptr,
@@ -155,12 +195,13 @@ static int chap_server_compute_md5(
 {
 	unsigned long id;
 	unsigned char id_as_uchar;
-	unsigned char digest[MD5_SIGNATURE_SIZE];
-	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
+	unsigned char type;
 	unsigned char identifier[10], *challenge = NULL;
 	unsigned char *challenge_binhex = NULL;
-	unsigned char client_digest[MD5_SIGNATURE_SIZE];
-	unsigned char server_digest[MD5_SIGNATURE_SIZE];
+	unsigned char *digest = NULL;
+	unsigned char *response = NULL;
+	unsigned char *client_digest = NULL;
+	unsigned char *server_digest = NULL;
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
 	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
@@ -168,13 +209,33 @@ static int chap_server_compute_md5(
 	struct shash_desc *desc = NULL;
 	int auth_ret = -1, ret, challenge_len;
 
+	digest = kzalloc(chap->digest_size, GFP_KERNEL);
+	if (!digest) {
+		pr_err("Unable to allocate the digest buffer\n");
+		goto out;
+	}
+
+	response = kzalloc(chap->digest_size * 2 + 2, GFP_KERNEL);
+	if (!response) {
+		pr_err("Unable to allocate the response buffer\n");
+		goto out;
+	}
+
+	client_digest = kzalloc(chap->digest_size, GFP_KERNEL);
+	if (!client_digest) {
+		pr_err("Unable to allocate the client_digest buffer\n");
+		goto out;
+	}
+
+	server_digest = kzalloc(chap->digest_size, GFP_KERNEL);
+	if (!server_digest) {
+		pr_err("Unable to allocate the server_digest buffer\n");
+		goto out;
+	}
+
 	memset(identifier, 0, 10);
 	memset(chap_n, 0, MAX_CHAP_N_SIZE);
 	memset(chap_r, 0, MAX_RESPONSE_LENGTH);
-	memset(digest, 0, MD5_SIGNATURE_SIZE);
-	memset(response, 0, MD5_SIGNATURE_SIZE * 2 + 2);
-	memset(client_digest, 0, MD5_SIGNATURE_SIZE);
-	memset(server_digest, 0, MD5_SIGNATURE_SIZE);
 
 	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge) {
@@ -219,18 +280,18 @@ static int chap_server_compute_md5(
 		pr_err("Could not find CHAP_R.\n");
 		goto out;
 	}
-	if (strlen(chap_r) != MD5_SIGNATURE_SIZE * 2) {
+	if (strlen(chap_r) != chap->digest_size * 2) {
 		pr_err("Malformed CHAP_R\n");
 		goto out;
 	}
-	if (hex2bin(client_digest, chap_r, MD5_SIGNATURE_SIZE) < 0) {
+	if (hex2bin(client_digest, chap_r, chap->digest_size) < 0) {
 		pr_err("Malformed CHAP_R\n");
 		goto out;
 	}
 
 	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
 
-	tfm = crypto_alloc_shash("md5", 0, 0);
+	tfm = crypto_alloc_shash(chap->digest_name, 0, 0);
 	if (IS_ERR(tfm)) {
 		tfm = NULL;
 		pr_err("Unable to allocate struct crypto_shash\n");
@@ -271,15 +332,15 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	bin2hex(response, server_digest, MD5_SIGNATURE_SIZE);
-	pr_debug("[server] MD5 Server Digest: %s\n", response);
+	bin2hex(response, server_digest, chap->digest_size);
+	pr_debug("[server] %s Server Digest: %s\n", hash_name, response);
 
-	if (memcmp(server_digest, client_digest, MD5_SIGNATURE_SIZE) != 0) {
-		pr_debug("[server] MD5 Digests do not match!\n\n");
+	if (memcmp(server_digest, client_digest, chap->digest_size) != 0) {
+		pr_debug("[server] %s Digests do not match!\n\n", hash_name);
 		goto out;
 	} else
-		pr_debug("[server] MD5 Digests match, CHAP connection"
-				" successful.\n\n");
+		pr_debug("[server] %s Digests match, CHAP connection"
+				" successful.\n\n", hash_name);
 	/*
 	 * One way authentication has succeeded, return now if mutual
 	 * authentication is not enabled.
@@ -393,7 +454,7 @@ static int chap_server_compute_md5(
 	/*
 	 * Convert response from binary hex to ascii hext.
 	 */
-	bin2hex(response, digest, MD5_SIGNATURE_SIZE);
+	bin2hex(response, digest, chap->digest_size);
 	*nr_out_len += sprintf(nr_out_ptr + *nr_out_len, "CHAP_R=0x%s",
 			response);
 	*nr_out_len += 1;
@@ -405,6 +466,10 @@ static int chap_server_compute_md5(
 		crypto_free_shash(tfm);
 	kfree(challenge);
 	kfree(challenge_binhex);
+	kfree(digest);
+	kfree(response);
+	kfree(server_digest);
+	kfree(client_digest);
 	return auth_ret;
 }
 
@@ -419,7 +484,9 @@ static int chap_got_response(
 
 	switch (chap->digest_type) {
 	case CHAP_DIGEST_MD5:
-		if (chap_server_compute_md5(conn, auth, nr_in_ptr,
+	case CHAP_DIGEST_SHA:
+	case CHAP_DIGEST_SHA3_256:
+		if (chap_server_compute_hash(conn, auth, nr_in_ptr,
 				nr_out_ptr, nr_out_len) < 0)
 			return -1;
 		return 0;
diff --git a/drivers/target/iscsi/iscsi_target_auth.h b/drivers/target/iscsi/iscsi_target_auth.h
index d5600ac30b53..8b10f935675a 100644
--- a/drivers/target/iscsi/iscsi_target_auth.h
+++ b/drivers/target/iscsi/iscsi_target_auth.h
@@ -7,13 +7,16 @@
 #define CHAP_DIGEST_UNKNOWN	0
 #define CHAP_DIGEST_MD5		5
 #define CHAP_DIGEST_SHA		6
+#define CHAP_DIGEST_SHA3_256	7
 
 #define CHAP_CHALLENGE_LENGTH	16
 #define CHAP_CHALLENGE_STR_LEN	4096
-#define MAX_RESPONSE_LENGTH	64	/* sufficient for MD5 */
+#define MAX_RESPONSE_LENGTH	128	/* sufficient for SHA3 256 */
 #define	MAX_CHAP_N_SIZE		512
 
 #define MD5_SIGNATURE_SIZE	16	/* 16 bytes in a MD5 message digest */
+#define SHA_SIGNATURE_SIZE	20	/* 20 bytes in a SHA1 message digest */
+#define SHA3_256_SIGNATURE_SIZE	32	/* 32 bytes in a SHA3 256 message digest */
 
 #define CHAP_STAGE_CLIENT_A	1
 #define CHAP_STAGE_SERVER_AIC	2
@@ -28,9 +31,11 @@ extern u32 chap_main_loop(struct iscsi_conn *, struct iscsi_node_auth *, char *,
 				int *, int *);
 
 struct iscsi_chap {
-	unsigned char	digest_type;
 	unsigned char	id;
 	unsigned char	challenge[CHAP_CHALLENGE_LENGTH];
+	unsigned int	challenge_len;
+	unsigned char	*digest_name;
+	unsigned int	digest_size;
 	unsigned int	authenticate_target;
 	unsigned int	chap_state;
 } ____cacheline_aligned;
-- 
Maurizio Lombardi


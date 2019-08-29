Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69136C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C5F205ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfH2P7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33897 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2P7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:59:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D4F920ABB;
        Thu, 29 Aug 2019 15:59:46 +0000 (UTC)
Received: from manaslu.redhat.com (unknown [10.35.206.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 166825D772;
        Thu, 29 Aug 2019 15:59:40 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     cleech@redhat.com
Cc:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 3/4] target-iscsi: tie the challenge length to the hash digest size
Date:   Thu, 29 Aug 2019 17:59:28 +0200
Message-Id: <20190829155929.27701-4-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
References: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 29 Aug 2019 15:59:46 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 37 +++++++++++++++++-------
 drivers/target/iscsi/iscsi_target_auth.h |  4 +--
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 77dac8086927..976c8c73d261 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -25,16 +25,21 @@ static int chap_gen_challenge(
 	unsigned int *c_len)
 {
 	int ret;
-	unsigned char challenge_asciihex[CHAP_CHALLENGE_LENGTH * 2 + 1];
+	unsigned char *challenge_asciihex;
 	struct iscsi_chap *chap = conn->auth_protocol;
 
-	memset(challenge_asciihex, 0, CHAP_CHALLENGE_LENGTH * 2 + 1);
+	challenge_asciihex = kzalloc(chap->challenge_len * 2 + 1, GFP_KERNEL);
+	if (!challenge_asciihex)
+		return -ENOMEM;
 
-	ret = get_random_bytes_wait(chap->challenge, CHAP_CHALLENGE_LENGTH);
+	memset(chap->challenge, 0, MAX_CHAP_CHALLENGE_LEN);
+
+	ret = get_random_bytes_wait(chap->challenge, chap->challenge_len);
 	if (unlikely(ret))
-		return ret;
+		goto out;
+
 	bin2hex(challenge_asciihex, chap->challenge,
-				CHAP_CHALLENGE_LENGTH);
+				chap->challenge_len);
 	/*
 	 * Set CHAP_C, and copy the generated challenge into c_str.
 	 */
@@ -43,7 +48,10 @@ static int chap_gen_challenge(
 
 	pr_debug("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
 			challenge_asciihex);
-	return 0;
+
+out:
+	kfree(challenge_asciihex);
+	return ret;
 }
 
 static int chap_test_algorithm(const char *name)
@@ -163,6 +171,9 @@ static struct iscsi_chap *chap_server_open(
 		return NULL;
 	}
 
+	/* Tie the challenge length to the digest size */
+	chap->challenge_len = chap->digest_size;
+
 	pr_debug("[server] Got CHAP_A=%d\n", digest_type);
 	*aic_len = sprintf(aic_str, "CHAP_A=%d", digest_type);
 	*aic_len += 1;
@@ -326,21 +337,23 @@ static int chap_server_compute_hash(
 	}
 
 	ret = crypto_shash_finup(desc, chap->challenge,
-				 CHAP_CHALLENGE_LENGTH, server_digest);
+				 chap->challenge_len, server_digest);
 	if (ret < 0) {
 		pr_err("crypto_shash_finup() failed for challenge\n");
 		goto out;
 	}
 
 	bin2hex(response, server_digest, chap->digest_size);
-	pr_debug("[server] %s Server Digest: %s\n", hash_name, response);
+	pr_debug("[server] %s Server Digest: %s\n",
+		chap->digest_name, response);
 
 	if (memcmp(server_digest, client_digest, chap->digest_size) != 0) {
-		pr_debug("[server] %s Digests do not match!\n\n", hash_name);
+		pr_debug("[server] %s Digests do not match!\n\n",
+			chap->digest_name);
 		goto out;
 	} else
 		pr_debug("[server] %s Digests match, CHAP connection"
-				" successful.\n\n", hash_name);
+				" successful.\n\n", chap->digest_name);
 	/*
 	 * One way authentication has succeeded, return now if mutual
 	 * authentication is not enabled.
@@ -406,7 +419,9 @@ static int chap_server_compute_hash(
 	 * initiator must not match the original CHAP_C generated by
 	 * the target.
 	 */
-	if (!memcmp(challenge_binhex, chap->challenge, CHAP_CHALLENGE_LENGTH)) {
+	if (challenge_len == chap->challenge_len &&
+				!memcmp(challenge_binhex, chap->challenge,
+				challenge_len)) {
 		pr_err("initiator CHAP_C matches target CHAP_C, failing"
 		       " login attempt\n");
 		goto out;
diff --git a/drivers/target/iscsi/iscsi_target_auth.h b/drivers/target/iscsi/iscsi_target_auth.h
index 8b10f935675a..e22840fea903 100644
--- a/drivers/target/iscsi/iscsi_target_auth.h
+++ b/drivers/target/iscsi/iscsi_target_auth.h
@@ -9,7 +9,7 @@
 #define CHAP_DIGEST_SHA		6
 #define CHAP_DIGEST_SHA3_256	7
 
-#define CHAP_CHALLENGE_LENGTH	16
+#define MAX_CHAP_CHALLENGE_LEN	32
 #define CHAP_CHALLENGE_STR_LEN	4096
 #define MAX_RESPONSE_LENGTH	128	/* sufficient for SHA3 256 */
 #define	MAX_CHAP_N_SIZE		512
@@ -32,7 +32,7 @@ extern u32 chap_main_loop(struct iscsi_conn *, struct iscsi_node_auth *, char *,
 
 struct iscsi_chap {
 	unsigned char	id;
-	unsigned char	challenge[CHAP_CHALLENGE_LENGTH];
+	unsigned char	challenge[MAX_CHAP_CHALLENGE_LEN];
 	unsigned int	challenge_len;
 	unsigned char	*digest_name;
 	unsigned int	digest_size;
-- 
Maurizio Lombardi


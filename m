Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F50C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 313B120578
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfH2P7t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfH2P7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:59:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E467210F23E2;
        Thu, 29 Aug 2019 15:59:48 +0000 (UTC)
Received: from manaslu.redhat.com (unknown [10.35.206.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFB715D721;
        Thu, 29 Aug 2019 15:59:46 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     cleech@redhat.com
Cc:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 4/4] target-iscsi: rename some variables to avoid confusion.
Date:   Thu, 29 Aug 2019 17:59:29 +0200
Message-Id: <20190829155929.27701-5-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
References: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Thu, 29 Aug 2019 15:59:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch renames some variables in chap_server_compute_hash()
to make it harder to confuse the initiator's challenge with
the target's challenge when the mutual chap authentication is used.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 40 ++++++++++++------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 976c8c73d261..7ccef7b1c60b 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -207,8 +207,8 @@ static int chap_server_compute_hash(
 	unsigned long id;
 	unsigned char id_as_uchar;
 	unsigned char type;
-	unsigned char identifier[10], *challenge = NULL;
-	unsigned char *challenge_binhex = NULL;
+	unsigned char identifier[10], *initiatorchg = NULL;
+	unsigned char *initiatorchg_binhex = NULL;
 	unsigned char *digest = NULL;
 	unsigned char *response = NULL;
 	unsigned char *client_digest = NULL;
@@ -218,7 +218,7 @@ static int chap_server_compute_hash(
 	struct iscsi_chap *chap = conn->auth_protocol;
 	struct crypto_shash *tfm = NULL;
 	struct shash_desc *desc = NULL;
-	int auth_ret = -1, ret, challenge_len;
+	int auth_ret = -1, ret, initiatorchg_len;
 
 	digest = kzalloc(chap->digest_size, GFP_KERNEL);
 	if (!digest) {
@@ -248,15 +248,15 @@ static int chap_server_compute_hash(
 	memset(chap_n, 0, MAX_CHAP_N_SIZE);
 	memset(chap_r, 0, MAX_RESPONSE_LENGTH);
 
-	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
-	if (!challenge) {
+	initiatorchg = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
+	if (!initiatorchg) {
 		pr_err("Unable to allocate challenge buffer\n");
 		goto out;
 	}
 
-	challenge_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
-	if (!challenge_binhex) {
-		pr_err("Unable to allocate challenge_binhex buffer\n");
+	initiatorchg_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
+	if (!initiatorchg_binhex) {
+		pr_err("Unable to allocate initiatorchg_binhex buffer\n");
 		goto out;
 	}
 	/*
@@ -391,7 +391,7 @@ static int chap_server_compute_hash(
 	 * Get CHAP_C.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_C", CHAP_CHALLENGE_STR_LEN,
-			challenge, &type) < 0) {
+			initiatorchg, &type) < 0) {
 		pr_err("Could not find CHAP_C.\n");
 		goto out;
 	}
@@ -400,28 +400,28 @@ static int chap_server_compute_hash(
 		pr_err("Could not find CHAP_C.\n");
 		goto out;
 	}
-	challenge_len = DIV_ROUND_UP(strlen(challenge), 2);
-	if (!challenge_len) {
+	initiatorchg_len = DIV_ROUND_UP(strlen(initiatorchg), 2);
+	if (!initiatorchg_len) {
 		pr_err("Unable to convert incoming challenge\n");
 		goto out;
 	}
-	if (challenge_len > 1024) {
+	if (initiatorchg_len > 1024) {
 		pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
 		goto out;
 	}
-	if (hex2bin(challenge_binhex, challenge, challenge_len) < 0) {
+	if (hex2bin(initiatorchg_binhex, initiatorchg, initiatorchg_len) < 0) {
 		pr_err("Malformed CHAP_C\n");
 		goto out;
 	}
-	pr_debug("[server] Got CHAP_C=%s\n", challenge);
+	pr_debug("[server] Got CHAP_C=%s\n", initiatorchg);
 	/*
 	 * During mutual authentication, the CHAP_C generated by the
 	 * initiator must not match the original CHAP_C generated by
 	 * the target.
 	 */
-	if (challenge_len == chap->challenge_len &&
-				!memcmp(challenge_binhex, chap->challenge,
-				challenge_len)) {
+	if (initiatorchg_len == chap->challenge_len &&
+				!memcmp(initiatorchg_binhex, chap->challenge,
+				initiatorchg_len)) {
 		pr_err("initiator CHAP_C matches target CHAP_C, failing"
 		       " login attempt\n");
 		goto out;
@@ -453,7 +453,7 @@ static int chap_server_compute_hash(
 	/*
 	 * Convert received challenge to binary hex.
 	 */
-	ret = crypto_shash_finup(desc, challenge_binhex, challenge_len,
+	ret = crypto_shash_finup(desc, initiatorchg_binhex, initiatorchg_len,
 				 digest);
 	if (ret < 0) {
 		pr_err("crypto_shash_finup() failed for ma challenge\n");
@@ -479,8 +479,8 @@ static int chap_server_compute_hash(
 	kzfree(desc);
 	if (tfm)
 		crypto_free_shash(tfm);
-	kfree(challenge);
-	kfree(challenge_binhex);
+	kfree(initiatorchg);
+	kfree(initiatorchg_binhex);
 	kfree(digest);
 	kfree(response);
 	kfree(server_digest);
-- 
Maurizio Lombardi


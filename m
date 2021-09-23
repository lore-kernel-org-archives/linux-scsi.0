Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E12CC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1453661038
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbhIWS6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhIWS6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 14:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C71610C8;
        Thu, 23 Sep 2021 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632423410;
        bh=JtAKSE6+7kMHHinuBvmO5cbXmVnXoymoU+wAOyUXE+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGlklspJTYrbnfj/qDRLBCvAZp5W98mUwbNlyv+BaxVAOjWtic49naHj1ofdMZVQ9
         Vqg5AYzmfPTz9uUy8wktP7MhMJo6hKpFhlbb7mQDNnndt6NlfIIW1A0g1JRAB1tblh
         K6FubKtlM8fzHw3sQ6KRtfACakQvv66eeichvn4HwIJhieMrTu7v0+xczcYD93grxX
         lTcn3X5sWlqsTrpH14NK1iTPQtu7p99c89/LlIktbX6CDr708EWMPdyg2nN02Zdzhm
         tSRL0kA7KDvFVbBX2eeOhMfXOZ+3ikfPSXOuLB0fVmYM80ittcTjNK+ShkRgyEomxJ
         r2uwhUM/gNE4w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v3 1/4] blk-crypto-fallback: properly prefix function and struct names
Date:   Thu, 23 Sep 2021 11:56:26 -0700
Message-Id: <20210923185629.54823-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923185629.54823-1-ebiggers@kernel.org>
References: <20210923185629.54823-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For clarity, avoid using just the "blk_crypto_" prefix for functions and
structs that are specific to blk-crypto-fallback.  Instead, use
"blk_crypto_fallback_".  Some places already did this, but others
didn't.

This is also a prerequisite for using "struct blk_crypto_keyslot" to
mean a generic blk-crypto keyslot (which is what it sounds like).
Rename the fallback one to "struct blk_crypto_fallback_keyslot".

No change in behavior.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-fallback.c | 59 +++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index c322176a1e099..82b302597b474 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -72,7 +72,7 @@ static mempool_t *bio_fallback_crypt_ctx_pool;
 static DEFINE_MUTEX(tfms_init_lock);
 static bool tfms_inited[BLK_ENCRYPTION_MODE_MAX];
 
-static struct blk_crypto_keyslot {
+static struct blk_crypto_fallback_keyslot {
 	enum blk_crypto_mode_num crypto_mode;
 	struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
 } *blk_crypto_keyslots;
@@ -88,9 +88,9 @@ static struct bio_set crypto_bio_split;
  */
 static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
 
-static void blk_crypto_evict_keyslot(unsigned int slot)
+static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 {
-	struct blk_crypto_keyslot *slotp = &blk_crypto_keyslots[slot];
+	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
 	enum blk_crypto_mode_num crypto_mode = slotp->crypto_mode;
 	int err;
 
@@ -103,34 +103,34 @@ static void blk_crypto_evict_keyslot(unsigned int slot)
 	slotp->crypto_mode = BLK_ENCRYPTION_MODE_INVALID;
 }
 
-static int blk_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
-				      const struct blk_crypto_key *key,
-				      unsigned int slot)
+static int blk_crypto_fallback_keyslot_program(struct blk_keyslot_manager *ksm,
+					       const struct blk_crypto_key *key,
+					       unsigned int slot)
 {
-	struct blk_crypto_keyslot *slotp = &blk_crypto_keyslots[slot];
+	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
 	const enum blk_crypto_mode_num crypto_mode =
 						key->crypto_cfg.crypto_mode;
 	int err;
 
 	if (crypto_mode != slotp->crypto_mode &&
 	    slotp->crypto_mode != BLK_ENCRYPTION_MODE_INVALID)
-		blk_crypto_evict_keyslot(slot);
+		blk_crypto_fallback_evict_keyslot(slot);
 
 	slotp->crypto_mode = crypto_mode;
 	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], key->raw,
 				     key->size);
 	if (err) {
-		blk_crypto_evict_keyslot(slot);
+		blk_crypto_fallback_evict_keyslot(slot);
 		return err;
 	}
 	return 0;
 }
 
-static int blk_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
-				    const struct blk_crypto_key *key,
-				    unsigned int slot)
+static int blk_crypto_fallback_keyslot_evict(struct blk_keyslot_manager *ksm,
+					     const struct blk_crypto_key *key,
+					     unsigned int slot)
 {
-	blk_crypto_evict_keyslot(slot);
+	blk_crypto_fallback_evict_keyslot(slot);
 	return 0;
 }
 
@@ -140,8 +140,8 @@ static int blk_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
  * hardware.
  */
 static const struct blk_ksm_ll_ops blk_crypto_ksm_ll_ops = {
-	.keyslot_program	= blk_crypto_keyslot_program,
-	.keyslot_evict		= blk_crypto_keyslot_evict,
+	.keyslot_program	= blk_crypto_fallback_keyslot_program,
+	.keyslot_evict		= blk_crypto_fallback_keyslot_evict,
 };
 
 static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
@@ -159,7 +159,7 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 	bio_endio(src_bio);
 }
 
-static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
+static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -186,12 +186,13 @@ static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
 	return bio;
 }
 
-static bool blk_crypto_alloc_cipher_req(struct blk_ksm_keyslot *slot,
-					struct skcipher_request **ciph_req_ret,
-					struct crypto_wait *wait)
+static bool
+blk_crypto_fallback_alloc_cipher_req(struct blk_ksm_keyslot *slot,
+				     struct skcipher_request **ciph_req_ret,
+				     struct crypto_wait *wait)
 {
 	struct skcipher_request *ciph_req;
-	const struct blk_crypto_keyslot *slotp;
+	const struct blk_crypto_fallback_keyslot *slotp;
 	int keyslot_idx = blk_ksm_get_slot_idx(slot);
 
 	slotp = &blk_crypto_keyslots[keyslot_idx];
@@ -209,7 +210,7 @@ static bool blk_crypto_alloc_cipher_req(struct blk_ksm_keyslot *slot,
 	return true;
 }
 
-static bool blk_crypto_split_bio_if_needed(struct bio **bio_ptr)
+static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	unsigned int i = 0;
@@ -276,7 +277,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	blk_status_t blk_st;
 
 	/* Split the bio if it's too big for single page bvec */
-	if (!blk_crypto_split_bio_if_needed(bio_ptr))
+	if (!blk_crypto_fallback_split_bio_if_needed(bio_ptr))
 		return false;
 
 	src_bio = *bio_ptr;
@@ -284,7 +285,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 
 	/* Allocate bounce bio for encryption */
-	enc_bio = blk_crypto_clone_bio(src_bio);
+	enc_bio = blk_crypto_fallback_clone_bio(src_bio);
 	if (!enc_bio) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
 		return false;
@@ -301,7 +302,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	}
 
 	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_alloc_cipher_req(slot, &ciph_req, &wait)) {
+	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
 		goto out_release_keyslot;
 	}
@@ -403,7 +404,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	}
 
 	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_alloc_cipher_req(slot, &ciph_req, &wait)) {
+	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
 		bio->bi_status = BLK_STS_RESOURCE;
 		goto out;
 	}
@@ -473,9 +474,9 @@ static void blk_crypto_fallback_decrypt_endio(struct bio *bio)
  * @bio_ptr: pointer to the bio to prepare
  *
  * If bio is doing a WRITE operation, this splits the bio into two parts if it's
- * too big (see blk_crypto_split_bio_if_needed). It then allocates a bounce bio
- * for the first part, encrypts it, and update bio_ptr to point to the bounce
- * bio.
+ * too big (see blk_crypto_fallback_split_bio_if_needed()). It then allocates a
+ * bounce bio for the first part, encrypts it, and updates bio_ptr to point to
+ * the bounce bio.
  *
  * For a READ operation, we mark the bio for decryption by using bi_private and
  * bi_end_io.
@@ -610,7 +611,7 @@ static int blk_crypto_fallback_init(void)
 int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 {
 	const char *cipher_str = blk_crypto_modes[mode_num].cipher_str;
-	struct blk_crypto_keyslot *slotp;
+	struct blk_crypto_fallback_keyslot *slotp;
 	unsigned int i;
 	int err = 0;
 
-- 
2.33.0


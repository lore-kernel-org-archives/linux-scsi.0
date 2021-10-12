Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F06C10F04
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DF7E6101D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhJLVrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhJLVr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 17:47:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E637C60F92;
        Tue, 12 Oct 2021 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634075126;
        bh=FYxkvr97reyUgCiAuZ/n5hz9iSw0w4FejXoFWwtNskc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZf4NFgclzgVDCK22KSltCS4YPEXORIQoFJmLj5rs/i4vfuklfbJlhGz7FrC34l/P
         OsdEaZmETln8s3MvyRFtlyBcH/vun8ODuU3uJ6D1hLUTtqo4Fs/4wmEasHrggLAccV
         F6JaE0xBrItzJp1S4mIa43kz6z6MXH/bYE2E9QwYcAKii5WasnJdFxoNcChXwBa7r/
         uZKSH9ksckwoxweUWGoqP8AuD4nLp8tyiJ5ZkIfyPsZG7eWP7xdz4pctff+wX1HImw
         B75Ba96F1Dcs7opb2pMeXqthNyqFg122AjgfWXDbCTTwx1mj73KPBSA3fDoYYRT4HG
         T+8zjDQfJPRCA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 1/4] blk-crypto-fallback: properly prefix function and struct names
Date:   Tue, 12 Oct 2021 14:43:27 -0700
Message-Id: <20211012214330.40470-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211012214330.40470-1-ebiggers@kernel.org>
References: <20211012214330.40470-1-ebiggers@kernel.org>
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
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-fallback.c | 59 +++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index ec4c7823541c8..1bcc1a1514248 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -73,7 +73,7 @@ static mempool_t *bio_fallback_crypt_ctx_pool;
 static DEFINE_MUTEX(tfms_init_lock);
 static bool tfms_inited[BLK_ENCRYPTION_MODE_MAX];
 
-static struct blk_crypto_keyslot {
+static struct blk_crypto_fallback_keyslot {
 	enum blk_crypto_mode_num crypto_mode;
 	struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
 } *blk_crypto_keyslots;
@@ -89,9 +89,9 @@ static struct bio_set crypto_bio_split;
  */
 static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
 
-static void blk_crypto_evict_keyslot(unsigned int slot)
+static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 {
-	struct blk_crypto_keyslot *slotp = &blk_crypto_keyslots[slot];
+	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
 	enum blk_crypto_mode_num crypto_mode = slotp->crypto_mode;
 	int err;
 
@@ -104,34 +104,34 @@ static void blk_crypto_evict_keyslot(unsigned int slot)
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
 
@@ -141,8 +141,8 @@ static int blk_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
  * hardware.
  */
 static const struct blk_ksm_ll_ops blk_crypto_ksm_ll_ops = {
-	.keyslot_program	= blk_crypto_keyslot_program,
-	.keyslot_evict		= blk_crypto_keyslot_evict,
+	.keyslot_program	= blk_crypto_fallback_keyslot_program,
+	.keyslot_evict		= blk_crypto_fallback_keyslot_evict,
 };
 
 static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
@@ -160,7 +160,7 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 	bio_endio(src_bio);
 }
 
-static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
+static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -187,12 +187,13 @@ static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
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
@@ -210,7 +211,7 @@ static bool blk_crypto_alloc_cipher_req(struct blk_ksm_keyslot *slot,
 	return true;
 }
 
-static bool blk_crypto_split_bio_if_needed(struct bio **bio_ptr)
+static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	unsigned int i = 0;
@@ -277,7 +278,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	blk_status_t blk_st;
 
 	/* Split the bio if it's too big for single page bvec */
-	if (!blk_crypto_split_bio_if_needed(bio_ptr))
+	if (!blk_crypto_fallback_split_bio_if_needed(bio_ptr))
 		return false;
 
 	src_bio = *bio_ptr;
@@ -285,7 +286,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 
 	/* Allocate bounce bio for encryption */
-	enc_bio = blk_crypto_clone_bio(src_bio);
+	enc_bio = blk_crypto_fallback_clone_bio(src_bio);
 	if (!enc_bio) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
 		return false;
@@ -302,7 +303,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	}
 
 	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_alloc_cipher_req(slot, &ciph_req, &wait)) {
+	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
 		goto out_release_keyslot;
 	}
@@ -404,7 +405,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	}
 
 	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_alloc_cipher_req(slot, &ciph_req, &wait)) {
+	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
 		bio->bi_status = BLK_STS_RESOURCE;
 		goto out;
 	}
@@ -474,9 +475,9 @@ static void blk_crypto_fallback_decrypt_endio(struct bio *bio)
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
@@ -611,7 +612,7 @@ static int blk_crypto_fallback_init(void)
 int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 {
 	const char *cipher_str = blk_crypto_modes[mode_num].cipher_str;
-	struct blk_crypto_keyslot *slotp;
+	struct blk_crypto_fallback_keyslot *slotp;
 	unsigned int i;
 	int err = 0;
 
-- 
2.33.0


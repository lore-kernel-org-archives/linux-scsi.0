Received: from mail-pl1-f231.google.com (mail-pl1-f231.google.com [209.85.214.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7C8379EFC
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 05:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538970; cv=none; b=eltTCKYkqEhU+bQSMNTAuhSwcTt4XDmnD/gptTleUTPOSl99jg7L5nq6nsqaAXLcvbk8F7Z3xKZcmX1u9ar4AxG2+s1dRvzw4KhGFntN4LvdTBoYzd9nyyAkXL/KoOOlfR/e0iLr+rwJWwjVsoRNH8gIIj8Zi77NW50wQnrOz0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538970; c=relaxed/simple;
	bh=ptYPEAcabOb1qGUWNpAdVjwbbM/+AqTacpnF9OjHyL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4wB9jCUrdjbZSiTs6ysaKLJBfbMCBMP5Wp6s9xcDfst3JuRFz1q0rGBfepue7W5f2s+ufQD9jAldwZnO6x9GoKSxNAMv7GFl3z+A3NrNKe0n8WVz9XtQ1/uUhnsmQuRGFQymEb7ZAeo+6yAMe1wQ8OwoWPxang+cv4qTOBvgKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BnQsM+BL; arc=none smtp.client-ip=209.85.214.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BnQsM+BL"
Received: by mail-pl1-f231.google.com with SMTP id d9443c01a7336-2c988e16bb3so1552335ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538968; x=1783143768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N3Kd40H6AivwA7mMDVuUj/O3ZPQ2Ju439VOfkOedNRs=;
        b=BnQsM+BLRuzgHCcOEp9IYAiqY9eahGWO7F8e/R2vZGdA2b8FBGsRYfFPq6x4t7RHhz
         MMX+Nb1fejeLCWsuEiG+M8AyP8SM6LJbFstOKC3xZbzMW5jYov6yeSOeHVOwZTBqFct+
         SCWjhcaLEEdqv5BG6MsiTo621YQ+6my14qwo7tr0+9FWytNyoOEuHkKOLXNTIgJSeE1S
         DuLqft4MZ/EWqBgQLWUZI/Q6KBTcP9WCoQZMl6K0ygJ1/acHo0850XtebaN00pEoFMrF
         DLo0rhKN/xxX9WbKzTP29IWKOAa99iVIh2RFnCEmd6jCMUyBCQQVWxG0YQqoVssciDWA
         Zp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538968; x=1783143768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N3Kd40H6AivwA7mMDVuUj/O3ZPQ2Ju439VOfkOedNRs=;
        b=gZezrVvMSp+jIdpCKDsfP+6SkJkgpBiiQdIK2UvXp7JIRgcdtGbyvha9pPPYX+Ldh2
         r7FvFkqZVRqebr1gGG77/VGAcPa7p1b5HFT+FEfrAOxnibyS+6LiEMoxJ60Z3yBMO6Su
         45Ur/HyZ8U6v90zICmXsUMH0yenLUZqmNdqZAOdtcID+qdzJn/SMfui6ptiUB6k5B/q6
         ZrijamEt+loeETWbw5QDDlJdQ8zRMhQt/l6RId+Ota/R+1DqACk4Qx8xsNWCCHpPuOAM
         b5HP36t9JMKcvhFA/lxNF0LnwSvhnS33iH4abqiFqbuTR51WwPELswFRWQDrdys99e9g
         POOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqxWYwLj+2bq+hvqqe/XnN2ph2h9RsTJL3RqOX1YtupbwQF+fauWVzbH0Mfj+1gt24VwEg3kTmWy433@vger.kernel.org
X-Gm-Message-State: AOJu0YwfD9IgMYwHZdEBnYEDWyOqzFcjJmU57lM/u4XhjQH9BkIIcYMX
	FU/B33A1cpoaFkv+lksaAr56g8/e1/Qp7GZ/ezLiMRJ/syF8RKNLd0XaMx5UvRKiBKl30DdEeLB
	iE756/Z2Ls66BeRRTj23oWJK2fxlnXvHaxynaqZ9PGrx2HSXp9hNU
X-Gm-Gg: AfdE7cnLnp/gv91vXedd4gC4X3sbIx+wgI4H0DaplirmKVF3hM5j6REMnCDL7yxvx36
	NoRgG+ncYwfR5PWTB24iN0kfPYSyfC5PCfyuUm0J6IpfdU6U28luXGcBoofohXMK8R3eBxcf08N
	K2kGiiVZGEV8LF9yOLMG1iXw/NXUmzuN/Zx1gwX5RDMayoqRj2pmKYYZeDvsQ8vUjVpc2GcxZ7C
	iDpmj5HiCDEehVoo9yJcLxms6jvbMMH2palWNSCuuqE2dY1GsZmnowctF14ArDT4fMODvt67DmQ
	cTuRhQkqd0bqbgGnOBWuMby98SBQNVus4PB5w/LUnxuipPjjCMD7Swl7zWzeVY2v9lcOvohi0nz
	2vE0pxeHBiXFepMrp/OVJ/I/3PML7
X-Received: by 2002:a17:90b:224d:b0:368:e6dc:eee2 with SMTP id 98e67ed59e1d1-37dfa1c9f92mr5376226a91.3.1782538967787;
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([2620:125:9017:12:36:3:6:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-37fb5672f6asm134113a91.0.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.12.104])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id 26AE0402B6;
	Fri, 26 Jun 2026 23:42:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 24285E40712; Fri, 26 Jun 2026 23:42:47 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 5/5] blk-integrity: avoid sector_t in bip_{get,set}_seed()
Date: Fri, 26 Jun 2026 23:42:20 -0600
Message-ID: <20260627054220.2174166-6-csander@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260627054220.2174166-1-csander@purestorage.com>
References: <20260627054220.2174166-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bip_set_seed() and bip_get_seed() take/return a sector_t value that's
actually an integrity interval number. This is confusing, so pass
struct bio instead to bip_set_seed() and convert the bio's device
address to integrity intervals.

Open-code the access to bip->bip_iter.bi_sector in the one caller of
bip_set_seed() that doesn't use the bio device address for the seed.
Open-code bip_get_seed() in its one caller.

Add a comment to struct bvec_iter's bi_sector field explaining its
alternate use for bip_iter.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 block/bio-integrity.c               |  5 ++---
 block/t10-pi.c                      |  2 +-
 drivers/nvme/target/io-cmd-bdev.c   |  3 +--
 drivers/target/target_core_iblock.c |  3 +--
 include/linux/bio-integrity.h       | 11 -----------
 include/linux/blk-integrity.h       | 13 +++++++++++++
 include/linux/bvec.h                |  1 +
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index d20f9002c7c9..7e5fb9b44848 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -102,13 +102,12 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 
 void bio_integrity_setup_default(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	u64 seed = bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR_SHIFT);
 
-	bip_set_seed(bip, seed);
+	bip_set_seed(bio);
 
 	if (bi->csum_type) {
 		bip->bip_flags |= BIP_CHECK_GUARD;
 		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 			bip->bip_flags |= BIP_IP_CHECKSUM;
@@ -488,11 +487,11 @@ int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
 
 	it.count = integrity_bytes;
 	ret = bio_integrity_map_user(bio, &it);
 	if (!ret) {
 		bio_uio_meta_to_bip(bio, meta);
-		bip_set_seed(bio_integrity(bio), meta->seed);
+		bio_integrity(bio)->bip_iter.bi_sector = meta->seed;
 		iov_iter_advance(&meta->iter, integrity_bytes);
 		meta->seed += bio_integrity_intervals(bi, bio_sectors(bio));
 	}
 	return ret;
 }
diff --git a/block/t10-pi.c b/block/t10-pi.c
index 787950dec50a..71367fd082bd 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -510,11 +510,11 @@ static void blk_reftag_remap_prepare(struct blk_integrity *bi,
 static void __blk_reftag_remap(struct bio *bio, struct blk_integrity *bi,
 			       unsigned *intervals, u64 *ref, bool prep)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bvec_iter iter = bip->bip_iter;
-	u64 virt = bip_get_seed(bip);
+	u64 virt = bip->bip_iter.bi_sector;
 	union pi_tuple *ptuple;
 	union pi_tuple tuple;
 
 	if (prep && bip->bip_flags & BIP_MAPPED_INTEGRITY) {
 		*ref += bio->bi_iter.bi_size >> bi->interval_exp;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2d9e8901df4..65fce51b024a 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -218,12 +218,11 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-		     (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bio);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
 	while (resid > 0 && sg_miter_next(miter)) {
 		len = min_t(size_t, miter->length, resid);
 		rc = bio_integrity_add_page(bio, miter->page, len,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1087d1d17c36..1aeb5be529a8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -706,12 +706,11 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-				  (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bio);
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index c3dda32fd803..992cb1622c2c 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -56,21 +56,10 @@ static inline bool bio_integrity_flagged(struct bio *bio, enum bip_flags flag)
 		return bip->bip_flags & flag;
 
 	return false;
 }
 
-static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
-{
-	return bip->bip_iter.bi_sector;
-}
-
-static inline void bip_set_seed(struct bio_integrity_payload *bip,
-				sector_t seed)
-{
-	bip->bip_iter.bi_sector = seed;
-}
-
 void bio_integrity_init(struct bio *bio, struct bio_integrity_payload *bip,
 		struct bio_vec *bvecs, unsigned int nr_vecs);
 struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 825d777c078b..c82b2f6fe194 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -85,10 +85,23 @@ static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 					       unsigned int sectors)
 {
 	return bio_integrity_intervals(bi, sectors) * bi->metadata_size;
 }
 
+/**
+ * bip_set_seed - Set bip reference tag seed from bio device address
+ * @bio:	struct bio whose integrity payload's ref tag seed to initialize
+ */
+static inline void bip_set_seed(struct bio *bio)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	bip->bip_iter.bi_sector =
+		bio_integrity_intervals(bi, bio->bi_iter.bi_sector);
+}
+
 static inline bool blk_integrity_rq(const struct request *rq)
 {
 	return rq->cmd_flags & REQ_INTEGRITY;
 }
 
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 92837e2743f1..22bded380bbf 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -91,10 +91,11 @@ static inline struct folio *bvec_folio(const struct bio_vec *bv)
 
 struct bvec_iter {
 	/*
 	 * Current device address in 512 byte sectors. Only updated by the bio
 	 * iter wrappers and not the bvec iterator helpers themselves.
+	 * For bip_iter, this is overloaded to represent the integrity interval.
 	 */
 	sector_t		bi_sector;
 
 	/*
 	 * Remaining size in bytes.
-- 
2.54.0


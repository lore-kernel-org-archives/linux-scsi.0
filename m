Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7693617C211
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298970; cv=none; b=W1AGMSq1ZFwfTtGuGF0F7PyVax5dXrD34sI8memq6pwTvTPImr1w97P8rb1mQv43bxHTk+8UFOjLDoXZiNBvnGDnQlOhQlPk68z3KKMAtqhLVwtLZS6Utypv3WH4uYIcrmE3RQS60Y8Bg5FbsVOLpfzJMVn+IO8fi48DTGeDpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298970; c=relaxed/simple;
	bh=O636dE9N69mBMEYSKXLOipICMqqDxgahqZWWn++RCU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhtLiHgfxvR14KWnaXbNEyg3G8GY6JnXsmNXNIYHSaiIljLoc38rh5Zg+K5kuQfRHRSGJelka/1WhJjG0UAfwlZ9zd+/6twb8J3fpHqI07ApNbM0JmfHAkrBJL6uJ5MZZxIgpBAZ+CzTvAIIaC1E5k0c4cx0yz8C5L/MyBcOc0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JRtyR4Bj; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JRtyR4Bj"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-35e4617924eso811829a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298967; x=1776903767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbLFjrQgSq+vo/irY8puWuag67WZ2r6Vk4eT1HQFu+k=;
        b=JRtyR4BjFln/4yy/caVkMKlZ0LRW4mraIQPe8LqPfvGDvryRe0Ii7QS1DVEUyU8suV
         7PRyTpOk116LtbOkM+dYF+6nYa5wUoZVwI5SOpqBRB+iW2+VhD2l8A7QfOmV89ngCB6K
         lyWpbGevt+ic15OAp2sBW/q4h2dOwszgawgOYhhBN4b2kNgzWeSmWX9LsYJyJFESA6He
         QywuI6FX+2VhfpkJhedxi5I5JfzBokz25f/5fFrR9DyPbC+rrdQIgYtXP31jx40CNACD
         lb/ckAnDkdagTfQBdJCNKt/xhIJp5FzXKO/hDePlfsqEOdw5lq+avE3LVOqreCkM5Lgy
         QE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298967; x=1776903767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UbLFjrQgSq+vo/irY8puWuag67WZ2r6Vk4eT1HQFu+k=;
        b=nJNcRaE0N52VMBmWv1Qcxni5QzaAPiIoHIqwF8LzXRE9C1s0TTaw//1CZ33q3BrFST
         5mMnolRJ4z9Ex9ZO27L0zHnrlcWV2kMuiRmSmhef5YnETuiB+NHXlNYdL73fSCZ4kUXv
         pB1baJkKaz7ZiSSzqlXODygO8XUGT3CNClAYsbpAC5CsbSWrJ2ZFsaqIRCxsUq4h6CRm
         Es85DwlMxMCgKJZAnTK3bceST4tgMbwnBUvdWSoD6kOJaW7VZmC060sbz07HAINE08BN
         Zl3W9jCwg8CUEGaLEhmlcYxaH8Ux5UKfVKfNLey/woZa/DoyUwcHYrK0mP3v/TZZx/E5
         hpaA==
X-Forwarded-Encrypted: i=1; AFNElJ9yTde8hHyCu3wyi/A348YKjwhntdThE3m+V2bqIGVyYL00xdBctFhtfx6vdnUK+ft2jlko5cHn4rN1@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9pW2GO6dnd45n2/qia3hSc+Q1CMYnbVkqAjzFJIFtNHB2b/IW
	2H378kvC+nR6YLYYjrhqHaM+HbbYNwZMbSiFi60i2U6vaQr/BmQ//EFHuG3QlHxjyYZ0AbcEkgC
	DxkqfYu73oSF3U9XW1Oi7WelrmNK0zVAFSo/PxWUOX/7g8QS07/p9
X-Gm-Gg: AeBDiesSQL/WY8W066BM/ohLw84tqb8E7s6CkiAZwpglACcPyyUYzYuvh+J2q5HP0om
	cz2Z2IVKly+9Z6zh9iYzXjEBQUzlcNuvF2oCT1HxqV8sjsCsop/OF4TCu6tOfcSs5Hvx/TlGC14
	hx1gFuueFPjlIj8l8G9nqf2yTO/3aAvX+cUkvF9MNM0AIV1W++obQqCfL41urws4m8t09vpcd1k
	r2IVFBPVd2d0LdPHLmUV49eAVuP1awqdZ6/G0LUtDF3eIY/oFZ8cYUSgbY5j/O48H7F6OIddZ3w
	7cKUYLShMQGd+mE14WTIrrIUZvGEx5noM8lXyOOtipXuJRvxQxNt0VTMu3agIsYMSyjfPmjRZsH
	aLhanSmfp9Ykaq75/cqIoYy2PF/CoTnZD74CXmxOX+iSn+8KUMQ==
X-Received: by 2002:a17:90b:1850:b0:35e:596b:8a3 with SMTP id 98e67ed59e1d1-361333cbb8amr152191a91.8.1776298966715;
        Wed, 15 Apr 2026 17:22:46 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-36132c7b9a8sm25551a91.1.2026.04.15.17.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:46 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 095613422C2;
	Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id F2DEDE41B93; Wed, 15 Apr 2026 18:22:45 -0600 (MDT)
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
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 1/6] block: use integrity interval instead of sector as seed
Date: Wed, 15 Apr 2026 18:22:09 -0600
Message-ID: <20260416002214.2048150-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260416002214.2048150-1-csander@purestorage.com>
References: <20260416002214.2048150-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_integrity_setup_default() and blk_integrity_iterate() set the
integrity seed (initial reference tag) to the absolute address in the
block device in units of 512-byte sectors. The seed is correctly
incremented/decremented in units of integrity intervals in
bio_integrity_map_iter(), bio_integrity_advance(), and
blk_integrity_interval(). As a result, the ref tag written or read to a
particular integrity interval on a block device with integrity interval
size > 512 bytes varies with the starting offset of the read/write.

Convert the initial seed to units of integrity intervals so a consistent
ref tag is used for each integrity interval.

Fixes: 3be91c4a3d09 ("block: Deprecate the use of the term sector in the context of block integrity")
Fixes: 63573e359d05 ("bio-integrity: Restore original iterator on verify stage")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity.c | 3 ++-
 block/t10-pi.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e79eaf047794..3ad6a6799f17 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -103,12 +103,13 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 
 void bio_integrity_setup_default(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	u64 seed = bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR_SHIFT);
 
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	bip_set_seed(bip, seed);
 
 	if (bi->csum_type) {
 		bip->bip_flags |= BIP_CHECK_GUARD;
 		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 			bip->bip_flags |= BIP_IP_CHECKSUM;
diff --git a/block/t10-pi.c b/block/t10-pi.c
index a19b4e102a83..e58d5eb6cefb 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -308,18 +308,19 @@ static blk_status_t blk_integrity_iterate(struct bio *bio,
 					  struct bvec_iter *data_iter,
 					  bool verify)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	u64 seed = data_iter->bi_sector >> (bi->interval_exp - SECTOR_SHIFT);
 	struct blk_integrity_iter iter = {
 		.bio = bio,
 		.bip = bip,
 		.bi = bi,
 		.data_iter = *data_iter,
 		.prot_iter = bip->bip_iter,
 		.interval_remaining = 1 << bi->interval_exp,
-		.seed = data_iter->bi_sector,
+		.seed = seed,
 		.csum = 0,
 	};
 	blk_status_t ret = BLK_STS_OK;
 
 	while (iter.data_iter.bi_size && ret == BLK_STS_OK) {
-- 
2.45.2


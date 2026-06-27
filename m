Received: from mail-pl1-f229.google.com (mail-pl1-f229.google.com [209.85.214.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DDC351C0C
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 05:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538969; cv=none; b=Zhm1A/ODo28dH1pjF3KkVSh2ELpyULXL4RANoh8Tp/c2hwkM2Ah8Pfo40+3HB9J4vn3LVL+m4Vh0iVe652Pjcwk9dCCEFwjtGGaY6NT+8mF+egN7GQl78a8a0zRsrorm+XlttapjeDiUgmOkc+xvZW7XMOzy6bCEbkhER1tR+48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538969; c=relaxed/simple;
	bh=K1LOnC0nO04NxoYLtuKPP+ooAV8Hhwm2IoP1qsbA66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AycnoFjxbC209DIHWX3auVZTM3+pWWeSa7rMsY/4OEHKXtSynClIAU4X7M0xqQ1NSVgJgF1cyvZ9ZIXQh7AE01ZEIjds4Csz6xJWbvD4GFNKepG/iXWtyH7JHKZE7OnLIgLLewUJipPnHkEEUkF4MMezLOV8FzIWstQmOBw6F2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IobvcSie; arc=none smtp.client-ip=209.85.214.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IobvcSie"
Received: by mail-pl1-f229.google.com with SMTP id d9443c01a7336-2c81ee6e4a6so1966525ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538967; x=1783143767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jnhzn4PnyE6/ck4Kf6jRx3+nK+/tFuTU2ywEa+RZ3LI=;
        b=IobvcSiehcL2AQQP5bKGghqpmt4zvJDw5n6JzIuWjyQXuW+c9MGXyF/V8CSlf7fM7z
         OlOPzJs3MCJF7KK+6+cVkhHGXItW01uzfzjlOomuqvS5cbnPT8mpJk9k9oJHkSsmEq87
         qrXdOb/Fkmev54I11J57mNS1+pyfBNKxs6mItMRtp9qwX3Krkb2D9Skecalhsi14nnAC
         uZPKZS0bqEPUQk0NucxwjHBKC2SnFjxrr65sCYsrarTu6H4KLNjnwpXfRxuIKTCx5kBg
         Y9azKyUVbFiOEvWLhl8+cx7FbVmv4HYBHPWml8x83Qd49sq8JbBpY0sxyfYPgiOyDD/c
         YZbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538967; x=1783143767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jnhzn4PnyE6/ck4Kf6jRx3+nK+/tFuTU2ywEa+RZ3LI=;
        b=cM8w+kiOgHKHZMzNpMVYeziqYGrArKYTY9xd2o40H2upUlycNjlPRXHgk8R1udTENa
         iKb3E9HqnNc7dstHLne0lrcRwoPAWKSQ5MTGckIiit4w0VrQfE3bRcFyhz5NWq84Gdtu
         LfVpweDkteQ4aENCkdMe9nRO36vLM3mZppxccuuu6wGa2QhfQRoqFvBB14NF7MiP0kzS
         qG9RGj6KKZEm4fEgtq0O9tSzx1FSmjwUnorV6FTQhxphbWVZa4mdk9IguefakHdHYYjW
         edmyzBTSFOC6DC5j0TuEsF83L9cVpQFZIqoBnH8kDvnOSida0HG1afRV+bPGKhB+J6gv
         Xj1w==
X-Forwarded-Encrypted: i=1; AHgh+RoNzo+NPRbFLHAfgQCF6RFVhBk33vzr4LryW2NBs9nofWITF3tfUMFLFt09pGTNPutzbpvN0dDJ4IQl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1QKfdvIF2HkaMDo9PSCMcXV7Warlf5OxZAuUF1nxaAPbzgOG3
	Lgtfu+PJICMkW8YoAEpcjatAepGrE69yhrVJjttbihuSOwYAy4+Itqtkx0I8wuDdwtyMEuBNe94
	PUJoXJonbvAaJFxTIoofmwzrBIxfwfMPt6QwSaemMKnjvpEwXevv3
X-Gm-Gg: AfdE7cmbfsdy5XUqrG1nfDp3kTMzID7+rUmfRKMxd7HvP/YGzDltfvfv1kKIIktZ6cK
	mZ+NfxlkNq51RNFYzm/DvH+hh+KS4713CNnx1l2Gk/9rD/KrWRFi9R3DSCFLGrGbSPDzBJVzoF0
	HOQAoOwBCLCHxFEKvnxkSmI4QUQxlUeY6O7g29/RNH6C9cyreN+BuG5E1N4qspRtlb4P+1SoRQN
	c480gX6LAE4WiAv6OKzL6vZwQ8Km3rvVvPMCBkUSF1G1h4WSI6miRXnxP4G4BgYBr2QwgENhlfc
	poAvUKalfFIlQkD+t8BKrVKd67LD6zCOTMc58r3Ak3OnrQGbpY7pj+B53qeYIGn3LT8eBEAME63
	E7ZUmX7Es1MA5f5Ln6oCLfqY8Z7it
X-Received: by 2002:a17:903:1c2:b0:2bf:2e93:c626 with SMTP id d9443c01a7336-2c7fc8a89c4mr47071505ad.5.1782538966883;
        Fri, 26 Jun 2026 22:42:46 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([2620:125:9017:12:36:3:6:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2c7f63977fbsm7067815ad.49.2026.06.26.22.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:46 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.12.104])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id 3E13A40278;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3B27EE40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
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
Subject: [PATCH v4 1/5] block: use integrity interval instead of sector as seed
Date: Fri, 26 Jun 2026 23:42:16 -0600
Message-ID: <20260627054220.2174166-2-csander@purestorage.com>
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

bio_integrity_setup_default() and blk_integrity_iterate() set the
integrity seed (initial reference tag) to the absolute address in the
block device in units of 512-byte sectors. However, Type 1 and Type 2
ref tags are actually the least significant bits of the integrity
interval number. On devices with integrity interval size > 512 bytes,
the ref tag seed thus isn't the correct initial ref tag. The ref tag
seed is correctly incremented/decremented in units of integrity
intervals in bio_integrity_map_iter(), bio_integrity_advance(), and
blk_integrity_interval().

For REQ_OP_{WRITE,READ}, blk_integrity_{prepare,complete}() covers up
this ref tag seed discrepancy by adding/subtracting the difference
between the initial integrity interval and ref tag values to/from each
ref tag in the protection information. However, REQ_OP_ZONE_APPEND can
also carry PI but doesn't go through blk_integrity_prepare() because the
final data location on the zoned block device isn't known until the
operation completes. As a result, the REQ_OP_ZONE_APPEND PI ref tags
start from the ref tag seed, which isn't in integrity interval units.
Subsequent reads of the appended blocks will fail to remap the ref tags
from the expected integrity interval numbers to sector numbers.

Additionally, NVMe and many SCSI transports support offloading ref tag
remapping to the device by specifying the expected initial ref tag in
the command. The kernel doesn't currently take advantage of this, always
remapping ref tags in software for reads and writes and setting the
expected initial ref tag to the integrity interval. Setting the ref tag
seed in units of integrity intervals would be a prerequisite to allowing
the kernel to skip the software remapping and pass the ref tag seed as
the expected initial ref tag in the command.

So compute the ref tag seed in units of integrity intervals instead of
sectors to avoid relying on ref tag remapping for the conversion.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 3 ++-
 block/t10-pi.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index b23e2434d80c..d20f9002c7c9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -102,12 +102,13 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 
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
2.54.0


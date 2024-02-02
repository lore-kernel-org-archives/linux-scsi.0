Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1D18030;
	Fri,  2 Feb 2024 07:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859072; cv=none; b=lRvpzeUrpIJg6VQAVHPLnxEg8C789lOfVdqe1vFUkr8IHCJjZiQMv+UDfmyZpMTbm0hYqMr+SCETpzCMEntrYFg6lcO7dXd/Kc272BSXOsBYCI7WLqG3vw7Uy8fmq+72ECaD3XO+2sYbM2eZJeG1opqiNdzci5+81O4UJKfdb0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859072; c=relaxed/simple;
	bh=ghDCfu0r4bUE5dahnx+I96C3hoT+rAgiYNOjnZuM1dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ipy/PyCg/JgZXdd7/X/dvYmgnSgckzeTrljX0Xsnwfivm91D9v5kp+b9ooPhyhPEOSh6y778/D0fXGA5mLZA9tJ2LxYkhZZ4yWjAnJiFXKueBsBL1OQtZVwBVmNBURd/yxKAg/lURm4h1JaHEPTTaNZQASy/yAbIPytLRQ6Sqxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVzcmedN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVzcmedN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E31C433C7;
	Fri,  2 Feb 2024 07:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859071;
	bh=ghDCfu0r4bUE5dahnx+I96C3hoT+rAgiYNOjnZuM1dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVzcmedNTSJ15b8qeNFrG+Gsy7QXw1bU/wreSMEfA4/VK9aBYP1tNyhfYWsD/LPHT
	 MGrt/JdzSGsaqu6STzjksGzhyVNMEN9OJxfujQLCkOIywHxkUTxTPOZ5BWHdG12N/c
	 x1kbXgwsJrWJoVarjRI6k9nLRbXkODEYvqBn2BVdz38zv++KDEqoNUX8hl4lYXaRSz
	 EHw0EvgTGo0z6+TR9fs1srC4pln24ewpSMp9wnOEbEKPbSsBHcnGl/cqGdSvMMJrVc
	 /F8JNdqohgJk6gjOqW7gSQL76x+3eu/OVZvYYVLf7uQi1hxePpCIkp2Iupqxw01UGh
	 oJAcJa6aW2n6A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/26] block: Introduce bio_straddle_zones() and bio_offset_from_zone_start()
Date: Fri,  2 Feb 2024 16:30:41 +0900
Message-ID: <20240202073104.2418230-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the inline helper functions bio_straddle_zones() and
bio_offset_from_zone_start() to respectively test if a BIO crosses a
zone boundary (the start sector and last sector belong to different
zones) and to obtain the oofset from a zone starting sector of a BIO.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d7cac3de65b3..0bb897f0501c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -845,6 +845,12 @@ static inline unsigned int bio_zone_no(struct bio *bio)
 	return disk_zone_no(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
 }
 
+static inline bool bio_straddle_zones(struct bio *bio)
+{
+	return bio_zone_no(bio) !=
+		disk_zone_no(bio->bi_bdev->bd_disk, bio_end_sector(bio) - 1);
+}
+
 static inline unsigned int bio_zone_is_seq(struct bio *bio)
 {
 	return disk_zone_is_seq(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
@@ -1297,6 +1303,12 @@ static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
 	return sector & (bdev_zone_sectors(bdev) - 1);
 }
 
+static inline sector_t bio_offset_from_zone_start(struct bio *bio)
+{
+	return bdev_offset_from_zone_start(bio->bi_bdev,
+					   bio->bi_iter.bi_sector);
+}
+
 static inline bool bdev_is_zone_start(struct block_device *bdev,
 				      sector_t sector)
 {
-- 
2.43.0


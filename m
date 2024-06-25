Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E615CD62;
	Tue, 25 Jun 2024 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327609; cv=none; b=KYBm//G8ro1QwGvCOdt54Pyj9uZF02mNOPaiZRVwhc+HK0q8jRSd+Qpbwfbt/DXCv42rRf1qSZQqG5UGkh/KUwHo1oPrqclSDyaGvxErQAqHofE1S021mawbOf1W1tJtAoPAQ29/9Yrl8/HebIkKtk4aWVVHVBCQP1QZx/lWCcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327609; c=relaxed/simple;
	bh=pXcp1IQcf5Avfi9gPpS6hyWOYJLZFNjlA3dGoCfhXJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwNU/PEnyaIBjbFo7RBqPWskWEkY1X1+3REn7T478C4uBAQfpvEnRpZmtzhS3Qw3oBOUHVp/9nxVVWieUWSlFVeRxW37/6m3eUMAGmYFmQk76sC8qeP63GPZXS6/m1OG0q0qUzeEzsbqYpZKJ8EYiS2/BcB075ZaaG+SESpwUZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=egIBHeum; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egIBHeum"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WBw4zpC4gCRwuSmqqg615KKP+eUNXA8HQ+9IWVnRf4o=; b=egIBHeumZTWMuO8YfJss62MPn/
	PrJI458bkjFrQOqsvCaTuRiJPXb70ycUy79Ln/Ctf4REHiAIQ9PR+G0wtM17hPWixbOmlsnhQopNx
	kcD7c3G1J3Otz1BNRqXBBHVKOTookVnk7hwQumu4XOzFYq3N+cPIOSWyeZhgKQnnkVIhMdKDGWTJ3
	8FF3mo9vcsH14PvPLW/0IWgzu3lfg1rXQ37SyAhfx54vdKkY+hVf3YyClKiuC7SB9yTX4ujzpTBdK
	2WMBhM8BIIV0OZ2pwS8cITsT/+1ZD5hgBdELq+hpnHxZGJHXCE9fFzBcy7m2kYRJn3LdJJwTc9mok
	0wOHdvpg==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7eN-00000003IfU-0Fix;
	Tue, 25 Jun 2024 15:00:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 1/8] md: set md-specific flags for all queue limits
Date: Tue, 25 Jun 2024 16:59:46 +0200
Message-ID: <20240625145955.115252-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625145955.115252-1-hch@lst.de>
References: <20240625145955.115252-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The md driver wants to enforce a number of flags to an all devices, even
when not inheriting them from the underlying devices.  To make sure these
flags survive the queue_limits_set calls that md uses to update the
queue limits without deriving them form the previous limits add a new
md_init_stacking_limits helper that calls blk_set_stacking_limits and sets
these flags.

Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c     | 13 ++++++++-----
 drivers/md/md.h     |  1 +
 drivers/md/raid0.c  |  2 +-
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69ea54aedd99a1..8368438e58e989 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5853,6 +5853,13 @@ static void mddev_delayed_delete(struct work_struct *ws)
 	kobject_put(&mddev->kobj);
 }
 
+void md_init_stacking_limits(struct queue_limits *lim)
+{
+	blk_set_stacking_limits(lim);
+	lim->features = BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
+			BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
+}
+
 struct mddev *md_alloc(dev_t dev, char *name)
 {
 	/*
@@ -5871,10 +5878,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	int shift;
 	int unit;
 	int error;
-	struct queue_limits lim = {
-		.features		= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-					  BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT,
-	};
 
 	/*
 	 * Wait for any previous instance of this device to be completely
@@ -5914,7 +5917,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		 */
 		mddev->hold_active = UNTIL_STOP;
 
-	disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
 	if (IS_ERR(disk)) {
 		error = PTR_ERR(disk);
 		goto out_free_mddev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c4d7ebf9587d07..28cb4b0b6c1740 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -893,6 +893,7 @@ extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern int mddev_init(struct mddev *mddev);
 extern void mddev_destroy(struct mddev *mddev);
+void md_init_stacking_limits(struct queue_limits *lim);
 struct mddev *md_alloc(dev_t dev, char *name);
 void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62634e2a33bd0f..32d58752477847 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -379,7 +379,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1a0eba65b8a92b..04a0c2ca173245 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3194,7 +3194,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3334aa803c8380..2a9c4ee982e023 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3974,7 +3974,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0192a6323f09ba..10219205160bbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7708,7 +7708,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	 */
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.43.0


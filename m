Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215D129D06;
	Mon,  8 Apr 2024 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540525; cv=none; b=QLHHtPawVmHwqMhTWU7Gkr2kTVeis6pv1UfXLqsdWVWPyZq4e+sQem8HoCcHgIj75Y6+jKbpxGcCA0VJnOjuv/CGufn/qZiYV3esjgr7HkZnsWMY+IWhrm//jJSQluQL29OR6dHhWY7hE+Gp6Ryp0MUjFSXASyn15vL9iRv4Zqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540525; c=relaxed/simple;
	bh=eK0oimqtGMQwdEQJvds7CbqZFh112249PiZX4tEvXd4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5IfbmW9diCupuF+NAuWGAWEs9gA0Pfy4V6uqg+F/oh7UHWKR4UgQQTOrXnGi5hAvlpdhvhKd4GH3idO1VFx+brQcsqEgsHANskGaXqxeV2ee+dllzgLI2tnfniuBRBytWWYonyekazUGtqLFssgLAiDVfYsMl0XVu5frnyLvK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5GKAsbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5GKAsbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F00EC43394;
	Mon,  8 Apr 2024 01:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540525;
	bh=eK0oimqtGMQwdEQJvds7CbqZFh112249PiZX4tEvXd4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s5GKAsbWGHxk+rbp6jA+LQ/BUhioacF0kAyHjquafipgrRp0G24e8bWuIV0Cs3DZ+
	 K1vE4vtLgejnf3+bQCT2HO358ozPN963grkNKb2dPxXJYFiaWBX5R6XE5Z0zZMjWOg
	 bGABdT5dIGlpu95Mf4AJN7Vsca3hKlBXKkLzx1DN9OA+Uesg1nwo09X5Jp2s6zFMLF
	 LFpudfiz+RDsOc4Tb7CVCjdDviK6gp7yIh+Aqahdu78ZLxsKGeykpztUPQVHzNZOm2
	 FG6tTuXTi/GPNyPvH6LctRKgFLws/ns4ZaiQzLE96LcZFlXdHn4BbZ+2CMM4rzydk2
	 otqcmAludp8Gw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 18/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Mon,  8 Apr 2024 10:41:18 +0900
Message-ID: <20240408014128.205141-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gendisk conventional zone bitmap is going away. So to check for the
presence of conventional zones on a zoned target device, always use
report zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/nvme/target/zns.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 3148d9f1bde6..0021d06041c1 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -52,14 +52,10 @@ bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
 	if (get_capacity(bd_disk) & (bdev_zone_sectors(ns->bdev) - 1))
 		return false;
 	/*
-	 * ZNS does not define a conventional zone type. If the underlying
-	 * device has a bitmap set indicating the existence of conventional
-	 * zones, reject the device. Otherwise, use report zones to detect if
-	 * the device has conventional zones.
+	 * ZNS does not define a conventional zone type. Use report zones
+	 * to detect if the device has conventional zones and reject it if
+	 * it does.
 	 */
-	if (ns->bdev->bd_disk->conv_zones_bitmap)
-		return false;
-
 	ret = blkdev_report_zones(ns->bdev, 0, bdev_nr_zones(ns->bdev),
 				  validate_conv_zones_cb, NULL);
 	if (ret < 0)
-- 
2.44.0


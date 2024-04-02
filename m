Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666B86257;
	Tue,  2 Apr 2024 12:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061575; cv=none; b=LPqNb/cbFhEiD+1r/ZWekE6VQtFiUAPkB231vfJMMYjK8nljcqzyRCbLwyBfrN6dmcvKDQWcuXy4Hr8VzszVRRYnrjhqjLc+ssPXYpBbQOH9k0YZiKX+qDO//03u/vQTzMMVbv4YMR0b7l91V7puGeffm0gAYmW1ant/h1neGFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061575; c=relaxed/simple;
	bh=ZqWxRKy0BiC3ofFZbofkWToZYi/vcXeY+FC2wZOs0FI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9832MHx9VFTi9AHeHhAojFkiZlIp+5Rsgvl1j3yQqYkZh2KvNahhyqrpHIXQjeWviauvcFrObtttIFY8AhXAYYzlBizqoyeRCwIFKLLq1d6b8hJgGQt0z6TcnzwriSDNEzWj3xacQtvfZlF2G50Gb2rVhwxZjJYiMMM0cndB4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJVerBMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJVerBMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843E2C433C7;
	Tue,  2 Apr 2024 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061575;
	bh=ZqWxRKy0BiC3ofFZbofkWToZYi/vcXeY+FC2wZOs0FI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LJVerBMOcXI4hDfTfXNqW1eEDoL0m3fnn02stGN/tjROLoplmPfT0TMdU2ZLS9Nu2
	 oXeaPmfyOC01C8DllmwlBBLHvLpiDLtqCZknCNn9xh9NzEK/k5nevKLIcx6uFjfINM
	 UQ+/Wdf0tRLqnuywU/g7BJQrvz1s/vHPzVWp/L5n707x0HcAFoGSv0HDnVSkGkNMpw
	 sgTKDwi5aUyhx2MtPD/4XOc6NxwkzU7JtEXONnjps+a3a74MgFficr5rAhVU8uIByv
	 GB2vQk5RSHiFcuKeHFxwn5lrcbz/6AeM3LUCRssGdbZ8Cm33BqiNA/Qd1a2t3tI5hE
	 qAz2zn1TFx3Bg==
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
Subject: [PATCH v4 18/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Tue,  2 Apr 2024 21:38:57 +0900
Message-ID: <20240402123907.512027-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
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


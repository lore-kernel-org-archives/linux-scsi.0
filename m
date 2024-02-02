Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443B43A1CC;
	Fri,  2 Feb 2024 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859090; cv=none; b=G9T07I55289xjXsCGE0lGxRvCvjIJBWsxYNcx6+mDnS3XHgwB6OBN0/nRYIG3KYQDUNQE3OYdYLm/b1hpvcOgHGdwGP0KYq1gEY43ftG4hAT4yrLit8pVYO0Zvvv6U1FK1/x2s9Lkw5pEKe27om9RHsM9CXB0vCQEvjWi2o8heQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859090; c=relaxed/simple;
	bh=duiENxXpLby9NcXm8h6GCYgOp95Mhw7j9ldLWg0lGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCB1y11suesF3j4jjDN08b83vKGcrkeH5uwj/bbk8Pc8P4I2H6JD66ALyYfpgR4R83WIPplfi2VKLFVglL71U6A6yk9GD7KhgsD8thA7xFA4A9borUvLWHroO/OQjKfGwynB99uCK47X1ES4gyYnWFAE7Gb19PgnXkUFK/g4mG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTJAWCBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTJAWCBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12078C433C7;
	Fri,  2 Feb 2024 07:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859090;
	bh=duiENxXpLby9NcXm8h6GCYgOp95Mhw7j9ldLWg0lGO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTJAWCBFCrfv7A+UgFoeNK+Wxvtb+MhSPtxfpUkhLW5hSquTlEzP/2UIA6QMBtfPx
	 yToFt3JnpQEEeCF4soHspQWtl+qgtlEPKFDGOzSvPhkN4IJfpIoweNOgKvUoBc3+pt
	 +3FnDg59nuaYq6nqtHZCwdeo9nV/zx1AKTWzpEfVs7qR6DHNKed6oX68Q+CYLO1taJ
	 VjgnRSaX1qufGQki/uhtNuPjt7tieT1gBNh0qpFfbYh4pePUtSCX10+66lOj1LBmV3
	 +nnJKx74xRtxQdgQW5pEAY3DQbE4fyxUPNXWIItKdLxQo7f1R8rofc+6RX4j1J4a2G
	 dWlArjPIPojmw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/26] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Fri,  2 Feb 2024 16:30:54 +0900
Message-ID: <20240202073104.2418230-17-dlemoal@kernel.org>
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

The gendisk conventional zone bitmap is going away. So to check for the
presence of conventional zones on a zoned target device, always use
report zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/nvme/target/zns.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 5b5c1e481722..f95f0040e108 100644
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
2.43.0


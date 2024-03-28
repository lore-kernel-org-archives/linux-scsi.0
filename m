Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F3A3987B;
	Thu, 28 Mar 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586687; cv=none; b=QmsNXHhkmTLq0RR1mHHpyE+EJ8fJRc7PhbAt3GVecF8UwC4KDluW8f5Run/V21tvWu4wmJ9J0CjoyFpV5wZ8lU3wwbj/pqdDtpPHr7O4W3DpVPdDZwIS+f0oIp+M3GOcUWsZZhCWSDOYa6Y+f9kzfmxDyoh6CSRF5w46l3GZds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586687; c=relaxed/simple;
	bh=Q82us1KAyFFbFVCmhiR9y5cPq6FqICqZqK9wxosWHF8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhvmz45Q80eLXx1FBNQSJUhN+Zcbb3SBjG7HSrRL1fxmmc2dksBmLlbXFv0JrsLY3UmFoPrRGKhC+I217TAEc89MKlH/7X+HJeqH4L6pZCNdbu+FPs8NbmcbufZ6b2/JBDdZuz9T/3MJl6Ls01S3kyE3dESCT9Tm7mmU7fkDAzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTAawlAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTAawlAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6203DC43394;
	Thu, 28 Mar 2024 00:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586687;
	bh=Q82us1KAyFFbFVCmhiR9y5cPq6FqICqZqK9wxosWHF8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mTAawlAPCDUKCaTbep2ShjXFAtHPlJVDeOYnwSmD27+h8oymA5/hx7xxNwenDqH16
	 WhT+exGh5iFYP2NLEjajB0tNxKi3jowaJDPRnIm/xOM0lGANdOCRKR4pR94QoJpObA
	 bpLA3XJxLrIm4uBwKI9jDBHFOzQEu2l4y74v+8lbhrMwjvjqYLKfQF/+Fy4VEZfNXx
	 ur8W6KUY93uQd++BMqyTsshGnyKsXjDr+RhuxSQKVNkktHRWr05wz4pCbKxM8M0qzI
	 0CJNbfQEoSwSNCYP4Vb3SQNcf6rU1+gLE4eGENe3pZ6stltk8X6CQ5IAdVwHTW3/5z
	 zH8okJcTAX25g==
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
Subject: [PATCH v3 20/30] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Thu, 28 Mar 2024 09:43:59 +0900
Message-ID: <20240328004409.594888-21-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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


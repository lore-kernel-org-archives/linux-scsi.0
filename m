Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40918364DC;
	Fri,  5 Apr 2024 04:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292156; cv=none; b=oDDAaOAGH65UTQz1CEAvVuqIgRNntzfeTPod9qcoKJkPuevLGpRbehhEQOzWg+d3Rl+5Q/HmiyGphccORSvUzN7t+w0AGYQdS0Ey+B6xU0xNjwHhlRo7JvIZdeH5ilrwcOK0qabNWFv9WO/VhKmAcR7FE2NPmG6NCIswV8PMJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292156; c=relaxed/simple;
	bh=bZ6CmoUZHeF0V+yCdDX4vQwkiIgUMYj2IlheLcYsEw4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/SHX4EDv/QrMueKCQ4MxXBTHrq2EdyY0F8ryeFmiQRjfPGISAuznrBmkszSnQUQo3t8oGVmmHRvtZzfhq5dlT9R8Pl7bucFZ2u5bhsAyrmYeiZIvC5QwAGv9lwERz+x6vtpmffVEi8SaZE+g4wXU+Fw3BdsaOQAalh1Cmth4Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehQC4oNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehQC4oNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F256CC433C7;
	Fri,  5 Apr 2024 04:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292156;
	bh=bZ6CmoUZHeF0V+yCdDX4vQwkiIgUMYj2IlheLcYsEw4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ehQC4oNYoS7eV9v/xjeCQc0uguM7tdTrX+cULWOZzCPYiiNx2vCqw8PA2Iky0huz8
	 rYnyFrNIP/uJFy6LrOLmKVIprZP0q3hC9/ZJhbrJ4auotTlr3om9rtLiUoq0Q1q3ea
	 awvVKl7/36F0oHn2FDxkkRBTpVaUjbJjJ//7x9lgdLegnefpU1hWcuS12/m8LDAa8p
	 jDa2wnKwYb+1bZcyx0DJkA5krnUvyrKVFw15nTi/lYUhRdrSBvJQJb3pi7u2SAz2av
	 7dUXRk1/wv3nMHBuaO/clOIyVFqH5mdIew9BqzICkiQabnjTe+KCbzKJ3QYOlEwHko
	 bBl+09RbHYNOQ==
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
Subject: [PATCH v6 18/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Fri,  5 Apr 2024 13:41:57 +0900
Message-ID: <20240405044207.1123462-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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


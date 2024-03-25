Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9842F1C2570;
	Mon, 25 Mar 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341932; cv=none; b=YQUpZVUc/hP9dzmTystAKLwvsd9wEglwB95YWzmLuC64HTwjZOrdN9V5V99WRfjcafhfzi+kovNUwlRVN4zFG+TMyuc3UAWHG3YEejjts9ekoP/5gZxsSMfeEzPOOL8cM5s+/j/Mr/omYs3prG1jeOamy/Qu84VCDxdd5M+ukYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341932; c=relaxed/simple;
	bh=VI0oaqaJ8C0CI41pt1LzW/PFgmEPhNExJLpTSq0ZMxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK3YSkley4P/99bf1O5N4R15V77Y2gHVwL6md3JcDyiHUG/4ybmJmIcjmC4IT0BwkcM+wyNFm/cvSb9+cUaOuKfqrX9TNJDxF5lxN7JcKFKdZnkjnrkJme9DniAV3j3ITNYyDDl8A3Vg9CHHO+O85uV0YNcEQtWW36pEm64p80s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcDXhFYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcDXhFYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1006DC433F1;
	Mon, 25 Mar 2024 04:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341932;
	bh=VI0oaqaJ8C0CI41pt1LzW/PFgmEPhNExJLpTSq0ZMxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcDXhFYOLmPrn5annEnl/KTBnEQTCVrzzMLZFpxZ9eHPq9TN9r22iHs/Nzc8SSObt
	 dtW3cmNjSuTnOKnwx72Yr3KOHyMlsaqn5htKF1t+pNSXMPkAHTbdCMjIWQkOQIvlQb
	 YvQ6KRzFEU2qoHLNZR67dMAHOmyrcvztOANGvZssgSYeVwJckL6QZIYJOUR8MiWNR5
	 Z0OApWJaRc4trUzrRyEF22lKUl0Ub72A6qyz/C9OFsmBikcQH9O/XfQGqcdNUYBbyW
	 N43dsPJaswEmFA36MsCt/bT9mKKKeVRkF5iH0/Zsm14XFD1ftFrZqc+wRZzQ98u5f9
	 RPlZL7vi/LJoQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 19/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Mon, 25 Mar 2024 13:44:43 +0900
Message-ID: <20240325044452.3125418-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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


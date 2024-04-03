Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A4D6CDBD;
	Wed,  3 Apr 2024 08:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133798; cv=none; b=nWfWc8XnpwKXOYHNmsIekgjR0i8SyQBQ7vDZ/iviwoq7RdLsT0m4sjcGcJCAFEtnloR/PsXv200oqVAbdBN8O/Uu4NXsdK2FbEdsG2n7X8Z7hx53avnF6QCFzciPVfTW2aoWcNQpvqVNtM2WWtBe6aCsogutiGUjlA17gnjCNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133798; c=relaxed/simple;
	bh=ZqWxRKy0BiC3ofFZbofkWToZYi/vcXeY+FC2wZOs0FI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0sUaZI1Ucoc5A6V4X4hSezRAec+gkmJ2+S+Oc2yIzL9KkxicUTDdB3ZfxNmbIcZkRXxmH1AUr7SQTl2cRsR7NvE2ED8+mSQ0B52S8vKSnKXzyXqfgV2SpBOCxKKtYmd/RFKqwakmweQ0jAKeObahiYTau7HawIr6IlQ1trOg3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iz9I7sd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iz9I7sd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5884FC43399;
	Wed,  3 Apr 2024 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133798;
	bh=ZqWxRKy0BiC3ofFZbofkWToZYi/vcXeY+FC2wZOs0FI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Iz9I7sd4/aSq4vDOd2lSxyzNsdkzO/CXcYaqW6eo4n4IPI96Jv9BYwD3qR9LfAK/Q
	 ZztYki5JIYVSp8xQfENRNYWivBEPHy13m7HmIQxNcLeyMgcPvMwL7PFFeVQQlCbKcT
	 rlKpJcpTNgKSniGRibz8zTiwMU/oiaw0CwmcxQ+w0VEJunYCgAi3cvlcOMMiPDDBJI
	 xdqIZ8l/64z/hNEAnVsFahW/4Agismx/obGhWidDyRKw7t7U7l/YxvEMomBEWKU93N
	 z+pfQE4DhNF5IUotL4FZU91QsHroudpx77yvHzBPOYrqnr+KX1uR0rB4brQPUPQTXy
	 ort6NJjRPVguA==
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
Subject: [PATCH v5 18/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
Date: Wed,  3 Apr 2024 17:42:37 +0900
Message-ID: <20240403084247.856481-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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


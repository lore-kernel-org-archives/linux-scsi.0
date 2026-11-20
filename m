Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208818;
	b=Ar2axft3dF1Y6npkpx2PVHL8sA4N+evkl1ia5sXcFzZI2JLdY6k4wwpK6eijFcYwl7pW
	 JoYqDTfoFIN8Xyrhuc6xnHjPr0LnxenLC5mg+tbyBZCpxKCVdcoTrNVVG2opu76Q19MP+
	 YkePiY88sCmcFCfcqkddXrLnn5dfNaggsBe/JaTLdDCkAFaythHcEEUoZmJB+3O4SjzM/
	 0x3DTgJGvPzChs9Hc9LTgOU+AtcNc2AQ+8suRR0BunhXm+MRGe/qt8rqMZrhyqgtuYfUY
	 4OXLnNEwX5wwJ0WYeU+iGuVO1/j1xl4sSh/+43eo/RWm/eDJFqdmVMmXuG3DLtUE2yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208818;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	b=MBegkxHekasp9OzbQ+UDUf110QbiNPcXwddWRA4Q3plMcK7Kb7j0qzgFpuuES9SY6Hdm
	 pi1V9tbreA5pj62rCPSyl03+tDi9i1RR2RZV275+FJHuZzcV2aQo1MGYb8LitQeaOGVWd
	 Nj8mXLVGwZPXgXeAsVAU0rV4q93y5OItjZPjVTOTSsTr/nyEX8YLxeE6HdPz8SrbLL3ID
	 EuDySHGhWbS3QZOMPoeSzobVJb2R9om+pJYs77AJDO5lWIGEgXGmU7v/d4AdhNO1nCXPz
	 qCaS8rlDp89xXBR0ympJOmQSlsrKJN+ezkd0/Bo+S43bZn/Dzr/soCf4YufjvFMTJfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLNeau5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AA2606A32A;
	Fri, 20 Nov 2026 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLNeau5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F329D1F000C4;
	Fri, 20 Nov 2026 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208817;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=WLNeau5YvDGmQPQsy/aIDIuZIXoziPcqa6/0AjMsQC/FSt1jhsqYrD7dMPe6PM0x+
	 H4Q817/A95QRGT6pqBaaogeoVx+54n1zMUDo1I8UcAt3iWDReKz1E2V+zNny5ALuzT
	 zfzA2LI569zplkwyr6mnRVO/aUJmIZSqSbbmOGyVyRXj3UIsJc5PoJYBFCDH8oSSw4
	 pGczl6PDHdcMzsaAveX/A1KH4pIhBnyHLxsI3Br+w6huO4EXRmpc8fwqKVNrgkaO1g
	 gzcCcD847O0xzM0D8T5J8GhszvHCvuRSV8HvDGiVe+5zn7ljLSg0QpC4Tdg4R1IjM2
	 RFoCsWn4+8X+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 03/13] block: allow dropping all zone write plugs on revalidation
Date: Sat, 21 Nov 2026 06:06:41 +0900
Message-ID: <20261120210651.580511-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for supporting storage element depopulation, modify the
function disk_revalidate_zones() to take an additional boolean parameter
drop_all_zwplugs to force removing all zone write plugs from a disk hash
table.  Removing all zone write plugs is done in the same manner as for a
capacity change, using the function disk_drop_zone_wplug() applied to all
hashed zone write plugs.

Calls to disk_revalidate_zones() with the argument drop_all_zwplugs set to
true will be used when restoring depopulated storage elements as such
operation clears all sequential zones, modifying them to be empty.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 600d6bd008ae..3761e634650e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2552,7 +2552,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	return ret;
 }
 
-static int disk_revalidate_zones(struct gendisk *disk)
+static int disk_revalidate_zones(struct gendisk *disk, bool drop_all_zwplugs)
 {
 	struct blk_revalidate_zone_args args = { };
 	struct blk_report_zones_args rep_args = {
@@ -2563,6 +2563,9 @@ static int disk_revalidate_zones(struct gendisk *disk)
 	int retries = 2;
 	int ret;
 
+	if (drop_all_zwplugs)
+		disk_for_all_zone_wplugs(disk, disk_drop_zone_wplug, NULL);
+
 again:
 	ret = disk_revalidate_capacity(disk, &args);
 	if (ret)
@@ -2647,7 +2650,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	 * eventually change the disk zone information.
 	 */
 	mutex_lock(&disk->zone_revalidate_mutex);
-	ret = disk_revalidate_zones(disk);
+	ret = disk_revalidate_zones(disk, false);
 	mutex_unlock(&disk->zone_revalidate_mutex);
 
 	return ret;
-- 
2.56.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931065;
	b=5dxqUdXRbhNZECWYR7uG4sLoD9nTc5N/iUmjDflYNBJGOY8IgEBp3LaaoUzwchoApZzC
	 2YEzXqGFC3FrqTaHXO9EbtY7hoKpFVlCB//ZEvLiOuIvv+nWf4xAViaGFDJyY1MZhcaKj
	 Q8fIgtiNq1bUvqMPp2WLkw0W5PrUHrFoPP1QFC/of079yec/H8vVPJ5mi6p5Dsr8DhaXN
	 UQ7IWZXLJB5emu9Rpu78Asx573VCmwnQrEH/jQxwDRaxkdZlPOP0ENGIIuL+Vx8s198DZ
	 VeaJHQloxPv7MFWcY5VcUu/y4+OPd/vSgRRYUb6Wb1cdVoU2bFZdh0/Rbiz2E+uzfSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931065;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	b=PTh/ItbYBxfVSNJHE9m0nLBpWUHyKBIx76vh6VjKpARveIbfzOw2dlA0rJJqs1o1hPxZ
	 6/jltRN3AcHHkQui7yRv6kU6jmcuIFszE4q2tsMB0nzQ2sTGaqFy3DIXqaCXNtSIYyWAp
	 RFfGVxowF7DlDYinjwnnnCHEnBaSBHAcQuE7aFFqcyzOBZCWrvgAPpolv6/6cKru9lSSI
	 zdV7sTlnoz5JaJE6v7GcdkbqZdI241Uw1jEw3VgrR5zCq+swHtkhohJJrKpr6bHyzEUzP
	 c0wRBTz9F7r4DuGE2RPxlG5IpYIizhH4rPVrSsbnDe3qRuV5p9OgCyhBxKzuIWkc/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKFKbgnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4B606A884;
	Tue, 17 Nov 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKFKbgnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6B21F000C6;
	Tue, 17 Nov 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931065;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZKFKbgnN8xHsOJn/WDG1l4DSFLvZEYTxQBGqBRzBgN/3at0bcJSRNZBC3O4EQKGfT
	 jCjJ1kxJXBhZrIIx1tiKZuhZOakjph9GCzi1n+bFR7S2dIjCB5qma4TrWtbTFaBG0U
	 DulDSWpiPn0/t2H7+1QouD6sCEGan8yiobrlAVjmbMEiBhpgHWtFh5O635VjWylj9m
	 rAY+B1+WFB6mFMidhazqmsLKBMr7pebzZ7Yyjyw2gvLKsvnh+HWwdLrTNcjiyQG1Qq
	 BNcxdXhAujYt8fJVIeRodyZiFhhLCs/CxP/F1d+0Gs0ntlu6nZE4vYa5mQUPNaQ9BH
	 PO8JqZjkBZiYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 03/13] block: allow dropping all zone write plugs on revalidation
Date: Wed, 18 Nov 2026 00:57:29 +0900
Message-ID: <20261117155739.304506-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
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


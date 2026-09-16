Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFC24F7971;
	Wed, 16 Sep 2026 13:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567145; cv=none; b=loODGJQ5czh7TvujE3CEV5HTQbnlwUjs4V6oIIYXJXFeXsTy5aCKmYiiKcpunKDdLXyJl+mGWKtzuBY5/5DfQfiflqGp6xLl5kZKeEeElmFfzdK7DujWwF15PPMstrTl+iZVPgjS+Zs3toBkiN9K1PGSPDin+fi5DR+7pxcQFFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567145; c=relaxed/simple;
	bh=iy0+G4SeGCJYULbTINVC9Bx2QHxvPxLCDP+Nyv/4/CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ1NDvkNwa/AU+mcyPGSYigmhSbFOLyH2H+WJ6RFsVAy/54nuCFWbAYoK3jPTSR7qkGPthRGbbbA7RIt9MSbIgO007nV9xa5ruwQv7baAPdDmlwovTM5aahLuSWELi9oGThkRj4fwerMcegavqeKVJk+V5BT5id/y6TqwBoyxak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz; spf=none smtp.mailfrom=fxti.xyz; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fxti.xyz
X-QQ-mid: esmtpsz11t1789567106t4102caeb
X-QQ-Originating-IP: BMZHLLkqF8TvkcXeRgxZexOE7ODSkEQ8OgC4v7P3Jw4=
Received: from fxti.xyz ( [14.153.126.83])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 16 Sep 2026 21:58:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1711284091273451374
From: ZHOU Jiaxiang <me@fxti.xyz>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 1/2] block: fix zones_cond out-of-bounds write on zone report
Date: Wed, 16 Sep 2026 21:58:21 +0800
Message-ID: <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260916135822.32584-1-me@fxti.xyz>
References: <20260916135822.32584-1-me@fxti.xyz>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:fxti.xyz:qybglogicsvrgz:qybglogicsvrgz3a-1
X-QQ-XMAILINFO: MpO6L0LObisWCVCb/xLApDfZ1Q1/PSaPL4XTirqJie9iVcRhA+DyorBA
	VvU8NTWoYV4GOsqnbaU8OB+eX4Yrc89oScfWlLMUkpcWkBwipwET/nY3kJAf/GzIsHcIVk3
	jDE/OT2Z+5wtZYuolX8jsEg/yhoscGNwMQgV5ycB0hkQn8HQBF2UF3Sl0wD/KXxKQDM/8fx
	wl+2ke9L4IXmiReVwwphWabEGRJY6QTbGXH/O7brcb9CPxCQQT3fsir8Bz6A5BWa/afjhsL
	SJY9l5ccLk3e3511BYciFLvEWV73gK/GxIdiZgrUJEuGcfK3EpWleqCI6SiNJJDinwZ/+Kt
	40eFXhEbgf6+f1ZBsMYS98UPAaGgtqoYwvv4Xk300znYN5nrk4jiQ83qOmO4jsPD8TpyEQq
	MZfY/B2hR6Sm6St9Z2vAemjOPIeieM3QJixwbtjeyH3fGKYuOPKUMcstavxIHB2s9IksmO/
	BanwgXAkAXt14NmDHe83qR9Typotqd9T1Ksg7LMjmUnF+yxR1h8oJCfcDLpQVHaHJ+axtyN
	ZuJwlnufnBmnBANBL4E4ojQqlhVVyMvEt8xyIpwvZvn3AX6JPKLkN0KqzWSpQ8ZGHbuylc+
	isRTJdvOUUycVte0ae+AVRftMd+xkppLV9QqvkoVd/O0qJRNhGc8iO+HK+JyZNvnoxNJy9w
	1k6HeBVzSR4OuxrJ54tp5c9p9B/J9Uj34551hh5bPVA65qAVMtsNwF/vkum19QSGOJvJR3A
	FR1XNNdkA/a82wTd6nudm+Qzf8DRqXGlZFQj2ksAyJYboQ48d06eVjmkpL6dO/b0lPdQNlk
	ujq6kxjVYtOlR9xvelp8rLSJwIm1jEsVSW5PoKFKSqogC8sPui74AkKZ1n2ZwH2DOwERtxc
	SgLIeGaizw7Ar6mjjJvOf+NrCdSfZlvZcfz/7zZ4+VRLDxo34KAluklKMZ1G0zlYPY4GJmG
	WptUWDwghm0+Yl6fcT/ST0QDP1yxju8VjaeMnOik/jSe9fERJGQd0UMVY
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

blk_revalidate_disk_zones() sizes the zones_cond array from the disk
capacity and zone size, but the index used by blk_revalidate_zone_cond()
comes from the device-driven report_zones() walk and is never checked
against the array size. A device reporting more zones than fit the
array makes blk_zone_set_cond() write out of bounds.

One way to reach this is a zone count exceeding 32 bits: both
blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
2^32 + 1024 zones of one 512-byte logical block) gets its zone count
truncated to a small value, undersizing the array while the report
walk keeps counting upward.

Check the index against the array size before storing the zone
condition, and refuse to revalidate when the zone count does not fit
32 bits.

Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional zones")
Signed-off-by: ZHOU Jiaxiang <me@fxti.xyz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a5afb842b..475aa16bc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2018,12 +2018,17 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 				struct blk_revalidate_zone_args *args)
 {
 	struct queue_limits *lim = &disk->queue->limits;
+	unsigned long long nr_zones;
 	unsigned int pool_size;
 	int ret = 0;
 
 	args->disk = disk;
-	args->nr_zones =
-		DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	nr_zones = DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	if (nr_zones > UINT_MAX) {
+		pr_warn("%s: Too many zones (%llu)\n", disk->disk_name, nr_zones);
+		return -EINVAL;
+	}
+	args->nr_zones = nr_zones;
 
 	/* Cached zone conditions: 1 byte per zone */
 	args->zones_cond = kzalloc(args->nr_zones, GFP_NOIO);
@@ -2131,6 +2136,12 @@ static int blk_revalidate_zone_cond(struct blk_zone *zone, unsigned int idx,
 {
 	enum blk_zone_cond cond = zone->cond;
 
+	if (idx >= args->nr_zones) {
+		pr_warn("%s: Zone report index %u exceeds zone count %u\n",
+			args->disk->disk_name, idx, args->nr_zones);
+		return -EINVAL;
+	}
+
 	/* Check that the zone condition is consistent with the zone type. */
 	switch (cond) {
 	case BLK_ZONE_COND_NOT_WP:
-- 
2.50.1 (Apple Git-155)


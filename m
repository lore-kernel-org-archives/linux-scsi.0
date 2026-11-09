Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217910;
	b=MKM00tIxe7IT9CeYli5ftmzLBU8UWIPMl0Ex1VZbT3fXSex0vNeFhhUdGOAAXyULBCEm
	 WhqIUngP+SxOhChlsRCflsa42/9y35m1WOj9KuX8gcIADDqH7sGYXazbRiOgzlXOinGs5
	 jKu4+4FdhoqjAG6cCfPgnOtvItnUjm/MIazHsPjn4vcYTNgR+/ST8f6nUKf5ZVQlemYzS
	 u7tLeLHvUA0/1iszMn/+5OUWo5MnBXyi/y+XDXYZ/YZe74T4O6/H4KSc18i4q7c1njEZg
	 TuuAGWFEY3H3pe02RbB7MCv0bINdksS09hk/50y7mzvGkmSz6O2A6J78PzGc7k73N4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217910;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7MD7Y/lE7mN681ERipzhkv2qPwGIYQmhku9iVo/qa8M=;
	b=PBtixCBV6gZnqqloqsCgVDps45uSLGkvO+FfZLAecDTmWVI+FNeLYqJiPhyazwH3KihI
	 bVuE+Bo79toiYcPrfzF7O2V+cx8qgb8bCKT59PixgjNnorKS4lg1ZP+0CUzZstGlNEUkk
	 HtVzXvzmoekBMgN4vWM1LNZ8Ef7rGbqUpxlQ2xcSkzoBNUFNzJ8scEKCS09PkxrbUxbkE
	 kOvSU4APGGhoNSj/aR17mKkyoEx8dYKw/5Qkhb1SnwCkovGy42BtLigdU/dxy8hm86dKn
	 52MZcLoo5TkA1gHyFjHnyvpksuJNyvKIOhzLrXAO0aZUu4Q0G2wKVoaFdjoTOWS2M4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYPOOBKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D62606A331;
	Mon,  9 Nov 2026 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYPOOBKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E9B1F008A5;
	Mon,  9 Nov 2026 09:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217910;
	bh=7MD7Y/lE7mN681ERipzhkv2qPwGIYQmhku9iVo/qa8M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=VYPOOBKECSITTCOieGHFI1UsuP5SAlav28Rljqdmq7qmJ3epiwWJwR61nJVvijzBc
	 QMms4YRxaAnr1wAeDyAeI8P+J5UoRck2lIbgLlIrYuCLj3UPF4w5WVZ7sb8sFrP0k9
	 xP11DODkoP/oNYT7G82Q1E92cUAzx1M8iIEH5VosZIRchWWz9xaSfA+UXL0ZDxs3H5
	 3HyyXLErEy4fm2nfXm8y0/p9n9Ww3XPTTzNMr7wLfD4EsYgqH772BW3hHYy6zSVVvN
	 39eVUvS4massSTjmPpmmxhlNKUxA/f8lshwFSoL79EVW3DKpIJfDYFMHPJlA0xYCbn
	 BDWiAA6ipPRTA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 03/12] block: allow dropping all zone write plugs on revalidation
Date: Mon,  9 Nov 2026 18:51:35 +0900
Message-ID: <20261109095144.819709-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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
2.56.0


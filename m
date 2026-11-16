Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865028;
	b=roLUaQaqjtnA7xPF4BbUwU0gjZGXhLb3uCELgW/2M5pwO77589GseFu4mw/h25d4q+ZQ
	 1JmLv2YCPjUWbthUZ6LKyvgpCOC3aXrvZDt3OKbcEIo129QjO2IA/zigQXJLtXzuvw0fZ
	 HtLDEedARqQYgcxfAy9SuBAvq0ZpgBLAhaAQZeLB1QAjMqC2M7p2h4uxLxpxkMTCjOhUs
	 ftslwxUnhnKtYjsOVk9e/n/Qw8CSsvEyi9uWfhbKtwf+MOPU+7I3XQvlp9BnucFcK6ezq
	 UORVOAqL47PuO+ubyNeGqxFi1o8+Q3MsmAQgaNPeO412ZgtOfDWiBcPV2v5/c4QP2FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865028;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	b=dFMleqSulwskykPuBsR7UNpsX1h9+mkgsnwrFS27dc+DgpYU7Q15UpQjXfnkiCOzJEax
	 DtcCdGhsfSGhuVO/ymus8HGjPCPZNoFgBDqWUDkF196jsAftaEkRpItBDEO1BS+ka6WyF
	 27ynJ3XXOE3LrW1KabpRjizabwIelTFatZ4GNJ/NusE4kSXV6eU2aomjAqTuJ6avow3ux
	 qY+IAwN7/Pn3mpQFVqI+AHiaz+4ELq+3M8hySaeHW6KFW6ic+nUI1Q0oiy1x7erEouCCR
	 Zu4uyVH4D6e/LPEv9afTSoidoNredtC2heboKmdwsO4P7zz8cJWrGYwO03Nmd4zJpDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6C1adM7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C559606A33A;
	Mon, 16 Nov 2026 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6C1adM7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239331F000C4;
	Mon, 16 Nov 2026 21:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865027;
	bh=8BkUdf1S46KqyubGGpY/YhD1wSuJJFemJippob/xq/A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=W6C1adM7QaoBzxDgDZzlnv0P8H12uRBRHBDNrleHq5m+8iVAfbWuqk3iXmM9Kdi4l
	 9+jpN36IRD2aHaO8uTQ737MmTnpAAnlyeSLbYw5pQyJcd6hf2c2phiVZOj0Bu4KMHh
	 sqbJaVG5BN7JN9NOvKnB+ECyKlKlBIyzHFtG4/PuXUlwsKVt6DYe87Gkn1t1A5kA3W
	 /CoGbnBm6b9xAKEa8IDOrDYF/8/GAYbmyFN+2KSunkyqdlQdMlIOXyE4wKz5Raw3tk
	 c42TP8bPFfWvR3IGP/AKHLNYXwOOKhOHzk64azz3ops37iWEkMM5K35kt72dczwQpz
	 xdifP3RcYngNQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 03/13] block: allow dropping all zone write plugs on revalidation
Date: Tue, 17 Nov 2026 06:36:52 +0900
Message-ID: <20261116213702.225970-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116213702.225970-1-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
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


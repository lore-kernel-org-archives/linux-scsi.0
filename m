Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208823;
	b=Y78ayahT7Y2WrtC9vwk7SoJyj0GeAg2NFuzjLKK/G9tnMhfy7mR90/tss7crQhiGxaJ1
	 s95Y6wmeV70DJCzffGfip715PIkduLNDcoPhVqiuuGddvhj563CLeqonDvxNKr2jkPVmL
	 ty7i8hil1TlQSkVieulkCQuGwwIvbxbZ4f0k/x5GXtHt7tOBYoFFEJnaTXNUT/mlOnYiE
	 GPxc+pDmSoBYg6i/ZkYApaQ8u+CwAqR4DgqzC8aiia6ML1W/L7KXmOisW2uGG3wL07j/g
	 heSCEgwfJnDxTLqhrTKITB6FNWRz96b4KKoqANPxSdMtxF9CyYC+d+LaIrH7bcQJVIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208823;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	b=LAL4DOiqCxSxW48r5Dot/sbb4HvaesBvgerEyu9sj2Cm/SFHpUDvqHnmTXpDD8Rw/TnJ
	 o6xRZsFu3s7Hesvy4vD0ZqzgnJrxMQyj5RLbiC2sWHhFCgdM5aGQUHTp4RIlgb5mnoii+
	 cImWUL9gubQo6Mbb3ciYk/buY+/ERA4XikT7vNOsM9LQXQ7D8SOcZsd6LjyhJEpRTjKyt
	 5jlDydtQij34goc+povJoPCv0grc18c9DGKNlDrpDUTBzlMRM0oE2TQx5oVxDni9BZOJh
	 +IXeHQkrFIsSLq3icrI0ccCagQNzxojBEpoOnvPUNWdhE6csik+I9U46G/fDvRBXDiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eX2Wsn3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5C606A6A8;
	Fri, 20 Nov 2026 21:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eX2Wsn3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7FE1F000C4;
	Fri, 20 Nov 2026 21:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208823;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eX2Wsn3QjH0zF0UALRcF3NDUF8ulQJbS3hKQYqHwKCx7D8gc+nEvkj15jOGvoumur
	 Be953LQ0xQXwziAaNUG3gS/vvZ4esSHHtU1MaHWG42xRx1A4+kFZGIqj6eRzkQs7ma
	 xzFPAUjxMbnWX1ToOtlk5OhC2cpqBInbtgQyITQYKerkDCjVN+2ngBP9W6I2RPSst6
	 7kjTzWRPr6x7XAn9QZt4fALCLk8RYOgi4m9UXkzaBK9jeKZ4blQYspBjNSDRoy3Gnj
	 9lCg6iKh6x8L7N8SnG4gIoEbehRe5YOWQ9voGGz5QFX1ORnVm7HcCq7RjescGGpKHp
	 wV9ZXGgnvW9iQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 07/13] zloop: fix zone reporting consistency
Date: Sat, 21 Nov 2026 06:06:45 +0900
Message-ID: <20261120210651.580511-8-dlemoal@kernel.org>
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

In zloop_report_zones(), filling the write pointer and condition of a zone
descriptor separately outside of the zone wp_lock can lead to an
inconsistent zone report with a write pointer potentially not being
consistent with the condition being reported. Avoid such inconsistency by
filling both fields while holding the zone wp_lock.

Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 19949ed3824f..6bb68022ab30 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -950,8 +950,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
 		blkz.len = zlo->zone_size;
 		spin_lock(&zone->wp_lock);
 		blkz.wp = zone->wp;
-		spin_unlock(&zone->wp_lock);
 		blkz.cond = zone->cond;
+		spin_unlock(&zone->wp_lock);
 		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
 			blkz.type = BLK_ZONE_TYPE_CONVENTIONAL;
 			blkz.capacity = zlo->zone_size;
-- 
2.56.1


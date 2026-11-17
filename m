Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931070;
	b=2W2yue+O0Uuz9D2fn+I/92gMzXX3cwSK2OCm2uNANl1VqfssbRFmCxq+N57VbD20JfZf
	 PrLte3qKvmyiIZBJxKRqGG0rmh1D2rQaVU0FX8PhAbFr7pLnfW171FWjpQzxqJJl6aUMs
	 I9MOw/rTCemraD7g23xC9blEc1yQBws+bx01rVyctMmRgqtI5ObtlXL9Zp6zdO3n25fy+
	 tZMxjmu4zlFnjuJTtAW8hVyS2jcw0ZRmBTfqPfAPJvHB9BTiJeR5z6Rjp0lqqFaUX3nVv
	 kiKLukngvQnNpdJvv6gecpJN0tSlco+Z+yUNYpXtA+pjR0L5XXbrvx1ZCnPSjfVANPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931070;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	b=QiTTr6dqE+XJYNTLUZY3hoOk/lefzCXyfUlHukW33bSXUHAvkymSWX84z51Sfaqx4m4u
	 eyqnAFJ4JAVSDdIjlm80NuCHngN0pLow1PqrIFU3ELMSGqakmFwZt57kXMSN2Qdv31BYE
	 LtS8cDkPM8kn3vSnhjjuf2Hgz8jguLCrUBQ836p1iFAD0n40NbaCMg9AMIu9RS5VFomvs
	 xUCOwzl+guQZQzdQUjofmk6zFQLAVe2NYofUKwi692ex66l+WxSFlYIS1hMqyQ8pNyxpj
	 Rbw20greQwBONze01SxZdX5x5UWCsHYink1x9rVWaE1QEiwj8oXlvvwz+y7VeCqoGuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhPcd+4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A63606A89C;
	Tue, 17 Nov 2026 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhPcd+4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8881F000C9;
	Tue, 17 Nov 2026 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931070;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RhPcd+4kQzxYJUyHL4QqTcC/mqWMmmelF9omlJoWGbw1wLVeaSRAElXH2Pw+MC3XR
	 7lxQ/VKxAc3nxHY9WJI/SVJkhdmJfuMW06JJG4fqJEfWB7bHVUb+ZKJ+0PSCQCxEP9
	 uiF9Q9bxFvaWQA0TzHvhX9rel9pTthLmebVzd7RGVjO+DnP/cu6Aoi0GJc7Vf48ntM
	 NmFLuM2P0+L+Rd3eeTFHW1S3/dF/dVpVi+VACwsIsjHIVyW8FPY/kxhjHTQgE/9ojP
	 YAmzSLnZJQFSTOm/uIVLCQHKznu1ubz0L+j3C83rI3K5u1OWUSYjfcC0OW2nh9Ag+2
	 f1EH3xJytYJ4w==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 07/13] zloop: fix zone reporting consistency
Date: Wed, 18 Nov 2026 00:57:33 +0900
Message-ID: <20261117155739.304506-8-dlemoal@kernel.org>
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


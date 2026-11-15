Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754227;
	b=W0VMUl68mBxCggYffCFlf3CW7jOGYJoAyfaQ3VQSN1GX2I8sGMrRluQYdnAMB5EhUmtG
	 13rIxaqKTZHfLrB53Mug+rQHNEQwpL4Chl5/dcQQuYfZqOQE3OdqNFYeYMQtwU2M+45CS
	 2LW3wisdQcqPAe8jDU4Q0U2pxgr3HeVgIYo7tJwZQfKMOylp1itpL2ZWeBe+9BXi2iu6J
	 KFqR3PaiNPbTYTaHpAgs1DJDowcT0cNHUzra+T6/A7X0n0DjDv73Oqdht26dmQ+qiQyVD
	 UoJYf2HH5Le1hnf4FsJkVKMM+eygXSENLpm5AaUXaPT98WNrhAXmZzxKLlAL3XcaImg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754227;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=59mduTrrTNmjxfYqfdo58HA+Phqk1TOoLOeksdfgClQ=;
	b=HIHY4cP+/AkhisPxq9+Zowm2LnLgm8VJ57fZWswM/5nChsIr/eiCrBsFXc88HoLFPZ59
	 NygOSQkVwJHOP7UIvC+yLs6wTHoZOUIL5xlqwp4E0bMCqd9zPnWN73G86gvJPux7G5rt7
	 KLXKmtkegBMXM2+9yKt0E/GJVYVQ4gzG2KGyJ4PHArFOZ5+08uCnpKGYliUn+/XOK6deK
	 RgkwNhE9W9VdwBT3cRyz9BNZ3ruaNd7+CMrMXGHjL8jJrL9jyTHb4jaPq3lp/Swo2sSMI
	 /VTvwe5zmQUOeRKUR3UMYjftYrs4nSf65vE2xPu8Ba5u6eQwsNGeI5gFGJj5DOZIJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ds36VXeh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E37606A31A;
	Sun, 15 Nov 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ds36VXeh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5DF1F000C4;
	Sun, 15 Nov 2026 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754226;
	bh=59mduTrrTNmjxfYqfdo58HA+Phqk1TOoLOeksdfgClQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ds36VXehSnwur34hA8HqkbGvx9xBP0yoCezQ8o/7RJ8fczgzsaHtk30Cq9/piMDu+
	 bk3XVvGSlFAdJVwQuCctGCE65JlRUQjjhoXztbHcF8Wy61SzwsiUgxmnnsdx633hsQ
	 m0AfikBpKUWNqxg4sI+PB+mqU2m0tG1Lo9hOfqfpNcGISboAsNeTvr17GsVuxhzstJ
	 JQkhehVbqguWUoFxXUyy8OnS/jISPdn1I6eGE084tDOWKMZUGuV4demSxBf4u8Y0IX
	 BARk/AV7eeQu1lnawBcYSADaU4n89ArDpMEy4H5MQTL6HXmQKnqXj2NlkpBSmo5xVX
	 oNro8PxteXV5Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 07/13] zloop: fix zone reporting consistency
Date: Sun, 15 Nov 2026 23:50:09 +0900
Message-ID: <20261115145015.938426-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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
---
 drivers/block/zloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 7d98be66a3a8..a13937f3bf6b 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1001,8 +1001,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
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
2.56.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785617;
	b=QAEaXnzQB5rds/Et26Xe7G1/ClcKD3VOann1nvDie9TV17VK9Jd3rU8aXf5yLtIxWtGL
	 Lib2xkhVVTKcnRldT2m89yRe+V48XwJQE9pyW8YFu26yrvof9rTEC4YkBhfq0gBus+0BO
	 24MmSL0yIuy9qGpmVGA4tb5wpSwtZmBOIoGlBOSxqYhtgQEHY97WsaIwyplPhj+snlqkS
	 ntIn8sR7O2mDsCGFQL80ARmcg7V0aAAe57/G5LUEUJ6ijBtHHomdPz9GnAOgxIFPWbkt2
	 GKkQApQPfxUUcS41GjCdMnWpK4dRSmqZGDVR8zdGUYjrRyu5adfTx0LqdnPqtF1AZUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785617;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=G5YVQU6TomNxhFPfWOkS7sLIwi5OJ/jkEyrAtrT74bk=;
	b=vMC/Ib/SEePbNjmBYHoL03/Fr7Lr6SeltjIFauCDVtEM3NwnaIxNgaubdyjVPd9TmAVZ
	 VTaL1eV+6HuEu3LPAbnfnc/xq0CP5pBXCx1KENt8Zi4wWNM3r6MhzaHacSgY9/aRHWbG9
	 GVWY0kUlnMKPBCx7c++wMQzKKytTHk2SlrB4OEBmkLynlCpxEgjavLUvO3wg9V/Rngp4F
	 GZdpsdGj2PGZkd4+7ENSIJRzprai7KreG9OQJ4DhnE8aAPdPeaLDGbpPQQGUVstzSiSBq
	 drT02cg7zra4OG+Aad50OQr76kAPFVLeC/tC+aeHsUKYq4QRWl09EQvSfnuUi50s2IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jL6PJyXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0C606A339;
	Sun, 15 Nov 2026 23:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jL6PJyXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933D71F000C5;
	Sun, 15 Nov 2026 23:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785617;
	bh=G5YVQU6TomNxhFPfWOkS7sLIwi5OJ/jkEyrAtrT74bk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=jL6PJyXsg6bU/L6Finp1o62eQ+8F1aPrDtOerb2HyfWU+MTlDsphAB8AahHBNsmu5
	 tbHjep3txmNKYnUBdyRBeYcMQmQM1WLPsrIEvnfc/xDP7s7wKvsqOXEye/BsNly+xx
	 I3W5iC8HhDjW1r+SkyTEOd72vowzlDKEb8Z5OEU12btiHXrBua0Ej5esC6RLXe/T+p
	 iQoGOrOPJT/etKcJQ/V7OnYtKBkkblGf19FqROyw/l6IgFTz9dGO04aA65q13PA5nJ
	 cnag2zqZ4d+3jhaAHUtfFwjz9jXLOnTtLzaNEbbE3gsy22rj348TRJD+S0r5FnyLQl
	 4iWr3BbXUaVvA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 07/13] zloop: fix zone reporting consistency
Date: Mon, 16 Nov 2026 08:33:21 +0900
Message-ID: <20261115233327.941586-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
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
index 0cf67acf8096..bea62cd31668 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -952,8 +952,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
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


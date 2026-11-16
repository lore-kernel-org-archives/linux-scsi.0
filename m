Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865032;
	b=0rCKpW6FWsELZf6EFocsLe8dMo9WC/SXxotLxWQkRgs4+lwximY57dhdkeskE00ryKYD
	 7eNT8NFB7sMBnsCmdk5Ctbw+JrAMkpUFc9luqrumSENg9qgNgZzdA3EsuGthZMvJMtCLE
	 dky+NxJsi25l8YD9vMPXzh6Emt/40Xn4eKhZ8EuoZnCIUDd6jblKbyL+igea1tqiT+Drj
	 ikbnvPb5+G81va0pF/nGV3s4ARLpR5f4m7VEAB1ia9WZt3QAl4GmGBv04Yycc8KaWSyS2
	 aeJJXT0KfwryOsqs+pTz9kPCEmGv1THJSOy5PetxGRnF1Cb/8iaFtvHeWCrrYGyxhgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865032;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	b=jezxZVWrfisf+ZEuE6+cvrcvlIq0cekDhrOgEGYbO862nefiRM2D2tgarGKkcH1GtQee
	 qixwWAsc6ul+WuatLGAdRLpHNRypCvfqKUkyaO3nYkGaycu9mQ8qQAKOltyEmF4GIVhP2
	 iZYmIvYRRPdiyzyZLIwhH3YSDYGXSBfgg0FJrLs+JJ8pAcJM+fIYrlKsYEpSs5QchJmQl
	 g+Taf3Y3TXSF7w/HeUAX3OzTKCn2TliqobHD8A9URgEpfvCMQmsuiFTefEaB1vWbUs7Rd
	 sMdaxTERUKHFwADpy1DqY5TkwlfuBZYtqbmLJ4tP28qG8MX5/TxjDiM5mMU6q1F+zMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhjFbvlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5CD606A339;
	Mon, 16 Nov 2026 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhjFbvlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541211F000C4;
	Mon, 16 Nov 2026 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865032;
	bh=MEWUIA8EFD6426LiIW3WNwL+ZDOjXx3FCY1R8/PbnWs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=NhjFbvlMjkpUVmsDhoTiXs8jhPq9WVn0J31ZPb4ky+0gSmns/XpA3B4FdB4pVZjpf
	 pbFuuxX/inkg+1ABD53GvB+xBYifOZtvPGtxutc1sFDdO8P4ON9Ux15wuzmWEekwtd
	 E/Gjn+a3Dp++X1l1gQvcvbHDgzInOAVoAUwRHOuv0VRLgj8MzPY7sgrl7p0/RShk3X
	 vy7H9s2JBbHjPax0fnRGTwJILzR5FEpnWLQEVOXRxSJA0lrT4oGy3tZll1hbA7ob++
	 VT6uODE3NW6wR2p5DbnZeZHkN49OHvM/w4xqSHY0vHT158cn83A4D+CAbTkxRoYVB2
	 m7VyIQgxAqQlg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 07/13] zloop: fix zone reporting consistency
Date: Tue, 17 Nov 2026 06:36:56 +0900
Message-ID: <20261116213702.225970-8-dlemoal@kernel.org>
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


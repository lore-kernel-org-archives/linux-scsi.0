Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217913;
	b=cx9uSrgRGTFX4rZAzXo4j6BkR+7mxl84ehF6dj+actrWkYGQXGLPVc6UKlX3cJEkw+9y
	 yYUm591F8lEjBuRsrvqtd2uPCb9coYAP+dXhIEDqQ9OW3LFVsBjGK2a34XdU3vJbUwln/
	 qZrhS/lSoOk8MEKfwMYYNm7Ca8P1j9ofG4j69sE5EAUDIrTBvoyT/ak3vc+7TXAywQe6C
	 aDg3I9lA51+WkdoD7rN2KCzxgApPAAJTYiOuxA7sFmQzjJr7Qqy7vVxFGy0/VxiNU/daU
	 SYbhYpkTQHhTAzLfuqsQ3p0e7f3+29Xj0VnZvAsa7/fA05rjKhS9ExayKZHY8fPC8mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217913;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Va/edfja37W5dTqik19ZBuXUKHSQQ+xjtPp1G40xu94=;
	b=bADddXILjpb1qCsOybOb0RzvLxGkph8kp6wwpcng++oEH7JpAqqiHohD/Dw0QLBz4dMF
	 Fm5RUJfob2WE8AwJeZ6yESUdRvpwPr+hpaaQdANTDTj5s3j1xAwCBAoOh4kCg5kmTc4Rd
	 1sL92QfKfyqy2TgKlD2QxUxZaHxp8oAd8d2jV7pU8JZamKlESHx6RHEylr0Ndn4Z/G58C
	 mfK8aRdtVSLMjF3Vc+jkSyeAoOODvWNMR3l5zckty2EWLLyhtRtw+YHh4+pO/vs5exznC
	 7A0ZakBhHGJzvx5HqGRjqvZfYeUiXLKd3PhdRxPMUvN57mnYG0DbBDkwlxB5CX3M0/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWOtgaXw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD51606A331;
	Mon,  9 Nov 2026 09:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWOtgaXw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9462D1F008A4;
	Mon,  9 Nov 2026 09:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217913;
	bh=Va/edfja37W5dTqik19ZBuXUKHSQQ+xjtPp1G40xu94=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZWOtgaXwrDqF1VGQtn5GfurDfjXaP1rP5f69f+KqHisL6ai/yPNZbPOV9xZ8wEFHv
	 15wqr2ZkuA+fkP5sAh2rDAhqsoZjtT4Qu24TcJ2q41S39GtBxItC3WhEzdUo9iUz3y
	 fmzz25WkRQCXhFd/1Fqggnmj0lTC7t9daCRZ3bWlrccYY5pdcniEny9t6Vezs+tGjA
	 iZC3U3ahtPr0JS5KZeTbiSt+taTuC6VbqFxFg2pwTemmthn7QcPr0ZgctEg3hVYAg5
	 kTR159cy+eLp75PNT9MLD5dm18fqtfvL6fk2NQxxNsWqq0tviyHhIgba+wjHubLNgH
	 Jk0LezwGD5ZUg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 06/12] zloop: fix zone reporting consistency
Date: Mon,  9 Nov 2026 18:51:38 +0900
Message-ID: <20261109095144.819709-7-dlemoal@kernel.org>
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

In zloop_report_zones(), filling the write pointer and condition of a zone
descriptor separately outside of the zone wp_lock can lead to an
inconsistent zone report with a write pointer potentially not being
consistent with the condition being reported. Avoid such inconsistency by
filling both fields while holding the zone wp_lock.

Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/zloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 96666742523b..844a9f5db6a4 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -992,8 +992,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
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


Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB9207A22;
	Fri,  7 Nov 2025 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559634; cv=none; b=pQrN0lYoJoAvNab7X2e6tvvn7KFN35uMT5cf0IYueXRDbnbpaagiQZDx+0DKC+a/mugqCZTs+rodg6l39ZRgC+1GbDkKaTnH3bS0CIEHm4a/hiO7tqGImi0sSHXAfAOc5iS4fwlAGjH9bj6uONNgYKDog5C4c7DxEGZ5wwbUSJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559634; c=relaxed/simple;
	bh=2UEc+9eGsDDndUsVoGewLqpwT3F+JTLNmHWfTARAIBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDjQc92dcFWYQKTtryMUlPjWL8smlrqGf1q9qRX1VjTlCRMXVrq8fA3T8QVLJu6OzRT3BUrHfm5rgOYyoWwM2EDP83LWtUmXnBmUwZJHPWeJx/3ngIwkhYgCVbpjownZ3jmlswia+PU0LhNver1lYpX1xDvnpQ/by91/LQLqfZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DFM2Wqsc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DFM2Wqsc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9X2mh4zm17wV;
	Fri,  7 Nov 2025 23:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559631; x=1765151632; bh=+2+gH
	JaWQ1JbAaqME7oi3qPIYzK10pq4689DyyZ9pAA=; b=DFM2Wqsc5d1xOYMAXO+FF
	M0olXKKyAJRkpwYWqPdIw9zYnmA1fBQINmiSHIJfWcWPGqtOYcd7Xfv64QeD+FP2
	+FvsVVje0JTjUmbDzQK4yHdNC9ACFcTgAcutD6YL9sT97O+k5eOP75FrsdvREwgT
	VPoAJeb+GVP1/r+GQn0QwcgY76p50LOxxSgZGKSS5vGxMqf7UodNGowsKGgsC056
	e/Runqb2e+ORBGn2C3lu0yaHj5zEJZTt93KSYMYI7ROCAEDBmg1LTm3RQ4/EWTZj
	0pSOlvUA/eseM+f5bUPpTXIPduGaAXWoQimYgeuXc9zr9bcCur2NVyWO8tybqC4w
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z_mnzoY2aFWh; Fri,  7 Nov 2025 23:53:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9R0wHBzm17wt;
	Fri,  7 Nov 2025 23:53:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 05/17] blk-zoned: Fix a typo in a source code comment
Date: Fri,  7 Nov 2025 15:52:58 -0800
Message-ID: <20251107235310.2098676-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Remove a superfluous parenthesis that was introduced by commit fa8555630b=
32
("blk-zoned: Improve the queue reference count strategy documentation").

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3791755bc6ad..57ab2b365c2d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -730,7 +730,7 @@ static inline void blk_zone_wplug_bio_io_error(struct=
 blk_zone_wplug *zwplug,
 	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 	bio_io_error(bio);
 	disk_put_zone_wplug(zwplug);
-	/* Drop the reference taken by disk_zone_wplug_add_bio(() */
+	/* Drop the reference taken by disk_zone_wplug_add_bio(). */
 	blk_queue_exit(q);
 }
=20

Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821231AAC4;
	Tue, 19 Nov 2024 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976116; cv=none; b=nLU5jFqHumVHnBH0wHQXdTh+Dw697XDitju+41UGt8EslI47vfMPqVVYo7sJdkSqW8R3UjslEtX4bB58dDBgv79GnYb2FTvBcjLaII7DZ7eV9FjzZaB3kVzGBQsrfSsrGNJKRhgRv/srA98IwpLNyYzPXFD8zurguKcVjonWrwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976116; c=relaxed/simple;
	bh=Bh5/UK4HYerQo8SKIvp0FyEnvJpwkWV1/JntUGWwrZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gos4t/kclqhLJyBNhjCHpz1xtZmtAQGACF7A+4W94FWE/sVL3IWCzB8vXEhfko25/x9ZsiJBfZli7laT5ec3qWI17ksZF+umDXYVL+hWgdRca1wsTam0D7d4ersGnq3+OGA3QXfyyDhW1+dJl/jG+kT9Kq+0n/yPFcRdfZDumfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=f2R/m5Aj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="f2R/m5Aj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslhx5GwkzlgT1K;
	Tue, 19 Nov 2024 00:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976111; x=1734568112; bh=hBVx3
	Uq/JzR2vP6uuT26+jeD5kDe4DFlRoEVPfAYVNo=; b=f2R/m5Aj8Fxa3P9hoyZs7
	20+xFMaFY+oUcuxm12PM44O8BBAzz2VBEewcyk7y2fUu2qxehJs6KlHHmY1jBRb5
	K3DQc9PHT87Q8msuL+jEKXulcrpbE2rJ25Jm95juBQe+8zTbZTItMgioyljMd5MJ
	eJyh2mCBC3Je1iWHQydN1TauGH98+PxkJ/82S0x6RVwcMX6VXdde/tOhISaLRFI0
	w6P+QqQUoBEjtwBHslG0dV5QBw4+tSylwGYr6B/LL33ofShh1er5tQNjnI/gjKdj
	jzF/QyY+4fEWQ8thfc0jdf0TZ29yT6rnuz1mBdsQ7Po/fRsdeS+WrrvTZs8q6rAU
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fwipjbrtLXOb; Tue, 19 Nov 2024 00:28:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslhs5tYPzlgVXv;
	Tue, 19 Nov 2024 00:28:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 01/26] blk-zoned: Fix a reference count leak
Date: Mon, 18 Nov 2024 16:27:50 -0800
Message-ID: <20241119002815.600608-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fix a reference count leak in disk_zone_wplug_handle_error()

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 70211751df16..3346b8c53605 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1337,6 +1337,8 @@ static void disk_zone_wplug_handle_error(struct gen=
disk *disk,
=20
 unlock:
 	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	disk_put_zone_wplug(zwplug);
 }
=20
 static void disk_zone_wplugs_work(struct work_struct *work)

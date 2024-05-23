Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F948249B;
	Thu, 23 May 2024 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488789; cv=none; b=pfUIOpaWpOshWxiSgmOgXHVPuA6k0dJp+BaXk5vipuvbDE4ku9wKECT30ooC9s+yZQGa+bZfur4eneYLsZnH9yJD68K5dvfgK8hSp1JNY+KmZVx4uEsdGp1GkCy3umLaMMNLy3zHnD+vhP/hHLggds9ZaaGB/a223ujZ9a6V9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488789; c=relaxed/simple;
	bh=IOkWiMnDt/vONLOUhmoFD8wkAV+/WO7NkiKdKh6jeJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX33/J6iLS978mkjYrw/qp5Unes3ZVJSG2xepkbZqKqaRi8v4byajJnfAQVWPnF3aBRmG/Wd3twr0jfl33aPIVSnZ/MK/OtCdrAwTzO8Fco03KqcvgVB3zEgRvAJrIlX4RJcGgBW52L86ObqRtZslmlL41MSN0+9rscxe1GSw2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MQEBpOTj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MQEBpOTj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+NJbVWZoMjCNg5EZX2uy6cwmNS5mpHax/WJICDKj+wY=; b=MQEBpOTjikS5eyOqMtazIGLqWf
	g6ANym3fgQjECY4EDwGDyRljLdmAd2OPOi6G+KOTMgGFaewJNySyaZRy0du/uB5nKCb4yBN9bjWs8
	Zp9XAU9V0EqVHkwEFxDqb1IlTPE58BEc3/IUUQUG/knYS4jwN9wBtKOzdM7eL0229T3xb7bV1CNnt
	g35MHQQdEYQDqiDTByHzMcWcq4k9qYbhumxe0fYkx8FVaGFcRbHVrogZ9pqt6VG808AGW/q+MXYtD
	8G4AoA/DrdVwCt9wr9joofOtad++iBVKfFKJtFnpnPstKcQAE2iKsEsDEtfLcxbsCo9fGGED13Jrd
	g9oGfhtg==;
Received: from [2001:4bb8:2d0:ea45:284:cf8f:6784:4c64] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAD90-000000070qw-0nrj;
	Thu, 23 May 2024 18:26:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] sd: also set max_user_sectors when setting max_sectors
Date: Thu, 23 May 2024 20:26:13 +0200
Message-ID: <20240523182618.602003-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240523182618.602003-1-hch@lst.de>
References: <20240523182618.602003-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

sd can set a max_sectors value that is lower than the max_hw_sectors
limit based on the block limits VPD page.   While this is rather unusual,
it used to work until the max_user_sectors field was split out to cleanly
deal with conflicting hardware and user limits when the hardware limit
changes.  Also set max_user_sectors to ensure the limit can properly be
stacked.

Fixes: 4f563a64732d ("block: add a max_user_discard_sectors queue limit")
Reported-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 332eb9dac22d91..f6c822c9cbd2d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->first_scan ||
 	    q->limits.max_sectors > q->limits.max_dev_sectors ||
-	    q->limits.max_sectors > q->limits.max_hw_sectors)
+	    q->limits.max_sectors > q->limits.max_hw_sectors) {
 		q->limits.max_sectors = rw_max;
+		q->limits.max_user_sectors = rw_max;
+	}
 
 	sdkp->first_scan = 0;
 
-- 
2.43.0


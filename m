Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEE9768EA;
	Fri, 31 May 2024 07:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141753; cv=none; b=R2en13/bU3XvQkm2JMwpH2lST8kFFewMcnK4IEDIjOYG6BANUpFSzwBKylkPc04PebvinIA9T/5eIPBcSVW1e1Azp/wRwKMDkm6xHF0k/L9vewfrjVS/BowPt3LRMXJMj6RYbTWpbQ9sDJYqtYwJkRnPSturLE+oAdwvKBcvgvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141753; c=relaxed/simple;
	bh=VeoBC+ZyGhvAObHuWDXL8ya+YIxg1lSxMLlNDY3pwk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIIsgJwbxyXqwk/Y/58+gUhh4MsGNYwhVeJg8epCRv8gLhZS2hZ3DbFgnVgHXkc7En+jhB70fBBi5ZQzgM1dCJCMcfFeUl1mFC6yk3cKHTUy5DWIfTgrbO1BXUP3Sdi/SAZwRYhsjt+pTlnrASkzVo0zs9LqpB0oBZg7URX7vM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ixc7sU02; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ixc7sU02"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rb1OF73CoqNaiVO8CqTHVc8xH4T7Xk6a2c9CxacCVxo=; b=ixc7sU02vm0CYaeNZLVqmJqr1F
	w3t3CHukX6Y/WrwEBPmir631IGBTKvdXkr3Gx7sPqVqokxqFFVlywpqEW1Ike10ParnnBt1UYNr5g
	oxfWZdjBwiqVCxtSkH5LykBrDs6zXobZzMgztC7hMbwDnMSYlJqmNgh8Q9kC05ZfeL1SBTCNAFVWE
	+8sLD6+qG9QyI/eL8OKGy0oMy9FUSqpJQy2NiOWqYRZmyBUvVUNO6Lvocvevg3GFFr1HQvo+FKyWO
	zjfg3D4GZ3IuWhl7HByairPmkUxGxODsK90DtnOBsC9OwFCM9RkfiY/ajKZ3KzidolhxQDvM0BqsD
	2Z40FzGQ==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0c-00000009Xgz-3ZvO;
	Fri, 31 May 2024 07:49:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 09/14] sd: factor out a sd_discard_mode helper
Date: Fri, 31 May 2024 09:48:04 +0200
Message-ID: <20240531074837.1648501-10-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the logic to pick the right discard mode into a little helper
to prepare for further changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0dbc6eb7a7cac3..39eddfac09ef8f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3201,6 +3201,25 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	return;
 }
 
+static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
+{
+	if (!sdkp->lbpvpd) {
+		/* LBP VPD page not provided */
+		if (sdkp->max_unmap_blocks)
+			return SD_LBP_UNMAP;
+		return SD_LBP_WS16;
+	}
+
+	/* LBP VPD page tells us what to use */
+	if (sdkp->lbpu && sdkp->max_unmap_blocks)
+		return SD_LBP_UNMAP;
+	if (sdkp->lbpws)
+		return SD_LBP_WS16;
+	if (sdkp->lbpws10)
+		return SD_LBP_WS10;
+	return SD_LBP_DISABLE;
+}
+
 /**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
  * @sdkp: disk to query
@@ -3239,23 +3258,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
-		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
-
-			if (sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else
-				sd_config_discard(sdkp, SD_LBP_WS16);
-
-		} else {	/* LBP VPD page tells us what to use */
-			if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else if (sdkp->lbpws)
-				sd_config_discard(sdkp, SD_LBP_WS16);
-			else if (sdkp->lbpws10)
-				sd_config_discard(sdkp, SD_LBP_WS10);
-			else
-				sd_config_discard(sdkp, SD_LBP_DISABLE);
-		}
+		sd_config_discard(sdkp, sd_discard_mode(sdkp));
 	}
 
  out:
-- 
2.43.0


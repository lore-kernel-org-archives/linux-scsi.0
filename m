Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653635244;
	Thu, 28 Dec 2023 07:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pYVw9iWI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OxBUl5R3EwjwockHF3eENF9Jxp82TA96jdI6BZ6Pk2Q=; b=pYVw9iWIwpmXmn6vVt1FtMEov4
	b4FXtLsDdTJ/SIWMBXq2Yja+oGm+pFQhsROV42VP5o8oRTS6qzGm3NczSSz7ftjdn1RqnXL4HFzMg
	b0AQasvUGNNoiy49kTVXTDaaBU++1IM+x6RXLdaEWdW1ZSVzo1IIRl7Hd2klM5KaAsVTLG0d5PQsq
	+NgbAJoAQR6474A3ucHxFuu8LYgM5KF3pk1C+Mjwbfh80NLn/O+KNQFyEaLsdUtODvzKbpKGxFUoj
	K/GyuRnITJkfp82dzfg8pTHxaINjhzpftPrt/Nz/vFGtAFqT77vuFwN4IKgNPRlOpfMxjtpsxxuh+
	ovcyxggA==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlBJ-00GMgc-18;
	Thu, 28 Dec 2023 07:51:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] sd: remove the !ZBC && blk_queue_is_zoned case in sd_read_block_characteristics
Date: Thu, 28 Dec 2023 07:51:40 +0000
Message-Id: <20231228075141.362560-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228075141.362560-1-hch@lst.de>
References: <20231228075141.362560-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that host-aware devices are always treated as conventional this case
can't happen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6bedd2d5298f6d..dace4aa8e3534d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3149,12 +3149,11 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		 * the device physical block size.
 		 */
 		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
-	} else if (blk_queue_is_zoned(q)) {
+	} else {
 		/*
-		 * Anything else.  This includes host-aware device that we treat
-		 * as conventional.
+		 * Host-aware devices are treated as conventional.
 		 */
-		disk_clear_zoned(sdkp->disk);
+		WARN_ON_ONCE(blk_queue_is_zoned(q));
 	}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-- 
2.39.2


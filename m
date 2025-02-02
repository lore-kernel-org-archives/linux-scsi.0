Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0ED2111;
	Sun,  2 Feb 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738510097; cv=none; b=uKCaThcQ1qheXPhip3jUECeWiMUUvk0pxYTQIuGYvRbrR7/Un8m+yPBBzZKx203wbOalgX49zxUbmEHU5NAq7MJIOQSyhTLZ7pNs0zniVH1cNf92Ml9yf9M4/CGHwBVXK7IxMRRqdMW7RClJkTkGruIXvjQS4l+a6Nw9tHz1/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738510097; c=relaxed/simple;
	bh=NiL5ybeg1iOfvaf9F+4eTDRpOdS3ULOG8KdSOcoAd3A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Q495uXy45IWT0sNqQeyoozyDgS4HyUbCyZqtwW6UJNKexfKM9Dawm5buubTyths1Nc3H96zKTUGB+4sV86f9WNf10dF/RhSg2VbLDdWfRN4ZaslGNCwn9yFehQJAY9Z3VkZWZSGvjPwfNIlKw2lt1dIVUzEYMhTXHFAHBokIIss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ulyGTsRE; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ulyGTsRE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1738510095; x=1770046095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yw2P6wdO/necDRS/+3zlk6PNM25jDdpqFoPzBZuSPyA=;
  b=ulyGTsREIZnYBiyLk0HFIIO24FHJuXZ6MUmY5SrzH9Wh2QnoiUfvSaen
   2SKEwj5YvzZgUjBl6G3RiNxcLrnGgaF1w0QPG9yRrXIstsJoGJ7opnCWM
   io7MgleL+GJnIIJdFFgyBxQ/MXFoqrEIp4DZtdnHu0pbotqJgQzhsBwAe
   k=;
X-IronPort-AV: E=Sophos;i="6.13,254,1732579200"; 
   d="scan'208";a="405301952"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2025 15:28:10 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:26186]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.183:2525] with esmtp (Farcaster)
 id f9b9310c-ea39-4660-aba9-b55597eaea3e; Sun, 2 Feb 2025 15:28:09 +0000 (UTC)
X-Farcaster-Flow-ID: f9b9310c-ea39-4660-aba9-b55597eaea3e
Received: from EX19D003ANC003.ant.amazon.com (10.37.240.197) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 15:28:07 +0000
Received: from b0be8375a521.amazon.com (10.37.244.8) by
 EX19D003ANC003.ant.amazon.com (10.37.240.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 15:28:04 +0000
From: Kohei Enju <enjuk@amazon.com>
To: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, Kohei Enju
	<kohei.enju@gmail.com>, Kohei Enju <enjuk@amazon.com>
Subject: [PATCH v2] scsi: target: Remove unnecessary null checking for bio allocation
Date: Mon, 3 Feb 2025 00:27:53 +0900
Message-ID: <20250202152753.22685-1-enjuk@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D003ANC003.ant.amazon.com (10.37.240.197)

Remove unnecessary null checking because bio_alloc_bioset() is
guaranteed to succeed with __GFP_DIRECT_RECLAIM (included in GFP_NOIO).
For more details, please see the comment in bio_alloc_bioset().

Signed-off-by: Kohei Enju <enjuk@amazon.com>
---
v1: https://lore.kernel.org/target-devel/20250202090208.26890-1-enjuk@amazon.com/T/#u
v1->v2:
 * Fix the commit message to use imperative mood
 * Remove the unnecessary blank line
---
 drivers/target/target_core_iblock.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c8dc92a7d63e..a53e41212cdd 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -369,11 +369,6 @@ static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
 	 */
 	bio = bio_alloc_bioset(ib_dev->ibd_bd, bio_max_segs(sg_num), opf,
 			       GFP_NOIO, &ib_dev->ibd_bio_set);
-	if (!bio) {
-		pr_err("Unable to allocate memory for bio\n");
-		return NULL;
-	}
-
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
-- 
2.39.5 (Apple Git-154)


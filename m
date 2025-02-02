Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4C32F3B;
	Sun,  2 Feb 2025 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738486947; cv=none; b=qUcdOHdIFuTEfPHQEOuZNGESoaL4UxsG9x/j9CMm8uCcyUNXYTW5sgxUYLIioLDoTxpMBMVzX+qTy2hr1+34Rb8iO27WvHkgrPlLH5Kb54p7w6LwHHJlg3YHf9F1OstmMYZK1iUOl3e7XgVFjEqBYj4dmVO6+97eaFLQn/s39aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738486947; c=relaxed/simple;
	bh=nD4kaYdBysHGMqyO+DYxF+ZInYqK5Sv6MZqCmZ5KplI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zy2gdc/3ARezf8TS5XpdxQSUKNKIPP82MYD4nLVwXlRcrgdl4Dq8GWFAxmfCuZwtHGkbioIyAFy1OU4HnR10KSbn2anXdnPBKFSioalEVVfx++GtTvEf3aF9HaNmxwzMIt3vzOLjD3H1aSlzAQ8jtg32cyY6PSV1k3uZOBNVWGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=nDHDDswp; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nDHDDswp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1738486946; x=1770022946;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j7BC454znfGK+YxC1sObQa0ZrTdrnrk7q5MLNC7JmeM=;
  b=nDHDDswpD9cKWteiSFrFKgNzdeMeCCq9ofEh0ImsKlsCLTIvRS1OTBLM
   GUkOHcLkgHPilrVYUIJdXecxOkuQzx3I7AkObkveGsCEynabEDRic79c+
   WVFGmQKSULRzp22cv4zzc62OiVrPD4zEnOMuRj35ADNMcjYhtPlwP5D3L
   E=;
X-IronPort-AV: E=Sophos;i="6.13,253,1732579200"; 
   d="scan'208";a="715364577"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2025 09:02:23 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.7.35:26257]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.183:2525] with esmtp (Farcaster)
 id de94db05-fdca-43eb-9475-bc8a3af49cee; Sun, 2 Feb 2025 09:02:21 +0000 (UTC)
X-Farcaster-Flow-ID: de94db05-fdca-43eb-9475-bc8a3af49cee
Received: from EX19D003ANC003.ant.amazon.com (10.37.240.197) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 09:02:21 +0000
Received: from b0be8375a521.amazon.com (10.37.244.8) by
 EX19D003ANC003.ant.amazon.com (10.37.240.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Sun, 2 Feb 2025 09:02:18 +0000
From: Kohei Enju <enjuk@amazon.com>
To: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, Kohei Enju
	<kohei.enju@gmail.com>, Kohei Enju <enjuk@amazon.com>
Subject: [PATCH v1] scsi: target: remove unnecessary null checking for bio allocation
Date: Sun, 2 Feb 2025 18:02:08 +0900
Message-ID: <20250202090208.26890-1-enjuk@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWA002.ant.amazon.com (10.13.139.12) To
 EX19D003ANC003.ant.amazon.com (10.37.240.197)

When __GFP_DIRECT_RECLAIM (included in GFP_NOIO) is specified,
bio_alloc_bioset() never fails to allocate a bio. For more details, see
the comment in bio_alloc_bioset() in block/bio.c

Signed-off-by: Kohei Enju <enjuk@amazon.com>
---
 drivers/target/target_core_iblock.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c8dc92a7d63e..9ef23eea55e7 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -369,10 +369,6 @@ static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
 	 */
 	bio = bio_alloc_bioset(ib_dev->ibd_bd, bio_max_segs(sg_num), opf,
 			       GFP_NOIO, &ib_dev->ibd_bio_set);
-	if (!bio) {
-		pr_err("Unable to allocate memory for bio\n");
-		return NULL;
-	}
 
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
-- 
2.39.5 (Apple Git-154)


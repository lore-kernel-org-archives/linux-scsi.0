Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B6CC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64ABC60235
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhA1Euz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:50:55 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21969 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhA1Eus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:50:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809448; x=1643345448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AS28SYb5q1dU4ktJHvnVMu02oMpGHGEKFN6I8l7eXCY=;
  b=ZEb189+44cXfqrzJPfs74wYDlphEkleFnxxkICu0zkdYvWnYPkEXH4J0
   5N/CHHuXncSrbDt0Ixp6tY01e2vlVbslUnOk2732nqi02NYYVUFJZdMIk
   7SWzF8nfoYhfIM3zh0sX044qrDEIiNCaF7qO78SsjLfChZ0HvpPPvX47n
   R1kSJJmdJJ4GwdJdSvQN6ey4FUpODccZ4Itm1eXd8Jwls8zFygQFOoIMj
   Z8vJCMGu7ZG7CUNPr0/ZtRfrkDfpx7iZ0VWr+wb107Mxg23VpeK13fzKW
   rVqG/gYUAmR9sseuR/gQ9wPynRxMho7JbFkZ3xyhO3CFRdJ5L2URqzd+I
   A==;
IronPort-SDR: v6uV6cOLpUvbVzNWjf4tCDoGM6cTbDjr6oaqbbR5JIA2z0Wg0owo1KzGWgYr/KSTwN6LcSVWRH
 XyZ0uCBQSMY3PyNW4LZSqEU4pUe6o70hMKoxBpgWi8ZWDD/Jfv8d6mpdwN9izuUE+a8uDQHb2Q
 GEJObIedxq1NxUA242NSvzO9ykfIrPOem9XKwNa3suWnh2K/q9vP80uVSTiBtPqO5rUyhWbatd
 N4dW4iBf0wZJmw15EJa5tPoABpe16ooRuTqxgpIWhQUVmQCD+UlN0nkyoC+8DuyonDfAkMKzLA
 NqI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509141"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:45 +0800
IronPort-SDR: uqaKiiVCg8znjzm8bGqDB1xyXEhDT/pXTZq9jkekh4aTDRmJSquqvgCefBrpvORZr1JMr+TqPY
 KwyWglknbB8Dc5C2KqnjYsGQZp11JcZ8Iv1crlacauRNONc2CnBJ69WCS06mRh9azh2L3pb0dN
 jT0yxTeSmB46S6F6DiHufiBG+pfr65JhX9QWQTRy2d8+E2KtBnWYp5Es8IOH8qnIlIV+EUbN4u
 S3VAFOQrPfe3nU3v8c+mUd6cAp/5cY9slG+Ht9K9r97wJ/q1hYRyC2CUHlKclOnG4fvXf5vT7g
 iUxt8QCaQsoJD9m6xrHUWflh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:30:03 -0800
IronPort-SDR: Ih/EIXJQ+gm7gzO0vYm/RUmL/N2knyTj+4YQH3D2SEHcGrwcmtNZQxBVXi3nTLGXND293dX5dv
 3osTAZVlmO9JfrAPv/Bi40zkDPS7XHJmLbju+yPgWStmacadE7vXXBeqMt1lbcBZbPsHZBOCPL
 64LZrURWEW/UJWwRiU8cDrOw9VAqjAVlcSRnYCpzIJ/xcYXUHx4BYVRG2jEobNX+4tyWDmibgG
 e5XXPyMCMYMmFDTW1lJajFjyLc8xgiP8wDEbhRw5HIRYhra0VLM/LlE0fSOWYrKFp9pPsFoH5R
 hec=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:44 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 6/8] zonefs: use zone write granularity as block size
Date:   Thu, 28 Jan 2021 13:47:31 +0900
Message-Id: <20210128044733.503606-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zoned block devices have different granularity constraints for write
operations into sequential zones. E.g. ZBC and ZAC devices require that
writes be aligned to the device physical block size while NVMe ZNS
devices allow logical block size aligned write operations. To correctly
handle such difference, use the device zone write granularity limit to
set the block size of a zonefs volume, thus allowing the smallest
possible write unit for all zoned device types.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/zonefs/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index ab68e27bb322..b9fb55b250ae 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1581,12 +1581,11 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran	= 1;
 
 	/*
-	 * The block size is set to the device physical sector size to ensure
-	 * that write operations on 512e devices (512B logical block and 4KB
-	 * physical block) are always aligned to the device physical blocks,
-	 * as mandated by the ZBC/ZAC specifications.
+	 * The block size is set to the device zone write granularity to ensure
+	 * that write operations are always aligned according to the device
+	 * interface constraints.
 	 */
-	sb_set_blocksize(sb, bdev_physical_block_size(sb->s_bdev));
+	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
 	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
-- 
2.29.2


Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F183C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 13:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3246320740
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 13:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKONTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 08:19:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727249AbfKONTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 08:19:54 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 48828598D73E8012590F;
        Fri, 15 Nov 2019 21:19:51 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Fri, 15 Nov 2019 21:19:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] scsi: sd_zbc: Remove set but not used variable 'buflen'
Date:   Fri, 15 Nov 2019 13:18:29 +0000
Message-ID: <20191115131829.162946-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/sd_zbc.c: In function 'sd_zbc_check_zones':
drivers/scsi/sd_zbc.c:341:9: warning:
 variable 'buflen' set but not used [-Wunused-but-set-variable]

It is not used since commit d9dd73087a8b ("block: Enhance
blk_revalidate_disk_zones()")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/sd_zbc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 23281825ec38..0e5ede48f045 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -338,7 +338,6 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 			      u32 *zblocks)
 {
-	size_t buflen;
 	u64 zone_blocks = 0;
 	sector_t max_lba;
 	unsigned char *rec;
@@ -363,7 +362,6 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	}
 
 	/* Parse REPORT ZONES header */
-	buflen = min_t(size_t, get_unaligned_be32(&buf[0]) + 64, SD_BUF_SIZE);
 	rec = buf + 64;
 	zone_blocks = get_unaligned_be64(&rec[8]);
 	if (!zone_blocks || !is_power_of_2(zone_blocks)) {




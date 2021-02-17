Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1264C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 13:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665CE64E58
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 13:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhBQNyB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 08:54:01 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38411 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbhBQNx6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 08:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613570037; x=1645106037;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9PNjJH8NX5qan4FfUnuDAvbdor8Cdj82IDbllV6pW5Q=;
  b=I/Ju4tzMiB33ygolWKz28RmZFEnc0lly+Sd+GWbTOWKuDZeRZZpbywaz
   gsnw7ZP7qGm2k22LUOoDbN4WS2y03VH1Spb9oSjMJnmDhli6huWr52be1
   ObMQLqz3/0vn4cGauaouZ1MD2GYDEwTV9dtrRe3B12h4GRs4IzgWyNiHH
   kwD9DH792DWxZJBXt5WpR49NZ/f8vmvEMDwZsDKHGgwuPVO+MwDOyoF+v
   hIjvDFLXsxXyaFGyGdAR8cXcc+GCAuxtTmm8+4S8eKMrZKF6t7Z38/udB
   NVOaeTVrejTgimPlvjKkNEmtx7p8XrDvQBmdqlkL9VjPDi8I6rHRQCfbH
   A==;
IronPort-SDR: NU6heZ09+++HnStuJhaNlqCgMKoCXU+VOct+nL5XI4sVmEkPzZq2EiyRu9FxjSjpuwo6qjDcan
 Lr9T6AmTwhG+Ln2DoiSfm+wMtAkheQ3fwu6DrXRAMEKcPWj5RYXBojNlGG7SUOagr/FcK/BoQE
 dVfOS3G5i8aFmEjydKMHsUHfV5/l7FutRv8Y27ch7bdX+T0pRlqdF85SOwEh/7n5oU4hwLmY4w
 K95adXo4dJdwbVgOrET5qiWJNxAatM5S6PHxstCP4UzRkluGos4+dM2tIfwT41I+ie9I6gOBe2
 slk=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="160156559"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 21:52:50 +0800
IronPort-SDR: FqJGizxJXN2cfqSCp1qmEGBMhOnb6uQZ4uZ9sXSIew+Qsmo0XPG8SUl1QRX7T6druJxHJ+5DcU
 bPovWx3AmFeQIm4ea6fZhCRnpdxAQ4h/XSSbbIx31g6njfYH7qWAvqwDcu4eVVlwxBVE7Vk5sC
 TzT6R6ZOmw6haIigGOaoe2ipiNGSrWADw+EX/o2VNZ47faG9tHaqWMu+ofOPsQW3pUlmfhGUHs
 b/yCk8zV44G//WWOZdwOdwS/gNeaY+RXv82ynmLlr4gTCrtbrChU1TthcBorV/RpGY40bjDxpI
 dyh3OKqXrPfvlxfNjKxbUfIh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 05:34:35 -0800
IronPort-SDR: 4nAZBiHIa5K4DZjgjGiVDvRW5C8kb6ZKKIo+o9C5uvKO1xlMkOB/vH//TtFnLI02lJ+7BCZyOy
 ULFj7A2m07uywirZo6pCWlXMwy/nSjcMucrNVfq4pP2cYkgsoTut05A35fkL446Ns60noO+lF7
 gv/EMS1V2noFL746T3TmWx5NLqUNdo4KEF7R5JO07gQBeQxDBo7ZT9XeQz2BQj3c/AKWedwOcS
 7yV/Am2aPth7V+8gmv7Ank1O1f3F1P6hRf4YA/AyYKad0sS2HCj0ofGOLk4erql/ZTULOmTfqo
 paM=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Feb 2021 05:52:49 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "martin . petersen @ oracle . com" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: [PATCH] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
Date:   Wed, 17 Feb 2021 22:52:45 +0900
Message-Id: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dan reported we're passing in GFP_NOIO to kvmalloc() which will then
fallback to doing kmalloc() instead of an optional vmalloc() if the size
exceeds kmalloc()s limits. This will break with drives that have zone
numbers exceeding PAGE_SIZE/sizeof(u32).

Instead of passing in GFP_NOIO, enter an implicit GFP_NOIO allocation
scope.

Link: https://lore.kernel.org/r/YCuvSfKw4qEQBr/t@mwanda
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Fixes: 5795eb443060: ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index cf07b7f93579..87a7274e4632 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -688,6 +688,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	unsigned int nr_zones = sdkp->rev_nr_zones;
 	u32 max_append;
 	int ret = 0;
+	unsigned int flags;
 
 	/*
 	 * For all zoned disks, initialize zone append emulation data if not
@@ -720,16 +721,19 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	    disk->queue->nr_zones == nr_zones)
 		goto unlock;
 
+	flags = memalloc_noio_save();
 	sdkp->zone_blocks = zone_blocks;
 	sdkp->nr_zones = nr_zones;
-	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);
+	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
 	if (!sdkp->rev_wp_offset) {
 		ret = -ENOMEM;
+		memalloc_noio_restore(flags);
 		goto unlock;
 	}
 
 	ret = blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);
 
+	memalloc_noio_restore(flags);
 	kvfree(sdkp->rev_wp_offset);
 	sdkp->rev_wp_offset = NULL;
 
-- 
2.30.0


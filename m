Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0B6C17442
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D21322067B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lkmG9Ghj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKCjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:46 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfKKCjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439986; x=1604975986;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=bpIGBElxsl0fjSxZjNS/ZKnF4nvJx57BXQeH1ukfHDw=;
  b=lkmG9GhjtD9D9E3codvGlxX9XGo/sms1+XwvmgndovJwVWhK+VJcbaBV
   84ZqObTfS1d8md2CJfjTibckYL9ftbhDNTk7+ak/TRPEyB4dEuVXVel7o
   cqT0ax5+R8c6BbwYvzYuHHh1EJz7AXOOFXEh5MCSpnfUrL7vNJGJ/Wruh
   OBR1u6WiVYaVleMBQ/nBJRmcpMlmRyULFkBMpJFqI8VHTsID18nkGfmbx
   GVxOSGL5ZSgNMJPVdJjB2mNUTCmPjRazF2FEgkz+wqwpiPG7O4MRP2g2U
   lktPSrhe1rVh6eHDvP2lWaK5gY75Z6mv3pks9tyapVkQLXohyfjtzmz+W
   Q==;
IronPort-SDR: VTV7oBSxCraEInY9C3Mr+DNx6tMnDDVfJ/11oLDjLpV7edL/PJIqGH0CjAXpMq0xtVI8/X7/xp
 hru/QXkBlP2qhcJ03V71VpInpiJhqNWbehUUA21BVMWAxqJYoy0dFUtiPxK/bRpYKb2MCuZKFT
 Kc6drPvdoEcoEyxQoDio/7hF+Nyvhf0VJ9jllQMsqXZOTVhdAafqeF8vpY9DzKv2aiuUSgAh6K
 HtlBIdDFOlcC4EGRH9a9jpmHXc9G1sSXXYkXPuC4X4MdwcumFgZzW9US5j4XyBl8z67cU8+qwn
 cTY=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062983"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:46 +0800
IronPort-SDR: WPN/zGsraGkYrJ9eU3LNeH97TInzidMcBnG+TogpwpTbt3Vn3hrTAlvtvICvxHMXj2ztoSqNyW
 UR8ANGl4s5MWzAynn/VquC9bLVQu/bTtJrYrIMTdJrRHp4H8T7Bu7Rt6LHd9aJqogdRvfFJjWt
 2m0I1WTQakWaYASIrJMl6LYWWOWkh8gVL0qud+ay2TmgDLteGC9simks/Q/7+k7ick2yElTQqo
 mKLxK6XvCS4d9vZsiVkX9LeoZG9oJ57XW/JiXwQD4BvID06MihctGG042/i4a/qcMg3atZTtdK
 oTf5Jh0rgWVbfYAoK8nYhJPm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:51 -0800
IronPort-SDR: d26YsSQ5WsgX0IMpopyKqryqzsAOLpcKOoJ2xbrC9TC0FnQgPCTQe7zeg6q06lZ8pNRHBKuQ7s
 5TE96C5OXVFDXE/+AZmA82Y6G1fOMeS83me1ZR0vzCoSjwg+nWzv33CLcEvQoW9W90j3QZtO0I
 cv/Ps1TEZ+32UGA3y2kyRVxggtfLPM9TBjUv08jRX/PUace73jULqDKhykdlOGtnibsh+1O73H
 Z7msO/3h3ePoSqFMRZQ4iPq5DDX9gukcQL6g+MvEi9FdyRWEvsPxfBbo2AzYLBrHvGsdvH5nHm
 Yac=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:45 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 8/9] scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()
Date:   Mon, 11 Nov 2019 11:39:29 +0900
Message-Id: <20191111023930.638129-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to arbitrarily limit the size of a report zone to the
number of zones defined by SD_ZBC_REPORT_MAX_ZONES. Rather, simply
calculate the report buffer size needed for the requested number of
zones without exceeding the device total number of zones. This buffer
size limitation to the hardware maximum transfer size and page mapping
capabilities is kept unchanged. Starting with this initial buffer size,
the allocation is optimized by iterating over decreasing buffer size
until the allocation succeeds (each iteration is allowed to fail fast
using the __GFP_NORETRY flag). This ensures forward progress for zone
reports and avoids failures of zones revalidation under memory pressure.

While at it, also replace the hard coded 512 B sector size with the
SECTOR_SIZE macro.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7c4690f26698..663608d1003b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -104,11 +104,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
-/*
- * Maximum number of zones to get with one report zones command.
- */
-#define SD_ZBC_REPORT_MAX_ZONES		8192U
-
 /**
  * Allocate a buffer for report zones reply.
  * @sdkp: The target disk
@@ -138,17 +133,24 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
 	 */
-	nr_zones = min(nr_zones, SD_ZBC_REPORT_MAX_ZONES);
-	bufsize = roundup((nr_zones + 1) * 64, 512);
+	nr_zones = min(nr_zones, sdkp->nr_zones);
+	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
 
-	buf = vzalloc(bufsize);
-	if (buf)
-		*buflen = bufsize;
+	while (bufsize >= SECTOR_SIZE) {
+		buf = __vmalloc(bufsize,
+				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY,
+				PAGE_KERNEL);
+		if (buf) {
+			*buflen = bufsize;
+			return buf;
+		}
+		bufsize >>= 1;
+	}
 
-	return buf;
+	return NULL;
 }
 
 /**
-- 
2.23.0


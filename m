Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B260C17442
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 303AC20818
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZaLgeFYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKCjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:36 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKCjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439976; x=1604975976;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=pRKa9RYPbmYIjqNqnNPy9xId0wvUi5EB+wPZWDfjvWA=;
  b=ZaLgeFYsegTa3PNE23HNzERN0Fh7VRnF9gUblFWdJ7BZLUowtN0Xs/t6
   OudC/6umSIovlj/2XPPgMcUJ7b6/ulWpg+Z6TE9SOWSt+I3c9rgMoFo9B
   1O6J1bKPGqHatSxxy6bgdnb/k5pe2/rxehmuVWuJDr6dVLVUE+QEQ3IJI
   2/duxAnyjHlHOfbyaRC0uMeTWUg2xykT39cWAKto+6iSpRP2dhyk7Epy+
   PZu4k4UMyLInrIY8Vi4vV1dWP7eBFGaZck6gFHh8fx2FUw7d1LCtNY6rX
   OyMEMQKYNpxQ5hKsi1lUZG+Syf69rG/U+oQ2l7/pJ6DlxHg2KpprpsSZM
   g==;
IronPort-SDR: Q4kFFmNWDiECznUrbkp9m2zelk8rZyVCEzZxVdLIEI0UFvhzk7ahDpGvwkl22wyqAFlkeRy73k
 D330yM1sCKzKr6o7QU5YrHOBvgrGguDVJ7giXbeqZcsEjGsuxgRMY081dYA2hs/B/QZdfvnuMZ
 SD2pYIdlksJs1vFIqTMH8ZQ0Wvwng1ciQ0xBWWhsLb9bS13oON1ZeSeQ7E+QRQFW4dqBUQ+eJ4
 HSDDZ1B5Qm0a6sFc1aoW2AYes8n19rtXyjUTGBjn646m56pfkG2RsB3qsSTGDs54Tq4Sv8hbDa
 ZBg=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062963"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:36 +0800
IronPort-SDR: iy1E/f2SeRHSl2NR4k/Xew+QBmls//EErBJ4RtneW7W0Qo2ZsxDmh5bwFJ2qirBAH3kJzTiXUw
 nQVOdjrPi1epwFVzoWL8IZZa8q6V+5SMwfeBOfQ9o8D1M0ilqzsFqCHrV3nCPyyBQ7IOcnotiA
 zT2JAGcyxhZsJk1SJgAn23U4XAKVLbPSmPzCazjPsuRj3l2hi0qhl/u/3dyMthEOBr0hs63IOl
 vKrbTLhYa3E+j7ezuGFw4lrmINFc2gi6ovbOd0QblPTsglJCc5dnRawoBv85Dwp0kJyAO1pWlZ
 HfE/fhj/eXtaHfBi5K0Cv4Fs
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:40 -0800
IronPort-SDR: 7KNGaRYyEF8x+/ZjhGLu+4u7TY3OdEre8o8K8/TSWKs251Hma92sBpZPSA97z7BpbhbhrdKCih
 20juh7bT6ZoQyJrVgJHjWUPUUiQtcwoWZTZ5S4umULlxJ66POPAasvaVIFu28RLa8V7fo4US+n
 i3LfYjAeNMB3hSVfcBGoSOkKyvNlOCxOBxEBguMsrNWpPHVw8tD6fqnn5xtN11LUgxpGeSHVoc
 H70zVCimk3duIOd4rIT2UQ3ODoLxwdogWfGpLa3Y4iWYeM+bD4sfoVMS+mr5D5N4UCAcDW9sOF
 VNQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:35 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 2/9] block: cleanup the !zoned case in blk_revalidate_disk_zones
Date:   Mon, 11 Nov 2019 11:39:23 +0900
Message-Id: <20191111023930.638129-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

blk_revalidate_disk_zones is never called for non-zoned devices.  Just
return early and warn instead of trying to handle this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dae787f67019..523a28d7a15c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -520,6 +520,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	sector_t sector = 0;
 	int ret = 0;
 
+	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+		return -EIO;
+
 	/*
 	 * BIO based queues do not use a scheduler so only q->nr_zones
 	 * needs to be updated so that the sysfs exposed value is correct.
@@ -535,10 +538,8 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	 */
 	noio_flag = memalloc_noio_save();
 
-	if (!blk_queue_is_zoned(q) || !nr_zones) {
-		nr_zones = 0;
+	if (!nr_zones)
 		goto update;
-	}
 
 	/* Allocate bitmaps */
 	ret = -ENOMEM;
-- 
2.23.0


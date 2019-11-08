Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EDEC5DF61
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22BD21882
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oh/2HX0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfKHB5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:20 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178238; x=1604714238;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=EnSuzKY/axQCAajAVOcJoJw9dBgmXf5swcshYxE1YWA=;
  b=oh/2HX0aao8ozc4rjBWUdb4SHqkFtWmpydtyObAmBEfT4KCyJ1nCwOAq
   DruK12DTGW8DQmJFsEc/jWaAOBxo5bXaF0Cy+R1Tr01pdm+uQ8l+AojCb
   ALt1AOO7q7ymsDnrUfmylsbKfoHqhOa7A2BaGymrvnxwMf0h92cQo8yFi
   gTfZMQNocIAyvV0QAqBsiPlV2uqtBTdF+TVMMPWkCiYBvz4C4fFEH0KXq
   QHB7i4WI2EvoydWaVilj76SI4KCJ3wpfuOJ7kezSl5qWmNtsoDGkIqX+P
   ma4NP61nIfKPYwMQb1uCc1XVgaCFAD/RLuK33JJwTVk+D0vc609g7Rpxd
   g==;
IronPort-SDR: G3D4gSI0aTSZb1BBRruCdpvkG+/8WYVo/m6WnKT69/1qzXnFB3VtbOF0ZaHzUhM3BgGXpkUi/B
 J7xE5KhJnRg39sUY6Q54XLLO3g6xkDpSJ6Xwqj8sfrTMyjZos1XLu/9tnAYcpbUdFYx/Lks5Ph
 oTkRkr9bnxqnzOpPhe3G2eEoIzoLd+qRIql6ENONftEk0BHFVcFpkXEH6qKfg8RBzq0aGPmmS1
 7Nk0PcuzxOk2+IdNsI7GdZI3JqqxJkgYXZLCTSpszGeS5csfMLdB8Tam9YK458NvSTntBcO4pz
 9R0=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437223"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:18 +0800
IronPort-SDR: oe/u78q/AJGeEL2eR0cr+REhySrwiHayRhUOufblEp/Rz06JQDK6BpWpnDMNFhFGKQTPe3FL1a
 jBoTpEEjNMum2YfNEwEGbLzaOWo7lerNkk8A9rvVmN43XwQea0+bTHxgBUZufcB9YbxNq5NU7i
 DgOLkodAtNMfFSjc9IXPWZhtuIorVy2wDGzPKNvpNgP1mgzzl+vgXrA72QihEwqr2BlPM2mYkA
 LKIaxZIyxyqwJ+YtMHBxH3J36nQOrNpQREe7w4jt1sJ9l8uGJTfoMnLZ+DGfo0XXs1GOvp1C4d
 9KQiFAeLOwVbF06dluaskfVf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:28 -0800
IronPort-SDR: dHLRd3tvtQ98q8DR8MwYs6kFl+6+MwCORXw5XY8UeHeZmmbwW8EmKaU/5UBlQ7GIWI2DFt5/h3
 pguu0LBgUW+IOJRG5oHEnqORPsQgS+3ttITalhT8LiVC71i3QBCZmPqzGx0gQ0zdTJT1IMPP7f
 dNvMATD9OHPjcUhT/m49BQjwPkpDKz1gKwrGkyL6bKrb08LFBK9YIDij069nNj95EI/A9jryfZ
 yTBySx8vV/N6UXprL8jNnLLQKZSRZIWWqWawaUj+itEJuxVNmwPXy4zdUaSOoJrr87VuDOSoWt
 K5s=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:17 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 8/9] scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()
Date:   Fri,  8 Nov 2019 10:57:01 +0900
Message-Id: <20191108015702.233102-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108015702.233102-1-damien.lemoal@wdc.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
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
until the allocation succeeds. This ensures forward progress for zone
reports and avoids failures of zones revalidation under memory pressure.

While at it, also replace the hard coded 512 B sector size with the
SECTOR_SIZE macro.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7c4690f26698..f191af15de1b 100644
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
@@ -138,17 +133,22 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
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
+		buf = vzalloc(bufsize);
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


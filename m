Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88163C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530CC207F9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CYBthDT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGPJQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:16:13 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:64312 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGPJQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 05:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594890972; x=1626426972;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v9clwlcU4qm2PTH4UUGbp2bIolYjNIIqx0I5fJl78zU=;
  b=CYBthDT2SnjIUpbDfZhyN1e3pYVWWmX00TGJj7eiQ0jz//G9DqQI2Ys/
   amk+XQ1qjHZx9pf6awqMMBsuJ71ljHxTwAIQdaPQUvzIzoN2A/REmAvtv
   ZlFCI/wrRMC0rFncbmKbu1JV90aIdcElBcfQK90u1OQsYZDwlMnuqLtBW
   U9/c2EZmGhWCU+eAJxqBw0Z/kWFHGXq2JRHQ9xP4Fh1rdySiXSziIJGQy
   Rrz962zeQbCR5T/n058SPehpxhykeO8RB+11DDsU3iqR5hifwmA3vnYXT
   iXkpnsPb9VDIyvBtpFH15ouVxWfgK337OJxpVeIaD8QJtXuvYIRgMUbAz
   g==;
IronPort-SDR: czYHP0k7OgDkYQ4Fdn6e4zTLdGyXZQHen7zqF75Bakd9A3Z8LgyDp9ioABM0mPoXrhHmJKus4X
 v0W183d8ceSvDPNLDur2rUYHO8BwuIXBupV25GdIBIRLjwS/iGZN0CLQULPwPBwvQMQOMKtr0t
 lywq70KI2Dy/qgNazjj9lK7/D7IW07akzLTj1aHbJmSpivqYxP3p1SxWw44BVJmMs/Dh6Rv1oT
 eeHNBUS9BolpT/nW5yxR0iEVCWj3IS0xypKKpyUxPyxQYY10LUlRndqMSznZBpjf+nwN1yyEUW
 pGw=
X-IronPort-AV: E=Sophos;i="5.75,358,1589212800"; 
   d="scan'208";a="142588951"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2020 17:16:11 +0800
IronPort-SDR: PcUyjG0Vi9clJwdShjWED3CB2Kz2uyimDeJBtVoEAl9wQKMEafjUcfqDogO8xRNxzJf4IIleeD
 xFc6xWjeyhHYyUfhld3YuBD/sScSXVsS0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 02:04:02 -0700
IronPort-SDR: LXy9zqijH1EqAJvSCNq+xkeAeJc1TTYgCrP3JJ06a3grXGhUVSb0kiZMbI5mMSAJW8E0QTm0bW
 hbLyNGe3mKpQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 16 Jul 2020 02:16:10 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: sd_zbc: don't check max zone append sectors for max hw sectors
Date:   Thu, 16 Jul 2020 18:16:06 +0900
Message-Id: <20200716091606.38316-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't check for the maximum zone append sectors to be not bigger than the
maximum hardware sectors in sd, as the block layer is already enforcing
this limit when setting the max zone append sectors.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6f7eba66687e..4c90911545b6 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -736,7 +736,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
 			   q->limits.max_segments << (PAGE_SHIFT - 9));
-	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
 
 	blk_queue_max_zone_append_sectors(q, max_append);
 
-- 
2.26.2


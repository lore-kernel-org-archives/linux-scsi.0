Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A764DCA9EBD
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C9AE21850
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="msaI73hu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfJ0OFy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:05:54 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185225; x=1603721225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jlg9LQdkZeLQo63QAcPnxaAUEhyugOYEsJL1rupmp9U=;
  b=msaI73huyfNAW26XUItXcmNuOKQuV9xzJBUtZEPPB8OfvFSE1+vBkzoQ
   L/9s0udaRXyK7S6TuRcyGIeIJ/UG53qlA+a2leJTPtOq85STghhxqGe3Y
   us6xOumM85hvUscfUodf5cTpoW+DVXADnymuex86DjXZhF7ZDraYsK4Wq
   L0r5vfy4Zfmvsdpe8fUmHefhUCe0djoYfA/8OCsZG1FF3wqi6UihoJppO
   h+HFuuUDUJ5NJH7BFxMuWGEpuEZylPhGxV6W72xldp7c3LaipvP0MQPHt
   zU+2rMYZLmA/iomklPYa77Zv70NzlTvdsjbrnma7d6bKIru/+TTcES2PD
   w==;
IronPort-SDR: yBSEMVKnU/AYJKmtL47QQNcAvYPn3Pv2AcWAslo0A1Wdcar3c4YXHt5DTY3DDdvbp//LlOiUD+
 e4ff++/49KuJktfuVh0BukS48TVcmT/MENwu8OSulPFjRTPUaLZiWkgjjOq60Z+0i8brtBhUnn
 kHrJhyuzeji0TOO0td8KQlpwYm0uu+YetvUxiWKz+mWUskNoHJHvw/J2gSzbbD/k0cVQuy5M49
 UoHxFtyKLWzievb7/0irvEhKv/XrzDBbwZy2s7F27cgkW9/sMH7yOvTbZzAVIhKfTMwIE/uOUp
 8ic=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578534"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:05 +0800
IronPort-SDR: jfC9YRmBiYH5BXgBYVrKXl+C6EcT8M0dvvg1AUpHQXGD++ER4mbT2bW5600qnPgwC15Ew9Jg/Q
 sUaOjrQxr+GMZiuoNOJTuKna4Su2eiMj4wUMwM9Vw00dYmoVeaRbLxoPp3w0ua2ES8pgq2Frmt
 wHFHnKzDF1IWgs2ygJGe20qiwH/2tfn4ykpj6UnweBO3iKTulWQ3a254bHEDvM5LVSURlZR6a6
 +MKz7Of0Q615mBmu8Enm1L+vByW1gMS5jK5mfre6TEl6a7s21zeLe0Ks/E8R7PRCmo+RpGvPG+
 fidFH+QSsj0BWQ9o/oZ9JZdc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:17 -0700
IronPort-SDR: UoC2Q5lfcrXcukiP5MUowul50Uc7s5EoU9j73nfDk4RULLZ/LxkObuA/Je8nS59wPzBmKCLzfL
 8QuZMfk5D7b6kWtNYeyM5WccaEFCsyyFsOG7nKp3J8cUBnhnQijW6Rur1q75hcBgbM1xktfJWT
 JNg4UwqCEYzYTBKxvFo0/dEbMgrU+DSu7oxNpre0XZAYqYqc6l8lz8R3lMu0/QmDurwAhpDWmv
 XSkOQt60fe3oT5V0blUqjIbJcWRbqCLc65wyPBpeW5OiSKRfyDvv/2A+knmr3JkbIxH40SgeLr
 d+4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:05:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Date:   Sun, 27 Oct 2019 23:05:42 +0900
Message-Id: <20191027140549.26272-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

REQ_OP_ZONE_RESET operations cannot be merged as these bios and requests
do not have a size and are never sequential due to the zone start sector
position required for their execution. As a result, there is no point in
using a plug around blkdev_reset_zones() bio issuing loop. This patch
removes this unnecessary plugging.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4bc5f260248a..7fe376eede86 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -258,7 +258,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	sector_t zone_sectors;
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
-	struct blk_plug plug;
 	int ret;
 
 	if (!blk_queue_is_zoned(q))
@@ -283,7 +282,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	    end_sector != bdev->bd_part->nr_sects)
 		return -EINVAL;
 
-	blk_start_plug(&plug);
 	while (sector < end_sector) {
 
 		bio = blk_next_bio(bio, 0, gfp_mask);
@@ -301,8 +299,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
 
-	blk_finish_plug(&plug);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_reset_zones);
-- 
2.21.0


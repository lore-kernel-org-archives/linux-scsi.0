Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99781C1975A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720472467F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QwnWYFxb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCJJrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:21 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833647; x=1615369647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EwKO5aoN0Yru0ywPm9Sy5+xOh9OevyNdB2LDiJcdQj4=;
  b=QwnWYFxb/cn571T5GZv5pdMzHbPvKgTjrqBQZM/5D+NYTQY2XNEp/vOe
   HWsFDqoxGCU0+7WNh3bUFZ7O8s6WdaXc7A6ICHrc7I2OpwYpje0C0WzjK
   j8ZlCmLmHoVQigXEVhLohIJSBYFXho+tT+4XlyADqbnrP3tXiVHxTtLSu
   NbYNLwseCMaLsiu6cxGBHZ08pPt73BiDKST4fI94i4aVU3C9x60XyTHiV
   ZsbxaZ8+nEw7j7wZ9mzhwMdbzGkYG9t52BDiZYCcr4VYVz7PVfVP3MkqD
   l9EBdKNzMgRLbqbtcnDiEN3vgMOaWqvDmaZjyAY06sJd9nn+qcGKXyygS
   Q==;
IronPort-SDR: 7t0+shfSJpClnWfBhNIGfY9D9PVHbiluKUFslZBm5h9Y8ZSKrRvcDghj44mgThlKARQZG+FAmS
 rLSAiMldn3Dq3hkk4Noz7AtzcW9FuHCjhlgTmbp1yXfFHa2qU83yY0hAshIn7PVyEH5BcVL/f2
 tcSURLewpPKC814ORRJwfXZ4pu/RMlAZQTkAR+2e+psxziX4chH6IUmiE7hcWtiluCf3hySRq+
 7YCEcgFKF6+zRq1gLfDp62M8EuKntrIxKXLsFqJpAOOObAS9panv5I+RQOZ4IUEgZGOAKWqwIp
 9Zw=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082792"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:26 +0800
IronPort-SDR: 6h4HcwQgON7V1CHi5X+ii6XY0hxSk2ufogFZ3NE41AVj14MB/1LbZg+33DbfhL9skUByvr0Twf
 +uo8y3+Mz8fDGoHPVSudHyBX8cU3VD7YC3dKxuWMlOkY0veOMGdS1U2BpGBNlTqq0GIZEg1pj/
 fvZByu/2o1nV9NA3M7hUTuDgLhclPNndi568RFMIdRahWMEK3FVN8kAN3tpmTZUAXX9t2NVv95
 7oTwFTrpRVvuA/pPURlQ9dS6++unBHtcSCaloKyiPCYqrMK4HGozfGTqRTY8Q613LHd+UTIohb
 fnsyKlEgOXqnUQNZoYVBv/1Z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:39:01 -0700
IronPort-SDR: VECWyrasUrZXGT/LOibSlJBXNClZAV1UNrRobYltk21W3M7e9q4FOkFDtx+s35JFeSSDZALgJN
 9Kccd1UkMvE3TKjtfSeQD1SMxu2n8mWyAueYuS2d+75IDfbfxrN20Rjs4yjRVRw3eLpZD5hJ//
 p0i1nc3EY+cVTD6AaxaQWklEfbOfzthv2GnnPNJ9/GkSFfjozshJzzcouHz5uwjaU0HZldzST/
 G79tdUQXteKDoipARZDH2dbEiEPyiB8ZvcyDFk4mVn/C5aW54mhubeOI2RGTo6c64Z2Whxen5L
 X78=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:20 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 06/11] block: introduce blk_req_zone_write_trylock
Date:   Tue, 10 Mar 2020 18:46:48 +0900
Message-Id: <20200310094653.33257-7-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c      | 14 ++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 05741c6f618b..00b025b8b7c0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -50,6 +50,20 @@ bool blk_req_needs_zone_write_lock(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_req_needs_zone_write_lock);
 
+bool blk_req_zone_write_trylock(struct request *rq)
+{
+	unsigned int zno = blk_rq_zone_no(rq);
+
+	if (test_and_set_bit(zno, rq->q->seq_zones_wlock))
+		return false;
+
+	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
+	rq->rq_flags |= RQF_ZONE_WRITE_LOCKED;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(blk_req_zone_write_trylock);
+
 void __blk_req_zone_write_lock(struct request *rq)
 {
 	if (WARN_ON_ONCE(test_and_set_bit(blk_rq_zone_no(rq),
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 36111b10d514..e591b22ace03 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1746,6 +1746,7 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 
 #ifdef CONFIG_BLK_DEV_ZONED
 bool blk_req_needs_zone_write_lock(struct request *rq);
+bool blk_req_zone_write_trylock(struct request *rq);
 void __blk_req_zone_write_lock(struct request *rq);
 void __blk_req_zone_write_unlock(struct request *rq);
 
-- 
2.24.1


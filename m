Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C50BC3A5A6
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9153214DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S9iGmRKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfH1C34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27205 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfH1C3z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959395; x=1598495395;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Zf0MDQJRBxCXI8NccwOPMOrHOvfBpcXR5EU39nZ7Dyg=;
  b=S9iGmRKXxQY1JlBL+o+1S5io795eB4lcYw+JbpxNXDQSnxZvYLwyTLuh
   Z3xQBYSXNrYUbQAdlooCVq+qSFRSqZluHTuxjX3ZPzB7qFsz5ZauuNbuQ
   yObvuMPprKG1HnlU7FMyqKdcD3KU6in4Ead2RSoqC2uvvg8JjAb2Cs5EC
   l+keUIrzyYYjvtNFtVUNGyG4JdoALIUTx0n7mlCRhNY0izeownLy8UZGG
   o9aTeUoa/aGQpLYMLNVGNyN2AIoXpKwI20hJju5UehUl2lc8vxfyzSvi2
   zVFrza0ixUi+p9CnswW1boWRxSURgCLCSpLzQkx+23BwrljHi/jphX0Io
   w==;
IronPort-SDR: qVtdCY6WFUPRmbH45zPor39j+2gRxxD0aj/MEKxSvXOoX/Ip1b3y0sUo8cNNfkw8KGJWfE9Ogh
 1Tvvyfys1RRkl++OVm7qZGligqknijP9+xB5id6jvhri2cxNc2A6ZEUIVUY3FYJcd7jBlkXWDP
 2jD+M2C/E7NHPqsD0dNv81X4KdK4ztNmclND3fRFmUrhMJtn+eCv53BkZj23ZBkMY/weFWNMZR
 xtyS9yx3GY4gGv3Th9+UaKgnrzgxEHmgb8Z6Il+zukyhvULRRajIR0JzIdDooG77TmYkVXukeU
 aOs=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475489"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:54 +0800
IronPort-SDR: PivQC/MBfjxKhW3RnhHzhpsyNbB70PzT+w2SrfNcPsbkLi2vy5qR08pihBKMJWUOVmqu8NwbXX
 MswBSlH8j5D+mKUoQfOXTXwcSgR4OsTQ9O845BnoeqrXq58GjXahxfFKtP8rOVq8OpvOXnv70R
 qS491c/F72CxD3CXa+4dG5TfuW8q3xPadvMXa9GrN+fJm0LWYItz2eURSIw1oSNqa7F1STfMq3
 JiFkh33oKwHDqiZHSNmYTcVwSdU3CPdRKYAhxprzdb3tKY0JxBQzlJB8XkfqQq9jIop6lM+pqy
 OYtiAqkzU0BWp75RSNKXUlMc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:05 -0700
IronPort-SDR: kmSQCPvY9Yl0P/qLqPk/7Ph9bHEtL1zCCQibdcjMqEsQEPdKNFI36yY1BDK4OqFTfBSXa3f/Ib
 DXDfkhZgtbulqDbiuBT8r6Y/WOqxV40j8mr+DJTiXMlzniXlTnLfDN/rMdqDF4XY1q6ah+EcNa
 g+urg21gD9iHa4LNwY2EV1N68n/SRMWdoU4HH1+IWcA+uwe7YePUgjGM5XxUG71iydSHBgPcCy
 0dQiZ0QLZPyY+786x8Di2QFzAcxB2lMfdqJglkRKJq7IixXRCh8qg1zKFOLXT7nDdSEl44rAM6
 cu8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
Date:   Wed, 28 Aug 2019 11:29:46 +0900
Message-Id: <20190828022947.23364-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828022947.23364-1-damien.lemoal@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the helper blk_queue_required_elevator_features(), set the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
queue of null_blk devices created with zoned mode enabled.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index b26a178d064d..b29b273690b0 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1695,6 +1695,8 @@ static int null_add_dev(struct nullb_device *dev)
 		blk_queue_chunk_sectors(nullb->q, dev->zone_size_sects);
 		nullb->q->limits.zoned = BLK_ZONED_HM;
 		blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, nullb->q);
+		blk_queue_required_elevator_features(nullb->q,
+						ELEVATOR_F_ZBD_SEQ_WRITE);
 	}
 
 	nullb->q->queuedata = nullb;
-- 
2.21.0


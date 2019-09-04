Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98128C3A5AC
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658C822CEA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NMvcF6sO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfIDInC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbfIDInB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586581; x=1599122581;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=pKvixMi0uvmO9/2ZT4Cg0TZHXdkq6iCNQjN+mXlVvMo=;
  b=NMvcF6sOqTUwKr5KqcxangNyiVeMf2zusZRCu9b6OZuGayVfJMjAi+p8
   iv6R/Yl38JUi2fzUWvoFpIWGwxg9gwP8K5arQfGEBqND+dwTVo62eIL96
   BFhH0M1CfKt2gw7NURKgGU+sMYV18wEkvxMa0BSSD1DvTe55fvepTP6S4
   OAPIGoXv6wXkGiMCKepXBkNjvR0F8PR8hugzKGs96XVXC/7JBi1W27NwK
   h4Z9e1H1qnGDevqp/pFXJC+1LF+5P3sH2K5gczaDtlmhA2ytYr8k8Ii0h
   8FwcEn0FP/ogg74SAsLznqtkWnNmbA8XOQN6A/+Sfho53WfAk6PTMBNKV
   w==;
IronPort-SDR: XyX3EL/jPe3evEHejNKr/e2V5FGjdw1sL/fiY1Bd18OoZV1z4U/klAukWaTndTa4SSJ1W2Rjis
 EdxrGeI4TUSujIkrouKPcYzDhr9k+yEk4BU5I8sch18CqI6Cs1vcwhfJQmFa5Fwoxp/zycGwRT
 HUEJK/bLV2uUn37kFnrYpKAE8wofYOIYbauDT7zIrJgNQmP6dq7knU9tLzker9Kvm3CKoqOtT3
 ya5QJM2oW9c6621KbSbvWDlZI7nwYTs8cK2f8IS8VKC8oJvB134TDL/vy5hY4dIUOYZFIZjksP
 hAo=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374688"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:55 +0800
IronPort-SDR: H3PI/oYHlBAf4xDa66yKtVOhCpUTEMFoMIYey/uMAiSRO7L+CTp14cPmdkkHSB/F3GzeXjXmjm
 VNRO5Hj4FIzJGeoOhZ4yLGMeGCHEWU0KtRA5Iq/t4J+PnM6oJF9xOBmpN6OUjWCil9u43SIEam
 vSAM6pkQIDcYVWbtgN75SrdIzSI1HE4OUnh6UfrFGP3BEz9+ZKtkym3H8Gk1vk0xrD8Kma8iZr
 aLHsy9tK9lRmB3ye921wJer/B3eYaUmqxZq/mcR8HF3UAwGGMlRwlmgE6J6xNZWsfOpfWd+rba
 nY4bL5hb6W7e2wl3w/+m7Zn4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:53 -0700
IronPort-SDR: BnRiekJ3Sz+YVudHETO9KdEIEhLczKv4/nQyCHt42YNogu9rDA3b6WfL7l8h+YDuzApENsZWG+
 wpUA0d5Tkl5pxpRQU7GkUec+XytgSvM6iK9EFQs/YnLe/iqJ2OHthPJpWH3H3TqGshhAUaUzVV
 uzv/7iD+Ov10NH19HiVgWZIw0cEZgfSTwGKPssXp8UyB7IPjS2P3zs8mJw/VToEf7fcXvXhZmi
 pGNfqt/LsixkaM4JZ9TeTpbXfOrjTfX7a54iHDHggbYvyHSOBpkAJvc+SKbqmYI2e0cS9WkjDS
 eD0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
Date:   Wed,  4 Sep 2019 17:42:46 +0900
Message-Id: <20190904084247.23338-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


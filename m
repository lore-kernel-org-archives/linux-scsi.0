Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4A5C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CC7964DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhA1Eub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:50:31 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22074 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhA1Eu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809428; x=1643345428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O5qP2BvielJYmUlUhNylv6LuJjfmaS7aLBnXfbQBd5s=;
  b=AJZGERhWZQrtfnzMrEHIV124U0+E2e1dr7pon6fE2hzDZn9HLzhe1VOT
   P2R2X9iSe7kbI0nHE1ytCE9VKfIyuPxqSehfy6SRnruLV2O3OtAEAJgJ1
   pbjFSA4JVBY9SVwBbifFE1vrZRoN8vNyOnolFqT+1W5AxBThGxoNDEBNw
   kR0fYb3Be/giPg9jtXI6Trpjtfwyo5gGfRqAaGggY9FVFb0X3iOHhpIE8
   ZY0SIdjvzoXIWiOwMAwqg5zccYaeNtVTu/O1NyiQzfYMfKlWcgJp2WuRN
   jjgOOwIp1H4i0BqLQ4h4EUfNr1kDqNMzBwqvZuOrfKym6JVXHbr7AQp7q
   A==;
IronPort-SDR: tlR7IPQdtoxNp302SYZSb7X7iAGxzMCv0RVZGufgmonBI2vCqurzYG34FnqOuan5OXUk9r3jTN
 CYRh2eBrRdBE0GmF6wCbHakYT4TzhtYgXvuDncTWq66WF9NWUfgyXnMjwunuPweaUlNFB6drLm
 bfkR6Xo9em4HQWUeYqTOcm8+QqFvjkq2TIPxcejVL20722fHT/xyjSC9KexFgLvMbK/2wz716m
 B+I4MxzBuX1a2hIOv+7A6TTlOQbmc++am4NfuQvIHRIRPSuYk+YAbXFZmyZj/zKpcAaZBXuZRp
 yeM=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509134"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:42 +0800
IronPort-SDR: tQPjUYi9cdtYvuBMY+UzQCJvhZa66m4iytRGVJJs2F47ew5CyLF1Ek5LjT0RrVSaIuX8MZnusG
 sCjtSvcmBsesa/yuu4NCuUAWUHBIqdki4VJlDBgBNsN4Ta9OSGl+kwrcI4VfNgNxloDvW+L/vM
 s74l608MWMr8AnLHm+JdIwE7++8rx3b+7H/SAPWReMH+mVovt5FOqWTwP9wsOnSp0KPzIoNTq+
 SaHQk2otjZ6t76ZcYxdyXympbJSPUiMgfPx6uoaM5i9IBEB607D82Nb0t4IlHfdcPuS6ssXAu4
 6DETLUdbh43U0lYbPD5gGM4D
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:30:00 -0800
IronPort-SDR: 8FBSkmLkyjz/GhHTUchlUwVPFmI+pC7A7EzrMqfa3aKCq8hn1uhE8WCrOLREjJOTmvCt3/CE0A
 PFi6FIaeYm42gCoDFulkqJRp74RBKkiObqip/8YLU5qrv8PTMAeTu2Y9odXlKxxFlbZvu5ejsU
 DGiolIEupzXSPUdqBMUlhiyub/QZ2ynvdm9KWsJN5/8O/dopTirjNGr2qnZcoR/3ZX46Jkviex
 Gz0JFZ39uG0fQ+i29cUV7N2vlNDYZQSEONJZF6Z8/4lc7Vm5g5Hsn3WR+vBMeqsEL0dpBkHiBi
 /QE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:40 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 4/8] block: use blk_queue_set_zoned in add_partition()
Date:   Thu, 28 Jan 2021 13:47:29 +0900
Message-Id: <20210128044733.503606-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When changing the zoned model of host-aware zoned block devices, use
blk_queue_set_zoned() instead of directly assigning the gendisk queue
zoned limit.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/partitions/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index b1cdf88f96e2..d6094203116a 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -334,7 +334,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	case BLK_ZONED_HA:
 		pr_info("%s: disabling host aware zoned block device support due to partitions\n",
 			disk->disk_name);
-		disk->queue->limits.zoned = BLK_ZONED_NONE;
+		blk_queue_set_zoned(disk, BLK_ZONED_NONE);
 		break;
 	case BLK_ZONED_NONE:
 		break;
-- 
2.29.2


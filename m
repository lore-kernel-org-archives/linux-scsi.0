Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86860C17443
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AECD2067B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LPrDs3ud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKKCjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:42 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKKCjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439982; x=1604975982;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Mhdy8g97yrlGhg/4RxtKDJYb9b3tPtuYVaQdVOv/e+c=;
  b=LPrDs3udB0j+Cn50+Fc8dDwcobvwtT7GzDaXekDAHBoe9CjDD0utZvfn
   JwDzu7/hBqtYJ7KSBWNwtWXWP1Ye1lBdWOc+64G+Ra3ClBLMYwvhSApaK
   6+ntMAidbhfiMJm939KY3+EHIKFBHUJ7hlJStl9E5h8dh2XpH5jc0k8py
   Dj25KANU5GQI8KLxNt06DEC1KcprCucrNUBd9B51SQSejjMzCsMcPxxHx
   7HAAX58i9sokMLOjrHOOWQqpUCC3WgSsoU0/nFBjJ2uHCLlHKrtxrBETq
   kmkY5gphEp6QBCwUguqnPe7VRY+ZEcMaKmaXEa3qd8weS6BAjrrOkpvug
   w==;
IronPort-SDR: XgaDhrhLnim1SgKbySnyf+A02hU0ezxMnDtlbpUks+vtCQkx0LqNtQZhoqfO6gYvmmD8r6bnYe
 F4UnapC3QChFD/JLqf9gh+nurmUjuA331eZlPkUf5Cgj9hO+hJTkR+pY8oHpa4VB7ANbS8VIYh
 Gp5odrysSlbm8bxVFifH7QsY43Uz1LdnrK8h3kbBh2Bm+ouNpCGoEawsp0AJD1KmJL7tCGQ2Pa
 i8umDEjYzI3FukeNM1qNvihlfbiAr7pbkKsQToy26yJYJhjuN5M/MXGsw48Of1kJaZJVoaeF13
 z10=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062975"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:41 +0800
IronPort-SDR: FoL4vUE9DFst9Pq/VF57vYgNBFHGYoYvpyQT/qKzxpaYkPtnAM1bejc+cdmBM/ABSYg6qKQUTr
 SlJg3jeO4PK6qQMCbJ/Zs70gDY9Kr3IZajJNC+vZqFeVsPE3jMA8RD4taiyvV7VSoQzZficP2R
 qkytzG4ie8fQmG5atns0MEs/E/1JfU+jiYcDYFcaEODc1CT/KHlR5JkCWAWXVBlhYa9lVsWJTo
 35HqVIjwJGXkkv74UxYlsLbuRSlX5fIaENoMSaXwXBPRFvUs0SRZ/gyiraUOZTyyf4sBhw+y77
 /BVLsdcVkn4VGUPYlJj+jbih
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:45 -0800
IronPort-SDR: NyyzMjuId9K/cwPW4JejXGl9FOwY6f4zFA0r2xaWlqpgAWgx+kRjiP8OqVZDjDYVpGEZpwSIMZ
 hPo4W3ycGN7s6Py3xxyG2l2wTUQ/d4aQg2jSYGFmjC19ej2PEMO11ERUdlhul1ZcvGNJ3lyNXt
 TwsZraiGWIr9JWb9WdpAaWwQmF+iIsp8W4sgEKr9m/r1q5emigRYnXyY5HU9WxK5wLBB9UifKr
 lZg8Zm0UZPNOJcTwRXXQwzESDgKQlU0hTaJsdD9YS951Nzj26s42T6SjnXuO1JrvfTrj2PhTSR
 Nlk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:40 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 5/9] null_blk: clean up the block device operations
Date:   Mon, 11 Nov 2019 11:39:26 +0900
Message-Id: <20191111023930.638129-6-damien.lemoal@wdc.com>
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

Remove the pointless stub open and release methods, give the operations
vector a slightly less confusing name, and use normal alignment for the
assignment operators.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/null_blk_main.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 40a64bdd8ea7..89d385bab45b 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1442,20 +1442,9 @@ static void null_config_discard(struct nullb *nullb)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, nullb->q);
 }
 
-static int null_open(struct block_device *bdev, fmode_t mode)
-{
-	return 0;
-}
-
-static void null_release(struct gendisk *disk, fmode_t mode)
-{
-}
-
-static const struct block_device_operations null_fops = {
-	.owner =	THIS_MODULE,
-	.open =		null_open,
-	.release =	null_release,
-	.report_zones =	null_zone_report,
+static const struct block_device_operations null_ops = {
+	.owner		= THIS_MODULE,
+	.report_zones	= null_zone_report,
 };
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
@@ -1556,7 +1545,7 @@ static int null_gendisk_register(struct nullb *nullb)
 	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
 	disk->major		= null_major;
 	disk->first_minor	= nullb->index;
-	disk->fops		= &null_fops;
+	disk->fops		= &null_ops;
 	disk->private_data	= nullb;
 	disk->queue		= nullb->q;
 	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
-- 
2.23.0


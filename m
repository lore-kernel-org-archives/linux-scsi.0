Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEBEC41514
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777542173E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mMvyqrC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1C36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:58 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27210 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1C34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959395; x=1598495395;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=OfotJnMRsLgxqnsb0ALm0ooV/tnerfPYqKG+KQ8XLzo=;
  b=mMvyqrC+CxaclqsBG0D/770ixwZwgDcB8Af5Y9vW8wN5/caZCH/NvgzJ
   9gfYZbbvWaR9ATdYnYDb828IcRZW++1KXcLr9XC6XH4F72qQHJ4o6tmHO
   UMM++oW7XTF1jZgpcuV+61IAOw+lyii5HN0pFPJzHtaEemaVXkN+n68/+
   7C/2CtvyQKH821b49IK7L5fITNyHBG3EbSPhl/jW6XmJe2OerjcNX6ML0
   slVUaE8YyNWWrXx0fzd6C9QQedSzRi7bF8297wZGsFJIm4/rSMq9wMToO
   y0IZp9RKMRXOrP3iZgNlw0/YMFrllfgHHKryTn7RLWo/rzMLLdk0H8B+y
   A==;
IronPort-SDR: v8ECnTyxFzVAjXUp81uLzlP2FlNzYd/W9mrVfjYtG/E+t0GzgKn6b4dD1vcqiK6ZkWrAGSGZPM
 ZRs191Pj4EHw5TRkAsU34qOk0maRb1f72cWA3/Qmc1YT0QaAeR1gMOH25KuQU7hHoG9FFmvAlC
 VgYawWcNkX6USopD+06rcpKqnYKjNKi4Qq68IHErJhkfOjOGeH80GvrekPV/lFFP6X5x35n/w+
 j2sFDYa9j0vfwSp5peSSwmVPycD5ItlDz8TXg/pfxaLLYTEcufq322d+vxuGWvFY3FQhGsGpNv
 ous=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475493"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:55 +0800
IronPort-SDR: 9CZgos8OF4Uus0NGPjtJ/6KgXQD53+RbLtbD5kGmPDZCHtNxbW8raNpzJUTL2G79QJDqi2I1df
 2l8R0BAmgbjmm2lBXTWcr1MlyC0uY4qSqtoCDtNpzMawATt2bdpqo21zZYYYqKWkXEWBY5njaO
 M3wllVvvtN4HoharGrK9LckFRwHPsoD3JmHRVTQyEoT4d52msoCGYMzxfB256QwH0XI2GyW3nf
 UjkW4n/7Dm58tmuS9zdipJ8suYdvuQTxVAm0azuLw+CvYmNrGfXVM8qeG97KJPltU77ktq6bLW
 EtMjwq4ksYghDHzsUzQqkzfZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:06 -0700
IronPort-SDR: OxfdaPKtErLUOmeJXPjFRG0QeJZ46k5uZk8BFVrkxmxpxaf8OnsbH+NZzGiYehdORVmyl/zpSl
 yJbi+RW4DC4s11m1nFhDvdKVgdN+L/WjofH6dW/VqVGNpsDG8beLbS1TqQp8LORr6wa+5ON4fX
 8qY0QQom5PPieWcHeGAhOreX4Vm/PBQHFdZKVtdgDPWEj0Ax99shKBJysAhZDC/m22fiiztICy
 L8hQfBJmWTZ+IHDCfs/nHehBvbM7xtC892XRjqI2KYCQf9V0TsbhHG4EzmaNvkk8RMiGJcunJj
 BGY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:55 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 7/7] scsi: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
Date:   Wed, 28 Aug 2019 11:29:47 +0900
Message-Id: <20190828022947.23364-8-damien.lemoal@wdc.com>
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
queue of SCSI ZBC disks.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 367614f0e34f..de4019dc0f0b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -493,6 +493,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, zone_blocks));
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
+	blk_queue_required_elevator_features(sdkp->disk->queue,
+					     ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
-- 
2.21.0


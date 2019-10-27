Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F91C47E49
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07CFD21D81
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MvI++XDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfJ0OFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:05:53 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185222; x=1603721222;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=utIVpuMkwaTdskTo45vxPM/J/8/lle5F97i1zeRPlaI=;
  b=MvI++XDP5mHmNbryaJiiO0YV9cH5oCdvEm2sa2ICnPTL/oxs9Leummb7
   uBAAZ7KPObiyGOZFxbuy1R3DEEOs6Tr75clDvPtpagwkK0S9h/5WP8IZa
   +Jg6dOYRr0QQcV2uq8coLdtNiG/HN8snIwKe7ppDo4fhKT7OOe8R8qP5n
   di8lAxX58q1XjVVlQyDIQ/DBVn4eYcsxZqBMn++efh927TmhZf5XngDY4
   Djw9Ub0QYF7D5S2VWmk53wTTNamAPv+siyEYqsTWsjzdxjQmutFb/VBoQ
   uAAwAbPgxOQQ4bHJcTL8RwZYlHbtNeMPjLwVoyEWAYDfDhovmn2C/JPx9
   w==;
IronPort-SDR: 0fgX3hgxsqOxx4JMXPjA0PkrT5b03a/Qs3bLjqWSPQozgu2aM69ReTHhr3g2fW8T7DcpMe8QZQ
 X6pShLvum9kqI4/QvtOG1qTSYLltu4uQrVeKn//UAH3sf6Bm1Hsv3jZvV99yLQruIBsd85B8Mu
 tKkMH4z1FF8+4g7mh4MEUucKOYQwMVkZS5vHTn+PPZxs8upt8loTVmqQmLmc6sYZ3eqxodl2M6
 C97wzDBCC4PGPkc9Krkm3cr4H1A/7e1gaREkk1iwVB7OUcNjb68wW8T8WSbIu5ckCuIpZubkQB
 9ys=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578532"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:02 +0800
IronPort-SDR: YmdfsQJsC+cUkTScAHfzAN0ZfF0CK0mD+J4wuORYuRu+u5upRxdY94BIeVnLka89qM/H8VcegG
 haq9JNoY4z0QOI8jKP/BqOmrcft3uFEp7/IMehce/Ylgq9iGfJIVG86TmdpAJ7wVts7cuZYQHW
 cMbum8sWOiMEENXJZ63FGnFkZ8XJGBPS8y0NZWJAlSv9jwJW6FAfw6dyWDTLpyjMjlMF+J0OlJ
 LygZWMmBEjRT4qfEUjFH+lmmUhOzUrLlD397O+PRO4/eK3GKlL2Pa+QV8RHWskA/cGTmjAaW+w
 ZXN3bgoWk4m72Bg/eIROjuPg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:15 -0700
IronPort-SDR: +RZzKRYzw04dKAZWap4nRW126plQWlg5ewBORgqIOHsG+JaBctwQxupeWsJuzTXv5gowAeF0eh
 X8WPaAQu3Vur/D8ASXdNogN+xAudZYi6dYSbj4KKAof4dUKREP1ajzZN5vsocLv0BFf/9AgGiH
 7XeurbURQa/MmJ0MRgnKi359C/OqtsdN8FbD7S/uS+pPaE6RWYTKX1mLxV+7ss73+B6Z8A+KQH
 h1ajkIbfurdX22hvijRmEq1rpG/6yTkjZhbjuoNPK2oj8Q/wmf9g95hhlY8ogoQLwchkUqFNA8
 was=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:05:50 -0700
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
Subject: [PATCH 0/8] Zone management commands support
Date:   Sun, 27 Oct 2019 23:05:41 +0900
Message-Id: <20191027140549.26272-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series implements a few improvements and cleanups to zone block
device zone reset operations with the first three patches.

The remaining of the series patches introduce zone open, close and
finish support, allowing users of zoned block devices to explicitly
control the condition (state) of zones.

While these operations are not stricktly necessary for the correct
operation of zoned block devices, the open and close operations can
improve performance for some device implementations of the ZBC and ZAC
standards under write workloads. The finish zone operation, which
transition a zone to the full state, can also be useful to protect a
zone data by preventing further zone writes.

These operations are implemented by introducing the new
REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH request codes
and the function blkdev_zone_mgmt() to issue these requests. This new
function also replaces the former blkdev_reset_zones() function to reset
zones write pointer.

The new ioctls BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE are also
defined to allow applications to issue these new requests without
resorting to a device passthrough interface (e.g. SG_IO).

Support for these operations is added to the SCSI sd driver, to the dm
infrastructure (dm-linear and dm-flakey targets) and to the null_blk
driver.

Ajay Joshi (5):
  block: add zone open, close and finish operations
  block: add zone open, close and finish ioctl support
  scsi: sd_zbc: add zone open, close, and finish support
  dm: add zone open, close and finish support
  null_blk: add zone open, close, and finish support

Damien Le Moal (3):
  block: Remove REQ_OP_ZONE_RESET plugging
  block: Simplify REQ_OP_ZONE_RESET_ALL handling
  scsi: sd_zbc: Fix sd_zbc_complete()

 block/blk-core.c               | 12 +++--
 block/blk-zoned.c              | 99 ++++++++++++++++++----------------
 block/ioctl.c                  |  5 +-
 drivers/block/null_blk_zoned.c | 33 ++++++++++--
 drivers/md/dm-flakey.c         |  7 ++-
 drivers/md/dm-linear.c         |  2 +-
 drivers/md/dm-zoned-metadata.c |  6 +--
 drivers/md/dm.c                |  5 +-
 drivers/scsi/sd.c              | 15 +++++-
 drivers/scsi/sd.h              |  8 +--
 drivers/scsi/sd_zbc.c          | 43 +++++++--------
 fs/f2fs/segment.c              |  3 +-
 include/linux/blk_types.h      | 25 +++++++++
 include/linux/blkdev.h         | 15 +++---
 include/uapi/linux/blkzoned.h  | 17 ++++--
 15 files changed, 192 insertions(+), 103 deletions(-)

-- 
2.21.0


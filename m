Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9423BC17442
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6813C20854
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C2kXtCwe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKKCjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:33 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKCjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439973; x=1604975973;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=loxvxJRUWOUdYNBZtzySvWSAolTb0SaIEeeVmfNePq8=;
  b=C2kXtCweN+Gleglw41Jjg5mB6z+Jg/PCMOzyZPfCBYUJg5Q7NIKcM6UB
   qhgg5zcKCUSb4PBb9blhcGtqGn7jhq7DISLZMvttzIVTtRZm+xVB7fRid
   NYnAsTzzf0xAy0HtLoV4EC+qP89XHFZvdnfFxy1qNnymkENFg0P8xTghZ
   Gg1h+KS+xLn2Co14x+MQoJIEzm7UPz9MvWzbsDGcOZxqRE4UzPXO25T+G
   SMk+x89HtdpQVdF0oFbsZW/eViIYhgjn2DE+BFGcRYY6srRdmfXpkbWtQ
   pK7dVjWOye6HxmLUFFt0QtiUSzdWc1mmGm8AwkBoNE+dApoVuHZG6EXBO
   Q==;
IronPort-SDR: /FzPcx5ZN5FmkV1LyJAMO3WaALcJIGnzND5kPHsDhsiLnTqdl1QHBwO850QIhI8j67sIjLQVXJ
 WttiHfybLdFoBcCrWzSWccc7TI03tzIAoRFUHFDAVG685/xMU/7h4s7g9M06a1njVF1sJ7W7ib
 bIMhaKRRdUOG55HHOcsot1vxRMqbrXEijPSqxlbfZ4FB5FgTt1fESRBM2pXcaHaJtAEBomayOu
 iw7Z6yvktipRXF80Gti9nqlCWOwrlf0ItvAO/w3P2jYqExQMmJKp/yaAglW+YOamlQvSh8Vho6
 U5w=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062958"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:33 +0800
IronPort-SDR: ywOv4JCcIrxhs3Ju3qWlYdHZR+WtBXcs1XHbaZ5qswYP0a5XiMeaLbWfwWuyuleEzo6iQ1bg//
 o4XExydKDshffH3/+nQ1khHv6bp9IEEyfmrbA7FldFu31qQlqE4/SQQ/5PRz8Ll1ScmepN6mdz
 KCnM/o7t/Z42+VHWY4jaqaFNejkesJYr8zI7DAl6UunEbtpshrSnDivvAgMI5p6Wq03dssV7dp
 zr8B5pWgqP5EudI6302bwxIZfN4yKNLLreaKl/t7SshTREOaOAFsLXx5SSnPam9VOo1Qr0PItc
 em91glbftwqFWd6GP/9RWpOm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:37 -0800
IronPort-SDR: k0Wrpwz0IBDAyiy3NeJtqBPlFVnypJfiA3/fr3hFumDAX2NkTsMTCRzzSVFVZQ4q0CiUw00AMU
 RHMBekM1qrTAUQL7H3mKmH3JKyCryCqMSA6Utx02YsNM20Bfxk8sVzMwoR6zZQYurgfm0Iakom
 oC8oFbWIxWEPFIg54zaEp6V0l/7qB6nZitli9Dr6m1/h/Dx2qEU+3pi6GUbic6PD5tuESCoAMA
 v57xogsjSi9utAySnLkgjlBUw3SZcI81ivDj8s2dTxkU5dPNWEKr9r+/yudSBcwv0b/pCna2DG
 rPo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:32 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 0/9] Zoned block device enhancements and zone report rework
Date:   Mon, 11 Nov 2019 11:39:21 +0900
Message-Id: <20191111023930.638129-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series of patches introduces changes to zoned block device handling
code with the intent to simplify the code while optimizing run-time
operation, particularly in the area of zone reporting.

The first patch lifts the device zone check code out of the sd driver
and reimplements these zone checks generically as part of
blk_revalidate_disk_zones(). This avoids zoned block device drivers to
have to implement these checks. The second patch simplifies this
function code for the !zoned case.

The third patch is a small cleanup of zone report processing in
preparation for the fourth patch which removes support for partitions
on zoned block devices. As mentioned in that patch commit message, none
of the known partitioning tools support zoned devices and there are no
known use case in the field of SMR disks being used with partitions.
Dropping partition supports allows to significantly simplify the code
for zone report as zone sector values remapping becomes unnecessary.

Patch 5 to 6 are small cleanups and fixes of the null_blk driver zoned
mode.

The prep patch 7 optimizes zone report buffer allocation for the SCSI
sd driver. Finally, patch 8 introduces a new interface for report zones
handling using a callback function executed per zone reported by the
device. This allows avoiding the need to allocate large arrays of
blk_zone structures for the execution of zone reports. This can
significantly reduce memory usage and pressure on the memory management
system while significantly simplify the code all over.

Overall, this series not only reduces significantly the code size, it
also improves run-time memory usage for zone report execution.

This series applies cleanly on the for-next block tree on top of the
zone management operation series. It may however create a conflict with
Christoph's reqork of disk size revalidation. Please consider this
series for inclusion in the 5.5 kernel.

As always, comments are welcome.

Changes from V1:
* Use __GFP_NORETRY in patch 8 as suggested by Bart.
* Added reviewed-by tags.

Christoph Hellwig (4):
  block: cleanup the !zoned case in blk_revalidate_disk_zones
  null_blk: clean up the block device operations
  null_blk: clean up report zones
  block: rework zone reporting

Damien Le Moal (5):
  block: Enhance blk_revalidate_disk_zones()
  block: Simplify report zones execution
  block: Remove partition support for zoned block devices
  null_blk: Add zone_nr_conv to features
  scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()

 block/blk-core.c               |   6 +-
 block/blk-zoned.c              | 356 ++++++++++++++-------------------
 block/partition-generic.c      |  74 +------
 drivers/block/null_blk.h       |  11 +-
 drivers/block/null_blk_main.c  |  21 +-
 drivers/block/null_blk_zoned.c |  33 ++-
 drivers/md/dm-flakey.c         |  18 +-
 drivers/md/dm-linear.c         |  20 +-
 drivers/md/dm-zoned-metadata.c | 131 +++++-------
 drivers/md/dm.c                | 130 +++++-------
 drivers/scsi/sd.h              |   4 +-
 drivers/scsi/sd_zbc.c          | 237 ++++++++--------------
 fs/f2fs/super.c                |  51 ++---
 include/linux/blkdev.h         |  15 +-
 include/linux/device-mapper.h  |  24 ++-
 15 files changed, 429 insertions(+), 702 deletions(-)

-- 
2.23.0


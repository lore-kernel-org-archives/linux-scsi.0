Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C12C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0310721D6C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FMtGacsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKHB5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178225; x=1604714225;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vM/KrJ+HIa8siNY2n9F5icqhovX3v2IUN4Yn9XIWjuU=;
  b=FMtGacsqvEhGlMRjnMuvZ8n3gZdWJxI1YLetG1ZuE7fABCqVeB7SclOu
   HPGHafqGTib8c6Dbz0VhSsTcDsoCODAW1xVh/LzaAoeviSCxaPxMUSYR6
   Ek1tEqRlTAWv7Lj79JA5jxIgYsJFUC1mYL8oXBCVyv6aMvmqXdYPkkfT1
   PpCEQ/U46dRVbc5wi9wzmmHdZMTGzC38DTrLbFAXkhadoURyKsqtEgSlD
   cEy7JIRObVBPrXYk9hcd/mIvD9bAuON9E2jSnddFRMYcvasorXScDdeuc
   wG3hxz+L+sMi9mY+d2SOfh3WNZgdrmrMQ/stmfbwA2wwYiM3cTA7IidNi
   w==;
IronPort-SDR: XiZ3ZFOV7P9QgP0jGD8gSnW3q43MaH80TrCTgmAUAmLZRwKrHeJs3KXHp5Lyqh5U2Aj05fxxk5
 c7vcUaKocEB1spc1u+jQUE8MtilUQqZXYh0B4tP8pEP+ERf6Ijfh2Iyb/auWB+efP5SkXBRRxE
 qMMl3BedthxFHRQlhqZd/C1F8s7/JS52c/df8gqTADXA8qJUacai8nFGcy9pb+uJ4BPY16733T
 7gdhq620kRKmK3styBW+ufNjjzJJGfHQmIKPxbZYb0hWjbQ0Dvds/OI/dxihsQs5UKUEkQKEBh
 oTs=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437193"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:04 +0800
IronPort-SDR: licwX++cEbmszrlTbWi5QKI+NfcB6Tet/4mCGCW5rwnVUFgOPnHs+xGTKug4mD8rVHd24Y1iPx
 HNNQ2crmH4OyOOe2vvatrsySy5V7lhzBxJK55hEHldHb1F0zGZEcmW+QUZJs7o6h7Z80ETVKVS
 xROhd+hhpooNJemnaDjquHQz94xp3oZUDd/8h8pHX6r7po5tXs2QyuW7JSFCEpLX5tIpv1gDFO
 nMDLwDePdQcpApcvfg8+kn9nrKJiZq0gJu1pej3blSqiET7KX8AApFf37YQjd1I1/HWY34jCx6
 ugIbgeyujZgGgkNznOiGFuFN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:14 -0800
IronPort-SDR: n1JB/r/HWWN2B17V0qOnL+HfFwacsPp5S7iKAhVZGZsNZezmTrmkpdg7au+KUF22Zv4gjzyhb7
 NHHxOniZM35NXgyv3T+t/RUTLj9+ZkQSbX7SIgY7GZHWE8zXAyV+VCl3tx8wJpZ3D0qpEbNLAK
 7lTAk0GlfNVg6qBZeCDlW+7HFz5ZLDgOHAwhAZhqjj2Nv6zn+b7OuaTwd/ou9i+FLBk4tB18CH
 gz93U1hqWBN1NMh1oiqBwxd5rlbxaIZgAFJxbbCE5WrcvT0uWh4c9ostOi3q4RjsklKO86XJSy
 ZTE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:03 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 0/9] Zoned block device enhancements and zone report rework
Date:   Fri,  8 Nov 2019 10:56:53 +0900
Message-Id: <20191108015702.233102-1-damien.lemoal@wdc.com>
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
 drivers/scsi/sd_zbc.c          | 235 ++++++++--------------
 fs/f2fs/super.c                |  51 ++---
 include/linux/blkdev.h         |  15 +-
 include/linux/device-mapper.h  |  24 ++-
 15 files changed, 427 insertions(+), 702 deletions(-)

-- 
2.23.0


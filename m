Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E78C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693CF60FE6
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhIFB7d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22455 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbhIFB7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893496; x=1662429496;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qkG5YiBawGUM6oV5jQYPQv3PzaGKgTXQw6Xp460fmkI=;
  b=J5xi465eJeHmpOS5cXQFV55Due1eM6xhF2259yiQ/aj/YP6jAVWCZI32
   MQGbl7WQXVDytwT2M16LnUA3zy6/QL6UBuRMcSp64Gbwk2o5gpcq+Mdda
   brJI1zHaL0oLBycAqaTMBuZJMjyvM4UcQUQVmG2adCIY+hshfHsHdxRKI
   qoJt1kXrjZqamVMFFnCS4utPbhi/Xzx4FZgfLC+b2/GfsF4GiOZprVKOS
   p+JBvft/M5oNv4wmIjF8YWNFNxulEyuUx40FMR+iVjcEage3cHJak4W+W
   WhZuvw7G+KQRu/PAXXW2XZchcwoPpsmwz9PhQLOuR4BaEL1EafmQ+I0A8
   w==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789026"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:14 +0800
IronPort-SDR: WFcoo2Njm9dghRp+1BVslSWZmZQjlyord+n5c3KgVW4XFWMU9/kbb+NcX8jgpRjK+HM5hVUYM2
 3HGx+QzAqCQ42EJZVVJuvn1FGG0H8JqwszLvz75lCtriDmaDLsKR8pGtwyJjIjyS1o9Cc256Lc
 cOdut8NL9QA2ZewF5QhaOT5sELoQbWskH5UpIoPaXzld0ICe91LpvnXHMZSGmMwwfKVx/KuDa6
 2qKsem1QqpPpcAaNFI3J2+mTBkH3PQfHFPxxxk2C6Un9/6RrxZvv8PhnWHtvPjhXhV1EaQR9D9
 RH9yAFlBrfL8vJfWmJZxE8zu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:14 -0700
IronPort-SDR: NaLYoFIRYQ2G8gxGpQeGzkUcA+wPemdB6/E8JyBYphKS6L+IueDkKebfahuY0PyCIAnx11iuYX
 K+07jNFlB5S732SSrI3JOZnI4ap3GH35Yk4cOGGBpjkjE/n66CluTYln1b2wRfoGkDFBw1VpFU
 5mUFz7bVENLMFqGHQk/ysXuUe7LZVPqTkz3yuBefn6JvMp2fPu9Q4sCdv8xVaRN4POgCCCZzAg
 2CYUmd7M8Ft90hzdfZ2Q7M7zA0zbvcY0xoP8AHqxQytpZcQ2+FngbCBVMpsW5xOOnZ+4pAs6BR
 BpE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:13 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 0/5] Initial support for multi-actuator HDDs
Date:   Mon,  6 Sep 2021 10:58:05 +0900
Message-Id: <20210906015810.732799-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Single LUN multi-actuator hard-disks are cappable to seek and execute
multiple commands in parallel. This capability is exposed to the host
using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
Each positioning range describes the contiguous set of LBAs that an
actuator serves.

This series adds support to the scsi disk driver to retreive this
information and advertize it to user space through sysfs. libata is
also modified to handle ATA drives.

The first patch adds the block layer plumbing to expose concurrent
sector ranges of the device through sysfs as a sub-directory of the
device sysfs queue directory. Patch 2 and 3 add support to sd and
libata. Finally patch 4 documents the sysfs queue attributed changes.
Patch 5 fixes a typo in the document file (strictly speaking, not
related to this series).

This series does not attempt in any way to optimize accesses to
multi-actuator devices (e.g. block IO schedulers or filesystems). This
initial support only exposes the independent access ranges information
to user space through sysfs.

Changes from v6:
* Changed patch 1 to prevent a device from registering overlapping
  independent access ranges.

Changes from v5:
* Changed type names in patch 1:
  - struct blk_crange -> sturct blk_independent_access_range
  - struct blk_cranges -> sturct blk_independent_access_ranges
  All functions and variables are renamed accordingly, using shorter
  names related to the new type names, e.g.
  sturct blk_independent_access_ranges -> iaranges or iars.
* Update the commit message of patch 1 to 4. Patch 1 and 4 titles are
  also changed.
* Dropped reviewed-tags on modified patches. Patch 3 and 5 are
  unmodified

Changes from v4:
* Fixed kdoc comment function name mismatch for disk_register_cranges()
  in patch 1

Changes from v3:
* Modified patch 1:
  - Prefix functions that take a struct gendisk as argument with
    "disk_". Modified patch 2 accordingly.
  - Added a functional release operation for struct blk_cranges kobj to
    ensure that this structure is freed only after all references to it
    are released, including kobject_del() execution for all crange sysfs
    entries.
* Added patch 5 to separate the typo fix from the crange documentation
  addition.
* Added reviewed-by tags

Changes from v2:
* Update patch 1 to fix a compilation warning for a potential NULL
  pointer dereference of the cr argument of blk_queue_set_cranges().
  Warning reported by the kernel test robot <lkp@intel.com>).

Changes from v1:
* Moved libata-scsi hunk from patch 1 to patch 3 where it belongs
* Fixed unintialized variable in patch 2
  Reported-by: kernel test robot <lkp@intel.com>
  Reported-by: Dan Carpenter <dan.carpenter@oracle.com
* Changed patch 3 adding struct ata_cpr_log to contain both the number
  of concurrent ranges and the array of concurrent ranges.
* Added a note in the documentation (patch 4) about the unit used for
  the concurrent ranges attributes.

Damien Le Moal (5):
  block: Add independent access ranges support
  scsi: sd: add concurrent positioning ranges support
  libata: support concurrent positioning ranges log
  doc: document sysfs queue/independent_access_ranges attributes
  doc: Fix typo in request queue sysfs documentation

 Documentation/block/queue-sysfs.rst |  33 ++-
 block/Makefile                      |   2 +-
 block/blk-iaranges.c                | 345 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  26 ++-
 block/blk.h                         |   4 +
 drivers/ata/libata-core.c           |  57 ++++-
 drivers/ata/libata-scsi.c           |  48 +++-
 drivers/scsi/sd.c                   |  81 +++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  39 ++++
 include/linux/libata.h              |  15 ++
 12 files changed, 631 insertions(+), 21 deletions(-)
 create mode 100644 block/blk-iaranges.c

-- 
2.31.1


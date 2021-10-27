Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C717DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B437F60D42
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhJ0CYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:24:50 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63763 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbhJ0CYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635301345; x=1666837345;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qkcdkfnKQ+VIwnl2Cu/kNnIVze3tKolVFa6rlrS0vIo=;
  b=qUNcfW0SAHf+7yY2wkuDXAAoy9SwuhAlOW+tx+Opt+MPhd86mAl6U/zw
   2iJ3hyeUgQqaI2f6/KX0X23F8xD4QEt5dS+A1aTgyUN7ItYNJ2fyWo5MV
   CxVuhrFCLESjDzgGuQmR9Yn6lT5U2arM+uPyau9sqZI1vyGIaC+T70y2g
   noQF8P7GXp+QNEmho13+aENhEMKFx2yoTxAVz46xKTy6GFd5ItWtOMCEg
   XZMQ6ZoF7ruJ9uLgcf+mMGGearD4R1U0ZmKl4Qr0PuCfIl+2QqeAsY2TQ
   TA61D0aL/GlclMBzgVIsljAH9y7dBYD5974BUjPjWf95Lh8S5IvcB0U1i
   A==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183924733"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:22:24 +0800
IronPort-SDR: 5LMXtI3UH7yeNLciy5doXy/SOqesuk7xqZ0C50yCcu0mAomSizdTGzta8rsjuGxHo4y+Swn34m
 kOFzVh/ah2MRyu0xNssUFfeZkVFyQsT/V3I+VNtugybjUvLaYTJRgHwcgUDHlPrYBD+KIAMNvs
 D04SA4p7N89OAMa9TgD1gHUKm1M5mur5z2J1MXXk1SADu0vh8Mb7HGLC9Y3T5//V8JCkrpcAmk
 xFLnftEUKA2aPeM4mapbRH+9FKSZWVzt3ndSzO2wkcbqIavGk88UFEa02V9MmNbFVDYr2/OWoq
 a++h48VixrQ6TJyy58tahk92
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:57:54 -0700
IronPort-SDR: HGySe0BeOzipMfM2MFHofSspQG5XR6ZwYfQsq+QDnHaUAA8QlUrbOozU2AYL+ekoRJeJCR2hbj
 rhZKTV8mvA+XYDpn7j+4IgaB8TKqdTBNXaxyEjqUJgmu88nhQD2LVU1M79+RLHOM7NCIatWkgq
 fjTc8YHYCJS1xv7wgdm2GliRdDEy5+Wol93ntY9Bvd+AwB7ZJslXwaSIhjMGbhVv5i//WHkTR3
 Kcc5pk0Dfl/FjqqfeIQoG3pz+XPuIN45LWUifqPokFakanFfbQXe1rmzUDVLiAf2vGXwozaE8e
 3yg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2021 19:22:25 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Date:   Wed, 27 Oct 2021 11:22:18 +0900
Message-Id: <20211027022223.183838-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

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

Changes from v8:
* Rebase on latest for-5.16/block tree
* Added reviewed-by tags

Changes from v7:
* Renamed functions to spell out "independent_access_range" instead of
  using contracted names such as iaranges. Structure fields names are
  changed to ia_ranges from iaranges.
* Added reviewed-by tags in patch 4 and 5

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
 block/blk-ia-ranges.c               | 348 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  26 ++-
 block/blk.h                         |   4 +
 drivers/ata/libata-core.c           |  57 ++++-
 drivers/ata/libata-scsi.c           |  48 +++-
 drivers/scsi/sd.c                   |  81 +++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  39 ++++
 include/linux/libata.h              |  15 ++
 12 files changed, 634 insertions(+), 21 deletions(-)
 create mode 100644 block/blk-ia-ranges.c

-- 
2.31.1


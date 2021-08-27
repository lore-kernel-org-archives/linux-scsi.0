Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9D7C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A0E60FDC
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244525AbhH0Hvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:36 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42478 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbhH0Hvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050646; x=1661586646;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e0janEU+uFeXcw1kV1BI5nKCepxFRJ6aK4mhuB0q5pk=;
  b=qrWnnMN3ymuAhAaYPSnKYHQyn/cKNgaUZLaiRc5ccKv9h2KkGTtMhjv1
   IwlMFKY4ba0fW7RspRg9PN9OB+P/JOZ2nBr9PyUlR6FfVrCE7QtrCqyM4
   VX5HEl9lDVZGEN1CejMeFoakhXR7lC5KEDUsJb+WocPc9N+AJB3LrzA8g
   DUbtx1pXZhKxvjdR3WqU6huJ6NzHFjAXMevSVoq9tImajlSmkO1tgC6mi
   lhdxrFWQFSI2I5rPYGUlye/WkVNjEMZSMqGll2MhLjXHDokryQ6pQPQLq
   PrE5MFzUz6qrRh3fV48K6kHZHTvBp+T1peYPFKiVZra+flfm90WOSdAD0
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342782"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:46 +0800
IronPort-SDR: tvDCZ+yUZ92jopHw3crYEYZxU2/N6vw1eoslAWSAK4enBYzlh981H8l8GKvsUeKNF3USpo/LJG
 IdMUBL4+fTniGIXBbFnlWN8K05M3tVF6xRdVpTgmgEFn9goSlpQH2/NnE7Zf0WocLdxOtmXsQN
 Ro2TC8OImoYrcPD1nGpkaUKDA4zCLcoV8F2OcgZn0HRhMA/nYFkrcVJjaA4z9oYAQJP+ER8Ma0
 vPGSYQAc4d2FdNBFCkAb98w4cusVo8RSoKVvEhCavBNNBda923Jpxok7lEB8SySi/rwQRtw7P8
 ncSDcUkVmzYWVlAWzGoXF1cs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:25:58 -0700
IronPort-SDR: lK+xM5AbvE7fHnfbozpf3IlMXtPBfYSfXi4k8/4qb58uGsemyjrIo9Q5D2rdrhYlVi00GiH5qo
 y1Ncpppo7HHe4CeqJUtMxSVNZs8TR6RGaG6aJtoUYpOs7wuSkEebv/7iTgvR7bISC5mchiNQPR
 k6rgVKPT7RuCAK3ZjZMe30XPskAxOmudCamk3Ud7r1Umt5ysAw6OHP5AA5yhZrpzsuX0AQltTH
 JATI02+ZICs4lnCzHpqCpqBFjkDSMsGXdnTBrLRuP5ifKSYHohpGU9LZLtlNPWNqRq05v15AO8
 ZN8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Date:   Fri, 27 Aug 2021 16:50:39 +0900
Message-Id: <20210827075045.642269-1-damien.lemoal@wdc.com>
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

Changes from v5:
* Changed type names in patch 1:
  - struct blk_crange -> sturct blk_independent_access_range
  - struct blk_cranges -> sturct blk_independent_access_ranges
  All functions and variables are renamed accordingly, using shorter
  names related to the new type names, e.g.
  sturct blk_independent_access_ranges -> iaranges or iars.
* Update the commit message of patch 1 to 4. Patch 1 and 4 titles are
  also new.
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

 Documentation/block/queue-sysfs.rst |  30 ++-
 block/Makefile                      |   2 +-
 block/blk-iaranges.c                | 322 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  26 ++-
 block/blk.h                         |   4 +
 drivers/ata/libata-core.c           |  52 +++++
 drivers/ata/libata-scsi.c           |  48 ++++-
 drivers/scsi/sd.c                   |  81 +++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  34 +++
 include/linux/libata.h              |  15 ++
 12 files changed, 597 insertions(+), 19 deletions(-)
 create mode 100644 block/blk-iaranges.c

-- 
2.31.1


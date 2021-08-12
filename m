Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F925C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F45C6101E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhHLHum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:50:42 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51846 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhHLHum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628754618; x=1660290618;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4u8e9rFyNPDmv1NIZxmllueH6Qf71aOKm4JtYfad7S4=;
  b=O2YiMC/gmNcRBmXV5fcRz4fkPAqpfbbQM1cdyb5t1+Ql43QAsVjs8iLY
   lKlGXLg9lEuWAA/LJiCR7ua+EvEeftL4JDjgPr1s5N4cCJQ+bJ5MOLAUB
   FQ8CU2EcaQKJg/7zKWsR59g6TvV7YRaKyXmkLBQgF8i+KVwW8czajPdWa
   dApbO015ItBTtcDOsf32KVXSkEUB9xVS/KN2sNBSyeD4su7MAKtsTxu5R
   EckDA86waDQnch3BGx8NBLIclV5ROj35h378Pgzamdus8Gerlx56mBM0I
   LvBXb1Px2FNY8U/YIzBN90iDVUfaJey/2Q4qYc1xidh6izgMdvxBz/Bvy
   A==;
X-IronPort-AV: E=Sophos;i="5.84,315,1620662400"; 
   d="scan'208";a="177596931"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 15:50:17 +0800
IronPort-SDR: +tNerFHQTUi0RC1CH+kq2x1BZFyTsav8fNaXr2hA2/0l+f8PJacb94iSqJv44EZNS47Fy/unDf
 maQ4y631dp5at/aJqvyVt8NFmOk8LWP/GNelaNN0Ij6P5UZ7Sw25yFC4idXYx49DKGqMnyjCJ2
 kIZSMw78eD8s4B4LBroFS5ozA3jLwxiSbqTmx6xCAoUUAdKJgxYzxH59kTELH1t87WgTmml+s2
 xf2saIkFi5jLEdsFGDa4DBVIgb6HagSzUKmV5GzZzrM7URQIraqRiUFNXwe8GWQ/dHBwIn/N2u
 7KoEgQrrsLr6JkPFCt64hCuk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 00:25:46 -0700
IronPort-SDR: +Bh2yLsoIrS4Vo5rs2t1Ncasyk/+FAgq9Rd/MOpoIyaztNsjj4pPwEybVx1gsD9EbPL9hIG6/S
 KPyd1whWQOHPQu7NXbYA8fkacAwelOYyQeDltxpuMA9EzLvt+TU2wBR3y1+3ikozan9rYDRYNE
 0H4skHVgS+iKBv1OBb6/bNYlHWQSWGhNmGujpTzfgIS3XrEAB7akPQIAZ9nx8+LM64Nv/TCOgQ
 kffKW34ututYaNPTowaXQJ3ajrB7BIACibD94egjjTNQlQ6SelJ8TSancjWfemGfGoNiD79tfo
 0Aw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 00:50:16 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Date:   Thu, 12 Aug 2021 16:50:10 +0900
Message-Id: <20210812075015.1090959-1-damien.lemoal@wdc.com>
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

This series adds support the scsi disk driver to retreive this
information and advertize it to user space through sysfs. libata is also
modified to handle ATA drives.

The first patch adds the block layer plumbing to expose concurrent
sector ranges of the device through sysfs as a sub-directory of the
device sysfs queue directory. Patch 2 and 3 add support to sd and
libata. Finally patch 4 documents the sysfs queue attributed changes.
Patch 5 fixes a typo in the document file (strictly speaking, not
related to this series).

This series does not attempt in any way to optimize accesses to
multi-actuator devices (e.g. block IO scheduler or filesystems). This
initial support only exposes the actuators information to user space
through sysfs.

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
  block: Add concurrent positioning ranges support
  scsi: sd: add concurrent positioning ranges support
  libata: support concurrent positioning ranges log
  doc: document sysfs queue/cranges attributes
  doc: Fix typo in request queue sysfs documentation

 Documentation/block/queue-sysfs.rst |  30 ++-
 block/Makefile                      |   2 +-
 block/blk-cranges.c                 | 310 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  26 ++-
 block/blk.h                         |   4 +
 drivers/ata/libata-core.c           |  52 +++++
 drivers/ata/libata-scsi.c           |  48 ++++-
 drivers/scsi/sd.c                   |  81 ++++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  29 +++
 include/linux/libata.h              |  15 ++
 12 files changed, 580 insertions(+), 19 deletions(-)
 create mode 100644 block/blk-cranges.c

-- 
2.31.1


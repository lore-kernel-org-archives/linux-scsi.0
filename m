Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD64C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 01:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B8F606A5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 01:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhGZA5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jul 2021 20:57:41 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5174 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhGZA5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jul 2021 20:57:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627263490; x=1658799490;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+4y6QnO0EX2zdAVAuJf41nc6N7i70ACwJW+ZZfsL8Pk=;
  b=Ws3ZqJbmX238TXZ9UXqiMMFmaqJqrz0rLZIGc7xR4AYAf5/pgavstJVa
   7YSEpMBEfZBZUHXIc3zafVNZk3XbKskXzcYKB0VA9hYbXx6trWMPYbPE3
   od90HINJJGs/EmBCMBLtjCRbByUeT8fVKvxAaJCV0coW2Tpls8glBStsJ
   SxkHr0rnd2lHRM5hLAfSBjuyIVAqbBuYCjrKzl4vlRdiKUdp4mtbCnZQr
   UL65PTdsBzagR3XWQ2A6BFf6n81xdLMnDtIXKas21VNuWSPmy2isyXkCH
   LqjHanfXG/nugxbR21lSXHMdfS67D7iQC7SE6Rm/zOIG9zq5ZCybeOmjp
   w==;
X-IronPort-AV: E=Sophos;i="5.84,269,1620662400"; 
   d="scan'208";a="279290737"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2021 09:38:10 +0800
IronPort-SDR: v0JO29SNne3OFOoCca7jmgwboAnXK/k0xQd1RR3Ed3HQ/qT3p9DfBndOXoyB9HnOSzDkEFhdRY
 D0DtjVbt9q+4eFNJW9fKS9EQxCvrSx9/PEER7TwzbRk2L8GxBEFIiMvujB7f/2PP7KNBaVVeFR
 T0K6ohid7zxB2flf5QFdPlYirMa/6qbsLK0FNbCz2Dpan33XOT1TPSDrmak7pgX3yGnkH3iHMo
 MMPDSw1SvcKlxZ/ntKzpWsr5i4u+btwtOFSHrOiFvecVxEkkOrsnJJZiUf+5roKnrTofsxcUyl
 hpAPxWXVgyVEapsN/3E3pJl6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 18:14:09 -0700
IronPort-SDR: V0fHofpYZ52+ogEe8QsTWdMnQ3+IeHLoMlvKEuAEEnc/ZaXYhT1a/Yr4Rn/Gfj5zJ2s2vjzHXb
 ND0bkfOybERihAIBlMxCgB4GrvEvlYGlV7T4TdFrxg2JuuEIb5sde2IcmVMJBPGYJ65n4BDv5K
 Sm9MjYITO9bKaZATrOhRDyNh0QJljCLiGmdBjZ62IIduQyJfNrnWZVGd5DKjPRBy6z2yPHkHWy
 dHnMfbj7upQqSm2I0mgy8yiPLVyd3fplRZTk1ihj/JHPr/RJHNl2NP01Ezg3pnZSwF+aPSkqz8
 h6I=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 25 Jul 2021 18:38:09 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Date:   Mon, 26 Jul 2021 10:38:02 +0900
Message-Id: <20210726013806.84815-1-damien.lemoal@wdc.com>
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

This series does not attempt in any way to optimize accesses to
multi-actuator devices (e.g. block IO scheduler or filesystems). This
initial support only exposes the actuators information to user space
through sysfs.

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

Damien Le Moal (4):
  block: Add concurrent positioning ranges support
  scsi: sd: add concurrent positioning ranges support
  libata: support concurrent positioning ranges log
  doc: document sysfs queue/cranges attributes

 Documentation/block/queue-sysfs.rst |  30 ++-
 block/Makefile                      |   2 +-
 block/blk-cranges.c                 | 295 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  13 ++
 block/blk.h                         |   3 +
 drivers/ata/libata-core.c           |  52 +++++
 drivers/ata/libata-scsi.c           |  48 ++++-
 drivers/scsi/sd.c                   |  81 ++++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  29 +++
 include/linux/libata.h              |  15 ++
 12 files changed, 559 insertions(+), 11 deletions(-)
 create mode 100644 block/blk-cranges.c

-- 
2.31.1


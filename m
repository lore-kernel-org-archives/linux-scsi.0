Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12838C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD30D61221
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhGUKDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:03:22 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53605 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbhGUKBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 06:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626864137; x=1658400137;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bneDi9dHJOGIRkcB2WJhJfsaHO3P52JDhLKtxKgm0t4=;
  b=oXQBrsYht4sSIHPz903hkd3etg2nerM3vbZOqe1KR1o0cOIVqI6VWOex
   pzl+ODswVjtu2GbgVBZH7Ab84UiW6u6IAFoHD4VrkO3K3dBF8JoMe8Syp
   4/lY2pc+FhYByD5th1aU84xpWqswlcYJbzEdVcB/lAaH1RFRR6shS4A5C
   z7NGO1oBR7+BFynLHVKyZtdHPPleEpF83g4mWXyHFSxw3lZ0aLxsan//Q
   MskQmoadUzkJdJj74iP8/vDpqOY7pVr/68FOu8pc/OW6jlI/OZxmJdUJy
   FpHsnYskU2Tvl7gT+201YhNnBcLJaC/ZsRHNsZhxSYDjtpeH6rJKt0/Id
   A==;
X-IronPort-AV: E=Sophos;i="5.84,257,1620662400"; 
   d="scan'208";a="179944859"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2021 18:42:08 +0800
IronPort-SDR: 75StO+yNg0nFz5qfZiw9VVBZZzorJMFjunXeVEGLiqVmA0pMKXEyDAlCTbMn4yLwYjxZ6PHJYf
 zo7zBfBNKmCadNs8xRZSugU+MZWLuA9YfEfU5BRJHGOaQuqb2iZPHqkLOjl0s6E8WhMlzzZGwz
 VjaxcYPcdCXxcsOfRY2XwiioN1DzyLE/Ctt7ukeFA1jKshmA2hH7iQMEkmzT/MtXg8sXidMg5O
 WzC1j8azysUbvsTt6GWyb0yanGUzHMX6xck+qxzXd09YYHn9VNydU/bIx2M6TJf2w+wvGXpkpZ
 5tSozAuMzxy5eeWNOKOdWi65
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:20:02 -0700
IronPort-SDR: qoIlJGm06X7y1x0YXibHr6XRp378xp3jvPlllfMJpvOaXpXj/PDqZStcauS/RlBKKushxD0zw6
 95032bGd3DEz3zzkOjOqwkTzZ2nYR9yzYxNyyH+D8Pnt3ePlCUw6+jl7M4ZsR2zD1oiXMIS0lh
 SdzTEH/faexg9Vcx6lFPcfWOHINIk7WE4mZvNJLEzavEgEgj4fAWPJI48AEcWOjBzWhrV0Q1n0
 IYkOyPrFq6oxf7pt7CkB37DPzzhSw85+t3pWqDCEo5gIAWMXJZmq1woAXQvy+Y6fk0P807yQdO
 sXs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jul 2021 03:42:08 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 0/4] Initial support for multi-actuator HDDs
Date:   Wed, 21 Jul 2021 19:42:01 +0900
Message-Id: <20210721104205.885115-1-damien.lemoal@wdc.com>
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

Damien Le Moal (4):
  block: Add concurrent positioning ranges support
  scsi: sd: add concurrent positioning ranges support
  libata: support concurrent positioning ranges log
  doc: document sysfs queue/cranges attributes

 Documentation/block/queue-sysfs.rst |  27 ++-
 block/Makefile                      |   2 +-
 block/blk-cranges.c                 | 286 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  13 ++
 block/blk.h                         |   3 +
 drivers/ata/libata-core.c           |  57 ++++++
 drivers/ata/libata-scsi.c           |  47 ++++-
 drivers/scsi/sd.c                   |  80 ++++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  29 +++
 include/linux/libata.h              |  11 ++
 12 files changed, 546 insertions(+), 11 deletions(-)
 create mode 100644 block/blk-cranges.c

-- 
2.31.1


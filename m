Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5C0C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A00A760EB5
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhGWAl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 20:41:28 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48056 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhGWAl2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 20:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627003323; x=1658539323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n7KLZmCSrxd5Wnj/5lIevh5BRKov2S5fgABF77yajfk=;
  b=O+G55DTWhRj93jmAz9sY1SLVhORwxT9eCaP7GWchFPUQugZ6GYQxyZwH
   0oiAGYnMGsgVHXkKdoz3BRhKLEyhWSS8bbkqTHsMcR4qj5qxuFbeWFeSu
   +rsMuOF6XfU/nD1iVFKHYIrxO7SAJ0fvIN39qVU6yrkwBfuQ/Z98qFpwL
   w0iIWBIugQIypbiEsydPoW6WhxCvCRdSLJSGQXAlJyGLPXdZVm0qbR0w9
   PGwphTU2YHPSxztHrevNWHGn3RJeLNA/Og+IZaFm1/DHlsWTf8xY+oEdG
   n8xBb+mShMlgR0hXXMCBVdtA/gYHALG9ZggWtY5AmvBV3+8A+YjSeTN4N
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="175874104"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 09:22:03 +0800
IronPort-SDR: BXhTSQedvwynOkgOi6O8DaVb8IIbcl8H9pJf9O7FPsgRQPZNpevrlrrLhJYFJzVM6JdEhMtf6R
 JYcmNUDLQgW1YImBIkNoVHEr6w0mdaxJ+j+1laEJNGoVY6SqVDOC/Yx8at04OTOP9cQzhPbD7Y
 +b8j8/jc1Jr0K0iQxrFrI0Jb9kwTkVhbvdvXlOnsfgmi8MsAqmU8aKUyuN0fx3PHmp/xT/5teD
 QJVr2PieBULXNAzOrDGKkcL1vLOpciCtt/klUTR5yBRr0bEuOfGPdvaQB8dBaOAHATdEmLYneb
 EQJsqAwnDJa/5bwa6EM35mhm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 17:59:53 -0700
IronPort-SDR: F6TNqktI/n5mepR5Hei2UkYSDjN4Yjk9mpAPvsLOgT6aE9ltz6F5PP09PGqtCoiNkUEhZ3ATXP
 iwzxDDgpJUpdbnRjBiQwfkTOmUmoPjfWb0fTsU+kYb4MlVRi3jPYqXb6EazKyrhcr87fgmtIpk
 uczRy5aI2oUWuS0XXx4UUEYblR8to+8ehsO8dAL1xam4Sx7zQTdpwtr5vg7kmmOz/B+4v4JEkh
 umJmjsbvuE4ZD6LRxgV4BSWB1tp2iQUyiTa05CJs36alBSWDcoRZCFbzzYQfZnXfsYl9yfb7F8
 EWM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 22 Jul 2021 18:22:01 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 0/4] Initial support for multi-actuator HDDs
Date:   Fri, 23 Jul 2021 10:21:56 +0900
Message-Id: <20210723012200.953825-1-damien.lemoal@wdc.com>
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
 block/blk-cranges.c                 | 286 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                   |  13 ++
 block/blk.h                         |   3 +
 drivers/ata/libata-core.c           |  52 +++++
 drivers/ata/libata-scsi.c           |  48 ++++-
 drivers/scsi/sd.c                   |  81 ++++++++
 drivers/scsi/sd.h                   |   1 +
 include/linux/ata.h                 |   1 +
 include/linux/blkdev.h              |  29 +++
 include/linux/libata.h              |  15 ++
 12 files changed, 550 insertions(+), 11 deletions(-)
 create mode 100644 block/blk-cranges.c

-- 
2.31.1


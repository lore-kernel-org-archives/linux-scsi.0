Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEA0C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A697B6056B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHLC1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:27:13 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHLC1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 22:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628735208; x=1660271208;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oyDc3RkVhBAkytz5i1T7Vr3QZ0lcUkXM3PwELPUqjKg=;
  b=ILt6FpwZ8wvayyH8/Uns4x6oAzA5JbdNDgufIdmAmjpE2lXwOwILBEcy
   NCT40OpxHqIT70M8CCfGNu8KF6uEkrHVikAherT6IMsNzLhb0iirix1K8
   pwRzSHMoXcwMcP8Pbm/FcflduhCcIpB6Pwvazal9ACXYskrvnC0+q7m1v
   foYT+QTprVTpskzxMBeanvV4s0ODO2hmLuzIo3W8aGzmnHT3nGTsJVRv7
   PGIofwHAuj0NVOISl9jlNGTBcOZR4dl4ATs71scGp807H3WtPLdcw6AkH
   9cH74zS2msAAxnzJtYLPngLB8+XPMRuPCyUEga6Idjtp6FJeIJ7uoKRNF
   A==;
X-IronPort-AV: E=Sophos;i="5.84,314,1620662400"; 
   d="scan'208";a="280823436"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 10:26:47 +0800
IronPort-SDR: K4IDMOqqRVYdA9knFfcud/MQdjfvXOnVSJcR4YWmkeXxwJ9WjEJetUR3EA4DVQkuqBaLhdpxLj
 XGgoQNoHoUouHv1TouwPdRu+lABjBP0wt/TR3pTiaTr4WazgZ4ZsEUcj/rwcAQN9Z32gticdoL
 iASNSmSy1bgwxBkMZtwt44STmysLlbJhH0mo6+FtAFGYdEdx5Ph9Vouw5G2cXSZcsfwdQFp78Q
 HSws10/Z9L9MNp/5kANldnv8A/R3zOx1HqM1CElzloUhijaM+CfS9jok/4+ZMaaAPOZumypP66
 eZPfzsfFtPyhj2kkS3pOH1F4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 19:04:06 -0700
IronPort-SDR: KV+44CP4TlrGMAu2vQokGzgK1dMAF/Lw80OLF0vmMjyR4SLS48sDRO3k2r6a1NaV2L0aEVni09
 dAzAINK2JNNxPt3Hk+rbnLj7PNG8Oeo7HAcKSIBoDVuKQjkN0TGkybMQJC/uj3n558tMs/nHOa
 XJsMq9wm5rJ6zMMXJfLrfWDGqbSnDyTwZ6tywvBln1aHlF8pbGqYNYIIZUGLCPEn9rdsMiWMJY
 1m4eqsUjcH9empNbbPJqTcQ5P7K/jINawEBuK8Rzx9Zka14OSW0s/mV8hGvWcis9mEMq/skGLn
 95I=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Aug 2021 19:26:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/5] Initial support for multi-actuator HDDs
Date:   Thu, 12 Aug 2021 11:26:21 +0900
Message-Id: <20210812022626.694329-1-damien.lemoal@wdc.com>
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

Damien Le Moal (4):
  block: Add concurrent positioning ranges support
  scsi: sd: add concurrent positioning ranges support
  libata: support concurrent positioning ranges log
  doc: document sysfs queue/cranges attributes

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


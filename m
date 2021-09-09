Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19370C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1FF66101A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbhIICg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:36:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42516 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhIICg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 22:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631154948; x=1662690948;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/znf9iEzwenaftk3SdR34SU5MwZ08E9mWO19CN3LUh4=;
  b=qtesBRYmkmiipn1Vi8ISFVUkKA04OJuw3l+ojQGckUeH1UCXlZ1TgGN2
   eCKc7WZb/z/E7bPju+BIF6urKo1nUcy9a3Q7Hqdzvk1V/VP5d166GVuo2
   9iHvAgtFwt5dHH6+ChhXGQPBgomrOjNnf6fS36FjA1rN0DiTMp/QM/spN
   kw3uETCdjSeqeiZYR79PHJP8cXfoWQh+05CFy1zT3uSC0LZQtEPQ3+2/O
   kXqj/HBBFe2xCACIKUZO39mWt8BlmIjA4LDPejGGW4agFxYdbJgYDexrN
   Q9TzrMijUnixYXn6I+7f0hnwa4D+jDs/5+SPFHL3QjFAmJXBuxGHjKjnK
   A==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="180062204"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 10:35:47 +0800
IronPort-SDR: C6Ufz4HpGfocNwo7oPqDyJwL5TGI7+d/MAo6nKodcjBjhxFlhm1h9sa7JGdTJ21NNK099b25kg
 IR3vvKQoFgJnC61czqMj1UNo5QLdAxgNh90LVpmGiEYsO6chNnnQvUuFjAMnJuhj++gqeGSejE
 q361+SnJ7ze1TucJuRs+fiA/wgIKuLaK3UgKl9Nue1smpUlEIYXtFCG0UaNpY9Ab2T1MsWhu+q
 +7sEiJfqHnQOF4rE3tBzt24SkTEtsOw+RCyCUvFZ4Hteglu4TRgVuELsxmcRAvCGIrTR0+zQTi
 AQSMdP0DFNZGvOVvw7brneLR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 19:12:22 -0700
IronPort-SDR: mTpPHHswIUw/iUIn0Bi73ObE2YAqghhkeQMBtrW69lCA1TVXKfPzAZ3isea+bTy0svJ6MK6t1x
 RmAysEzEBHnPpvOlkVVtf8pJf3j/JqwE0AaNl8WcXSCe5fpAZ6NdknX/jB35eoM12YLEVVVAy+
 inZgTTqjYKwmnomawDzSh16RgSq3bbtihF4t+7UMBrdHsqbpee0+RRzQfD2OMsv8PVOKpiqRtW
 3XeJ7cx/cNXJaLpaHfOeRNTx5v+6qqa8IBzJwBPAhvyLHronHJ2jBmfLu2f4XSvyTUB9ByXzLI
 l2g=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 19:35:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Date:   Thu,  9 Sep 2021 11:35:40 +0900
Message-Id: <20210909023545.1101672-1-damien.lemoal@wdc.com>
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


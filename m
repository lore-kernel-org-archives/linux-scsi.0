Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40487C54EAA
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbjAXTDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjAXTDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:22 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D499E4CE69;
        Tue, 24 Jan 2023 11:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674586997; x=1706122997;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=guJk4kFmS4889CEj1s4MzHf94Zx/hFvYXVh23o9Wfvk=;
  b=Szznpp9tXRqfdYoyGskm61qzQAryRjS3I4OkRQrzclOgjDUbXFO/HLlu
   OnDllgbfbzbiwnhCuhY45FU55w+jHWwaIlP+JrYRTYcxRLbHEm5PVml8C
   6WwqYflSoLtMmKSeSw6yPrNnCeqjZQfgo9YstTm/IE58rSyMymTWcgRIS
   S1qCwHUXFW0sx5y1sU6OYYV8YefVAblnD0dquuzHEXaGARDkitUGAni+1
   XTYOsNocig7QIjc1SL/z8mc+hYDJiuw3kHADmv+WgKGP/4o6ycSZh9tDD
   /J3ZDoJYNWXqD5xFXdwwBSdhcUHjX1/p06tFgXayE9KikuqUiHV5QhNnk
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472917"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:16 +0800
IronPort-SDR: l1m5F3KtmkWV4eL600QabmEL/I8FthKjVsMTJy7iAWKTg0mdxLNwQ9byhGzRCa+ddipK0Tu0TX
 uOYM+gDoR/vxGZsVf/Pmj0FRbBGx7SiAc/QIKisHmBFxWr9xb8+iTni2zroIUJX4bzTdfMbOU0
 R1hpqqCQSQGgp3HIEhAtwqmSDyB+xrLqD0Pfgok407R2Tgkkjf46KNND5P8xT4b4gXcxdsUSrL
 lwO763R48wxCxl+h2QtHrmMMhoMiEI38bNwSNL5lkwzNuAIr4+7wSwGOa/2nO2Oqr3prDX/Dh3
 B4I=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:04 -0800
IronPort-SDR: Fqjm5XE9FjimNASDPQk8tyPfIxFD5ArYfHN2prpNK558BfDc7Td3mJGwiRSk4wqkZIoWE5xLSJ
 9+VnYi06V+l2VeWUkFMoyIWLBGCEboJXqJ6fUaoRE/9C+N6C+nher218jnUXtOKljYsjmq472D
 hA31xzDke9UVC/9QswBscqNP7SYqZUKS/nO8DsJ0O3gy7KlPjip8mJSqkRKv/+mdv5vv8kQyPJ
 OnZPGWd6SY/TVKwRAMdfpXX8WSYgTcYHEZ24/172qPoGkmsYtGQlaKM82dMff7GaN2aE6q3vD1
 MW8=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:14 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 00/18] Add Command Duration Limits support
Date:   Tue, 24 Jan 2023 20:02:46 +0100
Message-Id: <20230124190308.127318-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

This series adds support for Command Duration Limits.
The series is based on linux-next tag: next-20230124
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v3


=================
CDL in ATA / SCSI
=================
Command Duration Limits is defined in:
T13 ATA Command Set - 5 (ACS-5) and
T10 SCSI Primary Commands - 6 (SPC-6) respectively
(a simpler version of CDL is defined in T10 SPC-5).

CDL defines Duration Limits Descriptors (DLD).
7 DLDs for read commands and 7 DLDs for write commands.
Simply put, a DLD contains a limit and a policy.

A command can specify that a certain limit should be applied by setting
the DLD index field (3 bits, so 0-7) in the command itself.

The DLD index points to one of the 7 DLDs.
DLD index 0 means no descriptor, so no limit.
DLD index 1-7 means DLD 1-7.

A DLD can have a few different policies, but the two major ones are:
-Policy 0xF (abort), command will be completed with command aborted error
(ATA) or status CHECK CONDITION (SCSI), with sense data indicating that
the command timed out.
-Policy 0xD (complete-unavailable), command will be completed without
error (ATA) or status GOOD (SCSI), with sense data indicating that the
command timed out. Note that the command will not have transferred any
data to/from the device when the command timed out, even though the
command returned success.

Regardless of the CDL policy, in case of a CDL timeout, the I/O will
result in a -ETIME error to user-space.

The DLDs are defined in the CDL log page(s) and are readable and writable.
For convenience, the kernel provides a sysfs interface for reading the
descriptors. If a user really wants to change the descriptors, they can do
so using a user-space application that sends passthrough commands,
one such application is cdl-tools:
https://github.com/westerndigitalcorporation/cdl-tools


==============================
How to use CDL from user-space
==============================
Since CDL is mutually exclusive with NCQ priority
(see ncq_prio_enable and sas_ncq_prio_enable in
Documentation/ABI/testing/sysfs-block-device),
CDL has to be enabled using:
echo 1 > /sys/block/$bdev/device/duration_limits/enable

In order for user-space to be able to select a specific DLD for an I/O,
we have decided to reuse the I/O priority API.

This means that we introduce a new priority class (IOPRIO_CLASS_DL).
When using this class, the existing I/O priority levels (0-7) directly
indicates the DLD index to use.

By reusing the I/O priority API, the user can both define DLD to use
per AIO (io_uring sqe->ioprio or libaio iocb->aio_reqprio) or per-thread
(ioprio_set()).


=======
Testing
=======
With the following fio patch that simply adds the new priority class:
https://github.com/westerndigitalcorporation/cdl-tools/blob/main/patches/fio-3.29-and-newer/0001-os-linux-Add-IORPIO_CLASS_DL-definition.patch

CDL can be tested using fio, e.g.:
fio --ioengine=io_uring --cmdprio_percentage=10 --cmdprio_class=4 --cmdprio=DLD_index

A simple way to test is to use a DLD with a very short duration limit,
and send large reads. Regardless of the CDL policy, in case of a CDL
timeout, the I/O will result in a -ETIME error to user-space.

We also provide a CDL test suite located in the cdl-tools repo, see:
https://github.com/westerndigitalcorporation/cdl-tools/blob/main/README.md#testing-a-system-command-duration-limits-support


We have tested this patch series using:
-real hardware
-the following QEMU implementation:
https://github.com/floatious/qemu/tree/cdl
(NOTE: the QEMU implementation requires you to define the CDL policy at compile
time, so you currently need to recompile QEMU when switching between policies.)


===================
Further information
===================
For further information about CDL, see Damien's slides:

Presented at SDC 2021:
https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-LeMoal-Be-On-Time-command-duration-limits-Feature-Support-in%20Linux.pdf

Presented at Lund Linux Con 2022:
https://drive.google.com/file/d/1I6ChFc0h4JY9qZdO1bY5oCAdYCSZVqWw/view?usp=sharing


================
Changes since V2
================
-Reordered the patches by subsystem, so that the different subsystem maintainers
 can pick up a single range of patches to their respective tree.
-Dropped extern keyword when modifying SCSI function declarations. (Christoph)
-Renamed flag SCMD_EH_SUCCESS_CMD to SCMD_FORCE_EH_SUCCESS. (Christoph)
-Improved commit message for patch "block: introduce duration-limits priority
 class". (Christoph)
-Added a new patch (10/18) that removes unnecessary !cmd checks. (Christoph)
-Modified ata_eh_request_sense(), instead of taking an extra parameter,
 let the caller set scsicmd->result. (Christoph)
-Dropped the patch that changed ata_scsi_set_sense(), let CDL specific code
 call scsi_build_sense_buffer() directly instead. (Christoph)
-Picked up Reviewed-by tags from Hannes and Christoph.


For older change logs, see previous patch series versions:
https://lore.kernel.org/linux-scsi/20230112140412.667308-1-niklas.cassel@wdc.com/
https://lore.kernel.org/linux-scsi/20221208105947.2399894-1-niklas.cassel@wdc.com/


Kind regards,
Niklas & Damien

Damien Le Moal (12):
  block: introduce duration-limits priority class
  block: introduce BLK_STS_DURATION_LIMIT
  scsi: support retrieving sub-pages of mode pages
  scsi: support service action in scsi_report_opcode()
  scsi: sd: detect support for command duration limits
  scsi: sd: set read/write commands CDL index
  ata: libata: detect support for command duration limits
  ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
  ata: libata-scsi: add support for CDL pages mode sense
  ata: libata: add ATA feature control sub-page translation
  ata: libata: set read/write commands CDL index
  Documentation: sysfs-block-device: document command duration limits

Niklas Cassel (6):
  scsi: core: allow libata to complete successful commands via EH
  scsi: rename and move get_scsi_ml_byte()
  scsi: sd: handle read/write CDL timeout failures
  ata: libata-scsi: remove unnecessary !cmd checks
  ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
  ata: libata: handle completion of CDL commands using policy 0xD

 Documentation/ABI/testing/sysfs-block-device | 150 ++++
 block/bfq-iosched.c                          |  10 +
 block/blk-core.c                             |   3 +
 block/blk-ioprio.c                           |   3 +
 block/ioprio.c                               |   3 +-
 block/mq-deadline.c                          |   1 +
 drivers/ata/libata-core.c                    | 215 ++++-
 drivers/ata/libata-eh.c                      | 130 ++-
 drivers/ata/libata-sata.c                    | 103 ++-
 drivers/ata/libata-scsi.c                    | 371 ++++++--
 drivers/ata/libata.h                         |   2 +-
 drivers/scsi/Makefile                        |   2 +-
 drivers/scsi/scsi.c                          |  28 +-
 drivers/scsi/scsi_error.c                    |  49 +-
 drivers/scsi/scsi_lib.c                      |  15 +-
 drivers/scsi/scsi_priv.h                     |   6 +
 drivers/scsi/scsi_transport_sas.c            |   2 +-
 drivers/scsi/sd.c                            |  37 +-
 drivers/scsi/sd.h                            |  71 ++
 drivers/scsi/sd_cdl.c                        | 894 +++++++++++++++++++
 drivers/scsi/sr.c                            |   2 +-
 include/linux/ata.h                          |  11 +-
 include/linux/blk_types.h                    |   6 +
 include/linux/ioprio.h                       |   2 +-
 include/linux/libata.h                       |  42 +-
 include/scsi/scsi_cmnd.h                     |   5 +
 include/scsi/scsi_device.h                   |  13 +-
 include/uapi/linux/ioprio.h                  |   7 +
 28 files changed, 2039 insertions(+), 144 deletions(-)
 create mode 100644 drivers/scsi/sd_cdl.c

-- 
2.39.1


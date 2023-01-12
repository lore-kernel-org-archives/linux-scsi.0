Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661C9C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjALOGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjALOFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:05:48 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909BA54DB6;
        Thu, 12 Jan 2023 06:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532259; x=1705068259;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CpbcuGbZ/SZvuAKVB3GvV9lEWWiGgJNhrZ1xHm+xV24=;
  b=eatGOBxqSMaL3CZwrWt3aIzP5eRTozNxezWP8wfrV48EjP69+2kWTUU5
   1qkSbpwQId0HeOlb9/bQi38dQHCd5DvQDmmSVqeIUU52rtRxFQs6Fo3qO
   dM4ZnbQk3BC/Rxn0WlWllcZktQO6LmEr3IXAwJiUhK7hLnpz9v6+/UKfI
   A9wbP988Wlp1C1qxQ529lmxitHtYrWTmMN2C/jRoiQTDMjx+++TGQbpj+
   iFAzZ3Hq9i+EtpOriArZZ2PHGTecG8tdAvhLF0K+5z4JwI9ZzYzLrnwrF
   eQphnqJpjPFVS0dEG7JchVH+OYZvS/P0UPQTvx+rg7w4UjoFwIcpFQD8L
   w==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632640"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:19 +0800
IronPort-SDR: MfapPtFeGULbhFSRbbh+POv3aEhRo1N818tHmqhM+qszkDUbuKd85ag2dbtSremhiRfTjEH4Ql
 LUfsmMi5PI8fV7fISq/QSl0ZG42EwF83I+QHv0+/T5gxeWyVBJuKToyCKmge8wz1RtkcUu2FmO
 qiJwmQZ4HkUR+5fGswcNqbBYDHlop+d/h4r64ncrXIgap1Zf7D2E941kjC1nelmzIy3TYOCyMp
 EQazTNDpX4Uw8FiWNC77VIT+JW+NTD7ekRrhfGgwtZZWvVF0qFYYcrb5pZkRxaOL4g01o6+nvp
 +9M=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:22 -0800
IronPort-SDR: EPaRh06m/O/MUHNLQkHrf9fw+MmWRFMMgkHyJZGE1wkRGkKRZcfQDLFrzpzjmNpGMkSINh3C4n
 TjsQCAAovSWtgP2Mqog6KY16cIH8vkJmG2dU5UjC8QT1i2wWQMjjSs13xaVzfoaEnQJ868A/vp
 NrfUIAYH3kxX3YsaTHcj7VbCGilO5keFwJNLSC8Ute9oZQKVPyNhvDSWpMOJnn6dHQIh6MMiy+
 2eGWOb15bmmdg+UHqt2ZYexVCAM+LA/+jX+64kVDBHFZe831COE7j8PGD0S8b1iD4YEKgXriGO
 9b4=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:17 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 00/18] Add Command Duration Limits support
Date:   Thu, 12 Jan 2023 15:03:49 +0100
Message-Id: <20230112140412.667308-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

This series adds support for Command Duration Limits.
The series is based on linux-next tag: next-20230112
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v2


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
Changes since V1
================
-libata patches that were not strictly related to CDL have been dropped,
 as they have already been sent out and been accepted as a separate series:
 https://lore.kernel.org/linux-ide/20221229170005.49118-1-niklas.cassel@wdc.com/
-Sending all patches to all mailing lists (libata,scsi,block), instead of only
 sending the cover letter + relevant patches to each list (Chaitanya Kulkarni).
-Added my Signed-off-by on the patches developed solely by Damien (John Garry).
-Fixed comments on the Documentation (Bagas Sanjaya).
-Renamed SCSI ML helper while moving it (Mike Christie).
-Modified patch 17 ("ata: libata: handle completion of CDL commands using policy
 0xD") to not trigger the libata fast drain timer (which is 2 seconds) while
 scheduling SCSI EH for a CDL command (i.e. while waiting for other commands to
 finish normally). The regular 30 second SCSI timeout is still in place for the
 commands that we are waiting for to finish normally.
-Rebased and resolved merge conflicts in libata introduced by the now accepted
 libata FUA cleanup series.
-Rebased and resolved merge conflicts in bfq-iosched introduced by the now
 accepted BFQ multi actuator series.


Kind regards,
Niklas & Damien

Damien Le Moal (12):
  scsi: support retrieving sub-pages of mode pages
  scsi: support service action in scsi_report_opcode()
  block: introduce duration-limits priority class
  block: introduce BLK_STS_DURATION_LIMIT
  ata: libata: detect support for command duration limits
  ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
  ata: libata-scsi: add support for CDL pages mode sense
  ata: libata: add ATA feature control sub-page translation
  ata: libata: set read/write commands CDL index
  scsi: sd: detect support for command duration limits
  scsi: sd: set read/write commands CDL index
  Documentation: sysfs-block-device: document command duration limits

Niklas Cassel (6):
  ata: libata: allow ata_scsi_set_sense() to not set CHECK_CONDITION
  ata: libata: allow ata_eh_request_sense() to not set CHECK_CONDITION
  scsi: core: allow libata to complete successful commands via EH
  scsi: rename and move get_scsi_ml_byte()
  scsi: sd: handle read/write CDL timeout failures
  ata: libata: handle completion of CDL commands using policy 0xD

 Documentation/ABI/testing/sysfs-block-device | 150 ++++
 block/bfq-iosched.c                          |  10 +
 block/blk-core.c                             |   3 +
 block/blk-ioprio.c                           |   3 +
 block/ioprio.c                               |   3 +-
 block/mq-deadline.c                          |   1 +
 drivers/ata/libata-core.c                    | 215 ++++-
 drivers/ata/libata-eh.c                      | 117 ++-
 drivers/ata/libata-sata.c                    | 104 ++-
 drivers/ata/libata-scsi.c                    | 403 +++++++--
 drivers/ata/libata.h                         |   6 +-
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
 include/scsi/scsi_device.h                   |   8 +-
 include/uapi/linux/ioprio.h                  |   7 +
 28 files changed, 2051 insertions(+), 151 deletions(-)
 create mode 100644 drivers/scsi/sd_cdl.c

-- 
2.39.0


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6E1C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCIVz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCIVz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:28 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89949EE765;
        Thu,  9 Mar 2023 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398926; x=1709934926;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IRBUQr/7nuIPn23czZxNpbmCg/RRCktmc3ZoibdXGAg=;
  b=PlRA105kd0TA9JG1257tBLjBCBjR8RAvXejHb4k9F0j9+11iQy4FCHbP
   YkUa+cEMkgYyK6TSvJN/8HDJlr6ng89JGTvaaxbRgofIryivD5afuzhIa
   YDjV2wZC4ZhKnLSam8wCQ4v01pwOmLn691aWWfEEbgKw7drVdcBmRg96k
   iwmAyuIyOLZiAY3XdCChX2eBPNiObF6GSb62sWt78VW8yki2s2PMoaY8h
   iayRui9S9UOVRk7RLB/0LqAcpc+QNKE38u0mLcOPEqYuglSt8mD9ALSYF
   Q0za/W0NYnEd57jEBpAS5jJkpdmx4BThBmuFgyKm99SP/0LedHeAM2Y8+
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270933"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:24 +0800
IronPort-SDR: 5ITnYOCvLSI5fZPjeIDoaLIZv1vu0GM4LS8cZ8LLDqBBvVHamYl68u//+7Hz4eCcHCN03wjtGB
 w/D+YtuFKqsfYXPKiiul2RMe1VHuTlrlpr+Voc+1sj5EogxQwQ1cxyuwZOWJMN2Ywl+KkIsI6A
 rnLgtIvMsvqDHG72qwILEFU3azW5zLJGxT5vSgNh2C6BmRXmKTP34JNv45wjZt6VAGa64m/MFu
 RyJE0+tU9fV5191HCQHQwZqUjPDqHNISmVDkK5sTjAXp4IPqbYQEWv980Z+rmpWS9kB0QbDY72
 A5A=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:18 -0800
IronPort-SDR: A6gciQK0xeKmFkX4fP53xIE8SHyAIY1tC5nS983dkTUKth9tt/1cFhe1LPYJzTe7/MjxYYFp5F
 wkBt+lgxejiSKy3XxRcKB3Y1q6nG/ugWabjmpVHpq6daxtgF31dxKnsqWTdOV8/xUl09xko9gO
 8+Yf6SkJkXEIgypG1FROhhGgjZjGPPBPTGiXohmwFFaB/MWOrFfxZqYtSGXh+fCxHyTIh3YpmE
 s+rTH77ERVpHmo5cjiMWllMlN1o8Y+B1J+qYoJOsDmP9pQT6g7uErbtBy/OuWEXUs1Cy7CozXw
 kbw=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:23 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 00/19] Add Command Duration Limits support
Date:   Thu,  9 Mar 2023 22:54:52 +0100
Message-Id: <20230309215516.3800571-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

This series adds support for Command Duration Limits.
The series is based on linux tag: v6.3-rc1
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v4


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
Reading and writing the CDL DLDs are outside the scope of the kernel.
If a user wants to read or write the descriptors, they can do so using a
user-space application that sends passthrough commands, such as cdl-tools:
https://github.com/westerndigitalcorporation/cdl-tools/commits/cdl-v4


================================
The introduction of ioprio hints
================================
What the kernel does provide, is a method to let I/O use one of the CDL DLDs
defined in the device. Note that the kernel will simply forward the DLD index
to the device, so the kernel currently does not know, nor does it need to know,
how the DLDs are defined inside the device.

The way that the CDL DLD index is supplied to the kernel is by introducing a
new 10 bit "ioprio hint" field within the existing 16 bit ioprio definition.

Currently, only 6 out of the 16 ioprio bits are in use, the remaining 10 bits
are unused, and are currently explicitly disallowed to be set by the kernel.

For now, we only add ioprio hints representing CDL DLD index 1-7. Additional
ioprio hints for other QoS features could be defined in the future.

A theoretical future work could be to make an I/O scheduler aware of these
hints. E.g. for CDL, an I/O scheduler could make use of the duration limit
in each descriptor, and take that information into account while scheduling
commands. Right now, the ioprio hints will be ignored by the I/O schedulers.


==============================
How to use CDL from user-space
==============================
Since CDL is mutually exclusive with NCQ priority
(see ncq_prio_enable and sas_ncq_prio_enable in
Documentation/ABI/testing/sysfs-block-device),
CDL has to be explicitly enabled using:
echo 1 > /sys/block/$bdev/device/cdl_enable

Since the ioprio hints are supplied through the existing I/O priority API,
it should be simple for an application to make use of the ioprio hints.

It simply has to reuse one of the new macros defined in
include/uapi/linux/ioprio.h: IOPRIO_PRIO_HINT() or IOPRIO_PRIO_VALUE_HINT(),
and supply one of the new hints defined in include/uapi/linux/ioprio.h:
IOPRIO_HINT_DEV_DURATION_LIMIT_[1-7], which indicates that the I/O should
use the corresponding CDL DLD index 1-7.

By reusing the I/O priority API, the user can both define a DLD to use per
AIO (io_uring sqe->ioprio or libaio iocb->aio_reqprio) or per-thread
(ioprio_set()).


=======
Testing
=======
With the following fio patches (authored by Damien):
https://github.com/floatious/fio/commits/cdl-v4

fio adds support for ioprio hints, such that CDL can be tested using e.g.:
fio --ioengine=io_uring --cmdprio_percentage=10 --cmdprio_hint=DLD_index

A simple way to test is to use a DLD with a very short duration limit,
and send large reads. Regardless of the CDL policy, in case of a CDL
timeout, the I/O will result in a -ETIME error to user-space.

We also provide a CDL test suite located in the cdl-tools repo, see:
https://github.com/westerndigitalcorporation/cdl-tools/blob/cdl-v4/README.md#testing-a-system-command-duration-limits-support


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
Changes since V3
================
-Changed user-facing API, instead of introducing a new ioprio class, introduce
 new ioprio hints.
-Dropped sysfs API for reading the DLDs. We can introduce a new block level
 (sysfs) API later on (instead of exposing an API that is tied to ATA/SCSI).
-Picked up Reviewed-by tags from Hannes and Bart.
-Improved commit message for patch "block: introduce BLK_STS_DURATION_LIMIT"
 (thanks Bart).
-Patch "scsi: sd: set read/write commands CDL index" is now split into two
 patches: "scsi: allow enabling and disabling command duration limits" and
 "scsi: sd: set read/write commands CDL index".
-The cdl_enable sysfs attribute is now defined in scsi_sysfs.c instead of sd.c.
 CDL is defined in SPC-6, so the feature is not really unique to disks.


For older change logs, see previous patch series versions:
https://lore.kernel.org/linux-scsi/20230124190308.127318-1-niklas.cassel@wdc.com/
https://lore.kernel.org/linux-scsi/20230112140412.667308-1-niklas.cassel@wdc.com/
https://lore.kernel.org/linux-scsi/20221208105947.2399894-1-niklas.cassel@wdc.com/


Kind regards,
Niklas & Damien

Damien Le Moal (13):
  ioprio: cleanup interface definition
  block: introduce ioprio hints
  block: introduce BLK_STS_DURATION_LIMIT
  scsi: support retrieving sub-pages of mode pages
  scsi: support service action in scsi_report_opcode()
  scsi: detect support for command duration limits
  scsi: allow enabling and disabling command duration limits
  scsi: sd: set read/write commands CDL index
  ata: libata: detect support for command duration limits
  ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
  ata: libata-scsi: add support for CDL pages mode sense
  ata: libata: add ATA feature control sub-page translation
  ata: libata: set read/write commands CDL index

Niklas Cassel (6):
  scsi: core: allow libata to complete successful commands via EH
  scsi: rename and move get_scsi_ml_byte()
  scsi: sd: handle read/write CDL timeout failures
  ata: libata-scsi: remove unnecessary !cmd checks
  ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
  ata: libata: handle completion of CDL commands using policy 0xD

 Documentation/ABI/testing/sysfs-block-device |  22 ++
 block/bfq-iosched.c                          |   8 +-
 block/blk-core.c                             |   3 +
 block/ioprio.c                               |   6 +-
 drivers/ata/libata-core.c                    | 214 ++++++++++-
 drivers/ata/libata-eh.c                      | 130 ++++++-
 drivers/ata/libata-sata.c                    | 103 ++++-
 drivers/ata/libata-scsi.c                    | 371 +++++++++++++++----
 drivers/ata/libata.h                         |   2 +-
 drivers/scsi/scsi.c                          | 171 ++++++++-
 drivers/scsi/scsi_error.c                    |  48 ++-
 drivers/scsi/scsi_lib.c                      |  15 +-
 drivers/scsi/scsi_priv.h                     |   6 +
 drivers/scsi/scsi_scan.c                     |   3 +
 drivers/scsi/scsi_sysfs.c                    |  33 ++
 drivers/scsi/scsi_transport_sas.c            |   2 +-
 drivers/scsi/sd.c                            |  59 ++-
 drivers/scsi/sr.c                            |   2 +-
 include/linux/ata.h                          |  11 +-
 include/linux/blk_types.h                    |   6 +
 include/linux/libata.h                       |  42 ++-
 include/scsi/scsi_cmnd.h                     |   5 +
 include/scsi/scsi_device.h                   |  18 +-
 include/uapi/linux/ioprio.h                  |  68 +++-
 24 files changed, 1195 insertions(+), 153 deletions(-)

-- 
2.39.2


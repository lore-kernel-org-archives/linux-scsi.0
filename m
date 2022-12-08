Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98F2C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiLHLCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLHLBm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:01:42 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA55C41;
        Thu,  8 Dec 2022 03:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497241; x=1702033241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kiFPw97oMlOhbq1kwrootHJ7a+SdW1/7qB+ORfg0Kks=;
  b=LXb8Z+kgJgJ2YPMEomV5y7aJnHTtg/ABp1WGaNEuTnQeWbWHihw6HUPr
   rC+gtMcoU+2s9LyFHvo/gEONKp3Pl/NC5oDTCJ4jiZKSMRAj6L3lGnlwU
   oqjmrSkhKGz42K36B+Y+uCqaJlc5MTTEncT4c/GRJ/ADCy5Lti+kSJ6PT
   I4Bxu+tMv/2tKoQEu58okSaT6Aa/7M5bkIyWZD5S8mHCqLa1ri63Jfy4J
   FaUHIOPuc9RqpjGhIERrIclOlh/PAqQHgwsRxlhMM6SYHJSAZ7Z2/D5DP
   nBl4GF/l+Q65MgBR0Ii8zkz8Dvwj2Vj4Ed8uyF3yTdDGXcxtwyWlkCPVW
   w==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333335"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:00:40 +0800
IronPort-SDR: py+XPYL6woTJI/s/hNeFS8UuOScHVGPIyl05LrK/0JqCarP5aoupbRYLppLCh1rcwD3NisiJY2
 IgEUOANAiJydvPwsaXxvZJ0a69rCB2/tbC8tCuRAMoAwQGU4viANB+1sdKUjWOlvznyKDV6N4w
 ifbnnlnrlLrZmRBDE8oQ1ytjyg3T8ikjhRC2GnhXgd0E4FlD5O3ZWG4JFBVKfbE7Q4pNx98kkN
 bW28LI6FKCOxTqaV3w/kRqESvGl30sl0H4P5EMt7oAiCUWokfOpj0I6CIlgx85iEyjeu+OXsTj
 xqg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:25 -0800
IronPort-SDR: irMqzqPhqy/9UX97tuiWYJwyz7O+TpEVyS4dWfgU6YrjQZdbb98FMnkk+oyubTT4SBJi1/w9tG
 X9Fn5ba2wjSuPwjMMR8np/OJzZ2CgtslCqgcgdRS9vKvT0dp4j0yCcVmeJosbKRfqEdEmyPwtZ
 jucIvh3rz4Pm4nmmXCfg4O8PzBrZwHre/zDq3wjejAXzSaYLrM3cCi2rEWjMkcbdRL+0tt2wum
 yCHQaqyuLqamzlOgDLXkDcZk1n59pUSDa2SQpzU9kZTl/uARAUwwERtq0OmbIRUP8HfBb4qD0c
 aaY=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:00:38 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@us.ibm.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 00/25] Add Command Duration Limits support
Date:   Thu,  8 Dec 2022 11:59:16 +0100
Message-Id: <20221208105947.2399894-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

This series adds support for Command Duration Limits.
The series is based on linux-next tag: next-20221205
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v1


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
DAMIEN: need to change the settings on the repo so that it public


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
fio --cmdprio_percentage=10 --cmdprio_class=4 --cmdprio=DLD_index

A simple way to test is to use a DLD with a very short duration limit,
and send large writes. Regardless of the CDL policy, in case of a CDL
timeout, the I/O will result in a -ETIME error to user-space.

In case of using a SATA drive, you might want to disable the write-cache:
sudo hdparm -W 0 /dev/$bdev


We have tested this patch series using:
-real hardware
-the following QEMU implementation:
https://github.com/floatious/qemu/tree/cdl


===================
Further information
===================
For further information about CDL, see Damien's slides:

Presented at SDC 2021:
https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-LeMoal-Be-On-Time-command-duration-limits-Feature-Support-in%20Linux.pdf

Presented at Lund Linux Con 2022:
https://drive.google.com/file/d/1I6ChFc0h4JY9qZdO1bY5oCAdYCSZVqWw/view?usp=sharing


Kind regards,
Niklas & Damien

Damien Le Moal (14):
  ata: libata: simplify qc_fill_rtf port operation interface
  ata: libata-scsi: improve ata_scsiop_maint_in()
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

Niklas Cassel (11):
  ata: scsi: rename flag ATA_QCFLAG_FAILED to ATA_QCFLAG_EH
  ata: libata: move NCQ related ATA_DFLAGs
  ata: libata: fix broken NCQ command status handling
  ata: libata: respect successfully completed commands during errors
  ata: libata: allow ata_scsi_set_sense() to not set CHECK_CONDITION
  ata: libata: allow ata_eh_request_sense() to not set CHECK_CONDITION
  ata: libata-scsi: do not overwrite SCSI ML and status bytes
  scsi: core: allow libata to complete successful commands via EH
  scsi: move get_scsi_ml_byte() to scsi_priv.h
  scsi: sd: handle read/write CDL timeout failures
  ata: libata: handle completion of CDL commands using policy 0xD

 Documentation/ABI/testing/sysfs-block-device | 143 +++
 block/bfq-iosched.c                          |  10 +
 block/blk-core.c                             |   3 +
 block/blk-ioprio.c                           |   3 +
 block/ioprio.c                               |   3 +-
 block/mq-deadline.c                          |   1 +
 drivers/ata/acard-ahci.c                     |   8 +-
 drivers/ata/libahci.c                        | 171 +++-
 drivers/ata/libata-core.c                    | 219 ++++-
 drivers/ata/libata-eh.c                      | 139 ++-
 drivers/ata/libata-sata.c                    | 111 ++-
 drivers/ata/libata-scsi.c                    | 414 +++++++--
 drivers/ata/libata-sff.c                     |  10 +-
 drivers/ata/libata-trace.c                   |   2 +-
 drivers/ata/libata.h                         |   6 +-
 drivers/ata/sata_fsl.c                       |   5 +-
 drivers/ata/sata_inic162x.c                  |  14 +-
 drivers/ata/sata_promise.c                   |   2 +-
 drivers/ata/sata_sil24.c                     |   7 +-
 drivers/ata/sata_sx4.c                       |   2 +-
 drivers/scsi/Makefile                        |   2 +-
 drivers/scsi/ipr.c                           |  11 +-
 drivers/scsi/libsas/sas_ata.c                |  11 +-
 drivers/scsi/scsi.c                          |  28 +-
 drivers/scsi/scsi_error.c                    |  49 +-
 drivers/scsi/scsi_lib.c                      |  13 +-
 drivers/scsi/scsi_priv.h                     |   6 +
 drivers/scsi/scsi_transport_sas.c            |   2 +-
 drivers/scsi/sd.c                            |  37 +-
 drivers/scsi/sd.h                            |  71 ++
 drivers/scsi/sd_cdl.c                        | 894 +++++++++++++++++++
 drivers/scsi/sr.c                            |   2 +-
 include/linux/ata.h                          |  11 +-
 include/linux/blk_types.h                    |   6 +
 include/linux/ioprio.h                       |   2 +-
 include/linux/libata.h                       |  44 +-
 include/scsi/scsi_cmnd.h                     |   5 +
 include/scsi/scsi_device.h                   |   8 +-
 include/uapi/linux/ioprio.h                  |   7 +
 39 files changed, 2225 insertions(+), 257 deletions(-)
 create mode 100644 drivers/scsi/sd_cdl.c

-- 
2.38.1


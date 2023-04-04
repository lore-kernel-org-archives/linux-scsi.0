Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1630C77B60
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjDDSaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbjDDS3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:29:31 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A20C976D;
        Tue,  4 Apr 2023 11:26:43 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g17so43515219lfv.4;
        Tue, 04 Apr 2023 11:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1TTtKp2Z+Blfgrk+uwE3EJPJkRMhQts//+Oui10tTVg=;
        b=zXty+18gC1Tteo+QSqXnOCpuEvM7uHgym0tA5B6LDIZOhqn67hWAE64X6hsxlpQQqh
         3t/KZvP/os0CTHmC+bz3Fcr576tbYIDJrEMmnlczDVuQ1HGuocmSsJlvgM6qd2+kP3Jd
         smhVOusgSRGWAmGeM66pa2cWS1jn0UkARP7AXXKUq/8uVmBL7sLAuOG/K0XRQRLvHlXS
         pvr1fELsDZY4AB015NAvIKSyuAfqR1Ftxu+wcXE7GmJzQx6Vo4zDwNTS6BHnZH0JyxWc
         HfvZ4P5BE1+REn9XXxqtUn66YgQAlWSzJ8aHGDk0SLEcRFMWoVQNHVD/X7Z/yobOkZ3M
         /Abg==
X-Gm-Message-State: AAQBX9fLrM+bJUCbFDhf2TvazEoHNi4OZxi7M8/oEzSGnL5NhCvHwD9i
        iCjRv//8ZJwgQr4BBgTCfaGdpV8Z5GJdXQ==
X-Google-Smtp-Source: AKy350YFu43lDUaDKcoevMzRnUelaAy16UlFw/E5fyPIZtyuH3cd7zSKSndyVcigtRzBxG4eMVLdlQ==
X-Received: by 2002:ac2:4309:0:b0:4e8:43e2:a8 with SMTP id l9-20020ac24309000000b004e843e200a8mr747953lfh.8.1680632801503;
        Tue, 04 Apr 2023 11:26:41 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id x10-20020ac25dca000000b004e8b90e14a8sm2445047lfq.25.2023.04.04.11.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:26:41 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 3BD042C0; Tue,  4 Apr 2023 20:26:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632800; bh=k/3hp4xLHj15I+ngxCDpdGB/9jBM52Hqdt2qQzDVCCI=;
        h=From:To:Cc:Subject:Date:From;
        b=GiF/tmUBLmTAz94yJOhq9TlMYYLsnNQAC1fOLHG7BeK+HgTevgIklaWi2SKxTbtq5
         j9/4gZ8MJrjKs11SiYUlXsk4I4ud9RlRjay/cH1VQbByf8vBQxHIzP7l5Wdu3wihRs
         HVCIk7xf69ouYI7TJ9l0nhtRoup92TE6QfmXVEZI=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id AC9E82C0;
        Tue,  4 Apr 2023 20:24:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632727; bh=k/3hp4xLHj15I+ngxCDpdGB/9jBM52Hqdt2qQzDVCCI=;
        h=From:To:Cc:Subject:Date:From;
        b=iWktieISVzJKEvOT6y6RayIo8oXNFaGQV/o56MZtiV9upHajPLpHLvT4hbB2kDgsj
         xBMNGX4wLy6p24muRIbtvSgrMEfH18Q6nb3GMuWxM/KYgxJ896Df2Fq/33PsFW987q
         YTHaH9JlO4zefCNdPZDzgFSDQlwvvDvBjzGZpUT8=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 00/19] Add Command Duration Limits support
Date:   Tue,  4 Apr 2023 20:24:05 +0200
Message-Id: <20230404182428.715140-1-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello,

This series adds support for Command Duration Limits.
The series is based on linux tag: v6.3-rc5
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v5


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
With the following fio patches:
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
Changes since V4
================
-Rebased on v6.3-rc5.
-Patch "ata: libata: set read/write commands CDL index" now takes the CDL
 index from the SCSI cdb, instead of looking at the IO prio hint directly.
 In other words, libata will now translate a SCSI passthrough READ_16 and
 WRITE_16 command with a pre-existing CDL index correctly.


For older change logs, see previous patch series versions:
https://lore.kernel.org/linux-scsi/20230309215516.3800571-1-niklas.cassel@wdc.com/
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
 drivers/ata/libata-core.c                    | 204 +++++++++-
 drivers/ata/libata-eh.c                      | 130 ++++++-
 drivers/ata/libata-sata.c                    | 103 ++++-
 drivers/ata/libata-scsi.c                    | 384 +++++++++++++++----
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
 include/linux/libata.h                       |  42 +-
 include/scsi/scsi_cmnd.h                     |   5 +
 include/scsi/scsi_device.h                   |  18 +-
 include/uapi/linux/ioprio.h                  |  68 +++-
 24 files changed, 1201 insertions(+), 150 deletions(-)

-- 
2.39.2


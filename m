Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981B7C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbjEKBP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjEKBP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:15:56 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B8B30FB;
        Wed, 10 May 2023 18:15:48 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2ac7ac8a4ffso86186381fa.0;
        Wed, 10 May 2023 18:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767746; x=1686359746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWw91VHhyGLJrmo/uCAdnNIMKEDS/WMx7m1BQdRRpsM=;
        b=Ey7HRjr2Yvk4VatsP2zX/Ue7MxOUcmpG4CB06hw68KG9xYveXF36dk/BWO/0JEz6Cn
         EbhPP2X+sdU3XrNEqx1biWzFSL/u93ZCaGToCq1U9p9heCazI1NpJMgAwLzZuDuBgX++
         YAI4jE6ChzMaACN2NXAqcl2y9mw2FMAZSiudsSNS+P1tT7ek3WJaeuyhqB6r59+jTX6s
         ri5HCXQHnzDCfqhMRzzviZjtTnWFxJTD/3lMT6gA9Evrfc+lWupCR3zQrKsXIAlFcA3I
         NlxbYWFUQeuRHWQNK4htHCQBNZvPX7iQIoWTKlB3M7rTO/3kMwkwbGGZjJ1H4LbXK7XK
         Z83g==
X-Gm-Message-State: AC+VfDzJHUeKdmFHhMYb2Ep/snmkQyg7hf3b2JAb8iHZSLT6yJ1UNafI
        n98OSm/DPLKNnctNoDJrzN7L+rC7Uhc91jmY
X-Google-Smtp-Source: ACHHUZ4HReG/FlZi2jVPnvhgrC8ezDT09azG2SsMkH0sbVDpY5KIt0luzGbNZRU8DpJAL/Ujs5W6DA==
X-Received: by 2002:a2e:9dca:0:b0:2ac:795a:5a90 with SMTP id x10-20020a2e9dca000000b002ac795a5a90mr2477214ljj.38.1683767745932;
        Wed, 10 May 2023 18:15:45 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id j16-20020a2e8250000000b002ab4ceea005sm2205332ljh.136.2023.05.10.18.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:15:45 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id A18D016FE; Thu, 11 May 2023 03:15:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767744; bh=FIVwQedgnSQEGuL9NAb3djUhipHLn9wImWc188cityE=;
        h=From:To:Cc:Subject:Date:From;
        b=WWE3rpLhNRU5ryDGtQu7TBgxR0HYtaH4o7lUcw5I5bdVBFXiO1IzdbFUZlYsp592y
         bBykQ0KK/gtUi89M2qLeuDvhwjmEC0ocJ7Hx4SM79w/5z8OmDvY6gRSmktWVaEDbzO
         DBzQK/ZRFa1osmohsy2VwRCzK5MlUFFIFB3lxP28=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 1444F3A7;
        Thu, 11 May 2023 03:14:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767676; bh=FIVwQedgnSQEGuL9NAb3djUhipHLn9wImWc188cityE=;
        h=From:To:Cc:Subject:Date:From;
        b=T8u6eykysOE8YWFTFQgy6FhYTRwlr6JdidO18aDx56nuzcxe/wRwwNGkctxm26rLD
         5304EOJ3P+mTCDcxgaWxO6FFU6E/PyEbGCS9EbiSHvR/6j1KfjNcbfCTZccl+OVth3
         3p/x8KN7SobojqV73Qfd72YIMdVnQu1VFI9nql40=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 00/19] Add Command Duration Limits support
Date:   Thu, 11 May 2023 03:13:33 +0200
Message-Id: <20230511011356.227789-1-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello,

This series adds support for Command Duration Limits.
The series is based on linux tag: v6.4-rc1
The series can also be found in git:
https://github.com/floatious/linux/commits/cdl-v7


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
https://github.com/westerndigitalcorporation/cdl-tools


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
https://github.com/floatious/fio/commits/cdl

fio adds support for ioprio hints, such that CDL can be tested using e.g.:
fio --ioengine=io_uring --cmdprio_percentage=10 --cmdprio_hint=DLD_index

A simple way to test is to use a DLD with a very short duration limit,
and send large reads. Regardless of the CDL policy, in case of a CDL
timeout, the I/O will result in a -ETIME error to user-space.

We also provide a CDL test suite located in the cdl-tools repo, see:
https://github.com/westerndigitalcorporation/cdl-tools#testing-a-system-command-duration-limits-support


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
Changes since V6
================
-Rebased series on v6.4-rc1.
-Picked up Reviewed-by tags from Hannes (Thank you Hannes!)
-Picked up Reviewed-by tag from Christoph (Thank you Christoph!)
-Changed KernelVersion from 6.4 to 6.5 for new sysfs attributes.


For older change logs, see previous patch series versions:
https://lore.kernel.org/linux-scsi/20230406113252.41211-1-nks@flawful.org/
https://lore.kernel.org/linux-scsi/20230404182428.715140-1-nks@flawful.org/
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
 drivers/scsi/scsi_sysfs.c                    |  30 ++
 drivers/scsi/scsi_transport_sas.c            |   2 +-
 drivers/scsi/sd.c                            |  59 ++-
 drivers/scsi/sr.c                            |   2 +-
 include/linux/ata.h                          |  11 +-
 include/linux/blk_types.h                    |   6 +
 include/linux/libata.h                       |  42 +-
 include/scsi/scsi_cmnd.h                     |   5 +
 include/scsi/scsi_device.h                   |  18 +-
 include/uapi/linux/ioprio.h                  |  68 +++-
 24 files changed, 1198 insertions(+), 150 deletions(-)

-- 
2.40.1


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18526C77B7F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 04:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbjEKErf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 00:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbjEKErd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 00:47:33 -0400
X-Greylist: delayed 900 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 May 2023 21:47:31 PDT
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4D330EB;
        Wed, 10 May 2023 21:47:31 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 07386E190B;
        Thu, 11 May 2023 04:22:20 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id E4937345A7;
        Thu, 11 May 2023 04:22:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id bh1xQeOrDyaB; Thu, 11 May 2023 04:22:18 +0000 (UTC)
Received: from [192.168.48.17] (host-192.252-165-26.dyn.295.ca [192.252.165.26])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id AD2E6345A5;
        Thu, 11 May 2023 04:22:17 +0000 (UTC)
Message-ID: <b8bd194d-7140-b924-059f-e67636d029a5@interlog.com>
Date:   Thu, 11 May 2023 00:22:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-05-10 21:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello,
> 
> This series adds support for Command Duration Limits.
> The series is based on linux tag: v6.4-rc1
> The series can also be found in git:
> https://github.com/floatious/linux/commits/cdl-v7
> 
> 
> =================
> CDL in ATA / SCSI
> =================
> Command Duration Limits is defined in:
> T13 ATA Command Set - 5 (ACS-5) and
> T10 SCSI Primary Commands - 6 (SPC-6) respectively
> (a simpler version of CDL is defined in T10 SPC-5).
> 
> CDL defines Duration Limits Descriptors (DLD).
> 7 DLDs for read commands and 7 DLDs for write commands.
> Simply put, a DLD contains a limit and a policy.
> 
> A command can specify that a certain limit should be applied by setting
> the DLD index field (3 bits, so 0-7) in the command itself.
> 
> The DLD index points to one of the 7 DLDs.
> DLD index 0 means no descriptor, so no limit.
> DLD index 1-7 means DLD 1-7.
> 
> A DLD can have a few different policies, but the two major ones are:
> -Policy 0xF (abort), command will be completed with command aborted error
> (ATA) or status CHECK CONDITION (SCSI), with sense data indicating that
> the command timed out.
> -Policy 0xD (complete-unavailable), command will be completed without
> error (ATA) or status GOOD (SCSI), with sense data indicating that the
> command timed out. Note that the command will not have transferred any
> data to/from the device when the command timed out, even though the
> command returned success.
> 
> Regardless of the CDL policy, in case of a CDL timeout, the I/O will
> result in a -ETIME error to user-space.
> 
> The DLDs are defined in the CDL log page(s) and are readable and writable.

The above sentence may be correct for ATA disks, but for SCSI disks the CDL log
page is for statistics. Those statistics counters can be reset (to zero) but
are not writable in the normal sense. To "define" (or change from the default
values) CDL settings in SCSI, the CDL _mode_ pages are provided. Confusingly
there are four such mode pages (A, B, T2A and T2B). Which one(s) do you
support/use?

Doug Gilbert

> Reading and writing the CDL DLDs are outside the scope of the kernel.
> If a user wants to read or write the descriptors, they can do so using a
> user-space application that sends passthrough commands, such as cdl-tools:
> https://github.com/westerndigitalcorporation/cdl-tools
> 
> 
> ================================
> The introduction of ioprio hints
> ================================
> What the kernel does provide, is a method to let I/O use one of the CDL DLDs
> defined in the device. Note that the kernel will simply forward the DLD index
> to the device, so the kernel currently does not know, nor does it need to know,
> how the DLDs are defined inside the device.
> 
> The way that the CDL DLD index is supplied to the kernel is by introducing a
> new 10 bit "ioprio hint" field within the existing 16 bit ioprio definition.
> 
> Currently, only 6 out of the 16 ioprio bits are in use, the remaining 10 bits
> are unused, and are currently explicitly disallowed to be set by the kernel.
> 
> For now, we only add ioprio hints representing CDL DLD index 1-7. Additional
> ioprio hints for other QoS features could be defined in the future.
> 
> A theoretical future work could be to make an I/O scheduler aware of these
> hints. E.g. for CDL, an I/O scheduler could make use of the duration limit
> in each descriptor, and take that information into account while scheduling
> commands. Right now, the ioprio hints will be ignored by the I/O schedulers.
> 
> 
> ==============================
> How to use CDL from user-space
> ==============================
> Since CDL is mutually exclusive with NCQ priority
> (see ncq_prio_enable and sas_ncq_prio_enable in
> Documentation/ABI/testing/sysfs-block-device),
> CDL has to be explicitly enabled using:
> echo 1 > /sys/block/$bdev/device/cdl_enable
> 
> Since the ioprio hints are supplied through the existing I/O priority API,
> it should be simple for an application to make use of the ioprio hints.
> 
> It simply has to reuse one of the new macros defined in
> include/uapi/linux/ioprio.h: IOPRIO_PRIO_HINT() or IOPRIO_PRIO_VALUE_HINT(),
> and supply one of the new hints defined in include/uapi/linux/ioprio.h:
> IOPRIO_HINT_DEV_DURATION_LIMIT_[1-7], which indicates that the I/O should
> use the corresponding CDL DLD index 1-7.
> 
> By reusing the I/O priority API, the user can both define a DLD to use per
> AIO (io_uring sqe->ioprio or libaio iocb->aio_reqprio) or per-thread
> (ioprio_set()).
> 
> 
> =======
> Testing
> =======
> With the following fio patches:
> https://github.com/floatious/fio/commits/cdl
> 
> fio adds support for ioprio hints, such that CDL can be tested using e.g.:
> fio --ioengine=io_uring --cmdprio_percentage=10 --cmdprio_hint=DLD_index
> 
> A simple way to test is to use a DLD with a very short duration limit,
> and send large reads. Regardless of the CDL policy, in case of a CDL
> timeout, the I/O will result in a -ETIME error to user-space.
> 
> We also provide a CDL test suite located in the cdl-tools repo, see:
> https://github.com/westerndigitalcorporation/cdl-tools#testing-a-system-command-duration-limits-support
> 
> 
> We have tested this patch series using:
> -real hardware
> -the following QEMU implementation:
> https://github.com/floatious/qemu/tree/cdl
> (NOTE: the QEMU implementation requires you to define the CDL policy at compile
> time, so you currently need to recompile QEMU when switching between policies.)
> 
> 
> ===================
> Further information
> ===================
> For further information about CDL, see Damien's slides:
> 
> Presented at SDC 2021:
> https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-LeMoal-Be-On-Time-command-duration-limits-Feature-Support-in%20Linux.pdf
> 
> Presented at Lund Linux Con 2022:
> https://drive.google.com/file/d/1I6ChFc0h4JY9qZdO1bY5oCAdYCSZVqWw/view?usp=sharing
> 
> 
> ================
> Changes since V6
> ================
> -Rebased series on v6.4-rc1.
> -Picked up Reviewed-by tags from Hannes (Thank you Hannes!)
> -Picked up Reviewed-by tag from Christoph (Thank you Christoph!)
> -Changed KernelVersion from 6.4 to 6.5 for new sysfs attributes.
> 
> 
> For older change logs, see previous patch series versions:
> https://lore.kernel.org/linux-scsi/20230406113252.41211-1-nks@flawful.org/
> https://lore.kernel.org/linux-scsi/20230404182428.715140-1-nks@flawful.org/
> https://lore.kernel.org/linux-scsi/20230309215516.3800571-1-niklas.cassel@wdc.com/
> https://lore.kernel.org/linux-scsi/20230124190308.127318-1-niklas.cassel@wdc.com/
> https://lore.kernel.org/linux-scsi/20230112140412.667308-1-niklas.cassel@wdc.com/
> https://lore.kernel.org/linux-scsi/20221208105947.2399894-1-niklas.cassel@wdc.com/
> 
> 
> Kind regards,
> Niklas & Damien
> 
> Damien Le Moal (13):
>    ioprio: cleanup interface definition
>    block: introduce ioprio hints
>    block: introduce BLK_STS_DURATION_LIMIT
>    scsi: support retrieving sub-pages of mode pages
>    scsi: support service action in scsi_report_opcode()
>    scsi: detect support for command duration limits
>    scsi: allow enabling and disabling command duration limits
>    scsi: sd: set read/write commands CDL index
>    ata: libata: detect support for command duration limits
>    ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
>    ata: libata-scsi: add support for CDL pages mode sense
>    ata: libata: add ATA feature control sub-page translation
>    ata: libata: set read/write commands CDL index
> 
> Niklas Cassel (6):
>    scsi: core: allow libata to complete successful commands via EH
>    scsi: rename and move get_scsi_ml_byte()
>    scsi: sd: handle read/write CDL timeout failures
>    ata: libata-scsi: remove unnecessary !cmd checks
>    ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
>    ata: libata: handle completion of CDL commands using policy 0xD
> 
>   Documentation/ABI/testing/sysfs-block-device |  22 ++
>   block/bfq-iosched.c                          |   8 +-
>   block/blk-core.c                             |   3 +
>   block/ioprio.c                               |   6 +-
>   drivers/ata/libata-core.c                    | 204 +++++++++-
>   drivers/ata/libata-eh.c                      | 130 ++++++-
>   drivers/ata/libata-sata.c                    | 103 ++++-
>   drivers/ata/libata-scsi.c                    | 384 +++++++++++++++----
>   drivers/ata/libata.h                         |   2 +-
>   drivers/scsi/scsi.c                          | 171 ++++++++-
>   drivers/scsi/scsi_error.c                    |  48 ++-
>   drivers/scsi/scsi_lib.c                      |  15 +-
>   drivers/scsi/scsi_priv.h                     |   6 +
>   drivers/scsi/scsi_scan.c                     |   3 +
>   drivers/scsi/scsi_sysfs.c                    |  30 ++
>   drivers/scsi/scsi_transport_sas.c            |   2 +-
>   drivers/scsi/sd.c                            |  59 ++-
>   drivers/scsi/sr.c                            |   2 +-
>   include/linux/ata.h                          |  11 +-
>   include/linux/blk_types.h                    |   6 +
>   include/linux/libata.h                       |  42 +-
>   include/scsi/scsi_cmnd.h                     |   5 +
>   include/scsi/scsi_device.h                   |  18 +-
>   include/uapi/linux/ioprio.h                  |  68 +++-
>   24 files changed, 1198 insertions(+), 150 deletions(-)
> 


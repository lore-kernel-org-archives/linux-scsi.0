Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654F3CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2AC21835
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfJ2BK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 21:10:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47528 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfJ2BK6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Oct 2019 21:10:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 83444204197;
        Tue, 29 Oct 2019 02:10:55 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Src4PM4I7rHq; Tue, 29 Oct 2019 02:10:48 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 62310204163;
        Tue, 29 Oct 2019 02:10:47 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 0/9] Consolidate {get,put}_unaligned_[bl]e24() definitions
To:     Bart Van Assche <bvanassche@acm.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20191028200700.213753-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <21a9443a-b52c-d028-d0a5-2bbc0b4c281a@interlog.com>
Date:   Mon, 28 Oct 2019 21:10:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-28 4:06 p.m., Bart Van Assche wrote:
> Hi Peter,
> 
> This patch series moves the existing {get,put}_unaligned_[bl]e24() definitions
> into include/linux/unaligned/generic.h. This patch series also introduces a function
> for sign-extending 24-bit into 32-bit integers and introduces users for all new
> functions and macros. Please consider this patch series for kernel version v5.5.

And while you are at it, the sg3_utils user space copy of
include/linux/unaligned/*.h (called sg_unaligned.h) has bindings
for 48 bit operations.

Checking my sg3_utils code, in VPD page 0x83 (mandatory device
identification page) the EUI-64 based 16-byte designator has a
6 byte field (the "vendor specific extension identifier").
Also the SET TIMESTAMP and REPORT TIMESTAMP commands have a 6 byte
timestamp field. There are also some attribute pages associated with
the READ ATTRIBUTE command that have 6 byte fields.


A recent trend with the pages returned by the SCSI LOG SENSE command
is to have (big endian) fields whose length (in bytes) is encoded
in the response. I have this function for those:

/* Returns 0 if 'num_bytes' is less than or equal to 0 or greater than
  * 8 (i.e. sizeof(uint64_t)). Else returns result in uint64_t which is
  * an 8 byte unsigned integer. */
static inline uint64_t sg_get_unaligned_be(int num_bytes, const void *p)

And I can see NVMe code in smartmontools using that one:

nvmeprint.cpp:   jrns["eui64"]["ext_id"] =
                                 sg_get_unaligned_be(5, id_ns.eui64 + 3);


Doug Gilbert


> Thanks,
> 
> Bart.
> 
> Bart Van Assche (9):
>    linux/unaligned/byteshift.h: Remove superfluous casts
>    c6x: Include <linux/unaligned/generic.h> instead of duplicating it
>    treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
>    drivers/iio: Sign extend without triggering implementation-defined
>      behavior
>    scsi/st: Use get_unaligned_signed_be24()
>    scsi/trace: Use get_unaligned_be*()
>    arm/ecard: Use get_unaligned_le{16,24}()
>    IB/qib: Sign extend without triggering implementation-defined behavior
>    ASoC/fsl_spdif: Use put_unaligned_be24() instead of open-coding it
> 
>   arch/arm/mach-rpc/ecard.c                     |  18 +--
>   arch/c6x/include/asm/unaligned.h              |  65 +--------
>   .../iio/common/st_sensors/st_sensors_core.c   |   7 +-
>   drivers/infiniband/hw/qib/qib_rc.c            |   2 +-
>   drivers/nvme/host/rdma.c                      |   8 --
>   drivers/nvme/target/rdma.c                    |   6 -
>   drivers/scsi/scsi_trace.c                     | 128 ++++++------------
>   drivers/scsi/st.c                             |   4 +-
>   drivers/usb/gadget/function/f_mass_storage.c  |   1 +
>   drivers/usb/gadget/function/storage_common.h  |   5 -
>   include/linux/unaligned/be_byteshift.h        |   6 +-
>   include/linux/unaligned/generic.h             |  44 ++++++
>   include/linux/unaligned/le_byteshift.h        |   6 +-
>   include/target/target_core_backend.h          |   6 -
>   sound/soc/fsl/fsl_spdif.c                     |   5 +-
>   15 files changed, 103 insertions(+), 208 deletions(-)
> 


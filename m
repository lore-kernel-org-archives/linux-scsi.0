Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BC5C4742C
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 07:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3734920786
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 07:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DtCVoeuL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgKKH2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 02:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKH20 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 02:28:26 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B73FC0613D4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2020 23:28:27 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n15so1270848otl.8
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2020 23:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h/Cku1++groDoIudZSzMGKm2dLSZyb3jfaMxuRhcM44=;
        b=DtCVoeuLQ0cF4bur7H1dmJR67mXXpDZ75psHAIcNKR35IR5/lZlzo9+7iLl7MZ4U+t
         HNGUZk348TQ58/Z8UB/yiSBeuPDLhoPH2OCBSCXdtxcGQMuBIRk6ecvgarUs+qacDbm7
         ZpervRhot+3+XU+NBnyK0Bcksk9OEcKrtmw1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h/Cku1++groDoIudZSzMGKm2dLSZyb3jfaMxuRhcM44=;
        b=DrDsjBtWqfHa7vF/5P7ySYe7MG5OHqIMgL4JlOqqpqGrN22KQ3a74L3KxYhOj6jKha
         NBqHf5FnDJkx/2N4OaM0hVNI12zBjZC6mCwlJb/o5CyI3keakbNUReYOF+kHnGup16YV
         jQWoaEBWk3Z+5KzZHdeup6+jHuIx0NqFSuAyUto33P+kWnWBiUs7Mw/3kTDL/jwnw3kY
         uU3mYVcd20qdVEdWndN6GE7zTPbuw0K33dKFqv7eORDmaLgZVHne46DMHd0kYqpUi7xX
         5ow7gj6ZXk4aDlae5oNUIsQnK2XX/bmKxo1wAl8C4vO/zEyZ2seCqJNnCdqLHUrGK0eP
         CEpA==
X-Gm-Message-State: AOAM530OGKnljCgc3AyUOFV5pQyqVN1XU7u7Lq8pYSmUKlVM08SGrIaR
        j9eeTN95YUTZ/p3UeHjwM9KhUcD29AwtNVjWQAYrQg==
X-Google-Smtp-Source: ABdhPJzEvrRe1WOy4obCtHzIIXRR8Lo1+duzLVyXSxF+9UALAM0sAEzAIXxDRhpRqGq5EF6jQuOzneU4VyRjGbGtjMI=
X-Received: by 2002:a9d:a0d:: with SMTP id 13mr15816351otg.348.1605079706407;
 Tue, 10 Nov 2020 23:28:26 -0800 (PST)
MIME-Version: 1.0
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-18-git-send-email-john.garry@huawei.com>
 <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
 <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com> <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
 <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com> <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
 <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com> <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com> <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com> <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
In-Reply-To: <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Wed, 11 Nov 2020 12:57:59 +0530
Message-ID: <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     John Garry <john.garry@huawei.com>
Cc:     Qian Cai <cai@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com,
        paolo.valente@linaro.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 10, 2020 at 11:12 PM John Garry <john.garry@huawei.com> wrote:
>
> On 09/11/2020 14:05, John Garry wrote:
> > On 09/11/2020 13:39, Qian Cai wrote:
> >>> I suppose I could try do this myself also, but an authentic version
> >>> would be nicer.
> >> The closest one I have here is:
> >> https://cailca.coding.net/public/linux/mm/git/files/master/arm64.confi=
g
> >>
> >> but it only selects the Thunder X2 platform and needs to manually sele=
ct
> >> CONFIG_MEGARAID_SAS=3Dm to start with, but none of arm64 systems here =
have
> >> megaraid_sas.
> >
> > Thanks, I'm confident I can fix it up to get it going on my Huawei arm6=
4
> > D06CS.
> >
> > So that board has a megaraid sas card. In addition, it also has hisi_sa=
s
> > HW, which is another storage controller which we enabled this same
> > feature which is causing the problem.
> >
> > I'll report back when I can.
>
> So I had to hack that arm64 config a bit to get it booting:
> https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.10-me=
garaid-hang
>
> Boot is ok on my board without the megaraid sas card, but includes
> hisi_sas HW (which enables the equivalent option which is exposing the
> problem).
>
> But the board with the megaraid sas boots very slowly, specifically
> around the megaraid sas probe:
>
> : ttyS0 at MMIO 0x3f00002f8 (irq =3D 17, base_baud =3D 115200) is a 16550=
A
> [   50.023726][    T1] printk: console [ttyS0] enabled
> [   50.412597][    T1] megasas: 07.714.04.00-rc1
> [   50.436614][    T5] megaraid_sas 0000:08:00.0: FW now in Ready state
> [   50.450079][    T5] megaraid_sas 0000:08:00.0: 63 bit DMA mask and 63
> bit consistent mask
> [   50.467811][    T5] megaraid_sas 0000:08:00.0: firmware supports msix
>         : (128)
> [   50.845995][    T5] megaraid_sas 0000:08:00.0: requested/available
> msix 128/128
> [   50.861476][    T5] megaraid_sas 0000:08:00.0: current msix/online
> cpus      : (128/128)
> [   50.877616][    T5] megaraid_sas 0000:08:00.0: RDPQ mode     : (enable=
d)
> [   50.891018][    T5] megaraid_sas 0000:08:00.0: Current firmware
> supports maximum commands: 4077       LDIO threshold: 0
> [   51.262942][    T5] megaraid_sas 0000:08:00.0: Performance mode
> :Latency (latency index =3D 1)
> [   51.280749][    T5] megaraid_sas 0000:08:00.0: FW supports sync cache
>         : Yes
> [   51.295451][    T5] megaraid_sas 0000:08:00.0:
> megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
> [   51.387474][    T5] megaraid_sas 0000:08:00.0: FW provided
> supportMaxExtLDs: 1       max_lds: 64
> [   51.404931][    T5] megaraid_sas 0000:08:00.0: controller type
> : MR(2048MB)
> [   51.419616][    T5] megaraid_sas 0000:08:00.0: Online Controller
> Reset(OCR)  : Enabled
> [   51.436132][    T5] megaraid_sas 0000:08:00.0: Secure JBOD support
> : Yes
> [   51.450265][    T5] megaraid_sas 0000:08:00.0: NVMe passthru support
> : Yes
> [   51.464757][    T5] megaraid_sas 0000:08:00.0: FW provided TM
> TaskAbort/Reset timeout        : 6 secs/60 secs
> [   51.484379][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map
> support     : Yes
> [   51.499607][    T5] megaraid_sas 0000:08:00.0: PCI Lane Margining
> support    : No
> [   51.547610][    T5] megaraid_sas 0000:08:00.0: NVME page size
> : (4096)
> [   51.608635][    T5] megaraid_sas 0000:08:00.0:
> megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
> [   51.630285][    T5] megaraid_sas 0000:08:00.0: INIT adapter done
> [   51.649854][    T5] megaraid_sas 0000:08:00.0: pci id
> : (0x1000)/(0x0016)/(0x19e5)/(0xd215)
> [   51.667873][    T5] megaraid_sas 0000:08:00.0: unevenspan support    :=
 no
> [   51.681646][    T5] megaraid_sas 0000:08:00.0: firmware crash dump   :=
 no
> [   51.695596][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map
> : enabled
> [   51.711521][    T5] megaraid_sas 0000:08:00.0: Max firmware commands:
> 4076 shared with nr_hw_queues =3D 127
> [   51.733056][    T5] scsi host0: Avago SAS based MegaRAID driver
> [   65.304363][    T5] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
> MZ7KH1T9 404Q PQ: 0 ANSI: 6
> [   65.392401][    T5] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG
> MZ7KH1T9 404Q PQ: 0 ANSI: 6
> [   79.508307][    T5] scsi 0:0:65:0: Enclosure         HUAWEI
> Expander 12Gx16  131  PQ: 0 ANSI: 6
> [  183.965109][   C14] random: fast init done
>
> Notice the 14 and 104 second delays.
>
> But does boot fully to get to the console. I'll wait for further issues,
> which you guys seem to experience after a while.
>
> Thanks,
> John
"megaraid_sas" driver calls =E2=80=9Cscsi_scan_host()=E2=80=9D to discover =
SCSI
devices. In this failure case, scsi_scan_host() is taking a long time
to complete, hence causing delay in system boot.
With "host_tagset" enabled, scsi_scan_host() takes around 20 mins.
With "host_tagset" disabled, scsi_scan_host() takes upto 5-8 mins.

The scan time depends upon the number of scsi channels and devices per
scsi channel is exposed by LLD.
megaraid_sas driver exposes 4 channels and 128 drives per channel.

Each target scan takes 2 seconds (in case of failure with host_tagset
enabled).  That's why driver load completes after ~20 minutes. See
below:

[  299.725271] kobject: 'target18:0:96': free name
[  301.681267] kobject: 'target18:0:97' (00000000987c7f11):
kobject_cleanup, parent 0000000000000000
[  301.681269] kobject: 'target18:0:97' (00000000987c7f11): calling
ktype release
[  301.681273] kobject: 'target18:0:97': free name
[  303.575268] kobject: 'target18:0:98' (00000000a8c34149):
kobject_cleanup, parent 0000000000000000

In Qian's kernel .config, async scsi scan is disabled so in failure
case SCSI scan type is synchronous.
Below is the stack trace when scsi_scan_host() hangs:

[<0>] __wait_rcu_gp+0x134/0x170
[<0>] synchronize_rcu.part.80+0x53/0x60
[<0>] blk_free_flush_queue+0x12/0x30
[<0>] blk_mq_hw_sysfs_release+0x21/0x70
[<0>] kobject_release+0x46/0x150
[<0>] blk_mq_release+0xb4/0xf0
[<0>] blk_release_queue+0xc4/0x130
[<0>] kobject_release+0x46/0x150
[<0>] scsi_device_dev_release_usercontext+0x194/0x3f0
[<0>] execute_in_process_context+0x22/0xa0
[<0>] device_release+0x2e/0x80
[<0>] kobject_release+0x46/0x150
[<0>] scsi_alloc_sdev+0x2e7/0x310
[<0>] scsi_probe_and_add_lun+0x410/0xbd0
[<0>] __scsi_scan_target+0xf2/0x530
[<0>] scsi_scan_channel.part.7+0x51/0x70
[<0>] scsi_scan_host_selected+0xd4/0x140
[<0>] scsi_scan_host+0x198/0x1c0

This issue hits when lock related debugging is enabled in kernel config.
kernel .config parameters(may be subset of this list) are required to
hit the issue:

CONFIG_PREEMPT_COUNT=3Dy
CONFIG_UNINLINE_SPIN_UNLOCK=3Dy
CONFIG_LOCK_STAT=3Dy
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
CONFIG_DEBUG_RWSEMS=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_DEBUG_LOCKDEP=3Dy
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_TRACE_IRQFLAGS_NMI=3Dy
CONFIG_DEBUG_KOBJECT=3Dy
CONFIG_PROVE_RCU=3Dy
CONFIG_PREEMPTIRQ_TRACEPOINTS=3Dy

When scsi_scan_host() hangs, there are no outstanding IOs with
megaraid_sas driver-firmware stack as SCSI "host_busy" counter and
megaraid_sas driver's internal counter are "0".
Key takeaways:
1. Issue is observed when lock related debugging is enabled so issue
is seen in debug environment.
2. Issue seems to be related to generic shared "host_tagset" code
whenever some kind of kernel debugging is enabled. We do not see an
immediate reason to hide this issue through disabling the
"host_tagset" feature.

John,
Issue may hit on ARM platform too using Qian's .config file with other
adapters (e.g. hisi_sas) as well. So I feel disabling =E2=80=9Chost_tagset=
=E2=80=9D in
megaraid_sas driver will not help.  It requires debugging from the
=E2=80=9CEntire Shared host tag feature=E2=80=9D perspective as scsi_scan_h=
ost()
waittime aggravates when "host_tagset" is enabled. Also, I am doing
parallel debugging and if I find anything useful, I will share.

Qian,
I need full dmesg logs from your setup with
megaraid_sas.host_tagset_enable=3D1 and
megaraid_sas.host_tagset_enable=3D0. Please wait for a long time. I just
want to make sure that whatever you observe is the same as mine.

Thanks,
Sumit

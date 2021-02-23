Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5F5C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 05:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B5464DA8
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 05:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBWFsK convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:48:10 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3032 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhBWFsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 00:48:07 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Dl7M96B29zRHsd;
        Tue, 23 Feb 2021 13:45:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 23 Feb 2021 13:47:24 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 23 Feb 2021 13:47:23 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Tue, 23 Feb 2021 13:47:23 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Topic: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Index: AQHXBcVsHfRcgE5/oku9/SZGNaGMW6pf/eSAgANvFTCAAUnngIAAhmHQ
Date:   Tue, 23 Feb 2021 05:47:23 +0000
Message-ID: <4d2f90d2157045a7b0800a4004f539ba@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com>
 <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au>
 <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com>
 <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au>
In-Reply-To: <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Finn Thain [mailto:fthain@telegraphics.com.au]
> Sent: Tuesday, February 23, 2021 6:25 PM
> To: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
> Cc: tanxiaofei <tanxiaofei@huawei.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; linuxarm@openeuler.org;
> linux-m68k@vger.kernel.org
> Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
> for SCSI drivers
> 
> On Mon, 22 Feb 2021, Song Bao Hua (Barry Song) wrote:
> 
> > > On Thu, 18 Feb 2021, Xiaofei Tan wrote:
> > >
> > > > On 2021/2/9 13:06, Finn Thain wrote:
> > > > > On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > > > >
> > > > > > > On Sun, 7 Feb 2021, Xiaofei Tan wrote:
> > > > > > >
> > > > > > > > Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI
> > > > > > > > drivers. There are no function changes, but may speed up if
> > > > > > > > interrupt happen too often.
> > > > > > >
> > > > > > > This change doesn't necessarily work on platforms that support
> > > > > > > nested interrupts.
> > > > > > >
> > > > > > > Were you able to measure any benefit from this change on some
> > > > > > > other platform?
> > > > > >
> > > > > > I think the code disabling irq in hardIRQ is simply wrong. Since
> > > > > > this commit
> > > > > >
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> ?id=e58aa3d2d0cc
> > > > > > genirq: Run irq handlers with interrupts disabled
> > > > > >
> > > > > > interrupt handlers are definitely running in a irq-disabled
> > > > > > context unless irq handlers enable them explicitly in the
> > > > > > handler to permit other interrupts.
> > > > > >
> > > > >
> > > > > Repeating the same claim does not somehow make it true. If you put
> > > > > your claim to the test, you'll see that that interrupts are not
> > > > > disabled on m68k when interrupt handlers execute.
> > > > >
> > > > > The Interrupt Priority Level (IPL) can prevent any given irq
> > > > > handler from being re-entered, but an irq with a higher priority
> > > > > level may be handled during execution of a lower priority irq
> > > > > handler.
> > > > >
> > > > > sonic_interrupt() uses an irq lock within an interrupt handler to
> > > > > avoid issues relating to this. This kind of locking may be needed
> > > > > in the drivers you are trying to patch. Or it might not.
> > > > > Apparently, no-one has looked.
> > > > >
> > > >
> > > > According to your discussion with Barry, it seems that m68k is a
> > > > little different from other architecture, and this kind of
> > > > modification of this patch cannot be applied to m68k. So, could help
> > > > to point out which driver belong to m68k architecture in this patch
> > > > set of SCSI? I can remove them.
> > > >
> > >
> > > If you would claim that "there are no function changes" in your
> > > patches (as above) then the onus is on you to support that claim.
> > >
> > > I assume that there are some platforms on which your assumptions hold.
> > >
> > > With regard to drivers for those platforms, you might want to explain
> > > why your patches should be applied there, given that the existing code
> > > is superior for being more portable.
> >
> > I don't think it has nothing to do with portability. In the case of
> > sonic_interrupt() you pointed out, on m68k, there is a high-priority
> > interrupt can preempt low-priority interrupt, they will result in access
> > the same critical data. M68K's spin_lock_irqsave() can disable the
> > high-priority interrupt and avoid the race condition of the data. So the
> > case should not be touched. I'd like to accept the reality and leave
> > sonic_interrupt() alone.
> >
> > However, even on m68k, spin_lock_irqsave is not needed for other
> > ordinary cases.
> > If there is no other irq handler coming to access same critical data,
> > it is pointless to hold a redundant irqsave lock in irqhandler even
> > on m68k.
> >
> > In thread contexts, we always need that if an irqhandler can preempt
> > those threads and access the same data. In hardirq, if there is an
> > high-priority which can jump out on m68k to access the critical data
> > which needs protection, we use the spin_lock_irqsave as you have used in
> > sonic_interrupt(). Otherwise, the irqsave is also redundant for m68k.
> >
> > >
> > > > BTW, sonic_interrupt() is from net driver natsemi, right?  It would
> > > > be appreciative if only discuss SCSI drivers in this patch set.
> > > > thanks.
> > > >
> > >
> > > The 'net' subsystem does have some different requirements than the
> > > 'scsi' subsystem. But I don't see how that's relevant. Perhaps you can
> > > explain it. Thanks.
> >
> > The difference is that if there are two co-existing interrupts which can
> > access the same critical data on m68k. I don't think net and scsi
> > matter. What really matters is the specific driver.
> >
> 
> Regarding m68k, your analysis overlooks the timing issue. E.g. patch 11/32
> could be a problem because removing the irqsave would allow PDMA transfers
> to be interrupted. Aside from the timing issues, I agree with your
> analysis above regarding m68k.

You mentioned you need realtime so you want an interrupt to be able to
preempt another one. Now you said you want an interrupt not to be preempted
as it will make a timing issue. If this PDMA transfer will have some problem
when it is preempted, I believe we need some enhanced ways to handle this,
otherwise, once we enable preempt_rt or threaded_irq, it will get the timing
issue. so here it needs a clear comment and IRQF_NO_THREAD if this is the
case.

> 
> With regard to other architectures and platforms, in specific cases, e.g.
> where there's never more than one IRQ involved, then I could agree that
> your assumptions probably hold and an irqsave would be probably redundant.
> 
> When you find a redundant irqsave, to actually patch it would bring a risk
> of regression with little or no reward. It's not my place to veto this
> entire patch series on that basis but IMO this kind of churn is misguided.

Nope.

I would say the real misguidance is that the code adds one lock while it
doesn't need the lock. Easily we can add redundant locks or exaggerate
the coverage range of locks, but the smarter way is that people add
locks only when they really need the lock by considering concurrency and
realtime performance.

Thanks
Barry

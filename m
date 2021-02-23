Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268FBC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 05:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D059D64E58
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 05:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBWF0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:26:03 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:43600 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhBWF0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 00:26:02 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id A09202A0A3;
        Tue, 23 Feb 2021 00:25:16 -0500 (EST)
Date:   Tue, 23 Feb 2021 16:25:15 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
cc:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
 for SCSI drivers
In-Reply-To: <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com>
Message-ID: <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com> <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au> <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > On Thu, 18 Feb 2021, Xiaofei Tan wrote:
> > 
> > > On 2021/2/9 13:06, Finn Thain wrote:
> > > > On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > > >
> > > > > > On Sun, 7 Feb 2021, Xiaofei Tan wrote:
> > > > > >
> > > > > > > Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI 
> > > > > > > drivers. There are no function changes, but may speed up if 
> > > > > > > interrupt happen too often.
> > > > > >
> > > > > > This change doesn't necessarily work on platforms that support 
> > > > > > nested interrupts.
> > > > > >
> > > > > > Were you able to measure any benefit from this change on some 
> > > > > > other platform?
> > > > >
> > > > > I think the code disabling irq in hardIRQ is simply wrong. Since 
> > > > > this commit
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc
> > > > > genirq: Run irq handlers with interrupts disabled
> > > > >
> > > > > interrupt handlers are definitely running in a irq-disabled 
> > > > > context unless irq handlers enable them explicitly in the 
> > > > > handler to permit other interrupts.
> > > > >
> > > >
> > > > Repeating the same claim does not somehow make it true. If you put 
> > > > your claim to the test, you'll see that that interrupts are not 
> > > > disabled on m68k when interrupt handlers execute.
> > > >
> > > > The Interrupt Priority Level (IPL) can prevent any given irq 
> > > > handler from being re-entered, but an irq with a higher priority 
> > > > level may be handled during execution of a lower priority irq 
> > > > handler.
> > > >
> > > > sonic_interrupt() uses an irq lock within an interrupt handler to 
> > > > avoid issues relating to this. This kind of locking may be needed 
> > > > in the drivers you are trying to patch. Or it might not. 
> > > > Apparently, no-one has looked.
> > > >
> > >
> > > According to your discussion with Barry, it seems that m68k is a 
> > > little different from other architecture, and this kind of 
> > > modification of this patch cannot be applied to m68k. So, could help 
> > > to point out which driver belong to m68k architecture in this patch 
> > > set of SCSI? I can remove them.
> > >
> > 
> > If you would claim that "there are no function changes" in your 
> > patches (as above) then the onus is on you to support that claim.
> > 
> > I assume that there are some platforms on which your assumptions hold.
> > 
> > With regard to drivers for those platforms, you might want to explain 
> > why your patches should be applied there, given that the existing code 
> > is superior for being more portable.
> 
> I don't think it has nothing to do with portability. In the case of 
> sonic_interrupt() you pointed out, on m68k, there is a high-priority 
> interrupt can preempt low-priority interrupt, they will result in access 
> the same critical data. M68K's spin_lock_irqsave() can disable the 
> high-priority interrupt and avoid the race condition of the data. So the 
> case should not be touched. I'd like to accept the reality and leave 
> sonic_interrupt() alone.
> 
> However, even on m68k, spin_lock_irqsave is not needed for other
> ordinary cases.
> If there is no other irq handler coming to access same critical data,
> it is pointless to hold a redundant irqsave lock in irqhandler even
> on m68k.
> 
> In thread contexts, we always need that if an irqhandler can preempt 
> those threads and access the same data. In hardirq, if there is an 
> high-priority which can jump out on m68k to access the critical data 
> which needs protection, we use the spin_lock_irqsave as you have used in 
> sonic_interrupt(). Otherwise, the irqsave is also redundant for m68k.
> 
> > 
> > > BTW, sonic_interrupt() is from net driver natsemi, right?  It would 
> > > be appreciative if only discuss SCSI drivers in this patch set. 
> > > thanks.
> > >
> > 
> > The 'net' subsystem does have some different requirements than the 
> > 'scsi' subsystem. But I don't see how that's relevant. Perhaps you can 
> > explain it. Thanks.
> 
> The difference is that if there are two co-existing interrupts which can 
> access the same critical data on m68k. I don't think net and scsi 
> matter. What really matters is the specific driver.
> 

Regarding m68k, your analysis overlooks the timing issue. E.g. patch 11/32 
could be a problem because removing the irqsave would allow PDMA transfers 
to be interrupted. Aside from the timing issues, I agree with your 
analysis above regarding m68k.

With regard to other architectures and platforms, in specific cases, e.g. 
where there's never more than one IRQ involved, then I could agree that 
your assumptions probably hold and an irqsave would be probably redundant.

When you find a redundant irqsave, to actually patch it would bring a risk 
of regression with little or no reward. It's not my place to veto this 
entire patch series on that basis but IMO this kind of churn is misguided.

> Thanks
> Barry
> 
> 

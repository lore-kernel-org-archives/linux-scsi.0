Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB40C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08ED64E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhBJEPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:15:04 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50224 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBJEPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:15:03 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id D343529E88;
        Tue,  9 Feb 2021 23:14:18 -0500 (EST)
Date:   Wed, 10 Feb 2021 15:14:23 +1100 (AEDT)
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
In-Reply-To: <4ee3b4fa65ee4773aa520c192b262dbb@hisilicon.com>
Message-ID: <20566af-7043-89b-a020-117696aed66b@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <6712a7f16b99489db2828098dc3e03b2@hisilicon.com> <968b5f7a-5375-f0c6-c8c4-26ea6dabd9d1@telegraphics.com.au> <4ee3b4fa65ee4773aa520c192b262dbb@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > 
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
> > > > >
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc 
> > > > > genirq: Run irq handlers with interrupts disabled
> > > > >
> > > > > interrupt handlers are definitely running in a irq-disabled 
> > > > > context unless irq handlers enable them explicitly in the 
> > > > > handler to permit other interrupts.
> > > > >
> > > >
> > > > Repeating the same claim does not somehow make it true.
> > >
> > > Sorry for I didn't realize xiaofei had replied.
> > >
> > 
> > I was referring to the claim in patch 00/32, i.e. that interrupt 
> > handlers only run when irqs are disabled.
> > 
> > > > If you put your claim to the test, you'll see that that interrupts 
> > > > are not disabled on m68k when interrupt handlers execute.
> > >
> > > Sounds like an implementation issue of m68k since IRQF_DISABLED has 
> > > been totally removed.
> > >
> > 
> > It's true that IRQF_DISABLED could be used to avoid the need for irq 
> > locks in interrupt handlers. So, if you want to remove irq locks from 
> > interrupt handlers, today you can't use IRQF_DISABLED to help you. So 
> > what?
> > 
> > > >
> > > > The Interrupt Priority Level (IPL) can prevent any given irq 
> > > > handler from being re-entered, but an irq with a higher priority 
> > > > level may be handled during execution of a lower priority irq 
> > > > handler.
> > > >
> > >
> > > We used to have IRQF_DISABLED to support so-called "fast interrupt" 
> > > to avoid this.
> > >
> > > But the concept has been totally removed. That is interesting if 
> > > m68k still has this issue.
> > >
> > 
> > Prioritized interrupts are beneficial. Why would you want to avoid 
> > them?
> > 
> 
> I doubt this is true as it has been already thought as unnecessary
> in Linux:
> https://lwn.net/Articles/380931/
>

The article you cited does not refute what I said about prioritized 
interrupts.

The article is about eliminating the distinction between fast and slow 
interrupt handlers.

The article says that some developers convinced Linus that, although 
minimal interrupt latency is desirable, is isn't strictly necessary.

The article also warns of stack overflow from arbitrarily deep slow 
interrupt nesting, but that's not what m68k does.

> > Moreover, there's no reason to believe that m68k is the only platform 
> > that supports nested interrupts.
> 
> I doubt that is true as genirq is running understand the consumption
> that hardIRQ is running in irq-disabled context:

I'm not going to guess whether other platforms might be affected -- you're 
supporting this patch so you will have to show that it is correct.

> "We run all handlers with interrupts disabled and expect them not to
> enable them. Warn when we catch one who does."
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b738a50a
> 
> If it is, m68k is against the assumption of genirq.
> 

Interrupt handlers on m68k do not enable interrupts. If they did, you 
would see that warning fire. It doesn't fire. Try it.

> > 
> > > > sonic_interrupt() uses an irq lock within an interrupt handler to
> > > > avoid issues relating to this. This kind of locking may be needed in
> > > > the drivers you are trying to patch. Or it might not. Apparently,
> > > > no-one has looked.
> > >
> 
> Thanks
> Barry
> 

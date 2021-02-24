Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15240C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2AE64E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhBXFVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:21:39 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:45274 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhBXFVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 00:21:38 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id D1C9C29B6A;
        Wed, 24 Feb 2021 00:20:53 -0500 (EST)
Date:   Wed, 24 Feb 2021 16:20:54 +1100 (AEDT)
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
In-Reply-To: <4d2f90d2157045a7b0800a4004f539ba@hisilicon.com>
Message-ID: <7293ba4c-c5ab-528f-1feb-dc59bfb0df2d@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com> <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au> <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com> <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au>
 <4d2f90d2157045a7b0800a4004f539ba@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > 
> > Regarding m68k, your analysis overlooks the timing issue. E.g. patch 
> > 11/32 could be a problem because removing the irqsave would allow PDMA 
> > transfers to be interrupted. Aside from the timing issues, I agree 
> > with your analysis above regarding m68k.
> 
> You mentioned you need realtime so you want an interrupt to be able to 
> preempt another one.

That's not what I said. But for the sake of discussion, yes, I do know 
people who run Linux on ARM hardware (if Android vendor kernels can be 
called "Linux") and who would benefit from realtime support on those 
devices.

> Now you said you want an interrupt not to be preempted as it will make a 
> timing issue.

mac_esp deliberately constrains segment sizes so that it can harmlessly 
disable interrupts for the duration of the transfer.

Maybe the irqsave in this driver is over-cautious. Who knows? The PDMA 
timing problem relates to SCSI bus signalling and the tolerance of real-
world SCSI devices to same. The other problem is that the PDMA logic 
circuit is undocumented hardware. So there may be further timing 
requirements lurking there. Therefore, patch 11/32 is too risky.

> If this PDMA transfer will have some problem when it is preempted, I 
> believe we need some enhanced ways to handle this, otherwise, once we 
> enable preempt_rt or threaded_irq, it will get the timing issue. so here 
> it needs a clear comment and IRQF_NO_THREAD if this is the case.
> 

People who require fast response times cannot expect random drivers or 
platforms to meet such requirements. I fear you may be asking too much 
from Mac Quadra machines.

> > 
> > With regard to other architectures and platforms, in specific cases, 
> > e.g. where there's never more than one IRQ involved, then I could 
> > agree that your assumptions probably hold and an irqsave would be 
> > probably redundant.
> > 
> > When you find a redundant irqsave, to actually patch it would bring a 
> > risk of regression with little or no reward. It's not my place to veto 
> > this entire patch series on that basis but IMO this kind of churn is 
> > misguided.
> 
> Nope.
> 
> I would say the real misguidance is that the code adds one lock while it 
> doesn't need the lock. Easily we can add redundant locks or exaggerate 
> the coverage range of locks, but the smarter way is that people add 
> locks only when they really need the lock by considering concurrency and 
> realtime performance.
> 

You appear to be debating a strawman. No-one is advocating excessive 
locking in new code.

> Thanks
> Barry
> 

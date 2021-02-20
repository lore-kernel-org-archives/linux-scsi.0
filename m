Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9D5C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 05:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86AEA64E4E
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 05:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhBTFSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 00:18:55 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35632 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhBTFSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 00:18:54 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id CE37828237;
        Sat, 20 Feb 2021 00:18:03 -0500 (EST)
Date:   Sat, 20 Feb 2021 16:18:07 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Xiaofei Tan <tanxiaofei@huawei.com>
cc:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        linux-m68k@vger.kernel.org
Subject: Re: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
 for SCSI drivers
In-Reply-To: <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com>
Message-ID: <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Feb 2021, Xiaofei Tan wrote:

> On 2021/2/9 13:06, Finn Thain wrote:
> > On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
> > 
> > > > On Sun, 7 Feb 2021, Xiaofei Tan wrote:
> > > > 
> > > > > Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI 
> > > > > drivers. There are no function changes, but may speed up if 
> > > > > interrupt happen too often.
> > > > 
> > > > This change doesn't necessarily work on platforms that support 
> > > > nested interrupts.
> > > > 
> > > > Were you able to measure any benefit from this change on some 
> > > > other platform?
> > > 
> > > I think the code disabling irq in hardIRQ is simply wrong.
> > > Since this commit
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc
> > > genirq: Run irq handlers with interrupts disabled
> > > 
> > > interrupt handlers are definitely running in a irq-disabled context
> > > unless irq handlers enable them explicitly in the handler to permit
> > > other interrupts.
> > > 
> > 
> > Repeating the same claim does not somehow make it true. If you put 
> > your claim to the test, you'll see that that interrupts are not 
> > disabled on m68k when interrupt handlers execute.
> > 
> > The Interrupt Priority Level (IPL) can prevent any given irq handler 
> > from being re-entered, but an irq with a higher priority level may be 
> > handled during execution of a lower priority irq handler.
> > 
> > sonic_interrupt() uses an irq lock within an interrupt handler to 
> > avoid issues relating to this. This kind of locking may be needed in 
> > the drivers you are trying to patch. Or it might not. Apparently, 
> > no-one has looked.
> > 
> 
> According to your discussion with Barry, it seems that m68k is a little 
> different from other architecture, and this kind of modification of this 
> patch cannot be applied to m68k. So, could help to point out which 
> driver belong to m68k architecture in this patch set of SCSI? I can 
> remove them.
> 

If you would claim that "there are no function changes" in your patches 
(as above) then the onus is on you to support that claim.

I assume that there are some platforms on which your assumptions hold.

With regard to drivers for those platforms, you might want to explain why 
your patches should be applied there, given that the existing code is 
superior for being more portable.

> BTW, sonic_interrupt() is from net driver natsemi, right?  It would be 
> appreciative if only discuss SCSI drivers in this patch set. thanks.
> 

The 'net' subsystem does have some different requirements than the 'scsi' 
subsystem. But I don't see how that's relevant. Perhaps you can explain 
it. Thanks.

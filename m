Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5388C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B08164E3E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBJEQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:16:42 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50308 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBJEQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:16:40 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 96DAC29E88;
        Tue,  9 Feb 2021 23:15:58 -0500 (EST)
Date:   Wed, 10 Feb 2021 15:16:03 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
cc:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage optimization
 for SCSI drivers
In-Reply-To: <88d26bd86c314e5483ec596952054be7@hisilicon.com>
Message-ID: <da111631-83ef-1ad8-799a-5d976d5759d@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au> 
 <88d26bd86c314e5483ec596952054be7@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:

> > > sonic_interrupt() uses an irq lock within an interrupt handler to 
> > > avoid issues relating to this. This kind of locking may be needed in 
> > > the drivers you are trying to patch. Or it might not. Apparently, 
> > > no-one has looked.
> 
> Is the comment in sonic_interrupt() outdated according to this:
> m68k: irq: Remove IRQF_DISABLED
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=77a4279
> http://lkml.iu.edu/hypermail/linux/kernel/1109.2/01687.html
> 

The removal of IRQF_DISABLED isn't relevant to this driver. Commit 
77a42796786c ("m68k: Remove deprecated IRQF_DISABLED") did not disable 
interrupts, it just removed some code to enable them.

The code and comments in sonic_interrupt() are correct. You can confirm 
this for yourself quite easily using QEMU and a cross-compiler.

> and this:
> genirq: Warn when handler enables interrupts
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b738a50a
> 
> wouldn't genirq report a warning on m68k?
> 

There is no warning from m68k builds. That's because arch_irqs_disabled() 
returns true when the IPL is non-zero.

> > 
> > Thanks
> > Barry
> 
> Thanks
> Barry
> 
> 

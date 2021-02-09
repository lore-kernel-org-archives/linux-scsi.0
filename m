Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_TONAME_EQ_TOLOCAL_HDRS_LCASE,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BFCC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48BFB64EAA
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhBIFMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 00:12:36 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50874 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhBIFMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 00:12:21 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id A65662B3DE;
        Tue,  9 Feb 2021 00:11:36 -0500 (EST)
Date:   Tue, 9 Feb 2021 16:11:40 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     tanxiaofei <tanxiaofei@huawei.com>
cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH for-next 00/32] spin lock usage optimization for SCSI
 drivers
In-Reply-To: <a555f4b2-4df9-7bf4-e76c-3556d5ccb4ff@huawei.com>
Message-ID: <e18f571-d848-84a-13e5-47315c2a5f5@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <a555f4b2-4df9-7bf4-e76c-3556d5ccb4ff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Feb 2021, tanxiaofei wrote:

> Hi Finn,
> Thanks for reviewing the patch set.
> 
> On 2021/2/8 15:57, Finn Thain wrote:
> > On Sun, 7 Feb 2021, Xiaofei Tan wrote:
> > 
> > > Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
> > > There are no function changes, but may speed up if interrupt happen too
> > > often.
> > 
> > This change doesn't necessarily work on platforms that support nested
> > interrupts.
> > 
> 
> Linux doesn't support nested interrupts anymore after the following 
> patch, so please don't worry this.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc
> 

Clearly that patch did not disable interrupts. It removed a statement that 
enabled them.

> > Were you able to measure any benefit from this change on some other 
> > platform?
> > 
> 
> It's hard to measure the benefit of this change. 

It's hard to see any benefit. But it's easy to see risk, when there's no 
indication that you've confirmed that the affected drivers do not rely on 
the irq lock, nor tested them for regressions, nor checked whether the 
affected platforms meet your assumuptions.

> Hmm, you could take this patch set as cleanup. thanks.
> 

A "cleanup" does not change program behaviour. Can you demonstrate that 
program behaviour is unchanged?

> > Please see also,
> > https://lore.kernel.org/linux-scsi/89c5cb05cb844939ae684db0077f675f@h3c.com/
> > 
> > .
> > 
> 
> 

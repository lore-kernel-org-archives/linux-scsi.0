Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D6FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 11:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6ED760F4F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 11:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhJYLlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 07:41:40 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51052 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232967AbhJYLli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 07:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635161956;
        bh=p+az3OvBrOIPQBWOo7u8s1OubNSQmhmDFk1qfzBLanY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=jJLCf9+ev4wRzgBuTw+xu2oz9I+UypwZykx4v79/sRg+0FqMj+dQdxI4Re53fD4jH
         VKwRIJaBdSjrS1tEzPJJHBfHE4KjFpyvAXeIHGPHX/iq52kejVi4ELCsp8eOifuFt+
         R1ScHPCamG9grCGsRACCIJ2Xe06vS/unvAka4rI0=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 16FA51280597;
        Mon, 25 Oct 2021 07:39:16 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i56CYmEQW6W1; Mon, 25 Oct 2021 07:39:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635161955;
        bh=p+az3OvBrOIPQBWOo7u8s1OubNSQmhmDFk1qfzBLanY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=JhIUDxjILuTh2xRX+fw/UVoT5DQDuCi3XXjy6htkoHm4fzj/C4jL3c7ysVk5tlYBm
         Z5/5QWOHr41BZiPZbFcomL+t26fPX9VL4hgXp6P5bGreE2pDfas4qTEHLWVCKrg0of
         OsKF06mI+hj9U3WfvTEELDi6i0JU7xbF/2C6txRg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3EB9D1280518;
        Mon, 25 Oct 2021 07:39:15 -0400 (EDT)
Message-ID: <ac5c6248cfd73af5306c109be03adc320bb7d83f.camel@HansenPartnership.com>
Subject: Re: please revert the UFS HPB support
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     daejun7.park@samsung.com, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Mon, 25 Oct 2021 07:39:14 -0400
In-Reply-To: <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
References: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com>
         <20211021144210.GA28195@lst.de>
         <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
         <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de>
         <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
         <CGME20211023154316epcas2p208f95cf1e4a87a4b61d2daf1a2b3c725@epcms2p3>
         <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-10-25 at 14:16 +0900, Daejun Park wrote:
> > On Thu, 2021-10-21 at 09:22 -0700, Bart Van Assche wrote:
> > > On 10/21/21 8:17 AM, Christoph Hellwig wrote:
> > > > On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig
> > > > wrote:
> > > > > > > I just noticed the UFS HPB support landed in 5.15, and
> > > > > > > just as before it is completely broken by allocating
> > > > > > > another request on the same device and then reinserting
> > > > > > > it in the queue.  It is bad enough that we have to live
> > > > > > > with blk_insert_cloned_request for dm-mpath, but this is
> > > > > > > too big of an API abuse to make it into a release.  We
> > > > > > > need to drop this code ASAP, and I can prepare a patch
> > > > > > > for that.
> > > > > > 
> > > > > > That sounds awful, do you have a link to the offending
> > > > > > commit(s)?
> > > > > 
> > > > > I'll need to look for it, busy in calls right now, but just
> > > > > grep for blk_insert_cloned_request.
> > > > 
> > > > Might as well finish the git blame:
> > > > 
> > > > commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
> > > > Author: Daejun Park <daejun7.park@samsung.com>
> > > > Date:   Mon Jul 12 18:00:25 2021 +0900
> > > > 
> > > >      scsi: ufs: ufshpb: Add HPB 2.0 support
> > > >          
> > > >      Version 2.0 of HBP supports reads of varying sizes from
> > > > 4KB to 1MB.
> > > > 
> > > >      A read operation <= 32KB is supported as single HPB read.
> > > > A read between
> > > >      36KB and 1MB is supported by a combination of write buffer
> > > > command and HPB
> > > >      read command to deliver more PPN. The write buffer
> > > > commands may not be
> > > >      issued immediately due to busy tags. To use HPB read more
> > > > aggressively, the
> > > >      driver can requeue the write buffer command. The requeue
> > > > threshold is
> > > >      implemented as timeout and can be modified with
> > > > requeue_timeout_ms entry in
> > > >      sysfs.
> > > 
> > > (+Daejun)
> > > 
> > > Daejun, can the HPB code be reworked such that it does not use 
> > > blk_insert_cloned_request()? I'm concerned that if the HPB code
> > > is not reworked that it will be removed from the upstream kernel.
> >  
> > Just to give urgency to Bart's request: we have two or three weeks
> > before the kernel is due to go final.  Can the problems identified
> > by Christoph be fixed within that timeframe?
> 
> I'm checking to see if I can replace blk_execute_rq_nowait with
> blk_insert_cloned_request in the HPB code.

That's not going to help: removing blk_insert_cloned_request() is what
we need.
 
> > Specifically, looking at the paper you reference, it only uses READ
> > BUFFER for the host cache sharing.  Since the JDEC standard appears
> > to be proprietary, I have no method of understanding why the driver
> > now uses WRITE BUFFER as well, but it appears to be a simple
> > optimization.  If you can cut out the WRITE BUFFER code,
> > blk_insert_cloned_request() will also be gone and thus the API
> > abuse.  Can you get us a simple patch doing this ASAP so we don't
> > have to revert the driver?
> 
> If WRITE BUFFER is not used, only READs with a size of 32KB or less
> can be changed to HPB READs. This becomes a limiting factor in how
> READ performance can be improved by the HPB.

Well, precisely: it's an optimization.  It can be removed now and you
can work out how to add the code back without the problem API later. 
We're running critically short of time to fix this, so unless you have
a different proposal, it's either this hunk of code or the entire
driver.

James



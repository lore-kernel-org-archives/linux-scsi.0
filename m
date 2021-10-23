Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B885FC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 15:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A098B6108D
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 15:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhJWPpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Oct 2021 11:45:32 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:50666 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhJWPpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Oct 2021 11:45:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635003792;
        bh=Z6K7LTvBRIJIb0g/+eF6LqIR9On0z/f56XxFPFMQiWY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aL8ymHXZUUKeU0G5rFeg9R5eN6SbAHNeSTiM7nPDjW3PN6IttfMyfKo1HvrxCvaDJ
         /AwGoyP6x2VkMBw+SBB1hH3b6cKTXmF33zaATtw2H4wFcNCAj/SvsmeysP+a58B9uF
         8EDkb1GaXE7edRJrf1mg9aaYGcrP6ngJE6FpFxZ4=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7970D12805A8;
        Sat, 23 Oct 2021 11:43:12 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Etrgv-_yR2Hh; Sat, 23 Oct 2021 11:43:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635003792;
        bh=Z6K7LTvBRIJIb0g/+eF6LqIR9On0z/f56XxFPFMQiWY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aL8ymHXZUUKeU0G5rFeg9R5eN6SbAHNeSTiM7nPDjW3PN6IttfMyfKo1HvrxCvaDJ
         /AwGoyP6x2VkMBw+SBB1hH3b6cKTXmF33zaATtw2H4wFcNCAj/SvsmeysP+a58B9uF
         8EDkb1GaXE7edRJrf1mg9aaYGcrP6ngJE6FpFxZ4=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C1C1312801A1;
        Sat, 23 Oct 2021 11:43:10 -0400 (EDT)
Message-ID: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com>
Subject: Re: please revert the UFS HPB support
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Sat, 23 Oct 2021 11:43:09 -0400
In-Reply-To: <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
References: <20211021144210.GA28195@lst.de>
         <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
         <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de>
         <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-10-21 at 09:22 -0700, Bart Van Assche wrote:
> On 10/21/21 8:17 AM, Christoph Hellwig wrote:
> > On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
> > > > > I just noticed the UFS HPB support landed in 5.15, and just
> > > > > as before it is completely broken by allocating another
> > > > > request on the same device and then reinserting it in the
> > > > > queue.  It is bad enough that we have to live with
> > > > > blk_insert_cloned_request for dm-mpath, but this is too big
> > > > > of an API abuse to make it into a release.  We need to drop
> > > > > this code ASAP, and I can prepare a patch for that.
> > > > 
> > > > That sounds awful, do you have a link to the offending
> > > > commit(s)?
> > > 
> > > I'll need to look for it, busy in calls right now, but just grep
> > > for blk_insert_cloned_request.
> > 
> > Might as well finish the git blame:
> > 
> > commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
> > Author: Daejun Park <daejun7.park@samsung.com>
> > Date:   Mon Jul 12 18:00:25 2021 +0900
> > 
> >      scsi: ufs: ufshpb: Add HPB 2.0 support
> >          
> >      Version 2.0 of HBP supports reads of varying sizes from 4KB to
> > 1MB.
> > 
> >      A read operation <= 32KB is supported as single HPB read. A
> > read between
> >      36KB and 1MB is supported by a combination of write buffer
> > command and HPB
> >      read command to deliver more PPN. The write buffer commands
> > may not be
> >      issued immediately due to busy tags. To use HPB read more
> > aggressively, the
> >      driver can requeue the write buffer command. The requeue
> > threshold is
> >      implemented as timeout and can be modified with
> > requeue_timeout_ms entry in
> >      sysfs.
> 
> (+Daejun)
> 
> Daejun, can the HPB code be reworked such that it does not use 
> blk_insert_cloned_request()? I'm concerned that if the HPB code is
> not reworked that it will be removed from the upstream kernel.

Just to give urgency to Bart's request: we have two or three weeks
before the kernel is due to go final.  Can the problems identified by
Christoph be fixed within that timeframe?

Specifically, looking at the paper you reference, it only uses READ
BUFFER for the host cache sharing.  Since the JDEC standard appears to
be proprietary, I have no method of understanding why the driver now
uses WRITE BUFFER as well, but it appears to be a simple optimization. 
If you can cut out the WRITE BUFFER code, blk_insert_cloned_request()
will also be gone and thus the API abuse.  Can you get us a simple
patch doing this ASAP so we don't have to revert the driver?

James



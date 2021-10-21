Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD932C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E3526112D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJUPTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:19:47 -0400
Received: from verein.lst.de ([213.95.11.211]:47056 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhJUPTr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 11:19:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id ECAB568BEB; Thu, 21 Oct 2021 17:17:28 +0200 (CEST)
Date:   Thu, 21 Oct 2021 17:17:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: please revert the UFS HPB support
Message-ID: <20211021151728.GA31600@lst.de>
References: <20211021144210.GA28195@lst.de> <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk> <20211021151520.GA31407@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021151520.GA31407@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
> > > I just noticed the UFS HPB support landed in 5.15, and just as
> > > before it is completely broken by allocating another request on
> > > the same device and then reinserting it in the queue.  It is bad
> > > enough that we have to live with blk_insert_cloned_request for
> > > dm-mpath, but this is too big of an API abuse to make it into
> > > a release.  We need to drop this code ASAP, and I can prepare
> > > a patch for that.
> > 
> > That sounds awful, do you have a link to the offending commit(s)?
> 
> I'll need to look for it, busy in calls right now, but just grep for
> blk_insert_cloned_request.

Might as well finish the git blame:

commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Mon Jul 12 18:00:25 2021 +0900

    scsi: ufs: ufshpb: Add HPB 2.0 support
        
    Version 2.0 of HBP supports reads of varying sizes from 4KB to 1MB.

    A read operation <= 32KB is supported as single HPB read. A read between
    36KB and 1MB is supported by a combination of write buffer command and HPB
    read command to deliver more PPN. The write buffer commands may not be
    issued immediately due to busy tags. To use HPB read more aggressively, the
    driver can requeue the write buffer command. The requeue threshold is
    implemented as timeout and can be modified with requeue_timeout_ms entry in
    sysfs.

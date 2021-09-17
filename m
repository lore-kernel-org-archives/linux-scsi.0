Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F00C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF6C60F6B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244038AbhIQH6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 03:58:16 -0400
Received: from verein.lst.de ([213.95.11.211]:44070 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240123AbhIQH6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 03:58:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4D8E967373; Fri, 17 Sep 2021 09:56:51 +0200 (CEST)
Date:   Fri, 17 Sep 2021 09:56:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <20210917075650.GA28455@lst.de>
References: <20210915092547.990285-1-ming.lei@redhat.com> <20210915134008.GA13933@lst.de> <YUKfl9Qqsluh+5FX@T590> <20210916101451.GA26782@lst.de> <YUM6uFHqfjWMM5BH@T590> <20210916142009.GA12603@lst.de> <YUQOBKa67R9pEunr@T590.Home> <20210917065305.GA24012@lst.de> <YURGkXQndMxDEWxW@T590.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YURGkXQndMxDEWxW@T590.Home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 03:41:05PM +0800, Ming Lei wrote:
> >  
> > -	return ret;
> > +	if (unlikely(!disk_live(disk))) {
> > +		blk_queue_exit(disk->queue);
> > +		bio_io_error(bio);
> > +		return -ENODEV;
> > +	}
> 
> Is it safe to fail IO in this way? There is still opened bdev, and
> usually IO can be done successfully even when disk is being deleted.

"normal" I/O should not really happen by the time it is deleted.  That
being said we should do this only after the fsync is done. While no
one should rely on that I'm pretty sure some file systems do.
So we'll actually need a deleted flag.

> Not mention it adds one extra check in real fast path.

I'm not really woried about the check itself.  That being
sais this inode cache line is not hot right now, so moving it to
disk->state will help as we need to check the read-only flag in
the the I/O submission path anyway.

> > +	/*
> > +	 * Prevent new I/O from crossing bio_queue_enter().
> > +	 */
> > +	blk_freeze_queue_start(q);
> > +	if (queue_is_mq(q))
> > +		blk_mq_wake_waiters(q);
> > +	/* Make blk_queue_enter() reexamine the DYING flag. */
> > +	wake_up_all(&q->mq_freeze_wq);
> > +
> > +	rq_qos_exit(q);
> 
> rq_qos_exit() requires the queue to be frozen, otherwise kernel oops
> can be triggered. There may be old submitted bios not completed yet,
> and rq_qos_done() can be referring to q->rq_qos.

Yes.  I actually misread the old code - it atually does two
blk_freeze_queue_start, but it also includes the wait.

> But if waiting for queue frozen is added, one extra freeze is added,
> which will slow done remove disk/queue.

Is it?  For the typical case the second free in blk_cleanp_queue will
be bsically free because there is no pending I/O.  The only case
where that matters if if there is pending passthrough I/O again,
which can only happen with SCSI, and even there is highly unusual.

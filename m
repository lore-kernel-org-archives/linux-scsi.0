Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FD0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 08:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A363C61108
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 08:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245391AbhIQIdf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 04:33:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245388AbhIQIde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 04:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631867532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bl9paqXasvMJQpi9tCjR8uDrk5cbl9CB2/20iF8Ur30=;
        b=LX5w/FNPlHo1tjQDsBfdDbN0wZCKVVrLdbWgL05KXsUaIm8XiJF4rciDCtEIfcNrfGD7Tw
        K46rwaEib3YCW0s7VClsTbgKRE/HqndUiHKf7ydGNLitVLGgoxnB617l5/hBRqnCQEnH5a
        LH2/KgfjJ88Fh9Uhxi7BQ/MEk5ojCN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-Xo9IMI30M82lg-H6MX0N0A-1; Fri, 17 Sep 2021 04:32:10 -0400
X-MC-Unique: Xo9IMI30M82lg-H6MX0N0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EF5310247A6;
        Fri, 17 Sep 2021 08:32:09 +0000 (UTC)
Received: from T590.Home (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22B651AC7E;
        Fri, 17 Sep 2021 08:32:05 +0000 (UTC)
Date:   Fri, 17 Sep 2021 16:32:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YURSj0G5gMiSAo5j@T590.Home>
References: <20210915092547.990285-1-ming.lei@redhat.com>
 <20210915134008.GA13933@lst.de>
 <YUKfl9Qqsluh+5FX@T590>
 <20210916101451.GA26782@lst.de>
 <YUM6uFHqfjWMM5BH@T590>
 <20210916142009.GA12603@lst.de>
 <YUQOBKa67R9pEunr@T590.Home>
 <20210917065305.GA24012@lst.de>
 <YURGkXQndMxDEWxW@T590.Home>
 <20210917075650.GA28455@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917075650.GA28455@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 09:56:50AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 03:41:05PM +0800, Ming Lei wrote:
> > >  
> > > -	return ret;
> > > +	if (unlikely(!disk_live(disk))) {
> > > +		blk_queue_exit(disk->queue);
> > > +		bio_io_error(bio);
> > > +		return -ENODEV;
> > > +	}
> > 
> > Is it safe to fail IO in this way? There is still opened bdev, and
> > usually IO can be done successfully even when disk is being deleted.
> 
> "normal" I/O should not really happen by the time it is deleted.  That
> being said we should do this only after the fsync is done. While no
> one should rely on that I'm pretty sure some file systems do.
> So we'll actually need a deleted flag.
> 
> > Not mention it adds one extra check in real fast path.
> 
> I'm not really woried about the check itself.  That being
> sais this inode cache line is not hot right now, so moving it to
> disk->state will help as we need to check the read-only flag in
> the the I/O submission path anyway.

When the deleted flag is set in del_gendisk(), it may not be observed
in time in bio_submit() because of memory/compiler re-order, so the
check is still sort of relax constraint. I guess the same is true for
read-only check.

> 
> > > +	/*
> > > +	 * Prevent new I/O from crossing bio_queue_enter().
> > > +	 */
> > > +	blk_freeze_queue_start(q);
> > > +	if (queue_is_mq(q))
> > > +		blk_mq_wake_waiters(q);
> > > +	/* Make blk_queue_enter() reexamine the DYING flag. */
> > > +	wake_up_all(&q->mq_freeze_wq);
> > > +
> > > +	rq_qos_exit(q);
> > 
> > rq_qos_exit() requires the queue to be frozen, otherwise kernel oops
> > can be triggered. There may be old submitted bios not completed yet,
> > and rq_qos_done() can be referring to q->rq_qos.
> 
> Yes.  I actually misread the old code - it atually does two
> blk_freeze_queue_start, but it also includes the wait.

Only blk_freeze_queue() includes the wait, and blk_freeze_queue_start()
doesn't.

> 
> > But if waiting for queue frozen is added, one extra freeze is added,
> > which will slow done remove disk/queue.
> 
> Is it?  For the typical case the second free in blk_cleanp_queue will
> be bsically free because there is no pending I/O.  The only case
> where that matters if if there is pending passthrough I/O again,
> which can only happen with SCSI, and even there is highly unusual.

RCU grace period is involved in blk_freeze_queue(). One way you can
avoid it is to keep the percpu ref at atomic mode when running
blk_mq_unfreeze_queue() in del_gendisk().



Thanks,
Ming


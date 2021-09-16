Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAC6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 14:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B6260EE3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 14:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbhIPOVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 10:21:34 -0400
Received: from verein.lst.de ([213.95.11.211]:40384 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235934AbhIPOVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 10:21:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7FB8167373; Thu, 16 Sep 2021 16:20:10 +0200 (CEST)
Date:   Thu, 16 Sep 2021 16:20:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <20210916142009.GA12603@lst.de>
References: <20210915092547.990285-1-ming.lei@redhat.com> <20210915134008.GA13933@lst.de> <YUKfl9Qqsluh+5FX@T590> <20210916101451.GA26782@lst.de> <YUM6uFHqfjWMM5BH@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUM6uFHqfjWMM5BH@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2021 at 08:38:16PM +0800, Ming Lei wrote:
> > > and it may cause other trouble at least for scsi disk since sd_shutdown()
> > > follows del_gendisk() and has to be called before blk_cleanup_queue().
> > 
> > Yes.  So we need to move the bits of blk_cleanup_queue that deal with
> > the file system I/O state to del_gendisk, and keep blk_cleanup_queue
> > for anything actually needed for the low-level queue.
> 
> Can you explain what the bits are in blk_cleanup_queue() for dealing with FS
> I/O state? blk_cleanup_queue() drains and shutdown the queue basically,
> all shouldn't be related with gendisk, and it is fine to implement one
> queue without gendisk involved, such as nvme admin, connect queue or
> sort of stuff.
> 
> Wrt. this reported issue, rq_qos_exit() needs to run before releasing
> gendisk, but queue has to put into freezing before calling
> rq_qos_exit(),

I was curious what you hit, but yes rq_qos_exit is obvious.
blk_flush_integrity also is very much about fs I/O state.



> so looks you suggest to move the following code into
> del_gendisk()?

something like that.  I think we need to split the dying flag into
one for the gendisk and one for the queue first, and make sure the
queue freeze in del_gendisk is released again so that passthrough
still works after.

> If we move the above into del_gendisk(), some corner cases have to be
> taken care of, such as request queue without disk involved.

Yes.

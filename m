From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/15] block: rework flush sequencing for blk-mq
Date: Thu, 6 Feb 2014 08:18:16 -0800
Message-ID: <20140206161816.GC16916@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124152.299135922@bombadil.infradead.org>
 <CAFR8ueegsgqiTruZkGxeSL4KCyxYzZUzqvWw42ZLiOZgUapH8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaBFQSU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:18:20 -0500
Content-Disposition: inline
In-Reply-To: <CAFR8ueegsgqiTruZkGxeSL4KCyxYzZUzqvWw42ZLiOZgUapH8w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 05, 2014 at 06:08:37PM -0800, Muthu Kumar wrote:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index c00e0bd..d3eb330 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -693,11 +693,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
> >         if (!uninit_q)
> >                 return NULL;
> >
> > +       uninit_q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
> 
> 
> Shouldn't this be kzalloc_node()?

Probably.  There's also various kinds of optimization potential like
allocating one per hw_ctx or similar.  But until we have a device that
has high enough IOPS to matter and needs cache flushes I wouldn't worry
about optimizing the flush path.


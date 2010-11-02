From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: QUEUE_FLAG_CLUSTER and no_cluster are NOT in sync
Date: Tue, 2 Nov 2010 16:21:59 -0400
Message-ID: <20101102202159.GC23680@redhat.com>
References: <5e7598cf7714083ffd84.1283104752@malahal>
 <20100829203149.GC24466@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab0KBUWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2010 16:22:07 -0400
Content-Disposition: inline
In-Reply-To: <20100829203149.GC24466@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, jaxboe@fusionio.com, dm-devel@redhat.com

Malahal,

This patch should go through the scsi tree.  Please update the patch (so
it includes the patch header) and repost to linux-scsi.

Thanks,
Mike

On Sun, Aug 29 2010 at  4:31pm -0400,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Here is the missing header:
> 
> no_cluster is used by device mapper (may be others) resulting in
> multipath devices setting QUEUE_FLAG_CLUSTER flag even though the
> underlying devices (e.g. open iscsi virtual adapter) don't support it.
> 
> Signed-off-by: Malahal Naineni (malahal@us.ibm.com)
> 
> Malahal Naineni [malahal@us.ibm.com] wrote:
> > diff -r 8305d08f6ecf -r 5e7598cf7714 drivers/scsi/scsi_lib.c
> > --- a/drivers/scsi/scsi_lib.c	Wed Aug 25 13:44:33 2010 -0700
> > +++ b/drivers/scsi/scsi_lib.c	Wed Aug 25 13:44:33 2010 -0700
> > @@ -1633,8 +1633,10 @@ struct request_queue *__scsi_alloc_queue
> >  	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
> > 
> >  	/* New queue, no concurrency on queue_flags */
> > -	if (!shost->use_clustering)
> > +	if (!shost->use_clustering) {
> >  		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
> > +		q->limits.no_cluster = 1;
> > +	}
> > 
> >  	/*
> >  	 * set a reasonable default alignment on word boundaries: the
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

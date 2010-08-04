From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Wed, 04 Aug 2010 13:57:37 +0900
Message-ID: <4C58F341.9060605@ct.jp.nec.com>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54734 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0HDFHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 01:07:40 -0400
In-Reply-To: <20100803185148.GA12258@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

Hi Christoph,

On 08/04/2010 03:51 AM +0900, Christoph Hellwig wrote:
> Adapt device-mapper to the new world order where even bio based devices
> get simple REQ_FLUSH requests for cache flushes, and need to submit
> them downwards for implementing barriers.
<snip>
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2010-08-03 20:26:49.676004139 +0200
> +++ linux-2.6/drivers/md/dm.c	2010-08-03 20:36:59.301005325 +0200
<snip>
> @@ -1573,7 +1565,7 @@ static int dm_prep_fn(struct request_que
>  	struct mapped_device *md = q->queuedata;
>  	struct request *clone;
>  
> -	if (unlikely(dm_rq_is_flush_request(rq)))
> +	if (rq->cmd_flags & REQ_FLUSH)
>  		return BLKPREP_OK;
>  
>  	if (unlikely(rq->special)) {
> @@ -1664,7 +1656,7 @@ static void dm_request_fn(struct request
>  		if (!rq)
>  			goto plug_and_out;
>  
> -		if (unlikely(dm_rq_is_flush_request(rq))) {
> +		if (rq->cmd_flags & REQ_FLUSH) {
>  			BUG_ON(md->flush_request);
>  			md->flush_request = rq;
>  			blk_start_request(rq);

Current request-based device-mapper's flush code depends on
the block-layer's barrier behavior which dispatches only one request
at a time when flush is needed.
In other words, current request-based device-mapper can't handle
other requests while a flush request is in progress.

I'll take a look how I can fix the request-based device-mapper to
cope with it.  I think it'll take time for carefull investigation.

Thanks,
Kiyoshi Ueda

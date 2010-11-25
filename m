From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Date: Thu, 25 Nov 2010 19:43:01 +0100
Message-ID: <4CEEAE35.5060805@fusionio.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>	<yq14ob5o2d4.fsf@sermon.lab.mkp.net> <yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:36939 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0KYSnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Nov 2010 13:43:11 -0500
In-Reply-To: <yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Promise_Linux <Promise_Linux@promise.com>

On 2010-11-25 17:35, Martin K. Petersen wrote:
> 
> When stacking devices a request_queue is not always available. This
> forced us to have a no_cluster flag in the queue_limits that could be
> used as a carrier until the request_queue had been set up for a
> metadevice.
> 
> There were several problems with that approach. First of all it was up
> to the stacking device to remember to set queue flag after stacking had
> completed. Also, the queue flag and the queue limits had to be kept in
> sync at all times. We got that wrong, which could lead to us issuing
> commands that went beyond the max scatterlist limit set by the driver.
> 
> The proper fix is to avoid having two flags for tracking the same thing.
> We deprecate QUEUE_FLAG_CLUSTER and use the queue limit directly in the
> block layer merging functions. The queue_limit 'no_cluster' is turned
> into 'cluster' to avoid double negatives and to ease stacking.
> Clustering defaults to being enabled as before. The queue flag logic is
> removed from the stacking function, and explicitly setting the cluster
> flag is no longer necessary in DM and MD.

Great, the two different values and needing to sync them was horrible.
What kind of testing did you do? Have to be a little extra careful at
this point.

> @@ -87,7 +87,7 @@ EXPORT_SYMBOL(blk_recount_segments);
>  static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
>  				   struct bio *nxt)
>  {
> -	if (!test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
> +	if (blk_queue_cluster(q))
>  		return 0;

Oops, inverted this one.

-- 
Jens Axboe


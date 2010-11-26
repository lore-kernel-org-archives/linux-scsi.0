From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Date: Thu, 25 Nov 2010 21:28:05 -0500
Message-ID: <20101126022804.GA15662@redhat.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>
 <yq14ob5o2d4.fsf@sermon.lab.mkp.net>
 <yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net>
 <4CEEAE35.5060805@fusionio.com>
 <yq1r5e8ncmz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab0KZC2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Nov 2010 21:28:53 -0500
Content-Disposition: inline
In-Reply-To: <yq1r5e8ncmz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, dm-devel@redhat.com, Promise_Linux <Promise_Linux@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Nov 25 2010 at  7:37pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> New version below, fixing the things you and Matthew pointed out...
> 
> 
> 
> block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
> 
> When stacking devices, a request_queue is not always available. This
> forced us to have a no_cluster flag in the queue_limits that could be
> used as a carrier until the request_queue had been set up for a
> metadevice.
> 
> There were several problems with that approach. First of all it was up
> to the stacking device to remember to set queue flag after stacking had
> completed. 

But that was already done properly, so that wasn't a problem that needed
fixing (it just had potential to be overlooked if/when there is a new
stacking driver).

> Also, the queue flag and the queue limits had to be kept in
> sync at all times. We got that wrong, which could lead to us issuing
> commands that went beyond the max scatterlist limit set by the driver.

It took me a bit to see exactly where we got it wrong.  Looks like
__scsi_alloc_queue was only concerned with the queue flag.  So a
minimalist fix would've been to also set no_cluster = 1 in
__scsi_alloc_queue?

(OK, I just reviewed Ed's initial report and that is exactly what his
proposed patch did! :)

This patch's header could stand to be a bit more explicit about where
the real problem was ...

But I agree that this patch cleans things up nicely.

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks,
Mike

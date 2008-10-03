From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: export busy state via q->lld_busy_fn()
Date: Fri, 03 Oct 2008 13:14:56 -0500
Message-ID: <1223057696.3230.38.camel@localhost.localdomain>
References: <20081001.145039.39152159.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40181 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbYJCSP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 14:15:29 -0400
In-Reply-To: <20081001.145039.39152159.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, akpm@linux-foundation.org, michaelc@cs.wisc.edu, j-nomura@ce.jp.nec.com

On Wed, 2008-10-01 at 14:50 -0400, Kiyoshi Ueda wrote:
> Hi James,
> 
> I hope the previous RFC patch(*) would be no problem, since I haven't
> gotten any negative comment.
>     (*) http://lkml.org/lkml/2008/9/25/262
> 
> So could you take this patch for 2.6.28 additionally?
> This patch implements a new interface of the block layer for
> request stacking drivers.
> There should be no effect on existing drivers' behavior.
> 
> This patch was created on top of the commit below of scsi-post-merge-2.6.
> ---------------------------------------------------------------------
> commit e49f03f37104c0e7cae7c455480069bada00932f
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Fri Sep 12 16:46:51 2008 -0500
> 
>     [SCSI] scsi_error: fix target reset handling
> ---------------------------------------------------------------------
> 
> And this patch depends on the following block layer patch, which
> is in Jens' for-2.6.28 of linux-2.6-block.
>     http://lkml.org/lkml/2008/9/29/142
> 
> Thanks,
> Kiyoshi Ueda
> 
> 
> Subject: [PATCH 1/1] scsi: export busy state via q->lld_busy_fn()
> 
> This patch implements q->lld_busy_fn() for scsi mid layer to export
> its busy state.
> 
> Please note that it checks the cached information (sdev->lld_busy)
> for efficiency, instead of checking the actual state of
> sdev/starget/shost everytime.
> 
> So the care must be taken not to leave sdev->lld_busy = 1 for
> the following cases:
>     - when there is no request in the sdev queue
>     - when scsi can't dispatch I/Os anymore and needs to kill I/Os
> Otherwise, request stacking drivers may not submit any request,
> and then, nobody sets back lld_busy = 0 and that causes deadlock.
> 
> OTOH, it has no major problem in setting sdev->lld_busy = 0 even when
> the starget/shost is actually busy, because newly submitted request
> will soon turn it to 1 in scsi_request_fn().
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi.c        |    4 ++--
>  drivers/scsi/scsi_lib.c    |   20 +++++++++++++++++++-
>  include/scsi/scsi_device.h |   13 +++++++++++++
>  3 files changed, 34 insertions(+), 3 deletions(-)
> 
> Index: scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- scsi-post-merge-2.6.orig/drivers/scsi/scsi_lib.c
> +++ scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
> @@ -480,6 +480,8 @@ void scsi_device_unbusy(struct scsi_devi
>  	spin_unlock(shost->host_lock);
>  	spin_lock(sdev->request_queue->queue_lock);
>  	sdev->device_busy--;
> +	if (sdev->device_busy < sdev->queue_depth && !sdev->device_blocked)
> +		sdev->lld_busy = 0;
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  }
>  
> @@ -1535,6 +1537,13 @@ static void scsi_softirq_done(struct req
>  	}
>  }
>  
> +static int scsi_lld_busy(struct request_queue *q)
> +{
> +	struct scsi_device *sdev = q->queuedata;
> +
> +	return sdev ? sdev->lld_busy : 0;
> +}

Since you've moved to a functional approach, why is this lld_busy flag
still necessary?  Surely this function can just check the three blocked
conditions and the two overqueue ones at this point without ever having
to reach into any of the SCSI internals?

James



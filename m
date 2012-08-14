From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
Date: Tue, 14 Aug 2012 13:07:51 +0100
Message-ID: <1344946071.3117.26.camel@dabdike.int.hansenpartnership.com>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
	 <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-08-14 at 18:48 +0900, Chanho Min wrote:
> We don't need to unlock the queue before put_device in scsi_request_fn()
> If we trigger the ->remove() function, It occur a oops from the caller.
> So sdev reference count should not be dropped to zero here.
> Also It was added before scsi_device_dev_release() was moved
> to user context, so it is outdated.

None of this sounds to be correct.  The user context comment is
irrelevant because if we happen to be in user context, all the release
functions will occur in line.  I also don't see why the sdev reference
couldn't drop to zero here.

The reason I think we could remove the lock drop is because the queue
reference cannot drop to zero here because the block layer is holding a
reference to run the queue.  It's only the queue ->release function that
would take the queue lock and therefore we're safe to hold it.

James


> Signed-off-by: Chanho Min <chanho.min@lge.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ffd7773..cb2185a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1626,11 +1626,7 @@ out_delay:
>  	if (sdev->device_busy == 0)
>  		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  out:
> -	/* must be careful here...if we trigger the ->remove() function
> -	 * we cannot be holding the q lock */
> -	spin_unlock_irq(q->queue_lock);
>  	put_device(&sdev->sdev_gendev);
> -	spin_lock_irq(q->queue_lock);
>  }
> 
>  u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)

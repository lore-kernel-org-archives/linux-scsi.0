From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] fc-transport: BSG clean-up changes for normal and
 timeout completions (scsi-post-merge tree)
Date: Thu, 18 Jun 2009 09:33:20 +0900
Message-ID: <20090618093311K.fujita.tomonori@lab.ntt.co.jp>
References: <9A4AF066-850F-4EC0-A4A7-9850C73632E4@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40803 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZFRAd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 20:33:26 -0400
In-Reply-To: <9A4AF066-850F-4EC0-A4A7-9850C73632E4@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: James.Bottomley@HansenPartnership.com, James.Smart@Emulex.Com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com

On Wed, 17 Jun 2009 09:31:30 -0700
Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:

> 
> Registered the softirq_done function for BSG request since this is  
> requried by the block layer using block level
> request timeout functionality. This function will be called by the  
> block layer as part of time out clean process to release the  BSG  
> request.
> 
> Moved some of the BSG request completion activities to softirq_done  
> routine to take care of both normal and timout completions.
> 
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

The patch seems to be malformed to me.


>   drivers/scsi/scsi_transport_fc.c |   37 ++++++++++++++++++ 
> +------------------
>   1 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
> scsi_transport_fc.c
> index 3f64d93..453d9e6 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3397,7 +3397,6 @@ fc_destroy_bsgjob(struct fc_bsg_job *job)
>   	kfree(job);
>   }
> 
> -
>   /**
>    * fc_bsg_jobdone - completion routine for bsg requests that the LLD  
> has
>    *                  completed
> @@ -3408,15 +3407,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>   {
>   	struct request *req = job->req;
>   	struct request *rsp = req->next_rq;
> -	unsigned long flags;
>   	int err;
> 
> -	spin_lock_irqsave(&job->job_lock, flags);
> -	job->state_flags |= FC_RQST_STATE_DONE;
> -	job->ref_cnt--;
> -	spin_unlock_irqrestore(&job->job_lock, flags);
> -
>   	err = job->req->errors = job->reply->result;
> +
>   	if (err < 0)
>   		/* we're only returning the result field in the reply */
>   		job->req->sense_len = sizeof(uint32_t);
> @@ -3433,13 +3427,27 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>   		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
>   				      rsp->resid_len);
>   	}
> +	blk_complete_request(req);
> +}
> +
> +/**
> + * fc_bsg_softirq_done - softirq done routine for destroying the bsg  
> requests
> + * @req:        BSG request that holds the job to be destroyed
> + */
> +static void fc_bsg_softirq_done(struct request *rq)
> +{
> +	struct fc_bsg_job *job = rq->special;
> +	unsigned long flags;
> 
> -	blk_end_request_all(req, err);
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	job->state_flags |= FC_RQST_STATE_DONE;
> +	job->ref_cnt--;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> 
> +	blk_end_request_all(rq, rq->errors);
>   	fc_destroy_bsgjob(job);
>   }
> 
> -
>   /**
>    * fc_bsg_job_timeout - handler for when a bsg request timesout
>    * @req:	request that timed out
> @@ -3471,19 +3479,10 @@ fc_bsg_job_timeout(struct request *req)
>   				"abort failed with status %d\n", err);
>   	}
> 
> -	if (!done) {
> -		spin_lock_irqsave(&job->job_lock, flags);
> -		job->ref_cnt--;
> -		spin_unlock_irqrestore(&job->job_lock, flags);
> -		fc_destroy_bsgjob(job);
> -	}
> -
>   	/* the blk_end_sync_io() doesn't check the error */
>   	return BLK_EH_HANDLED;

I think that you need to return a proper value here; see my previous
patch. If a job is done, we need to return BLK_EH_NOT_HANDLED here;
otherwise the block layer calls __blk_complete_request for the job
(and later we call blk_complete_request for the same job).

The rest looks fine by me.

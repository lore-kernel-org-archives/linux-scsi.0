From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: kernel crash when BSG request timesout
Date: Thu, 28 May 2009 15:12:37 +0900
Message-ID: <20090528151304Q.fujita.tomonori@lab.ntt.co.jp>
References: <4A1928B4.7030807@panasas.com>
	<3688CE86-250A-4D29-A3EB-ED1B46F82377@qlogic.com>
	<20090528150147U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57628 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbZE1GMo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 02:12:44 -0400
In-Reply-To: <20090528150147U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

On Thu, 28 May 2009 15:01:21 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> CC'ed James Smart,
> 
> On Tue, 26 May 2009 11:38:14 -0700
> Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:
> 
> > Thanks for the pointer. I will check with the post-merge tree.
> > 
> > 	The crash I am seeing is because of softirq_done_fn not set in the  
> > request queue for BSG request. Even in the post-merge tree I don't see  
> > FC transport setting this function during the allocation of the  
> > request queue.  When BSG request times out, I see that it executes  
> > __blk_complete_request function where check is done for its existence.  
> > I see this getting set for SCSI request during queue allocation in  
> > scsi_lib.c. Is this required for BSG request?
> 
> Yeah, you need to set q->softirq_done_fn if you use the block timeout
> infrastructure. The current bsg user, SMP, uses bsg but it doesn't use
> the timeout infrastructure so it doesn't set q->softirq_done_fn.
> 
> If q->softirq_done_fn returns BLK_EH_HANDLED, the block layer doesn't
> expect that q->softirq_done_fn frees the request (currently,
> fc_bsg_job_timeout does); The block layer calls q->softirq_done_fn
> for it.

Oops, 

If q->rq_timed_out_fn returns BLK_EH_HANDLED, the block layer doesn't
expect that q->rq_timed_out_fn frees the request (currently,
fc_bsg_job_timeout does); The block layer calls q->softirq_done_fn to
clean up the request.


> The attached patch works? It just adds q->softirq_done_fn and moves
> fc_destroy_bsgjob from fc_bsg_job_timeout to it. fc_bsg_job_timeout
> returns BLK_EH_NOT_HANDLED when a job is done since the job will be
> finished shortly so we don't want the block layer to do anything for
> the job.
> 
> It might be better to use q->softirq_done_fn for all the requests not
> only for expired requests, as SCSI-ml does, that is, job->job_done
> calls blk_complete_request().
> 
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 3f64d93..c58e33a 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3439,6 +3439,16 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>  	fc_destroy_bsgjob(job);
>  }
>  
> +static void fc_bsg_softirq_done(struct request *rq)
> +{
> +	struct fc_bsg_job *job = rq->special;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	job->ref_cnt--;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +	fc_destroy_bsgjob(job);
> +}
>  
>  /**
>   * fc_bsg_job_timeout - handler for when a bsg request timesout
> @@ -3471,19 +3481,12 @@ fc_bsg_job_timeout(struct request *req)
>  				"abort failed with status %d\n", err);
>  	}
>  
> -	if (!done) {
> -		spin_lock_irqsave(&job->job_lock, flags);
> -		job->ref_cnt--;
> -		spin_unlock_irqrestore(&job->job_lock, flags);
> -		fc_destroy_bsgjob(job);
> -	}
> -
> -	/* the blk_end_sync_io() doesn't check the error */
> -	return BLK_EH_HANDLED;
> +	if (done)
> +		return BLK_EH_NOT_HANDLED;
> +	else
> +		return BLK_EH_HANDLED;
>  }
>  
> -
> -
>  static int
>  fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
>  {
> @@ -3879,6 +3882,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
>  
>  	q->queuedata = shost;
>  	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
> +	blk_queue_softirq_done(q, fc_bsg_softirq_done);
>  	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
>  	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

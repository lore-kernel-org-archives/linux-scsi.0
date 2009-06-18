From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [Suspected SPAM] Re: [PATCH] fc-transport: BSG clean-up changes for normal and timeout completions (scsi-post-merge tree)
Date: Thu, 18 Jun 2009 12:05:24 -0700
Message-ID: <58607277-D587-4B56-AB2F-361B486FAEBC@qlogic.com>
References: <9A4AF066-850F-4EC0-A4A7-9850C73632E4@qlogic.com> <20090618093311K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52036 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058AbZFRTFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 15:05:22 -0400
In-Reply-To: <20090618093311K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jun 17, 2009, at 5:33 PM, FUJITA Tomonori wrote:

> On Wed, 17 Jun 2009 09:31:30 -0700
> Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:
>
>>
>> Registered the softirq_done function for BSG request since this is
>> requried by the block layer using block level
>> request timeout functionality. This function will be called by the
>> block layer as part of time out clean process to release the  BSG
>> request.
>>
>> Moved some of the BSG request completion activities to softirq_done
>> routine to take care of both normal and timout completions.
>>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>
> The patch seems to be malformed to me.

I re-posted the patch.
>
>
>
>>  drivers/scsi/scsi_transport_fc.c |   37 ++++++++++++++++++
>> +------------------
>>  1 files changed, 19 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>> scsi_transport_fc.c
>> index 3f64d93..453d9e6 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -3397,7 +3397,6 @@ fc_destroy_bsgjob(struct fc_bsg_job *job)
>>  	kfree(job);
>>  }
>>
>> -
>>  /**
>>   * fc_bsg_jobdone - completion routine for bsg requests that the LLD
>> has
>>   *                  completed
>> @@ -3408,15 +3407,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>>  {
>>  	struct request *req = job->req;
>>  	struct request *rsp = req->next_rq;
>> -	unsigned long flags;
>>  	int err;
>>
>> -	spin_lock_irqsave(&job->job_lock, flags);
>> -	job->state_flags |= FC_RQST_STATE_DONE;
>> -	job->ref_cnt--;
>> -	spin_unlock_irqrestore(&job->job_lock, flags);
>> -
>>  	err = job->req->errors = job->reply->result;
>> +
>>  	if (err < 0)
>>  		/* we're only returning the result field in the reply */
>>  		job->req->sense_len = sizeof(uint32_t);
>> @@ -3433,13 +3427,27 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>>  		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
>>  				      rsp->resid_len);
>>  	}
>> +	blk_complete_request(req);
>> +}
>> +
>> +/**
>> + * fc_bsg_softirq_done - softirq done routine for destroying the bsg
>> requests
>> + * @req:        BSG request that holds the job to be destroyed
>> + */
>> +static void fc_bsg_softirq_done(struct request *rq)
>> +{
>> +	struct fc_bsg_job *job = rq->special;
>> +	unsigned long flags;
>>
>> -	blk_end_request_all(req, err);
>> +	spin_lock_irqsave(&job->job_lock, flags);
>> +	job->state_flags |= FC_RQST_STATE_DONE;
>> +	job->ref_cnt--;
>> +	spin_unlock_irqrestore(&job->job_lock, flags);
>>
>> +	blk_end_request_all(rq, rq->errors);
>>  	fc_destroy_bsgjob(job);
>>  }
>>
>> -
>>  /**
>>   * fc_bsg_job_timeout - handler for when a bsg request timesout
>>   * @req:	request that timed out
>> @@ -3471,19 +3479,10 @@ fc_bsg_job_timeout(struct request *req)
>>  				"abort failed with status %d\n", err);
>>  	}
>>
>> -	if (!done) {
>> -		spin_lock_irqsave(&job->job_lock, flags);
>> -		job->ref_cnt--;
>> -		spin_unlock_irqrestore(&job->job_lock, flags);
>> -		fc_destroy_bsgjob(job);
>> -	}
>> -
>>  	/* the blk_end_sync_io() doesn't check the error */
>>  	return BLK_EH_HANDLED;
>
> I think that you need to return a proper value here; see my previous
> patch. If a job is done, we need to return BLK_EH_NOT_HANDLED here;
> otherwise the block layer calls __blk_complete_request for the job
> (and later we call blk_complete_request for the same job).
>
> The rest looks fine by me.

static void blk_rq_timed_out(struct request *req)
{
         struct request_queue *q = req->q;
         enum blk_eh_timer_return ret;

         ret = q->rq_timed_out_fn(req);
         switch (ret) {
         case BLK_EH_HANDLED:
                 __blk_complete_request(req);
                 break;
         case BLK_EH_RESET_TIMER:
                 blk_clear_rq_complete(req);
                 blk_add_timer(req);
                 break;
         case BLK_EH_NOT_HANDLED:
                 /*
                  * LLD handles this for now but in the future
                  * we can send a request msg to abort the command
                  * and we can move more of the generic scsi eh code to
                  * the blk layer.
                  */
                 break;

	As per this code, the completion routine will be called only if we  
return BLK_EH_HANDLED from fc transport. In our case the abort of the  
timed out request
has been completed and handled. That's the reason I returned  
BLK_EH_HANDLED always.

	In case of returning BLK_EH_NOT_HANDLED when does the bsg job  
completion happens? I did see that by returning BLK_EH_NOT_HANDLED the  
application never got response back.

-Giridhar Malavali




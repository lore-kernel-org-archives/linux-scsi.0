From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [Suspected SPAM] Re: kernel crash when BSG request timesout
Date: Wed, 10 Jun 2009 00:56:05 -0700
Message-ID: <7DDBFE45-260F-4645-94FE-DB600B79F92C@qlogic.com>
References: <4A1928B4.7030807@panasas.com> <3688CE86-250A-4D29-A3EB-ED1B46F82377@qlogic.com> <20090528150147U.fujita.tomonori@lab.ntt.co.jp> <20090528151304Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:38919 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZFJH4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 03:56:04 -0400
In-Reply-To: <20090528151304Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>


	After applying the changes from Fujita, I see that application never  
completes when BSG time out happens.  Once the BSG request times out,  
I see fc_bsg_softirq_done routine destroying the bsg_job but does not  
send any response back to the application. The application infinitely  
waits for the response with following warning message

Jun  9 17:22:09 elab60 kernel: [  480.666830]INFO: task sgv4_els:6058  
blocked for more than 120 seconds.
Jun  9 17:22:09 elab60 kernel: [  480.666833] "echo 0 > /proc/sys/ 
kernel/hung_task_timeout_secs" disables this message.
Jun  9 17:22:09 elab60 kernel: [  480.666835] sgv4_els      D  
0000000000000000     0  6058   5993
Jun  9 17:22:09 elab60 kernel: [  480.666838]  ffff88007f173b78  
0000000000000082 0000000000000000 ffffffffa003f880
Jun  9 17:22:09 elab60 kernel: [  480.666842]  ffff880001030000  
000000000000ff00 000000000000c8b8 ffff88007fbf6990
Jun  9 17:22:09 elab60 kernel: [  480.666845]  ffff88007fbf6c18  
00000001a00382cf 00000000ffff3524 ffff88007f93c990
Jun  9 17:22:09 elab60 kernel: [  480.666848] Call Trace:
Jun  9 17:22:09 elab60 kernel: [  480.666858]  [<ffffffffa00015d2>] ?  
fc_bsg_map_buffer+0x2a/0x72 [scsi_transport_fc]
Jun  9 17:22:09 elab60 kernel: [  480.666864]  [<ffffffff8029a2ba>] ?  
cache_alloc_debugcheck_after+0x73/0x243
Jun  9 17:22:09 elab60 kernel: [  480.666868]  [<ffffffff80511ebe>]  
schedule+0x9/0x1d
Jun  9 17:22:09 elab60 kernel: [  480.666871]  [<ffffffff8051210f>]  
schedule_timeout+0x12f/0x164
Jun  9 17:22:09 elab60 kernel: [  480.666873]  [<ffffffff805113f7>]  
wait_for_common+0xb8/0x15e
Jun  9 17:22:09 elab60 kernel: [  480.666878]  [<ffffffff80230feb>] ?  
default_wake_function+0x0/0xf
Jun  9 17:22:09 elab60 kernel: [  480.666880]  [<ffffffff80511527>]  
wait_for_completion+0x18/0x1a
Jun  9 17:22:09 elab60 kernel: [  480.666884]  [<ffffffff80360da6>]  
blk_execute_rq+0x7f/0xc9
Jun  9 17:22:09 elab60 kernel: [  480.666887]  [<ffffffff80365c28>]  
bsg_ioctl+0x1c0/0x227
Jun  9 17:22:09 elab60 kernel: [  480.666890]  [<ffffffff80514362>] ?  
_spin_unlock_irqrestore+0x2b/0x32
Jun  9 17:22:09 elab60 kernel: [  480.666894]  [<ffffffff802adb36>]  
vfs_ioctl+0x2a/0x95
Jun  9 17:22:09 elab60 kernel: [  480.666896]  [<ffffffff802adc22>]  
do_vfs_ioctl+0x81/0x583
Jun  9 17:22:09 elab60 kernel: [  480.666898]  [<ffffffff80514372>] ?  
_spin_unlock+0x9/0xb
Jun  9 17:22:09 elab60 kernel: [  480.666901]  [<ffffffff802ae165>]  
sys_ioctl+0x41/0x65
Jun  9 17:22:09 elab60 kernel: [  480.666904]  [<ffffffff8020b26b>]  
system_call_fastpath+0x16/0x1b

	I see that function blk_end_request_all calls blk_finish_request  
routine to complete the response to application. After adding this  
call in fc_bsg_softirq_done function, the application gets the  
response and completes.

Is this a proper fix? How does block layer request completes when  
timeout happens?

/**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg  
requests
  * @req:        BSG request that holds the job to be destroyed
  */
static void fc_bsg_softirq_done(struct request *rq)
{
         struct fc_bsg_job *job = rq->special;
         unsigned long flags;

         spin_lock_irqsave(&job->job_lock, flags);
+      job->state_flags |= FC_RQST_STATE_DONE;
         job->ref_cnt--;
         spin_unlock_irqrestore(&job->job_lock, flags);
+      blk_end_request_all(rq, rq->errors);
         fc_destroy_bsgjob(job);

- Giridhar.M.B



Once the BSG request times
On May 27, 2009, at 11:12 PM, FUJITA Tomonori wrote:

> On Thu, 28 May 2009 15:01:21 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> CC'ed James Smart,
>>
>> On Tue, 26 May 2009 11:38:14 -0700
>> Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:
>>
>>> Thanks for the pointer. I will check with the post-merge tree.
>>>
>>> 	The crash I am seeing is because of softirq_done_fn not set in the
>>> request queue for BSG request. Even in the post-merge tree I don't  
>>> see
>>> FC transport setting this function during the allocation of the
>>> request queue.  When BSG request times out, I see that it executes
>>> __blk_complete_request function where check is done for its  
>>> existence.
>>> I see this getting set for SCSI request during queue allocation in
>>> scsi_lib.c. Is this required for BSG request?
>>
>> Yeah, you need to set q->softirq_done_fn if you use the block timeout
>> infrastructure. The current bsg user, SMP, uses bsg but it doesn't  
>> use
>> the timeout infrastructure so it doesn't set q->softirq_done_fn.
>>
>> If q->softirq_done_fn returns BLK_EH_HANDLED, the block layer doesn't
>> expect that q->softirq_done_fn frees the request (currently,
>> fc_bsg_job_timeout does); The block layer calls q->softirq_done_fn
>> for it.
>
> Oops,
>
> If q->rq_timed_out_fn returns BLK_EH_HANDLED, the block layer doesn't
> expect that q->rq_timed_out_fn frees the request (currently,
> fc_bsg_job_timeout does); The block layer calls q->softirq_done_fn to
> clean up the request.
>
>
>> The attached patch works? It just adds q->softirq_done_fn and moves
>> fc_destroy_bsgjob from fc_bsg_job_timeout to it. fc_bsg_job_timeout
>> returns BLK_EH_NOT_HANDLED when a job is done since the job will be
>> finished shortly so we don't want the block layer to do anything for
>> the job.
>>
>> It might be better to use q->softirq_done_fn for all the requests not
>> only for expired requests, as SCSI-ml does, that is, job->job_done
>> calls blk_complete_request().
>>
>>
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
>> scsi_transport_fc.c
>> index 3f64d93..c58e33a 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -3439,6 +3439,16 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>> 	fc_destroy_bsgjob(job);
>> }
>>
>> +static void fc_bsg_softirq_done(struct request *rq)
>> +{
>> +	struct fc_bsg_job *job = rq->special;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&job->job_lock, flags);
>> +	job->ref_cnt--;
>> +	spin_unlock_irqrestore(&job->job_lock, flags);
>> +	fc_destroy_bsgjob(job);
>> +}
>>
>> /**
>>  * fc_bsg_job_timeout - handler for when a bsg request timesout
>> @@ -3471,19 +3481,12 @@ fc_bsg_job_timeout(struct request *req)
>> 				"abort failed with status %d\n", err);
>> 	}
>>
>> -	if (!done) {
>> -		spin_lock_irqsave(&job->job_lock, flags);
>> -		job->ref_cnt--;
>> -		spin_unlock_irqrestore(&job->job_lock, flags);
>> -		fc_destroy_bsgjob(job);
>> -	}
>> -
>> -	/* the blk_end_sync_io() doesn't check the error */
>> -	return BLK_EH_HANDLED;
>> +	if (done)
>> +		return BLK_EH_NOT_HANDLED;
>> +	else
>> +		return BLK_EH_HANDLED;
>> }
>>
>> -
>> -
>> static int
>> fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
>> {
>> @@ -3879,6 +3882,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost,  
>> struct fc_host_attrs *fc_host)
>>
>> 	q->queuedata = shost;
>> 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
>> +	blk_queue_softirq_done(q, fc_bsg_softirq_done);
>> 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
>> 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


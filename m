From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Suspected SPAM] Re: kernel crash when BSG request timesout
Date: Wed, 10 Jun 2009 17:40:17 +0900
Message-ID: <20090610174011H.fujita.tomonori@lab.ntt.co.jp>
References: <20090528150147U.fujita.tomonori@lab.ntt.co.jp>
	<20090528151304Q.fujita.tomonori@lab.ntt.co.jp>
	<7DDBFE45-260F-4645-94FE-DB600B79F92C@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36873 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZFJIkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 04:40:23 -0400
In-Reply-To: <7DDBFE45-260F-4645-94FE-DB600B79F92C@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

On Wed, 10 Jun 2009 00:56:05 -0700
Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:

> 
> 	After applying the changes from Fujita, I see that application never  
> completes when BSG time out happens.  Once the BSG request times out,  
> I see fc_bsg_softirq_done routine destroying the bsg_job but does not  
> send any response back to the application. The application infinitely  
> waits for the response with following warning message
> 
> Jun  9 17:22:09 elab60 kernel: [  480.666830]INFO: task sgv4_els:6058  
> blocked for more than 120 seconds.
> Jun  9 17:22:09 elab60 kernel: [  480.666833] "echo 0 > /proc/sys/ 
> kernel/hung_task_timeout_secs" disables this message.
> Jun  9 17:22:09 elab60 kernel: [  480.666835] sgv4_els      D  
> 0000000000000000     0  6058   5993
> Jun  9 17:22:09 elab60 kernel: [  480.666838]  ffff88007f173b78  
> 0000000000000082 0000000000000000 ffffffffa003f880
> Jun  9 17:22:09 elab60 kernel: [  480.666842]  ffff880001030000  
> 000000000000ff00 000000000000c8b8 ffff88007fbf6990
> Jun  9 17:22:09 elab60 kernel: [  480.666845]  ffff88007fbf6c18  
> 00000001a00382cf 00000000ffff3524 ffff88007f93c990
> Jun  9 17:22:09 elab60 kernel: [  480.666848] Call Trace:
> Jun  9 17:22:09 elab60 kernel: [  480.666858]  [<ffffffffa00015d2>] ?  
> fc_bsg_map_buffer+0x2a/0x72 [scsi_transport_fc]
> Jun  9 17:22:09 elab60 kernel: [  480.666864]  [<ffffffff8029a2ba>] ?  
> cache_alloc_debugcheck_after+0x73/0x243
> Jun  9 17:22:09 elab60 kernel: [  480.666868]  [<ffffffff80511ebe>]  
> schedule+0x9/0x1d
> Jun  9 17:22:09 elab60 kernel: [  480.666871]  [<ffffffff8051210f>]  
> schedule_timeout+0x12f/0x164
> Jun  9 17:22:09 elab60 kernel: [  480.666873]  [<ffffffff805113f7>]  
> wait_for_common+0xb8/0x15e
> Jun  9 17:22:09 elab60 kernel: [  480.666878]  [<ffffffff80230feb>] ?  
> default_wake_function+0x0/0xf
> Jun  9 17:22:09 elab60 kernel: [  480.666880]  [<ffffffff80511527>]  
> wait_for_completion+0x18/0x1a
> Jun  9 17:22:09 elab60 kernel: [  480.666884]  [<ffffffff80360da6>]  
> blk_execute_rq+0x7f/0xc9
> Jun  9 17:22:09 elab60 kernel: [  480.666887]  [<ffffffff80365c28>]  
> bsg_ioctl+0x1c0/0x227
> Jun  9 17:22:09 elab60 kernel: [  480.666890]  [<ffffffff80514362>] ?  
> _spin_unlock_irqrestore+0x2b/0x32
> Jun  9 17:22:09 elab60 kernel: [  480.666894]  [<ffffffff802adb36>]  
> vfs_ioctl+0x2a/0x95
> Jun  9 17:22:09 elab60 kernel: [  480.666896]  [<ffffffff802adc22>]  
> do_vfs_ioctl+0x81/0x583
> Jun  9 17:22:09 elab60 kernel: [  480.666898]  [<ffffffff80514372>] ?  
> _spin_unlock+0x9/0xb
> Jun  9 17:22:09 elab60 kernel: [  480.666901]  [<ffffffff802ae165>]  
> sys_ioctl+0x41/0x65
> Jun  9 17:22:09 elab60 kernel: [  480.666904]  [<ffffffff8020b26b>]  
> system_call_fastpath+0x16/0x1b

Oops, sorry about that.


> 	I see that function blk_end_request_all calls blk_finish_request  
> routine to complete the response to application. After adding this  
> call in fc_bsg_softirq_done function, the application gets the  
> response and completes.
> 
> Is this a proper fix? How does block layer request completes when  
> timeout happens?

Looks ok to me. You need to complete such requests (as your fix does
in fc_bsg_softirq_done), if I understand correctly.


> /**
>   * fc_bsg_softirq_done - softirq done routine for destroying the bsg  
> requests
>   * @req:        BSG request that holds the job to be destroyed
>   */
> static void fc_bsg_softirq_done(struct request *rq)
> {
>          struct fc_bsg_job *job = rq->special;
>          unsigned long flags;
> 
>          spin_lock_irqsave(&job->job_lock, flags);
> +      job->state_flags |= FC_RQST_STATE_DONE;
>          job->ref_cnt--;
>          spin_unlock_irqrestore(&job->job_lock, flags);
> +      blk_end_request_all(rq, rq->errors);
>          fc_destroy_bsgjob(job);
> 

My previous patch with this fix is fine by me for now.

However, as I proposed in the previous mail, I think that it would be
clean if we use q->softirq_done_fn for all the requests not only for
expired requests because fc_bsg_jobdone() does the part of what
fc_bsg_softirq_done() does.

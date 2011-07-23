From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 02/10] scsi bsg: add scsi bsg helper lib
Date: Fri, 22 Jul 2011 22:19:42 -0500
Message-ID: <4E2A3DCE.6090605@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>	<1311329100-2982-3-git-send-email-michaelc@cs.wisc.edu> <20110723011924Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39918 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1GWDTw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 23:19:52 -0400
In-Reply-To: <20110723011924Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On 07/22/2011 11:31 AM, FUJITA Tomonori wrote:
>> +/**
>> + * scsi_destroy_bsg_job - routine to teardown/delete a bsg job
>> + * @job: scsi_bsg_job that is to be torn down
>> + */
>> +static void scsi_destroy_bsg_job(struct scsi_bsg_job *job)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&job->job_lock, flags);
>> +	if (job->ref_cnt) {
>> +		spin_unlock_irqrestore(&job->job_lock, flags);
>> +		return;
>> +	}
>> +	spin_unlock_irqrestore(&job->job_lock, flags);
> 
> Is this actually a reference counter? Doesn't look like how we use a
> reference counter? If scsi_bsg_job needs it, it would be better to
> just put kref in it?

Yeah, I do not think it is needed. That and the state_flags should not
be needed (state flag seems to duplicate the request state handling). I
have patches to remove that code. I was going to send them separately
though, so just in case I/we are wrong it can be git reverted. I guess
it can just be merged in this patch though.



>> +void scsi_bsg_remove(struct request_queue *q)
>> +{
>> +	struct request *req; /* block request */
>> +	int counts; /* totals for request_list count and starved */
> 
> This function looks hacky a bit (e.g. peeking at the queue internal
> values such as count and starved). Can we do this in a different way
> (less hacky way)?
> 


>> +			}
>> +
>> +			msleep(200); /* allow bsg to possibly finish */
> 
> Hmm, what's it? Do we need to fix something about bsg?

James Smart had added this in 78d16341facf829a71b6f7c68ec5511b9c168060.
I do not think it can be easily fixed. I think he is working on a better
long term fix.

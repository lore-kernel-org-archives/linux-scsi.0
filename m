From: Sven Schuetz <sven@linux.vnet.ibm.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Wed, 26 Nov 2008 19:25:52 +0100
Message-ID: <492D94B0.9000003@linux.vnet.ibm.com>
References: <1227043498.4949.21.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54190 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYKZSZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 13:25:54 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id mAQIPrrI013035
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2008 18:25:53 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAQIPqlv4161636
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2008 19:25:52 +0100
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAQIPqBU001607
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2008 19:25:52 +0100
In-Reply-To: <1227043498.4949.21.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com

James Smart wrote:

>- A new file was created, scsi_bsg_fc.h, which contains the
>  request/response data structures that should be shared
>  between the application and the kernel entities.

So we need to add this to include/scsi/Kbuild, right?

> +/**
> + * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
> + *                  completed
> + * @job:	fc_bsg_job that is complete
> + */
> +static void
> +fc_bsg_jobdone(struct fc_bsg_job *job)
> +{
> +	struct request *req = job->req->next_rq;

Shouldn't this be just job->req?

> +	struct request *rsp = req->next_rq;
> +	unsigned long flags;
> +	int err;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	job->state_flags |= FC_RQST_STATE_DONE;
> +	job->ref_cnt--;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +
> +	err = job->req->errors = job->reply->result;
> +	if (err < 0)
> +		/* we're only returning the result field in the reply */
> +		job->req->sense_len = sizeof(uint32_t);
> +	else
> +		job->req->sense_len = job->reply_len;
> +
> +	/*
> +	 * we'll cheat: tell blk layer all of the xmt data was sent.
> +	 * but try to be honest about the amount of rcv data received
> +	 */
> +	if (rsp)
> +		blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
> +	    			     job->reply->reply_payload_rcv_len);

Here is a problem when a LLD does not set job->reply->reply_payload_rcv_len, but
has created a response.
blk_end_bidi_request will be called with a length of 0 for the last parameter
and will thus return "1: still buffers pending for this request", which we do
not evaluate. A few lines later the job is destroyed. But a few seconds later
the timeout kicks in, leading to a crash (I suppose because the job has been
destroyed).
I see two options:
1. check if we have a response and see if a length has been set - but what do
for cases which have a response and no length set? throw the request away?
2. always use the blk_rq_bytes(job->req->next_rq) from Seokmanns initial patch
(which I prefer)

> +	else
> +		blk_end_request(job->req, err, blk_rq_bytes(job->req));
> +
> +	fc_destroy_bsgjob(job);
> +}
> +

<snip>

> +/**
> + * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
> + * @shost:	scsi host rport attached to
> + * @rport:	rport request destined to
> + * @job:	bsg job to be processed
> + */
> +static enum fc_dispatch_result
> +fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
> +			 struct fc_rport *rport, struct fc_bsg_job *job)
> +{
> +	struct fc_internal *i = to_fc_internal(shost->transportt);
> +	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
> +	int ret;
> +
> +	/* Validate the rport command */
> +	switch (job->request->msgcode) {
> +	case FC_BSG_RPT_ELS:
> +	case FC_BSG_RPT_CT:
> +		cmdlen += sizeof(struct fc_bsg_rport_els);

Why do we do the same here for ELS and CT? The struct fc_bsg_rport_ct is some
bytes larger than for the ELS and should get its own case.

> +		/* there better be a xmt and rcv payloads */
> +		if ((!job->request_payload.payload_len) ||
> +		    (!job->reply_payload.payload_len)) {
> +			ret = -EINVAL;
> +			goto fail_rport_msg;
> +		}
> +		break;
> +	default:
> +		ret = -EBADR;
> +		goto fail_rport_msg;
> +	}
> +
> +	/* check if we really have all the request data needed */
> +	if (job->request_len < cmdlen) {
> +		ret = -ENOMSG;
> +		goto fail_rport_msg;
> +	}
> +
> +	ret = i->f->bsg_request(job);
> +	if (ret) {
> +fail_rport_msg:
> +		/* return the errno failure code as the only status */
> +		BUG_ON(job->reply_len < sizeof(uint32_t));
> +		job->reply->result = ret;
> +		job->reply_len = sizeof(uint32_t);
> +		fc_bsg_jobdone(job);
> +		/* fall thru */
> +	}
> +
> +	return FC_DISPATCH_UNLOCKED;
> +}
> +
> +

<snip>
> +struct fc_bsg_job {
> +	struct Scsi_Host *shost;
> +	struct fc_rport *rport;
> +	struct device *dev;
> +	struct request *req;
> +	spinlock_t job_lock;
> +	unsigned int state_flags;
> +	unsigned int ref_cnt;
> +	void (*job_done)(struct fc_bsg_job *);
> +
> +	struct fc_bsg_request *request;
> +	struct fc_bsg_reply *reply;
> +	unsigned int request_len;
> +	unsigned int reply_len;
> +	/*
> +	 * On entry : reply_len indicates the buffer size allocated for
> +	 * the reply.
> +	 *
> +	 * Upon completion : the message handler must set reply_len
> +	 *  to indicates the size of the reply to be returned to the
> +	 *  caller.
> +	 */

Do we need this field (reply_len)? Both the fc_bsg_buffer struct (for the vector
i/o) as well as the fc_bsg_reply struct (for the sense data) contain fields for
the payload length.

> +
> +	/* DMA payloads for the request/response */
> +	struct fc_bsg_buffer request_payload;
> +	struct fc_bsg_buffer reply_payload;
> +
> +	void *dd_data;			/* Used for driver-specific storage */
> +};


Sven

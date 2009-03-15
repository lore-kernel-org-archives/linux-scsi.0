From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sun, 15 Mar 2009 11:15:42 -0400
Message-ID: <49BD1B9E.4010804@emulex.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BA8E1E.6080809@linux.vnet.ibm.com> <49BCCBC3.7020204@panasas.com> <49BCFF47.2050005@emulex.com> <49BD0ACE.8000409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39333 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZCOPPv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2009 11:15:51 -0400
In-Reply-To: <49BD0ACE.8000409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, Seokmann Ju <seokmann.ju@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Giridhar Malavali <giridhar.malavali@qlogic.com>



Boaz Harrosh wrote:
<snip..>
>> +	if (rsp) {
>> +		rsp_len = blk_rq_bytes(rsp);
>> +		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
>> +		/* set reply (bidi) residual */
>> +		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
>> +	}
>> +
>> +	/* we assume all request payload was transferred */
> 
> -	/* we assume all request payload was transferred */
> +	/* we assume all request payload was transferred, residual == 0 */
> +	req->data_len = 0;
> 
> Note: this is the proper procedure. Otherwise bsg user will receive transfer
> residual of all payload. On the other hand you might have more precise residual
> information here, as received from the scsi transport? (Specially in the error
> case, perhaps in the future).
> 
>> +	blk_end_request(req, err, blk_rq_bytes(req));
> 
> -	blk_end_request(req, err, blk_rq_bytes(req));
> +	blk_end_bidi_request(req, err, req_len, rsp_len);
> 
>> +
>> +	fc_destroy_bsgjob(job);
>> +}
> 
> This should take care of all possible cases, (bidi or otherwise), and will
> return the proper transfer residual count of 0 to user-mode.

We should be calling blk_end_bidi_request() even in cases where there wasn't a 
req->next_rq ?

Here's what I would have done. Has your changes for setting req_len and 
req->data_len, and Seokman's mods for calling either blk_end_bidi_request() or 
blk_end_request() depending on whether there is a rsp request.

-- james s


/**
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
  * @job:	fc_bsg_job that is complete
  */
static void
fc_bsg_jobdone(struct fc_bsg_job *job)
{
	struct request *req = job->req;
	struct request *rsp = req->next_rq;
	unsigned long flags;
	unsigned rsp_len = 0, req_len = blk_rq_bytes(req);

	int err;

	spin_lock_irqsave(&job->job_lock, flags);
	job->state_flags |= FC_RQST_STATE_DONE;
	job->ref_cnt--;
	spin_unlock_irqrestore(&job->job_lock, flags);

	err = job->req->errors = job->reply->result;
	if (err < 0)
		/* we're only returning the result field in the reply */
		job->req->sense_len = sizeof(uint32_t);
	else
		job->req->sense_len = job->reply_len;

	/* we assume all request payload was transferred, residual == 0 */
	req->data_len = 0;

	if (rsp) {
		rsp_len = blk_rq_bytes(rsp);
		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
		/* set reply (bidi) residual */
		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
		blk_end_bidi_request(req, err, req_len, rsp_len);
	} else
		blk_end_request(req, err, req_len);

	fc_destroy_bsgjob(job);
}

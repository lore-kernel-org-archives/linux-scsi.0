From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sun, 15 Mar 2009 16:26:17 +0200
Message-ID: <49BD1009.10708@panasas.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BA8E1E.6080809@linux.vnet.ibm.com> <49BCCBC3.7020204@panasas.com> <49BCFF47.2050005@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:5440 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCOO1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2009 10:27:19 -0400
Received: by nf-out-0910.google.com with SMTP id d21so895395nfb.21
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2009 07:27:15 -0700 (PDT)
In-Reply-To: <49BCFF47.2050005@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, Seokmann Ju <seokmann.ju@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Giridhar Malavali <giridhar.malavali@qlogic.com>

James Smart wrote:
> Current patch is the RFC, at :
> http://marc.info/?l=linux-scsi&m=123436574018579&w=2
> 
> -- james s
> 
> Boaz Harrosh wrote:
>> My humble opinion is: That none of the patches should go in. It is easy
>> enough to use the API as it is, and it is more correct then any of the
>> suggested alternatives.
>>
>> Please point me to the latest code-base and I'll fix you a patch that I
>> think looks very simple and will work well.
>>
>> Cheers, have a good day
>> Boaz
>>   

My changes below

> +static void
> +fc_bsg_jobdone(struct fc_bsg_job *job)
> +{
> +	struct request *req = job->req;
> +	struct request *rsp = req->next_rq;
> +	unsigned long flags;
> +	unsigned rsp_len;

-	unsigned rsp_len;
+	unsigned rsp_len = 0, req_len = blk_rq_bytes(req);

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
> +	if (rsp) {
> +		rsp_len = blk_rq_bytes(rsp);
> +		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
> +		/* set reply (bidi) residual */
> +		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
> +	}
> +
> +	/* we assume all request payload was transferred */

-	/* we assume all request payload was transferred */
+	/* we assume all request payload was transferred, residual == 0 */
+	req->data_len = 0;

Note: this is the proper procedure. Otherwise bsg user will receive transfer
residual of all payload. On the other hand you might have more precise residual
information here, as received from the scsi transport? (Specially in the error
case, perhaps in the future).

> +	blk_end_request(req, err, blk_rq_bytes(req));

-	blk_end_request(req, err, blk_rq_bytes(req));
+	blk_end_bidi_request(req, err, req_len, rsp_len);

> +
> +	fc_destroy_bsgjob(job);
> +}

This should take care of all possible cases, (bidi or otherwise), and will
return the proper transfer residual count of 0 to user-mode.

Thanks
Boaz

(Sorry if it's a repost, we had a small email outage)

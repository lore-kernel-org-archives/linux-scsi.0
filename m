From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Mon, 16 Mar 2009 15:38:41 +0200
Message-ID: <49BE5661.7060603@panasas.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BCCAA4.5060104@panasas.com> <FEF98017-BE60-4CA8-BD53-6C69D8935BE3@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:8143 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752790AbZCPNjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 09:39:46 -0400
In-Reply-To: <FEF98017-BE60-4CA8-BD53-6C69D8935BE3@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Giridhar Malavali <giridhar.malavali@qlogic.com>

Seokmann Ju wrote:
> On Mar 15, 2009, at 2:30 AM, Boaz Harrosh wrote:
> 
>> Seokmann Ju wrote:
>>> On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:
>>>
>>>> On Feb 11, 2009, at 7:13 AM, James Smart wrote:
>>>>
>>>>> Trying to kick-start this again...
>>>>> I've updated the prior RFC with the comments from Seokmann,
>>>>> SvenFujita, and Boaz. I would still like review on the
>>>>> blk_xxx completion calls in the std and error paths.
>>>> I'm looking the driver changes to match it with latest updates in
>>>> the transport layer.
>>>> The driver with the changes should be available within a couple of
>>>> weeks.
>>> Here is a change that I've made for transport layer while I'm testing
>>> the feature.
>>> ---
>>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>>> scsi_transport_fc.c
>>> index 63ab7bc..4bca164 100644
>>> --- a/drivers/scsi/scsi_transport_fc.c
>>> +++ b/drivers/scsi/scsi_transport_fc.c
>>> @@ -3435,10 +3435,11 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>>>                 BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
>>>                 /* set reply (bidi) residual */
>>>                 rsp->data_len = (rsp_len - job->reply-
>>>> reply_payload_rcv_len);
>> This part looks a bit white-space broken.
>>
>>> -       }
>>> +               blk_end_bidi_request(req, err, blk_rq_bytes(req),
>>> +                   job->reply->reply_payload_rcv_len);
>>>
>>> -       /* we assume all request payload was transferred */
>>> -       blk_end_request(req, err, blk_rq_bytes(req));
>>> +       } else
>>> +               blk_end_request(req, err, blk_rq_bytes(req));
>> I still do not like this version for more then one reason. There is
>> a more proper simpler way.
>>
>> Where is the code-base this is patching? I'll make a proper patch  
>> for you.
> I took James S's patch from here.
> http://lwn.net/Articles/318731/
> 

Not good, sorry. Quoted the original patch in link above please change
lines below

James Smart wrote:
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
> Thank you,
> Seokmann
> 

This should take care of all possible cases, (bidi or otherwise), and will
return the proper transfer residual count of 0 to user-mode.

Thanks
Boaz

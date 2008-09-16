From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface
Date: Mon, 15 Sep 2008 18:00:48 -0700
Message-ID: <E107B586-840C-4367-A6DE-DECA5D649889@qlogic.com>
References: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com> <48CA9DB3.20005@emulex.com> <20080916050551A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:47523 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYIPBAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2008 21:00:51 -0400
In-Reply-To: <20080916050551A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com


On Sep 15, 2008, at 1:06 PM, FUJITA Tomonori wrote:

> On Fri, 12 Sep 2008 12:49:55 -0400
> James Smart <James.Smart@Emulex.Com> wrote:
>
>> Seokmann,
>>
>> There are number of fundamental issues with this patch that need to  
>> be
>> corrected. I'll be at plumbers conference next week, and will be  
>> able to
>> work through this. Please look me up if you will be there. Otherwise,
>> I'll just post a revised patch.
>>
>> Here are the issues as I see them:
>>
>> - There is no concept of a Request Structure, that supplies the  
>> type of
>>   request and other parameters (such as a timeout). This should have
>>   come from the cdb bytes.  Over time, we can expand this request
>>   structure for other types of requests, not just els/ct passthru.
>>
>> - There is no true definition of what the request payload should be.
>>   It's implied that it should be a fully built frame header,  
>> followed by
>>   payload.  We should be striking the frame header, and just stating
>>   that for els/ct, the request payload is the tx sequence payload.
>>
>> - There is no definition of what the response payload should be. Does
>>   it contain a header too ? or what ? If the request is rejected,
>>   could it also contain other frame types ? We should simply state
>>   that it is the rx sequence payload, and only if successful.
>>
>> - There is no concept or definition of a Reply structure, which  
>> should
>>   be stuffed into the request sense area.  This should be well  
>> defined,
>>   and matched to the request structure. We whould supply status  
>> values,
>>   or response data from RJT's, BSY's, aborted status's, etc.
>
> If fc needs to handle several types of requests, I think that it would
> be make sense to define fc request/response structure. But the timeout
> is in bsg's header so I'm not sure adding the timeout to fc request
> structure.
That is right. the timeout entry is available in the sg_io_v4 structure.

>> - Have you tested how large of a single buffer you can supply and get
>>   by on the single sg vector ?  For nameserver payloads we should
>>   support bigger buffers - 4k as a minimum.
>
> bsg uses blk_rq_map_user to map the user pages, so you can handle much
> bigger buffers than 4k.
OK. Thanks for the clarification.

> But the above part in the current patch needs to be fixed:
>
> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport *rport,
> +			  struct request *req)
> +{
>
> ...
>
> +	/* ELS doesn't support multiple SG */
> +	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
> +		printk(KERN_WARNING "ERROR: multiple segments req %u,"
> +		    " rsp %u  are not supported for ELS services\n",
> +		    req->bio->bi_vcnt, rsp->bio->bi_vcnt);
> +		return -EINVAL;
> +	}
> +
> +	ret = issue_fc_service(rport, bio_data(req->bio), req->data_len,
> +			bio_data(rsp->bio), rsp->data_len, req->sense);
>
> This works for SMP that handles only small buffers but it doesn't work
> for large buffers.
Yes, that is true for the CT services. For ELS services, the SG   
always has to be a single, as far as I understand.
Changes will be made accordingly.

Thank you,
Seokmann


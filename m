From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Tue, 28 Oct 2008 09:03:50 -0700
Message-ID: <D1992D36-6205-41FB-AE70-D6A836E24D8A@qlogic.com>
References: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>	<20081024125449T.fujita.tomonori@lab.ntt.co.jp>	<49043A7C.8030105@panasas.com> <20081027131110Z.fujita.tomonori@lab.ntt.co.jp> <490579C5.5080102@panasas.com> <C411DA16-2D8D-4B06-91B4-EB2B2B1984E5@qlogic.com> <4906C5DB.1010402@panasas.com> <EE6A1268-D18E-497E-AF5F-FF78F4A837E4@qlogic.com> <490723E8.9050801@panasas.com> <490727E6.6010503@panasas.com> <490728BD.3080005@panasas.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:57483 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYJ1QDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 12:03:53 -0400
In-Reply-To: <490728BD.3080005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Smart@Emulex.Com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com


On Oct 28, 2008, at 7:59 AM, Boaz Harrosh wrote:

> Boaz Harrosh wrote:
>> Boaz Harrosh wrote:
...
[snip]
...
>>> if the attached file is the code you tested then it is wrong look  
>>> here:
>>>
>>>> +
>>>> +	if (service->srv_reply.residual) {
>>>> +		service->req->data_len = 0;
>>>> +		service->req->next_rq->data_len = service->srv_reply.residual;
>>>> +	} else {
>>>> +		service->req->data_len = 0;
>>>> +		service->req->next_rq->data_len = 0;
>>>> +	}
>>>> +
>>> Move above to after the blk_end_bidi_request call
>>>
>>>> +	blk_end_bidi_request(service->req, 0, blk_rq_bytes(service->req),
>>>> +	    service->req->next_rq ? blk_rq_bytes(service->req- 
>>>> >next_rq) : 0);
>>> You must call blk_end_bidi_request before you change service->req- 
>>> >data_len
>>> to hold the residual (or 0). Otherwise you damage the request.
>>>
>>>> +	service->req->end_io(service->req, 0);
>>
>> Hmm, on re inspection req->end_io(...) called here has the same  
>> problem.
>> Are you sure it's needed?
>>
>
> No you do not call req->end_io(..) directly. It eventual gets called
> by blk_end_bidi_request() inside end_that_request_last(). (Once
> all byte are completed)
Yes, that is correct. Thank you for the correction - end_io() call has  
removed.
Other than setting req->errors field and req->next_rq->errors, there  
are not
many things to do in the callback prior to calling  
blk_end_bidi_request().

With the clean-up, updated patch will be followed.

Thank you,
Seokmann



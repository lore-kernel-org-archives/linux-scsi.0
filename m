From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support - revised II
Date: Thu, 30 Oct 2008 07:47:12 -0700
Message-ID: <FD7E6B80-6F5E-444E-AA39-76E33D6E03F7@qlogic.com>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com> <20081030131825M.fujita.tomonori@lab.ntt.co.jp> <BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com> <4909C0DA.305@panasas.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:43438 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYJ3OrO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 10:47:14 -0400
In-Reply-To: <4909C0DA.305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com


On Oct 30, 2008, at 7:12 AM, Boaz Harrosh wrote:

> Seokmann Ju wrote:
>> On Oct 29, 2008, at 9:18 PM, FUJITA Tomonori wrote:
>>
>>> On Wed, 29 Oct 2008 05:48:03 -0700
>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>
>>>> From f32b386a61a23f408974f2289cd34200f59401e1 Mon Sep 17 00:00:00
>>>> 2001
>>>> From: root <root@linux-atl-00.qlogic.com>
>>>> Date: Tue, 28 Oct 2008 19:27:15 -0700
>>>> Subject: [PATCH] scsi_transport_fc: FC pass through support
>>>>
>>>> This patch will add FC pass through support.
>>>> The FC pass through support is service request handling mechanism
>>>> for FC specification defined services including,
>>>> - Link Services (Basic LS, Extended LS)
>>>> - Generic Services (FC-CT - Common Transport)
>>>> The support utilize BSG (Block layer SCSI Generic) interface with
>>>> bidi (bi-directional) nature in handling the service requests.
>>>>
>>>> This patch added following featues in the support
>>>> - FC service structure has defined to transport service requests
>>>> - Handles the service request in asynchronous manner - LLD
>>>> - Timeout capability
>>>> - Abort capability
>>>>
>>>> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
>>>> ---
>>>> drivers/scsi/scsi_transport_fc.c |  216 +++++++++++++++++++++++++++
>>>> ++
>>>> ++++++++-
>>>> include/scsi/scsi_transport_fc.h |   81 ++++++++++++++-
>>>> 2 files changed, 294 insertions(+), 3 deletions(-)
>>> First, the patch looks corrupt (I can't apply this). I guess that  
>>> tabs
>>> are converted to spaces.
>> Sorry, whenever I send patches, it makes me to worry about it... but,
>> I'm still struggling to find what causes the problem.
>> Sometimes it worked (guessing for shorter ones).
>> I will submit the patch along with attachment next time.
>> BTW: I use the Mail on my Mac... any comments on this problem would  
>> be
>> greatly appreciated...
>>
>>>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>>>> scsi_transport_fc.c
>>>> index 1e71abf..e26e8e0 100644
>>>> --- a/drivers/scsi/scsi_transport_fc.c
>>>> +++ b/drivers/scsi/scsi_transport_fc.c
> <snip>
>>>> +
>>>> +static void fc_service_done(struct fc_service *service)
>>>> +{
>>>> +
>>>> +	if (service->service_state_flag != FC_SERVICE_STATE_DONE) {
>>>> +		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT)
>>>> +			printk(KERN_ERR "ERROR: FC service timed out\n");
>>>> +		else if (service->service_state_flag ==
>>>> +		    FC_SERVICE_STATE_ABORTED)
>>>> +			printk(KERN_ERR "ERROR: FC service aborted\n");
>>>> +		else
>>>> +			printk(KERN_ERR "ERROR: FC service not finished\n");
>>>> +	}
>>>> +
>>>> +	if (service->srv_reply.status != FC_SERVICE_COMPLETE) {
>>>> +		printk(KERN_ERR "ERROR: FC service to rport %p failed with"
>>>> +		    " status 0x%x\n", service->rport,
>>>> +		    service->srv_reply.status);
>>>> +	}
>>>> +
>>>> +	service->req->errors = service->srv_reply.status;
>>>> +	service->req->next_rq->errors = service->srv_reply.status;
>>> We don't need to save service->srv_reply.status at two places
>>> service->req is appropriate.
>> OK. It is removed.
>>
>>>> +	blk_end_bidi_request(service->req, service->srv_reply.status,
>>>> +	    blk_rq_bytes(service->req),
>>>> +	    service->req->next_rq ? blk_rq_bytes(service->req->next_rq) :
>>>> 0);
>
> From what James said I understand that you should do:
> +	blk_end_bidi_request(service->req, service->req->errors ? -EIO : 0,
> +		blk_rq_bytes(service->req),
> +		service->req->next_rq ? blk_rq_bytes(service->req->next_rq) : 0);
Yes, that is right. I will make the change accordingly.
Thanks for the comment.

>>>> +
>>>> +	kfree(service->payload_dma);
>>>> +	kfree(service->response_dma);
>>>> +	kfree(service);
>>>> +}
>>>> +
> <snip>
>
> Boaz


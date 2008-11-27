From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Thu, 27 Nov 2008 13:51:51 +0200
Message-ID: <492E89D7.1020502@panasas.com>
References: <1227043498.4949.21.camel@ogier>	<20081127160331I.fujita.tomonori@lab.ntt.co.jp>	<492E6143.2080407@panasas.com> <20081127185406L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:25155 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752606AbYK0Lv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2008 06:51:59 -0500
In-Reply-To: <20081127185406L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com

FUJITA Tomonori wrote:
> On Thu, 27 Nov 2008 10:58:43 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Tue, 18 Nov 2008 16:24:58 -0500
>>> James Smart <James.Smart@Emulex.Com> wrote:
>>>
>>>> All,
>>>>
>>>> I've reworked Seokmann's patch for the following items:
>>>> - Add an fchost interface for bsg requests
>>>>
>>>> - Formalized the request/response structures that I expect
>>>>   to have us stuff into the bsg cmd/sense data areas. These
>>>>   are now genericized so we can essentially pass any kind of
>>>>   transaction. It can be a request that has no transmit or
>>>>   receive payload, and simply returns a response.
>>>>
>>>> - A new file was created, scsi_bsg_fc.h, which contains the
>>>>   request/response data structures that should be shared
>>>>   between the application and the kernel entities. 
>>>>
>>>> - I stripped out some things that were in the request
>>>>   structure that were actually LLD fields. Instead, I added
>>>>   a dd_bsgsize structure to the template, so the transport
>>>>   will allocate LLD work space along with the job structure.
>>>>   I expect the missing fields to move to this area.
>>>>
>>>> - I've made a strong attempt at ensuring that the request
>>>>   has all the information necessary for the LLD, so that
>>>>   there is no need to have the LLD remap the transmit payload
>>>>   to figure things out. Granted, this comes at the cost of
>>>>   replicating some data items.
>>>>
>>>>   Sven, I've added the CT information you needed as part of this.
>>>>
>>>> - I've renamed things quite a bit, hoping to make it clarity
>>>>   better. The "service" struct is now a job. I still have
>>>>   headaches with "request" (is it the blk request, or the job
>>>>   request, or what..)
>>>>
>>>> - The CT/ELS response is a bit funky. I've noted that the
>>>>   way Emulex returns a response, vs Qlogic is a bit different,
>>>>   thus the 2 ways to indicate "reject".
>>>>
>>>> - fixed a couple of bugs in Seokmann's code, in the teardown,
>>>>   error flows, request que dma settings, etc.
>>>>
>>>> - I added a "vendor_id" field to the scsi_host_template to
>>>>   use when verifying that the recipient knows how to decode
>>>>   vendor-specific message. I didn't do this with the netlink
>>>>   things as I was prepping it to not break kabi in existing
>>>>   and older kernels. But, I believe this is a good time to
>>>>   add it.
>>>>
>>>> - I've started the Documentation/scsi/scsi_transport_fc.txt
>>>>   documentation, but punted finishing it in lieu of sending
>>>>   this RFC. I'm starting from Seokman's original emails and
>>>>   will be updating for this reformat.
>>>>
>>>> I'm only starting to debug this, so user beware.
>>>>
>>>> I could really use some code review from Fujita or Boaz, to
>>>> make sure I'm calling the right blk_xx completion functions
>>>> relative to the setup flow, and to ensure that the "goose"
>>>> when I jump out while the rport is blocked is correct.
>>>>
>>>> Comments welcome
>>>>
>>>> -- james s
>>>>
>>>>
>>>>
>>>>  Signed-off-by: James Smart <james.smart@emulex.com>
>>>>
>>>>  ---
>>>>
>>>>  Documentation/scsi/scsi_fc_transport.txt |   11 
>>>>  Documentation/scsi/scsi_mid_low_api.txt  |    5 
>>>>  drivers/scsi/scsi_transport_fc.c         |  581 ++++++++++++++++++++++++++++++-
>>>>  include/scsi/scsi_bsg_fc.h               |  291 +++++++++++++++
>>>>  include/scsi/scsi_host.h                 |    9 
>>>>  include/scsi/scsi_transport_fc.h         |   53 ++
>>>>  6 files changed, 946 insertions(+), 4 deletions(-)
>>> (snip)
>>>
>>>> +/**
>>>> + * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
>>>> + *                  completed
>>>> + * @job:	fc_bsg_job that is complete
>>>> + */
>>>> +static void
>>>> +fc_bsg_jobdone(struct fc_bsg_job *job)
>>>> +{
>>>> +	struct request *req = job->req->next_rq;
>>>> +	struct request *rsp = req->next_rq;
>>>> +	unsigned long flags;
>>>> +	int err;
>> +	unsigned bytes_requested = 0;
>>
>>>> +
>>>> +	spin_lock_irqsave(&job->job_lock, flags);
>>>> +	job->state_flags |= FC_RQST_STATE_DONE;
>>>> +	job->ref_cnt--;
>>>> +	spin_unlock_irqrestore(&job->job_lock, flags);
>>>> +
>>>> +	err = job->req->errors = job->reply->result;
>>>> +	if (err < 0)
>>>> +		/* we're only returning the result field in the reply */
>>>> +		job->req->sense_len = sizeof(uint32_t);
>>>> +	else
>>>> +		job->req->sense_len = job->reply_len;
>>>> +
>>>> +	/*
>>>> +	 * we'll cheat: tell blk layer all of the xmt data was sent.
>>>> +	 * but try to be honest about the amount of rcv data received
>>>> +	 */
>>>> +	if (rsp)
>>>> +		blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
>>>> +	    			     job->reply->reply_payload_rcv_len);
>>>> +	else
>>>> +		blk_end_request(job->req, err, blk_rq_bytes(job->req));
>>> I think that you can use blk_end_bidi_request() for non-bidi requests:
>>>
>>> 	blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
>>> 			rsp ?
>>> 			 job->reply->reply_payload_rcv_len : 0);
>>>
>>>
>>> I guess that it would be better to have one function to complete a
>>> request, instead of blk_end_bidi_request and blk_end_request.
>>>
>>>
>> +	/*
>> +	 * tell blk layer all of the xmt data was sent.
>> +	 * but set residual count to: requested - received
>> +	 */
>> +
>> +	if (rsp) {
>> +		bytes_requested = blk_rq_bytes(rsp);
>> +		rsp->data_len = bytes_requested - job->reply->reply_payload_rcv_len;
>> +	}
>> +
>> +	blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req), bytes_requested);
>>
>> The residual count is left in req->data_len. Does bsg have a way to return the
>> residual to user-mode? It must, since Pete was using that for sure. Note that
>> you are looking for the bidi_read residual count.
> 
> Yeah, bsg has. struct sg_io_v4 has:
> 
> __s32 din_resid;	/* [o] din_xfer_len - actual_din_xfer_len */
> __s32 dout_resid;	/* [o] dout_xfer_len - actual_dout_xfer_len */
> 
> 
>> As was said by people. You must complete ALL bytes on both sides. Residual information
>> is passed through req->data_len. Other wise the request is still active.
>>
>> (And yes blk_end_request uses blk_end_bidi_request internally)
> 
> We always complete all bytes on both sides. So why we do something
> like:
> 
> int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
> {
> 	unsigned int bidi_bytes	= 0;
> 
> 	if (blk_bidi_rq(rq))
> 		bidi_bytes = req->next_rq->data_len;
> 
> 	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
> }
> 
> The callers can do something like:
> 
> blk_end_request(rq, err, rq->data_len);
> rq-->next_rq->data_len = resid;

Sorry TOMO, I do not understand what you mean. Do you say that we should
change blk_end_request() in blk-core.c ?

In anyway, the code you suggest has a bug you can not use rq-> after call to blk_end_io()
because it might not exist at this point. You must set residual before. And also
you should use  blk_rq_bytes(rq). To see how a request is fully competed see
scsi_end_bidi_request().

Boaz


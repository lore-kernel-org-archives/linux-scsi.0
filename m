From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support - revised II
Date: Thu, 30 Oct 2008 18:38:04 -0700
Message-ID: <8F8E62D4-233D-4347-ACAE-2018C6ADDA00@qlogic.com>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com> <20081030131825M.fujita.tomonori@lab.ntt.co.jp> <BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:19171 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYJaBiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 21:38:09 -0400
In-Reply-To: <BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>


On Oct 30, 2008, at 6:37 AM, Seokmann Ju wrote:

>
> On Oct 29, 2008, at 9:18 PM, FUJITA Tomonori wrote:
[snip]
>
>
>>> +	    GFP_KERNEL);
>>> +	sg_init_table(service->payload_dma, req->nr_phys_segments);
>>> +	service->payload_sg_cnt =
>>> +	    blk_rq_map_sg(q, req, service->payload_dma);
>>> +	service->payload = (void *) bio_data(req->bio);
>>
>> You don't need service->payload. We use scatterlist for data  
>> transfer.
> Yes. Removed.
I need a step back here.
I understand that modules get involved in handling pass through are  
treat
FC service requests as opaque data.
However, there are some case where LLDs need to retrieve the contents of
the service request and pull out some information - for example, opcode
of the ELS for the case of qla2xxx.
I guess there might be some other LLDs that need to pull out some
information from the service request for similar reasons.
For that purpose, I think it would be good to keep 'payload' and  
'response'
field instead.
Any comment?

>
>
>>> +	service->payload_size = req->data_len;
>>> +
>>> +	service->response_dma = (struct scatterlist *)
>>> +	    kzalloc(sizeof (struct scatterlist) * rsp->nr_phys_segments,
>>> +	    GFP_KERNEL);
>>> +	sg_init_table(service->response_dma, rsp->nr_phys_segments);
>>> +	service->response_sg_cnt =
>>> +	    blk_rq_map_sg(q, rsp, service->response_dma);
>>> +	service->response = bio_data(rsp->bio);
>>
>> Ditto.
> OK.
Same here.

Seokmann

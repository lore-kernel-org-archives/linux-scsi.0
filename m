From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Tue, 24 Feb 2009 06:25:35 -0800
Message-ID: <9FE21C07-82C4-46EF-855B-D8EFCA2E41D0@qlogic.com>
References: <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <ADDE90B2-587A-4503-9609-4FED45732D3C@qlogic.com> <20090221145953E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33721 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZBXOZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 09:25:40 -0500
In-Reply-To: <20090221145953E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, "bharrosh@panasas.com" <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Feb 20, 2009, at 10:00 PM, FUJITA Tomonori wrote:

> On Thu, 19 Feb 2009 18:33:43 -0800
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>>
>> On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:
>>
>>>
>>> On Feb 11, 2009, at 7:13 AM, James Smart wrote:
>>>
>>>> Trying to kick-start this again...
>>>> I've updated the prior RFC with the comments from Seokmann,
>>>> SvenFujita, and Boaz. I would still like review on the
>>>> blk_xxx completion calls in the std and error paths.
>>> I'm looking the driver changes to match it with latest updates in
>>> the transport layer.
>>> The driver with the changes should be available within a couple of
>>> weeks.
>> When the FC transport layer calls fc_bsg_map_buffer(), it eventually
>> calls
>> blk_rq_map_sg() to build sg_list for mapped bio in the request
>> structure.
>> I'm having trouble, however, in getting the sg_list for both  
>> dout_xferp
>> and din_xferp, which is mapped into the bio in the request structure.
>> With the pass-thru - Rev V, the sg_list returned from the
>> fc_bsg_map_buffer()
>> seems not right, particularly, the dma_address and dma_length fields
>> are NULL.
>> The sg_cnt and payload_len of the request_payload/reply_payload are
>> correctly
>> set by the function, though.
>
> I've not read the code yet but the above behavior doesn't sound a bug.
>
> dma_map_sg is a function that sets up the dma_address and dma_length
> fields in a scatter list. LLDs gets a request from the transport layer
> and need to call dma_map_sg.
Thanks for the point.
Actually, we talked about this before as below, somehow, I've forgotten.
http://markmail.org/message/vfxzsupax4xhozfy


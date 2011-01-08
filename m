From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Fri, 07 Jan 2011 22:23:06 -0600
Message-ID: <4D27E6AA.5010304@cs.wisc.edu>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6> <4D27A500.2020009@cs.wisc.edu> <4D27A628.7040008@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50860 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1AHE01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 23:26:27 -0500
In-Reply-To: <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 01/07/2011 06:09 PM, Karen Xie wrote:
> Hi, Mike,
>
> Yes, the message size is different between cxgb3i and cxgb4i. I am not

I am not sure if we are talking about the same thing. Mostly I am 
confused a little :)

For pool I just mean gl_skb. So I mean cxgb3i could make its own pool 
like it is now. Basically just move gl_skb to some cxgb3i struct and mv 
ddp_alloc_gl_skb related code to cxgb3i.

Then cxgb4i could do something similar if possible. Below when I was 
asking about variable sizes I meant that for cxgb4i it seemed harder 
because ddp_set_map->ddp_ppod_write_idata->alloc_wr allocates the skb 
based on wr_len.

> using the pool mainly because this is on the tx side and tx skb
> recycling does not seem to be utilized much.
>

What pool are you talking about? Some sort of skb pool from the network 
layer?

> Karen
>
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Friday, January 07, 2011 3:48 PM
> To: open-iscsi@googlegroups.com
> Cc: Karen Xie; linux-scsi@vger.kernel.org;
> James.Bottomley@HansenPartnership.com
> Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
>
> On 01/07/2011 05:42 PM, Mike Christie wrote:
>> On 01/07/2011 04:45 PM, kxie@chelsio.com wrote:
>>> [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info.
>>>
>>> From: Karen Xie<kxie@chelsio.com>
>>>
>>> Remove gl_skb from cxgbi_ddp_info as it is only used by cxgb3i.
>>>
>>> Signed-off-by: Karen Xie<kxie@chelsio.com>
>>> ---
>>> drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 51
>>> +++++-------------------------------
>>> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 -
>>> drivers/scsi/cxgbi/libcxgbi.c | 15 +----------
>>> drivers/scsi/cxgbi/libcxgbi.h | 3 --
>>> 4 files changed, 8 insertions(+), 63 deletions(-)
>>>
>>> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>> b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>> index a129a17..e2362b9 100644
>>> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>>> @@ -1108,10 +1108,11 @@ static int ddp_set_map(struct cxgbi_sock
> *csk,
>>> struct cxgbi_pagepod_hdr *hdr,
>>> csk, idx, npods, gl);
>>>
>>> for (i = 0; i<  npods; i++, idx++, pm_addr += PPOD_SIZE) {
>>> - struct sk_buff *skb = ddp->gl_skb[idx];
>>> + struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
>>> + PPOD_SIZE, 0, GFP_ATOMIC);
>>
>>
>> I think you want to try to avoid lots of little GFP_ATOMIC allocations
>> in the main IO path, because it probably is bad for performance and
>> because they can fail and you can be stuck with no mem but other
>> allocations needing to write data out.
>>
>> Did you want to just make each driver allocate a pool/map, then
> allocate
>> from that pool/map in these places (cxgb4i does a similar skb
> allocation
>> at these points right?)?
>>
>
> Oh yeah, is the complication that the cxgb3i driver uses 1 size for the
> objects but cxgb4i is variable?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Fri, 7 Jan 2011 16:09:03 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6> <4D27A500.2020009@cs.wisc.edu> <4D27A628.7040008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:8764 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1AHAL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 19:11:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Hi, Mike,

Yes, the message size is different between cxgb3i and cxgb4i. I am not
using the pool mainly because this is on the tx side and tx skb
recycling does not seem to be utilized much.

Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Friday, January 07, 2011 3:48 PM
To: open-iscsi@googlegroups.com
Cc: Karen Xie; linux-scsi@vger.kernel.org;
James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info

On 01/07/2011 05:42 PM, Mike Christie wrote:
> On 01/07/2011 04:45 PM, kxie@chelsio.com wrote:
>> [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info.
>>
>> From: Karen Xie<kxie@chelsio.com>
>>
>> Remove gl_skb from cxgbi_ddp_info as it is only used by cxgb3i.
>>
>> Signed-off-by: Karen Xie<kxie@chelsio.com>
>> ---
>> drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 51
>> +++++-------------------------------
>> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 -
>> drivers/scsi/cxgbi/libcxgbi.c | 15 +----------
>> drivers/scsi/cxgbi/libcxgbi.h | 3 --
>> 4 files changed, 8 insertions(+), 63 deletions(-)
>>
>> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>> b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>> index a129a17..e2362b9 100644
>> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
>> @@ -1108,10 +1108,11 @@ static int ddp_set_map(struct cxgbi_sock
*csk,
>> struct cxgbi_pagepod_hdr *hdr,
>> csk, idx, npods, gl);
>>
>> for (i = 0; i< npods; i++, idx++, pm_addr += PPOD_SIZE) {
>> - struct sk_buff *skb = ddp->gl_skb[idx];
>> + struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
>> + PPOD_SIZE, 0, GFP_ATOMIC);
>
>
> I think you want to try to avoid lots of little GFP_ATOMIC allocations
> in the main IO path, because it probably is bad for performance and
> because they can fail and you can be stuck with no mem but other
> allocations needing to write data out.
>
> Did you want to just make each driver allocate a pool/map, then
allocate
> from that pool/map in these places (cxgb4i does a similar skb
allocation
> at these points right?)?
>

Oh yeah, is the complication that the cxgb3i driver uses 1 size for the 
objects but cxgb4i is variable?

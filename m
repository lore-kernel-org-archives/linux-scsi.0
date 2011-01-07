From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Fri, 07 Jan 2011 17:42:56 -0600
Message-ID: <4D27A500.2020009@cs.wisc.edu>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38455 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1AGXqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 18:46:17 -0500
In-Reply-To: <201101072245.p07MjdBm027576@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, James.Bottomley@HansenPartnership.com

On 01/07/2011 04:45 PM, kxie@chelsio.com wrote:
> [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info.
>
> From: Karen Xie<kxie@chelsio.com>
>
> Remove gl_skb from cxgbi_ddp_info as it is only used by cxgb3i.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>
> ---
>   drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   51 +++++-------------------------------
>   drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 -
>   drivers/scsi/cxgbi/libcxgbi.c      |   15 +----------
>   drivers/scsi/cxgbi/libcxgbi.h      |    3 --
>   4 files changed, 8 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index a129a17..e2362b9 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -1108,10 +1108,11 @@ static int ddp_set_map(struct cxgbi_sock *csk, struct cxgbi_pagepod_hdr *hdr,
>   		csk, idx, npods, gl);
>
>   	for (i = 0; i<  npods; i++, idx++, pm_addr += PPOD_SIZE) {
> -		struct sk_buff *skb = ddp->gl_skb[idx];
> +		struct sk_buff *skb = alloc_wr(sizeof(struct ulp_mem_io) +
> +						PPOD_SIZE, 0, GFP_ATOMIC);


I think you want to try to avoid lots of little GFP_ATOMIC allocations 
in the main IO path, because it probably is bad for performance and 
because they can fail and you can be stuck with no mem but other 
allocations needing to write data out.

Did you want to just make each driver allocate a pool/map, then allocate 
from that pool/map in these places (cxgb4i does a similar skb allocation 
at these points right?)?

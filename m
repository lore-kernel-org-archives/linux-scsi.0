From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
 non-contiguous descriptors
Date: Tue, 15 Jan 2013 16:19:54 +0000
Message-ID: <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51670 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803Ab3AOQT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2013 11:19:58 -0500
In-Reply-To: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org

On Tue, 2013-01-15 at 21:31 +0530, Subhash Jadavani wrote:
> blk_rq_map_sg() function merges the physically contiguous pages to use same
> scatter-gather node without checking if their page descriptors are
> contiguous or not.
> 
> Now when dma_map_sg() is called on the scatter gather list, it would
> take the base page pointer from each node (one by one) and iterates
> through all of the pages in same sg node by keep incrementing the base
> page pointer with the assumption that physically contiguous pages will
> have their page descriptor address contiguous which may not be true
> if SPARSEMEM config is enabled. So here we may end referring to invalid
> page descriptor.
> 
> Following table shows the example of physically contiguous pages but
> their page descriptor addresses non-contiguous.
> -------------------------------------------
> | Page Descriptor    |   Physical Address |
> ------------------------------------------
> | 0xc1e43fdc         |   0xdffff000       |
> | 0xc2052000         |   0xe0000000       |
> -------------------------------------------
> 
> With this patch, relevant blk-merge functions will also check if the
> physically contiguous pages are having page descriptors address contiguous
> or not? If not then, these pages are separated to be in different
> scatter-gather nodes.

How does this manifest as a bug?

The discontinuity is in struct page arrays, which hardware doesn't care
about.  All we need is to get from struct page to the physical address
for programming the hardware, for which we use the sg_phys() inline
function.

Even given we have a two page physical contiguity at 0xdffff000 in your
example, the sg list entry contains a length of 8192 and a page_link of
0xc1e43fdc, which we transform to the correct physical address and
length.

James



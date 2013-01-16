From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with non-contiguous
 descriptors
Date: Wed, 16 Jan 2013 12:07:53 +0530
Message-ID: <50F64AC1.3040304@codeaurora.org>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2428 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3APGh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jan 2013 01:37:59 -0500
In-Reply-To: <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, martin.petersen@oracle.com, asias@redhat.com, tj@kernel.org

On 1/15/2013 9:49 PM, James Bottomley wrote:
> On Tue, 2013-01-15 at 21:31 +0530, Subhash Jadavani wrote:
>> blk_rq_map_sg() function merges the physically contiguous pages to use same
>> scatter-gather node without checking if their page descriptors are
>> contiguous or not.
>>
>> Now when dma_map_sg() is called on the scatter gather list, it would
>> take the base page pointer from each node (one by one) and iterates
>> through all of the pages in same sg node by keep incrementing the base
>> page pointer with the assumption that physically contiguous pages will
>> have their page descriptor address contiguous which may not be true
>> if SPARSEMEM config is enabled. So here we may end referring to invalid
>> page descriptor.
>>
>> Following table shows the example of physically contiguous pages but
>> their page descriptor addresses non-contiguous.
>> -------------------------------------------
>> | Page Descriptor    |   Physical Address |
>> ------------------------------------------
>> | 0xc1e43fdc         |   0xdffff000       |
>> | 0xc2052000         |   0xe0000000       |
>> -------------------------------------------
>>
>> With this patch, relevant blk-merge functions will also check if the
>> physically contiguous pages are having page descriptors address contiguous
>> or not? If not then, these pages are separated to be in different
>> scatter-gather nodes.
> How does this manifest as a bug?
>
> The discontinuity is in struct page arrays, which hardware doesn't care
> about.  All we need is to get from struct page to the physical address
> for programming the hardware, for which we use the sg_phys() inline
> function.
>
> Even given we have a two page physical contiguity at 0xdffff000 in your
> example, the sg list entry contains a length of 8192 and a page_link of
> 0xc1e43fdc, which we transform to the correct physical address and
> length.
Thanks James for looking at this patch.

Let's assume this scenario.
PAGE_SIZE = 4096 (4K),
2 page descriptors (as mentioned commit text) whose own addresses are 
discontingous but they point to physically contiguous memory space, 
sizeof(struct page) is 36 bytes.
Only one SG node created in Scatter Gather list (by blk_rq_map_sg) with 
this node's page_link=0xc1e43fdc, length=8192, offset=0

Now consider this call stack from MMC block driver (this is on the ARmv7 
based board):
     [   98.918174] [<c001b50c>] (v7_dma_inv_range+0x30/0x48) from 
[<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c)
     [   98.927819] [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c) from 
[<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c)
     [   98.937982] [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c) from 
[<c0017ff8>] (dma_map_sg+0x3c/0x114)
     [   98.947169] [<c0017ff8>] (dma_map_sg+0x3c/0x114) from 
[<c0532c40>] (msmsdcc_prep_xfer+0x50/0x10c)
     [   98.956020] [<c0532c40>] (msmsdcc_prep_xfer+0x50/0x10c) from 
[<c0539664>] (msmsdcc_pre_req+0x78/0x98)
     [   98.965237] [<c0539664>] (msmsdcc_pre_req+0x78/0x98) from 
[<c0521d98>] (mmc_start_req+0x4c/0x1c4)
     [   98.974088] [<c0521d98>] (mmc_start_req+0x4c/0x1c4) from 
[<c052faa0>] (mmc_blk_issue_rw_rq+0x3a0/0x84c)
     [   98.983457] [<c052faa0>] (mmc_blk_issue_rw_rq+0x3a0/0x84c) from 
[<c05304b4>] (mmc_blk_issue_rq+0x568/0x5c4)
     [   98.993193] [<c05304b4>] (mmc_blk_issue_rq+0x568/0x5c4) from 
[<c0530718>] (mmc_queue_thread+0xb4/0x120)
     [   99.002563] [<c0530718>] (mmc_queue_thread+0xb4/0x120) from 
[<c0096400>] (kthread+0x80/0x8c)
     [   99.010987] [<c0096400>] (kthread+0x80/0x8c) from [<c000f028>] 
(kernel_thread_exit+0x0/0x8)

dma_cache_maint_page() function iterates through each page in single sg 
node, maps it to virtual space and then call the cache maintainance 
operation on that page.

With above scenario, first page descriptor would be 0xc1e43fdc, which 
would be mapped virtual address by either kmap() (if it's higmem page) 
or by page_address() (if it's low mem page).

Now as the size of the sg node is 8192 bytes, dma_cache_maint_page() 
function increments the page pointer (pointed by page_link of sg node) 
to get to the next descriptor. page++ would yield page descriptor 
address = 0xc1e44000 (0xc1e43fdc + sizeof (struct page)). 0xc1e44000 is 
not pointing any real page descriptor so when calls 
page_address(0xc1e44000) to get virtual address of the page, it returns 
invalid virtual address. Now when we try to dereference that invalid 
virtual address in cache maintainance functions, it would result into 
"Unable to handle kernel paging request at virtual address xxxxxxxx" 
error and kernel crashes.

Regards,
Subhash
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


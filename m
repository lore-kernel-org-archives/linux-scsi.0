From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFD] blk_rq_map_pages new API
Date: Thu, 12 Feb 2009 11:19:09 +0200
Message-ID: <4993E98D.8020001@panasas.com>
References: <20090212010454J.fujita.tomonori@lab.ntt.co.jp>	<1234369838.3295.31.camel@localhost.localdomain>	<49931113.3090701@panasas.com> <20090212103112M.fujita.tomonori@lab.ntt.co.jp> <4993DCCA.8080508@panasas.com> <4993DD9A.6070701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:60009 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZBLJTR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 04:19:17 -0500
Received: by bwz5 with SMTP id 5so834688bwz.13
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2009 01:19:15 -0800 (PST)
In-Reply-To: <4993DD9A.6070701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> /**
>  * blk_rq_map_pages - Receives an array of pages and appends them to a request structure 
>  *
>  * @rq:  The request to map
>  * @pages_info: A structure that specifies the array of pages, offset and more that need to be
>  *              map to the request. the @pages_info->null_mapped is assumed to be 1 and is ignored.
>  * @length: Total bytes to map. Array of pages can be larger, stop mapping after @length bytes mapped.
>  * @max_pages: When allocating the internal bio use @max_pages as an hint that says the amount of anticipated
>  *             pages that will be mapped. This member is optional and can be zero.
>  * 
>  * blk_rq_map_pages can be called multiple times so the user does not need to allocate a contiguous array
>  * of struct page pointers but can call this routine multiple times. In that case max_pages can be set
>  * so no bio re-allocation occurs.
>  * There is no unmap function for this mapping, the request is completed in the regular way.
>  */
> 
> int blk_rq_map_pages(struct request rq, struct *rq_map_data pages_info, unsigned length, unsigned max_pages);
> 
> 
> Implementation comments:
> - Then when this member is available many places that call blk_rq_map_user() rq_map_data and null_mapped set,
>   and buff == NULL, can be converted to this member.
> 
> - Internal block implementation is refactored to not duplicate any code with blk_rq_map_user().
> 
> Thanks for any comments
> Boaz
> 
> --

FUJITA Tomonori wrote:
> Please send a patch to implement the proposal.
> 

Is the above API accepted by you? Is it accepted by Jens?
Should I also attempt first comment above.

If its OK I will implement it ASAP.

Thanks
Boaz

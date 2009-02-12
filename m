From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFD] blk_rq_map_pages new API
Date: Thu, 12 Feb 2009 13:34:06 +0200
Message-ID: <4994092E.7030009@panasas.com>
References: <4993DD9A.6070701@panasas.com>	<4993E98D.8020001@panasas.com>	<20090212185038F.fujita.tomonori@lab.ntt.co.jp> <20090212192019C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:31593 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbZBLLeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 06:34:11 -0500
In-Reply-To: <20090212192019C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 12 Feb 2009 18:50:33 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> On Thu, 12 Feb 2009 11:19:09 +0200
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>>> Boaz Harrosh wrote:
>>>> /**
>>>>  * blk_rq_map_pages - Receives an array of pages and appends them to a request structure 
>>>>  *
>>>>  * @rq:  The request to map
>>>>  * @pages_info: A structure that specifies the array of pages, offset and more that need to be
>>>>  *              map to the request. the @pages_info->null_mapped is assumed to be 1 and is ignored.
>>>>  * @length: Total bytes to map. Array of pages can be larger, stop mapping after @length bytes mapped.
>>>>  * @max_pages: When allocating the internal bio use @max_pages as an hint that says the amount of anticipated
>>>>  *             pages that will be mapped. This member is optional and can be zero.
>>>>  * 
>>>>  * blk_rq_map_pages can be called multiple times so the user does not need to allocate a contiguous array
>>>>  * of struct page pointers but can call this routine multiple times. In that case max_pages can be set
>>>>  * so no bio re-allocation occurs.
>>>>  * There is no unmap function for this mapping, the request is completed in the regular way.
>>>>  */
>>>>
>>>> int blk_rq_map_pages(struct request rq, struct *rq_map_data pages_info, unsigned length, unsigned max_pages);
>>>>
>>>>
>>>> Implementation comments:
>>>> - Then when this member is available many places that call blk_rq_map_user() rq_map_data and null_mapped set,
>>>>   and buff == NULL, can be converted to this member.
>>>>
>>>> - Internal block implementation is refactored to not duplicate any code with blk_rq_map_user().
>>>>
>>>> Thanks for any comments
>>>> Boaz
>>>>
>>>> --
>>> FUJITA Tomonori wrote:
>>>> Please send a patch to implement the proposal.
>>>>
>>> Is the above API accepted by you? Is it accepted by Jens?
>>> Should I also attempt first comment above.
>>>
>>> If its OK I will implement it ASAP.
>> Sorry, I'm not sure until I see the actual code. You always find
>> tricky things when you actually write the code.
>>
>> The patch should be small. It's not difficult at all to write a patch
>> to see how it works.
> 
> BTW, the idea is fine by me:
> 
> I have some page frames and want to build a request out of them.
> 
> That's what st and osst want. If OSD ULD wants it, adding a new API
> for it sounds a good idea to me. Then we can remove some features of
> blk_rq_map_user that I added for st and osst.

Right, I agree with you totally. I'm on it, I'll try an RFC see how it
goes, and we can decide from there.

Thanks TOMO
Boaz

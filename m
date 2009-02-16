From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Mon, 16 Feb 2009 11:19:21 +0200
Message-ID: <49992F99.1060404@panasas.com>
References: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>	<20090216131806X.fujita.tomonori@lab.ntt.co.jp>	<499928A3.60507@panasas.com> <20090216180028C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:9054 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbZBPJT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 04:19:26 -0500
In-Reply-To: <20090216180028C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: avishay@gmail.com, jeff@garzik.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 16 Feb 2009 10:49:39 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Mon,  9 Feb 2009 15:12:09 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> This patch includes osd infrastructure that will be used later by
>>>> the file system.
>>>>
>>>> Also the declarations of constants, on disk structures,
>>>> and prototypes.
>>>>
>>>> And the Kbuild+Kconfig files needed to build the exofs module.
>>>>
>>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>>> ---
>>>>  fs/exofs/Kbuild   |   30 +++++++
>>>>  fs/exofs/Kconfig  |   13 +++
>>>>  fs/exofs/common.h |  181 +++++++++++++++++++++++++++++++++++++++++
>>>>  fs/exofs/exofs.h  |  139 ++++++++++++++++++++++++++++++++
>>>>  fs/exofs/osd.c    |  230 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  5 files changed, 593 insertions(+), 0 deletions(-)
>>>>  create mode 100644 fs/exofs/Kbuild
>>>>  create mode 100644 fs/exofs/Kconfig
>>>>  create mode 100644 fs/exofs/common.h
>>>>  create mode 100644 fs/exofs/exofs.h
>>>>  create mode 100644 fs/exofs/osd.c
>>>> +static void _osd_read(struct osd_request *or,
>>>> +	const struct osd_obj_id *obj, uint64_t offset, struct bio *bio)
>>>> +{
>>>> +	osd_req_read(or, obj, bio, offset);
>>>> +	EXOFS_DBGMSG("osd_req_read(p=%llX, ob=%llX, l=%llu, of=%llu)\n",
>>>> +		_LLU(obj->partition), _LLU(obj->id), _LLU(bio->bi_size),
>>>> +		_LLU(offset));
>>>> +}
>>>> +
>>>> +#ifdef __KERNEL__
>>> Hmm?
>>>
>> Yep, this file also complies in user mode.
> 
> Even if you do, it's a good thing to add __KERNEL__ to fs/*.c?
> 
> 
>>>> +static struct bio *_bio_map_pages(struct request_queue *req_q,
>>>> +				  struct page **pages, unsigned page_count,
>>>> +				  size_t length, gfp_t gfp_mask)
>>>> +{
>>>> +	struct bio *bio;
>>>> +	int i;
>>>> +
>>>> +	bio = bio_alloc(gfp_mask, page_count);
>>>> +	if (!bio) {
>>>> +		EXOFS_DBGMSG("Failed to bio_alloc page_count=%d\n", page_count);
>>>> +		return NULL;
>>>> +	}
>>>> +
>>>> +	for (i = 0; i < page_count && length; i++) {
>>>> +		size_t use_len = min(length, PAGE_SIZE);
>>>> +
>>>> +		if (use_len !=
>>>> +		    bio_add_pc_page(req_q, bio, pages[i], use_len, 0)) {
>>>> +			EXOFS_ERR("Failed bio_add_pc_page req_q=%p pages[i]=%p "
>>>> +				  "use_len=%Zd page_count=%d length=%Zd\n",
>>>> +				  req_q, pages[i], use_len, page_count, length);
>>>> +			bio_put(bio);
>>>> +			return NULL;
>>>> +		}
>>>> +
>>>> +		length -= use_len;
>>>> +	}
>>>> +
>>>> +	WARN_ON(length);
>>>> +	return bio;
>>>> +}
>>> 1) exofs builds bios by hand.
>>> 2) exofs passes bio to OSD SCSI ULD.
>>>
>>> As a result, exofs and OSD SCSI ULD need to know the internal of bio,
>>> that is, you reinvent the bio handling infrastructure, as pointed out
>>> in another thread in scsi-ml.
>>>
>>> _bio_map_pages is called where the VFS passes an array of a pointer to
>>> a page frame.
>>>
>>> Why can't you simply pass the array to OSD SCSI ULD? Then OSD SCSI ULD
>>> can use the block layer helper functions to build a request out of
>>> pages without knowing the internal of bio.
>>>
>>>
>> Because actually this code is wrong and temporary and will change soon.
>> At vfs write_pages I do not get a linear array of page pointers but a
>> link-list of pages. This will not fit any current model.
> 
> Then, why can't you pass a link-list of pages?
> 

What? How to do that? I mean how to move from link-list of pages
to request?

> 
>> Also looking
>> ahead I will have RAID 0, 1, 5, and 6 on objects of different devices. bio
>> is the perfect collector for memory information in this situation.
> 
> You will add such features to exofs, handling multiple devices
> internally?
> 

Multiple objects on Multiple devices, Yes.

> 
>> exofs is not the first and only file system who is using bios. Proof of
>> the matter is that block exports a bio submit routine.
> 
> Seems that exofs just passes pages and the ULD sends a SCSI command
> including these pages. I don't see how exofs needs to handle bio
> directly.
> 

How do you propose to collect these pages? and keep them without allocating
an extra list? without pre-allocating a struct request? and without re-inventing
the bio structure?

> 
>> As I said on the other thread, I could live without it for now, for a short while,
>> but I will regret it badly and it will hurt performance in the long run.
>>
>> <snip>
>>
>> Boaz

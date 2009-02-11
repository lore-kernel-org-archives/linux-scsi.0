From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Wed, 11 Feb 2009 17:07:16 +0200
Message-ID: <4992E9A4.9080303@panasas.com>
References: <49929749.5020109@panasas.com>	<20090211233206H.fujita.tomonori@lab.ntt.co.jp>	<4992E635.9080903@panasas.com> <20090212000202R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:30009 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752546AbZBKPHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 10:07:21 -0500
In-Reply-To: <20090212000202R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 11 Feb 2009 16:52:37 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Wed, 11 Feb 2009 11:15:53 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> I spoke too soon. There is one more place that uses blk_rq_append_bio, that is
>>>> the place that adds the read/write bio that is received in osd_req_write/read.
>>>> The reason I receive a bio at these is because mainly I need a way to
>>>> accept struct page* arrays, as well as kernel & user pointers. A bio is a nice
>>> The API using an array of pointers to page can handle everything. So
>>> why do the users of ULD (some rare file systems, I guess), osd
>>> initiator, need to build bios and pass them?
>>>
>>>
>>>> general carrier for any type of memory. Given a bio at hand there are no ways
>>>> left to prepare a request from it save the FS generic_make_request() route.
>>>>
>>>> I was thinking of using struct sg_iovec* at one stage but they look very
>>>> scary when used with page*, and mapping a page to a pointer but not doing
>>>> cache sync and all that jazz. A bio is a very nice carrier of a scatter-gather
>>>> list of memory. It has all the API for any needs. blk_rq_append_bio() was the last
>>>> way to associate a bio with a request. (except for privileged block-filesystems)
>>> We need to remove the usage of blk_rq_append_bio() in scsi.
>>>
>>>
>>>> So the first thing we have to decide is what API we need at read/write
>>>> today there is:
>>> You are talking about the API for osd file systems (or something
>>> related with osd), right? If so, I think that you can do whatever you
>>> want to do now. You can make a mistake since it's in-kernel API.
>>>
>>>
>>>> void osd_req_read(struct osd_request *or,
>>>> 	const struct osd_obj_id *, struct bio *data_in, u64 offset);
>>>>
>>>> in exofs I use these two:
>>>>
>>>> int osd_req_read_kern(struct osd_request *or,
>>>> 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
>>>> int osd_req_read_pages(struct osd_request *or,
>>>> 	const struct osd_obj_id *, u64 offset, u64 length,
>>>> 	struct page **pages, int page_count);
>>>>
>>> As I wrote above, if you have an interface handling 'struct page
>>> **pages', then there should be ok.
>> Sorry you miss understand me, I did not explain well.
>>
>> int osd_req_read_pages(,,,, struct page **pages, int page_count);
>>
>> Is in exofs.ko. It builds a bio out of **pages then calls
>> osd_req_read(,,bio,) which will then call blk_rq_append_bio()
> 
> As I wrote in the previous mail, why does exofs need to build a bio?
> Why can exofs pass pages to osd ULD?
> 
> 

Sure it can pass pages to ULD but then how ULD maks a request out of
pages? And it gets more complicated then that (above multiple times)

But lets try to solve just the pages first.

Boaz




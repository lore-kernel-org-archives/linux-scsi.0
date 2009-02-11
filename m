From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Wed, 11 Feb 2009 17:41:35 +0200
Message-ID: <4992F1AF.9060702@panasas.com>
References: <4992E635.9080903@panasas.com>	<20090212000202R.fujita.tomonori@lab.ntt.co.jp>	<4992E9A4.9080303@panasas.com> <20090212002105A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:7297 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751774AbZBKPlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 10:41:42 -0500
In-Reply-To: <20090212002105A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 11 Feb 2009 17:07:16 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>
>>>
>> Sure it can pass pages to ULD but then how ULD maks a request out of
>> pages?
> 
> If you extend blk_rq_map_kern as James did, your ULD make a request
> out of passed pages, that is, the block layer properly builds a
> request with bio(s).

What? I don't understand?
blk_rq_map_kern takes a kernel-pointer and length, how to pass array
of page* ?

> 
> I think that another possible option is adding a new mapping function
> that can handle multiple bios for kernel buffers (as Mike extended
> blk_rq_map_user).
> 

Yes adding a new mapping function can help. Please note I need to
add (append) pages same as bio_add_pc_page() but on request level.

And yet we had an entry that did exactly that, blk_rq_append_bio(), no?

> 
>> And it gets more complicated then that (above multiple times)
> 
> I don't think so. If you don't have time to work on it, please let me
> know. I'll fix OSD ULD.

I have all the time in the world, And yes what James did with blk_rq_map_kern
will help with appending other osd segments on top of data.

If you propose the appropriate new API for block request level I can implement
that in block, and also in OSD. What other entry you want to add/change that solve
my need?

Thanks
Boaz


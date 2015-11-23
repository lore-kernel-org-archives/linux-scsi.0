From: Ming Lei <ming.lei@canonical.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Mon, 23 Nov 2015 08:36:15 +0800
Message-ID: <CACVXFVMAm1niRvXqQXjOXW=ryy41d-ne09wSNbJUq3b9o6vJ7w@mail.gmail.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
	<1447855399.3974.24.camel@redhat.com>
	<1447894964.15206.0.camel@ellerman.id.au>
	<20151119082325.GA11419@infradead.org>
	<1448021448.14769.7.camel@ellerman.id.au>
	<565055C6.5040801@linux.vnet.ibm.com>
	<20151122005635.1b9ffbe1@tom-T450>
	<1448234410.8209.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbbKWAgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2015 19:36:18 -0500
In-Reply-To: <1448234410.8209.3.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org

On Mon, Nov 23, 2015 at 7:20 AM, Mark Salter <msalter@redhat.com> wrote:
> On Sun, 2015-11-22 at 00:56 +0800, Ming Lei wrote:
>> On Sat, 21 Nov 2015 12:30:14 +0100
>> Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
>>
>> > On 20/11/2015 13:10, Michael Ellerman wrote:
>> > > On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
>> > >
>> > > > It's pretty much guaranteed a block layer bug, most likely in the
>> > > > merge bios to request infrastucture where we don't obey the merging
>> > > > limits properly.
>> > > >
>> > > > Does either of you have a known good and first known bad kernel?
>> > >
>> > > Not me, I've only hit it one or two times. All I can say is I have hit it in
>> > > 4.4-rc1.
>> > >
>> > > Laurent, can you narrow it down at all?
>> >
>> > It seems that the panic is triggered by the commit bdced438acd8 ("block:
>> > setup bi_phys_segments after splitting") which has been pulled by the
>> > merge d9734e0d1ccf ("Merge branch 'for-4.4/core' of
>> > git://git.kernel.dk/linux-block").
>> >
>> > My system is panicing promptly when running a kernel built at
>> > d9734e0d1ccf, while reverting the commit bdced438acd8, it can run hours
>> > without panicing.
>> >
>> > This being said, I can't explain what's going wrong.
>> >
>> > May Ming shed some light here ?
>>
>> Laurent, looks there is one bug in blk_bio_segment_split(), would you
>> mind testing the following patch to see if it fixes your issue?
>>
>> ---
>> From 6fc701231dcc000bc8bc4b9105583380d9aa31f4 Mon Sep 17 00:00:00 2001
>> From: Ming Lei <ming.lei@canonical.com>
>> Date: Sun, 22 Nov 2015 00:47:13 +0800
>> Subject: [PATCH] block: fix segment split
>>
>> Inside blk_bio_segment_split(), previous bvec pointer('bvprvp')
>> always points to the iterator local variable, which is obviously
>> wrong, so fix it by pointing to the local variable of 'bvprv'.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  block/blk-merge.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index de5716d8..f2efe8a 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -98,7 +98,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>>
>>                       seg_size += bv.bv_len;
>>                       bvprv = bv;
>> -                     bvprvp = &bv;
>> +                     bvprvp = &bvprv;
>>                       sectors += bv.bv_len >> 9;
>>                       continue;
>>               }
>> @@ -108,7 +108,7 @@ new_segment:
>>
>>               nsegs++;
>>               bvprv = bv;
>> -             bvprvp = &bv;
>> +             bvprvp = &bvprv;
>>               seg_size = bv.bv_len;
>>               sectors += bv.bv_len >> 9;
>>       }
>
> I'm still hitting the BUG even with this patch applied on top of 4.4-rc1.

OK, looks there are still other bugs, care to share us how to reproduce
it on arm64?

thanks,
Ming

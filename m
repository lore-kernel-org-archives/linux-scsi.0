From: Alan Ott <alan@softiron.co.uk>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Tue, 24 Nov 2015 13:59:05 -0500
Message-ID: <5654B379.30700@softiron.co.uk>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org>
 <1448021448.14769.7.camel@ellerman.id.au>
 <565055C6.5040801@linux.vnet.ibm.com> <20151122005635.1b9ffbe1@tom-T450>
 <1448234410.8209.3.camel@redhat.com>
 <CACVXFVMAm1niRvXqQXjOXW=ryy41d-ne09wSNbJUq3b9o6vJ7w@mail.gmail.com>
 <1448243411.8209.36.camel@redhat.com>
 <CACVXFVPWBnm8H4BgQ_=V-Z-NLrkt+TE7T_RpEctNrjEwpRpJhw@mail.gmail.com>
 <20151123232134.4abda9a7@tom-T450>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20151123232134.4abda9a7@tom-T450>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ming Lei <tom.leiming@gmail.com>, Mark Salter <msalter@redhat.com>
Cc: linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Ming Lei <ming.lei@canonical.com>, "James E. J. Bottomley" <JBottomley@odin.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, brking <brking@us.ibm.com>, Laurent Dufour <ldufour@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 11/23/2015 10:21 AM, Ming Lei wrote:
> On Mon, 23 Nov 2015 10:46:20 +0800
> Ming Lei <ming.lei@canonical.com> wrote:
>
>> Hi Mark,
>>
>> On Mon, Nov 23, 2015 at 9:50 AM, Mark Salter <msalter@redhat.com> wrote:
>>> On Mon, 2015-11-23 at 08:36 +0800, Ming Lei wrote:
>>>> On Mon, Nov 23, 2015 at 7:20 AM, Mark Salter <msalter@redhat.com> wrote:
>>>>> On Sun, 2015-11-22 at 00:56 +0800, Ming Lei wrote:
>>>>>> On Sat, 21 Nov 2015 12:30:14 +0100
>>>>>> Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
>>>>>>
>>>>>>> On 20/11/2015 13:10, Michael Ellerman wrote:
>>>>>>>> On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
>>>>>>>>
>>>>>>>>> It's pretty much guaranteed a block layer bug, most likely in the
>>>>>>>>> merge bios to request infrastucture where we don't obey the merging
>>>>>>>>> limits properly.
>>>>>>>>>
>>>>>>>>> Does either of you have a known good and first known bad kernel?
>>>>>>>>
>>>>>>>> Not me, I've only hit it one or two times. All I can say is I have hit it in
>>>>>>>> 4.4-rc1.
>>>>>>>>
>>>>>>>> Laurent, can you narrow it down at all?
>>>>>>>
>>>>>>> It seems that the panic is triggered by the commit bdced438acd8 ("block:
>>>>>>> setup bi_phys_segments after splitting") which has been pulled by the
>>>>>>> merge d9734e0d1ccf ("Merge branch 'for-4.4/core' of
>>>>>>> git://git.kernel.dk/linux-block").
>>>>>>>
>>>>>>> My system is panicing promptly when running a kernel built at
>>>>>>> d9734e0d1ccf, while reverting the commit bdced438acd8, it can run hours
>>>>>>> without panicing.
>>>>>>>
>>>>>>> This being said, I can't explain what's going wrong.
>>>>>>>
>>>>>>> May Ming shed some light here ?
>>>>>>
>>>>>> Laurent, looks there is one bug in blk_bio_segment_split(), would you
>>>>>> mind testing the following patch to see if it fixes your issue?
>>>>>>
>>>>>> ---
>>>>>>  From 6fc701231dcc000bc8bc4b9105583380d9aa31f4 Mon Sep 17 00:00:00 2001
>>>>>> From: Ming Lei <ming.lei@canonical.com>
>>>>>> Date: Sun, 22 Nov 2015 00:47:13 +0800
>>>>>> Subject: [PATCH] block: fix segment split
>>>>>>
>>>>>> Inside blk_bio_segment_split(), previous bvec pointer('bvprvp')
>>>>>> always points to the iterator local variable, which is obviously
>>>>>> wrong, so fix it by pointing to the local variable of 'bvprv'.
>>>>>>
>>>>>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>>>>>> ---
>>>>>>   block/blk-merge.c | 4 ++--
>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>>>>>> index de5716d8..f2efe8a 100644
>>>>>> --- a/block/blk-merge.c
>>>>>> +++ b/block/blk-merge.c
>>>>>> @@ -98,7 +98,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>>>>>>
>>>>>>                        seg_size += bv.bv_len;
>>>>>>                        bvprv = bv;
>>>>>> -                     bvprvp = &bv;
>>>>>> +                     bvprvp = &bvprv;
>>>>>>                        sectors += bv.bv_len >> 9;
>>>>>>                        continue;
>>>>>>                }
>>>>>> @@ -108,7 +108,7 @@ new_segment:
>>>>>>
>>>>>>                nsegs++;
>>>>>>                bvprv = bv;
>>>>>> -             bvprvp = &bv;
>>>>>> +             bvprvp = &bvprv;
>>>>>>                seg_size = bv.bv_len;
>>>>>>                sectors += bv.bv_len >> 9;
>>>>>>        }
>>>>>
>>>>> I'm still hitting the BUG even with this patch applied on top of 4.4-rc1.
>>>>
>>>> OK, looks there are still other bugs, care to share us how to reproduce
>>>> it on arm64?
>>>>
>>>> thanks,
>>>> Ming
>>>
>>> Unfortunately, the best reproducer I have is to boot the platform. I have seen the
>>> BUG a few times post-boot, but I don't have a consistant reproducer. I am using
>>> upstream 4.4-rc1 with this config:
>>>
>>>    http://people.redhat.com/msalter/fh_defconfig
>>>
>>> With 4.4-rc1 on an APM Mustang platform, I see the BUG about once every 6-7 boots.
>>> On an AMD Seattle platform, about every 9 boots.
>>
>> Thanks for the input, and I will try to reproduce the issue on mustang with
>> your kernel config.
>
> I can reproduce the issue on mustang, and looks I may understand the story now.
>
> When 64K page size is used on arm64, and the default segment size of block
> is 65536, then one segment should only include one page at most.
>
> Commit bdced438acd83a(block: setup bi_phys_segments after splitting) does not
> compute bio->bi_seg_front_size and bio->bi_seg_back_size, then one less segment
> may be obtained because blk_phys_contig_segment() thought the last bvec in 1st
> bio and the 1st bvec in the 2nd bio is in one physical segment, so cause the
> regression.
>
> Looks the following patch can fix the issue by figuring bio->bi_seg_front_size
> and bio->bi_seg_back_size in blk_bio_segment_split().
>
> Mark, thanks again for providing the reproduction steps, and could you run your
> test to see if it can fix your issue?
>
> ---
>  From 86b5f33d48715c1150fdcfd9a76e495e7aa913aa Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@canonical.com>
> Date: Mon, 23 Nov 2015 20:27:23 +0800
> Subject: [PATCH 2/2] blk-merge: fix blk_bio_segment_split
>
> Commit bdced438acd83a(block: setup bi_phys_segments after
> splitting) introduces function of computing bio->bi_phys_segments
> during bio splitting.
>
> Unfortunately both bio->bi_seg_front_size and bio->bi_seg_back_size
> arn't computed, so too many physical segments may be obtained
> for one request since both the two are used to check if one segment
> across two bios can be possible.
>
> This patch fixes the issue by computing the two variables in
> blk_bio_segment_split().
>
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Reported-by: Mark Salter <msalter@redhat.com>
> Fixes: bdced438acd83a(block: setup bi_phys_segments after splitting)
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   block/blk-merge.c | 22 +++++++++++++++++++---
>   1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index f2efe8a..50793cd 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -76,6 +76,9 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>   	struct bio_vec bv, bvprv, *bvprvp = NULL;
>   	struct bvec_iter iter;
>   	unsigned seg_size = 0, nsegs = 0, sectors = 0;
> +	unsigned front_seg_size = bio->bi_seg_front_size;
> +	bool do_split = true;
> +	struct bio *new = NULL;
>
>   	bio_for_each_segment(bv, bio, iter) {
>   		if (sectors + (bv.bv_len >> 9) > queue_max_sectors(q))
> @@ -111,13 +114,26 @@ new_segment:
>   		bvprvp = &bvprv;
>   		seg_size = bv.bv_len;
>   		sectors += bv.bv_len >> 9;
> +
> +		if (nsegs == 1 && seg_size > front_seg_size)
> +			front_seg_size = seg_size;
>   	}
>
> -	*segs = nsegs;
> -	return NULL;
> +	do_split = false;
>   split:
>   	*segs = nsegs;
> -	return bio_split(bio, sectors, GFP_NOIO, bs);
> +
> +	if (do_split) {
> +		new = bio_split(bio, sectors, GFP_NOIO, bs);
> +		if (new)
> +			bio = new;
> +	}
> +
> +	bio->bi_seg_front_size = front_seg_size;
> +	if (seg_size > bio->bi_seg_back_size)
> +		bio->bi_seg_back_size = seg_size;
> +
> +	return do_split ? new : NULL;
>   }
>
>   void blk_queue_split(struct request_queue *q, struct bio **bio,
>

I applied both your patches and tested on Overdrive 3000. This fixes the 
issue for me.

Added linux-arm-kernel, since arm64 triggers this issue.

Thanks Ming and testers for your hard work on this.

Tested-by: Alan Ott <alan@softiron.co.uk>

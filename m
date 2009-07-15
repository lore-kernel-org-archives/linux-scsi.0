From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] block: implement mixed merge of different failfast
 requests
Date: Wed, 15 Jul 2009 18:41:53 +0900
Message-ID: <4A5DA461.5010401@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-4-git-send-email-tj@kernel.org> <4A507203.8020001@panasas.com> <4A553E36.8060006@kernel.org> <4A55B5A9.2060705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZGOJmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 05:42:13 -0400
In-Reply-To: <4A55B5A9.2060705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

Boaz Harrosh wrote:
> On 07/09/2009 03:47 AM, Tejun Heo wrote:
>> Hello,
>>
>> Boaz Harrosh wrote:
>>>> @@ -1165,6 +1165,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>>>>  	const unsigned short prio = bio_prio(bio);
>>>>  	const int sync = bio_sync(bio);
>>>>  	const int unplug = bio_unplug(bio);
>>>> +	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
>>> Perhaps a bio_fail_fast(bio)
>>> and also an blk_failfast(rq).
>> Me not being a big fan of those simple accessors, I want to avoid
>> adding those especially the use of bio ones are mostly confined to
>> block layer proper.
>>
> 
> OK but at least take care of blk_noretry_request(), at the minimum
> kill it, and use req->cmd_flags & REQ_FAILFAST_MASK everywhere.

Hmmm... looking at it now, looks like we can kill them all actually.
There are a lot of inconsistencies in this space.

* BIO_RW_* are bit positions and accessed with liberal combination of
  bio_rw_flagged() and manual bitops.

* QUEUE_FLAG_* are bit positions and has rather large collection of
  accessors.  The accessors have locking asserts.

* __REQ_* are bit positions but have counter part REQ_* bit masks
  defined and there are whole bunch of simple specific accessors.

I think all these can just be converted to bit masks (and I'll be
happy with that) but whether that would be desirable is a different
matter.  I think it would be best to hear what Jens' plan about flag
cleanup is (who BTW is away till the end of the next week) before
proceeding.

Jens, can you please let us know what your plan is?

Thanks.

-- 
tejun

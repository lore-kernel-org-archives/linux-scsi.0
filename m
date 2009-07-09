From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/4] block: implement mixed merge of different failfast
 requests
Date: Thu, 09 Jul 2009 12:17:29 +0300
Message-ID: <4A55B5A9.2060705@panasas.com>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-4-git-send-email-tj@kernel.org> <4A507203.8020001@panasas.com> <4A553E36.8060006@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:15793
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756777AbZGIJRc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 05:17:32 -0400
In-Reply-To: <4A553E36.8060006@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

On 07/09/2009 03:47 AM, Tejun Heo wrote:
> Hello,
> 
> Boaz Harrosh wrote:
>>> @@ -1165,6 +1165,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>>>  	const unsigned short prio = bio_prio(bio);
>>>  	const int sync = bio_sync(bio);
>>>  	const int unplug = bio_unplug(bio);
>>> +	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
>> Perhaps a bio_fail_fast(bio)
>> and also an blk_failfast(rq).
> 
> Me not being a big fan of those simple accessors, I want to avoid
> adding those especially the use of bio ones are mostly confined to
> block layer proper.
> 

OK but at least take care of blk_noretry_request(), at the minimum
kill it, and use req->cmd_flags & REQ_FAILFAST_MASK everywhere.

> Thanks.
> 

Thanks
Boaz

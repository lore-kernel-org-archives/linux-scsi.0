From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of queue
Date: Thu, 22 Jan 2009 14:44:14 +0200
Message-ID: <49786A1E.3070707@panasas.com>
References: <4976F067.8000501@panasas.com> <20090122082314G.fujita.tomonori@lab.ntt.co.jp> <20090122111302.GG30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:20520 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZAVMoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 07:44:20 -0500
Received: by ug-out-1314.google.com with SMTP id 39so484963ugf.37
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 04:44:18 -0800 (PST)
In-Reply-To: <20090122111302.GG30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

Jens Axboe wrote:
> On Thu, Jan 22 2009, FUJITA Tomonori wrote:
>> On Wed, 21 Jan 2009 11:52:39 +0200
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>>> Currently inherited from sg.c bsg will submit asynchronous request
>>> at the head-of-the-queue, (using "at_head" set in the call to
>>> blk_execute_rq_nowait()). This is bad in situation where we want
>>> to keep the queues full but need the requests to execute in order.
>> As I wrote, I think that blk_execute_rq_nowait inserts a request and
>> plugs a queue. So how can you keep the queue full? On the completion
>> of blk_execute_rq_nowait, the queue is empty.
> 
> That's not true at all. If you submit more than one request, request 2
> and up would be queued according to the orientation given. It may even
> include request 1 as well, what if the queue is busy doing work for
> someone else already?
> 
> I think the patch makes sense, I also wish that the default would have
> been reversed so that at_back would be the default. at_back is more
> complex though, since it impacts existing requests for the device (it
> drains the scheduler queue).
> 

bsg only sends BLOCK_PC commands, I think these are not held in the
scheduler queue, right? 

I think like you at_back is the default to use, but this is historic
compatibility with SG that had problems with ABORT and such not. With
my patch I give the user a choice and be done with it.

Thanks
Boaz

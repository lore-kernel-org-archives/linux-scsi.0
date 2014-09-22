From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Mon, 22 Sep 2014 10:39:41 -0600
Message-ID: <542050CD.5000005@kernel.dk>
References: <541C27BF.6070609@acm.org> <20140922143731.GA15377@infradead.org> <54204D7A.1070305@acm.org> <54204ED6.3020204@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49507 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVQjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 12:39:47 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so4856355pab.33
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2014 09:39:46 -0700 (PDT)
In-Reply-To: <54204ED6.3020204@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 2014-09-22 10:31, Jens Axboe wrote:
> On 2014-09-22 10:25, Bart Van Assche wrote:
>> On 22/09/2014 8:37, Christoph Hellwig wrote:
>>> One thing that is missing is generation multiqueue-aware tags at the
>>> blk-mq level, which should be as simple as always adding a queue
>>> prefix in the tag allocation code.
>>
>> Hello Christoph,
>>
>> Adding a queue prefix in the tag allocation code is an interesting idea.
>> Encoding the hardware context index in the upper bits of the 'tag' field
>> in 'struct request' is something I have considered. The reason I have
>> not done that is because I think several block drivers assume that the
>> rq->tag field is a number in the range [0..queue_depth-1]. Here is just
>> one example from the mtip32xx driver:
>>
>>          fis->sect_count  = ((rq->tag << 3) | (rq->tag >> 5));
>
> Most drivers assume that the tag is within a certain range, the queue
> prefix would only work on drivers where the tag number is just some
> arbitrary "cookie". So for SCSI it should work, and I don't think we
> need it anywhere else.
>
> Alternatively, we can wrap tag retrieval in some function to mask off
> the queue prefix for the cases where we just want an index.

Would probably be better to have a tag generation function instead, that 
uses rq->tag and ORs in the queue prefix, actually. That way rq->tag 
would remain being a plain index, and the issued tag in the driver could 
then use some function to add the queue prefix, if it needs unique tags 
across queues in a shared tag set.

-- 
Jens Axboe


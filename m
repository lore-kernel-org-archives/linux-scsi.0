From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 16:22:54 +0200
Message-ID: <545249BE.50505@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <54462403.70700@dev.mellanox.co.il> <5450DF49.3090904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48223 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaJ3OW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 10:22:57 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so7552010wiv.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 07:22:56 -0700 (PDT)
In-Reply-To: <5450DF49.3090904@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/29/2014 2:36 PM, Bart Van Assche wrote:
> On 10/21/14 11:14, Sagi Grimberg wrote:
>> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>>               spin_lock_irqsave(&ch->lock, flags);
>>>               ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
>>> @@ -1906,7 +1970,7 @@ static int srp_queuecommand(struct Scsi_Host
>>> *shost, struct scsi_cmnd *scmnd)
>>>           goto err;
>>
>> Bart,
>>
>> Any chance you can share some perf output on this code?
>> I'm interested of knowing the contention on target->lock that is
>> still taken on the IO path across channels.
>>
>> Can we think on how to avoid it?
>>
>> Also would like to understand the where did the bottleneck transition.
>
> Hello Sagi,
>
> Are you referring to target->lock ? That lock isn't taken anywhere in
> the hot path.

Right, my recollection was that we used to acquire the target-lock in
srp_chkready(). I see that's not the case anymore.

> More in general, I haven't seen any lock contention in the
> perf output that was caused by the block layer, SCSI core, SRP initiator
> or HCA (mlx4) drivers. The code that showed up highest in the perf
> output was the direct I/O code, the code that is triggered by fio to
> submit I/O requests.

Interesting, you don't see more contention on SQ/RQ/CQ locks? I find
that surprising.

Sagi.

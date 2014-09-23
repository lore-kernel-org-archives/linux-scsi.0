From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 7/8] IB/srp: Separate target and channel variables
Date: Tue, 23 Sep 2014 14:00:49 -0600
Message-ID: <5421D171.10206@acm.org>
References: <541C27BF.6070609@acm.org> <541C28C8.7000007@acm.org> <54219ACA.5000904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:59276 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbaIWUCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2014 16:02:36 -0400
In-Reply-To: <54219ACA.5000904@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 23/09/2014 10:07, Sagi Grimberg wrote:
> On 9/19/2014 3:59 PM, Bart Van Assche wrote:
>> @@ -3047,24 +3098,28 @@ static ssize_t srp_create_target(struct 
>> device *dev,
>>       INIT_WORK(&target->tl_err_work, srp_tl_err_work);
>>       INIT_WORK(&target->remove_work, srp_remove_work);
>>       spin_lock_init(&target->lock);
>
> Hey Bart,
>
> You keep this target-lock around. I don't see in this patch any usage
> of it left. Can you document what each of target->lock and ch->lock
> protects?
>
> So I would imagine that target-lock manages the target-wide variables
> such as state (what else?) while ch->lock protect channel specific free
> requests pool which can be moved to blk-mq preallocs and avoid
> maintaining it (not sure how req_lim would be maintained though and if
> it is still needed?).

Hello Sagi,

The use of these locks is very traditional - each lock is used to 
protect those members of the data structure it is a member of and that 
need to be protected against concurrent access.

Even with this patch applied "target->lock" is still used, e.g. to 
protect target port state modifications.

I will convert the free request pool in the next version of this patch 
series. The code for managing req_lim can probably be converted into 
something based on the blk-mq reserved tag infrastructure.

Bart.

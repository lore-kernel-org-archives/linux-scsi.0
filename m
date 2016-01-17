From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Sun, 17 Jan 2016 13:06:48 +0200
Message-ID: <569B75C8.5010709@dev.mellanox.co.il>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-8-git-send-email-hch@lst.de>
 <CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
 <569B5DE3.1010908@dev.mellanox.co.il>
 <CAG53R5VFRSLjapFS_V=f9iunKg=sXQDeB3Dy8vHaEbjxkzcw0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG53R5VFRSLjapFS_V=f9iunKg=sXQDeB3Dy8vHaEbjxkzcw0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>> If we have not drained the CQ (consumed budget or more) the second
>> condition (ib_req_notify_cq) will not be invoked. We are only rearming
>> the CQ when we drained it completely. So I don't see how we can end up
>> with missed notifications.
> We drain the CQ completely for whatever CQEs available at that time,
> say for example,
> 33 CQEs drained at time t1. So now req_notify_cq will be invoked at time t2.
> During time delta t2-t1, CQ in hardware remains unarmed.
> If cqes are added during that time delta, Will event/interrupt raised
> for it, for CQ in unarmed state?
>
> At time time t2, CQ is armed containing pending CQEs. Will
> event/interrupt raised for those pending CQEs on next arming?

If the device did not reported missed-events then it is the device
responsibility to generate a new completion event after arming.

Specifically, the mlx4/mlx5 HW is able to generate a completion event
in your described scenario. A device that is not capable of doing so
must report missed events to inform the core it has more completions
to consume.

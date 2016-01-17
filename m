From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Sun, 17 Jan 2016 16:39:33 +0530
Message-ID: <CAG53R5Vt+TTx8bm9+jyksBJ-nMh0Ug4wnhNicK7LsdqL+AGz_w@mail.gmail.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
	<1449521512-22921-8-git-send-email-hch@lst.de>
	<CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
	<569B5DE3.1010908@dev.mellanox.co.il>
	<CAG53R5VFRSLjapFS_V=f9iunKg=sXQDeB3Dy8vHaEbjxkzcw0Q@mail.gmail.com>
	<569B75C8.5010709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37301 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcAQLJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jan 2016 06:09:34 -0500
In-Reply-To: <569B75C8.5010709@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Jan 17, 2016 at 4:36 PM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>
>>> If we have not drained the CQ (consumed budget or more) the second
>>> condition (ib_req_notify_cq) will not be invoked. We are only rearming
>>> the CQ when we drained it completely. So I don't see how we can end up
>>> with missed notifications.
>>
>> We drain the CQ completely for whatever CQEs available at that time,
>> say for example,
>> 33 CQEs drained at time t1. So now req_notify_cq will be invoked at time
>> t2.
>> During time delta t2-t1, CQ in hardware remains unarmed.
>> If cqes are added during that time delta, Will event/interrupt raised
>> for it, for CQ in unarmed state?
>>
>> At time time t2, CQ is armed containing pending CQEs. Will
>> event/interrupt raised for those pending CQEs on next arming?
>
>
> If the device did not reported missed-events then it is the device
> responsibility to generate a new completion event after arming.
>
> Specifically, the mlx4/mlx5 HW is able to generate a completion event
> in your described scenario. A device that is not capable of doing so
> must report missed events to inform the core it has more completions
> to consume.
o.k. Thanks.

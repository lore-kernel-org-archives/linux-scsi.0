From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Sun, 17 Jan 2016 11:24:51 +0200
Message-ID: <569B5DE3.1010908@dev.mellanox.co.il>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-8-git-send-email-hch@lst.de>
 <CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> Hi Christoph, Sagi,
>
> On Tue, Dec 8, 2015 at 2:21 AM, Christoph Hellwig <hch@lst.de> wrote:
>
>> +static void ib_cq_poll_work(struct work_struct *work)
>> +{
>> +       struct ib_cq *cq = container_of(work, struct ib_cq, work);
>> +       int completed;
>> +
>> +       completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
>> +       if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>> +           ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>> +               queue_work(ib_comp_wq, &cq->work);
>> +}
>
> In above code, Let says completion is added in a time window where
> ib_process_cq is completed (CQ is diarmed in hw at that point) and
> ib_req_notify_cq is yet to be called.
> Provider vendor driver say mlx4 or mlx5 as specific case always
> returns ib_req_notify_cq = 0.
> Will it result into a missed notification? (so queue_work is not done).

If we have not drained the CQ (consumed budget or more) the second
condition (ib_req_notify_cq) will not be invoked. We are only rearming
the CQ when we drained it completely. So I don't see how we can end up
with missed notifications.

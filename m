From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Fri, 15 Jan 2016 19:24:00 +0530
Message-ID: <CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
	<1449521512-22921-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449521512-22921-8-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph, Sagi,

On Tue, Dec 8, 2015 at 2:21 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> +static void ib_cq_poll_work(struct work_struct *work)
> +{
> +       struct ib_cq *cq = container_of(work, struct ib_cq, work);
> +       int completed;
> +
> +       completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
> +       if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
> +           ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> +               queue_work(ib_comp_wq, &cq->work);
> +}

In above code, Let says completion is added in a time window where
ib_process_cq is completed (CQ is diarmed in hw at that point) and
ib_req_notify_cq is yet to be called.
Provider vendor driver say mlx4 or mlx5 as specific case always
returns ib_req_notify_cq = 0.
Will it result into a missed notification? (so queue_work is not done).

IB spec says: Any CQ entries that existed before the notify is enabled
will not result in a call to the handler.

I did try to follow this thread on similar notes.
http://www.spinics.net/lists/linux-nfs/msg54266.html

I believe above code possibly needs fix based above two comments? Or I
must be missing something basic here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

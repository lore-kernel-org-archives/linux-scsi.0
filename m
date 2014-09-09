From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH] Block: fix unbalanced bypass-disable in blk_register_queue
Date: Tue, 9 Sep 2014 13:32:40 -0500
Message-ID: <CADT32e+QNfjyyfs9F14b5KDc9TfGKs5SnQF4W8sAkUWVOmtQ0w@mail.gmail.com>
References: <20140909151726.GA8890@mtj.dyndns.org>
	<Pine.LNX.4.44L0.1409091149360.968-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1409091149360.968-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tested-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

On Tue, Sep 9, 2014 at 10:50 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> When a queue is registered, the block layer turns off the bypass
> setting (because bypass is enabled when the queue is created).  This
> doesn't work well for queues that are unregistered and then registered
> again; we get a WARNING because of the unbalanced calls to
> blk_queue_bypass_end().
>
> This patch fixes the problem by making blk_register_queue() call
> blk_queue_bypass_end() only the first time the queue is registered.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Tejun Heo <tj@kernel.org>
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> CC: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> [as1765]
>
>
>  block/blk-sysfs.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Index: usb-3.17/block/blk-sysfs.c
> ===================================================================
> --- usb-3.17.orig/block/blk-sysfs.c
> +++ usb-3.17/block/blk-sysfs.c
> @@ -554,8 +554,10 @@ int blk_register_queue(struct gendisk *d
>          * Initialization must be complete by now.  Finish the initial
>          * bypass from queue allocation.
>          */
> -       queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
> -       blk_queue_bypass_end(q);
> +       if (!blk_queue_init_done(q)) {
> +               queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
> +               blk_queue_bypass_end(q);
> +       }
>
>         ret = blk_trace_init_sysfs(dev);
>         if (ret)
>

From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Thu, 03 Nov 2011 18:49:53 +0100
Message-ID: <4EB2D441.9040708@kernel.dk>
References: <4EB2BC88.3070105@suse.cz> <20111103161436.GJ4417@google.com> <20111103162634.GK4417@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54525 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab1KCRuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 13:50:00 -0400
In-Reply-To: <20111103162634.GK4417@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>

On 2011-11-03 17:26, Tejun Heo wrote:
> blk_cleanup_queue() may be called before elevator is set up on a
> queue which triggers the following oops.
> 
>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>  IP: [<ffffffff8125a69c>] elv_drain_elevator+0x1c/0x70
>  ...
>  Pid: 830, comm: kworker/0:2 Not tainted 3.1.0-next-20111025_64+ #1590
>  Bochs Bochs
>  RIP: 0010:[<ffffffff8125a69c>]  [<ffffffff8125a69c>] elv_drain_elevator+0x1c/0x70
>  ...
>  Call Trace:
>   [<ffffffff8125da92>] blk_drain_queue+0x42/0x70
>   [<ffffffff8125db90>] blk_cleanup_queue+0xd0/0x1c0
>   [<ffffffff81469640>] md_free+0x50/0x70
>   [<ffffffff8126f43b>] kobject_release+0x8b/0x1d0
>   [<ffffffff81270d56>] kref_put+0x36/0xa0
>   [<ffffffff8126f2b7>] kobject_put+0x27/0x60
>   [<ffffffff814693af>] mddev_delayed_delete+0x2f/0x40
>   [<ffffffff81083450>] process_one_work+0x100/0x3b0
>   [<ffffffff8108527f>] worker_thread+0x15f/0x3a0
>   [<ffffffff81089937>] kthread+0x87/0x90
>   [<ffffffff81621834>] kernel_thread_helper+0x4/0x10
> 
> Fix it by making blk_cleanup_queue() check whether q->elevator is set
> up before invoking blk_drain_queue.

Thanks, glad this got caught before the merge...

-- 
Jens Axboe


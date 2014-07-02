From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: support scsi-mq, queues and locks
Date: Wed, 2 Jul 2014 03:15:21 -0700
Message-ID: <20140702101521.GA3275@infradead.org>
References: <53B0F0C0.40907@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaGBKPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2014 06:15:23 -0400
Content-Disposition: inline
In-Reply-To: <53B0F0C0.40907@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>, Christoph Hellwig <hch@lst.de>

Hi doug,

> ChangeLog:
>   - add host_lock option whose default value is 0 which
>     removes the host_lock around all queued commands

Any reason why we'd want to keep this?  You suggest below that the PI
parts might need locking, but in that case we should keept it there
undconditionally until Martin had a chance to verify it.

>   - accept delay=-1 (_hi_) or -2 which use a tasklet to invoke
>     the scsi_done callback into the mid-layer. The default
>     is still delay=1 which uses a timer to delay 1 jiffy

It might be worth to take a look at the null_blk driver for a few
more completion variants.

> 
> IMO the scsi-mq queue_depth handling doesn't break but does
> not converge promptly (and in some cases seems to be steady
> state unstable) in the face of TASK_SET_FULL statuses.
> This can be seen with this sequence:
>   # cd /sys/bus/pseudo/drivers/scsi_debug
>   # echo 0x600 > opts
> < then in another window 'tail -f /var/log/syslog'>
> < then in yet another window run a fio test against scsi_debug>
>   # echo 200 > max_queue
> < if the tail shows nothing, try writing a lower value into max_queue>
> 
> max_queue starts at 576. Depending on the fio test, the new
> value written into max_queue needed to prompt the TSF trip
> point will vary. You will now it when you see it :-)

There's really nothing specific to blk-mq in the queue-full handling,
so I'd be surprised if if it works that different.  What sort of
behavior do you see with scsi_debug when not using blk-mq?

What happens if you don't use blk-mq but the old host-wide tag
implementation (e.g. add a call to scsi_init_shared_tag_map in the probe
function)?


>  struct sdebug_queued_cmd {
> -	int in_use;
> -	struct timer_list cmnd_timer;
> -	done_funct_t done_funct;
> +	/* in_use flagged by a bit in queued_in_use_bm[] */
> +	struct timer_list *cmnd_timerp;
> +	struct tasklet_struct *tletp;

Why not keep these allocated as part of the structure and use an union?


>  static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
> +static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];

Any chance you could move to use the cmd_size field in the host template
instead of the statically allocated commands as suggested earlier?

That would allow for lockless I/O completions, and probably submissions
as well at least for the common case.


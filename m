From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Wed, 23 May 2012 10:58:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231054150.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSa_hYFu2JXLUOv2k+AhqUZWUvY-uzmocQKh_RUJJUP5Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51762 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756730Ab2EWO6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2012 10:58:24 -0400
In-Reply-To: <CAF1ivSa_hYFu2JXLUOv2k+AhqUZWUvY-uzmocQKh_RUJJUP5Ag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> Let's consider below code.
> 
> @@ -587,6 +591,11 @@ void __elv_add_request(struct request_queue *q,
> struct request *rq, int where)
>  {
>        trace_block_rq_insert(q, rq);
> 
> +       if (!(rq->cmd_flags & REQ_PM))
> +               if (q->nr_pending++ == 0 && (q->rpm_status == RPM_SUSPENDED ||
> +                               q->rpm_status == RPM_SUSPENDING) && q->dev)
> +                       pm_request_resume(q->dev);
> +
>        rq->q = q;
> 
>        if (rq->cmd_flags & REQ_SOFTBARRIER) {
> 
> Block layer reads runtime status and pm core writes this status.
> PM core uses dev->power.lock to protect this status.
> 
> I was thinking will it have problem if block layer does not acquire
> dev->power.lock?
> From your explanation below, it seems does not have problem.

I don't think it's a problem, because all you're doing is reading 
dev->power.rpm_status -- you're not writing it.

On the other hand, there's nothing really wrong with keeping your own
local copy of rpm_status.  You could think of it as being the queue's
status as opposed to the device's status.  (Also, some people might
argue that dev->power.rpm_status is supposed to be private to the
runtime PM core and shouldn't be used by other code.)

Alan Stern


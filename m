From: malahal@us.ibm.com
Subject: Re: question on block-layer timeout change
Date: Fri, 14 Nov 2008 09:18:23 -0800
Message-ID: <20081114171823.GA16575@us.ibm.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com> <20081112072919.GB12192@linux.vnet.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44845 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYKNRS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2008 12:18:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEHINCh010382
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:18:23 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEHIQ6R127370
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:18:26 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEHI9oF020200
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:18:10 -0500
Content-Disposition: inline
In-Reply-To: <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Harris" <Harris.Shi@lsi.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Shi, Harris [Harris.Shi@lsi.com] wrote:
> Mike,
> 
> Thanks for your valuable input.
> 
> For item 1, how can I make sure that the timed-out command will have
> the timer modified via blk_add_timer given that one of following
> conditions has to be met,
>
> * timer isn't already pending or

I don't completely understand the RDAC architecture, but here are my
comments bases on what I read from your earlier email.

When your timed_out function is called, the timer is already fired

In your case, you should always return 'BLK_EH_RESET_TIMER'. This is
just to make sure that the command doesn't fail before you resubmit the
request to the real HBA adapter, I think.

> * this timeout value is earlier than an existing one.

When you return BLK_EH_RESET_TIMER, the block layer puts the command
again in its timeout queue and waits for another 'timeout' value before
calling your timer again.

You can send the request to real HBA divers after timeout expiry. If you
really want to fail, you can return some other value...

> Also where do I need to have a retry after reset the timer?
There is no retry of the command. If you return 'BLK_EH_RESET_TIMER' the
command is still with your driver and you can take another timeout value
to finish the request.

> For item 2, rq_timed_out_fn is tied with scsi_times_out at the very beginning. What's the purpose to tie a specific mpp method? How do we handle the case if timeout is triggered at this time?
> 

When you send the request to the real HBA, the request timeout value
doesn't change. So Mike's suggestion is to have your own timed_out_fun
that returns BLK_EH_RESET_TIMER few times (effectively hijacking the
timeout value). See gdth_timed_out() for this case.

--Malahal.

> Harris
> 
> -----Original Message-----
> From: Mike Anderson [mailto:andmike@linux.vnet.ibm.com]
> Sent: Wednesday, November 12, 2008 1:29 AM
> To: Shi, Harris
> Cc: Jens Axboe; Alan Stern; Tejun Heo; SCSI development list
> Subject: Re: question on block-layer timeout change
> 
> Shi, Harris <Harris.Shi@lsi.com> wrote:
> >    Due to the current timeout management change, our RDAC (failover) driver
> >    had some difficulties in handling SCSI I/O timeout. The RDAC driver is in
> >    the similar        layer as HBA driver in that it will register into scsi
> >    mid-layer as scsi_host_template and stays below mid-layer. However, all
> >    scsi I/Os coming to RDAC stack are routed by a path then dispatched to the
> >    real HBA driver via mid-layer. We used to rely on the timer in
> >    scsi_cmnd->eh_timeout to deal with scsi i/o coming into the RDAC stack.
> >    Basically when I/O is coming to RDAC stack, we need to delete the timer
> >    for each I/O. Then after selecting a specific path for this I/O, we need
> >    to send the I/O back to mid-layer with a larger timeout value just to
> >    avoid the forced failover. When I/O completes successfully, we added the
> >    original timer back to the I/O and pass it over to upper block layer for
> >    further process.
> >
> >
> >
> >    However, with the current timeout management functions moving to block
> >    layer, it became difficult for us to explicitly control the timeout value
> >    for specific I/O.
> >
> >    Can you shed some lights on how to handle the I/O based timeout in this
> >    case?
> >
> 
> Since long term mpp capabilities should be handled by dm-mp and the SCSI
> RDAC handler exporting functions to allow direct adding and deleting of the
> timer may not be something that would be needed long term. It may not be
> really clean to add these interfaces in.
> 
> Could similar prior functionality be created by the following?
>         1.) To the RDAC vhba add a hostt->eh_timed_out function. In this
>         timeout function return BLK_EH_RESET_TIMER until it is done with
>         the command. Since the vhba does not have a transport
>         scsi_times_out should call this function on every timeout. There is
>         some overhead here depending on the default timeout value set in
>         timing out and then resetting the timer.
> 
>         2.) For each sdev that is taken over store the previous
>         rq_timed_out_fn and then use blk_queue_rq_timed_out to set a mpp
>         specific function for the requests sent to the real HBA drivers.
> 
>         3.) Set the timeout in the real HBA driver requests prior to
>         sending it to the mid layer.
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

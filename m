From: "Shi, Harris" <Harris.Shi@lsi.com>
Subject: RE: question on block-layer timeout change
Date: Fri, 14 Nov 2008 01:51:12 -0700
Message-ID: <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com>
 <20081112072919.GB12192@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48320 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYKNIvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2008 03:51:19 -0500
In-Reply-To: <20081112072919.GB12192@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: "malahal@us.ibm.com" <malahal@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Mike,

Thanks for your valuable input.

For item 1, how can I make sure that the timed-out command will have the timer modified via blk_add_timer given that one of following conditions has to be met,
* timer isn't already pending or
* this timeout value is earlier than an existing one.
Also where do I need to have a retry after reset the timer?

For item 2, rq_timed_out_fn is tied with scsi_times_out at the very beginning. What's the purpose to tie a specific mpp method? How do we handle the case if timeout is triggered at this time?

Harris

-----Original Message-----
From: Mike Anderson [mailto:andmike@linux.vnet.ibm.com]
Sent: Wednesday, November 12, 2008 1:29 AM
To: Shi, Harris
Cc: Jens Axboe; Alan Stern; Tejun Heo; SCSI development list
Subject: Re: question on block-layer timeout change

Shi, Harris <Harris.Shi@lsi.com> wrote:
>    Due to the current timeout management change, our RDAC (failover) driver
>    had some difficulties in handling SCSI I/O timeout. The RDAC driver is in
>    the similar        layer as HBA driver in that it will register into scsi
>    mid-layer as scsi_host_template and stays below mid-layer. However, all
>    scsi I/Os coming to RDAC stack are routed by a path then dispatched to the
>    real HBA driver via mid-layer. We used to rely on the timer in
>    scsi_cmnd->eh_timeout to deal with scsi i/o coming into the RDAC stack.
>    Basically when I/O is coming to RDAC stack, we need to delete the timer
>    for each I/O. Then after selecting a specific path for this I/O, we need
>    to send the I/O back to mid-layer with a larger timeout value just to
>    avoid the forced failover. When I/O completes successfully, we added the
>    original timer back to the I/O and pass it over to upper block layer for
>    further process.
>
>
>
>    However, with the current timeout management functions moving to block
>    layer, it became difficult for us to explicitly control the timeout value
>    for specific I/O.
>
>    Can you shed some lights on how to handle the I/O based timeout in this
>    case?
>

Since long term mpp capabilities should be handled by dm-mp and the SCSI
RDAC handler exporting functions to allow direct adding and deleting of the
timer may not be something that would be needed long term. It may not be
really clean to add these interfaces in.

Could similar prior functionality be created by the following?
        1.) To the RDAC vhba add a hostt->eh_timed_out function. In this
        timeout function return BLK_EH_RESET_TIMER until it is done with
        the command. Since the vhba does not have a transport
        scsi_times_out should call this function on every timeout. There is
        some overhead here depending on the default timeout value set in
        timing out and then resetting the timer.

        2.) For each sdev that is taken over store the previous
        rq_timed_out_fn and then use blk_queue_rq_timed_out to set a mpp
        specific function for the requests sent to the real HBA drivers.

        3.) Set the timeout in the real HBA driver requests prior to
        sending it to the mid layer.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

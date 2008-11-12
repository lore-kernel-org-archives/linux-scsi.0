From: malahal@us.ibm.com
Subject: Re: question on block-layer timeout change
Date: Wed, 12 Nov 2008 09:16:52 -0800
Message-ID: <20081112171652.GA30108@us.ibm.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com> <20081112072919.GB12192@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54093 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYKLRQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2008 12:16:59 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mACHGpmv031950
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2008 12:16:51 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mACHGsLS1949742
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2008 12:16:55 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mACHGr6Y021224
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2008 10:16:54 -0700
Content-Disposition: inline
In-Reply-To: <20081112072919.GB12192@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: "Shi, Harris" <Harris.Shi@lsi.com>, Jens Axboe <jens.axboe@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Mike Anderson [andmike@linux.vnet.ibm.com] wrote:
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
> 	1.) To the RDAC vhba add a hostt->eh_timed_out function. In this
> 	timeout function return BLK_EH_RESET_TIMER until it is done with
> 	the command. Since the vhba does not have a transport
> 	scsi_times_out should call this function on every timeout. There is
> 	some overhead here depending on the default timeout value set in
> 	timing out and then resetting the timer.

I believe, GDTG driver does this sort of thing for a different purpose.

> 	2.) For each sdev that is taken over store the previous
> 	rq_timed_out_fn and then use blk_queue_rq_timed_out to set a mpp
> 	specific function for the requests sent to the real HBA drivers.
> 
> 	3.) Set the timeout in the real HBA driver requests prior to
> 	sending it to the mid layer.

Should work, I guess...

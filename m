From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Wed, 4 Jun 2003 09:51:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030604165146.GA1426@beaverton.ibm.com>
References: <1054742495.1674.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:29833 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263571AbTFDQgC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2003 12:36:02 -0400
Content-Disposition: inline
In-Reply-To: <1054742495.1674.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> It has been pointed out by the USB people that the mid-layer doesn't
> obey its own online flag.
> 
> The attached patch should fix this.  However, there are a few caveats to
> offlining (read that as devices should still be prepared to process
> commands).
> 
> 1. Any special command will still be accepted (that's a command either
> via the SCSI_IOCTL_SEND_COMMAND, or an internally generated command).
> 2. Outstanding already processed commands in the queue (i.e. commands
> which have already been through the upper layer drivers but needed
> requeuing for some reason like QUEUE_FULL or device busy).
> 
> I'm willing to consider changing 2., it just requires more speciallised
> logic to distinguish between a command that has been prepared by the
> upper level drivers and a command sent via 1.
> 
> However, not that LLDs may not assume they will receive no commands just
> because scsi_device->online is zero.
> 
> James
> 

Doesn't this patch just re-implement in the prep_fn what is already
being done by sd and sr in there init_command functions.

Why allow io after online goes to zero. The user could bring the device
back online if they needed to send IO. I was counting on no IO so we could
do faster cleanup in the scsi_remove_host function.

I having been looking at this, but it is not very clean. To use existing
common functionality and avoid deadlock from calling back into the
request_fn the command needs wasted preparation just to use common
interfaces.

-andmike
--
Michael Anderson
andmike@us.ibm.com


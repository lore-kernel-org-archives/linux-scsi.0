From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC 1/2] 3ware 9000 SATA-RAID driver v2.26.00.009
Date: Thu, 27 May 2004 13:20:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6235B.1080507@pobox.com>
References: <HYCD4000.31K@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20700 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264659AbUE0RUn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 13:20:43 -0400
In-Reply-To: <HYCD4000.31K@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: akpm@osdl.org, james.bottomley@steeleye.com, hch@lst.de, linux-scsi@vger.kernel.org

Adam Radford wrote:
> Jeff,
> 
> Thanks for the useful feedback.
> 
> - The card can take up to 256 io's at a time, but 2 are marked off
>   for internal use.  There are no 'per device' limits.  The firmware queue
>   depth is 256 total for all devices.

Ok.

I would therefore recommend not setting device queue depth in 
->slave_configure(), but rather setting the Scsi_Host_Template's 
->can_queue to 256.

This more accurately reflects the hardware.


> - We are not calling do_gettimeofday() on every command sent to hardware.  It is
>   only sent when firmware requests an AEN_SYNC_TIME, which happens at startup, and
>   probably once a day thereafter.  This is so we can have scheduled events in the
>   firmware, such as rebuild events, scrub events, etc, _without_ an annoying daemon
>   running.  There is clock drift so we periodically sync the time.

I see the AEN_SYNC_TIME usage of do_gettimeofday(), but there are other 
uses of this function as well.


> - The ioctl routine _does_ copy down data buffers.  This isn't in the main IO path.

Still, you shouldn't need to copy all those buffers, just make sure they 
are present and mapped, then pass them to hardware.


> - twa_poll_status_gone() is called to prevent return from a function until the
>   hardware is ready.  How else do you propose delaying when the scsi midlayer called
>   your entrypoint with spin_lock_irqsave(host->host_lock, flags) ?

It's a problem with your model.  The ->queuecommand should 
asynchronously submit commands to hardware, up to the hardware limit.

twa_poll_status_done() AFAICS is being used during initialization and 
such, where ideally you should have code that issues a SCSI command, 
then calls scsi_wait_req or similar to wait for the command's completion.


> I will fix some of the issues you mention and re-send.  Thanks!

Thanks!

	Jeff




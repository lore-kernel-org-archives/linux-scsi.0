From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Status of patch as168 (sysfs readonly max_sectors attribute)
Date: Thu, 15 Jan 2004 14:30:17 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401151425590.1316-100000@ida.rowland.org>
References: <4006E2C2.10901@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:11012 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261464AbUAOTaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 14:30:19 -0500
In-Reply-To: <4006E2C2.10901@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 15 Jan 2004, Jeff Garzik wrote:

> Yeah, I want to kill scsi's max_sectors and dma_boundary both.  All SCSI 
> does is pass them straight to blk_queue_max_sectors() and 
> blk_queue_segment_boundary() from scsi_alloc_queue() anyway.
> 
> But it seems to me that the block layer already exports everything needed.
> 
> IMO: esteemed and wise SCSI maintainers should pick a point 
> (->slave_config?) where the low-level SCSI driver is allowed to tweak a 
> queue's settings in a race-free way (i.e. before any requests are 
> allowed to be sent to that queue).
> 
> Once that is done, elimination of max_sectors and dma_boundary is a 
> three-step process:
> 1) create a helper function scsi_config_queue() or somesuch.  This is 
> the default for low-level drivers without a slave_config.
> 2) make a bombing run through the low-level drivers, removing 
> max_sectors and dma_boundary from their template
> 3) simultaneously to #2, make a similar bombing run, adding or updating 
> the slave_config for each driver
> 
> Long term I want to bring low-level {scsi | ide | whatever} drivers much 
> closer to the block layer, and the above is actually one of the steps I 
> wanted to do anyway.

If I understand this, you would like to see the low-level drivers manage
these things for themselves by talking directly to the block layer,
without having to go through the intermediate SCSI layers.  This would
imply that any sysfs interface to max_sectors would then be the
responsibility of the driver, since the block layer itself is much too
generic to permit users to fiddle with the settings.

Correct?

Alan Stern


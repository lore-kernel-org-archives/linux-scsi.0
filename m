From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Status of patch as168 (sysfs readonly max_sectors attribute)
Date: Thu, 15 Jan 2004 13:58:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4006E2C2.10901@pobox.com>
References: <Pine.LNX.4.44L0.0401151300560.965-100000@ida.rowland.org> <1074190688.1867.143.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45235 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261659AbUAOS6Y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 13:58:24 -0500
In-Reply-To: <1074190688.1867.143.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-01-15 at 13:03, Alan Stern wrote:
> 
>>Does that mean you don't want to apply it and it should be done privately 
>>within usb-storage?  Or has it already been applied without me realizing?
> 
> 
> Sorry, I meant to comment on this.
> 
> The thing I really don't like is the fact that max_sectors is a block
> attribute but it's being exported from SCSI, I didn't catch this until I
> saw the patch.  This means it's should properly be exported at the block
> level, not at the SCSI level.


And I'm glad you commented on this :)

Yeah, I want to kill scsi's max_sectors and dma_boundary both.  All SCSI 
does is pass them straight to blk_queue_max_sectors() and 
blk_queue_segment_boundary() from scsi_alloc_queue() anyway.

But it seems to me that the block layer already exports everything needed.

IMO: esteemed and wise SCSI maintainers should pick a point 
(->slave_config?) where the low-level SCSI driver is allowed to tweak a 
queue's settings in a race-free way (i.e. before any requests are 
allowed to be sent to that queue).

Once that is done, elimination of max_sectors and dma_boundary is a 
three-step process:
1) create a helper function scsi_config_queue() or somesuch.  This is 
the default for low-level drivers without a slave_config.
2) make a bombing run through the low-level drivers, removing 
max_sectors and dma_boundary from their template
3) simultaneously to #2, make a similar bombing run, adding or updating 
the slave_config for each driver

Long term I want to bring low-level {scsi | ide | whatever} drivers much 
closer to the block layer, and the above is actually one of the steps I 
wanted to do anyway.

	Jeff




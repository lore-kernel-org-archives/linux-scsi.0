From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Sysfs attribute file for max_sectors
Date: Tue, 6 Jan 2004 14:31:10 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org>
References: <1073413440.2221.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:23812 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264936AbUAFTbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 14:31:10 -0500
In-Reply-To: <1073413440.2221.47.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On 6 Jan 2004, James Bottomley wrote:

> > The simplest way to export max_sectors to user processes is as a sysfs 
> > attribute.  We have code that will do this for USB devices, but perhaps it 
> > would be better as a general feature available for all SCSI devices.
> > 
> > What's your feeling?  Should max_sectors be exported for all SCSI devices 
> > or only for USB mass storage devices?
> 
> The value is useful to know for all drivers, so exporting it in sysfs
> should be fine.  If you want to do an attribute override in usb-storage,
> you can...but I'd be very careful not to let the user set it to an
> obviously wrong value (like larger than the sg array or something).

I was going to have a store() routine that would accept any value greater
than 0 and <= the value in the host template (or SCSI_DEFAULT_MAX_SECTORS
if the host template value is 0 -- that's what scsi_host_alloc() does).  
If this is writeable only by root, would that be acceptable for all SCSI
devices?

Alan Stern


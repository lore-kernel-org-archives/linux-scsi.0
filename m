From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Sysfs attribute file for max_sectors
Date: 06 Jan 2004 12:23:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073413440.2221.47.camel@mulgrave>
References: <Pine.LNX.4.44L0.0401061301230.1043-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31636 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264981AbUAFSYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 13:24:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401061301230.1043-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 2004-01-06 at 12:07, Alan Stern wrote:
> Some USB Mass Storage devices need max_sectors set as low as 64 KB per
> transfer.  Many devices don't have this restriction, though, and it would
> be nice to give users an easy way to change the value.  Especially if we
> play it safe by starting with the default value set low; that way more
> capable devices wouldn't have to be penalized.

This is treading on dangerous ground.  Setting max_sectors too high is a
sure fire way to hang a driver.  Its value isn't really "policy" which
belongs in user land, its an expression of a driver constraint.

> The simplest way to export max_sectors to user processes is as a sysfs 
> attribute.  We have code that will do this for USB devices, but perhaps it 
> would be better as a general feature available for all SCSI devices.
> 
> What's your feeling?  Should max_sectors be exported for all SCSI devices 
> or only for USB mass storage devices?

The value is useful to know for all drivers, so exporting it in sysfs
should be fine.  If you want to do an attribute override in usb-storage,
you can...but I'd be very careful not to let the user set it to an
obviously wrong value (like larger than the sg array or something).

James



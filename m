From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Sysfs attribute file for max_sectors
Date: Tue, 6 Jan 2004 17:00:44 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401061652450.621-100000@ida.rowland.org>
References: <20040106131105.A12358@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1284 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264574AbUAFWAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 17:00:45 -0500
In-Reply-To: <20040106131105.A12358@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 6 Jan 2004, Patrick Mansfield wrote:

> Alan -
> 
> Given that we currently don't have any user level intitiated scanning, how
> can you modify max_sectors in user space prior to the scsi_alloc_queue()
> call done during scan?

We can't.  But scan doesn't put much of a load on a device, and all sd
initially does is read partition table entries from single sectors
scattered around a disk.  Even mount doesn't seem to transfer very large
buffers.  It's only when people start using the devices and doing large
contiguous data transfers that we begin running against limitations.

So for us it would be enough to have scsi_slave_configure() set 
max_sectors to 128, insuring that this default value is workable on every 
device.  Then user space tools could increase that value for more capable 
devices at any time and reap the benefits of decreased overhead.

Making the store() method a USB-specific override is okay with me.

Alan Stern


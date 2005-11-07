From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 7 Nov 2005 15:59:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511071552360.5165-100000@iolanthe.rowland.org>
References: <20051107204720.GA18608@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:21943 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965370AbVKGU7w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 15:59:52 -0500
In-Reply-To: <20051107204720.GA18608@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, 7 Nov 2005, Patrick Mansfield wrote:

> We have the specific problem of a device being reported as scsi-2
> compliant when it is not.
> 
> Stepping back a bit ...
> 
> usb-storage should pass through the scsi level, we should not require
> special handling (adding back inhibit lun support or a new black list
> option) for compliant hardware.
> 
> So, do we have a usb-storage problem or non-compliant hardware here? I
> did not find the answer in previous emails.
> 
> That is, is usb-storage forcing scsi-2 when the device tells us it is
> scsi-3 compliant, or is the hardware reporting devices are scsi-2, yet
> requiring non-LUN value in cdb[1]?

I think we may have both.  However I don't know how this Cypress chip
reports itself.  A system log showing the INQUIRY data would be very
helpful.

It's quite possible that usb-storage no longer needs to force the 
scsi-level to 2.  No one has recently tested what would happen without 
it.  Matt probably has the best selection of devices for testing...

There is one problem we have with devices that report themselves as SCSI-3 
or SCSI-4 but hang when they receive a REPORT LUNS command.  That's easily 
handled by making usb-storage set the NOREPORTLUN flag.  Maybe that's all 
we need to do.

Alan Stern


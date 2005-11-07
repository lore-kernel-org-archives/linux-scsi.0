From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 12:47:20 -0800
Message-ID: <20051107204720.GA18608@us.ibm.com>
References: <20051107185718.GA16791@us.ibm.com> <Pine.LNX.4.44L0.0511071449560.5078-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:7657 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965325AbVKGUrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 15:47:40 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0511071449560.5078-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, usb-storage@lists.one-eyed-alien.net, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, Nov 07, 2005 at 02:53:34PM -0500, Alan Stern wrote:
> On Mon, 7 Nov 2005, Patrick Mansfield wrote:
> > Can we trigger black listing based on the above vendor/product values?
> > i.e. can you check for these values in usb-storage slave_configure code?
> 
> Yes.  The patch below illustrates how.  You'll have to change the name of 
> the sdev flag to something sensible...
> 
> I firmly believe this is the wrong approach, however.  It's a specific 
> solution to a general problem.  I would much prefer to add a new flag to 
> struct request.

We have the specific problem of a device being reported as scsi-2
compliant when it is not.

Stepping back a bit ...

usb-storage should pass through the scsi level, we should not require
special handling (adding back inhibit lun support or a new black list
option) for compliant hardware.

So, do we have a usb-storage problem or non-compliant hardware here? I
did not find the answer in previous emails.

That is, is usb-storage forcing scsi-2 when the device tells us it is
scsi-3 compliant, or is the hardware reporting devices are scsi-2, yet
requiring non-LUN value in cdb[1]?

A method that can reliably and easily set some black list value for the
hardware in question will to lead to fewer questions in the future as to
why an SG_IO command is getting LUN values set in cdb[1].

If this is a hardware problem I'm not opposed to adding back support for
the ioctl and AFAIUI a new struct request flag.

-- Patrick Mansfield

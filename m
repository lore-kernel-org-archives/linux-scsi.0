From: Alan Stern <stern@rowland.harvard.edu>
Subject: Expose shost->max_sectors via sysfs
Date: Tue, 28 Oct 2003 15:06:59 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281501500.6609-100000@ida.rowland.org>
References: <1067361445.7040.12.camel@patehci2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:23300 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261719AbTJ1UHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:07:00 -0500
In-Reply-To: <1067361445.7040.12.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Pat LaVarre <p.lavarre@ieee.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

I would like to add my voice to the complaint copied below.  Is there any
possibility of having shost->max_sectors exposed and settable via a sysfs
attribute file, so that data transfer sizes can be tuned by the user to
match the capabilities of high-performance devices?

My reason for asking is that a number of USB Mass Storage devices die when
asked to accept a transfer larger than about 128 KB.  But plenty of others
work just fine with transfers of 1 MB or more.  It would be nice to leave
the default limit set at the low value for interoperability but give
people a mechanism for increasing the transfer size limit when they want.

Alan Stern


On 28 Oct 2003, Pat LaVarre wrote:

> > not sure whether it should be applied or not.
> > 
> > Maybe the best solution is start off limiting transfers to 120 KB by 
> > default and asking the SCSI people to expose the max_sectors host field 
> > via sysfs.  That way people could adjust it upward for high-performance 
> > devices that will work with larger transfers.
> 
> Hi, hello, personally I have such a device.
> 
> Via SG_IO I can see my device hints in a number of mmc standard ways
> that my device responds best to large multiples of 64 KiB, aligned. 
> This idea of max 120 KB/cdb sharply conflicts with my mechanical reality
> of prefering aligned 1 MiB/cdb or more
> 
> How do I teach Linux to come to appreciate these standard mmc hints?
> 
> The paused thread:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106700651518749
> 
> List:     linux-scsi
> Subject:  Re: aligned /dev/scd$n reads less rare how
> Date:     2003-10-24 14:41:16
> 
> shows my device suffering from abuse: 
> 
> $ time sudo dd if=/dev/scd0 bs=1M
> ...
> usb-storage:  x 28 00 00 00 00 00 00 00 20 00
> usb-storage:  x 28 00 00 00 00 20 00 00 24 00
> usb-storage:  x 28 00 00 00 00 44 00 00 40 00
> usb-storage:  x 28 00 00 00 00 84 00 00 40 00
> usb-storage:  x 28 00 00 00 00 C4 00 00 40 00
> ...
> usb-storage:  x 28 00 00 07 FE C4 00 00 40 00
> 
> I had hoped to see something more radically polite, like:
> 
> $ time sudo dd if=/dev/scd0 bs=1M
> ...
> usb-storage:  x 28 00 00 00 00 00 00 02 00 00
> usb-storage:  x 28 00 00 00 02 00 00 02 00 00
> usb-storage:  x 28 00 00 00 04 00 00 02 00 00
> ...
> usb-storage:  x 28 00 00 07 FC 00 00 02 00 00
> ...
> 
> Indeed, personally I so immediately & deeply needed such polite
> consideration that I rolled my own code to get it via SG_IO i.e. I
> reinvented my own dd/ sg_dd:
> http://members.aol.com/plscsi/tools/pldd/
> 
> But I think I gather here the impression that a Linux block device only 
> by default shatters stream into rudely tiny pieces.  Thru a Linux block
> device I can stream as effectively as thru SG_IO, if only I reconfigure
> Linux appropriately?
> 
> Pat LaVarre


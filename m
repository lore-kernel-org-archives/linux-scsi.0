From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger
 receive buffer
Date: Thu, 13 Nov 2003 17:01:53 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
References: <1068744259.13580.41.camel@patrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:57604 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264435AbTKMWBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:01:55 -0500
In-Reply-To: <1068744259.13580.41.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On 13 Nov 2003, Pat LaVarre wrote:

> Deciding writable or not when disc arrives, rather than when device
> arrives, sounds good.
> 
> Breaking write protect that works sounds bad.  Does write protect ever
> work?

Your question is ambiguous.  Write protection has two aspects: detecting 
whether a device or its media is write protected, and avoiding sending any 
write commands to the device.  The first aspect doesn't work for many USB 
disk devices -- I haven't heard of any problems with USB CD/DVD devices -- 
and the second aspect works quite well (although you may want to update 
it for various CD/DVD type devices).  The only questionable point is that 
the kernel doesn't try to check commands that it doesn't generate itself, 
like commands submitted by way of the sg driver.

> Me, I want to learn how write protect works in Linux cdrom/sr/ide-cd
> because I want my USB & ATAPI write-protectable Iomega RRD to work.
> 
> Anybody know a better way for me to learn than to try write-protectable
> sd discs?

You could read through the source code.  A quick look at drivers/scsi/sr.c 
highlights the get_capabilities() routine.  Going through 
drivers/cdrom/cdrom.c shows that cdrom_open() checks for write 
capabilities.  If the drive is not marked with the CDC_DVD_RAM flag, you 
aren't allowed to open the device file for writing.

> So far I'm deeply confused by the concept of a device writable or not.
> 
> To ignorant newbie me, only partitions of discs are writable or not.

What do you find confusing?  There are basically just two issues: will the
device carry out a write request, and will the kernel allow you to send a
write request to the device.  The answer to the second may well vary
depending on what mechanism you use to send the request (sr versus sg for
example).

> > > We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink at
> > > the same time we fix SCSI over USB, yes?
> > 
> > Are they broken?
> 
> Aye, in much the same way: nothing but Talk Like Windows actually works
> well across a wide variety of devices.
> 
> I hear commercially available DVD/CD burning software actually resorts
> to guessing behaviour by op x12 Inquiry String.  Some apps doesn't even
> try to talk to an unrecognised device.  Friendlier apps gives you the
> option of running a diagnostic to try to discover behaviour - you crash
> or you hang or you profile the new device.
> 
> Traces tell me binary-code-only Windows XP/2K produces the first few cdb
> after plug in independently by bus, but pretty early in life the
> different forms of SCSI over whatever then share a common cdb author.
> 
> I'm guessing from nearly zero evidence, but as yet by guess is that the
> DVD/CD driver tries politically correct speech e.g.
> fetch-header-fetch-available, but the HDD/Flash driver tries a less
> obvious legacy speech whose sole virtue is that it works.

Those sound like different issues from the one we've been discussing in 
this thread, namely: how should sd.c try to determine the read/write 
status and cache-type of a disk device?

Alan Stern


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Thu, 4 Dec 2003 13:30:16 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312041329450.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8708 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263468AbTLDSaR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2003 13:30:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Here is a digested version of a log trace contributed by Alex Sanks.  It 
was collected from a generic USB Bulk-only storage device (actually the 
g_file_storage file-backed storage gadget) attached to a host running 
Windows XP SP1.  It agrees quite well with the results of my own tests 
using USB Snoopy on a Windows 2000 host.

In this trace, the number following the command name is the command length
in decimal; following it are the command bytes in hex, then the direction
and transfer length in decimal.


INQUIRY		6: 12 00 00 00 24 00  In 36
Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
	Provokes an Invalid Command error
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
	Bug in Windows: REQUEST-SENSE is really a 6-byte command

Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
	Retry previous failed command; it still doesn't work
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
	Another futile retry
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18

READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	Provokes Unit Attention: Reset Occurred
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	This time it works

READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
	Read the first sector
READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
	Windows likes reading the first sector
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	It also likes reading the disk capacity

MODE-SENSE	6: 1a 00 1c 00 c0 00  In 192
	Page 1c is listed as reserved; I don't know what it is;
	provokes Invalid Field in CDB error
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18

MODE-SENSE	6: 1a 00 3f 00 c0 00  In 192
	So page 3f should work if we request 192 bytes!

MODE-SENSE	6: 1a 00 08 00 c0 00  In 192
	And so should page 08!

MODE-SELECT	6: 15 10 00 00 18 00  Out 24
	Although not shown here, a USB Snoopy trace reveals that this
	attempts to set the WCE (write cache enable) bit in page 8;
	here it provokes Invalid Field in CDB error
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18

MODE-SELECT	6: 15 10 00 00 18 00  Out 24
	Retry of previous failed command; it fails again
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18

READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	Windows really likes to get the capacity!
READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
	And it really likes to read the first sector!
READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	Ommitted: this command was repeated 8 times

TEST-UNIT-READY	6: 00 00 00 00 00 00  
MODE-SENSE	6: 1a 00 00 00 0c 00  In 12
	I don't know what Windows expects to find in page 0;
	but this fails
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18

READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
	Ommitted: this command was repeated 3 times

TEST-UNIT-READY	6: 00 00 00 00 00 00  
MODE-SENSE	6: 1a 00 00 00 0c 00  In 12
	Fails again
REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8


Some of the activity may depend on the contents of the partition table
stored in the first sector.  But it seems clear that, subject to the
unknown function of command x23 and of mode page x1c, we might be able to
work with devices that advertise themselves as Bulk-only by requesting 192
bytes from page x3f and page 8.

Does anybody know what command x23 and mode page x1c do?  Although 
nominally vendor-specific, they must be reasonably standardized if Windows 
can get away with using them on a generic device.

Unfortunately, there's nothing to stop a manufacturer from supplying their
own driver which would avoid reading those pages.  So even an apparently
normal device might react badly to these commands.  However I think it's 
still worth a try.

Alan Stern





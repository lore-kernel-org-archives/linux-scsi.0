From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Fri, 16 Jan 2004 11:19:33 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0401161102390.843-100000@ida.rowland.org>
References: <20040116121824.GB10117@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040116121824.GB10117@paradigm.rfc822.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Florian Lohoff <flo@rfc822.org>, Alexander Motzkau <a.motzkau@web.de>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Help!  This is a problem in the interface between usb-storage and the SCSI
core (or maybe the block layer core).  The core thinks there is an error
when in fact there isn't.

On Fri, 16 Jan 2004, Florian Lohoff wrote:

> On Fri, Jan 16, 2004 at 12:48:00PM +0100, Alexander Motzkau wrote:
> > Hello,
> > 
> > I've got some problem with an USB Stick ("Floppy-on-Disc" Vendor=0ea0
> > ProdID=6828 Rev=1.10). It's an USB2 Stick, but I'm using it on an
> > USB 1.1-Controller (Intel 82801BA/BAM, Intel 815 Chipset).
> > 
> > The problem does occur with Kernel 2.6.1-rc1 (and 2.6.1), but not with
> > Kernel 2.6.0 (an 2.4.21).
> 
> I am having the same problem with the same Stick - For me the problem
> started with 2.6.0-test11 IIRC and is still valid for 2.6.1. All 2.4 kernel
> work - Mine is a
<snip>
> Here is my usb-storage debugging:

> usb-storage: Command READ_10 (10 bytes)
> usb-storage:  28 00 00 00 00 20 00 00 01 00
> usb-storage: Bulk Command S 0x43425355 T 0x1f L 512 F 128 Trg 0 LUN 0 CL 10
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> usb-storage: Status code 0; transferred 512/512
> usb-storage: -- transfer complete
> usb-storage: Bulk data transfer result 0x0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result = 0
> usb-storage: Bulk Status S 0x53425355 T 0x1f R 512 Stat 0x0

The READ completes successfully and transfers all 512 bytes, but the 
device reports a residue of 512 (probably a bug in the firmware).  Seeing 
a positive residue for the read, usb-storage does an auto-sense:

> usb-storage: -- unexpectedly short transfer
> usb-storage: Issuing auto-REQUEST_SENSE
<...>
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
> usb-storage: No Sense: No additional sense information
> usb-storage: scsi cmd done, result=0x0
> usb-storage: *** thread sleeping.

Seeing no sense key, usb-storage returns 0 indicating the command
succeeded.  But scsi_finish_command() sees that valid sense data is
present and sets the driver_byte to DRIVER_SENSE.

> SCSI error : <1 0 0 0> return code = 0x8000000
> Current sda: sense key No Sense

This causes scsi_io_completion() to call scsi_end_request() with uptodate 
= 0 and results in this error:

> end_request: I/O error, dev sda, sector 32
> FAT: unable to read boot sector

How should we handle this?  Should we zero out sense_buffer[0] when 
auto-sense shows sense key = NO_SENSE?

Alan Stern



-------------------------------------------------------
The SF.Net email is sponsored by EclipseCon 2004
Premiere Conference on Open Tools Development and Integration
See the breadth of Eclipse activity. February 3-5 in Anaheim, CA.
http://www.eclipsecon.org/osdn
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

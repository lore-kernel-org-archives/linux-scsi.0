From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Flash memory problem
Date: Sun, 27 Aug 2006 12:34:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608271214430.14629-100000@netrider.rowland.org>
References: <002901c6cae6$38b36e90$94403bd5@server>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.rowland.org ([192.131.102.7]:3080 "HELO mx2.rowland.org")
	by vger.kernel.org with SMTP id S932174AbWH0Qez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Aug 2006 12:34:55 -0400
In-Reply-To: <002901c6cae6$38b36e90$94403bd5@server>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Litvinov <antony@orel.ru>
Cc: USB users list <linux-usb-users@lists.sourceforge.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 29 Aug 2006, Anton Litvinov wrote:

> Hello.
> 
> 
> >
> > The major difference was that Windows didn't use the PREVENT-ALLOW MEDIUM
> > REMOVAL command.  So once you get that patch integrated into the driver
> > and use it properly, there's a good change the device will work.
> >
> > Alan Stern
> 
> 
> I applied a patch and that is what dmesg saying after plugging USB flash :

... device crashes while reading the partition table ...

> Then LED is blinking and lsusb is blocking console until USB flash
> is unplugged.

Here is a summary of all the SCSI commands from your capture logs in both 
Linux and Windows (all commands are for lun 0 unless otherwise noted):

	Linux:
INQUIRY
TEST UNIT READY (failed: Not ready to ready change)
TEST UNIT READY
READ CAPACITY
MODE SENSE 3f
TEST UNIT READY
TEST UNIT READY
READ CAPACITY
MODE SENSE 3f
READ(10) 8 sectors at 0 -- crashed

	Windows:
INQUIRY
READ FORMAT CAPACITIES (failed: Not ready to ready change)
READ FORMAT CAPACITIES
INQUIRY lun 1
READ FORMAT CAPACITIES lun 1 (failed: Not ready to ready change)
READ FORMAT CAPACITIES lun 1
READ CAPACITY
READ(10) 1 sector at 0
MODE SENSE 1c
MODE SENSE 3f
READ CAPACITY
READ CAPACITY
READ(10) 1 sector at 0
READ(10) 1 sector at 0
READ CAPACITY
READ CAPACITY
READ(10) 1 sector at 0
READ CAPACITY lun 1
READ(10) lun 1, 1 sector at 0
MODE SENSE 1c lun 1
MODE SENSE 3f lun 1
READ CAPACITY lun 1
READ CAPACITY lun 1
READ(10) lun 1, 1 sector at 0
READ(10) lun 1, 1 sector at 0
READ CAPACITY lun 1
READ CAPACITY lun 1
READ(10) lun 1, 1 sector at 0
TEST UNIT READY
TEST UNIT READY lun 1
TEST UNIT READY
READ CAPACITY
READ CAPACITY
READ(10) 8 sectors at 32

The main differences are:

	Windows uses READ FORMAT CAPACITIES and Linux doesn't.
	I doubt that this will make any difference.

	Windows sends INQUIRY and READ FORMAT CAPACITIES for
	lun 1 before doing anything more on lun 0.  It's possible
	that this matters, but I don't think so.

	Windows sends MODE SENSE with page code 0x1c and Linux
	doesn't.  Again, I doubt this will make any difference.

	Windows repeats lots of commands many times.  This shouldn't
	matter either.

	Windows reads 1 sector starting at sector 0 whereas Linux
	tries to read 8 sectors starting at sector 0 -- and when
	Linux sent that command, the device crashed.

There can be little question that the last difference is the important 
one.

There was no obvious reason for the device to crash when it did.  Perhaps
it just doesn't like to send any other sectors along with sector 0.  If
that's true, the device is in violation of the SCSI standards (although to
be fair, it doesn't claim to be compliant with the standards).

Sector 0 contains the partition table.  Naturally it is the first sector
to be read.  In principle no more than one sector's worth of data is
needed, but Linux almost always tries to read data in multiples of 4 KB (8
sectors).  I don't know any way to force Linux to do a 1-sector read of
sector 0 instead of an 8-sector read.

Maybe someone on one of the mailing lists can offer a suggestion.  As far 
as I can see, Linux simply can't use this device.

Alan Stern


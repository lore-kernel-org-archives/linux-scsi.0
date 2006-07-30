From: Douglas Gilbert <dougg@torque.net>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 14:02:46 -0400
Message-ID: <44CCF446.9000007@torque.net>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net> <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net> <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34989 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932168AbWG3SCy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 14:02:54 -0400
In-Reply-To: <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 29 Jul 2006, Douglas Gilbert wrote:
>> See below. Non-root users do not usually have read
>> or write permissions to a _disk_. We were talking
>> about a different class of devices: cd/dvd drives.
> 
> What has that got to do with _anything_?
> 
> What do you think is the difference between a disk and a CD drive?
> 
> And do you really think that it's the _medium_ that looks at the commands? 
> I don't think so. Regardless of whether it's a disk or a CD-ROM, it's the 
> controller in the _drive_ that looks and acts on those commands.
> 
> And that CD drive (that you have write access to) also has things like 
> firmware. And how do you think that firmware is updated? By magic? Or by 
> SCSI commands sent to the drive?

<snip>

Hard disks and CD/DVD drives are quite different from
a command set point of view. Both have high level
read operations that map very cleanly to the block
layer. The write side is very different. Disks have
a high level write operation that is symmetric with
the read operation and the write can be called many times
on the same lba with provision for multi user access
(locking). Writes and reads can be interspersed in
rapid succession.

OTOH CD/DVD drive media are written once (leaving aside
the "-RW" hack) and that write is done at a much
lower level (command set wise) than the read. The
application writing the cd/dvd media is assumed to
have exclusive access for the duration of the write
operation (which may be some time). During a write
operation the rest of the cd/dvd media is unavailable
for reading. That low level write operation assumes
the application knows a lot more about the drive and
the media than the OS would ever want to know. Another
difference is that the cd/dvd media is not only
removable but that a user expects to be able to
read it 5 or 10 years after it was burnt on a drive
from another manufacturer.

To cope with the lower level write once operation of a
cd/dvd drive, we need applications like cdrecord and
nero and they need a pass through interface. Just like
you, I have been abused by Joerg Schilling but there
was some technical merit in what he was saying and
it is reflected in the SG_IO ioctl design. Actually
the idea of the SG_IO ioctl itself came from Joerg
Schilling.


I have pointed out that the block layer SG_IO ioctl is
broken in various ways. Here is an example chosen because
it will be very difficult to exploit. The MMC command
set must not use opcodes (the first byte of a SCSI cdb)
that are used by the SCSI Primary Commands (SPC) but it
can overlap with other device specific command sets.
A quite important device specific command set is SBC (for
block devices including hard disks). The GET PERFORMANCE
MMC command is set for O_RDONLY access by the block layer
SG_IO filter and O_RDWR by the sg driver. That command uses
opcode 0xac . From a MMC point of view that opcode is "safe".
Now checking my references I observe that for the optical
block memory device type (covered by SBC) that is an
ERASE(12) operation. Choose your poison!


Also be aware that we have been in a world of multiple command
sets (and multiple transports) for some time. Take ATAPI devices:
one can send many SPC and MMC (SCSI) commands to such a device.
One can also send certain (transport and identification related)
ATA commands. The most obvious example of the latter is the
IDENTIFY PACKET DEVICE (ATA) command. As of lk 2.6.15 one can
send that ATA command two ways:
  - via the long standing ATA specific ioctls (e.g. the
    HDIO_GET_IDENTITY ioctl **)
  - if the device is libata connected (or any other SAT
    compliant layer), via the ATA PASS THROUGH SCSI command

The IDENTIFY PACKET DEVICE (ATA) command is "safe" and
should be allowed O_RDONLY but not all ATA commands that can
be sent to ATAPI device (e.g. SET FEATURES) could be
considered "safe". Once we move lower into the transport
domain, things can become even murkier with ATAPI
possibly conveyed across SATA (S-ATAPI) which in turn may
be conveyed across STP in SAS. Sometimes transport
characteristics can be tweaked "in-band", that is, down the
same path that commands are sent.


The point I'm trying to make is that opcode based filtering
may have been sufficient in 1992 (circa SCSI-2) but 14
years later it most certainly ain't.


Doug Gilbert

** Last time I looked the HDIO_GET_IDENTITY ioctl returned
   cached information. IMO that is incorrect, it should go
   out to the command each time.

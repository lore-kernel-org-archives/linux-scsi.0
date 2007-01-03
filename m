From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16 commands	to	libata
 ATAPI devices
Date: Wed, 03 Jan 2007 14:39:25 -0500
Message-ID: <459C066D.30507@torque.net>
References: <200701021935.07840.liml@rtr.ca>	 <1167788405.3687.25.camel@mulgrave.il.steeleye.com>	 <459B4243.5080804@rtr.ca> <1167838307.2789.12.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1167838307.2789.12.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-01-03 at 00:42 -0500, Mark Lord wrote:
>> James Bottomley wrote:
>>> I don't think I quite understand what you're trying to do here.  My
>>> understanding is that ATA_12 and ATA_16 are part of the SAT layer. i.e.
>>> they're used when we're speaking SCSI to an underlying ATA device to
>>> send taskfiles.  However, ATAPI devices don't use SAT ... every SCSI
>>> command you send to an ATAPI device goes out as an ATA PACKET command
>>> without being translated.
>> ATAPI devices also implement quite a few ATA (non-packet) commands.
>> This patch gives us a way to issue them in response to SG_IO ATA passthru
>> and the existing (non working) libata HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
>> ioctl calls.
> 
> I know that ... but when you send ATA_16 down to an ATAPI device via
> SG_IO  the code paths in libata don't unwrap it and send it out as a
> taskfile ... they put ATA_16 out as a packet command.
> 
>> Without this patch, SCSI blocks the ATA_16 passthru attempts,
>> because it thinks the CDB is too large for the 12-byte packet protocol
>> that ATAPI devices use.  This limit (12 bytes) is totally non-applicable
>> to ATA protocol commands.
>>
>>> Is there a missing piece to this patch, where you scan the incoming
>>> commands to ATAPI devices and actually do translation for ATA_16?
>> Look at the existing libata-core.c ioctl's for HDIO_DRIVE_CMD
>> and HDIO_DRIVE_TASK, used by hdparm and others.
> 
> Those send out taskfile commands ... my point is that the SAT SCSI
> commands only come down the SCSI paths, so without additional processing
> in the ATAPI path they're just packaged up as PACKET commands and never
> unwrapped and sent out as taskfiles.   If you think about it, cdrecord
> sending BLANK via SG_IO to an ATAPI device would never work if we
> interpreted ATA_12 in the ATAPI path...

James,
This doesn't only affect libata. The MPT Fusion SAS HBAs
have a SATL in firmware. It also make sense to put SATLs
close to the end device; for example: in a USB mass storage
bridge **, dito sbp2, and in a SAS enclosure (in which case
really useful SCSI commands like PERSISTENT RESERVE could
be implemented in front of SATA disks).

IMO we need to have a concept of near and far transport.
The near transport is what the LLD or local bridge (e.g.
libata is a virtual target) sees. The far transport is
what the lu sees (e.g. for cd/dvd drives that is usually
(S)ATAPI). So if the near transport does not limit cdb
length then the command should be sent to the target. If
the target can't either:
  - send the command unaltered to the lu, or
  - bridge the command to the far transport, or
  - interpret the command itself (e.g. REPORT LUNS + ATA_16)
then it can report an error.


I seem to be fighting a losing battle against the mindset
of trying to process errors at the highest possible level
and the even worse Unix block layer habit of trying to
foresee errors a priori.
Taking this example: should the block layer reject pass-
through SCSI commands due to command length? Of
course not, it shouldn't even know about SCSI command sets.
Should the cdrom driver block 16 byte SCSI commands?
No, because MMC imposes not limit in the cdb length.
It is the _transport_ that should block the command,
if it so chooses. In this case the transport is a
virtual one between sr/sg and libata and libata should
recognize SCSI ATA PASS-THROUGH (12+16) cdbs as
transport related and not (directly) to be sent to
the logical unit. And it is at this level we should
add the wrinkle that if the pdt=5 (cd or dvd) then
don't translate ATA_12. [I have already been around this
loop with Luben and his SATL: sorted with the minimum
of fuss.]


We also have the concept of the block layer as a common
security filter and some folks want to merge (i.e.
read _eliminate_ the sg driver's filter) the block layer
and the sg filter. Well sg's filter is SPC based with
some SBC knowledge and the block layer's filter is
heavily MMC based ("designed" to trick/facilitate cdrecord).
How to treat the ATA_16 command? Well at the moment sg will
require read-write permissions whereas I think the block
layer will require root (or CAP_IO_RAW) permissions. As a
point of reference, Windows documentation only identifies
one class of commands that it will block in its pass through
(SPT) and those are of the EXTENDED COPY type. That one is
way too powerful for OS folks to allow the users to get
their hands on.


** I have been told that USB disk enclosures being designed
now will include at a SATL. This will mean smartmontools
(version 5.37 and later) and hdparm (assuming that Mark is
looking at adding SATL pass through support) will just work
seamlessly. SAT does not include any sub-addressing support
so it doesn't help in trying to obtain diagnostic access
to physical (SATA) disks behind a logical SCSI (RAID) disk
device.

Doug Gilbert



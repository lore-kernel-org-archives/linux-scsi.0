From: Douglas Gilbert <dougg@torque.net>
Subject: Re: (SAT) libata + hdparm/smartctl
Date: Sun, 20 Nov 2005 17:10:36 +1000
Message-ID: <4380216C.5090408@torque.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>	 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave> <4372E66F.5070802@gmx.de> <437358EA.3090406@rtr.ca> <437361CF.2040909@gmx.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <437361CF.2040909@gmx.de>
Sender: linux-ide-owner@vger.kernel.org
To: t.schorpp@gmx.de
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

thomas schorpp wrote:
> Mark Lord wrote:
> 
>>thomas schorpp wrote:
>>
>>
>>>for hdparm ata-security theres ide taskfile used, can scsi command
>>>sequences combined with ide taskfiles which use own ioctls?
>>
>>
>>As Jeff said, libata translates some of the HDIO_TASK* functions
>>into SCSI passthru commands, which then get translated back
>>into ATA commands at the time of issue to the device.
>>
>>Once passthru makes it out into the wild (Linus kernels),
>>I'll update hdparm to have it use SCSI passthru instead
>>when available/appropriate.
>>
>>There will have to be about a year or so of full overlap
>>(hdparm, smartmontools, and kernel), to give distros time
>>to update/release with all of the affected components.
>>
>>After that, I imagine Jeff may want to remove the HDIO_TASK*
>>calls again.
>>
>>Cheers
> 
> 
> ive tried the whole day to make this driver helper libata or parts of it available to the user space
> and it didnt work out, sorry, you cant include the header in user-space apps and theres no interface to it.
> 
> but if You say so, i'll take a closer look at libatas HDIO_TASKs but this has to be utilized automatic then,
> at this time libata.ko does not get loaded or used by usbstorage devices.
> 
> when it is a driver library i will use it with drivers, as it should be:
> 
> so i look if i can modify sg, sd_mod or/and usb-storage to detect passthru needing devices automatic and to
> take action on passthru needing functionality, then none of the user space apps should need to be worked on.
BTW The ATA COMMAND PASS THROUGH (12) SCSI command shares its
opcode (0xa1) with the MMC BLANK command. According to sat-r07
a SAT layer should identify itself by using "ATA     " as
the vendor string of its standard INQUIRY response.



For those not aware in lk 2.6.15-rc1 smartctl (from smartmontools)
works. First you see:

# smartctl -a /dev/sda
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: ATA      ST380013AS       Version: 3.18

In Linux, SATA disks accessed via libata are not currently supported
by smartmontools. By the time you read this, support may have been added
in recent kernels. Try an additional '-d ata' argument.


Following that advice:

# smartctl -a -d ata /dev/sda
<output just like an (p)ATA disk>


Recent versions of hdparm also work (e.g. "hdparm -I /dev/sda").

Doug Gilbert


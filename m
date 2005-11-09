From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating	SMART/ATA-Security
 in usb-storage driver
Date: Wed, 09 Nov 2005 15:05:38 +0100
Message-ID: <43720232.6090609@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com> <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4371F7C3.5080702@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
>>no change with smartctl:
>>tom1:/usr/src/sm5/debug# ./smartctl -a -r ioctl,2 -T verypermissive
> /dev/sda
> 
> Shouldn't there be a "-d ata" flag on those smartctl commands?
> -

? i cant find any ata-passthrough in smartctl cvs, the device is treated pure ata then.

ok, will add the (preliminary) passthrough opcodes to linux/scsi.h, 
include it in hdparm, add an option "-d atacb", then try it out there, not?

tried -d ata too. result negative as expected:

tom1:/usr/src/sm5/debug# ./smartctl -a -d ata -r ioctl,2 -T verypermissive /dev/sg0
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/


REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE
REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE returned -1 errno=1 [Operation not permitted]

===== [IDENTIFY DEVICE] DATA START (BASE-16) =====
000-015: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
===== [IDENTIFY DEVICE] DATA END (512 Bytes) =====


REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY PACKET DEVICE
REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY PACKET DEVICE returned -1 errno=1 [Operation not permitted]

===== [IDENTIFY PACKET DEVICE] DATA START (BASE-16) =====
000-015: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
===== [IDENTIFY PACKET DEVICE] DATA END (512 Bytes) =====

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

=== START OF INFORMATION SECTION ===
Device Model:     [No Information Found]
Serial Number:    [No Information Found]
Firmware Version: [No Information Found]
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   1
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Nov  9 14:53:22 2005 CET
SMART is only available in ATA Version 3 Revision 3 or greater.
We will try to proceed in spite of this.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't show if SMART supported.
                  Checking for SMART support by trying SMART ENABLE command.

REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE
REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE returned -1 errno=1 [Operation not permitted]
Error SMART Enable failed: Operation not permitted
                  SMART ENABLE failed - this establishes that this device lacks SMART functionality.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 85-87 don't show if SMART is enabled.
                  Checking to be sure by trying SMART RETURN STATUS command.

REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1 errno=1 [Operation not permitted]
SMART support is: Unavailable


REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1 errno=1 [Operation not permitted]
SMART Disabled. Use option -s with argument 'on' to enable it.
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug# smartctl -a -d ata -r ioctl,2 -T verypermissive /dev/sda
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/


REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE
REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE returned -1 errno=22 [Invalid argument]

===== [IDENTIFY DEVICE] DATA START (BASE-16) =====
000-015: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
===== [IDENTIFY DEVICE] DATA END (512 Bytes) =====


REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY PACKET DEVICE
REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY PACKET DEVICE returned -1 errno=22 [Invalid argument]

===== [IDENTIFY PACKET DEVICE] DATA START (BASE-16) =====
000-015: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
===== [IDENTIFY PACKET DEVICE] DATA END (512 Bytes) =====

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

=== START OF INFORMATION SECTION ===
Device Model:     [No Information Found]
Serial Number:    [No Information Found]
Firmware Version: [No Information Found]
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   1
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Nov  9 14:53:35 2005 CET
SMART is only available in ATA Version 3 Revision 3 or greater.
We will try to proceed in spite of this.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't show if SMART supported.
                  Checking for SMART support by trying SMART ENABLE command.

REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE
REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE returned -1 errno=22 [Invalid argument]
Error SMART Enable failed: Invalid argument
                  SMART ENABLE failed - this establishes that this device lacks SMART functionality.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 85-87 don't show if SMART is enabled.
                  Checking to be sure by trying SMART RETURN STATUS command.

REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1 errno=22 [Invalid argument]
SMART support is: Unavailable


REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1 errno=22 [Invalid argument]
SMART Disabled. Use option -s with argument 'on' to enable it.
tom1:/usr/src/sm5/debug# 

From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Mon, 25 Oct 2004 17:55:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410252255.i9PMto6B024865@falcon10.austin.ibm.com>
References: <58cb370e041024054575c09679@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:985 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262081AbUJZBYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 21:24:31 -0400
In-reply-to: <58cb370e041024054575c09679@mail.gmail.com> 
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org


On Sun, 24 Oct 2004 14:45:53 +0200, Bartlomiej Zolnierkiewicz wrote:
...
>
>The new ide_fix_driveid function seems buggy,
>ie. it byte-swaps id->max_multsect with id->vendor3.

Ok, lets look at those vars.  Both are defined in hdreg.h as bytes.
No fields in the data from the device are bytes, but are 16 bit.  On big
endian, the relative positions for an LE u16 are swapped.  If the swap is
not done on those, then one replaces the other when read.  Probably not
what was intended.  It appears that another bug is being fixed here.

Do you not agree that all reads when doing IDENTIFY xxx DEVICE are
retrieved as u16?  If not, then the current ide_fix_driveid() code is
wrong also.

Backup data, taken from the raw bits on the wire via datatransit:

$ hexdump -C eio/ata/041025-2.6.9-rc3-wcd-4-dwm.data.bin
00000000  40 00 ff 3f 37 c8 10 00  00 00 00 00 3f 00 00 00  |@..?7.......?...|
00000010  00 00 00 00 20 20 20 20  20 20 20 20 20 20 36 20  |....          6 |
00000020  54 34 30 33 32 30 41 32  00 00 00 00 30 00 42 50  |T40320A2....0.BP|
00000030  30 31 45 33 20 20 4f 54  48 53 42 49 20 41 4b 4d  |01E3  OTHSBI AKM|
00000040  30 34 36 32 41 47 42 58  20 20 20 20 20 20 20 20  |0462AGBX        |
00000050  20 20 20 20 20 20 20 20  20 20 20 20 20 20 10 80  |              ..|
00000060  00 00 00 2f 00 40 00 02  00 00 07 00 ff 3f 10 00  |.../.@.......?..|
00000070  3f 00 10 fc fb 00 10 01  00 53 a8 04 07 00 07 00  |?........S......|
00000080  03 00 78 00 78 00 78 00  78 00 00 00 00 00 00 00  |..x.x.x.x.......|
00000090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000a0  7e 00 00 00 6b 7c 08 59  03 40 49 7c 08 18 03 40  |~...k|.Y.@I|...@|
000000b0  3f 20 0f 00 00 00 80 00  fe ff 4b 60 00 00 00 00  |? ........K`....|
000000c0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 a5 89  |................|
00000200

Note that bytes 5E-5F are '10 80'.  Per d1532, table 15, in the version I am 
looking at: 
47 M F 15-8 80h
     F 7-0 00h = Reserved  
     F     01h-FFh = Maximum number of sectors that shall be transferred per 
                     interrupt on READ/WRITE MULTIPLE commands

To match max_multisect and vendor3, the  bytes must be swapped.
	unsigned char	max_multsect;	/* 0=not_implemented */
	unsigned char	vendor3;	/* vendor unique */

Ouch! Oh man.  Depending on LE byte ordering in a u16, but only for certain 
vars.  Should this be ifdef'd in hdregs.h?  And, and, oh jeez...

What is the solution here?  Preserve the definitely non-arch neutral format
in hdregs.h?  All the char values are troubling.

Or copy and rename the entire ide_fix_driveid() into isd200?  This would be
Christoph's choice.

...
>The dependency is a bug, <linux/ide.h> is for IDE driver only.

The isd200 _is_ a bridge to ATA/ATAPI devices.  Does this mean it cannot use 
common code, just because it is not in drivers/ide?

>
>Doug, if you kill debugging code in isd200.c then only:
>
>id->command_set_1
>id->model
>id->fw_rev
>id->capability
>id->lba_capacity
>id->heads
>id->cyls
>id->sectors
>id->command_set_2
>
>need to be byte-swapped.
>

I don't plan on killing any debug code.





From: Ingo Flaschberger <if@xip.at>
Subject: Re: cpqfc gone - all compay RA4X00 Array now useless in linux?
Date: Mon, 6 Feb 2006 19:38:33 +0100 (CET)
Message-ID: <Pine.GSO.4.64.0602061921160.94@filebunker.xip.at>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at>
 <200602061923.31944@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:5310 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S932188AbWBFTHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 14:07:01 -0500
In-Reply-To: <200602061923.31944@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

Hello Rolf,

>> _only_ one which supported the now very cheap Compaq FiberChannel Array
>> RA4X00.
>>
>> With all other FC HBA's the logical volumes (LUN's) are not visible.
>> ---snip---
>> 5. Compaq RA4x00 firmware version 2.54 and later supports SSP (Selective
>> Storage Presentation), which maps LUNs to a WWN.  If RA4x00 firmware prior
>> 2.54 (e.g. older controller) is used, or the FC HBA is replaced (another WWN
>> is used), logical volumes on the RA4x00 will no longer be visible.
>> ---snap---
>>
>> So... there are 3 possibilities:
>> 1. Repair the cpqfc driver and but it again into linux?
>
> The driver is a horrible hack lacking too many of really needed error
> handling.
>
>> 2. Find out, how to get the RA4x00 arrays with othet HBA's running; I
>> 	searched about 1 week in Google, no way..
>
> We're working on it. The RA4x00 do things normal arrays don't or so.

What means, "We're working on it"?

> I'm not
> yet familiar enough with this to know exactly what is needed to beat this to
> work again.

The only thing I have found, why the RA4X00 arrays are different:
http://mail-index.netbsd.org/tech-kern/2005/01/06/0013.html
---sip---
Its been years time since I checked the T10/T11 drafts, but as best I
recall, there's some SCSI level (SCSI-3? The last ANSI level?)  where
any device claiming that level is required(?) to implement
REPORT_LUNS.

I've also seen devices just below that level which just won't talk
happily to an initiator unless the initiator sends them a REPORT_LUNS.
(The Compaq RA4000 RAID array was infamous for that. IIRC, the Linux
driver for the recommended Compaq/Aglient controller sent a REPORT
LUNs from inside the driver, then remapped the native LUNs to 8-bit
LUNS for upper layers; or something equally distaseful.)
---snap---

and the work around seems to be hardcoded in the cpqfc driver.


cpqfcTSworker.c
---snip---
     // e.g., the Compaq RA4x00 f/w Rev 2.54 and above may report
     // LUNs 4001, 4004, etc., because other LUNs are masked from
     // this HBA (owned by someone else).  We'll make those appear as
     // LUN 0, 1... to Linux
     {
       int j;
       int AppendLunList = 0;
       // Walk through the LUN list.  The 'j' array number is
       // Linux's lun #, while the value of .lun[j] is the target's
       // lun #.
       // Once we build a LUN list, it's possible for a known device
       // to go offline while volumes (LUNs) are added.  Later,
       // the device will do another PLOGI ... Report Luns command,
       // and we must not alter the existing Linux Lun map.
       // (This will be very rare).
---snap---

perhaps its that part of code....

when my server boots with 2.4.20:
dmesg:
---snip---
   HBA Tachyon RevId 3.0
Allocating 119808 for 576 Exchanges @ 057e0000
Allocating 112904 for LinkQ @ 057c0000 (576 elements)
Allocating 104456 for TachSEST for 512 Exchanges
   cpqfcTS: writing IMQ BASE 37B0000h    PI 37B4000h
   cpqfcTS: SEST 05780000(virt): Wrote base 3780000h @ c2a02140
cpqfcTS: NVRAM read failed
  WARNING! HBA NVRAM WWN read failed - make alias
cpqfcTS: New FC port 000001h WWN: 500508B100092C20 SCSI Chan/Trgt 0/0
scsi1 : Compaq FibreChannel HBA Tachyon Chip/Board Ver??: WWN 
5000061144556677
  on PCI bus 3 device 0x1028 irq 24 IObaseL 0x2000, MEMBASE 0xfe7f0000
PCI bus width 64 bits, bus speed 66 MHz
FCP-SCSI Driver v2.1.1
GBIC detected: NONE!  LPSM 0h Monitor
   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.40
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.40
   Type:   Direct-Access                      ANSI SCSI revision: 02
libata version 1.10 loaded.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdc at scsi1, channel 0, id 0, lun 1
---snap---

>> 3. Aeh.. use... 2.4, use... other OS?
>
> The 2.4 might work. And I might have some patches for you to make it a bit
> less broken. But don't expect too much from it.
>
>> Hope to find a way... and not only kicking a working driver because of not
>> as nice code and to much stack memory.
>
> It was not really working, at least not when I (remotely via IRC) tested it
> last time (some month ago).

I would like to give it a try.
What have been the latest parts of code?

Kind regards,
 	Ingo Flaschberger

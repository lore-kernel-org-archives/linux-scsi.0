From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: mpt2sas: dma error?
Date: Sun, 7 Mar 2010 02:00:43 -0500
Message-ID: <87d699441003062300q48e1c7x4be2a1e5e30e3bb0@mail.gmail.com>
References: <87d699441003062100y1804b007t406adc4dfec99f46@mail.gmail.com>
	 <1267941919.2812.26.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55961 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0CGHAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2010 02:00:44 -0500
Received: by vws9 with SMTP id 9so2355997vws.19
        for <linux-scsi@vger.kernel.org>; Sat, 06 Mar 2010 23:00:43 -0800 (PST)
In-Reply-To: <1267941919.2812.26.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 7, 2010 at 1:05 AM, James Bottomley <James.Bottomley@suse.d=
e> wrote:
> On Sun, 2010-03-07 at 00:00 -0500, Ilia Mirkin wrote:
>> Hi,
>>
>> I have an LSI 9211-4i card (aka SAS2004) with 4 drives attached. No
>> RAID-related setup in the card's BIOS, I'm just using the drives
>> directly. This is with kernel 2.6.33. The card starts up with
>>
>> [ =A0 =A01.714458] mpt2sas version 03.100.03.00 loaded
>> [ =A0 =A01.714757] scsi0 : Fusion MPT SAS Host
>> [ =A0 =A01.715174] =A0 alloc irq_desc for 16 on node -1
>> [ =A0 =A01.715175] =A0 alloc kstat_irqs on node -1
>> [ =A0 =A01.715178] alloc irq_2_iommu on node -1
>> [ =A0 =A01.715184] mpt2sas 0000:05:00.0: PCI INT A -> GSI 16 (level,=
 low) -> IRQ 16
>> [ =A0 =A01.715431] mpt2sas 0000:05:00.0: setting latency timer to 64
>> [ =A0 =A01.715435] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED=
,
>> total mem (12387344 kB)
>> [ =A0 =A01.715939] =A0 alloc irq_desc for 31 on node -1
>> [ =A0 =A01.715941] =A0 alloc kstat_irqs on node -1
>> [ =A0 =A01.715943] alloc irq_2_iommu on node -1
>> [ =A0 =A01.715947] mpt2sas 0000:05:00.0: irq 31 for MSI/MSI-X
>> [ =A0 =A01.715960] mpt2sas0: PCI-MSI-X enabled: IRQ 31
>> [ =A0 =A01.716199] mpt2sas0: iomem(0xfaefc000),
>> mapped(0xffffc90001878000), size(16384)
>> [ =A0 =A01.716643] mpt2sas0: ioport(0xd000), size(256)
>> [ =A0 =A01.788476] mpt2sas0: sending diag reset !!
>> [ =A0 =A02.726738] mpt2sas0: diag reset: SUCCESS
>> [ =A0 =A02.772789] mpt2sas0: Allocated physical memory: size(839 kB)
>> [ =A0 =A02.773034] mpt2sas0: Current Controller Queue Depth(339), Ma=
x
>> Controller Queue Depth(2015)
>> [ =A0 =A02.773481] mpt2sas0: Scatter Gather Elements per IO(128)
>> [ =A0 =A02.831901] mpt2sas0: LSISAS2008: FWVersion(02.00.50.00),
>> ChipRevision(0x02), BiosVersion(07.01.00.00)
>> [ =A0 =A02.832360] mpt2sas0: Protocol=3D(Initiator,Target),
>> Capabilities=3D(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task=
 Set
>> Full,NCQ)
>> [ =A0 =A02.833261] mpt2sas0: sending port enable !!
>> [ =A0 =A04.478515] mpt2sas0: host_add: handle(0x0001),
>> sas_addr(0x500605b0001d5848), phys(8)
>> [ =A0 11.712582] mpt2sas0: port enable: SUCCESS
>>
>> which looks all happy. However it seems that running SMART commands
>> (like smartctl -a, smartmontools 5.39) on the drives attached result=
s
>> in the following, semi-reliably:
>>
>> [ 7069.168433] DRHD: handling fault status reg 2
>> [ 7069.168440] DMAR:[DMA Read] Request device [05:00.0] fault addr e=
0000
>> [ 7069.168442] DMAR:[fault reason 06] PTE Read access is not set
>> [ 7069.815775] mpt2sas0: fault_state(0x2665)!
>> [ 7069.815778] mpt2sas0: sending diag reset !!
>> [ 7070.754176] mpt2sas0: diag reset: SUCCESS
>> [ 7070.823523] mpt2sas0: LSISAS2008: FWVersion(02.00.50.00),
>> ChipRevision(0x02), BiosVersion(07.01.00.00)
>> [ 7070.823526] mpt2sas0: Protocol=3D(Initiator,Target),
>> Capabilities=3D(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task=
 Set
>> Full,NCQ)
>> [ 7070.823818] mpt2sas0: sending port enable !!
>> [ 7079.740367] mpt2sas0: port enable: SUCCESS
>> [ 7079.740446] mpt2sas0: _scsih_search_responding_sas_devices
>> [ 7079.741023] scsi target0:0:0: handle(0x0009),
>> sas_addr(0x4433221100000000), enclosure logical
>> id(0x500605b0001d5848), slot(0)
>> [ 7079.741089] scsi target0:0:1: handle(0x000a),
>> sas_addr(0x4433221101000000), enclosure logical
>> id(0x500605b0001d5848), slot(1)
>> [ 7079.741154] scsi target0:0:2: handle(0x000b),
>> sas_addr(0x4433221103000000), enclosure logical
>> id(0x500605b0001d5848), slot(3)
>> [ 7079.741220] scsi target0:0:3: handle(0x000c),
>> sas_addr(0x4433221102000000), enclosure logical
>> id(0x500605b0001d5848), slot(2)
>> [ 7079.741287] mpt2sas0: _scsih_search_responding_raid_devices
>> [ 7079.741289] mpt2sas0: _scsih_search_responding_expanders
>> [ 7079.741291] mpt2sas0: _base_fault_reset_work: hard reset: success
>>
>> I can just avoid doing any SMART-related stuff on here, but that see=
ms
>> suboptimal. Anything I can do to debug this? Should I turn DMAR off?
>> The fault status reg changes with each attempt (2, 102, 202), but th=
e
>> fault address is always e0000.
>>
>> Actually, it only happened 3 times, and I can't get it to happen a 4=
th
>> time... perhaps it wasn't SMART, or harder to reproduce than I thoug=
ht
>> originally. This still seems bad though.
>
> So this is likely a firmware bug inside the mpt2sas. =A0All of the mp=
t
> cards use a fat firmware model meaning they take in pure SCSI command=
s
> and do the translation to SATA if necessary all within the firmware, =
so
> the first step would be to make sure your card has the latest firmwar=
e.

Just upgraded the FW to 04.00.00.00, and the BIOS to 7.03, same issue.
(These are the latest available on LSI's website.)

>
> Then, there are two methods of wrapping smart commands in SCSI: ATA_1=
2
> and ATA_16. =A0Try getting smartctl to use ATA_12, which is more wide=
ly
> supported, by using the -d sat,12 option to the command.

Hm, well first I did it without the sat,12 option and it had the
issue, and then I added -d sat,12 and again same thing (that's 2 for
2). Was having trouble getting it again for a while, but looks like
just hitting it a few times in a row (i.e. if I run it in quick
succession) triggered 2 more in a row. This time with addr d50e0000;
the reg is still going up by 100 every time in the message. No other
disk i/o was happening during this run, unlike during my initial
e-mail. To be clear, all but the very first error was with smartctl -d
sat,12 -a.

It just seems surprising that retrieving SMART data would be _so_
fragile off of a major manufacturer's controllers... Oh well.

Thanks for taking a look.

  -ilia

P.S. I'm also getting messages like
[  813.174509] sd 0:0:3:0: [sdd] Sense Key : Recovered Error [current]
[descriptor]
[  813.174514] Descriptor sense data with sense descriptors (in hex):
[  813.174517]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
[  813.174526]         00 4f 00 c2 00 50
[  813.174530] sd 0:0:3:0: [sdd] Add. Sense: ATA pass through
information available

on every smartctl command, but I'm fairly sure I've seen this effect
has been discussed before.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

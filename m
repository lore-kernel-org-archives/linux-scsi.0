From: Erich Schubert <erich@debian.org>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Sun, 10 Jan 2016 12:44:27 +0100
Message-ID: <CAGKbab_BpwV-8pFW+pbbzBd1i_QntjzpApZ7oWNQDKHDnoyqRw@mail.gmail.com>
References: <1452353032.1150.4.camel@giantmonkey.de>
	<Pine.LNX.4.44L0.1601091130560.7068-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33475 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbcAJLo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2016 06:44:29 -0500
Received: by mail-lf0-f53.google.com with SMTP id m198so51970384lfm.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jan 2016 03:44:28 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1601091130560.7068-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Ben Hutchings <ben@decadent.org.uk>, "James E. J. Bottomley" <JBottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>

Hi all,
4.4-rc8 does not fix the problem for me.
Anything beyond 4.1.0 remains unable to boot this computer.

Unfortunately, because the error occurs during early early SCSI
initialization, I do not have easy access to the log - no disk, no
network.
It happens during SATA initialization: "scsi_runtime_resume".
So my back trace looks different than Alex in
https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=42;filename=scsi-null-pointer-dereference.log;bug=801925;att=1
but like the one Paul is seeing:
https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=15;filename=20151020_006.jpg;bug=801925;att=3
I will try to do a photo next time, too.

Here is some dmesg output from a successful boot on 4.1.0:
Note there are some ACPI Errors there (but probably not related).
---
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems apst
scsi host0: ahci
scsi host1: ahci
scsi host2: ahci
scsi host3: ahci
scsi host4: ahci
scsi host5: ahci
ata1: SATA max UDMA/133 abar m2048@0xc0728000 port 0xc0728100 irq 30
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata5: DUMMY
ata6: DUMMY
usb 3-1: new high-speed USB device number 2 using ehci-pci
usb 4-1: new high-speed USB device number 2 using ehci-pci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ACPI Error: [GTF0] Namespace lookup failure, AE_NOT_FOUND (20150410/psargs-359)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.PRT0._SDD]
(Node ffff8802458b1608), AE_NOT_FOUND (20150410/psparse-536)
ACPI Error: [GTF0] Namespace lookup failure, AE_NOT_FOUND (20150410/psargs-359)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.PRT0._GTF]
(Node ffff8802458b15e0), AE_NOT_FOUND (20150410/psparse-536)
ata1.00: ATA-8: TOSHIBA THNSNS256GMCP, TA2ABBF0, max UDMA/133
ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ACPI Error: [GTF0] Namespace lookup failure, AE_NOT_FOUND (20150410/psargs-359)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.PRT0._SDD]
(Node ffff8802458b1608), AE_NOT_FOUND (20150410/psparse-536)
ACPI Error: [GTF0] Namespace lookup failure, AE_NOT_FOUND (20150410/psargs-359)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.PRT0._GTF]
(Node ffff8802458b15e0), AE_NOT_FOUND (20150410/psparse-536)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA THNSNS25 BBF0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Starting manual resume from disk
PM: Hibernation image partition 8:6 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
---

On Sat, Jan 9, 2016 at 5:36 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 9 Jan 2016, Paul Menzel wrote:
>
>> Version: 4.4~rc8-1~exp1
>>
>> Dear Alan,
>>
>>
>> Thank you for your help!
>>
>> There were some follow-ups to the bug report [1], but I think you and I
>> were not in CC.
>
> I wasn't.
>
>> >     http://marc.info/?l=linux-scsi&m=144185206825609&w=2
>> >     http://marc.info/?l=linux-scsi&m=144185208525611&w=2
>
>> I can only say, that I am still unable to boot my system with Linux
>> 4.4-rc8 [2]. Are these patches included there?
>
> They are.  I don't see how they could cause a NULL pointer dereference
> in sd_resume(), though.  If you revert them, does the problem go away?
>
> Also, can you add some debugging statements to sd_resume() so we can
> see where the NULL pointer comes from?
>
> Alan Stern
>

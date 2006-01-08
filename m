From: James Bottomley <jejb@steeleye.com>
Subject: Re: [Bug 5847] aic7xxx detection fails on x86_64/SMP (IRQ/ACPI
	problem?)
Date: Sun, 08 Jan 2006 10:08:15 -0600
Message-ID: <1136736495.3377.13.camel@mulgrave>
References: <200601072139.k07Ld5Sj031690@fire-2.osdl.org>
Reply-To: James.Bottomley@steeleye.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3539 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751432AbWAHQLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Jan 2006 11:11:44 -0500
In-Reply-To: <200601072139.k07Ld5Sj031690@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


> Machine was problem free using 2.6.11 (FC3, both i386 and 64bit kernels), 2.6.12
> and 2.6.14 kernels.
> Fails to boot with 2.6.14 and 2.6.15 kernels. Both vanilla and FC4 builds.
> When the machine tries to boot using a 14/15 kernel, the aic7xxx module is
> loaded, but does not detect any device. (No output is printed after the initial
> module load. See attached logs)
> I tried building a 2.6.15 vanilla kernel with all aic7xxxx debug options turned
> on, but saw nothing.
> I tried using both normal and PCI=routeirq both both failed. 


> [root@gilboa-home-dev ~]# lspci -vvxx -s 0a:09.0
> 0a:09.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
>         Subsystem: Adaptec 29160 Ultra160 SCSI Controller
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR+ FastB2B-
>         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 72 (10000ns min, 6250ns max), Cache Line Size 10
>         Interrupt: pin A routed to IRQ 177
>         BIST result: 00
>         Region 0: I/O ports at 3000 [disabled] [size=256]
>         Region 1: Memory at c0500000 (64-bit, non-prefetchable) [size=4K]
>         [virtual] Expansion ROM at 80000000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 05 90 80 00 16 01 b0 02 02 00 00 01 10 48 00 80
> 10: 01 30 00 00 04 00 50 c0 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 05 90 a0 e2
> 30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 28 19

It could be that the driver is being overly fussy and that there's a
mismatch in the PCI ID table.  Someone with better PCI knowledge might
like to comment, but I think that's

vendor 0x9005 (VENDOR_ID_ADAPTEC2)
Device 0x0080 (DEVICE_ID_ADAPTEC2_7892A)
Subvendor 0x0116
Subdevice 0x02b0

The subvendor and subdevice are ones that don't exist in the adaptec PCI
tables; we have four possible 0080 devices, all with either aic or cpq
subvendors, so it's not matching in the subdevice/subvendor.  The
curiosity is that I don't think this code has changed for ages, so I
don't see why it would previously have matched.

James



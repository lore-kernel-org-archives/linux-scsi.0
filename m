From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: LSI 53c1030 speed issue
Date: Thu, 13 Jul 2006 10:13:32 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F6810@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:31742 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932254AbWGMQNr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 12:13:47 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zoltan HERPAI <wigyori@uid0.hu>, linux-scsi@vger.kernel.org

-- Wednesday, July 12, 2006 4:40 PM, Zoltan HERPAI:

> 
> I've recently acquired a Promise VTrak 8110 (3x250Gb in 
> RAID5) with an 
> LSI 53c1030 card. The configuration was tested on a desktop 
> machine (AMD 

Whats linux os and kernel verion is running on your desktop?

> 2500+, standard 32/33 PCI) and reached about 30-40MB/sec. I installed 
> the card into a Sun X4100 (4 CPU, 4Gb mem, 64/133 PCI-X) with the 
> storage behind it, and got surprised that the maximum speed 
> of the card 
> in the box topped at 3-3.5MB/sec, with a load of 5, vmstat shows a 
> constant 50% iowait, filesystem is ext3, some debug info is below. It 
> might be interesting that the box has an LSI SAS1064 
> controller onboard. 

Did you create IR volume?

> Does anyone have an idea what am I doing wrong?
> 
> # lspci -vvv
> 0000:06:01.0 SCSI storage controller: LSI Logic / Symbios 
> Logic 53c1030 
> PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
>        Subsystem: LSI Logic / Symbios Logic: Unknown device 1060
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- 
> DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64 (4000ns min, 1500ns max), Cache Line Size: 
> 0x10 (64 
> bytes)
>        Interrupt: pin A routed to IRQ 209
>        Region 0: I/O ports at c800 [size=256]
>        Region 1: Memory at fe8e0000 (64-bit, 
> non-prefetchable) [size=128K]
>        Region 3: Memory at fe8c0000 (64-bit, 
> non-prefetchable) [size=128K]
>        Expansion ROM at fe400000 [disabled] [size=4M]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Message Signalled Interrupts: 
> 64bit+ Queue=0/0 
> Enable-
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [68] PCI-X non-bridge device.
>                Command: DPERE- ERO- RBC=0 OST=4
>                Status: Bus=6 Dev=1 Func=0 64bit+ 133MHz+ SCD- USC-, 
> DC=simple, DMMRBC=2, DMOST=4, DMCRS=1, RSCEM-
> 

Can you send dmesg boot log?

> 
> # uname -a
> Linux ivymike 2.6.16.16-grsec #1 SMP Tue Jun 27 19:01:53 CEST 2006 
> x86_64 GNU/Linux

Can you try with 2.6.17 kernel?  The -17 kernel is using spi transport
layer,
which is using generic domain validation.

Eric Moore

From: Zoltan HERPAI <wigyori@uid0.hu>
Subject: LSI 53c1030 speed issue
Date: Thu, 13 Jul 2006 00:40:06 +0200
Message-ID: <44B57A46.80804@uid0.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postahivatal.bpcl.broadband.hu ([195.184.181.19]:19943 "EHLO
	postahivatal.bpcl.broadband.hu") by vger.kernel.org with ESMTP
	id S932353AbWGLWkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 18:40:08 -0400
Received: from [10.1.1.20] (dsl195-38-112-166.pool.tvnet.hu [195.38.112.166])
	by postahivatal.bpcl.broadband.hu (Postfix) with ESMTP id 8738F200389
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2006 00:40:09 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've recently acquired a Promise VTrak 8110 (3x250Gb in RAID5) with an 
LSI 53c1030 card. The configuration was tested on a desktop machine (AMD 
2500+, standard 32/33 PCI) and reached about 30-40MB/sec. I installed 
the card into a Sun X4100 (4 CPU, 4Gb mem, 64/133 PCI-X) with the 
storage behind it, and got surprised that the maximum speed of the card 
in the box topped at 3-3.5MB/sec, with a load of 5, vmstat shows a 
constant 50% iowait, filesystem is ext3, some debug info is below. It 
might be interesting that the box has an LSI SAS1064 controller onboard. 
Does anyone have an idea what am I doing wrong?

# lspci -vvv
0000:06:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
       Subsystem: LSI Logic / Symbios Logic: Unknown device 1060
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
       Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 64 (4000ns min, 1500ns max), Cache Line Size: 0x10 (64 
bytes)
       Interrupt: pin A routed to IRQ 209
       Region 0: I/O ports at c800 [size=256]
       Region 1: Memory at fe8e0000 (64-bit, non-prefetchable) [size=128K]
       Region 3: Memory at fe8c0000 (64-bit, non-prefetchable) [size=128K]
       Expansion ROM at fe400000 [disabled] [size=4M]
       Capabilities: [50] Power Management version 2
               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
       Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable-
               Address: 0000000000000000  Data: 0000
       Capabilities: [68] PCI-X non-bridge device.
               Command: DPERE- ERO- RBC=0 OST=4
               Status: Bus=6 Dev=1 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=2, DMOST=4, DMCRS=1, RSCEM-


# uname -a
Linux ivymike 2.6.16.16-grsec #1 SMP Tue Jun 27 19:01:53 CEST 2006 
x86_64 GNU/Linux

# cat /proc/scsi/mptspi/1
ioc1: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222

Regards,
-w-

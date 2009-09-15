From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Tue, 15 Sep 2009 13:07:45 GMT
Message-ID: <200909151307.n8FD7jBC002000@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57354 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZIONHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 09:07:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8FD7jQI002001
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 13:07:45 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #8 from g.giorgetti@teamsystem.com  2009-09-15 13:07:42 ---
All right, we've just rebooted the server and tried with the "noioapicquirk"
param and everything is fine.

Looking at the patch you put up in your reply I can see some code for amd_813x
(quirk_disable_amd_813x_boot_interrupt and the definition for AMD_813X_REV_B2)

So just in case you need it, I'm pasting the lspci for the AMD-8131 we have.
Please let me know if you need anything else.

Thank you,
 Gabriele



40:0f.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
    Latency: 150
    Bus: primary=40, secondary=41, subordinate=41, sec-latency=96
    I/O behind bridge: 00007000-00007fff
    Memory behind bridge: e1f00000-e1ffffff
    Prefetchable memory behind bridge: 00000000e0200000-00000000e02fffff
    Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
    BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
    Capabilities: [a0] PCI-X bridge device
        Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
        Status: Dev=40:0f.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
        Upstream: Capacity=14 CommitmentLimit=65535
        Downstream: Capacity=2 CommitmentLimit=65535
    Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration
    Capabilities: [c0] HyperTransport: Slave or Primary Interface
        !!! Possibly incomplete decoding
        Command: BaseUnitID=15 UnitCnt=2 MastHost- DefDir-
        Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
        Link Config 0: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
        Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
        Link Config 1: MLWI=8bit MLWO=8bit LWI=N/C LWO=N/C
        Revision ID: 1.02

40:0f.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
(prog-if 10 [IO-APIC])
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
    Latency: 0

40:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
    Latency: 150
    Bus: primary=40, secondary=42, subordinate=42, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
    Capabilities: [a0] PCI-X bridge device
        Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=conv
        Status: Dev=40:10.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
        Upstream: Capacity=14 CommitmentLimit=65535
        Downstream: Capacity=2 CommitmentLimit=65535
    Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration

40:10.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
(prog-if 10 [IO-APIC])
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
    Latency: 0

41:01.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
    Subsystem: Adaptec Unknown device 0044
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
    Latency: 148 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: I/O ports at 7000 [disabled] [size=256]
    Region 1: Memory at e1f80000 (64-bit, non-prefetchable) [size=8K]
    Region 3: I/O ports at 7800 [disabled] [size=256]
    [virtual] Expansion ROM at e0200000 [disabled] [size=512K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [94] PCI-X non-bridge device
        Command: DPERE- ERO- RBC=512 OST=3
        Status: Dev=41:01.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512
DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

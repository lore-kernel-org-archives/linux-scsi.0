From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197877] arcmsr fails to initialize Areca ARC-1110/ARC-1120 on
 some systems
Date: Sat, 18 Nov 2017 12:03:31 +0000
Message-ID: <bug-197877-11613-8tTPuAUBL8@https.bugzilla.kernel.org/>
References: <bug-197877-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58034 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161968AbdKRMDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Nov 2017 07:03:32 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F13112A606
        for <linux-scsi@vger.kernel.org>; Sat, 18 Nov 2017 12:03:31 +0000 (UTC)
In-Reply-To: <bug-197877-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197877

--- Comment #5 from kr@sognnes.no ---
Interrupts are handled differently by the more recent driver. From a working
system running kernel 3.17.8:

--- /proc/interrupts ---
            CPU0       CPU1       CPU2       CPU3
   0:        133          0          0          0   IO-APIC-edge      timer
   1:          1         11          0          0   IO-APIC-edge      i8042
   6:          0          3          0          0   IO-APIC-edge      floppy
   7:          0          0          0          0   IO-APIC-edge      parport0
   8:          0          1          0          0   IO-APIC-edge      rtc0
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  11:          0          0          0          0   IO-APIC-fasteoi  
ohci_hcd:usb1
  12:          0        165          0          0   IO-APIC-edge      i8042
  14:          1        254          0          0   IO-APIC-edge     
pata_serverworks
  15:          0          0          0          0   IO-APIC-edge     
pata_serverworks
  16:          0       5658          0          0   IO-APIC   10-fasteoi  
sata_sil
  17:          0          0          0          0   IO-APIC    1-fasteoi  
hpilo
  18:          0        247          0          0   IO-APIC   13-fasteoi   eth0
  19:          0         35          0          0   IO-APIC    8-fasteoi  
arcmsr
 NMI:          0          0          0          0   Non-maskable interrupts
 LOC:       8967       8566      11465       8375   Local timer interrupts
 SPU:          0          0          0          0   Spurious interrupts
 PMI:          0          0          0          0   Performance monitoring
interrupts
 IWI:          0          1          0          0   IRQ work interrupts
 RTR:          1          0          0          0   APIC ICR read retries
 RES:       3182       1918       6329       2498   Rescheduling interrupts
 CAL:        992         16         11       1265   Function call interrupts
 TLB:        134        139        181        189   TLB shootdowns
 TRM:          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0   Machine check exceptions
 MCP:          1          1          1          1   Machine check polls
 THR:          0          0          0          0   Hypervisor callback
interrupts
 ERR:          0
 MIS:          0
------------------------

Unloading arcmsr v1.20.00.15 and loading v1.40.0X.02 instead results in this
change:

--- /proc/interrupts ---
  20:          0          0          0          0   PCI-MSI-edge      arcmsr
------------------------

Here's the output from lspci. On a working system:

--- lspci -vvv with driver v1.20.00.15 ---
07:0e.0 RAID bus controller: Areca Technology Corp. ARC-1120 8-Port PCI-X to
SATA RAID Controller
        Subsystem: Areca Technology Corp. ARC-1120 8-Port PCI-X to SATA RAID
Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64 (32000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        NUMA node: 0
        Region 0: Memory at f7ff0000 (32-bit, non-prefetchable) [size=4K]
        Region 2: Memory at f7800000 (32-bit, prefetchable) [size=4M]
        [virtual] Expansion ROM at f7f00000 [disabled] [size=64K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41a1
        Capabilities: [e0] PCI-X non-bridge device
                Command: DPERE+ ERO- RBC=1024 OST=8
                Status: Dev=07:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge
DMMRBC=1024 DMOST=4 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: arcmsr
        Kernel modules: arcmsr
------------------------------------------

On the same system after loading the most recent arcmsr driver:

--- lspci -vvv with driver v1.40.0X.02 ---
07:0e.0 RAID bus controller: Areca Technology Corp. ARC-1120 8-Port PCI-X to
SATA RAID Controller
        Subsystem: Areca Technology Corp. ARC-1120 8-Port PCI-X to SATA RAID
Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64 (32000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        NUMA node: 0
        Region 0: Memory at f7ff0000 (32-bit, non-prefetchable) [size=4K]
        Region 2: Memory at f7800000 (32-bit, prefetchable) [size=4M]
        [virtual] Expansion ROM at f7f00000 [disabled] [size=64K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/2 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41a1
        Capabilities: [e0] PCI-X non-bridge device
                Command: DPERE+ ERO- RBC=1024 OST=8
                Status: Dev=07:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge
DMMRBC=1024 DMOST=4 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: arcmsr
        Kernel modules: arcmsr
------------------------------------------

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

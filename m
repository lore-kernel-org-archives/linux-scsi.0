From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Sat, 12 Jul 2014 11:29:20 -0600
Message-ID: <CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41756 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaGLR3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jul 2014 13:29:41 -0400
Received: by mail-qc0-f178.google.com with SMTP id x3so164445qcv.23
        for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 10:29:40 -0700 (PDT)
In-Reply-To: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>

[+cc Matthew]

On Sat, Jul 12, 2014 at 5:56 AM, Robin H. Johnson <robbat2@gentoo.org> wrote:
> TL;DR LSI2208 card faults out and does not bring up drives in Linux. In BIOS works fine.
> Driver has no debug interfaces visible in code for early startup.
>
> Hardware: Supermicro SSG-6027R-E1R12T
> http://www.supermicro.com/products/system/2U/6027/SSG-6027R-E1R12T.cfm
> Motherboard is X9DRH-7TF
> Contains an LSI2208 controller (megaraid_sas), which is this bug.
>
> I also have a LSI2008 (mp2sas) card in a PCIe slot for accessing an external
> tape library, that works fine [it's in CPU2-SLOT6, PCIe v3 x8].
>
> 01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt] [1000:005b] (rev 05)
> 82:00.0 Serial Attached SCSI controller [0107]: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] [1000:0072] (rev 03)
> (full lspci output further down)
>
> Whenever the megaraid_sas module loads, it fails out :-(.
> [   14.188561] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
> [   14.188577] megasas: 0x1000:0x005b:0x15d9:0x0690: bus 1:slot 0:func 0
> [   14.188584] megaraid_sas 0000:01:00.0: enabling device (0000 -> 0002)
> [   14.188735] megasas: Waiting for FW to come to ready state
> [   14.193999] megasas: FW in FAULT state!!
> [   14.194003] megaraid_sas 0000:01:00.0: megasas: FW restarted successfully from megasas_init_fw!
> [   44.210482] megasas: Waiting for FW to come to ready state
> [   44.210484] megasas: FW in FAULT state!!
>
> During boots of the system, it DOES cleanly probe the drives (6x ST32000641AS),
> and has them assembled into RAID6.
>
> The problem occurs in all of these kernels:
> Ubuntu 3.13.11.2 (3.13.0-30.55-generic)
> Vanilla 3.14.5
> Ubuntu 3.16.0-rc4 (3.16.0-3.8~14.10-generic sic) from ppa:canonical-kernel-team/ppa
> (quite willing to build custom kernels for testing, I just had these on hand
> for quick reboots).
>
> If you Google around for the problem, there were claims that it's related to
> bug BKO63661 (https://bugzilla.kernel.org/show_bug.cgi?id=63661), amongst other things, suggesting the following workarounds:
> pci=conf1
> pcie_aspm=off
> disable_msi=1
> None of which have any affect.

Thanks for the report, Robin.

https://bugzilla.kernel.org/show_bug.cgi?id=63661 bisected the problem
to 3c076351c402 ("PCI: Rework ASPM disable code"), which appeared in
v3.3.  For starters, can you verify that, e.g., by building
69166fbf02c7 (the parent of 3c076351c402) to make sure that it works,
and building 3c076351c402 itself to make sure it fails?

Assuming that's the case, please attach the complete dmesg and "lspci
-vvxxx" output for both kernels to the bugzilla.  ASPM is a feature
that is configured on both ends of a PCIe link, so I want to see the
lspci info for the whole system, not just the SAS adapters.

It's not practical to revert 3c076351c402 now, so I'd also like to see
the same information for the newest possible kernel (if this is
possible; I'm not clear on whether you can boot your system or not) so
we can figure out what needs to be changed.

Bjorn

> # lspci  -nn -d 1000: -vvxxx
> 01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt] [1000:005b] (rev 05)
>         Subsystem: Super Micro Computer Inc LSI MegaRAID ROMB [15d9:0690]
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 16
>         Region 0: I/O ports at 8000 [disabled] [size=256]
>         Region 1: Memory at dfe60000 (64-bit, non-prefetchable) [size=16K]
>         Region 3: Memory at dfe00000 (64-bit, non-prefetchable) [size=256K]
>         Expansion ROM at dfe40000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [68] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s, Exit Latency L0s <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Supported
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
>                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+, EqualizationPhase1+
>                          EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest+
>         Capabilities: [d0] Vital Product Data
> pcilib: sysfs_read_vpd: read failed: Connection timed out
>                 Not readable
>         Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [c0] MSI-X: Enable- Count=16 Masked-
>                 Vector table: BAR=1 offset=00002000
>                 PBA: BAR=1 offset=00003000
> 00: 00 10 5b 00 02 00 10 00 05 00 04 01 10 00 00 00
> 10: 01 80 00 00 04 00 e6 df 00 00 00 00 04 00 e0 df
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 90 06
> 30: 00 00 e4 df 50 00 00 00 00 00 00 00 0b 01 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 01 68 03 06 08 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 01 00 00 10 d0 02 00 25 80 00 10
> 70: 20 28 00 00 83 04 40 00 40 00 83 10 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 16 00 00 00
> 90: 00 00 00 00 0e 00 00 00 03 00 3e 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 05 c0 80 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 11 00 0f 00 01 20 00 00 01 30 00 00 00 00 00 00
> d0: 03 a8 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> 82:00.0 Serial Attached SCSI controller [0107]: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] [1000:0072] (rev 03)
>         Subsystem: Dell 6Gbps SAS HBA Adapter [1028:1f1c]
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 11
>         Region 0: I/O ports at f000 [disabled] [size=256]
>         Region 1: Memory at fbe40000 (64-bit, non-prefetchable) [disabled] [size=64K]
>         Region 3: Memory at fbe00000 (64-bit, non-prefetchable) [disabled] [size=256K]
>         Expansion ROM at fbd00000 [disabled] [size=1M]
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [68] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Exit Latency L0s <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Supported
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>         Capabilities: [d0] Vital Product Data
>                 Unknown small resource type 00, will not decode more.
>         Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [c0] MSI-X: Enable- Count=15 Masked-
>                 Vector table: BAR=1 offset=0000e000
>                 PBA: BAR=1 offset=0000f800
> 00: 00 10 72 00 00 00 10 00 03 00 07 01 10 00 00 00
> 10: 01 f0 00 00 04 00 e4 fb 00 00 00 00 04 00 e0 fb
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 1c 1f
> 30: 00 00 d0 fb 50 00 00 00 00 00 00 00 0b 01 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 01 68 03 06 08 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 82 00 00 10 d0 02 00 25 80 00 10
> 70: 20 28 09 00 82 04 00 00 40 00 82 10 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 16 00 00 00
> 90: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 05 c0 80 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 11 00 0e 00 01 e0 00 00 01 f8 00 00 00 00 00 00
> d0: 03 a8 00 80 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
>
> --
> Robin Hugh Johnson
> Gentoo Linux: Developer, Infrastructure Lead
> E-Mail     : robbat2@gentoo.org
> GnuPG FP   : 11ACBA4F 4778E3F6 E4EDF38E B27B944E 34884E85

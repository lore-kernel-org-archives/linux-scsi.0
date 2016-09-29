From: Florian Fainelli <f.fainelli@gmail.com>
Subject: mpt2sas_cm0: unable to map adapter memory! or resource not found
Date: Thu, 29 Sep 2016 14:02:40 -0700
Message-ID: <be712b49-a000-4f6c-d332-146b6b605569@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33373 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933330AbcI2VCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 17:02:43 -0400
Received: by mail-pa0-f65.google.com with SMTP id oz2so3867329pac.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2016 14:02:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPT-FusionLinux.pdl@broadcom.com, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sathya.prakash@broadcom.com, linux-scsi@vger.kernel.org

Hi all,

Trying to get a LSI SAS 9200-8e adapter to work on an old Dell SC1435
server, mpt3sas returns the following:

[ 1442.404496] mpt3sas version 12.100.00.00 loaded
[ 1442.408820] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED,
total mem (33011820 kB)
[ 1442.408829] mpt2sas_cm0: unable to map adapter memory!  or resource
not found
[ 1442.415740] mpt2sas_cm0: failure at
/build/linux-R0TiM8/linux-4.4.0/drivers/scsi/mpt3sas/mpt3sas_scsih.c:8800/_scsih_probe()!

This is Ubuntu 16.04, but 4.8 returns essentially the same error.

Here is the verbose lspci output for this adapter, the Region 1/3
ignored seems a little worrying here, but I am not sure what I could try
to force the BIOS/Linux to try to re-assign these regions differently?

Thanks!

06:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic
SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
        Subsystem: LSI Logic / Symbios Logic SAS2008 PCI-Express
Fusion-MPT SAS-2 [Falcon]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at dc00 [size=256]
        Region 1: Memory at <ignored> (64-bit, non-prefetchable)
        Region 3: Memory at <ignored> (64-bit, non-prefetchable)
        Expansion ROM at <ignored> [disabled]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
FLReset-
                        MaxPayload 512 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Exit
Latency L0s <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+,
LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [d0] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [c0] MSI-X: Enable- Count=15 Masked-
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003800
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+
UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [138 v1] Power Budgeting <?>
        Capabilities: [150 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration-, Interrupt Message Number: 000
                IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy-
                IOVSta: Migration-
                Initial VFs: 16, Total VFs: 16, Number of VFs: 0,
Function Dependency Link: 00
                VF offset: 1, stride: 1, Device ID: 0072
                Supported Page Size: 00000553, System Page Size: 00000001
                Region 0: Memory at 00000000efe80000 (64-bit,
non-prefetchable)
                Region 2: Memory at 0000000000000000 (64-bit,
non-prefetchable)
                VF Migration: offset: 00000000, BIR: 0
        Capabilities: [190 v1] Alternative Routing-ID Interpretation (ARI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Kernel modules: mpt3sas

-- 
Florian

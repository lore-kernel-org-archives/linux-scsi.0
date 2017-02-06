From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 6 Feb 2017 17:32:48 +0530
Message-ID: <CAK=zhgp9K+JKAb8RrR_1vNcf-Y0XoR7174nb5YBcnZdCbd7rAw@mail.gmail.com>
References: <20161228110524.7516-1-ojab@ojab.ru> <73a398a7-bde4-d337-0954-bc0f8d2f3752@ojab.ru>
 <dd9f95e5-0812-521b-e060-f0fdf7283348@ojab.ru> <13e199bd-400f-d2e3-7896-d45c07bede51@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33992 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBFMCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 07:02:50 -0500
Received: by mail-qk0-f176.google.com with SMTP id s186so52228697qkb.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 04:02:49 -0800 (PST)
In-Reply-To: <13e199bd-400f-d2e3-7896-d45c07bede51@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ojab <ojab@ojab.ru>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Ojab,

Can I get output of 'lspci -vvv -s' for LSI SAS2 card?

On my Supermicro system, I have enabled ASPM in system BIOS but still
in lspci output I see this ASPM was disabled for my SAS2 HBA card
which has Phase19 firmware (i.e. 19.00.00.00) as shown below,

# lspci -vvv -s 83:00.0
83:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic
SAS2308 PCI-Express Fusion-MPT SAS-2 (rev 05)
    Subsystem: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT SAS-2
    Physical Slot: 1-1
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 40
    Region 0: I/O ports at f000 [size=256]
    Region 1: Memory at fbe40000 (64-bit, non-prefetchable) [size=64K]
    Region 3: Memory at fbe00000 (64-bit, non-prefetchable) [size=256K]
    Expansion ROM at fbd00000 [disabled] [size=1M]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [68] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 4096 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 8GT/s, Width x8, ASPM L0s, Exit
Latency L0s <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete+, EqualizationPhase1+
             EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest+
    Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
        Not readable
    Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [c0] MSI-X: Enable+ Count=16 Masked-
        Vector table: BAR=1 offset=0000e000
        PBA: BAR=1 offset=0000f000
    Capabilities: [100 v2] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [1e0 v1] #19
    Capabilities: [1c0 v1] Power Budgeting <?>
    Capabilities: [190 v1] #16
    Capabilities: [148 v1] Alternative Routing-ID Interpretation (ARI)
        ARICap:    MFVC- ACS-, Next Function: 0
        ARICtl:    MFVC- ACS-, Function Group: 0
    Kernel driver in use: mpt3sas
    Kernel modules: mpt3sas

So, Can you also try once with Phase19 firmware.

Thanks,
Sreekanth

On Mon, Feb 6, 2017 at 2:22 PM, ojab <ojab@ojab.ru> wrote:
> On 2017/01/30 10:58, ojab wrote:
>>
>> On 2017/01/23 15:59, ojab wrote:
>>>
>>> On 2016/12/28 11:05, ojab wrote:
>>>>
>>>> MPI2 controllers sometimes got lost (i. e. disappears from
>>>> /sys/bus/pci/devices) if ASMP is enabled.
>>>>
>>>> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
>>>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644
>>>
>>>
>>> Can I haz Reviewed-by?
>>>
>>
>> ping?
>>
>
> Humble ping.
>
> //wbr ojab

Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1729DC33CA7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 02:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66C72082E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 02:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1LYUC98"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbgALCVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 21:21:24 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:40559 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731967AbgALCVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 21:21:23 -0500
Received: by mail-qt1-f172.google.com with SMTP id v25so5937523qto.7
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jan 2020 18:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=CwBuMWmA5zNB852L3aL/uBATrixd+MFxSmCnro9Dxms=;
        b=T1LYUC98vFGXiRKePt4xUC9MeEabzvMqRgQYioB3iQiDvy3qCdiV0Sv7Ocx2wKn3Jd
         Am/ewF3Y9jJcJX2T+sphipJVaqPmqD4G9BvCmK9lbPDoAQpUCQSnrroqWwlBdJW0Hihd
         Em8bi5R8VMzc/KwtMDXbVw1gHyCvWmwzBZOIPV+zZKONuqKvTSSh64enPOAWd7LM6wRm
         hNAyA1wjTsvCR456Xq/G5qsCInJr/kTA5948xGSaairSyZ6WhGiiDombkR75+7FBzH/J
         XwRRmR7bS6gcGW5Z/DvTwSamNeQhgpG5gtfIzm0k51Uz9w1PK7S1qFxOVn843lUncj3h
         Yn4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CwBuMWmA5zNB852L3aL/uBATrixd+MFxSmCnro9Dxms=;
        b=RFTyZ4Tix/fCdZWcijs1A/4eXWpKx9YKZzXq3jUpIsCSrf/NB3v3FlXK3rrWNzfofN
         su+5GLz86F/ACXCGAEzYLMLo/cBsIAhKdCksTW+ovzfQBXKlohMCNZAvWkBjY9NSSkJF
         QOazUd6BNmFrarHHYrmOoZB4OANbbm3fIjtv12uEhGEXqmuERXhHp1slvKo7qHJzfzN4
         v70/jJlNU9MA3ksUNYx+DBsEvQLlQKtxRKUuKeqV5E05FX5cP6jb2m5bXQnkA5idowBk
         5m+OdAMghn2FwSOAob3B7Ex1knXLYW2W+zJjQh+Re1A/BxBSJAJQZ6XOE/tT0RPbaHJy
         FUYA==
X-Gm-Message-State: APjAAAXjynwpfjEA9Z3dmSQ9kfg6mcQvBQ9ebOBGh5AZZdGWS9i1k8xx
        5CH9UykIfNLPQ95i9pCpSjzyhwgr3rQs9Ln6ecxSIC+2Gbw=
X-Google-Smtp-Source: APXvYqzHCh7/UdAagMrF6Ydvo3LDY5P4n71UiaQiHidRByC6znQLwBhNdObepY6JMFioiteeGrDdYWI5iLj+561rgW0=
X-Received: by 2002:ac8:6611:: with SMTP id c17mr8921366qtp.170.1578795681885;
 Sat, 11 Jan 2020 18:21:21 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date:   Sun, 12 Jan 2020 04:21:10 +0200
Message-ID: <CAOE4rSyVSfRRc9vFK_EM9SJMPoZD6PAmiA+2LqyFx2C26ht-6A@mail.gmail.com>
Subject: How to reset HBA when using libsas/mvsas
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

I've HighPoint RocketRAID 2760A which uses mvsas driver.
When some error happens then disk becomes inaccessible and
to get it usable again currently I know only 2 ways,
either physically pull it out and put back in or reboot whole system.
This is pretty annoying so I want to just reset HBA to simulate that,
but I don't know how to do that.

I have tried:
$ echo 1 > /sys/block/sdf/device/delete
$ echo '- - -' > /sys/class/scsi_host/host0/scan

but it doesn't work as it doesn't detect any new drives.


Some more info see below

$ lspci -vv

44:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 2760 (rev c2)
        Subsystem: HighPoint Technologies, Inc. Device 0000
        Physical Slot: 117
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at 82240000 (64-bit, non-prefetchable) [size=128K]
        Region 2: Memory at 82200000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at 82260000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency
L0s <1us, L1 <8us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+
FLReset- SlotPowerLimit 25.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 512 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM not supported
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s (ok), Width x8 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR-, OBFF Not Supported
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+
ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Kernel driver in use: mvsas
        Kernel modules: mvsas

45:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 2760 (rev c2)
        Subsystem: HighPoint Technologies, Inc. Device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 47
        Region 0: Memory at 82140000 (64-bit, non-prefetchable) [size=128K]
        Region 2: Memory at 82100000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at 82160000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency
L0s <1us, L1 <8us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+
FLReset- SlotPowerLimit 25.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 512 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM not supported
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s (ok), Width x8 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR-, OBFF Not Supported
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+
ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Kernel driver in use: mvsas
        Kernel modules: mvsas

46:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 2760 (rev c2)
        Subsystem: HighPoint Technologies, Inc. Device 0000
        Physical Slot: 121
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at 82040000 (64-bit, non-prefetchable) [size=128K]
        Region 2: Memory at 82000000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at 82060000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency
L0s <1us, L1 <8us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+
FLReset- SlotPowerLimit 25.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 512 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM not supported
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s (ok), Width x8 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR-, OBFF Not Supported
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+
ECRCGenEn- ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Kernel driver in use: mvsas
        Kernel modules: mvsas


$ dmesg

[ 4609.661372] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 4609.661375] sas: trying to find task 0x00000000fba080c0
[ 4609.661375] sas: sas_scsi_find_task: aborting task 0x00000000fba080c0
[ 4609.661377] drivers/scsi/mvsas/mv_sas.c 1526:mvs_abort_task()
mvi=00000000f55c98e2 task=00000000fba080c0 slot=00000000928be8ed
slot_idx=x0
[ 4609.661378] sas: sas_scsi_find_task: task 0x00000000fba080c0 is aborted
[ 4609.661378] sas: sas_eh_handle_sas_errors: task 0x00000000fba080c0 is aborted
[ 4609.661380] sas: ata15: end_device-0:4: cmd error handler
[ 4609.661390] sas: ata11: end_device-0:0: dev error handler
[ 4609.661398] sas: ata12: end_device-0:1: dev error handler
[ 4609.661401] sas: ata13: end_device-0:2: dev error handler
[ 4609.661404] sas: ata14: end_device-0:3: dev error handler
[ 4609.661406] sas: ata15: end_device-0:4: dev error handler
[ 4609.661409] ata15.00: exception Emask 0x0 SAct 0x200000 SErr 0x0
action 0x6 frozen
[ 4609.661411] ata15.00: failed command: READ FPDMA QUEUED
[ 4609.661414] ata15.00: cmd 60/08:00:00:a3:50/00:00:5d:01:00/40 tag
21 ncq dma 4096 in
                        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[ 4609.661416] sas: ata16: end_device-0:5: dev error handler
[ 4609.661418] ata15.00: status: { DRDY }
[ 4609.661419] sas: ata17: end_device-0:6: dev error handler
[ 4609.661422] sas: ata18: end_device-0:7: dev error handler
[ 4609.661423] ata15: hard resetting link
[ 4609.671596] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4609.671602] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000081
[ 4609.707530] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4609.707535] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00010000
[ 4609.707538] drivers/scsi/mvsas/mv_sas.c 2012:notify plug in on phy[0]
[ 4609.727552] drivers/scsi/mvsas/mv_94xx.c 869:get all reg link rate
is 0x122000
[ 4609.727555] drivers/scsi/mvsas/mv_94xx.c 874:get link rate is 10
[ 4609.847627] drivers/scsi/mvsas/mv_sas.c 1066:phy 4 attach dev info is 20001
[ 4609.847631] drivers/scsi/mvsas/mv_sas.c 1068:phy 4 attach sas addr is 4
[ 4609.847634] drivers/scsi/mvsas/mv_sas.c 261:phy 4 byte dmaded.
[ 4609.847788] sas: sas_form_port: phy0 belongs to port4 already(1)!
[ 4611.954597] drivers/scsi/mvsas/mv_sas.c 1417:mvs_I_T_nexus_reset
for device[0]:rc= 0
[ 4612.111285] drivers/scsi/mvsas/mv_sas.c 1757:port 4 slot 0 rx_desc
30000 has error info8000000080000000.
[ 4617.287750] ata15.00: qc timeout (cmd 0x27)
[ 4617.287754] drivers/scsi/mvsas/mv_sas.c 1526:mvs_abort_task()
mvi=00000000f55c98e2 task=000000005325a7e3 slot=00000000928be8ed
slot_idx=x0
[ 4617.287757] ata15.00: failed to read native max address (err_mask=0x4)
[ 4617.287759] ata15.00: HPA support seems broken, skipping HPA handling
[ 4617.287760] ata15.00: revalidation failed (errno=-5)
[ 4617.287763] ata15: hard resetting link
[ 4617.297791] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00000000.
[ 4617.297792] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000001
[ 4617.297829] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4617.297830] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000081
[ 4617.318544] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4617.318547] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00010000
[ 4617.318549] drivers/scsi/mvsas/mv_sas.c 2012:notify plug in on phy[0]
[ 4617.338563] drivers/scsi/mvsas/mv_94xx.c 869:get all reg link rate
is 0x122000
[ 4617.338565] drivers/scsi/mvsas/mv_94xx.c 874:get link rate is 10
[ 4617.458637] drivers/scsi/mvsas/mv_sas.c 1066:phy 4 attach dev info is 20001
[ 4617.458639] drivers/scsi/mvsas/mv_sas.c 1068:phy 4 attach sas addr is 4
[ 4617.458642] drivers/scsi/mvsas/mv_sas.c 261:phy 4 byte dmaded.
[ 4617.458665] sas: sas_form_port: phy0 belongs to port4 already(1)!
[ 4619.634341] drivers/scsi/mvsas/mv_sas.c 1417:mvs_I_T_nexus_reset
for device[0]:rc= 0
[ 4619.790900] drivers/scsi/mvsas/mv_sas.c 1757:port 4 slot 0 rx_desc
30000 has error info8000000080000000.
[ 4636.487111] ata15.00: qc timeout (cmd 0xef)
[ 4636.487114] drivers/scsi/mvsas/mv_sas.c 1526:mvs_abort_task()
mvi=00000000f55c98e2 task=0000000060facb2f slot=00000000928be8ed
slot_idx=x0
[ 4636.487116] ata15.00: failed to set xfermode (err_mask=0x4)
[ 4636.487118] ata15.00: limiting speed to UDMA/133:PIO3
[ 4636.487120] ata15: hard resetting link
[ 4636.497144] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00000000.
[ 4636.497144] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000001
[ 4636.497185] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4636.497185] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000081
[ 4636.514969] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4636.514972] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00010000
[ 4636.514974] drivers/scsi/mvsas/mv_sas.c 2012:notify plug in on phy[0]
[ 4636.534988] drivers/scsi/mvsas/mv_94xx.c 869:get all reg link rate
is 0x122000
[ 4636.534990] drivers/scsi/mvsas/mv_94xx.c 874:get link rate is 10
[ 4636.655062] drivers/scsi/mvsas/mv_sas.c 1066:phy 4 attach dev info is 20001
[ 4636.655065] drivers/scsi/mvsas/mv_sas.c 1068:phy 4 attach sas addr is 4
[ 4636.655069] drivers/scsi/mvsas/mv_sas.c 261:phy 4 byte dmaded.
[ 4636.655092] sas: sas_form_port: phy0 belongs to port4 already(1)!
[ 4638.833687] drivers/scsi/mvsas/mv_sas.c 1417:mvs_I_T_nexus_reset
for device[0]:rc= 0
[ 4638.990261] drivers/scsi/mvsas/mv_sas.c 1757:port 4 slot 0 rx_desc
30000 has error info8000000080000000.
[ 4655.259921] ata15.00: qc timeout (cmd 0xef)
[ 4655.259924] drivers/scsi/mvsas/mv_sas.c 1526:mvs_abort_task()
mvi=00000000f55c98e2 task=00000000cb52cd96 slot=00000000928be8ed
slot_idx=x0
[ 4655.259926] ata15.00: failed to set xfermode (err_mask=0x4)
[ 4655.259928] ata15.00: disabled
[ 4655.269958] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00000000.
[ 4655.269961] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000001
[ 4655.269998] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4655.270000] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00000081
[ 4655.287760] drivers/scsi/mvsas/mv_sas.c 1961:phy 4 ctrl sts=0x00122000.
[ 4655.287762] drivers/scsi/mvsas/mv_sas.c 1963:phy 4 irq sts = 0x00010000
[ 4655.287764] drivers/scsi/mvsas/mv_sas.c 2012:notify plug in on phy[0]
[ 4655.307778] drivers/scsi/mvsas/mv_94xx.c 869:get all reg link rate
is 0x122000
[ 4655.307780] drivers/scsi/mvsas/mv_94xx.c 874:get link rate is 10
[ 4655.427849] drivers/scsi/mvsas/mv_sas.c 1066:phy 4 attach dev info is 20001
[ 4655.427850] drivers/scsi/mvsas/mv_sas.c 1068:phy 4 attach sas addr is 4
[ 4655.427854] drivers/scsi/mvsas/mv_sas.c 261:phy 4 byte dmaded.
[ 4655.427874] sas: sas_form_port: phy0 belongs to port4 already(1)!
[ 4657.606419] drivers/scsi/mvsas/mv_sas.c 1417:mvs_I_T_nexus_reset
for device[0]:rc= 0
[ 4657.762940] sd 0:0:4:0: [sdf] tag#45 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 4657.762942] sd 0:0:4:0: [sdf] tag#45 Sense Key : Not Ready [current]
[ 4657.762944] sd 0:0:4:0: [sdf] tag#45 Add. Sense: Logical unit not
ready, hard reset required
[ 4657.762945] sd 0:0:4:0: [sdf] tag#45 CDB: Read(16) 88 00 00 00 00
01 5d 50 a3 00 00 00 00 08 00 00
[ 4657.762947] blk_update_request: I/O error, dev sdf, sector
5860532992 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[ 4657.762965] ata15: EH complete
[ 4657.763115] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 1 tries: 1
[ 4657.763154] sd 0:0:4:0: [sdf] tag#54 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763158] sd 0:0:4:0: [sdf] tag#54 CDB: Read(16) 88 00 00 00 00
01 5d 50 a3 00 00 00 00 08 00 00
[ 4657.763160] blk_update_request: I/O error, dev sdf, sector
5860532992 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[ 4657.763162] Buffer I/O error on dev sdf, logical block 732566624,
async page read
[ 4657.763178] drivers/scsi/mvsas/mv_sas.c 1757:port 5 slot 0 rx_desc
30000 has error info8000000080000000.
[ 4657.763216] sd 0:0:4:0: [sdf] tag#52 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763218] sd 0:0:4:0: [sdf] tag#52 CDB: Write(16) 8a 00 00 00 00
00 35 46 a0 00 00 00 02 00 00 00
[ 4657.763220] blk_update_request: I/O error, dev sdf, sector
893820928 op 0x1:(WRITE) flags 0x8800 phys_seg 64 prio class 0
[ 4657.763266] sd 0:0:4:0: [sdf] Read Capacity(16) failed: Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763268] sd 0:0:4:0: [sdf] Sense not available.
[ 4657.763280] sd 0:0:4:0: [sdf] Read Capacity(10) failed: Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763281] sd 0:0:4:0: [sdf] Sense not available.
[ 4657.763290] sd 0:0:4:0: [sdf] tag#9 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763291] sd 0:0:4:0: [sdf] tag#9 CDB: Write(16) 8a 00 00 00 00
00 35 46 a0 00 00 00 00 08 00 00
[ 4657.763293] blk_update_request: I/O error, dev sdf, sector
893820928 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
[ 4657.763307] sd 0:0:4:0: [sdf] 0 512-byte logical blocks: (0 B/0 B)
[ 4657.763308] sd 0:0:4:0: [sdf] 4096-byte physical blocks
[ 4657.763338] sd 0:0:4:0: [sdf] tag#13 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763339] sd 0:0:4:0: [sdf] tag#13 CDB: Write(16) 8a 00 00 00 00
00 35 46 a0 08 00 00 00 08 00 00
[ 4657.763341] blk_update_request: I/O error, dev sdf, sector
893820936 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
[ 4657.763363] sd 0:0:4:0: [sdf] tag#15 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4657.763366] sd 0:0:4:0: [sdf] tag#15 CDB: Write(16) 8a 00 00 00 00
00 35 46 a0 10 00 00 00 08 00 00
[ 4657.763368] blk_update_request: I/O error, dev sdf, sector
893820944 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
[ 4657.763372] sdf: detected capacity change from 3000592982016 to 0
[ 4663.172629] sd 0:0:4:0: [sdf] Read Capacity(16) failed: Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4663.172631] sd 0:0:4:0: [sdf] Sense not available.
[ 4663.172657] sd 0:0:4:0: [sdf] Read Capacity(10) failed: Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 4663.172659] sd 0:0:4:0: [sdf] Sense not available.
[ 4837.222770] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 4837.222793] sas: ata11: end_device-0:0: dev error handler
[ 4837.222803] sas: ata12: end_device-0:1: dev error handler
[ 4837.222806] sas: ata13: end_device-0:2: dev error handler
[ 4837.222811] sas: ata14: end_device-0:3: dev error handler
[ 4837.222812] sas: ata15: end_device-0:4: dev error handler
[ 4837.222822] sas: ata16: end_device-0:5: dev error handler
[ 4837.222826] sas: ata17: end_device-0:6: dev error handler
[ 4837.222830] sas: ata18: end_device-0:7: dev error handler
[ 4837.377344] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1

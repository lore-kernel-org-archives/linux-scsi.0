Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867F2C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 11:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C5C564F68
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 11:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCSLau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 07:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhCSLak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 07:30:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B723AC06174A
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 04:30:39 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z1so10351585edb.8
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 04:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgrbM/oj042U+AZuoaNqgQrdVZNkFhf6uPneY8AaEps=;
        b=GDHOl5J2PHzzCa3SXxFjfcMIag830LICeqqNXkwqY0Q30hBMle+C80eU5QFTACasid
         GHbYHMhj2GDAYNwTxqWJOBnyNX6vJXRUqhjxYrJAEiIGcMZSNRtomwzCxBVAjkSKun6h
         5AoTY0E+q8XtJTsTSGcdt8OvQpU9HiB0DHWuUmAKcEzZmZcz8g5axUCP+nI4A4YvNSec
         6oaxWYucYATULZ1PTy3K+WYng+qWUYlfG5zKxwN6S/Qx4EgmNBphpvdqkeV3/LhDWBwL
         mO4omgsF9xb0X6sX86qEnA8pZWqL7yvs5g34hl75Kp1yC11ByYr2fRB9+A09wlYwsOAY
         DJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgrbM/oj042U+AZuoaNqgQrdVZNkFhf6uPneY8AaEps=;
        b=UHZo4q8FjG/ZcRZhfOdCgTBk5M6l+O4bZ4/j58nPZzj1soSDvkM4F0gAj4pmvR4MOX
         BHZwxnez4ozMhWvBt/43EQDAb4+J4i/PT5vxJeTzm9Ba0wL+ov4IdKON3L2t1AYBnZ09
         EqvjaBWNBuKKJtDtsKBy+QO9Z+J9heXyf2uWkHEST3+Jxcn2IfcN2K9Jw6pJK/oD3RMn
         yj3eHDYK695QXtCsoSDaK/JomU0BmFLU3F6G7Lt0XrChzxyNOtwZphhorpPoHg+/f3HM
         0IyrxmfMByUyrgNQ6uMAYoIse6M+E2vDyrBUAi1uJ6ZbjSfX//h4/xWhKfWMQ3rkFyvD
         JZgA==
X-Gm-Message-State: AOAM530HatDPv9uR1ZAfJ8C+j+7T7f9dK0bUR4C56xwxil2Sm+Pi5Tnq
        6jK4UQGZ2d662cAzunCgd6zGm4aFj92qy1ecPRjcGHdHDVhXGg==
X-Google-Smtp-Source: ABdhPJyjTFmoORnLgAc1XlZYsR8rChO6zWK2Y5CnPDDjucfVZHTz3HzFnZeUlQ7pjAfc3nQNbTgbL9RVrfX7SXAK7fg=
X-Received: by 2002:a05:6402:3049:: with SMTP id bu9mr9089633edb.104.1616153438484;
 Fri, 19 Mar 2021 04:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <009d01d71cb1$3fbd5200$bf37f600$@ai0.uk>
In-Reply-To: <009d01d71cb1$3fbd5200$bf37f600$@ai0.uk>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 19 Mar 2021 12:30:27 +0100
Message-ID: <CAMGffE=B9QRncb2UO3aCfbH9naYU6-pP_c6T3PuHNRKRpnkDJA@mail.gmail.com>
Subject: Re: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after v5.10.0
To:     ash@ai0.uk, Viswas G <Viswas.G@microchip.com>,
        Ruksar.devadi@microchip.com
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ash,

Thanks for reporting.


On Fri, Mar 19, 2021 at 12:16 PM <ash@ai0.uk> wrote:
>
> From kernel version 5.10 onwards, none of the drives attached to an Adaptec
> 6805H HBA appear.
>
> Building and installing the mainline kernel (5.12-rc3) does not fix the
> issue, neither does the latest longterm (5.10.24).
>
> 'dmesg | grep pm8' shows:
> [    0.810874] pm80xx 0000:01:00.0: pm80xx: driver version 0.1.40
> [    0.811542] pm80xx 0000:01:00.0: enabling device (0000 -> 0002)
> [    0.812309] :: pm8001_pci_alloc  525:Setting link rate to default value
> [    3.239584] pm80xx0:: pm8001_pci_probe  1112:chip_init failed [ret: -16]
> [    3.262231] pm80xx: probe of 0000:01:00.0 failed with error -16
>
> A bisection reveals the issue appears with the commit show below, with this
> commit reverted, the drives attached to a 6805H appear once again.
>
> > commit 05c6c029a44d9f43715577e33e95eba87f44d285
> > Author: Viswas G <Viswas.G@microchip.com>
> > Date:   Mon Oct 5 20:20:08 2020 +0530
> >
> >     scsi: pm80xx: Increase number of supported queues
> >
> >     Current driver uses fixed number of Inbound and Outbound queues and
> all of
> >     the I/O, TMF and internal requests are submitted through those. A
> global
> >     spin lock is used to control the shared access. This can create a lock
> >     contention and it is real bottleneck in the I/O path.
> >
> >     To avoid this, the number of supported Inbound and Outbound queues is
> >     increased to 64, and the number of queues used is decided based on
> number
> >     of CPU cores online and number of MSI-X vectors allocated. Also add
> locks
> >     per queue instead of using the global lock.
> >
> >     Link:
> https://lore.kernel.org/r/20201005145011.23674-2-Viswas.G@microchip.com.com
> >     Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> >     Signed-off-by: Viswas G <Viswas.G@microchip.com>
> >     Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> >     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
+cc Viswas and Ruksar.

Hi Viswas, hi Ruksar,

Can you please look into it?

Thanks!


> 'lspci -vvv' on working kernel:
>
> > 01:00.0 Serial Attached SCSI controller: Adaptec PMC-Sierra PM8001 SAS HBA
> [Series 6H] (rev 05)
> >         Subsystem: Adaptec PMC-Sierra PM8001 SAS HBA [Series 6H]
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx+
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0, Cache Line Size: 64 bytes
> >         Interrupt: pin A routed to IRQ 16
> >         Region 0: Memory at f7d60000 (64-bit, non-prefetchable) [size=64K]
> >         Region 2: Memory at f7d50000 (64-bit, non-prefetchable) [size=64K]
> >         Region 4: Memory at f7d40000 (32-bit, non-prefetchable) [size=64K]
> >         Region 5: Memory at f7d00000 (32-bit, non-prefetchable)
> [size=256K]
> >         Expansion ROM at f7c00000 [disabled] [size=1M]
> >         Capabilities: [40] Power Management version 3
> >                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot-,D3cold-)
> >                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> >         Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
> >                 Address: 0000000000000000  Data: 0000
> >         Capabilities: [70] Express (v2) Endpoint, MSI 00
> >                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> <1us, L1 <8us
> >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> SlotPowerLimit 0.000W
> >                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
> >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
> >                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr-
> TransPend-
> >                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Exit
> Latency L0s <512ns, L1 <64us
> >                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
> >                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 LnkSta: Speed 5GT/s (ok), Width x4 (downgraded)
> >                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> >                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+
> NROPrPrP- LTR-
> >                          10BitTagComp- 10BitTagReq- OBFF Not Supported,
> ExtFmt- EETLPPrefix-
> >                          EmergencyPowerReduction Not Supported,
> EmergencyPowerReductionInit-
> >                          FRS- TPHComp- ExtTPHComp-
> >                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> >                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
> LTR- OBFF Disabled,
> >                          AtomicOpsCtl: ReqEn-
> >                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-
> >                          Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
> >                          Compliance De-emphasis: -6dB
> >                 LnkSta2: Current De-emphasis Level: -3.5dB,
> EqualizationComplete- EqualizationPhase1-
> >                          EqualizationPhase2- EqualizationPhase3-
> LinkEqualizationRequest-
> >                          Retimer- 2Retimers- CrosslinkRes: unsupported
> >         Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
> >                 Vector table: BAR=0 offset=00002000
> >                 PBA: BAR=0 offset=00004000
> >         Capabilities: [100 v1] Advanced Error Reporting
> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> AdvNonFatalErr-
> >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> AdvNonFatalErr+
> >                 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn-
> ECRCChkCap+ ECRCChkEn-
> >                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres-
> HdrLogCap-
> >                 HeaderLog: 00000000 00000000 00000000 00000000
> >         Kernel driver in use: pm80xx
> >         Kernel modules: pm80xx
>
> 'lspci -vvv' on non-working kernel (5.12-rc3):
>
> > 01:00.0 Serial Attached SCSI controller: Adaptec PMC-Sierra PM8001 SAS HBA
> [Series 6H] (rev 05)
> >         Subsystem: Adaptec PMC-Sierra PM8001 SAS HBA [Series 6H]
> >         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx+
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Interrupt: pin A routed to IRQ 16
> >         Region 0: Memory at f7d60000 (64-bit, non-prefetchable) [size=64K]
> >         Region 2: Memory at f7d50000 (64-bit, non-prefetchable) [size=64K]
> >         Region 4: Memory at f7d40000 (32-bit, non-prefetchable) [size=64K]
> >         Region 5: Memory at f7d00000 (32-bit, non-prefetchable)
> [size=256K]
> >         Expansion ROM at f7c00000 [disabled] [size=1M]
> >         Capabilities: [40] Power Management version 3
> >                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot-,D3cold-)
> >                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> >         Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
> >                 Address: 0000000000000000  Data: 0000
> >         Capabilities: [70] Express (v2) Endpoint, MSI 00
> >                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> <1us, L1 <8us
> >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> SlotPowerLimit 116.000W
> >                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
> >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
> >                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr-
> TransPend-
> >                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Exit
> Latency L0s <512ns, L1 <64us
> >                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
> >                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 LnkSta: Speed 5GT/s (ok), Width x4 (downgraded)
> >                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> >                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+
> NROPrPrP- LTR-
> >                          10BitTagComp- 10BitTagReq- OBFF Not Supported,
> ExtFmt- EETLPPrefix-
> >                          EmergencyPowerReduction Not Supported,
> EmergencyPowerReductionInit-
> >                          FRS- TPHComp- ExtTPHComp-
> >                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> >                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
> LTR- OBFF Disabled,
> >                          AtomicOpsCtl: ReqEn-
> >                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-
> >                          Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
> >                          Compliance De-emphasis: -6dB
> >                 LnkSta2: Current De-emphasis Level: -3.5dB,
> EqualizationComplete- EqualizationPhase1-
> >                          EqualizationPhase2- EqualizationPhase3-
> LinkEqualizationRequest-
> >                          Retimer- 2Retimers- CrosslinkRes: unsupported
> >         Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
> >                 Vector table: BAR=0 offset=00002000
> >                 PBA: BAR=0 offset=00004000
> >         Capabilities: [100 v1] Advanced Error Reporting
> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> AdvNonFatalErr-
> >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> AdvNonFatalErr+
> >                 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn-
> ECRCChkCap+ ECRCChkEn-
> >                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres-
> HdrLogCap-
> >                 HeaderLog: 00000000 00000000 00000000 00000000
> >         Kernel modules: pm80xx
>

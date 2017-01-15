From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: aacraid:  kernel: AAC: Host adapter dead -1 (bisected)
Date: Sun, 15 Jan 2017 12:05:37 +0100
Message-ID: <201701151205.37563.a.miskiewicz__17982.9176668592$1484480988$gmane$org@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35483 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdAOLt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2017 06:49:28 -0500
Received: by mail-lf0-f66.google.com with SMTP id v186so9770713lfa.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2017 03:49:27 -0800 (PST)
Received: from xps.localnet (89-65-45-9.dynamic.chello.pl. [89.65.45.9])
        by smtp.gmail.com with ESMTPSA id x2sm3369467lja.6.2017.01.15.03.49.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 15 Jan 2017 03:49:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>


Hi.

There is a bug with handling of adaptec raid cards (in my case it is Adapte=
c=20
3405) where kernel logs hundreds of "AAC: Host adapter dead -1" messages.

Bug was reported previously on lkml but there was no progres in solving it.

There is also bugzilla entry:
https://bugzilla.kernel.org/show_bug.cgi?id=3D151661

I've bisected that to commit bellow and indeed, reverting it from kernel 4.=
9.3=20
makes messages go away.

Could anyone at microsemi look at this regression?

Thanks

commit 78cbccd3bd683c295a44af8050797dc4a41376ff
Author: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Date:   Mon Apr 25 23:32:37 2016 -0700

    aacraid: Fix for KDUMP driver hang

    When KDUMP is triggered the driver first talks to the firmware in INTX
    mode, but the adapter firmware is still in MSIX mode. Therefore the fir=
st
    driver command hangs since the driver is waiting for an INTX response a=
nd
    firmware gives a MSIX response. If when the OS is installed on a RAID
    drive created by the adapter KDUMP will hang since the driver does not
    receive a response in sync mode.

    Fixed by: Change the firmware to INTX mode if it is in MSIX mode before
    sending the first sync command.

    Cc: stable@vger.kernel.org
    Signed-off-by: Raghava Aditya Renukunta=20
<RaghavaAditya.Renukunta@microsemi.com>
    Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

my hardware:
02:0e.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285]
        Subsystem: Adaptec 3405 [9005:02bb]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping+ SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (250ns min, 250ns max), Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fba00000 (64-bit, non-prefetchable) [size=3D2M]
        [virtual] Expansion ROM at fbc00000 [disabled] [size=3D256K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [d0] MSI: Enable- Count=3D1/2 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D4
                Status: Dev=3D02:0e.0 64bit+ 133MHz+ SCD- USC- DC=3Dbridge=
=20
DMMRBC=3D1024 DMOST=3D4 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: aacraid
        Kernel modules: aacraid

[    1.956009] Adaptec aacraid driver 1.2-1[41066]-ms
[    2.164584] AAC0: kernel 5.2-0[17342] Aug  4 2010
[    2.164633] AAC0: monitor 5.2-0[17342]
[    2.164676] AAC0: bios 5.2-0[17342]
[    2.164719] AAC0: serial 7C46114103A
[    2.164761] AAC0: Non-DASD support enabled.
[    2.164804] AAC0: 64bit support enabled.
[    2.164846] AAC0: 64 Bit DAC enabled
[    2.177929] scsi host6: aacraid


=2D-=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )

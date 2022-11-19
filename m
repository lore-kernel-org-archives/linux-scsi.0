Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647FDC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 17:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiKSRkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 12:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiKSRkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 12:40:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976D119281
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 09:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2512E60BA4
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 17:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A074C433D7
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668879604;
        bh=LVSV6ZQ+hWBsoRkyU/B2OC5vUvo8iWIlUI0V8mNg0to=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q/Tt4FvjLmcXoFBi1PiYetveEz2ObeS+St+8oODktIGxsBt3zJuXy4Xt2wVrX8OQW
         HvdpBdDQ9TZxKysXQ4KyxB99+QC5Cjqaql0rsbrBu02RID5B6i9+Pj9VgSX3gWyH1l
         PS3HY0Guk3mznfqiyvrhE8xD+1nuAEm9nT17XgiQzLc4fXQYtcvA53xiyJPUmd+/Uh
         DtWLjXvS9ozzl0w8evBhvmtITncVALprV9cUFlRAmiw+zCVJbm6t46dsDFE4YXRUpY
         Uj6EuVlb6G/UmoT3t7r6jh+PQjF2rI5AgZ1+x+/UwjSrS0VbyGbsbPUBfRgKM43cD0
         kCMrGSkLt5HhA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5EB43C433E4; Sat, 19 Nov 2022 17:40:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 198975] Highpoint 840A RocketRAID Controller and drives are NOT
 detected by SCSI_HPTIOP kernel module
Date:   Sat, 19 Nov 2022 17:40:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: adnanshaoun582@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198975-11613-TEaMdP0XtN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198975-11613@https.bugzilla.kernel.org/>
References: <bug-198975-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D198975

Carol Jams (adnanshaoun582@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adnanshaoun582@gmail.com

--- Comment #8 from Carol Jams (adnanshaoun582@gmail.com) ---
(In reply to Jaym12 from comment #7)
> I fixed this error(In reply to Matthias Lippert from comment #0)
> > Hello,
> >=20
> > This is my first kernel bugzilla report, so please have mercy ;-)
> >=20
> > My freshly bought Highpoint 840A RocketRAID Controller and its 8 connec=
ted
> > "Samsung 860 EVO" ssd harddrives are NOT detected by the "SCSI_HPTIOP"
> > kernel low-level scsi driver module, but it seems to be the smaller bro=
ther
> > of the already from kernel supported 3740A RocketRAID controller by
> > Highpoint.
> > The only differnence seems to be that the 840A supports only 6Gb/s per
> > channel.
> > Thats is also confirmed by the top down view onto the expansion card.
> > In the upper right corner you can see the described dual product markin=
gs
> > "RocketRAID 3740A/840A", so the layout and most likely also the raid
> > processor of the controller has been used at least twice by Highpoint.
> > My controllers firmware is the recent 1.0.0 version.
> > I couldnt find any other driver module that is matching my controller m=
ore
> > closely.
> > The current published linux drivers by highpoint are useless under (Gen=
too)
> > Linux.
> > The controller and its connected drives are working flawlessy under Win=
dows
> > 10, so its not damaged. I am using a "Gigabyte X99-SLI" motherboard with
> > recent F24a bios version.
> > I am also willingly able to provide regular dump logs to kernel develop=
ers
> > for driver debugging.
> >=20
> > I would be VERY thankful for including support into the next kernel for
> this
> > cool piece of hardware!
> >=20
> >=20
> > Top-down view onto the expansion card:
> >=20
> > https://www.bhphotovideo.com/images/images1000x1000/
> > highpoint_rocketraid_3740a_12gb_s_pcie_1269779.jpg
> >=20
> >=20
> > dmesg outputs only this, then nothing else related to my controller:
> >=20
> > RocketRAID 3xxx/4xxx Controller driver v1.10.0
> >=20
> >=20
> > lspci -kvv outputs this:
> >=20
> > 02:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 0840 (=
rev
> > a1)
> >         Subsystem: HighPoint Technologies, Inc. Device 0000
> >         Physical Slot: 6
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
> > Stepping- SERR+ FastB2B- DisINTx-
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0, Cache Line Size: 32 bytes
> >         Interrupt: pin A routed to IRQ 11
> >         NUMA node: 0
> >         Region 0: Memory at d0900000 (64-bit, prefetchable) [size=3D1M]
> >         Region 4: Memory at d0a00000 (64-bit, prefetchable) [size=3D256=
K]
> >         Expansion ROM at dfe00000 [disabled] [size=3D128K]
> >         Capabilities: [80] Power Management version 3
> >                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA
> > PME(D0+,D1+,D2-,D3hot+,D3cold-)
> >                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 P=
ME-
> >         Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable+ 64bit+
> >                 Address: 0000000000000000  Data: 0000
> >                 Masking: 00000000  Pending: 00000000
> >         Capabilities: [b0] MSI-X: Enable- Count=3D18 Masked-
> >                 Vector table: BAR=3D0 offset=3D00038000
> >                 PBA: BAR=3D0 offset=3D00039000
> >         Capabilities: [c0] Express (v2) Endpoint, MSI 00
> >                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s
> > <128ns, L1 <2us
> >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > SlotPowerLimit 0.000W
> >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >                         MaxPayload 256 bytes, MaxReadReq 512 bytes
> >                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
> > TransPend-
> >                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Ex=
it
> > Latency L0s <128ns, L1 <2us
> >                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk-
> > DLActive- BWMgmt- ABWMgmt-
> >                 DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-,
> > OBFF Not Supported
> >                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> >                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance-
> SpeedDis-
> >                          Transmit Margin: Normal Operating Range,
> > EnterModifiedCompliance- ComplianceSOS-
> >                          Compliance De-emphasis: -6dB
> >                 LnkSta2: Current De-emphasis Level: -6dB,
> > EqualizationComplete+, EqualizationPhase1+
> >                          EqualizationPhase2+, EqualizationPhase3+,
> > LinkEqualizationRequest-
> >         Capabilities: [100 v2] Advanced Error Reporting
> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmp=
lt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmp=
lt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmp=
lt-
> > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr-
> >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> >                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> > ChkEn-
> >         Capabilities: [300 v1] #19
> >=20
> >=20
> > Highpoints 800er series RocketRAID website:
> >=20
> > http://www.highpoint-tech.com/USA_new/series-rr800-overview.htm
> >=20
> >=20
> > Highpoints 3700er series RocketRAID website:
> >=20
> http://www.highpoint-tech.com/USA_new/series-rr3700-overview.htm
>=20
> > I have been facing the same issue.
> > https://www.allhdd.com/seagate-st3000lm024-sata-6gbps-hdd/

You can use https://www.allhdd.com/samsung-mz-77q4t0-sata-ssd/ drive it is
working fine for me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

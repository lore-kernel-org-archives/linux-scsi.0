Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E3C15532A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573731; cv=none; b=gpQwpEs0PgQjU3YNzg/THWs7bEi7suFs0R5rCHF14C2f8Hs+RwrCksv8DoB/uslb+qpFFhg/vuIwAbAa4MdzZqvPcZSYKcZ3WoHbzjlbbILWcASlTT7+ZU0UqqAyAwM79uzCFVqo1ww55o/8Q7sbMY1392h7bZ6wsup69kep22Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573731; c=relaxed/simple;
	bh=c+LJYgLefMf2TuplTagIwvnMkU8XCXcioAd7YJAzMzk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m/XdiZxuEkbF39tKpEHWF8yFzN7ZMMVYOYO/71ttpfVfIOd3QydpGKMlyx7CsPByfh08+HJUylYrSjwrM1N4bpHrSnfpUEg257+Nvg267oddwnFC6OaFccCk3l+TYnt2lrc+3aIUSV6NfIifEVYNpI76FZj937FTRIf9UieSkNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFQxcND2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFQxcND2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C97ECC4CEC4
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725573730;
	bh=c+LJYgLefMf2TuplTagIwvnMkU8XCXcioAd7YJAzMzk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FFQxcND2UVFP2UU5O3kUMvRIMuMu9fV4//58QCyJLcs/3uBYMy42CUCWwmIJxis/x
	 MHnnzfWrwruDLgzxJY+mEixXx4wIXT8skFOE+vV+Fv+dTl3WmVqWAdhZCRH0ggVkiX
	 lawko21cJtxu76i6br3ncgEWryqZSAjpDjpcaPZm8mKKk50AuBTFKOtwhXazppuNKK
	 JxsxiTOiM1X8Suq4TgTxYy48yiCwQ98p0AhRr74Wrc1yDHy5tm+33TAIUayi/WtnIR
	 6wZTAFyH9JKCbBxYN52pxkkerhKGafZsPJOfsIiRIZ58N8I/gE1gP5Zb8spfUNhYYg
	 Gc1zifbxCj1HQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B2164C53BBF; Thu,  5 Sep 2024 22:02:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198975] Highpoint 840A RocketRAID Controller and drives are NOT
 detected by SCSI_HPTIOP kernel module
Date: Thu, 05 Sep 2024 22:02:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: jackhicks121@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198975-11613-ze8G9dEak1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198975-11613@https.bugzilla.kernel.org/>
References: <bug-198975-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D198975

Jack Hicks (jackhicks121@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jackhicks121@gmail.com

--- Comment #9 from Jack Hicks (jackhicks121@gmail.com) ---
Hello,

This is my first Bugzilla report, so I appreciate your patience!

I recently purchased a Highpoint 840A RocketRAID Controller with eight
connected Samsung 860 EVO SSDs . Unfortunately, the "SCSI_HPTIOP" kernel
low-level SCSI driver module does not detect this controller. It appears th=
at
the 840A is a smaller version of the 3740A, which is already supported by t=
he
kernel. The main difference seems to be that the 840A supports only 6Gb/s p=
er
channel, as indicated by the product markings on the card.

I am currently using the latest firmware version 1.0.0 for the controller. I
couldn't find any other driver modules that might be compatible with my
controller. The drivers available from Highpoint for Linux do not work on
(Gentoo) Linux. The controller and SSDs
(https://serverorbit.com/solid-state-drives-ssd/sata-6gbps-ssd) are functio=
ning
perfectly under Windows 10, so the hardware is not faulty. I am using a
Gigabyte X99-SLI motherboard with BIOS version F24a.

I am willing to provide regular dump logs for driver debugging if needed. I
would be extremely grateful if support for this hardware could be included =
in
the next kernel release!

Here is a top-down view of the expansion card for reference:
[Top-down view of the expansion
card](https://www.bhphotovideo.com/images/images1000x1000/highpoint_rocketr=
aid_3740a_12gb_s_pcie_1269779.jpg)

Current dmesg output:
```
RocketRAID 3xxx/4xxx Controller driver v1.10.0
```

`lspci -kvv` output:
```
02:00.0 RAID bus controller: HighPoint Technologies, Inc. Device 0840 (rev =
a1)
        Subsystem: HighPoint Technologies, Inc. Device 0000
        Physical Slot: 6
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        NUMA node: 0
        Region 0: Memory at d0900000 (64-bit, prefetchable) [size=3D1M]
        Region 4: Memory at d0a00000 (64-bit, prefetchable) [size=3D256K]
        Expansion ROM at dfe00000 [disabled] [size=3D128K]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [b0] MSI-X: Enable- Count=3D18 Masked-
                Vector table: BAR=3D0 offset=3D00038000
                PBA: BAR=3D0 offset=3D00039000
        Capabilities: [c0] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <128=
ns,
L1 <2us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
SlotPowerLimit 0.000W
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Exit
Latency L0s <128ns, L1 <2us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk- DLAct=
ive-
BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-, OB=
FF
Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR=
-,
OBFF Disabled
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDi=
s-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete+, EqualizationPhase1+
                         EqualizationPhase2+, EqualizationPhase3+,
LinkEqualizationRequest-
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ Ch=
kEn-
        Capabilities: [300 v1] #19
```

For more information on the Highpoint 800 series RocketRAID:
[Highpoint 800 Series
Overview](http://www.highpoint-tech.com/USA_new/series-rr800-overview.htm)

And the 3700 series RocketRAID:
[Highpoint 3700 Series
Overview](http://www.highpoint-tech.com/USA_new/series-rr3700-overview.htm)

Thank you for your help!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

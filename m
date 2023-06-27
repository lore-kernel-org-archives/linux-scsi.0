Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A3CEB64D7
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 01:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjF0Bsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 21:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjF0Bsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 21:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E36211B
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 18:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD8E60FC4
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FDD1C433CA
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687830471;
        bh=Yn0I44rwGPJe6BQfr0I7CVi1tbovSWx1q7R7Mg0Mhwc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=S/i1IcqDMdagoPlodHVUrdg+aPTO2Lb/DRDAo2Dc4SwmSnGAp13gCV6doqJY6BC4j
         v+D2cnu2gDnWodlge5GYatNvtmWp8/eeB3fPIntpipr8ktr2QCtBvcVILB28+ZYqAL
         C29XW7WT1FvuWPzXFxubBsG4mZCOrbhb0A2o75e8ZYc2dvr+I/3/2IOtYAfyGTOtpe
         ThiQ7yuq0rYBnHvDeLWvuthB3H/KtINEh/mDhByDmad7fHbyAc1Ftbr1rkCfcSEtN6
         M/QuCT50U8tsvHWjLGiGO8K/qd0C0+reFtwHn85K9c4MiT2mSf0AwT8G41suhkSwYV
         0w4LEtHZfvfVg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 308D2C53BD3; Tue, 27 Jun 2023 01:47:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Tue, 27 Jun 2023 01:47:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-pvpXHC1Lc3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #2 from pheidologeton@protonmail.com ---
I don't understand a bit, since I use a translator. I can attach dmesg as f=
iles
from kernel 6.4 and 6.3.9
-------- =D0=98=D1=81=D1=85=D0=BE=D0=B4=D0=BD=D0=BE=D0=B5 =D1=81=D0=BE=D0=
=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B5 --------
27 =D0=B8=D1=8E=D0=BD. 2023 =D0=B3., 04:31, =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=
=D0=B0=D0=BB:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D217599 Bagas Sanjaya
> (bagasdotme@gmail.com) changed: What |Removed |Added
> -------------------------------------------------------------------------=
---
> CC| |bagasdotme@gmail.com --- Comment #1 from Bagas Sanjaya
> (bagasdotme@gmail.com) --- (In reply to pheidologeton from comment #0) > =
The
> controller works fine for a few minutes. Then it hangs for a few tens of >
> seconds to a few minutes, then also works normally for a while. This bug =
is >
> present in the 6.4.0 kernel release (6.3.9 works without hanging) > The
> messages in dmesg are as follows > > [ 287.137901] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
909]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137912] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137914] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
916]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137919] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137921] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
924]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137926] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137928] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
930]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137933] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137934] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
937]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137939] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137941] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
943]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137945] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137947] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
949]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137951] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137952] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
954]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137956] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137958] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
960]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137962] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137964] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
966]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.137967] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 287.137969] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 287.137=
971]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 287.157697] aacraid: Host bus reset request. SCSI hang ? =
> [
> 287.157706] aacraid 0000:02:00.0: outstanding cmd: midlevel-0 > [ 287.157=
708]
> aacraid 0000:02:00.0: outstanding cmd: lowlevel-0 > [ 287.157709] aacraid
> 0000:02:00.0: outstanding cmd: error handler-0 > [ 287.157711] aacraid
> 0000:02:00.0: outstanding cmd: firmware-32 > [ 287.157712] aacraid
> 0000:02:00.0: outstanding cmd: kernel-0 > [ 287.167040] aacraid 0000:02:0=
0.0:
> Controller reset type is 3 > [ 287.167042] aacraid 0000:02:00.0: Issuing =
IOP
> reset > [ 321.029712] aacraid 0000:02:00.0: IOP reset succeeded > [
> 321.066201] numacb=3D512 ignored > [ 321.066843] aacraid: Comm Interface =
type2
> enabled > [ 344.845370] aacraid 0000:02:00.0: Scheduling bus rescan > [
> 358.294342] sd 10:0:0:0: [sda] Very big device. Trying to use READ >
> CAPACITY(16). > [ 442.109147] aacraid: Host adapter abort request. > aacr=
aid:
> Outstanding commands on (10,0,0,0): > [ 442.109155] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
158]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109160] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109162] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
164]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109166] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109168] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
170]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109172] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109174] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
176]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109178] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109179] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
181]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109183] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109185] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
187]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109189] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109191] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
193]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109194] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109196] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
198]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109200] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109201] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
203]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109205] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.109207] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.109=
208]
> aacraid: Host adapter abort request. > aacraid: Outstanding commands on
> (10,0,0,0): > [ 442.109210] aacraid: Host adapter abort request. > aacrai=
d:
> Outstanding commands on (10,0,0,0): > [ 442.137144] aacraid: Host adapter
> abort request. > aacraid: Outstanding commands on (10,0,0,0): > [ 442.154=
292]
> aacraid: Host bus reset request. SCSI hang ? > [ 442.154302] aacraid
> 0000:02:00.0: outstanding cmd: midlevel-0 > [ 442.154305] aacraid
> 0000:02:00.0: outstanding cmd: lowlevel-0 > [ 442.154307] aacraid
> 0000:02:00.0: outstanding cmd: error handler-0 > [ 442.154308] aacraid
> 0000:02:00.0: outstanding cmd: firmware-32 > [ 442.154310] aacraid
> 0000:02:00.0: outstanding cmd: kernel-0 > [ 442.171131] aacraid 0000:02:0=
0.0:
> Controller reset type is 3 > [ 442.171133] aacraid 0000:02:00.0: Issuing =
IOP
> reset > [ 476.040983] aacraid 0000:02:00.0: IOP reset succeeded > [
> 476.078055] numacb=3D512 ignored > [ 476.078606] aacraid: Comm Interface =
type2
> enabled > [ 494.747632] aacraid 0000:02:00.0: Scheduling bus rescan > [
> 507.896453] sd 10:0:0:0: [sda] Very big device. Trying to use READ >
> CAPACITY(16). Can you do bisection between v6.3 and v6.4 please? -- You m=
ay
> reply to this email to add a comment. You are receiving this mail because:
> You reported the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

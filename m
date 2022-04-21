Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D22C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 06:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385379AbiDUG5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 02:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385388AbiDUG47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 02:56:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35049193C9
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 23:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E01CFB82213
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 06:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88DAAC385A1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 06:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650523973;
        bh=KTjIEqqfxBM5Zkc9oM0riJ8UvrJ7cdl0scEBLw6K0pA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=D0rR5t/c0Yfb5iN89lmuc0rNTuNh0YPsaVK72cXCbhDTznoJL11PKGK3ERzkf7YFj
         LrLgBdpakNXOzAJ5niKc37GSlfxvlTSr4ORibvZM5I9WZ5PWsknMYAMVyS9du8fiaT
         oG/sYUfEXOqKdtmMaHAKyZUXrM/4au9tYRh2Ym0l1OUl5+ziODL8+NaKuir9Zfju3h
         zIB4WyqYifSN7VlOwoQeQUjSrNwQZfdX8dzSR7WhqTwYFPczNyIzCWAKijqzwemRgI
         KJNE9xXKeNH4D8zsmIHIdRM/P7+A8TeLPVd7V+Kq76dt2gZ+5Zx2FTBaX4tCmvhep6
         7xkHdp+EQp1nQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6FF49CAC6E2; Thu, 21 Apr 2022 06:52:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Thu, 21 Apr 2022 06:52:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christophotron@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215788-11613-jtdYadOH6Q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

Chris Rodrigues (christophotron@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |christophotron@gmail.com

--- Comment #15 from Chris Rodrigues (christophotron@gmail.com) ---
I am having similar issues with my ARC-1231 card in OpenSuSE with kernel 5.=
17.=20
The card works fine in Windows but when I try to boot linux I get "ata8:
softreset failed (device not ready)" along with errors from the arcmsr driv=
er.


> christophocles@localhost:~> lsb-release -a
LSB Version:    n/a
Distributor ID: openSUSE
Description:    openSUSE Tumbleweed
Release:        20220419
Codename:       n/a
christophocles@localhost:~> uname -r
5.17.3-1-default
christophocles@localhost:~> dmesg | grep ata8
[    0.683123] ata8: SATA max UDMA/133 abar m8192@0xde400000 port 0xde400180
irq 16
[    6.998524] ata8: link is slow to respond, please be patient (ready=3D0)
[   10.730379] ata8: softreset failed (device not ready)
[   17.042164] ata8: link is slow to respond, please be patient (ready=3D0)
[   20.770497] ata8: softreset failed (device not ready)
[   27.081803] ata8: link is slow to respond, please be patient (ready=3D0)
[   55.840740] ata8: softreset failed (device not ready)
[   55.851912] ata8: limiting SATA link speed to 1.5 Gbps
[   60.916825] ata8: softreset failed (device not ready)
[   60.928005] ata8: reset failed, giving up
christophocles@localhost:~> dmesg | grep arcmsr
               arcmsr version v1.50.00.05-20210429
[   63.719008] arcmsr 0000:02:00.0: msi enabled
[   95.326504] arcmsr9: abort device command of scsi id =3D 6 lun =3D 7
[   98.990514] arcmsr: executing bus reset eh.....num_resets =3D 0, num_abo=
rts =3D
1=20
[  139.002496] arcmsr9: wait 'abort all outstanding command' timeout
[  139.017296] arcmsr9: executing hw bus reset .....
[  192.194497] arcmsr9: wait 'start adapter background=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
rebuild' timeout=20
[  192.208071] arcmsr: scsi bus reset eh returns with success
[  212.562498] arcmsr9: abort device command of scsi id =3D 6 lun =3D 7
[  216.210497] arcmsr: executing bus reset eh.....num_resets =3D 1, num_abo=
rts =3D
2=20
[  256.222496] arcmsr9: wait 'abort all outstanding command' timeout
[  256.235610] arcmsr9: executing hw bus reset .....
[  309.422496] arcmsr9: wait 'start adapter background=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
rebuild' timeout=20
[  309.435455] arcmsr: scsi bus reset eh returns with success

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

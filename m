Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628D7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 02:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbiDYCbK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Apr 2022 22:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240370AbiDYCbJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Apr 2022 22:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300B0B16
        for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2022 19:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B254C614C2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 02:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FE55C385AD
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 02:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650853686;
        bh=LB71s4h75VpCVkldqG13YvuU45hJLoHJD3onlL4YkbM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gIICLWZgdLbM65GOpqFanDINytCjPF5R0P5hZDbbOgj89bUzjNx+r8JTrDSYD5Vat
         Wi4KirYZIWqidjb4ubWuXMP7YDNLpS+CwM3urLIbvMVGNcHTTR68nlOcpl70iNoeVR
         pJgxeMBTXKVU1zCm2TJNkCN2XjIDIvVrknORXf1NT3bqEt8keYh2Scl67DmY7ydv8h
         QevT6gGPAOG0eETIiDtugeEPv/ZX49534yfLpHfvvsxsaxEqbHj7xjv/hWL2IFYKu4
         gJbBsKHnScDwPMVfov6NEckRxLzD6CQCwiMq9AsafTeDP2iP8JX4kKkr7BSvDS2YQ5
         thJYVQqpD+stg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02CDCCC13AD; Mon, 25 Apr 2022 02:28:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Mon, 25 Apr 2022 02:28:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-uyKAFbQcUa@https.bugzilla.kernel.org/>
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

--- Comment #16 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Chris Rodrigues from comment #15)
> I am having similar issues with my ARC-1231 card in OpenSuSE with kernel
> 5.17.  The card works fine in Windows but when I try to boot linux I get
> "ata8: softreset failed (device not ready)" along with errors from the
> arcmsr driver.
>=20
>=20
> > christophocles@localhost:~> lsb-release -a
> LSB Version:    n/a
> Distributor ID: openSUSE
> Description:    openSUSE Tumbleweed
> Release:        20220419
> Codename:       n/a
> christophocles@localhost:~> uname -r
> 5.17.3-1-default
> christophocles@localhost:~> dmesg | grep ata8
> [    0.683123] ata8: SATA max UDMA/133 abar m8192@0xde400000 port 0xde400=
180
> irq 16
> [    6.998524] ata8: link is slow to respond, please be patient (ready=3D=
0)
> [   10.730379] ata8: softreset failed (device not ready)
> [   17.042164] ata8: link is slow to respond, please be patient (ready=3D=
0)
> [   20.770497] ata8: softreset failed (device not ready)
> [   27.081803] ata8: link is slow to respond, please be patient (ready=3D=
0)
> [   55.840740] ata8: softreset failed (device not ready)
> [   55.851912] ata8: limiting SATA link speed to 1.5 Gbps
> [   60.916825] ata8: softreset failed (device not ready)
> [   60.928005] ata8: reset failed, giving up
> christophocles@localhost:~> dmesg | grep arcmsr
>                arcmsr version v1.50.00.05-20210429
> [   63.719008] arcmsr 0000:02:00.0: msi enabled
> [   95.326504] arcmsr9: abort device command of scsi id =3D 6 lun =3D 7
> [   98.990514] arcmsr: executing bus reset eh.....num_resets =3D 0, num_a=
borts
> =3D 1=20
> [  139.002496] arcmsr9: wait 'abort all outstanding command' timeout
> [  139.017296] arcmsr9: executing hw bus reset .....
> [  192.194497] arcmsr9: wait 'start adapter background=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> rebuild' timeout=20
> [  192.208071] arcmsr: scsi bus reset eh returns with success
> [  212.562498] arcmsr9: abort device command of scsi id =3D 6 lun =3D 7
> [  216.210497] arcmsr: executing bus reset eh.....num_resets =3D 1, num_a=
borts
> =3D 2=20
> [  256.222496] arcmsr9: wait 'abort all outstanding command' timeout
> [  256.235610] arcmsr9: executing hw bus reset .....
> [  309.422496] arcmsr9: wait 'start adapter background=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> rebuild' timeout=20
> [  309.435455] arcmsr: scsi bus reset eh returns with success

If you can and know how to build a kernel, can you please try this code:

https://git.kernel.org/mkp/h/5.18/discovery

It seems to solve the issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

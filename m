Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB862C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 00:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D2961027
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 00:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348533AbhKPAJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353707AbhKPAHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 19:07:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A9F763219
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 00:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637021045;
        bh=nPdicN+tZvkFTR4ANWb3YtX96w9a5OYDdLcXBlcfmYs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vNXJvm/Rl4i1rpDwfQfM6vPI1NOVYrvBqhMpvNdkxyJYz5eWcmYc6kB82+aYhoWmK
         /8VjGnx/6AxHqsqJrWfiiC6PNopYBeOdfYsQLpnGm9odzUSut3XUtvK/pcSBLGt0/D
         j+78+wFivj5SUXTxUglybh/27VfQlyPVF1rwW3tCLx1TxWmtz+pUO50s8lLQC856Ja
         Mec+q3J02pmyuqyJIjOkzh4+Lc4u780HoKa1VMUPsgI07+7NrLEmTtRIkHAukQCrbV
         h+79IPLNqpxig9/r6n4PIbVq1qw7Gbmr7xgCagYvsdFd45N0eOnF7qNrREDYvOms8u
         lJf9sbPGSYXuQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 00:04:05 +0000
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
Message-ID: <bug-214967-11613-7kkGNFyihN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

--- Comment #10 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Matthew Perkowski from comment #9)
> (In reply to Damien Le Moal from comment #7)
> > (In reply to Matthew Perkowski from comment #1)
> > > I stumbled across this and gave it a try, and it fixed my immediate
> > problem:
> > >=20
> > >
> https://sourceforge.net/p/scst/mailman/scst-devel/thread/4FDDA78C.400@acm.
> > > org/
> > >=20
> > > However, it doesn't look like the mvsas driver has changed in some ti=
me,
> so
> > > I'm thinking the problem was caused by another change somewhere else =
in
> the
> > > kernel, and adding that one line of code to mv_sas.c simply "band-aid=
ed"
> > the
> > > immediate issue I was experiencing.
> >=20
> > I am not familiar with the mv_sas driver & associated HBAs. Do these
> > implement SAT using libata on the host ? Or does the HBA firmware handle
> > scsi command translation ? Some quick grep in the driver code does not
> > reveal much.
>=20
> I'm afraid I don't know that for certain. I know the card HAS firmware si=
nce
> I've updated it once before. I'll see if those patches solve the problem.=
 If
> not, maybe I can figure out more about the card to help us along. I can t=
ell
> you that the card uses this controller chip:
>=20
> https://www.marvell.com/content/dam/marvell/en/public-collateral/storage/
> marvell-storage-88se94xx-product-brief-2011-04.pdf
>=20
> I'm not accustomed to interpreting hardware information at such a low lev=
el
> myself, but it mentions offering "native 6Gb/s SATA interface support."

Looks like the mvsas driver uses libsas, so it likely relies on libata for
SCSI-to-ATA translation. Will have a closer look. I also have other HBAs us=
ing
the pm80xx driver that is similar. Will do some more tests with that.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

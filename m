Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACD9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 00:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A2360EFD
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 00:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347817AbhKPAFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhKPACw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 19:02:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 18E9760EFD
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 23:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637020796;
        bh=sspNCaI5VcKdjkEEPUggWWzWo1D6V46KMWbIswuMPL4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mO6eAZAe8IRAOOdl0vrdEcUhr2IdTFHrbohzVIbA9uQ/czjZUFEjNDsY1dOsNMoxD
         ++ADimxKNVtRpz0xJ/lIZ2aYKNT0qttxDfVypEzzxsUSt5bILmzySCNRES4UMK8jro
         q65ea+BepyRvKb9+j6zHLyoSN4d+tPd8mM0uH4zsKeJxAZZZ0hgLwuIJd+isZKZd+y
         +fEHenxwSo3OyrJ8cv86AwAONMBMsHGJjadd9fCrvJEsGQJmi6+8Nk0PgSLzEJfOm4
         JTjwGN4/Vfi9whJzIKGhnFcAu6kWR0LjDJQMqMbtO+5vZ3tqgWrXCRGsLwN+eiJc6Y
         UG0QgmX1VtvIg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 23:59:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgperkow@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-Pv7UjYNkSY@https.bugzilla.kernel.org/>
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

--- Comment #9 from Matthew Perkowski (mgperkow@gmail.com) ---
(In reply to Damien Le Moal from comment #7)
> (In reply to Matthew Perkowski from comment #1)
> > I stumbled across this and gave it a try, and it fixed my immediate
> problem:
> >=20
> > https://sourceforge.net/p/scst/mailman/scst-devel/thread/4FDDA78C.400@a=
cm.
> > org/
> >=20
> > However, it doesn't look like the mvsas driver has changed in some time=
, so
> > I'm thinking the problem was caused by another change somewhere else in=
 the
> > kernel, and adding that one line of code to mv_sas.c simply "band-aided"
> the
> > immediate issue I was experiencing.
>=20
> I am not familiar with the mv_sas driver & associated HBAs. Do these
> implement SAT using libata on the host ? Or does the HBA firmware handle
> scsi command translation ? Some quick grep in the driver code does not
> reveal much.

I'm afraid I don't know that for certain. I know the card HAS firmware since
I've updated it once before. I'll see if those patches solve the problem. If
not, maybe I can figure out more about the card to help us along. I can tell
you that the card uses this controller chip:

https://www.marvell.com/content/dam/marvell/en/public-collateral/storage/ma=
rvell-storage-88se94xx-product-brief-2011-04.pdf

I'm not accustomed to interpreting hardware information at such a low level
myself, but it mentions offering "native 6Gb/s SATA interface support."

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

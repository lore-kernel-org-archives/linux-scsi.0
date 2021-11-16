Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70412C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AC260E78
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhKPDLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239353AbhKPDLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 22:11:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F34261C4F
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637032104;
        bh=XkwvxJ2V1qOzMxs4myoHvEupFyCb+jBgdeX92l5YA1U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RNRjYiVvUX4/6auh0lsXo7zFlJpM7aYPz8Ju5r4lXZ4DlYby/e++AjTEEpzzdw87m
         g7SYLlgIII4nMRfN7pnfY7Bv88FCn2lZsz1RARJvC653wGp0AObPVodjvZ6Gc5tv9/
         TEPQCz9W1oIMQ8C1IN9tHA12/RVr3LVR2Rv//Kg3kUbnXO65bZwImZJjLZbyQ/mvkU
         plk5X3b9yllC/4gXCUpmD7AOh9DDZBTvtkooDSGkxiseNVjpfjHTvnC1TbzxNLwkxj
         AMNZUAAkCETRzI+gKjnpK8vFaPK2iIc2ZXrpKcwg6yE0cLJI/bYyRGV8e6kAkwvi/9
         JOLSU1zQ1CBRA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Tue, 16 Nov 2021 03:08:23 +0000
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
Message-ID: <bug-214967-11613-kpYowokcLj@https.bugzilla.kernel.org/>
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

--- Comment #12 from Matthew Perkowski (mgperkow@gmail.com) ---
(In reply to Damien Le Moal from comment #11)
> (In reply to Matthew Perkowski from comment #8)
> > (In reply to Damien Le Moal from comment #6)
> > > (In reply to Bart Van Assche from comment #5)
> > > > On 11/15/21 2:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D214967
> > > > >=20
> > > > > --- Comment #4 from Matthew Perkowski (mgperkow@gmail.com) ---
> > > > > Bisection has identified commit
> > 2360fa1812cd77e1de13d3cca789fbd23462b651
> > > as
> > > > > the
> > > > > origin of the issue.
> > >=20
> > > Hmm... It seems very strange that this patch creates the problem. Even
> with
> > > a bug, the worst that could happen is failing to detect NCQ priority
> > support.
> > >=20
> > > The problem is likely related to the errors "ata14.00: Read log page =
0x08
> > > failed, Emask 0x1" which come from the kernel trying to access a non
> > > existent log page (IDENTIFY DEVICE data log), which is tried when pro=
bing
> > > for NCQ priority support.
> > >=20
> > > libata ignores this error, not enabling the feature that was being
> probed.
> > > The mvsas driver may not.
> > >=20
> > > I posted a patch yesterday to prevent such access to log pages not
> > supported
> > > by the device. See:
> > >=20
> > > https://lore.kernel.org/linux-ide/20211115060559.232835-1-damien.
> > > lemoal@opensource.wdc.com/
> > >=20
> > > Can you try these ?
> > >=20
> > >=20
> > > >=20
> > > > This commit: 2360fa1812cd ("libata: cleanup NCQ priority handling")?
> > > >=20
> > > > Damien, can you take a look?
> >=20
> > I will try rebuilding with the patches at my first opportunity and repo=
rt
> > back.
>=20
> That would be great. Thanks.

Looks like your hunch may have been right on. I applied your patches to a f=
resh
copy of the 5.15.2 source (which was not working properly with my RR 2744 c=
ard
via the mvsas driver in vanilla form), and the issue did not arise when I
booted into it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

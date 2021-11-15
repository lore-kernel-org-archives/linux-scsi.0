Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0114C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3A963253
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242732AbhKPAAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356700AbhKOX4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 18:56:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BDF8061AFD
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 23:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637020434;
        bh=oiBNGtTCTKyRkb03qtzC8fozskbZu1sL82Crtn44vi8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jfPFaedAwFjywaN5SVTn0pAZ5zqMgFFGtLpy6mZuGYXNflSF0gU921Wvi9fnd7YaS
         1Rur/Fb0MR2n7mEb6pkuQ79RXB6AUrkNEJiA7WDL1rTBPYDJvPteH6S4R7DfUtB3oH
         /P61weKXJisPLhaPo/p8IuqnQWVr842ZV78CJQJXM4D0dJPkdUc2BEG4M45teFhqoM
         qkKLuicM7P//GS867uooifthqyXB9KPK/k8fi+X8A9R3qhgrgGd5xhQsdEa+4eCcNu
         lGEYNH+ryeasg53kLxQgA5cTkCudWGZHN7R6S1fHVDhYp05UD66/CMswrs4ppGifh+
         dkI/S12jCEQKg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 23:53:54 +0000
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
Message-ID: <bug-214967-11613-qJ0KkPU9vk@https.bugzilla.kernel.org/>
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

--- Comment #8 from Matthew Perkowski (mgperkow@gmail.com) ---
(In reply to Damien Le Moal from comment #6)
> (In reply to Bart Van Assche from comment #5)
> > On 11/15/21 2:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D214967
> > >=20
> > > --- Comment #4 from Matthew Perkowski (mgperkow@gmail.com) ---
> > > Bisection has identified commit 2360fa1812cd77e1de13d3cca789fbd23462b=
651
> as
> > > the
> > > origin of the issue.
>=20
> Hmm... It seems very strange that this patch creates the problem. Even wi=
th
> a bug, the worst that could happen is failing to detect NCQ priority supp=
ort.
>=20
> The problem is likely related to the errors "ata14.00: Read log page 0x08
> failed, Emask 0x1" which come from the kernel trying to access a non
> existent log page (IDENTIFY DEVICE data log), which is tried when probing
> for NCQ priority support.
>=20
> libata ignores this error, not enabling the feature that was being probed.
> The mvsas driver may not.
>=20
> I posted a patch yesterday to prevent such access to log pages not suppor=
ted
> by the device. See:
>=20
> https://lore.kernel.org/linux-ide/20211115060559.232835-1-damien.
> lemoal@opensource.wdc.com/
>=20
> Can you try these ?
>=20
>=20
> >=20
> > This commit: 2360fa1812cd ("libata: cleanup NCQ priority handling")?
> >=20
> > Damien, can you take a look?

I will try rebuilding with the patches at my first opportunity and report b=
ack.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6148C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F4A613AD
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 23:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347239AbhKOX3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 18:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhKOX05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 18:26:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B689461AA9
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 23:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637018640;
        bh=b4R0kfUtIeweqrKOXNC4gs6GVNQsa3swGz+wBqjsGlI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lp88DE2RF8pmAicRIwbzAmNkEHo513IKjtqbk/dRqw1ovUWmuhxb4g5rXKxqYb0VG
         GB+eM6hUOvSndBPEMUKxNrjwtqrnVa+hujccH2JdSmbzEdu82WZtPESiuNUDp2X7OR
         yyijdl+SqLgn4clb4wZACRr0sTYmi3YOaVVQ9imK0b5dyoC56SuKb5/zeg6qw+HJLT
         H5zTiFRssIU7aeXFrNPYTTDAr8/4lUQxNYL5rb/hHtnQR5C9usDUdDE8TacqB7V+nF
         xqMxvpbJEYOYpiE4dMWRg6MO4HvuzR3g7kLi5Rc71cmrdjU3FVVsUS/HVjAkRezPRm
         nJDX49NvQ4epA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 15 Nov 2021 23:24:00 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214967-11613-TGLiGevZzq@https.bugzilla.kernel.org/>
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

Damien Le Moal (damien.lemoal@wdc.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |damien.lemoal@wdc.com

--- Comment #6 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Bart Van Assche from comment #5)
> On 11/15/21 2:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D214967
> >=20
> > --- Comment #4 from Matthew Perkowski (mgperkow@gmail.com) ---
> > Bisection has identified commit 2360fa1812cd77e1de13d3cca789fbd23462b65=
1 as
> > the
> > origin of the issue.

Hmm... It seems very strange that this patch creates the problem. Even with=
 a
bug, the worst that could happen is failing to detect NCQ priority support.

The problem is likely related to the errors "ata14.00: Read log page 0x08
failed, Emask 0x1" which come from the kernel trying to access a non existe=
nt
log page (IDENTIFY DEVICE data log), which is tried when probing for NCQ
priority support.

libata ignores this error, not enabling the feature that was being probed. =
The
mvsas driver may not.

I posted a patch yesterday to prevent such access to log pages not supporte=
d by
the device. See:

https://lore.kernel.org/linux-ide/20211115060559.232835-1-damien.lemoal@ope=
nsource.wdc.com/

Can you try these ?


>=20
> This commit: 2360fa1812cd ("libata: cleanup NCQ priority handling")?
>=20
> Damien, can you take a look?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

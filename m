Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE17CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 21:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E731610C8
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 21:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhEDVXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 17:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhEDVXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 17:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7DF7F613DB
        for <linux-scsi@vger.kernel.org>; Tue,  4 May 2021 21:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620163371;
        bh=7gm4OTT58ENj5UD9r3SRiQoTVsFbnum9IebVlNtwZKs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qw7SQfAJj1kcV1pQlwkgNZBwgVwdPovsBVykX7LZ31cetbIGbTVohi50ubzj6bk1K
         EDNoAZcC3ua9Zuboi0AOaabTZlI1r4QsjtLyg+ntdX8daWJbz/SQCxSKCetuAGnZZp
         lt3cIJ4ht04zZhaxv+BU+gQXTQzjB6S5RB493DpDJaDfIu22aUnS21Nx94LCeoVqcA
         1rvQVcaktdN/I1wX9PNueHrP478mZoEgc6bLQAP3h/xIDuMqoDY9EofJmUxFy3xDpm
         yNjVP0h83/VI3+vdzAutdQ+PaZIJizOZ0RHlnBhUhkQ6XAwiwnFacs4ZS1/wGQG1HC
         ugHJvTKv5X+QA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Tue, 04 May 2021 21:22:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-y3qtRZZSal@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212337-11613@https.bugzilla.kernel.org/>
References: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

--- Comment #14 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #8)
> On 2021-03-18 3:14 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
> >=20
> > --- Comment #4 from Luis Chamberlain (mcgrof@kernel.org) ---
> > I'm afraid scsi_debug is filled with bug bombs bound to happen, because=
 it
> > was
> > written without certain consideration of races now coming up as tangible
> with
> > syfs / driver load. Namely, if you hold a lock at init and also use it =
on
> > sysfs
> > attributes you can easily deadlock. I discovered this issue first with =
the
> > zram
> > driver, and fixed the issue with try_module_get()'s on each driver sysfs
> > attribute, I posted patches for that, for discussion on that see the po=
st
> [0]
> > [1], although discussion is mostly on the first patch, the patch you wa=
nt
> to
> > look at is the second one [1].
> >=20
> > [0] https://lkml.kernel.org/r/20210306022035.11266-2-mcgrof@kernel.org
> > [1] https://lkml.kernel.org/r/20210306022035.11266-3-mcgrof@kernel.org
> >=20
> > I considered fixing scsi_debug in light of this, but given that module
> > initialization is *also* calling helpers used by syfs attributes, *and*
> this
> > is
> > also true at module removal, I'm afraid much more care is needed here. =
In
> my
> > patch to zram for the sysfs issue I mention ways to trigger the deadloc=
k,
> if
> > you're up for the task to fix that, it would be wonderful. But hey, the=
se
> are
> > separate issues. just figured you should be aware.
>=20
> In the hack proposed above, not much would appear in sysfs until that thr=
ead
> finished adding at least adding its first host by which time
> scsi_debug_init()
> should have long since finished.

The sysfs races are a bit more complex than what I think is being conveyed.=
 I
will Cc you on some fixes for zram which demo what the issues are, which are
generic, which I also think we need to fix in this driver. There would be t=
wo
issues:

 * the syfs deadlock
 * races against the private data which is type specific

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

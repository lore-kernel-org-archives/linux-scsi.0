Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D2BC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 22:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF7761431
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 22:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhEGWr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 18:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGWrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 18:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BFE161431
        for <linux-scsi@vger.kernel.org>; Fri,  7 May 2021 22:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620427582;
        bh=G+R074MR4ut3Jf789PHlnWEHDSzGdo/VT6ujK0Lly1w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hhlDBrAXp8U+jG9Jc023LF0JNkX2ZXPOxX4FlANYgdQkzEbn1mHu3AzPw60Os7XC7
         0Bq0WfmS1HGQdHzA4ISJ4euh58+QQF4yqSbZUn521SWVaWhZ6pP1sv0+9dfZQLpd8T
         G0pHbmSIgewuhVbNoqv0WgjrOpaTeqcQcJKBdGk+6/nhbhdmchgqHjCGLSXq0IfVmf
         1M0FvmoPuH2+DpLoEeZafKBiO4bQXVfC9ykk1z30T2iztcVuVEVV0bWtkx6ozRGdVy
         pMGCmGg0ZPlJ9fSICu0Ob/jl61uwBMdt2SrRoPNF6p+f2cJBWz6LZGPdSIYJR6zALP
         vJLi6+P39L4Mw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Fri, 07 May 2021 22:46:22 +0000
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
Message-ID: <bug-212337-11613-E7XfPLgpfP@https.bugzilla.kernel.org/>
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

--- Comment #19 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #17)
> I'm working on the rm_all_hosts parameter angle which lets me get in "und=
er"
> modprobe, as well as after scsi_debug_init() finishes ... lots of races :=
-)

OK so this would be a new generic sysfs knob, ie, independent of scsi devic=
es
it creates? So created and attached synchronously at init.

> If I can solve all of those, the reported problem may disappear.

If the solution includes a state machine to prevent *future* additions, *or=
* it
uses try_module_get() before allowing any new possible generic knobs (not s=
ure
if you are going to add some) I agree that this should work.

FWIW, just one minor consideration, just recall that distributions are now
using scsi_debug to do tons of testing both on fstests and blktests... So...
they'd benefit from fixing these races as a backport with the least amount =
of
changes as possible, and so if a fix is possible with the least amount of l=
ines
possible they can backport this fix so that tests don't run into so many fa=
lse
positives with tests.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

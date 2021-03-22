Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103CBC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B2B6199E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhCVSbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCVSbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 14:31:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8663761994
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616437867;
        bh=2c/HlueYEx3hPVMcEQDPkmDJKEmkX47ZE14oKG3V67M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hRdZV7eiYlOTJeozLIUB/ph8GhON59UptViwO6qR0nh9SHG3A8igbSaNwdELzJ4On
         RxODteWfIR1XSSftUYmaGzFAft2bip4djplqdkZQuWHM9+PP6mk8411fgkAStZdUy4
         iHa4q96tLmUJYznfHCL6IxjVvCiIDklrY3N7QOo+EPZrj91KqnoPJjNcqOSBunXA1G
         8NY74hGOeWzqSoYEBW3T+d/gZQir3DEN9lixoq/mRto8or0z8tcd+5X/+VY8JBSkan
         FQC0O53zvueh3YIb+nICbiKVvg2fJ8ZE96grvAI2GJW83+ZJFk0bkwcRhwQikxsHcb
         imJ3BtKkh2n/Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Mon, 22 Mar 2021 18:31:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-a4mJg3MrBm@https.bugzilla.kernel.org/>
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

--- Comment #11 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #8)
> On 2021-03-18 3:14 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> Addressing this issue first (i.e. loading things in scsi_debug_init() ). =
The
> bulk of the work is done in that function's final for loop. Would putting
> that in its own thread started by a workqueue help? If so, then
> scsi_debug_init() could complete reasonably quickly. That thread
> (called sdeb_add_hosts_thr, say) might still be running when a rmmod is
> attempted. How to handle that?

I don't think it would given we'd still move the race elsewhere. It would be
nice design though to do that in principle though. Then load can be done us=
ing
new sysfs knobs. But since we want to keep backward compatibility I can't s=
ee
how this can help.

> >> It would be an improvement IMO, if rmmod alerted the module
> >> in question when it rejects a removal attempt with "device busy".
> >=20
> > rmmod does just that when it can find that. In this case it can just
> provide
> > a
> > refcount.
>=20
> I'm looking for some callback that scsi_debug wires up in its init functi=
on
> that when called will try and stop things, or at least stop adding new
> things.

If try_module_get() fails the module can be in leaving state, that is, its
module removal is being called. But rmmod won't bother to call the unload
module system call unless the refcount is 1.

So, the way to avoid doing things when the module is leaving is to check for
try_module_get(). Other than that, one needs its own state machine. The rac=
es I
observed however likely could not be fixed with a new state machine though,
given the semantics would be the same. I can't see what other information t=
he
driver can get to prevent this race at this time.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

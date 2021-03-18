Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88418C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D3A264F01
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhCRTO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232479AbhCRTOi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 15:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD2A064F2A
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616094877;
        bh=rpUAKjgeiqwro3Cybe4zBQlO6BWba4r32Ef/gzqZL6U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IxgdJiSSEA/wkEr7lDaXBmsjGQrnN/x5pJP5BxUbkJUe/MQ9L1TCfd64ozXE9N7ru
         Hrw/vqIyXW/N9hWzqa6kv85s2mA/C24SRQ4HG5foiYaxkegHuOs/gy87GnTQ+vtF7p
         mve/UHsCjGo60JUIPoTo5rgL1OY81tNNPR4N9VHE+QMrH63g1dGzY0/LWOX3+dQKim
         mSI452uaegxTgA2hR7Em/+BU0eNXGJaNoG9TuBYdSRruQEt8NFEWeMdSdOa8RhyACr
         aMwICGubvr7g7T5t+5Yjgae8Y8YEV+PvU8lo5JpBtoAHff19qS/y7iicVD/UqZpNI5
         IsNPcSvrcTTMQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 19:14:37 +0000
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
Message-ID: <bug-212337-11613-X77yDAv8Xv@https.bugzilla.kernel.org/>
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

--- Comment #4 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #3)
> On 2021-03-18 1:38 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
> >=20
> > Luis Chamberlain (mcgrof@kernel.org) changed:
> >=20
> >             What    |Removed                     |Added
> >
> -------------------------------------------------------------------------=
---
> >               Status|NEW                         |RESOLVED
> >           Resolution|---                         |WILL_NOT_FIX
> >=20
> > --- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
> >=20
> > At first glance this might seem like a problem with scsi's async probe,=
 and
> > so
> > one might believe disabling CONFIG_SCSI_SCAN_ASYNC could help, however =
it
> > does
> > not. Linux scsi doesn't have semantics to allow only one driver to pref=
er
> to
> > probe asynchronously, but we can shoe-horn this in as follows:
> >=20
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 3cdeaeb92933..d970050ae866 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -857,6 +857,8 @@ static const int device_qfull_result =3D
> >=20
> >   static const int condition_met_result =3D SAM_STAT_CONDITION_MET;
> >=20
> > +MODULE_IMPORT_NS(SCSI_PRIVATE);
> > +int scsi_complete_async_scans(void);
> >=20
> >   /* Only do the extra work involved in logical block provisioning if o=
ne
> or
> >    * more of the lbpu, lbpws or lbpws10 parameters are given and we are
> doing
> > @@ -6851,6 +6853,7 @@ static int __init scsi_debug_init(void)
> >                          }
> >                  }
> >          }
> > +       scsi_complete_async_scans();
> >          if (sdebug_verbose)
> >                  pr_info("built %d host(s)\n", sdebug_num_hosts);
> >=20
> > Even with this present though we still have he refcnt issue. A better w=
ay
> to
> > see what is going on is to trace the kernel module calls after boot and=
 see
> > why
> > perhaps certain refcounts for the module are high at times and why they=
 are
> > not
> > in most other cases.
>=20
> Hi,
> Interesting analysis. There have been many changes to the scsi_debug driv=
er
> during the last 6 months, but none that I can remember in module
> initialization area. Do you think this is a problem introduced by those
> changes or may it have been there for a longer period?\

This problem has existed since it was decided to do loading of things at in=
it.
Its a terribly bad idea t do a lot work at init.

> Could it be that
> the scsi_debug driver is exposing the async nature of the scanning code.

Nope. That's not it. I tried by disabling async scan and also forcing it as=
 I
mentioned by exporting the function to wait.

> Of course, commencing device teardown during an async scan is stress test=
ing
> that code.

I'm afraid scsi_debug is filled with bug bombs bound to happen, because it =
was
written without certain consideration of races now coming up as tangible wi=
th
syfs / driver load. Namely, if you hold a lock at init and also use it on s=
ysfs
attributes you can easily deadlock. I discovered this issue first with the =
zram
driver, and fixed the issue with try_module_get()'s on each driver sysfs
attribute, I posted patches for that, for discussion on that see the post [=
0]
[1], although discussion is mostly on the first patch, the patch you want to
look at is the second one [1].

[0] https://lkml.kernel.org/r/20210306022035.11266-2-mcgrof@kernel.org
[1] https://lkml.kernel.org/r/20210306022035.11266-3-mcgrof@kernel.org

I considered fixing scsi_debug in light of this, but given that module
initialization is *also* calling helpers used by syfs attributes, *and* thi=
s is
also true at module removal, I'm afraid much more care is needed here. In my
patch to zram for the sysfs issue I mention ways to trigger the deadlock, if
you're up for the task to fix that, it would be wonderful. But hey, these a=
re
separate issues. just figured you should be aware.

> It would be an improvement IMO, if rmmod alerted the module
> in question when it rejects a removal attempt with "device busy".

rmmod does just that when it can find that. In this case it can just provid=
e a
refcount.

> To stop any higher levels setting up SCSI devices before the async scans
> are complete, the scsi_debug can set TEST UNIT READY to return an error
> along the lines of: not ready, device in process of becoming ready

OK cool, we could try this, but I'm afraid it would not fix the issue, given
that you may have userspace applications such as multipath mucking with the
device on init, and you won't know when its done. So I still think that the
onus is on userspace here.

Ideally I'd actually just remove the damn setup stuff on init, but since we
have old users, I'm afraid that's not possible now. Granted, scsi_debug is a
developer tool, so perhaps its OK to deprecate that. But still, you end up =
with
the same requirements to verify the refcnt is 1 before trying to remove it.

> BTW that is what real devices do, but scsi_debug does not do that by defa=
ult.

Why not?

> The scsi_debug module option that is already in place is:
>    tur_ms_to_ready: TEST UNIT READY millisecs before initial good status
> (def=3D0)
>=20
> So it's just a fixed delay at the moment. Perhaps you could experiment wi=
th
> that
> option to see if it improves things.

fstests / blktests relies on scsi_debug for a few tests, we need a solution
documented / in palce for both upstream / older kernels. If setting the
not-ready thing on init works, we would still need to verify a solution for
older kernels.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

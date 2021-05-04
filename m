Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE741C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 21:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F57F610C8
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 21:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhEDVTS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 17:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhEDVTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 17:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9F95613C6
        for <linux-scsi@vger.kernel.org>; Tue,  4 May 2021 21:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620163102;
        bh=SlQWr+q+QcZivMulldFb6jYEHQQ6HC/NeIk8zBuK49Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JQ48u2QFYlk2Zz/6YscnrvEIyk8f8OEJfqnqFTmm4kvxbxToOOrsBT5bceMCVIBtM
         eiBVRpPRSYl8YjekwdGNqvmf4gQBSRFOYds1/iQ1fWjE3nbx4lk+wxYE6co4Ni5OKt
         j8E1yY7i7zCyOFVJCmtMkpOYBIxdOjLT1b0vToa6JPuFFBHKfw9bz2d2Wp/zxglid+
         JVR3VPLEELFZe9uVPK34P3o7uPbM+OIFPh9jDvT1gOzvRA1WHnHMnLCzNftA6pSdYH
         BXWiAS97Y0qn2QTBx5ZsXhEkDkNFIKTqZeK/GRV0e6tNK3MXhxNaguBaZIyh10hCPE
         zs+fjQspcbs5w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Tue, 04 May 2021 21:18:22 +0000
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
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-212337-11613-HvylxRWG7p@https.bugzilla.kernel.org/>
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

Luis Chamberlain (mcgrof@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|WILL_NOT_FIX                |---

--- Comment #13 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #12)
> On 2021-03-22 12:23 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
> >=20
> > --- Comment #9 from Luis Chamberlain (mcgrof@kernel.org) ---
> > (In reply to d gilbert from comment #8)
> >=20
> >>>> The scsi_debug module option that is already in place is:
> >>>>      tur_ms_to_ready: TEST UNIT READY millisecs before initial good
> status
> >>>> (def=3D0)
> >>
> >> You asked how it works, try:
> >>       modprobe scsi_debug tur_ms_to_ready=3D20000
> >>
> >=20
> > That does not resolve the rmmod race against insmod:
> >=20
> > scsi host2: scsi_debug: version 0190 [20200710]
> > [   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statis=
tics=3D0
> > [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug=20=
=20=20=20=20=20
> 0190
> > PQ: 0 ANSI: 7
> > [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
> > [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
> > [   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statis=
tics=3D0
> > [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug=20=
=20=20=20=20=20
> 0190
> > PQ: 0 ANSI: 7
> > [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
> > [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
> > [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
> >=20
> > Then we wait...
> >=20
> > [   44.308213] ...................ready
> > [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> MB/8.00
> > MiB)
> > [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
> > [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enab=
led,
> > supports DPO and FUA
> > [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
> > [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
> >=20
> > And then rmmod still fails.
> >=20
>=20
> Just to explain a bit more about tur_ms_to_ready, that does not effect SC=
SI
> commands like REPORT LUNS, INQUIRY and REQUEST SENSE, but does slow down =
all
> "media access" commands including TEST UNIT READY (TUR) and READ CAPACITY=
. So
> if you watch what is happening with 'lsscsi -s' the device (LUN) will app=
ear
> almost immediately but its size will be "-" due to the fact that READ
> CAPACITY (or TUR before it) is waiting for tur_ms_to_ready to elapse. Aft=
er
> that the size (for disks) will be shown by 'lsscsi -s'.
>=20
>=20
> When you say 'rmmod still fails' do you mean it refuses to remove the mod=
ule
> because the device is busy?

Yes. The refcnt must be 1 for rmmod to work. If it is not it will fail.

> If is busy, where is the race?. What precisely
> would you like to happen? What does a real SCSI HBA do?

That's the thing, the trace on comment #1 does not exactly show who to blam=
e,
but there seems to be only two possibilities: systemd and multipath. Regard=
less
what is clearer is that once the device is exposed we *cannot* block usersp=
ace
from poking at the device. The best we can do, is udevadm settle, however t=
hat
still does not guarantee userspace things like multipath won't try to poke.

> Is there any way that a driver can detect that rmmod has been called and
> rejected?

Yes! try_module_get() would fail if rmmod was kicked off.

> If not, we could add  a "shutdown" writable attribute in
> /sys/bus/pseudo/drivers/scsi_debug/ . Then if a large number of pseudo
> devices is being built due to the modprobe invocation, the driver can go
> into reverse by checking that attribute before it adds another host
> (target or LUN?). After shutdown, the driver is still active, just with
> no hosts, and thus no LUNs. A more accurate name would be rm_all_hosts .

This may work actually, and so new users who would want to avoid this race
would have to issue this call prior to rmmod. That would remove the possibi=
lity
of a race. Let me know if you have a patch I can test. Putting this as
re-opened.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C93FECAAA0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 20:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiHYUbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 16:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243654AbiHYUbG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 16:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A82ACA31
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 13:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FA31619B0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 20:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF7D9C43156
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661459463;
        bh=GfsOKZ9Ae9KzLHZOFlaPw2hGn1XfF6MJD3zInB0Leqg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ntRnKFMxhL+6bkMYEifAGWYiReug74li/9MW8QBMeKW9OYqCNDzdQRR7uYfvMTOIy
         XIyQ282fUBPvG9iz1ypeDpvnwdeoQlfyQMpNdRMaGdoHY/f9D5G2RO6KqS91ow30+V
         zEBq+vk9KaiVPXJoGQ8UAuoD9SG+hkzQwKUScX34V+dIrLCAKp/5FTep0P1TCaE477
         or8UzpMosMV1n96T97i9TGzIijLrZQc6Rdu8A3KMM7ze7snXlJ7xVAXzJIHmITNy0y
         yRSeSPaxP8L1hj09ZpsGcuvgZDu4aDNiOJCZcMuxSadWoCWwJY7sE9ZGIuj5F4VDrn
         NArMZ7MUgAiRA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B0B12C0422E; Thu, 25 Aug 2022 20:31:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 25 Aug 2022 20:31:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-145qj6CvR1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #37 from Bart Van Assche (bvanassche@acm.org) ---
On 8/25/22 13:01, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>=20
> --- Comment #36 from jason600 (jason600.groome@gmail.com) ---
> (In reply to Bart Van Assche from comment #27)
>> Thanks for testing! The patches from the sd-resume branch have been post=
ed
>> on the linux-scsi mailing list. See also
>>
>> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@acm=
.org/
>> T/#t
>=20
> Hi Bart, just an update for you. I noticed this had been removed from the
> 6.0-rc1 for freezing after suspend.
>=20
> I've been compiling my kernel with this fix on various 5.18 kernels (with
> opensuse tumbleweed), it has worked fine, no freezing on resume as others
> have
> mentioned.
>=20
> Yesterday, I updated to 5.19.2 kernel, applied the fix, recompiled, and it
> froze after the first suspend. Rebooted and the same thing happened again=
. I
> recompiled the kernel with the fix, just to make sure i didn't mess it up,
> and
> the same happened again.
>=20
> When you originally did this fix, you based it on 5.18, and indeed, it wo=
rks
> fine on 5.18 for me. There were a lot of changes to the drivers/scsi/sd.c
> file
> for 5.19, presumably it was those changes that made this fix start freezi=
ng
> after suspend.
>=20
> Perhaps you could check if the other people that experienced freezing were
> using either 5.19 or 6.0-rc1.

Multiple people reported issues with freezes during suspend with kernel=20
v6.0-rc1. Please take a look at the following report:=20
https://lore.kernel.org/all/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.com=
/.=20
It shows that if zoned ATA disks are present that blk_mq_freeze_queue()=20
may be called from inside ata_scsi_dev_rescan() on the context of a work=20
queue. ATA rescanning happens from inside the SCSI error handler. So=20
there is potential for a lockup because of the following:
* Execution of the START command being postponed because the SCSI error=20
handler is active.
* blk_mq_freeze_queue() waiting for the START command to finish.
* The START completion handler not being executed because it got queued=20
on the same work queue as the ATA rescan work.

Unfortunately I do not know enough about the ATA core to proceed. I need=20
help from an ATA expert.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

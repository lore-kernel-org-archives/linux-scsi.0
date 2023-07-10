Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39929EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 00:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjGJArS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 20:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJArR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 20:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF297106
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 17:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 722BB60CF9
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 00:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4C54C433C7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 00:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688950034;
        bh=4gFf7ggiqduhbdFXL3z8bdQ1h3FOARQVm5lyEpk0r8I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=avPfO+TMkxnzjdSjjW18/0Q57cvUiz5KhF9Yw7T0nJ+4RlmijkBfpQOgH5N38eLCd
         wbjWGSMDiESjFXg4HDuH5J/oLSXSL6Uws9X1fHzkoPpz2C++lgk43JT+EU+xNgALeY
         Q/R534An9Y0VUbIoLHao6sx4qQlnMGDgrdHyWKscpuNeH1Woqtg6fTKj4UOyUQoDjF
         3EG07Pgbi+iXNGcuduxb1hdE2XnEPzoMc8X2cZD/HjgP43SNcSFqI5zyVsDbQRVNwH
         W/sWyXtRV0Qfc3YPsiVfM7lnkODNTuNOdeqo4g6jyb50KBeGsoy4QubycBNBjak7hu
         F53HvAt9HVRGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C59E6C4332E; Mon, 10 Jul 2023 00:47:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 00:47:13 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-VD3AeoasF7@https.bugzilla.kernel.org/>
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

--- Comment #48 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Paul Ausbeck from comment #47)
> The PCI/GPU messages are only connected to the ATA messages in the sense
> that the PCI/GPU activity is unexpectedly deferred until after ATA init is
> complete. Since resuming of devices is supposedly asynchronous, one would
> have thought that PCI/GPU init activity would be completed long before hdd
> spin up is complete.

Maybe try enabling PM debug messages ? That could tell us what is going on.

> I realize that deferring drive spin up until needed would not be easy,
> that's why I called such an idea a tour de force. In the past it may have
> been common for an ata device to not resume reliably, but today even the =
10
> year old ata devices on my Ivy Bridge machine resume just as reliably as
> they normally operate, which is quite reliably. If it weren't for power
> outages, I'd have years of continuous uptime. It's just a thought, but it
> may be time to revisit how disks, especially spinning disks, are resumed.=
 It
> seems to me that the chance of a hdd failure during resume is not any
> greater than at any other time. It should be theoretically possible to qu=
eue
> up resume commands and execute them only when needed to service actual
> demand. The latency would have to eventually be absorbed, but if the api's
> are designed and implemented properly that would just happen when needed.

Spinning up the disk on resume is needed as many drives require the disk to=
 be
spun up to reply to commands, and that even applies to commands that do not
access the media (e.g. IDENTIFY, READ LOG, etc). The reason is that many dr=
ives
save their meta-data on a reserved area of the media (the spinning disk).

So even if the kernel were to explicitly defer spinning up the disk, the di=
sk
itself would in many instances automatically spinup, and that would manifest
itself with a long delay to the reply to the initial IDENTIFY command issued
during the rescan initiated by resume. And delaying that rescan is also not
desired as that would force the PM code to report "OK, this device is resum=
ed
and ready" while it is in fact not ready at all to receive commands. So the
"tour de force" is really not desired at all in practice.

You likely can avoid the hdd spinup on resume by soft-removing the device
before suspend. Then we could add a libata option to ignore some ports on
resume so that they are not probed. But then, reusing the drive after resume
will require a manual rescan for the disk to show up again. And all of this
also assumes that there is no file system mounted on the disk, of course.

Given that most laptop these days do not use HDDs anymore, I do not think a=
ll
of this is worth the effort.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

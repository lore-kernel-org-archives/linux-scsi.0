Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6464EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 00:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjGJASh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 20:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJASh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 20:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4717C114
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 17:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93AE60C98
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 00:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15989C433B7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 00:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688948315;
        bh=I30S8ig4oRDJuoxagfg1eveu/FrFmi8AkoekK+OVaY8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j30T8gtrBYmTZcZkJLZK80oGz7xzHNFMpFeBWLS3quHA15Djl/KtLhBc+BZOUZ1Wz
         V3ClauAtTFuRfyPGUkqgi9OHE/xjEGHoYWeAuxSONr3L1FADX4kS6CmOj6RoZw+jPn
         VfY52zzOGrjzokcaLE+FyGHV3owoWCjAiOfi+B8hAAcToHCoohwXoT2U6dqA6Xj+lt
         ZuHpAsxaEXaMpUgga1hjdM797M6murIQmUxQebTjhz9981bqEuOM76j+ISB1QVCkPH
         n+hcHqY9YVeMvJYHm7GsqYg2dM2F4UrlIFMWd4CkDHlTIdtak+ona6saCSBtZr8BAz
         biQ4J9jPZTy9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 07462C53BC6; Mon, 10 Jul 2023 00:18:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 00:18:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: paula@alumni.cse.ucsc.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-mYslUXsAQN@https.bugzilla.kernel.org/>
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

--- Comment #47 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
The PCI/GPU messages are only connected to the ATA messages in the sense th=
at
the PCI/GPU activity is unexpectedly deferred until after ATA init is compl=
ete.
Since resuming of devices is supposedly asynchronous, one would have thought
that PCI/GPU init activity would be completed long before hdd spin up is
complete.

I realize that deferring drive spin up until needed would not be easy, that=
's
why I called such an idea a tour de force. In the past it may have been com=
mon
for an ata device to not resume reliably, but today even the 10 year old ata
devices on my Ivy Bridge machine resume just as reliably as they normally
operate, which is quite reliably. If it weren't for power outages, I'd have
years of continuous uptime. It's just a thought, but it may be time to revi=
sit
how disks, especially spinning disks, are resumed. It seems to me that the
chance of a hdd failure during resume is not any greater than at any other
time. It should be theoretically possible to queue up resume commands and
execute them only when needed to service actual demand. The latency would h=
ave
to eventually be absorbed, but if the api's are designed and implemented
properly that would just happen when needed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

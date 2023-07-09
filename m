Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F261EB64DC
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 07:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjGIHJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 03:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGIHJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 03:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B500B1B1
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 00:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 336C560BA4
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 07:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89488C433B9
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 07:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688886541;
        bh=bKhEKQ4yFWAWPDm5XhChx/IghtXpd2EJfoHER9QewVI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oS5SiFDWPAtubCVEc8P9mu8cSpDE0TmirTmnLc4fNwYeTOtHhsXXLUDAGITvGzeet
         wqbDPwLXJYbARMlvkP8zMQPag2wrT+uPxv0iM9qohy4jA2r4HU6nlU9TW5ztSyatcp
         8tRtcxBqfEv5OUZdBK2i2hudLVgC/NS5/3ktk7TsID2JOt5j+uwYx+CGex81j3cgbQ
         TN4d5dVA+djm8gMNv1o814kj2V6JPLZ91JVmiZaRUWyH65rQ3d1/WLBNZXTuXoDmsG
         sGf5YfK5Z2xoLKWowbwZozWT21wPwek1enFf2D+ifx6thkZYGz1/x4Yh94PZZIaULL
         EMp9o+kejUZ/w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7C6E4C53BD2; Sun,  9 Jul 2023 07:09:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Sun, 09 Jul 2023 07:09:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-BtcguYzNhs@https.bugzilla.kernel.org/>
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

--- Comment #45 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
(In reply to Paul Ausbeck from comment #44)
> I'd like to add that I've also noticed this regression after upgrading fr=
om
> Debian 11/5.10 to Debian 12/6.1

Can't remember for sure (Bart and Damien might), but I think this issue sho=
uld
have been fixed by this revert that went into 6.0:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D785538bfdd6

So if you see similar symptoms it's likely a different issue. You thus might
want to open a new report, as things otherwise get messy; it's also in your=
 own
interest, see:
https://linux-regtracking.leemhuis.info/post/frequent-reasons-why-linux-ker=
nel-bug-reports-are-ignored/
especially
https://linux-regtracking.leemhuis.info/post/frequent-reasons-why-linux-ker=
nel-bug-reports-are-ignored/#you-reported-your-issue-in-a-reply-to-an-earli=
er-report

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

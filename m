Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876A3C001B0
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 18:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjGVSsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jul 2023 14:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGVSs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2023 14:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C226B5
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 11:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 580C860BB9
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 18:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE6BDC433C8
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690051705;
        bh=VB5eZ4/DwRyvl2CRIonQUD3WQYAG3rcH0oFj+m39onE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WWWk/Hecggnj0wcbm0/WZCPzmtW8KaQ1wL31FbAdOGE4Ik6vAAsQC+E6qOkzG3dgo
         YbU4L6ycNQnJDGJ+RW+OyWfCllExeuGlWGF0OlO+xvqCasd9BRr7lGxedPOLXR4NVu
         UQguCdHaqoM5kK21Bk+KiNlgUNcearYA2xz2Z5e7frU/BrZo7io8BwvhHFYnZxPsKX
         tMnQDTAFk4dAz2hQ4DIrZOJhnda8W8NBxrowWpR74q+jdC9J1IZY3tiDvxM4mSE2Zg
         WMlqwTgJXdpUbVuJ2kl6JterWf8ybCscKrWVkwTfaX3NPaT2JBWlfW0lnbhqRRBUmV
         jD1DwizhNEkAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8EC37C53BD2; Sat, 22 Jul 2023 18:48:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sat, 22 Jul 2023 18:48:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-NZylQYr9A1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #7 from pheidologeton@protonmail.com ---
One more observation. If you disable the controller write cache (set wt) in
arcconf settings, this problem is not observed, but the random write speed
drops 3-4 times.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

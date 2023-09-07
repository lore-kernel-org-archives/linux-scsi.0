Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E6EEC875B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 21:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbjIGVir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 17:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjIGViq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 17:38:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF08EE47
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 14:38:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47E65C433C9
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 21:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694122721;
        bh=GnMxwugKtq6Q82NRfgIpUdxkYpob2yH6Z4myjghPyJ0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Y9rM+47+K5NBqr84U7No4BVxnBRMr8bPQK6TMHz9B0Ngkvp1O3NN1QQGZLW+5v5N+
         tAtQFX0SXyD765SJvYYltVI8oRw9S80N0uS/9GexSn5+VrwrIYHGUOf4qAGxNVl8S/
         1/BJKBMh01+zYb0VEcWbwDNhPPFBmtIDmNVjNAYpEmTFgioMhrjNQGUXY6boyed76q
         Rf83uAzYpg6pYqSy8c5jOxgSt99dgwpKRvOXGxLXKaEsw9KJWoWi48Mq2MfKaELYKi
         jU2ETrxW4z4qSL/p5iZImIOUB5s/esLtsTojUmnie2081JO3qy7qtjdoboA5gz0ycL
         qydWYJ+YE3HFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 305F5C53BD0; Thu,  7 Sep 2023 21:38:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 07 Sep 2023 21:38:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maokaman@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-RJ9T4TqQFC@https.bugzilla.kernel.org/>
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

--- Comment #18 from Maokaman (maokaman@gmail.com) ---
(In reply to Sagar from comment #17)
> Hi Maokaman,
> Could you please provide additional details on which specific kernel you =
are
> seeing this issue on and the details of the server would also help us?
>=20
> We tried with 6.4.9 kernel on a 81605 controller and we do not see this
> issue on our setup.
> We are trying to understand the environment=20
>=20
> Thanks

Hi Sagar,

I've tested multiple 6.4.x kernels and the last one was 6.4.7.

Distro: Arch Linux

Kernel build script:
https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/ed40=
dc54e86cec6758ee43684f0fd37d78c5ba53/PKGBUILD

Kernel config:
https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/ed40=
dc54e86cec6758ee43684f0fd37d78c5ba53/config

# cat /proc/cmdline
initrd=3D\intel-ucode.img initrd=3D\initramfs-linux.img
root=3DPARTUUID=3D"5029e4ab-f734-4729-97b2-99eb53de8b0a" rw intel_idle.max_=
cstate=3D1
idle=3Dhalt transparent_hugepage=3Dnever mitigations=3Doff audit=3D0 selinu=
x=3D0
nmi_watchdog=3D0 nosoftlockup=3D0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6C1EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 21:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjGTVwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 17:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGTVwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 17:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D91719
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 14:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED5961CB4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 21:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B540C433C8
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 21:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689889936;
        bh=nUnelXWb9R2xbMJJ2OwmRkJlawIGEX+BG98EuTLU0Xk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KG90CIXIcZ1LJWvi+HpHfi8ScrDkaiuL8n0oZUBrh9SB98aWuClKidhLAM4TCUSCv
         /CkuPUBpe//izt/8Lp2kcCRV+8ykROPfLaVPl6yFaFx9wzeZnW+1JSTAWQ4HBTXwBp
         uY0kQb3WQYdDLdHS/AhM+ZPD1aY0tLVYJqAENum42qamOxYGgUq6nHe/1gusU0mX1w
         weZWfmO5ROAItFXwjdNlcJetzSlSrTYQIpzqqVMexL/tGkjZ8ugBWWZqmyq8LM2/YZ
         lWHPJbvH9SQmhqIfSkKEA0aeVeKumtHxSCorMTYh78vD++EV7O3W/AbVGw9rcnLoNT
         ApRYbavsM5SUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2CE89C53BCD; Thu, 20 Jul 2023 21:52:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 20 Jul 2023 21:52:14 +0000
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
Message-ID: <bug-215880-11613-L7fnF2ByyJ@https.bugzilla.kernel.org/>
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

--- Comment #57 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
The m.2/SATA to 7pin SATA adapter that I mentioned previously as on order,
arrived. Using this adapter I connected a spare Barracuda 4TB drive to one =
of
the m.2 slots on my Chuwi Gemibook Pro laptop. With this setup, the lack of
mouse pointer interactivity on resume exhibits exactly the same as on my In=
tel
dh77kc desktop.

The mouse pointer is not interactive until after "PM: suspend exit" is writ=
ten
to the kernel log. Additionally, an active GUI terminal is not interactive
until the same time. This is noticeable by typing "sudo pm-suspend" in a
terminal. The resulting CR/LF and next command prompt do not appear followi=
ng
resume until the same time that the mouse cursor comes alive. The Barracuda
drive connected to the Gemibook isn't as slow to spin up as the relatively =
old
WD 2TB in my desktop so the delay to interactivity is only about 5 seconds
instead of 10+.

The interactivity delay is present on both machines when using kernel 6.1x =
and
not present on both machines when using kernel 5.10x. When using kernel 5.1=
0x,
the dmesg log on both machines shows "PM suspend exit" happens before the
slower ATA drives are "configured for UDMA/133". When using kernel 6.1x, the
dmesg log shows "PM suspend exit" occurring after the slower ATA dries are
"configured for UDMA/133".

At this point, I am convinced that this is a regression related to changes =
in
libata. I will take this offline now to see what I can do to help recover t=
he
previous resume interactivity behavior.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

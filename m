Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0605EECAA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 20:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbiHYUCA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 16:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243445AbiHYUBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 16:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F179BFE95
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 13:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84EDBB82A37
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 20:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B5DDC43149
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 20:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457702;
        bh=ItJgtvtWYTddSaq7yjoRbvseyOBZPBJgymBWe26y2mk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=f+VF+YpZnxQOsYC8o61tHTcaoC250JOWsBldK0CyQYs1L425Rh6nkwHXx+3Ar2aea
         Tj1ikOG54c/7r67X19rX5Bzyy5Nn0YrJlOJEgrhAaU6AA14vr35K9nwRnhWZ46Vmlc
         9FaLkOnRpNsUClAfjA2BXSSfmOWuc9t9fkm482D9jdb8YGDEitC9n4RVeeXTlRz+ZB
         d2qcUj87Tq5/T5E24rTEGNit0Qc4x1hXRA4UBos5DVk9lLLamexhQibqmbhN3tWDv7
         Cm5h1UEOeLlFccO2FXFy6tL9yUDHLDg4hlIkZxgzH0GbxxoNxDN8OnuZZ7dQok8//l
         BpmBDzvhSmDug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2E040C0422E; Thu, 25 Aug 2022 20:01:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 25 Aug 2022 20:01:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jason600.groome@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-XJtmKDzTFo@https.bugzilla.kernel.org/>
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

--- Comment #36 from jason600 (jason600.groome@gmail.com) ---
(In reply to Bart Van Assche from comment #27)
> Thanks for testing! The patches from the sd-resume branch have been posted
> on the linux-scsi mailing list. See also
> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@acm.=
org/
> T/#t

Hi Bart, just an update for you. I noticed this had been removed from the
6.0-rc1 for freezing after suspend.

I've been compiling my kernel with this fix on various 5.18 kernels (with
opensuse tumbleweed), it has worked fine, no freezing on resume as others h=
ave
mentioned.

Yesterday, I updated to 5.19.2 kernel, applied the fix, recompiled, and it
froze after the first suspend. Rebooted and the same thing happened again. I
recompiled the kernel with the fix, just to make sure i didn't mess it up, =
and
the same happened again.

When you originally did this fix, you based it on 5.18, and indeed, it works
fine on 5.18 for me. There were a lot of changes to the drivers/scsi/sd.c f=
ile
for 5.19, presumably it was those changes that made this fix start freezing
after suspend.

Perhaps you could check if the other people that experienced freezing were
using either 5.19 or 6.0-rc1.

Hopefully, this information might help in finding the cause and re-fixing t=
his
issue.

Thanks for all you help

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

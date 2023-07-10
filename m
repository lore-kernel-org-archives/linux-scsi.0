Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25746EB64D9
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 22:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjGJWsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 18:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjGJWsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 18:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF6DF
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 15:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4015E6123D
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 22:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E032C433B7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689029328;
        bh=0YjaXKVDRyQA28A7Xvk/Uc8GpRUeRQA0f9Dz5tuAzLo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oESInfbQv6l4GOdOINS/H6qZtvybjF8FrUlkUXZIOOIC5AaUshioGLXLfLlRTURjp
         BZ2LiWc3R5/njQwM8yreeSk1ldIiCtarowM5x/Fo9eutNJoWs9ZUzVDDaFt586v6wC
         0Zl4I5cthr/0gEQsx33zIG0cHHAdWfIkNTpmg5XGtx2f1pugcSCHtLxV9GFpYn3qRv
         2dGOXr/l1SOodZk3EKG8qW9i+kQ3Wn2bj0KYNvUMD5kW4yzMEc4xZFdVSm1amkjrq9
         pyanStr76O1Fg9/9suknDtZS6bkuKiqZJ/B2jPG/1vy+QklaaWxYTpI7dz/imE59qE
         Uv8lvk8T74PZQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8EF97C53BD1; Mon, 10 Jul 2023 22:48:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 22:48:47 +0000
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
Message-ID: <bug-215880-11613-CrBdC4yZ5E@https.bugzilla.kernel.org/>
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

--- Comment #54 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to Paul Ausbeck from comment #53)
> I sense that we are in disagreement. In my way of thinking disagreement is
> overcome through logical argument. So here goes.
>=20
> I argue that you can't call a bug fixed if the fix introduces a serious,
> entirely separate, regression. I further argue that at resume the mouse
> pointer should be interactive at the same time that the display becomes
> active. I further argue that if the mouse pointer is not interactive at a=
ny
> time that the display is active, that is a serious UX bug. I further argue
> that before the recent kernel ATA changes this particular bug did not exi=
st
> and therefore it is a regression. I further argue that though the regress=
ion
> is UX related it cannot be patched over outside of the kernel. I further
> argue that this regression likely affects any personal machine that conta=
ins
> a spinning disk and that this class of machines is substantial in size. I
> further argue that your reported deadlock between ata resume and scsi res=
ume
> likely affects a far smaller class of machines. I further argue that thou=
gh
> for a single machine deadlock is a more important problem than temporary
> lack of mouse pointer interactivity, for the kernel as a whole, problem
> importance is proportional to the multiplication of the individual
> seriousness and the size of the set of affected machines. I further argue
> that your assertion that the non-interactive mouse pointer is not related=
 to
> the libata resume changes is incorrect. I further argue that the two dmesg
> fragments that I have posted to this thread explain the situation quite
> clearly.
>=20
> My argument contains 10 assertions. If you disagree with any of them, ple=
ase
> give details. In particular I don't have a clear idea of the size of the =
set
> of machines that might experience the "fixed" ata/scsi resume deadlock.

Repeating the same things again and again without new technical information=
 we
(developers) can act on is not very productive. So let's dig into this issu=
e to
verify *if* this is really an issue introduced by libata, which as I said, I
doubt it is. But let's make sure. So could you please try the following:
1) Build the latest 6.5-rc1 kernel from git and try with that kernel to see=
 if
the issue is still there.
2) If the issue is not resolved, with that same kernel, please try to revert
commit 6aa0365a3c85.
3) Regardless of the result for (2) please do a bisect to see if the commit
responsible for the issue is indeed 6aa0365a3c85. You can find information =
on
how to do that in the Linux documentation at
Documentation/admin-guide/bug-bisect.rst. You may also want to read=20
Documentation/admin-guide/quickly-build-trimmed-linux.rst
4) Please provide the output of lspci and a full dmesg for your system. dme=
sg
output after boot and after resume would be helpful.

With the above information, we will likely have a better idea of what is go=
ing
on with your machine.

Also please know that the number of machines affected by an issue only
determines the priority/urgency of a fix. Even if a single user is affected,
issues will still be addressed as long as enough information is provided and
the person affected helps with testing (as I cannot recreate that issue with
the hardware I have).

Note that I am on vacation this week, so I am only checking emails and repl=
ying
as a courtesy. I will not do anything until Tuesday next week.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

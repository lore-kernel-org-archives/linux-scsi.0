Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3CFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 23:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiJFXsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 19:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJFXsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 19:48:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB2B2611E
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 16:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AAFC0CE1770
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 23:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C157DC43147
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665100088;
        bh=vCFWEwOklr6JTV822Mv2hV+07ZV6Qdc4KMnKDUunrnQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NeQTc9LTnV3uXakxE3DbmtWJpsMAVjWySZLd5LhzFFn57GonK2zEWHUN2/DyLrQz5
         sBEVd0BfKzz3NM8PDrINLBTd+MG4wt3BDEtulLdx1k/rLfsWD9VkqBg2krVxLtHLZA
         xB5J1SBUhING5sjNPnHTnRaKrE3c9ye9KVK+Dlx5TGNvwmvI9oEmVRBflmCvNEHKuR
         V7gXmFgtpNFAV/eJvCH1F/v4XwJdf/0N3yEsTEMaVPWvtCEkZj9bGlSBSM9+FwJneH
         zZnG8b04C6y8KpMToV+uJwfmR9/CTroSUEHtEqMgX2UPqSu7zDhoUSr+cLP60CDzd2
         jESWdBmVFihyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ACDE1C433EA; Thu,  6 Oct 2022 23:48:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 06 Oct 2022 23:48:06 +0000
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
Message-ID: <bug-215880-11613-KcuVjbAg8M@https.bugzilla.kernel.org/>
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

--- Comment #41 from Damien Le Moal (damien.lemoal@wdc.com) ---
(In reply to jason600 from comment #40)
> I have been using Damien Lemoal's patch for the last couple of days on
> kernel 5.19.8, it works fine for me, and no obvious issues.
>=20
> I also tried in on kernel 6.0, again works fine and no obvious issues.
>=20
> (In reply to damien.lemoal from comment #39)
> > I am not sure at all this is correct though. This actually may break ot=
her
> > suspend/resume flavors. If we could somehow synchronize scsi pm resume =
to
> > run *after* ata pm resume, all problems should go away I think.
>=20
> With regard to Damiens comments, and the problems with this patch last ti=
me
> it was submitted, I think it would be a good idea to have more people
> testing this patch before re-submitting it.

I did not submit that patch on the lists, because I am not convinced this is
the right approach. It is a "hack" right now. As mentioned, the problem is =
that
scsi and ata pm resume are running at the same time because the dev/pm code
does not seem to know the dependency between the devices (struct dev). Would
need to dig further into that first to see if a cleaner solution can be cod=
ed.
Will try, but busy, so it may take some time. I first need to be able to
recreate the issue on my systems. Will start with that :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

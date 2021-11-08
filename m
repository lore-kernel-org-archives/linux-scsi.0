Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C9DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9131D61361
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbhKHQas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 11:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237175AbhKHQar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 11:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BF5C61378
        for <linux-scsi@vger.kernel.org>; Mon,  8 Nov 2021 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636388883;
        bh=jjuVVn0VnUWP4nu6BiTTglJPFVEdrBHGpuWLdi7jy7c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tMtmwVOYUQO+eur0xp9j58h79XOLClzghIh0dk8xtbKc3XoETXG9J2H/Rdg9Nat7z
         mFmMYTGKEZH3nlb6ci3fa1VYk58oAkeCyK6zLTz5u+8bB2Te/NsBRJlI2EmtY3xDMH
         u0hs1Ozmam6cUguVs3ilpMFwNoYa9rx8r89Lpsi1/aoymrlIgf9K5PwaIPackLcue5
         6KpUpjZ8QGZ55qjkjQdAqqJDOasGmtJnJDC10lXeH51ijLDd1UEbcsNb8WkfpZPSzY
         CwkVyOBZox4r35sjbYuh6nUsXc5FuBz9jwPNu4oc+9fJ+ZbRHOg7j1vKq5zK0hoQvu
         AvnmdejpoDXPg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214967] mvsas not detecting some disks
Date:   Mon, 08 Nov 2021 16:28:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgperkow@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214967-11613-ae7kGcm7JM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214967-11613@https.bugzilla.kernel.org/>
References: <bug-214967-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214967

--- Comment #1 from Matthew Perkowski (mgperkow@gmail.com) ---
I stumbled across this and gave it a try, and it fixed my immediate problem:

https://sourceforge.net/p/scst/mailman/scst-devel/thread/4FDDA78C.400@acm.o=
rg/

However, it doesn't look like the mvsas driver has changed in some time, so=
 I'm
thinking the problem was caused by another change somewhere else in the ker=
nel,
and adding that one line of code to mv_sas.c simply "band-aided" the immedi=
ate
issue I was experiencing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

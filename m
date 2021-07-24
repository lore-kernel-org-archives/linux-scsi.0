Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8D8C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 09:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C04DB60EAF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 09:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhGXJCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 05:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234867AbhGXJCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jul 2021 05:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D5DCB60EB4
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2021 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627119765;
        bh=NavQpsK24NyCDVh9Ur2FaHZ+9DoN+KFccRgxnqxbeDc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PZqaj1ZrJ+TsIJFTmgKVpGokZyehROedxPH0b1r9zdZ7myakBHgf/E/3mU73yYhzF
         pRROnsrlDL5qA/ttANbGn3CGizeEm5okg6Js6bTPocEtIcrYoJlZ0j5OIwEGoiGuLC
         uhpm0BK6BPvQ4RvPO9qKzufuwIVv/EenQpHNowq3xTNRMg3Ln82qWBBleBLHrWsEKN
         4kArBlu0yF5aiW7IJa++HHOaeH5lhTijZ9XxR3MX9LzmBox990zxrZFVMluETcA8b9
         uA3aoGfKOQ1Xch/Sx4kERu0yEKAkZjFj16801cHv1EM/FA2aqgzlxpi0z5Fhn55BAo
         TWJLPMVwKQwEQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Sat, 24 Jul 2021 09:42:45 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jonneransijn1998@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-OG1w74BJRe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Jonne Ransijn (jonneransijn1998@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jonneransijn1998@gmail.com

--- Comment #5 from Jonne Ransijn (jonneransijn1998@gmail.com) ---
The description for media event code 3 reads:

MediaRemoval
The media has been removed from the specified slot,
and the Drive is unable to access the media without user intervention.
This applies to media changers only.

This seems like a reasonable status notification after the disk drive detec=
ted
no disk in the drive.
How else could the the drive signal that the user removed a disk while the
kernel is suspended? The disk drive is (presumably) stateless, it doesn't
remember if it used to have a disk inserted.
This doesn't seem like a bug in the disk drive.

I'm pretty sure 'DISK_EVENT_EJECT_REQUEST' is not the correct event in this
case.
It seems more reasonable to send a 'DISK_EVENT_MEDIA_CHANGE'.

Also, the description for media event code 4:

MediaChanged
The user has requested that the media in the specified slot be loaded.
This applies to media changers only.

Should probably send a 'DISK_EVENT_MEDIA_CHANGE' for that as well then.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=

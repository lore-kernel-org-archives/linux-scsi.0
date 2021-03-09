Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC16C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 14:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937AB65239
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 14:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCIOea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 09:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhCIOeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Mar 2021 09:34:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 02B5A6522D
        for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2021 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615300441;
        bh=CIu9yyMann0456XbailaFI/hiv+p8qZK2BrRiudalQU=;
        h=From:To:Subject:Date:From;
        b=MkPNavkDtEGs8fTGxI7k+zBMpz37rfe6O12qXa6LP4tORz6akTN/QXP7aZRodxRAN
         O3udpO/zasE3onhwx3uqpYAwf3qp9n4mGbpkocVjq0f9tB5o5qmBn9UdXeq/wWNu41
         pJoPEfYjMTT9ZImtG650l8EnextCUOl6HDqncynY/f2PyAxKf6LRWo2C1tGAQ7764p
         XWf0nPk0d/6GevzqYngfJdEvleYoWYBR9jkWaqHWYeMB9WSqxiM3v5cjmcYfYJPU+a
         5kVXnYgJTxUAT0qy0G9SWnuSFX1sHo9RaweHMghA+pMVjAqNpY+HDRAZ5YbpiYsXvv
         /6xyjsJuyqzcA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212183] New: st read statistics inaccurate when requested and
 physical block mismatch
Date:   Tue, 09 Mar 2021 14:34:00 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: etienne.mollier@cgg.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-212183-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212183

            Bug ID: 212183
           Summary: st read statistics inaccurate when requested and
                    physical block mismatch
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.3.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: etienne.mollier@cgg.com
        Regression: No

Created attachment 295769
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295769&action=3Dedit
st.c patch working around stats issue when blocks size mismatch

Greetings,

when reading from tape with requested blocks larger than physical, statisti=
cs
go wrong as using the requested size for the calculation, instead of the ac=
tual
size of the block returned.  So, when running `dd if=3D/dev/st0 bs=3D10240
of=3D/dev/null`, a tool such as `tapestat` will work out the bandwidth usin=
g the
bs=3D10240.  However, if the block on tape was of size 1024, then the metric
would go wrong by a factor 10.

Most configurations won't notice, as tapes are usually fixed size block,
typically for backup use case.  However on our end, the problem exacerbates=
 due
to reading field acquisition cartridges with varying block size.  We are
currently working this around with the patch in attachment.

While we've observed the issue on a somewhat old kernel revision, checking =
out
the "master" branch of the linux tree, we believe this is present since
introduction of the capability in Linux 4.2, and likely to reappear with mo=
re
recent kernel revisions if left as-is.

Kind Regards,
=C3=89tienne.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=

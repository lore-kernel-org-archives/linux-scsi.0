Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574AEC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 15:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3D264E76
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 15:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBTPOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 10:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhBTPON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Feb 2021 10:14:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E8E864E76
        for <linux-scsi@vger.kernel.org>; Sat, 20 Feb 2021 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613834010;
        bh=WjvEI6FFMFg1wroT+2j+nr8Ie8FEFOtZqLR03a1fT70=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fRk5LeEWzNAKmKrGe3jqdvF+nE+JxTKZ/178osQujpxhet0Sa0FVPh92Ik5AVeTD/
         nA3kOohqK4oRNm+j5MYTbVQcLQWI2y5wfoaU/mEABaF2jz/hX6eHmISrtyLbXj3lVM
         ybOTGjg3r4K0TIImkP7x/2E0Mu54PxgLGKB1UzXRD3/tfKX9xJTlL/u0NiQlinpzqV
         g4tsd01V+xrqKmrdTKoubicJvMVWylmVqigDPs/ZIC46I3pRQO69bsIxQdcAcXORof
         vSXow/zPL8qT91yw1pr00Xv/KkVOYD0hRLgEZR93eXm9e9IAv02dCY8f2F4Xtx/T3R
         051H3VSmXdoQQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211227] [BISECTED][REGRESSION] Linux 5.10.7 breaks s3 resume on
 opal encrypted ssd
Date:   Sat, 20 Feb 2021 15:13:30 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chriscjsus@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211227-11613-xlZfx8IXDv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211227-11613@https.bugzilla.kernel.org/>
References: <bug-211227-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211227

--- Comment #3 from chriscjsus@yahoo.com ---
I patched kernel 5.10.17 and there was no debug messages from your patch in
either the console, dmesg, or the journal.  I booted with parameters
no_console_suspend=3D1 and ignore_loglevel.

Your patch does however fix the issue.

If I boot without your patch, resume from S3 hangs and I need to reboot usi=
ng
alt-sysreq-b.

If I boot with your patch, resume from S3 is normal and the drive is obviou=
sly
being unlocked.  When power is cut from the drive during S3, it locks itself
automatically and needs to be unlocked by the kernel on resume.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=

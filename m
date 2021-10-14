Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF496C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC603611C7
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhJNSX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233951AbhJNSX4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 14:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BCF9B61212
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634235711;
        bh=M1FThKBzvtRdDXTHnUOqGPzKFfkqF/EBlq+gxSuCvBQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PB6qUJE0Te5RQQHo9iF7ygD0iZubBWQrgp24QP0xsSVKelW/BcOiX3PtgAsqeRRTD
         /xczP//PNbdvHXxGFL35SWztBl84MR4+AyFOUDgI8PWD6ZCVrym+3hZrDepZxK3a7C
         yLtK/hQ0z2llclDUxzuMM8fse2qQ5UqfeRDkwWWaHUhMI9lSm+PYLBWG6FrKnXfRkt
         Cpnm+lDdF+hcmpenzooeaaQQRZDBvZ3/ui1pI7BrprilSC6UuMNRVMBJne6T1M4Dud
         qbqMnshWewe+Uu+0gLJZ6HG4cY1X9DIU5kKCCnwmnhxGnTycl3nCPk2FEtqpl+trss
         GKuje+sG3pR5w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Information leak from kernel to user space in
 scsi_ioctl.c
Date:   Thu, 14 Oct 2021 18:21:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvanassche@acm.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214711-11613-YUvRsDoWGD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214711-11613@https.bugzilla.kernel.org/>
References: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

--- Comment #4 from Bart Van Assche (bvanassche@acm.org) ---
C and C++ compilers always initialize all named data members of a data
structure in case of aggregate initialization. See also
https://stackoverflow.com/questions/10828294/c-and-c-partial-initialization=
-of-automatic-structure.
However, whether or not unnamed padding bytes and bits are initialized depe=
nds
on the language standard supported by the compiler. See e.g.
https://gustedt.wordpress.com/2012/10/24/c11-defects-initialization-of-padd=
ing/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

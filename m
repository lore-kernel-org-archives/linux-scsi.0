Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B904BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A118610E8
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhJNEIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 00:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhJNEIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 00:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B676610E8
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 04:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634184365;
        bh=L+mnuW4IS4XcEWSql0NXEf3bxyKQ6W3Kxu6y1QogUw8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pMEfXe8sRNR6tnlY6izEGup43rknqCF2G3S+RREEPneSr3d1oPi2bgSzBSYkMBL6N
         7WGG1Dh8ca2oKEh7I45HJMB4g4iJ3xY+oDqn+bpGOBTaDknUCr9QmCpSGXbNlMGBxl
         DklwgJXZR1TzRn5kGp2EWBTfi6/Dlu2fZi+BBTIeDl8n1H122tluE91rAGOeBhiC0v
         XVOC8wr4SsqQOoBcZiOiqEZEupnygpx9etV3gx25vDeJcfH1+TkNLpncrHigcYGr/K
         a1ZUPZLciIOOrzjsWxxJs6CKSp9PZd1qOCPh+QZUINmK6tP7UDY2ZU27rv92O4r5LT
         B5wVDFpE/XOEQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Memory leakage from kernel to user space in
 scsi_ioctl.c
Date:   Thu, 14 Oct 2021 04:06:05 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214711-11613-KJ4h2V4kJB@https.bugzilla.kernel.org/>
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

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
Isn't this called an information leak instead of a memory leak?

Additionally, my understanding of the C standard is that a compiler is requ=
ired
to zero-initialize members that have not been mentioned in an initializer l=
ist.
From the ANSI C 202x draft: "The initialization shall occur in initializer =
list
order, each initializer provided for a particular subobject overriding any
previously listed initializer for the same subobject; all subobjects that a=
re
not
initialized explicitly shall be initialized implicitly the same as objects =
that
have static storage duration."

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

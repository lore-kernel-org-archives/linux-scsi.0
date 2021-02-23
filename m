Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F360C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19656601FF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhBWIaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:30:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232182AbhBWI35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Feb 2021 03:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9594864E4B
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614068953;
        bh=aBgahJ7m/XAfibv/9a8xrX8T3odLoxX6r8xvQfP6obw=;
        h=From:To:Subject:Date:From;
        b=IecXYXkYx9wE7dexS4+/rn9lKOyzmys/H2/JMYcKfnhAkSoUX9O07ErGsDkW8jsyt
         p8RNC34nUez5CwsTV2ih/6KvG31SrVv2xSVdcIrhjkU+ljgNJdnUjsUlD0TaM+pblY
         QpajOWUZ90qaUAso4IQcY6ilk2QUoT7i6eY2t5nFoC4xn38Udo9kpfpu3fXnjN/dum
         8KpYMmTFqcU5gY4QSyRdUd366k194PdHOe8878H1ncg3rGl+uW20+M84pLJK/Zt2uZ
         EXWX+eoYLmWJyTlyiNvCah15QcktAAjrcjJU7ywoFcaOTWO+/seprmVohWzN/x2Vli
         PizUUnbkOjd5g==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 211903] New: scsi ses driver null pointer supervisor mode
 access prevention
Date:   Tue, 23 Feb 2021 08:29:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-211903-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211903

            Bug ID: 211903
           Summary: scsi ses driver null pointer supervisor mode access
                    prevention
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.10.17
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: janpieter.sollie@edpnet.be
        Regression: Yes

Created attachment 295409
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295409&action=3Dedit
BUG description

After booting kernel with SCSI SES + supervisor access prevention, the
following bug appears (view attachment).
On kernel 5.10.14, I haven't seen this

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

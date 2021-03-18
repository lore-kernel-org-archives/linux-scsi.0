Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDE3C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 17:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8637B64F1F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 17:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCRRKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhCRRJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 13:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D1FD64EF2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616087390;
        bh=ZqSJxpeHgyT3+L+dGrOLMP00Pt9YmZvlRXcV8KwEv4Y=;
        h=From:To:Subject:Date:From;
        b=SYw2lLpQWbLaRGI35/iiMrURKoCJNQcPm5C9to3Pq1VahQ0DFjXd1osZHkXW3YgaN
         GcZtTQC2aPYSVgC0jX4Vz4BYs2lt0aFIC/4G67D7EU7F3L20XhZ33eAEGKNGtQW1LD
         RrRPDBt1nbGaL0c/kWaRreo0mpg+C6BGVwI5luaqJ8IlF1xuNQ4TKWu63TRMRHG+/R
         inQA2VHQr/vrF6/sDaFl33lGALauM0yj8DSWTG3N6QcShwHrOmF9HyPSH0Q7ooz1XH
         s+OoclMsuSydtTY7PlX6S7qXVYWidY/clZKHzyuAOHNf3KOjbnZWCgx4dO4bp1auaY
         Q9MukPRJ+xDaw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] New: scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 17:09:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

            Bug ID: 212337
           Summary: scsi_debug: race at module load and module unload
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.12.0 linux-next 20210304
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: mcgrof@kernel.org
        Regression: No

Removing the scsi_module can *very often* fail:

modprobe scsi_debug; rmmod scsi_debug
rmmod: ERROR: Module scsi_debug is in use

The removal will fail complaining that the scsi_debug module is still in us=
e.
Both fstests and blktests rely on scsi_debug for many tests, and so likely =
some
false positives failures from those tests may be coming up. I've looked into
this issue and am going to use this bug report to track the observations, a=
nd
possible solutions.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

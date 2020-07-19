Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3227DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 093AA207DA
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgGSGgb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgGSGgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 02:36:31 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208605] New: AACRAID frequent hos bus reset with intensive IO
 on large arrays
Date:   Sun, 19 Jul 2020 06:36:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-208605-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208605

            Bug ID: 208605
           Summary: AACRAID frequent hos bus reset with intensive IO on
                    large arrays
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.14 - 5.7.8
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: janpieter.sollie@edpnet.be
        Regression: No

Created attachment 290345
  --> https://bugzilla.kernel.org/attachment.cgi?id=290345&action=edit
quick and dirty patch to fix the issue

On a large array (>15 drives), it is impossible to backup the storage to a SAS
tape without the driver detecting a lockup, and causing a bus reset.
This seems to be a false detection, as the host controller actually is not
locking up anything.  It's just a bit delayed.
This issue seems to go back to 4.14.

I reverted some cleanup stuff introduced in 4.14, and the driver is working
correctly.

I attached a patch for it, but this is just to show where the bug may be, it is
not ready for production (though it works, but this may be for 7 series only). 
I also have no idea what exactly causes this issue

Bug observed on a series 7 controller with a 12-drive RAID6 array.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

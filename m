Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB73C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 12:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C212067B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 12:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgFOMre convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgFOMre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jun 2020 08:47:34 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208185] New: aacraid won't init Adaptec 5405 card most times,
 driver is unstable
Date:   Mon, 15 Jun 2020 12:47:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nalorokk@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-208185-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208185

            Bug ID: 208185
           Summary: aacraid won't init Adaptec 5405 card most times,
                    driver is unstable
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.14, 5.7.2
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: nalorokk@gmail.com
        Regression: No

Created attachment 289663
  --> https://bugzilla.kernel.org/attachment.cgi?id=289663&action=edit
kvm screnshot of failed boot

I have Linux kernel, initrd and grub installed on raid partition, grub manages
to boot kernel fine every time, but then boot freezes on aacraid module init, i
got this lines in dmesg:

aacraid: Host adapter abort request.
aacraid: Outstanding commands on (0, 0, 0, 1)
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (0, 0, 0, 2)
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (0, 0, 0, 3)

They repeat every ~20 seconds. Partitions of raid is not visible for kernel
during this enumeration. I tried to wait, but it seems like it does not change
anything.

Problems can happen after both soft and hard reboots. It happens 50-70% of
boots, so it seems that aacraid driver is not really stable in it's current
state. In rare cases of normal init and boot, I don't have any problems with
driver, it seems to work stable under load for at least weeks.

kernel: Adaptec aacraid driver 1.2.1[50983]-custom
kernel: aacraid 0000:07:00.0: can't disable ASPM; OS doesn't have ASPM control
kernel: aacraid: Comm Interface enabled
kernel: AAC0: kernel 5.2-0[18948] Apr 13 2012
kernel: AAC0: monitor 5.2-0[18948]
kernel: AAC0: bios 5.2-0[18948]
kernel: AAC0: serial 8C3810A6B45
kernel: AAC0: Non-DASD support enabled.
kernel: AAC0: 64bit support enabled.
kernel: aacraid 0000:07:00.0: 64 Bit DAC enabled
kernel: scsi host0: aacraid

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

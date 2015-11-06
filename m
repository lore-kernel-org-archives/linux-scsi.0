From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107371] New: I/O error when accessing disk in standby
Date: Fri, 06 Nov 2015 11:42:54 +0000
Message-ID: <bug-107371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030815AbbKFLm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2015 06:42:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F0CB8205B5
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 11:42:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9294220742
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 11:42:54 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=107371

            Bug ID: 107371
           Summary: I/O error when accessing disk in standby
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.1.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: nikmind@home.se
        Regression: No

I got a LSI 2308 SAS controller (using the mpt2sas driver) and are noticing odd
I/O errors on my disk.

Example:

[398374.597662] sd 0:0:4:0: [sde] UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x00
[398374.597665] sd 0:0:4:0: [sde] CDB: opcode=0x88 88 00 00 00 00 00 c0 52 c3
90 00 00 00 08 00 00
[398374.597667] blk_update_request: I/O error, dev sde, sector 3226649488

It happenes to all disks on the controller. I can't seem to notice any problems
due to this, but something does not seem right about getting this error. I also
checked the offending sectors and it's no problem reading them.

So i started to investigate this problem and soon found that the problem occurs
when the disk is in standby mode. Ie. when I try to access the disk when it is
in standby mode. Somehow the system tries to access the disk without spinning
it up first, and hence getting this error. I also checked the offending sectors
and there is no problem reading them.

I don't notice any problems due to this error, but I don't think this error
should occur.

It's very easy to replicate.

1. run "hdparm -y" on the disk to spin it down.
2. Access the disk in any way, like list a directory.
3. Getting this I/O error above, but this getting the dirlist as if nothing
wen't wrong.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

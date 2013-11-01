From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] New: Block SCSI Generic Driver does not keep data
Date: Fri, 01 Nov 2013 19:49:52 +0000
Message-ID: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43977 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab3KATtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Nov 2013 15:49:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BEA7B204AF
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2013 19:49:53 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AD58F203F4
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2013 19:49:52 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

            Bug ID: 64171
           Summary: Block SCSI Generic Driver does not keep data
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32.61
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: af300wsm@gmail.com
        Regression: No

Data written to any given file descriptor should be unique to that descriptor
and processor space.  Currently, the BSG Driver does not keep this uniqueness. 
As the attached simple program demonstrates, a SCSI Command queued to the
device in one process is dequeued by another process which has opened a handle
to the same device.

The attached file sends the simple SCSI "Test Unit Ready" command from the SCSI
Primary Command Spec. to the device using the BSG driver.  As the program
demonstrates, the sg_io_v4.usr_ptr field, which is set in the "push" branch of
the program, is dequeued from the "pop" branch of the code.

I also tested this behavior on Fedora 19 and the bug exists there as well.  F19
uses kernel 3.9.5.

Compile the attachment:
g++ -o <out> combined.cpp


Execute as follows:
sudo combined pop /dev/bsg/0:0:0:0 &
sudo combined push /dev/bsg/0:0:0:0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

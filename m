From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116751] New: Double-Fetch bug in
 Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Tue, 19 Apr 2016 21:45:45 +0000
Message-ID: <bug-116751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41313 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcDSVpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2016 17:45:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 27A01202EC
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2016 21:45:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3B4AF202E9
	for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2016 21:45:46 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=116751

            Bug ID: 116751
           Summary: Double-Fetch bug in
                    Linux-4.5/drivers/scsi/aacraid/commctrl.c
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: wpengfeinudt@gmail.com
        Regression: No

Hi,

I found this Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctrl.c when
I was examining the source code. 

In function ioctl_send_fib(), the driver fetches user space data by pointer arg
via copy_from_user(), and this happens twice at line 81 and line 116
respectively. The first fetched value (stored in kfib) is used to get the
header and calculate the size at line 90 so as to copy the whole message later
at line 116, which means the copy size of the whole message is based on the old
value that came from the first fetch. Besides, the whole message copied in the 
second fetch also contains the header.

However, when the function processes the message after the second fetch at line
130, it uses kfib->header.Size that came from the second fetch, which might be
different from the one came from the first fetch as well as calculated the size
to copy the message from user space to driver. 

If the kfib->header.Size is modified by a user thread under race condition
between the fetch operations, for example changing to a very large value, this
will lead to over-boundary access or other serious consequences in function
aac_fib_send().

I am looking forward to a reply on this, thank you!

Kind regards
Pengfei

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

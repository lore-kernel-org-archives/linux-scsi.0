From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12481] New: mt takes two minutes to determine that the tape drive is empty
Date: Sun, 18 Jan 2009 18:37:25 -0800 (PST)
Message-ID: <bug-12481-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbZASCh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2009 21:37:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0J2bPXJ022184
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2009 18:37:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12481

           Summary: mt takes two minutes to determine that the tape drive is
                    empty
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: kmshanah@ucwb.org.au


Latest working kernel version:
- This definitely used to work fine (no long delays) when we first installed
the tape drive, which was back in July 2007. As we usually keep up to date with
the latest kernels, I assume we were using 2.6.21 at the time but I don't have
any logs to prove it. At the time the kernel was also 32-bit, though I hope
that won't be an important difference.

Earliest failing kernel version:
- Unfortunately, I also have no idea when exactly it broke. It is definitely
broken on at least 2.6.27 and 2.6.28.

Distribution: Debian Lenny (x86_64)
Hardware Environment: Xeon X3350, 8GB RAM, LSI53C1020A, HP LTO-3
Software Environment: mt (GNU cpio 2.9)
Problem Description:
mt is taking two minutes to return the status information for our tape drive
when the drive is empty. It used to be almost immediate. I'm also fairly sure
it used to give a different message as well, something with "OFFLINE" in it,
rather than "rmtopen failed".

Steps to reproduce:
# time mt --file=/dev/nst0 status
mt: /dev/nst0: rmtopen failed: No medium found

real    2m0.709s
user    0m0.003s
sys     0m0.000s


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

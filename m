From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] New: block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Fri, 12 Dec 2008 13:41:43 -0800 (PST)
Message-ID: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbYLLVmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 16:42:16 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBCLfhau001396
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 13:41:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207

           Summary: block reads/writes > 122880 bytes to USB tape drive
                    gives EBUSY
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.16
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: philipm@sybase.com


Latest working kernel version: 2.6.13
Earliest failing kernel version: 2.6.16 (that I've been able to test, may be
2.6.14)
Distribution: Red Hat Enterprise 4, 5, Fedora 9, SuSE 9, 10, SuSE Enterprise
10, and Ubuntu 8.04 tested
Hardware Environment: both x86 and amd64 on server, Quantum CD160UE-SST tape
drive with 80/160 GB tape
Software Environment: Linux
Problem Description:

Any attempt to read() or write() more than 122880 bytes at a time to the USB
tape device results in EBUSY.

Steps to reproduce:

This happened inside our application when attempting to do a backup with a
large write size.  However, it can be reproduced with tar:
- tar -b 240 -cf /dev/st0 foo (works)
- tar -b 241 -cf /dev/st0 foo
tar: /dev/st0: Cannot write: Device or resource busy
tar: Error is not recoverable: exiting now

The reads and writes worked fine in 2.6.13 and earlier.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

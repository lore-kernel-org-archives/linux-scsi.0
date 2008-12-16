From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12240] New: Disk errors sometimes ignored from the USB-SCSI layer
Date: Tue, 16 Dec 2008 13:14:52 -0800 (PST)
Message-ID: <bug-12240-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbYLPVPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 16:15:52 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBGLFKNO025836
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 13:15:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12240

           Summary: Disk errors sometimes ignored from the USB-SCSI layer
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.28-rc8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: kernel@roestock.demon.co.uk


Latest working kernel version: Unknown
Earliest failing kernel version: pre 2.6.19
Distribution: gentoo
Hardware Environment: x86
Software Environment: 
Problem Description:
I have a failing disk drive, and in one type of USB-IDE adaptor bad sectors are
not being handled correctly. This is probably becasue the USB-IDE converter
doesn't seem to report errors from reading bad sectors in the "proper" way, but
it does give plenty of evidence that something is wrong and that the sector
cannot be read.

Alan Stern gave a nice summary here:
http://marc.info/?l=linux-scsi&m=122903295704381&w=2

Various recent kernels seem to do different things when attempting
to read the bad disk:
 - 2.6.26 read the whole disk without reporting errors
 - 2.6.27 gets in a very long (or possibly infinite) loop
 - 2.6.28 gets a bit stuck on the bad sectors, taking several minutes to
timeout, and still does not report error

Steps to reproduce:
Attempt to read bad sectors from a disk drive via a newlink IDE/SATA to USB
disk adaptor.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

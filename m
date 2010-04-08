From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15722] New: unreliable IO for ata disks under heavy io load
Date: Thu, 8 Apr 2010 05:27:47 GMT
Message-ID: <bug-15722-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44406 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0DHF1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 01:27:49 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o385RmJK032727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2010 05:27:48 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15722

           Summary: unreliable IO for ata disks under heavy io load
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: dujun@perabytes.com
        Regression: No


with 2.6.32 valilla mptsas driver and 4.22.00 lsi driver, and SATA disks
connected through lsi 24x expander,  SATA passthrough command sometimes
gets resetted during heavy IO.  I found this problem is very similar
with the bug 14831 in bugzilla.kernel.org
https://bugzilla.kernel.org/show_bug.cgi?id=14831 . 
lots of task abort, task reset, bus reset logs in dmesg. the IO is then
stalled for somewhile until the resets success. 

However, the problem only occures when we connect more than 12 SATA
disks through expander and during heavy disk io.  If we use SAS disks or
we connect 16 SATA disks directly to 1068e card or we use less than 12
disks, the problem seems just disappear. 
2.6.21 kernel mptsas driver seems worse.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

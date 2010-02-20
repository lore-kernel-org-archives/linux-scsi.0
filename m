From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15362] New: MPT Fusion SCSI drives no longer appear - suspect
 PCI bus scan bug
Date: Sat, 20 Feb 2010 15:04:31 GMT
Message-ID: <bug-15362-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47068 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0BTPEj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2010 10:04:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1KF4V9O026224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 20 Feb 2010 15:04:32 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15362

           Summary: MPT Fusion SCSI drives no longer appear - suspect PCI
                    bus scan bug
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.30-1, 2.6.30-2, 2.6.32-trunk
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: pegasus@renegadetech.com
        Regression: Yes


Created an attachment (id=25130)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25130)
2.6.26 dmesg

Since upgrading to the 2.6.30 kernel on an AMD64 platform, drives attached to
my LSI/MPT SCSI controller are no longer visible. If I boot using the 2.6.26-2
kernel, it works fine. The SCSI controller doesn't even show up in lspci in
kernel versions above 2.6.26. (I do have the controller's BIOS disabled
however, but I understand that doesn't matter since the kernel will poll it
anyway, as 2.6.26 does. I tested with the controller's BIOS enabled too and it
doesn't make a difference.)

This has already been submitted to Debian as bug #543308, but evidence points
to a bug in the kernel PCI bus scanning code, since the following PCI devices
show up on 2.6.26-2 but not 2.6.30-1 and up:

0001:40:01.0 0604: 1022:7450 (rev 12)
0001:40:01.1 0800: 1022:7451 (rev 01)
0001:40:02.0 0604: 1022:7450 (rev 12)
0001:40:02.1 0800: 1022:7451 (rev 01)
0001:61:06.0 0100: 1000:0030 (rev 07)
0001:61:06.1 0100: 1000:0030 (rev 07)
0002:80:00.0 0580: 10de:005e (rev a3)
0002:80:01.0 0580: 10de:00d3 (rev a3)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41552] New: Performance of writing and reading from multiple
 drives decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and
 beyond)
Date: Mon, 22 Aug 2011 15:20:41 GMT
Message-ID: <bug-41552-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45799 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1HVPUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 11:20:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7MFKfM3030636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2011 15:20:41 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41552

           Summary: Performance of writing and reading from multiple
                    drives decreases by 40% when going from Linux Kernel
                    2.6.36.4 to 2.6.37 (and beyond)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mpete_06@hotmail.com
        Regression: No


We have an application that will write and read from every sector on a drive. 
The application can perform these tasks on multiple drives at the same time. 
It is designed to run on top of the Linux Kernel, which we periodically update
so that we can get the latest device drivers.  When performing the last update
from 2.6.33.2 to 2.6.37, we found that the performance of a set of drives
decreased by some 40% (took 3 hours and 11 minutes to write and read from 5
drives on 2.6.37 versus 2 hours and 12 minutes on 2.6.33.3).  I was able to
determine that the issue was in the 2.6.37 Kernel as I was able to run it with
the 2.6.36.4 kernel, and it had the better performance.   After seeing that I/O
throttling was introduced in the 2.6.37 Kernel, I naturally suspected that. 
However, by default, all the throttling was turned off (I attached the actual
.config that was used to build the kernel).  I then tried to turn on the
throttling and set it to a high number to see what would happen.  When I did
that, I was able to reduce the time from 3 hours and 11 minutes to 2 hours and
50 minutes.  There seems to be something there that changed that is impacting
performance on multiple drives.  When we do this same test with only one drive,
the performance is identical between the systems.  This issue still occurs on
Kernel 3.0.2.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

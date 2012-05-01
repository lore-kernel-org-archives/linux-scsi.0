From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43191] New: Syslog fills with messages about assuming drive
 cache when SD card not present
Date: Tue, 1 May 2012 22:21:48 GMT
Message-ID: <bug-43191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:49449 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2EAWVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 18:21:49 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q41MLmo3019431
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2012 22:21:48 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43191

           Summary: Syslog fills with messages about assuming drive cache
                    when SD card not present
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.4.0
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC390
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: sriharshatotakura+kernelbugs@gmail.com
        Regression: No


Created an attachment (id=73153)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73153)
list of currently loaded modules

I'm observing the issue discussed in this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=43190
I'm reporting it here since the original reporter didn't seem to have reported
here:


I get this output repeatedly after every minute or so:

[  465.435298] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  465.438295] sd 6:0:0:0: [sdb] Asking for cache data failed
[  465.438303] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  517.147818] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  517.150811] sd 6:0:0:0: [sdb] Asking for cache data failed
[  517.150822] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  568.859459] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  568.862330] sd 6:0:0:0: [sdb] Asking for cache data failed
[  568.862339] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  620.571790] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  620.574659] sd 6:0:0:0: [sdb] Asking for cache data failed

However, when I put in a memory card it stops after outputting this:

[ 1543.770351] sd 6:0:0:0: [sdb] 3970048 512-byte logical blocks: (2.03 GB/1.89
GiB)
[ 1543.775577] sd 6:0:0:0: [sdb] No Caching mode page present
[ 1543.775586] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 1543.780604] sd 6:0:0:0: [sdb] No Caching mode page present
[ 1543.780611] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 1543.807961]  sdb: sdb1

and once I eject the memory card it continues:

[ 4980.766490] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 5032.474959] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[ 5032.477961] sd 6:0:0:0: [sdb] Asking for cache data failed
[ 5032.477970] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 5084.187541] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[ 5084.190546] sd 6:0:0:0: [sdb] Asking for cache data failed
[ 5084.190554] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 5135.899244] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[ 5135.902369] sd 6:0:0:0: [sdb] Asking for cache data failed
[ 5135.902378] sd 6:0:0:0: [sdb] Assuming drive cache: write through

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

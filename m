From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15567] New: SCSI Generic queueing appears unfair between
 processes
Date: Wed, 17 Mar 2010 22:54:57 GMT
Message-ID: <bug-15567-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47300 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0CQWzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 18:55:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HMswcJ026109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 22:54:58 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15567

           Summary: SCSI Generic queueing appears unfair between processes
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.18-2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mh-linux-kernel@loup.net
        Regression: No


My timing indicates there appears to be no fair queueing mechanism for
scsi commands issued from multiple processes to separate devices over
a shared bus (e.g. SCSI or USB).  For example, an io can easily be
starved in queue for more than half a minute with just four processes
issuing 16 slow ios to usb flash devices at a time.  If I hold back
ios in my application and reduce the number of ios queued in the
kernel at a time to 2 per process it decreases average and maximum end
to end latency to more tolerable levels.

Much like memory, cpu or network hogging, unfair storage command
queueing between processes would be considered by most people to be a
performance related defect.  Shared use, particularly of a congested
bus, calls for time or bandwidth slicing to prevent starvation.

The SCSI Generic HOWTO doesn't go into it, but is this the current
kernel design?  If so, perhaps libaio would be a more viable solution
to concurrent io?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

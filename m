From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13143] New: scsi_debug doesn't manage more than 1Tb
Date: Tue, 21 Apr 2009 16:07:08 GMT
Message-ID: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50960 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZDUQHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 12:07:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3LG78aA007310
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 16:07:08 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13143

           Summary: scsi_debug doesn't manage more than 1Tb
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: tvignaud@mandriva.com
        Regression: No


While debugging a partitionner software that has issues with disks bigger than
1Tb, I found out that scsi_debug doesn't manage more than 1Tb:

# modprobe scsi_debug virtual_gb=1000
# cat /proc/partitions |fgrep sdc
   8       32 1048576000 sdc
# rmmod scsi_debug
# modprobe scsi_debug virtual_gb=1100
# cat /proc/partitions |fgrep sdc
   8       32 9223372035860725760 sdc


dmesg shows that the additionnal 100Gb makes it loose sight:
sd 16:0:0:0: [sdc] 2097152000 512-byte hardware sectors: (1.07 TB/1000 GiB)
versus:
sd 15:0:0:0: [sdc] 18446744071721451520 512-byte hardware sectors: (18.4
EB/15.9 EiB)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

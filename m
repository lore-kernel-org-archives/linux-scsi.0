From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16463] New: aic7xxx: fails to notice if a disk is unplugged
Date: Sun, 25 Jul 2010 21:27:22 GMT
Message-ID: <bug-16463-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38006 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0GYV1W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jul 2010 17:27:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6PLRMg6023160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jul 2010 21:27:22 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16463

           Summary: aic7xxx: fails to notice if a disk is unplugged
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-24-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rercola@acm.jhu.edu
        Regression: No


I have an external 7-disk array of SCA disks, connected to a backplane, with a
disk module that speaks 40-pin Fast SCSI:
[   15.992335] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   15.992336]         <Adaptec 2940 SCSI adapter>
[   15.992337]         aic7870: Single Channel A, SCSI Id=7, 16/253 SCBs

I was testing my RAID-6 setup on these, so I yanked one of them while they were
in an MD. dmesg didn't report any change in disk status, and while any IO to
the disk stalled in state D forever, Linux never noticed the disk was gone.

I tried using the convenient script I keep around for forcing rescans of SCSI
and its related friends, which can be found at
http://bash.cyberciti.biz/diskadmin/rescan-linux-scsi-bus/, but even after
running that, the controller still didn't notice the disk was missing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

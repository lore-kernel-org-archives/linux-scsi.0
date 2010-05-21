From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16021] New: mptsas target reset under heavy duty
Date: Fri, 21 May 2010 09:41:16 GMT
Message-ID: <bug-16021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41851 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0EUJlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2010 05:41:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4L9fGlP013256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 May 2010 09:41:16 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16021

           Summary: mptsas target reset under heavy duty
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: dujun@perabytes.com
        Regression: No


We have mptsas driver 4.22.00.00 from lsi official web site driving 1068e chip
which is connected to two lsi 12x expander chips. Each of the chips connects 8
sata disks. Under heavy duty, i.e., when we connect 16 hdd and build the linux
software raid5, there are lots of error reports in dmesg:
[20826.611906] mptscsih: ioc0: task abort: FAILED (sc=ffff88007b348c00)
[20826.611919] mptscsih: ioc0: attempting target reset! (sc=ffff88007dc78700)
[20826.611921] sd 4:0:16:0: [sdq] CDB: Read(10): 28 00 54 94 55 00 00 00 90 00
[20827.361823] mptscsih: ioc0: target reset: SUCCESS (sc=ffff88007dc78700)
[20837.361008] mptscsih: ioc0: attempting task abort! (sc=ffff88007dc78700)
[20837.361011] sd 4:0:16:0: [sdq] CDB: Test Unit Ready: 00 00 00 00 00 00
[20837.385655] mptbase: ioc0: LogInfo(0x31112000): Originator={PL},
Code={Reset}, SubCode(0x2000)
[20838.111238] mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO
Not Yet Executed}, SubCode(0x0000)

This would halt the io for about two minutes and then after successful target
reset, the io is continuing. 

If we reduce the hdd to less than 12, or we set the scsi command depth of each
of the disks to 1, the build process could complete without any error. 
We also tested the same scenario with lsi 36x expander chip without any
problem.

Is this a mptsas driver bug or just the 12x expander chip bug?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

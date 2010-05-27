From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] New: [BUG] Cannot boot any kernel from 2.6.27 on if a
 256 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 15:22:09 GMT
Message-ID: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45326 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab0E0PWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 11:22:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4RFM9hM001073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2010 15:22:09 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058

           Summary: [BUG] Cannot boot any kernel from 2.6.27 on if a 256
                    byte sector SCSI disk is attached
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.27
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: markh@compro.net
        Regression: Yes


Created an attachment (id=26560)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26560)
The boot process captured from a serial console

As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks
do not seem to trigger this. The disks in use do NOT have a partition table.
They are being used by out applications via the sg_io interface only.

A 2.6.26.8 kernel works fine. 

I have bisected this problem to the following commit:

# git bisect good
427e59f09fdba387547106de7bab980b7fff77be is first bad commit
commit 427e59f09fdba387547106de7bab980b7fff77be
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 8 18:24:17 2008 -0600

    [SCSI] make use of the residue value

    USB sometimes doesn't return an error but instead returns a residue
    value indicating part (or all) of the command wasn't completed.  So if
    the driver _done() error processing indicates the command was fully
    processed, subtract off the residue so that this USB error gets
    propagated.

    Cc: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
c85f8cb8bd4910724f0101e41054555980727e16 M      drivers

Now, what USB has to do with my SCSI disks is beyond me. I have a
feeling that this commit is just uncovering another problem. I've attached
a bootlog from a serial console that ends where the boot hangs.

The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
available.

Thanks and regards
Mark

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

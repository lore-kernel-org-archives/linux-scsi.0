From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43085] New: BUG: unable to handle kernel NULL pointer
 dereference (in scsi_send_eh_cmnd)
Date: Tue, 10 Apr 2012 09:53:44 GMT
Message-ID: <bug-43085-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33507 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2DJJxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2012 05:53:45 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3A9riax017219
	for <linux-scsi@vger.kernel.org>; Tue, 10 Apr 2012 09:53:44 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43085

           Summary: BUG: unable to handle kernel NULL pointer dereference
                    (in scsi_send_eh_cmnd)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.4-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: rockorequin@hotmail.com
        Regression: Yes


Created an attachment (id=72868)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72868)
BUG - unable to handle kernel NULL pointer dereference (scsi_send_eh_cmnd)

Whenever I plug my USB3 hub into the PC, I encounter this bug (log attached).
It stops the PC from booting if the hub is inserted at the time, and crashes
USB if I encounter it once the desktop is running.

The line where it crashes is in scsi_error.c at line 782:

struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);

which expands to:

struct scsi_driver *sdrv *(struct scsi_driver
**)scmd->request->rq_disk->private_data

The issue is that rq_disk is NULL (possibly because it's a USB hub and there
isn't necessarily an underlying hard drive?).

If I make it check for rq_disk being null before trying to assign sdrv and set
sdrv to null accordingly, and then later in the function I check for sdrv being
null before looking at sdrv->eh_action, the error goes away and drives on the
hub seem to mount and function OK (mostly anyway).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

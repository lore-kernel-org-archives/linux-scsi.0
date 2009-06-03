From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13437] New: found overlapping data buffer
Date: Wed, 3 Jun 2009 14:16:36 GMT
Message-ID: <bug-13437-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50315 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZFCOQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 10:16:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n53EGaWX011283
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 14:16:36 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13437

           Summary: found overlapping data buffer
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.29.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: GDT SCSI
        AssignedTo: scsi_drivers-gdt-scsi@kernel-bugs.osdl.org
        ReportedBy: ettl.martin@gmx.de
        Regression: No


Hello,

i detected an overlapping data buffer at file
"linux-2.6.29.3/drivers/scsi/gdth_proc.c"
For detection, i used the static code analysis tool cppcheck. It prints the
following message:
[linux-2.6.29.3/drivers/scsi/gdth_proc.c:199]: (error) Overlapping data buffer
hrec

Take a loop at file gdth_proc.c at line 199:

            sprintf(hrec,"%s,%d", hrec, reserve_list[i]);

Here, hrec is used by iteself at the sprintf statement, this is dangerous!!!!

Best regards

Ettl Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

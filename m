From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13438] New: found overlapping data buffer
Date: Wed, 3 Jun 2009 14:20:31 GMT
Message-ID: <bug-13438-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50325 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZFCOU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 10:20:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n53EKVVf011635
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 14:20:31 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13438

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
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: ettl.martin@gmx.de
        Regression: No


Hello,

i detected an overlapping data buffer at file 
"[linux-2.6.29.3/drivers/scsi/qla2xxx/qla_attr.c"
For detection, i used the static code analysis tool cppcheck. It prints the
following message:
[linux-2.6.29.3/drivers/scsi/qla2xxx/qla_attr.c:545]: (error) Overlapping data
buffer buf


Take a loop at file qla_attr.c at line 545:

        return snprintf(buf, PAGE_SIZE, "%s\n", buf);

Here, buf is used by iteself, this is dangerous!!!!

Best regards

Ettl Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

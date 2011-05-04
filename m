From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34412] New: Error-valued pointer dereferences in SCSI
Date: Wed, 4 May 2011 14:07:25 GMT
Message-ID: <bug-34412-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39635 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1EDOHZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 10:07:25 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p44E7PSu023605
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 May 2011 14:07:25 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=34412

           Summary: Error-valued pointer dereferences in SCSI
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.38.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: crubio@cs.wisc.edu
        Regression: No


Created an attachment (id=56572)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=56572)
Complete sample traces and slices describing error-valued pointer dereferences
in SCSI

We have statically analyzed SCSI, VFS and the memory management module to
find error-valued pointers that are dereferenced. We have found two potential
error-valued pointer dereferences:

drivers/scsi/scsi_devinfo.c:716: Dereferencing variable
scsi_dev_info_add_list#devinfo_table, which may contain one of the following
error codes: EINVAL* 

mm/slub.c:511: Dereferencing variable check_bytes#start, which may contain one
of the following error codes: ENOMEM* 

For each potential error-valued pointer dereference, our tool produces a
complete sample trace and a corresponding slice. The complete sample trace
illustrates how one error code may reach the program point at which the
variable is dereferenced. The slice summarizes the complete sample trace by
including only relevant program points at which the error code is transferred
from variable to variable or returned by a function. Sample traces and slices
for the above error-valued pointer dereferences are attached.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

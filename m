From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34422] New: Error-valued pointers used in pointer arithmetic in
 SCSI
Date: Wed, 4 May 2011 14:22:58 GMT
Message-ID: <bug-34422-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:46738 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1EDOW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 10:22:58 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p44EMwbM016278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 May 2011 14:22:58 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=34422

           Summary: Error-valued pointers used in pointer arithmetic in
                    SCSI
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


Created an attachment (id=56582)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=56582)
Complete sample traces and slices describing bad pointer arithmetic in SCSI

We have statically analyzed SCSI, VFS and the memory management module to
find error-valued pointers that are used in pointer arithmetic. We have found
12 instances:

include/linux/mm.h:389: Using variable virt_to_head_page#x in pointer
arithmetic, which may contain one of the following error codes: ENOMEM* 

m/slub.c:251: Using variable check_valid_pointer#object in pointer arithmetic,
which may contain one of the following error codes: ENOMEM* 

mm/slub.c:358: Using variable get_track#object in pointer arithmetic, which may
contain one of the following error codes: ENOMEM* 

mm/slub.c:360: Using variable get_track#object in pointer arithmetic, which may
contain one of the following error codes: ENOMEM* 

mm/slub.c:452: Using variable print_trailer#p in pointer arithmetic, which may
contain one of the following error codes: ENOMEM*

mm/slub.c:457: Using variable print_trailer#p in pointer arithmetic, which may
contain one of the following error codes: ENOMEM* 

mm/slub.c:470: Using variable print_trailer#p in pointer arithmetic, which may
contain one of the following error codes: ENOMEM*

m/slub.c:505: Using variable init_object#p in pointer arithmetic, which may
contain one of the following error codes: ENOMEM* 

mm/slub.c:537: Using variable check_bytes_and_report#start in pointer
arithmetic, which may contain one of the following error codes: ENOMEM*

mm/slub.c:603: Using variable check_pad_bytes#p in pointer arithmetic, which
may contain one of the following error codes: ENOMEM* 

mm/slub.c:643: Using variable check_object#object in pointer arithmetic, which
may contain one of the following error codes: ENOMEM* 

mm/slub.c:657: Using variable check_object#p in pointer arithmetic, which may
contain one of the following error codes: ENOMEM* 

For each case above, our tool produces a complete sample trace and a
corresponding slice. The complete sample trace illustrates how one error code
may reach the program point at which the error-valued pointer is used in
pointer arithmetic. The slice summarizes the complete sample trace by
including only relevant program points at which the error code is transferred
from variable to variable or returned by a function. Sample traces and slices
are attached.

All cases seem to be related: the error originates in the memory management
module, then it is propagated through VFS code (where there are some error
checks), SCSI code, and finally back to the memory management module where the
bad pointer arithmetic occurs (see sample traces). These bad pointer arithmetic
instances are reported only when analyzing SCSI code (and not any file system
implementation).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

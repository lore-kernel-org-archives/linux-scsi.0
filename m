From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34522] New: Error-valued pointer overwrite in SCSI
Date: Wed, 4 May 2011 20:37:30 GMT
Message-ID: <bug-34522-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45736 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1EDUhb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 16:37:31 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p44KbUmI014314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 May 2011 20:37:30 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=34522

           Summary: Error-valued pointer overwrite in SCSI
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


We have statically analyzed SCSI, the VFS and the Memory Management module to
find error-valued pointers that are overwritten without first being checked for
errors. We have found one potential overwrite:

drivers/scsi/scsi_scan.c:639: overwriting potential non-tentative unchecked
error in variable "*bflags", which may contain one of the following error
codes: *EINVAL

Here is a sample trace that illustrates how the overwrite might occur:

include/linux/err.h:24: an unchecked error may be returned
drivers/scsi/scsi_devinfo.c:268:"cabs2cil_" receives an error from function
"ERR_PTR"
drivers/scsi/scsi_devinfo.c:268:"tmp___8" receives an error from "cabs2cil_"
drivers/scsi/scsi_devinfo.c:268:"tmp___8" may have an unchecked error
drivers/scsi/scsi_devinfo.c:268:"tmp" receives an error from "tmp___8"
drivers/scsi/scsi_devinfo.c:268:"tmp" may have an unchecked error
drivers/scsi/scsi_devinfo.c:268:"tmp___7" receives an error from "tmp"
drivers/scsi/scsi_devinfo.c:268:"tmp___7" may have an unchecked error
drivers/scsi/scsi_devinfo.c:268: an unchecked error may be returned
drivers/scsi/scsi_devinfo.c:477:"devinfo_table" receives an error from function
"scsi_devinfo_lookup_by_key"
drivers/scsi/scsi_devinfo.c:479:"devinfo_table" may have an unchecked error
drivers/scsi/scsi_devinfo.c:480:"devinfo_table" may have an unchecked error
include/linux/err.h:29: an unchecked error may be returned
drivers/scsi/scsi_devinfo.c:480:"cabs2cil____0" receives an error from function
"PTR_ERR"
drivers/scsi/scsi_devinfo.c:480:"tmp___19" receives an error from
"cabs2cil____0"
drivers/scsi/scsi_devinfo.c:480:"tmp___17" receives an error from "tmp___19"
drivers/scsi/scsi_devinfo.c:480:"tmp___7" receives an error from "tmp___17"
drivers/scsi/scsi_devinfo.c:480: an unchecked error may be returned
drivers/scsi/scsi_devinfo.c:451:"tmp___7" receives an error from function
"scsi_get_device_flags_keyed"
drivers/scsi/scsi_devinfo.c:451: an unchecked error may be returned
drivers/scsi/scsi_scan.c:639:"*bflags" receives an error from function
"scsi_get_device_flags"
drivers/scsi/scsi_scan.c:644:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:645:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:646:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:655:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:656:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:657:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:658:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:573:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:578:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:581:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:582:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:583:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:585:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:587:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:592:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:596:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:603:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:605:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:609:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:578:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:581:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:582:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:583:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:585:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:587:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:592:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:596:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:603:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:620:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:623:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:624:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:625:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:626:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:628:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:629:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:630:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:639:"*bflags" may have an unchecked error
drivers/scsi/scsi_scan.c:639: overwriting potential non-tentative unchecked
error in variable "*bflags"

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

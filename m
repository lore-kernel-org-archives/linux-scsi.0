From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15562] New: SCSI Generic block io queueing can lock up
Date: Wed, 17 Mar 2010 22:14:08 GMT
Message-ID: <bug-15562-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51892 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0CQWOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 18:14:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HME8PC014265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 22:14:08 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15562

           Summary: SCSI Generic block io queueing can lock up
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.22-2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mh-linux-kernel@loup.net
        Regression: No


When queueing, write() can occassionally return ENOMEM or EBUSY.  The
SCSI GENERIC HOWTO indicates ENOMEM can be returned for indirect io
and that it is extremely rare, however I can typically cause it within
an hour even for direct io which shouldn't need to mem copy.  The
EBUSY return is not even a documented error in these circumstances.

Regardless of which error is received, retrying will never succeed and
the fd is wedged at this point.  With EBUSY I've noticed several
concurrent processes running against different sg block devices to
fail simultaneously and never allow a write() to queue a command
again.

This happens when there is plenty of swap, only 20% of ram "used ",
the rest occupied by buffer cache.

There are no errors logged by the driver. Here is an example of the
offending sg_io_hdr, note all values are in hex:

interface_id    S
dxfer_direction fffffffd  (SG_DXFER_FROM_DEV)
cmd_len         a         (it's a READ 10)
mx_sb_len       fc
iovec_count     0
dxfer_len       200000
dxferp          1c1f400
cmdp            896518
sbp             896528
timeout         20000
flags           1         (SG_FLAG_DIRECT_IO)
pack_id         0
usr_ptr         8964e0

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

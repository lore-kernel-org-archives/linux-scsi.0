From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15561] New: SCSI Generic READ_10 to SATA fails when starting
 multiple processes
Date: Wed, 17 Mar 2010 21:55:10 GMT
Message-ID: <bug-15561-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56109 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0CQVzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 17:55:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HLtAEM009784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 21:55:10 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15561

           Summary: SCSI Generic READ_10 to SATA fails when starting
                    multiple processes
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.18-2.6.32
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


Created an attachment (id=25572)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25572)
aborted sg_io_hdr and kernel logs for various kernels

Issuing a lot of concurrent READ_10 commands via sg driver to SATA
drives causes the the commands to be aborted for no good reason.  I
can reproducibly cause the problem within a few seconds on multiple
known good machines and drives over a wide range of kernels.

I queue 16 concurrent 64k reads to each of eight sata drives with
eight separate process which start at roughly the same time.  At least
one and typically several log kernel errors (reset the associated SATA
bus) and return task aborted.

Perhaps it is a clue to what is going on: even if just using one
drive, driver_duration shows the reads take far longer than normal
(greater than 10ms) when first starting to queue io even with only one
drive, after which the performance behaves more like one would expect
from a sata disk drive.  This slow start is exhibited on both arm and
x86_64 architectures although with only one drive I've never seen an
error.

Older x86_64 kernels are less verbose in kernel log and report with
fixed sense instead of sense descriptors, but the same ATA event is
occuring.  See attachment for typical sg_io_hdr and kernel logs.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

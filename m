From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] New: SCSI tape driver: Spurious EIO and kernel OOPS
Date: Mon, 9 Nov 2009 08:29:03 GMT
Message-ID: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43841 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZKII27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 03:28:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA98T3P8007665
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2009 08:29:03 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563

           Summary: SCSI tape driver: Spurious EIO and kernel OOPS
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.29.4, 2.6.30.3, 2.6.31.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: linux-kernel@jmbreuer.net
        Regression: No


Created an attachment (id=23702)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23702)
BUG console capture from 2.6.30.3 while writing to tape

Overview:

Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
is hit shortly thereafter.


Steps to reproduce:

Using amanda 2.6.0-p2 to perform tape backups to an HP C5683A DDS-4 tape drive;
connected to a Adaptec 29160 Ultra160 SCSI adapter / aic7892: Ultra160 Wide
Channel A, SCSI Id=7, 32/253 SCBs.


Actual results:

Amanda ALWAYS (on affected kernels, see below) complains about an EIO while
writing to the tape a few (< 1000) MB into the tape; most of the time a kernel
BUG is displayed and the system becomes unresponsive.

See attachments BUG-*.txt for a selection. Unfortunately, I could not save
readable BUG output from 2.6.31.5 due to a management console problem; if there
is great demand I can certainly reproduce the BUG output with working console
capture.


Expected results:

Amanda should correctly write to tape during backup as it does using kernels <=
2.6.27.10.


Affected versions:

The oldest kernel I tried which DOES exhibit the problem is 2.6.29.4; other
kernels exhibiting this problem are 2.6.30.3 and 2.6.31.5.


Non-affected versions:

A distribution-patched kernel based on version 2.6.23 [2.6.23-gentoo-r8] used
to work correctly since February 2008; the newest kernel I tried which did not
exhibit this problem is 2.6.27.10.

I did not try any 2.6.28 kernel.


Additional information:

See lshw-2.6.27.10.txt for a complete hardware overview; and
dmesg-2.6.27.10.txt/dmesg-2.6.29.4.txt for dmesg output on a
working/non-working kernel, respectively.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

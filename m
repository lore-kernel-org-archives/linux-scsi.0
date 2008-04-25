From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10554] New: scsi_scan doesn't set the queue depth for tape drive
Date: Fri, 25 Apr 2008 08:29:05 -0700 (PDT)
Message-ID: <bug-10554-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbYDYP3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 11:29:40 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3PFT5i1020823
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 08:29:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10554

           Summary: scsi_scan doesn't set the queue depth for tape drive
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.16
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: flerat@hi-stor.com


Latest working kernel version: 2.6.16
Distribution: Suse
Hardware Environment: IA64
Software Environment: Suse + Backup Software
Problem Description:
scsi_scan doesn't set the queue depth for tape drive.
I'm using an STK 9840B (scsi fiber tape drive) and when I try to acces with 2
driver on the same device, device report an error.



I'm using a software that monitor the tape drive quality. This software use the
"sg" driver to acces to tape drive. The backup software use "st" to read/ write
data.

When the backup software and my software acces in the same time the data
transfert failed.
I'm using a STK 9840B tape drive and when I test with IBM LTO1 it's work.

The main difference between the both drive is that STK doesn't support queue
command (qdepth=1 or 0) and IBM support queue qdepth > 1.

I'm using a qlogic fiber channel, when I'm force the ql2xmaxqdpeth to 1, all is
working very well. But this paramater is for all devices connected to Qlogic
Fiber channel. In my configuartion have 1TB a disk and performence is low due
to qdpeth=1.

On the scsi_scan.c, we have the method scsi_add_lun who read the CmdQue from
the inquiry and set the tagged flag:

if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
          !(*bflags & BLIST_NOTQ))
            sdev->tagged_supported = 1; 

---> CmdQue = inq_result[7] & 2 

STK: CmdQue = 0
IBM: CmdQue = 1

But according to www.t10.org and SPC-2:

"A command queuing (CMDQUE) bit of one indicates that the device supports
tagged tasks (command queuing) for this logical unit (see SAM-2). A value of
zero indicates the device server may support tagged tasks for this logical
unit (see the BQUE bit, above)."

Note the "may support tagged" and in fact if you look the BQUE bit:
STK:  BQUE=0
IBM:  BQUE=0

For www.t10.org:
BQUE=0, CmdQue=0 : No command queuing of any kind supported.
BQUE=0, CmdQue=1 : Command queuing with all types of task tags supported.

scsi_scan do this:
STK:  sdev->tagged_supported = 0 and qdepth = ql2xmaxqdepth
IBM:  sdev->tagged_supported = 1 and qdepth = ql2xmaxqdepth

For me, scsi_scan must read the BQUE bit and set the qdepth to 1 for STK and to
max for IBM.

Regards


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

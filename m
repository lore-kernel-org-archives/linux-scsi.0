From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] New: SCSI Generic (sg): BUG: sleeping function called
 from invalid context
Date: Thu, 26 Mar 2009 12:27:53 GMT
Message-ID: <bug-12945-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56214 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZCZN1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 09:27:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QCRr41016227
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 12:27:53 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12945

           Summary: SCSI Generic (sg): BUG: sleeping function called from
                    invalid context
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.28.9
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: txtoxtox285@googlemail.com
        Regression: No


Created an attachment (id=20685)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20685)
Stack trace on program kill (2.6.28.9)

I am experimenting with CD audio extraction. I use the SCSI Generic driver for
this.

My test program uses read() and write() (instead of ioctl) to send requests to
the driver and receive responses. I use SG_FLAG_DIRECT_IO.

When I kill my program (because I don't want to wait until it has ripped the
entire CD), I am often rewarded with messages like "BUG: sleeping function
called from invalid context at linux-2.6.28.9/include/linux/pagemap.h:347". I
have attached typical stack trace.

Another case when I hit this BUG is when I set a time out and the CD drive
doesn't respond fast enough. A stack trace is attached.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

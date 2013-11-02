From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] Block SCSI Generic Driver does not keep data
Date: Sat, 02 Nov 2013 17:09:46 +0000
Message-ID: <bug-64171-11613-moT5WALEj8@https.bugzilla.kernel.org/>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40535 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab3KBRJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Nov 2013 13:09:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 199E0203DC
	for <linux-scsi@vger.kernel.org>; Sat,  2 Nov 2013 17:09:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EF90220375
	for <linux-scsi@vger.kernel.org>; Sat,  2 Nov 2013 17:09:46 +0000 (UTC)
In-Reply-To: <bug-64171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

--- Comment #2 from d gilbert <dgilbert@interlog.com> ---
On 13-11-01 03:49 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=64171
>
>              Bug ID: 64171
>             Summary: Block SCSI Generic Driver does not keep data
>             Product: SCSI Drivers
>             Version: 2.5
>      Kernel Version: 2.6.32.61
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: high
>            Priority: P1
>           Component: Other
>            Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>            Reporter: af300wsm@gmail.com
>          Regression: No
>
> Data written to any given file descriptor should be unique to that descriptor
> and processor space.  Currently, the BSG Driver does not keep this uniqueness.
> As the attached simple program demonstrates, a SCSI Command queued to the
> device in one process is dequeued by another process which has opened a handle
> to the same device.
>
> The attached file sends the simple SCSI "Test Unit Ready" command from the SCSI
> Primary Command Spec. to the device using the BSG driver.  As the program
> demonstrates, the sg_io_v4.usr_ptr field, which is set in the "push" branch of
> the program, is dequeued from the "pop" branch of the code.
>
> I also tested this behavior on Fedora 19 and the bug exists there as well.  F19
> uses kernel 3.9.5.
>
> Compile the attachment:
> g++ -o <out> combined.cpp
>
>
> Execute as follows:
> sudo combined pop /dev/bsg/0:0:0:0 &
> sudo combined push /dev/bsg/0:0:0:0

I ran this test on lk 3.11.6 and it also exhibits this
problem.

When the bsg driver was originally designed, if my memory is
correct, it did not have an asynchronous interface, so it
skipped the complexity of keeping a separate context for
each file handle within each device.

With the addition of the asynchronous interface, the lack of
file handle context is exposed by your simple test. I'm
pretty sure that parallel test programs could show that
synchronous SG_IO ioctls can also be tricked. For example:
send INQUIRYs continuously from one process, TURs from
another process to the same device. Then, once in a while,
I guess that they would pick up the other one's response.

As for fixing it, that seems like a lot of work. I'm busy with
the sg driver at the moment. The short term solution is to use
the sg driver instead of the bsg driver in cases like these
unless:
   a) you want to do SCSI bidirectional commands
   b) you want to send SCSI commands whose cdb is greater
      that 16 bytes


Observation:
wc bsg.c bsg-lib.c
  1117  2761 24144 bsg.c
   232   797  6117 bsg-lib.c
  1349  3558 30261 total

wc sg.c
  2669  8327 72340 sg.c

Some of those sg.c lines are bloat and for backward compatibility
(to 1992); but not all of them!

The sg driver has problems which several people are looking at,
but not as fundamental as the one reported here.


Another random thought: if the bsg driver implemented O_EXCL
on its open()s [it just ignores it] then that would be one
mechanism that could be used to guard against what has been
observed.

Doug Gilbert

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

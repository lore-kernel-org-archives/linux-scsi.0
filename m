From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118081] New: open-iscsi Ping timeout erro
Date: Thu, 12 May 2016 03:34:45 +0000
Message-ID: <bug-118081-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbcELDes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 23:34:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2141B201EC
	for <linux-scsi@vger.kernel.org>; Thu, 12 May 2016 03:34:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7D606201D3
	for <linux-scsi@vger.kernel.org>; Thu, 12 May 2016 03:34:45 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118081

            Bug ID: 118081
           Summary: open-iscsi Ping timeout erro
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4.7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: liuzhengyuang521@gmail.com
        Regression: No

Hi everyone:
I create a target using fileio as the backend storage on ARM64 server. The
initiator reported some errors showed bellow  while perform iozone test.

[178444.145679]  connection14:0: ping timeout of 5 secs expired, recv timeout
5, last rx 4339462894, last ping 4339464146, now 4339465400
[178444.145706]  connection14:0: detected conn error (1011)
[178469.674313]  connection14:0: detected conn error (1020)
[178504.420979]  connection14:0: ping timeout of 5 secs expired, recv timeout
5, last rx 4339477953, last ping 4339479204, now 4339480456
[178504.421001]  connection14:0: detected conn error (1011)
[178532.064262]  connection14:0: detected conn error (1020)
[178564.584087]  connection14:0: ping timeout of 5 secs expired, recv timeout
5, last rx 4339492980, last ping 4339494232, now 4339495484
..............................

I try to trace the function call of target iscsi. Then, I found the  receiving 
thread of target iscsi blocked at fd_execute_sync_cache -> vfs_fsync_range.
Further, vfs_fsync_range may takes more than 10 seconds to return,while
initiator Ping timeout would happened after 5 seconds.   vfs_fsync_range was
call with the form vfs_fsync_range(fd_dev->fd_file, 0, LLONG_MAX, 1) every
times  which means sync all device cache. 
So, is this a bug?
How  does Initiator send sync_cache scsi command? 
Does it need to sync all device cache at once?
Any reply would be thankful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

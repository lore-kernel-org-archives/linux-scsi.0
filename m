From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Tue, 03 Sep 2013 05:09:51 +0000
Message-ID: <bug-60758-11613-2VFQJdVTo8@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab3ICFJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Sep 2013 01:09:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 47B4B20218
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2013 05:09:54 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6E9F52021E
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2013 05:09:51 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #22 from Jeff Zhou <jz.researcher@yahoo.com> ---
(In reply to zakrzewskim from comment #21)
> Here you are: http://www.upemax.user.icpnet.pl/3.10.4-1.el6.lst

Yes then we see the scsi_scan_wait is not in 3.10.4 either, otherwise there
will be a line :"drivers/scsi/scsi_wait_scan.ko".

The rc.sysinit file in your system might need adjustment to remove the
reference to scsi_wait_scan module.

But that might not be the root cause, since 3.10.4 without scsi_wait_scan works
fine under this script.

There could be a regression between 3.10.4 to 3.10.5 cause your system hang,
might be or might not be scsi problem.

To find the root cause and fix it, probably need to roll back between 3.10.5 to
3.10.4, build and test the kernel for booting, git bisect could be helpful.
Then we can check the details to see why the commit crashing the specific
machine.

-- 
You are receiving this mail because:
You are the assignee for the bug.

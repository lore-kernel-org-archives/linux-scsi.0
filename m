From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Thu, 11 Dec 2008 01:05:59 -0800 (PST)
Message-ID: <20081211090559.1DF1610800C@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbYLKJGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 04:06:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBB95xj5015412
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2008 01:06:00 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #3 from yanmin_zhang@linux.intel.com  2008-12-11 01:05 -------
I instrumented kernel. below is some finding.
1) The disk isn't stable. If we run dd in a loop, sometimes the disk doesn't
work, so block request will expire to start a scsi error handling;
2) fussion driver has its own periodic (1 sec) checking in
mpt_fault_reset_work. If something is wrong, it will do a hardware reset and
flush all pending requests;
3) Step 1) and 2) have a race that a request might be flushed in step 2), but
step 1) releases the request firstly. Later on, when SOFTIRQ tries to release
the scsi_cmnd, kernel panic.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Thu, 11 Dec 2008 07:17:26 -0800 (PST)
Message-ID: <20081211151726.EF777108042@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbYLKPSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 10:18:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBBFHRwm032670
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2008 07:17:28 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #5 from anonymous@kernel-bugs.osdl.org  2008-12-11 07:17 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Thu, 2008-12-11 at 01:05 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> I instrumented kernel. below is some finding.
> 1) The disk isn't stable. If we run dd in a loop, sometimes the disk doesn't
> work, so block request will expire to start a scsi error handling;
> 2) fussion driver has its own periodic (1 sec) checking in
> mpt_fault_reset_work. If something is wrong, it will do a hardware reset and
> flush all pending requests;
> 3) Step 1) and 2) have a race that a request might be flushed in step 2), but
> step 1) releases the request firstly. Later on, when SOFTIRQ tries to release
> the scsi_cmnd, kernel panic.

OK, so to rule out the block timer problems which we think are fixed,
could you reproduce on 2.6.28-rc8.

Also, the routine 

> [<a000000100391cf0>] scsi_softirq_done+0x50/0x2e0
>                                 sp=e000000008a97e10 bsp=e000000008a90d70

Is hard to diagnose. Could you ask gdb or addr2line which actual source
line this is?

Thanks,

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47701] When too many disks fall out at the same time, RCU hangs
Date: Sun,  7 Oct 2012 02:20:43 +0000 (UTC)
Message-ID: <20121007022043.E4EB711FC43@bugzilla.kernel.org>
References: <bug-47701-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2JGCUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Oct 2012 22:20:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 956EB201DE
	for <linux-scsi@vger.kernel.org>; Sun,  7 Oct 2012 02:20:46 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3A589201DD
	for <linux-scsi@vger.kernel.org>; Sun,  7 Oct 2012 02:20:44 +0000 (UTC)
In-Reply-To: <bug-47701-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47701


Joe Lawrence <joe.lawrence@stratus.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joe.lawrence@stratus.com




--- Comment #2 from Joe Lawrence <joe.lawrence@stratus.com>  2012-10-07 02:20:43 ---
Stratus noticed a similar crash (hang actually) earlier this week when removing
a single SAS disk as part of a RAID 1 MD mirror.  In our instance, the all CPUs
were idle, except one that was running scsi_target_reap and another waiting on
RCU synchronize_sched.  Since the former function was stuck in some loop, RCU
stalled and the machine wedged.  Another Stratus engineer noticed patch [1],
and once applied to our kernel, MD/mpt2sas disk removal no longer hung the
machine.

[1] [SCSI] scsi_remove_target: fix softlockup regression on hot remove
https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=bc3f02a795d3b4faa99d37390174be2a75d091bd

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

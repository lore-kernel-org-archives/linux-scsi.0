From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 03:59:09 +0000
Message-ID: <bug-90601-11613-Jth2d1Dswy@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56281 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbbDSD7N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Apr 2015 23:59:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3B3EF20461
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 03:59:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 07A1220454
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 03:59:10 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

Justin Keogh <kernel.org@v6y.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel.org@v6y.net

--- Comment #20 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174421
  --> https://bugzilla.kernel.org/attachment.cgi?id=174421&action=edit
dmesg for the commit that git bisect landed on

I'm getting a similar panic (attached).

$lspci | grep 3ware
05:00.0 RAID bus controller: 3ware Inc 9750 SAS2/SATA-II RAID PCIe (rev 05)

$uname -a
Linux localhost 3.16.0-rc5+ #18 SMP PREEMPT Wed Apr 8 20:11:03 2015 x86_64
Intel(R) Xeon(R) CPU X5482 @ 3.20GHz GenuineIntel GNU/Linux

root@localhost /usr/src/linux $git rev-parse HEAD
74665016086615bbaa3fa6f83af410a0a4e029ee

The panic bisected to:
74665016086615bbaa3fa6f83af410a0a4e029ee is the first bad commit
commit 74665016086615bbaa3fa6f83af410a0a4e029ee
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Jan 22 15:29:29 2014 +0100

    scsi: convert host_busy to atomic_t

    Avoid taking the host-wide host_lock to check the per-host queue limit.
    Instead we do an atomic_inc_return early on to grab our slot in the queue,
    and if necessary decrement it after finishing all checks.


I was unable to trigger the panic by writing to the 3w array with:
$dd if=/dev/zero of=test bs=1G count=10
or even:
$dd if=/dev/zero of=test bs=1G count=100

Instead, it takes somewhere between a few hours and 2 days of writing to panic,
so the good bisects were run for 3 days to make sure.

Crash happens with and without ZFS modules loaded but most of the bisect was
done with because I couldn't take the array out of the equation for a month.
Both cases are attached along with .config and bisect log.

I'll recompile without IOMMU and post the results, further suggestions
appreciated.

-- 
You are receiving this mail because:
You are the assignee for the bug.

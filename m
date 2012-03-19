From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42939] hv_storvsc - write cache enabled by default and cannot
 be disabled
Date: Mon, 19 Mar 2012 19:33:30 GMT
Message-ID: <201203191933.q2JJXU7i027495@bugzilla.kernel.org>
References: <bug-42939-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:45123 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965127Ab2CSTdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 15:33:31 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2JJXUcs027496
	for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:33:30 GMT
In-Reply-To: <bug-42939-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42939





--- Comment #1 from Mark <bugzilla-kernel-org-sux2k0@mstier.de>  2012-03-19 19:33:29 ---
Additional information:

trying to disable the writecache leads to the partition on the SCSI device
getting remounted read-only due to device errors.

Additional information (2):

I get 5.000 to 6.000 random reads per second even when manually creating the
fiometer file using random data from /dev/urandom (ie. fio doesn't access
zeroes in that case).

Additional information (3):

The host doesn't seem to cache anything: "dd iflag=direct if=/dev/sda bs=1M
of=/dev/null count=10" always and repeatedly gives me around 30-60 MB/s.

Additional information (4):

I did a simple MySQL InnoDB ACID transaction test where subsequent transactions
are done via a remote mysql client as fast as possible. I crashed the host
hardware and checked if all transactions reported as completed had been
committed to disk: no obvious problems there -- seemingly the reported
writecache has no writecache-effects at all...??

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

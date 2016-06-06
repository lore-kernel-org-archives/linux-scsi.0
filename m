From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118621] After upgrading from ubuntu 15.10 to 16.04 CD-R's won't
 mount, others mount just fine
Date: Mon, 06 Jun 2016 14:35:49 +0000
Message-ID: <bug-118621-11613-Fb4Xuy45o5@https.bugzilla.kernel.org/>
References: <bug-118621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbcFFOfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 10:35:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8514B20117
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2016 14:35:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 87B92201BC
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2016 14:35:49 +0000 (UTC)
In-Reply-To: <bug-118621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118621

--- Comment #2 from albapompeo@gmail.com ---
After looking for more information, I found this comment on a forum.
====================
Hi,
this must be a new bug with Linux kernel or udev.
A significant difference between CD TAO and CD SAO at read time
is that a TAO track ends by two non-data sectors, which cannot
be read by normal SCSI READ commands.
This can happen only with CD media. Not with DVD or USB sticks.
In the times of kernel 2.X, the situation in the Linux kernel was
quite bad: I/O error somewhere beginning 128 blocks before the
track end.
With kernel 3.X it improved. The I/O error reliably hits 2 blocks
before track end on 3.16. I did not try 4.X with real iron yet.
My best guess would be that this confuses the entity among the
ISO payload, which is in charge for creating /dev/disk/by-label/ 
links while the system boots up.
(If somebody can explain the factor 8 between "sector 1226752"
and "logical block 153344", then please do.)
Obviously the problem is still in archlinux-2016.02.01-dual.iso
====================
https://bbs.archlinux.org/viewtopic.php?pid=1605434#p1605434

After testing his theory and burning the ISO to a DVD instead of a CD, it
worked!

Does this shed any light to the problem?

-- 
You are receiving this mail because:
You are the assignee for the bug.

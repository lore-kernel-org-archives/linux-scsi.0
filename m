From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106841] ses: do not output error for simple subenclosure
 (handle Short Enclosure Status diagnostic page)
Date: Sat, 27 Feb 2016 01:21:39 +0000
Message-ID: <bug-106841-11613-Tljg8seZsR@https.bugzilla.kernel.org/>
References: <bug-106841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbcB0BVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2016 20:21:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 96D0320411
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 01:21:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B7B62203EC
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 01:21:40 +0000 (UTC)
In-Reply-To: <bug-106841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106841

--- Comment #2 from Tom Yan <tom.ty89@gmail.com> ---
This commit did NOT fix anything:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/ses.c?id=3417c1b5cb1fdc10261dbed42b05cc93166a78fd

Only the error changes from:

scsi 7:0:0:1: Failed to get diagnostic page 0x8000002
scsi 7:0:0:1: Failed to bind enclosure -19

to

scsi 7:0:0:1: Wrong diagnostic page; asked for 1 got 0
scsi 7:0:0:1: Failed to get diagnostic page 0xffffffea
scsi 7:0:0:1: Failed to bind enclosure -19

The ses driver should simply check whether there is an Short Enclosure Status
page (i.e. it is a simple subenclosure) FIRST. If that's the case, the device
should simply be skipped/bound WITHOUT error.

-- 
You are receiving this mail because:
You are the assignee for the bug.

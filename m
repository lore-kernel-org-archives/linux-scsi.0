From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47701] When too many disks fall out at the same time, RCU hangs
Date: Sat,  6 Oct 2012 14:30:58 +0000 (UTC)
Message-ID: <20121006143058.BACAA11FC6C@bugzilla.kernel.org>
References: <bug-47701-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60624 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2JFObD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Oct 2012 10:31:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 35E4820233
	for <linux-scsi@vger.kernel.org>; Sat,  6 Oct 2012 14:31:02 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7DA072022F
	for <linux-scsi@vger.kernel.org>; Sat,  6 Oct 2012 14:30:59 +0000 (UTC)
In-Reply-To: <bug-47701-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47701





--- Comment #1 from Brad Campbell <lists2009@fnarfbargle.com>  2012-10-06 14:30:58 ---
Created an attachment (id=82531)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=82531)
dmesg of boot, and removal of one drive at 9462 seconds.

I can reproduce this on 3.5.5 & 3.6.
I have 2 of these cards : 01:00.0 Serial Attached SCSI controller: LSI Logic /
Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)

My test setup places only 2 drives on the SAS cards. I create a RAID10 from
them. Simply pulling a drive will cause the following RCU hang, and prevent the
machine from syncing, rebooting or being able to use the array. Alt-sysrq gets
me rebooted and back up and running. 100% reproducible.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

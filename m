From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 06:42:54 -0800 (PST)
Message-ID: <20081223144254.B8168108042@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbYLWOnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 09:43:08 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBNEgstr016083
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 06:42:55 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #7 from philipm@sybase.com  2008-12-23 06:42 -------
Tapes don't work that way.  Each call to write() causes striping to be put on
the tape.  It has to be read and written in exactly the same way.  Since older
kernels had no problem with the larger block size, and all other operating
systems don't have this limit, all existing tapes (with larger block sizes) are
unreadable.

We routinely write blocks of up to 2MB at a time during our backup procedure. 
This makes them impossible to restore on recent Linux systems.

Maybe rather than limiting the transfer size, you should detect the failure on
devices that do fail and report that.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

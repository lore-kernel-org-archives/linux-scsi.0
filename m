From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Mon, 22 Dec 2008 23:30:49 -0800 (PST)
Message-ID: <20081223073049.D4AB3108040@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYLWHbU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 02:31:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBN7UnwW026092
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 23:30:50 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207


kai.makisara@kolumbus.fi changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kai.makisara@kolumbus.fi




------- Comment #3 from kai.makisara@kolumbus.fi  2008-12-22 23:30 -------
I have been testing large blocks with 2.6.27.7 and I was able to reach 6 MB
without any tricks. The difference between your system and mine is that my tape
is connected with SCSI and yours is with USB.

Looking at linux/drivers/usb/storage/scsiglue,c I find the following:

        /* limit the total size of a transfer to 120 KB */
        .max_sectors =                  240,

Maybe the USB experts can tell what is the reason for this.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

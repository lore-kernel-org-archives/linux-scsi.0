From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85751] iSCSI initiator lockup during logout
Date: Tue, 07 Oct 2014 16:42:02 +0000
Message-ID: <bug-85751-11613-AIXQdLQp7t@https.bugzilla.kernel.org/>
References: <bug-85751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49314 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaJGQmH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 12:42:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E0E820211
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 16:42:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2EAC420221
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 16:42:03 +0000 (UTC)
In-Reply-To: <bug-85751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85751

--- Comment #2 from Bart Van Assche <bvanassche@acm.org> ---
This is not easy to reproduce and happened while testing a modification of
iSCSI target software. The following commands were issued at the initiator
side:
* iscsiadm -m discovery -p 192.168.1.124 -t st
* iscsiadm -m node -p 192.168.1.124 -l
(something went wrong at the target side and the iSCSI initiator tried to
relogin)
* iscsiadm -m node -p 192.168.1.124 -u
Even after I powered off the virtual machine that was running the iSCSI target
software that last logout command did not finish. The system load raised to a
high value due to several kernel threads at the initiator side that got stuck
in an uninterruptible wait. It is only after the logout command had been issued
that I ran "echo w > /proc/sysrq-trigger".

-- 
You are receiving this mail because:
You are the assignee for the bug.

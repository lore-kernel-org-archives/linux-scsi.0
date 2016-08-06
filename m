From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sat, 06 Aug 2016 19:20:57 +0000
Message-ID: <bug-151631-11613-HPdGeKXB47@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50252 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcHFUgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2016 16:36:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9818C20821
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 19:21:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1354E20823
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 19:20:58 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |icanrealizeum+bugzillakerne
                   |                            |lorg@gmail.com

--- Comment #1 from icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> ---
I tried one shutdown, and after the above it did shutdown, as expected,
however, on poweron, SSD was not detected by BIOS unless I did one ctrl+alt+del
from POST's attempt to boot from LAN, and this second time it was detected.
This happens usually after I powerdown from button(hold 4 sec) because I
imagine SSD is busy recovering from sudden-power-loss internally, so I can only
conclude that the kernel didn't safely powerdown the SSD(aside from the above
failure to flush cache). (Was definitely ok in 4.7.0-rc6-ga99cde4)

I did however have a debug.sh script in
/usr/lib/systemd/system-shutdown/debug.sh
which did these:
sync && sdparm --command=sync /dev/sda && sleep 1
mount -o remount,ro /
hdparm -F /dev/sda
hdparm -f /dev/sda
sleep 1

So in a way, that ssd cache was supposedly flushed regardless; and it doesn't
seem to me that something else ever tried to remount,rw or do writes after
this.

-- 
You are receiving this mail because:
You are the assignee for the bug.

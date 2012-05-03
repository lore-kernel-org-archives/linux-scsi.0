From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43191] Syslog fills with messages about assuming drive cache
 when SD card not present
Date: Thu, 3 May 2012 06:55:27 GMT
Message-ID: <201205030655.q436tREJ007374@bugzilla.kernel.org>
References: <bug-43191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:53925 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2ECGz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 02:55:28 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q436tRxh007375
	for <linux-scsi@vger.kernel.org>; Thu, 3 May 2012 06:55:27 GMT
In-Reply-To: <bug-43191-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43191





--- Comment #4 from Christian Kujau <lists@nerdbynature.de>  2012-05-03 06:55:27 ---
Noticed this on a "Lenovo Ideapad S10" as well. Ubuntu #925760 has a workaround
for this:

$ rmmod ums_realtek

 usbcore: deregistering interface driver ums-realtek

And the messages stop. As soon as the module is loaded again, the messages
resume and repeat every 52 seconds:

$ modprobe ums_realtek

May  2 23:50:46 scsi5 : usb-storage 1-5:1.0
May  2 23:50:46 usbcore: registered new interface driver ums-realtek
May  2 23:50:47 scsi 5:0:0:0: Direct-Access Generic- Multi-Card 1.00 PQ: 0
ANSI: 0 CCS
May  2 23:50:47 sd 5:0:0:0: Attached scsi generic sg1 type 0
May  2 23:50:47 sd 5:0:0:0: [sdb] Attached SCSI removable disk

May  2 23:51:38 sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled
May  2 23:51:38 sd 5:0:0:0: [sdb] Asking for cache data failed
May  2 23:51:38 sd 5:0:0:0: [sdb] Assuming drive cache: write through
May  2 23:52:30 sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled
May  2 23:52:30 sd 5:0:0:0: [sdb] Asking for cache data failed
May  2 23:52:30 sd 5:0:0:0: [sdb] Assuming drive cache: write through

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

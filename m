From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sun, 07 Aug 2016 15:06:22 +0000
Message-ID: <bug-151631-11613-WS1PfScFU3@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbcHGPG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2016 11:06:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6478920263
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 15:06:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4D7962022A
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 15:06:22 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

--- Comment #4 from icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> ---
I have worked around this issue(for me) by adding a few lines in debug.sh like:

if test "$1" == "poweroff"; then
 hdparm -Y /dev/sda
 echo o > /proc/sysrq-trigger ; sleep 5
fi

that puts drive to sleep and triggers shutdown via sysrq

Seems to have worked just fine: no drive issues on startup anymore, as I've
mentioned before with having to ctrl+alt+del once to get BIOS to detect drive;
and no extra delays.

Also the above require a kernel patch:
//sd_start_stop_device(sdkp, 0);
commenting out that call in sd_shutdown function in file: drivers/scsi/sd.c
or else it will fail like in comment #3

-- 
You are receiving this mail because:
You are the assignee for the bug.

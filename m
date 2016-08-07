From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sun, 07 Aug 2016 00:29:48 +0000
Message-ID: <bug-151631-11613-qbaktU4wLc@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58698 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcHGA3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2016 20:29:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8184A20256
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 00:29:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7D1DF20259
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 00:29:48 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

--- Comment #3 from icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> ---
Ok, now that the cache error doesn't happen and reboot works, I've tested
shutdown and it now fails at the "Stopping disk" part, which means this line:
sd_start_stop_device(sdkp, 0);

ata4.00: failed command: STANDBY IMMEDIATE

screenshot: https://i.imgur.com/2yvAMSR.jpg

So now we know that it did in fact not safely shutdown the drive before, when I
thought it's just the drive cache flushing that failed. So the drive is doing
recovery, internally, upon laptop poweron which is why it doesn't identify
itself in time but only on next ctrl+alt+del boot. (see comment #1)

-- 
You are receiving this mail because:
You are the assignee for the bug.

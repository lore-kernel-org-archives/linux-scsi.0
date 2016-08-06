From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sat, 06 Aug 2016 19:57:37 +0000
Message-ID: <bug-151631-11613-X2EL1D2SSx@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47324 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbcHFUGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2016 16:06:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC9E820829
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 19:57:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A3AF820827
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 19:57:37 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

--- Comment #2 from icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> ---
Created attachment 227801
  --> https://bugzilla.kernel.org/attachment.cgi?id=227801&action=edit
for systemd, /usr/lib/systemd/system-shutdown/debug.sh

Found workaround, thanks to this article:
https://unix.stackexchange.com/questions/55281/how-to-stop-waking-all-attached-drives-on-reboot-deactivating-swap/55417#55417

If I put the following in aforementioned debug.sh file then reboot is
instant(after the SCSI bug, of course):

#THIS:
#turn off drive cache
hdparm -W0 /dev/sda
#^^^^^^^^^^^^^^^^^^^^^^

#this was already here before:
#flush drive cache:
hdparm -F /dev/sda
hdparm -f /dev/sda

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Thu, 07 Jul 2016 11:38:45 +0000
Message-ID: <bug-121531-11613-hTxKLjR8yQ@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbcGGLjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 07:39:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1AD0420122
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2016 11:38:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2881820142
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2016 11:38:46 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #12 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
@Jack: No, I hadn't tried that yet, but I will now:

I downloaded the driver from the homepage and installed the
adaptec/debian_7.4/x64/pm80xx-1.4.0-11068-debian64.deb package on our dev
server. After DKMS had compiled the pm80xx.ko module, I unloaded the pm80xx
module on the installer live system and replaced
/lib/modules/3.16.0-4-amd64/kernel/drivers/scsi/pm8001/pm80xx.ko with the newly
compiled module and loaded it again. It seems to work better... I've been able
to write 1024 MB successfully:

root@(none):~# dd if=/dev/zero of=/dev/sdc bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 6.51408 s, 165 MB/s

I'm now installing Debian onto the machine, I'll report back how that turns
out.

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Tue, 06 Jan 2015 15:28:17 +0000
Message-ID: <bug-90601-11613-nHHf4RZ4B7@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbbAFP2V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 10:28:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C4EBF201EC
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2015 15:28:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6D74720211
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2015 15:28:17 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #4 from merlin@liao.homelinux.org ---
Hi Kashyap,

1. I enabled CONFIG_DMA_API_DEBUG , strangely enough after enabling it I
couldn't even boot into the system anymore because it would crash when trying
to access the root partition (after the kernel image was loaded). I think the
problem was the initial xfs_repair that is done on bootup.

So I took the same kernel and copied it to a USB device and booted from that on
the same host into a system that also resides on the USB disk.

Then I mounted /dev/sda (which is the first device on the raid controller which
is the root partition).

Then I tried to reproduce the panic with the simple dd that was used before
without success.
I then compiled the kernel sources with -j25 on the mounted root partition 2
times without any problems.
Then I chrooted onto that partition and did the same and could finally
reproduce the crash.

I am not sure if that backtrace is more useful though.

I have also attached the /var/log/messages but of course that crash wasn't
saved in it.
I also added my kernel config.

-- 
You are receiving this mail because:
You are the assignee for the bug.

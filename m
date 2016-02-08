From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111381] mvsas 0.8.16 on Marvell 88SE9485 reports timeouts on
 load
Date: Mon, 08 Feb 2016 17:24:58 +0000
Message-ID: <bug-111381-11613-t2UaehqXX4@https.bugzilla.kernel.org/>
References: <bug-111381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49647 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbcBHRZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 12:25:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 670C320034
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 17:25:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BCDD7203DF
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 17:24:58 +0000 (UTC)
In-Reply-To: <bug-111381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111381

--- Comment #4 from Gabriel A. Devenyi <gdevenyi@gmail.com> ---
After much more research and reading, I believe I've found the root issue
causing the communication timeouts to the disks. I have not changed any cables
(other than reseating everything).

I came across several reports of marvell (mvsas) controllers randomly causing
issues with load, which mentioned SMART.

http://www.spinics.net/lists/linux-ide/msg50075.html
https://bugzilla.kernel.org/show_bug.cgi?id=42679

So I decided to stop smartd and try my load tests.

I have now gone through three iterations of high-load zfs scrubs along with
iotest.sh hammering the array simultaneously with no timeouts or communications
issues. I believe this indicates some issue with the driver/controller/disks
handling smart commands during load.

Do you have any recommendations as how I can test this further? Is there any
debug info I can provide?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

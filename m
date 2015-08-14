From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Fri, 14 Aug 2015 18:39:43 +0000
Message-ID: <bug-101011-11613-6jIKlaWb2M@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41515 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbbHNSjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2015 14:39:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1373B2081B
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 18:39:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B1B0D2080A
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 18:39:43 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

--- Comment #8 from Theodore Tso <tytso@mit.edu> ---
On Fri, Aug 14, 2015 at 11:02:14AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=101011
> 
> I can also confirm that this bug is present in latest stable kernel (4.1.5) and
> reverting commit from comment 6 seems to fix it.

Christoph,

I've since gotten two reports from users that reverting your commit:
"08439fec266c3: ext4: remove block_device_ejected" fixes a crash when
a USB stick is yanked from their system.  Looking at the reported
stack dump, it looks like the crash is happening in
account_page_dirtied() when it updates some bdi-specific statistics.

I haven't been paying attention to the recent changes in how bdi gets
torn down after the device gets removed, and in fact finding the
recent changes wasn't obvioius enough after doing a brief search, but
it seems to me that if reverting this patch is making any kind of
differences, then the assertion in the commit description:

    bdi->dev now never goes away, so this function became useless.

it implies that bdi->dev *does* become NULL, and checking for this is
useful.  In any case, I don't see any harm in reverting this commit;
what do you think?

Thanks,

                    - Ted

-- 
You are receiving this mail because:
You are the assignee for the bug.

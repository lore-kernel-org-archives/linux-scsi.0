From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106871] Lower log level for "No Caching mode page found" and
 "Assuming drive cache: write through"
Date: Sat, 31 Oct 2015 08:06:05 +0000
Message-ID: <bug-106871-11613-Cv2D6tS5IV@https.bugzilla.kernel.org/>
References: <bug-106871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55445 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbbJaIGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Oct 2015 04:06:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 06ED120600
	for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2015 08:06:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4F3EE20609
	for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2015 08:06:06 +0000 (UTC)
In-Reply-To: <bug-106871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106871

--- Comment #1 from Tom Yan <tom.ty89@gmail.com> ---
https://bugzilla.kernel.org/show_bug.cgi?id=16490#c8

The question is, why are we even using "write through" as fallback when if it
can be dangerous? What's wrong with using "write back" as fallback instead?
Would a SYNCHRONIZE CACHE command ever be a threat to devices without write
cache or caching mode page?

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b81478d82e389dd0961760f5ff6f56b50d29db6d
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=eaa05dfcdb12cf3a7bedf8918dc8699c00944384

Seems like we consider "write back" an safer option everywhere else but we just
somehow require users to use a quirk to switch to that for no reason. This just
looks silly to me.

-- 
You are receiving this mail because:
You are the assignee for the bug.

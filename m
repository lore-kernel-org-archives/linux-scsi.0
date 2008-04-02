From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Wed,  2 Apr 2008 08:50:03 -0700 (PDT)
Message-ID: <20080402155003.6717F11D107@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911AbYDBPue (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 11:50:34 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m32Fo47K032624
	for <linux-scsi@vger.kernel.org>; Wed, 2 Apr 2008 08:50:05 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #13 from anonymous@kernel-bugs.osdl.org  2008-04-02 08:50 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-04-02 at 16:09 +0200, Jos van der Ende wrote:
> Finally, bisecting is done. :-)

Thanks for doing this ... we'd never have found it by looking at the
driver code ...

> Well, it took more reboots than a typical Windows XP installation (and
> thank the heavens for my Sparc64 cross compiler on my Core 2 Duo), but
> this seems to be the culprit:
> 
> 5a606b72a4309a656cd1a19ad137dc5557c4b8ea is first bad commit

Reading the code for this, it seems that something fiddled with the
IRQ_DISABLED or IRQ_PENDING flags when it came time for the ->eoi() so
the gem interrupt is always held pending (because it's never ended).

Since the sym2 is on interrupts 16 and 17 and gem on 11 (and the
descriptors are separate entities in the irq_desc array) I can't really
see how sym2 would be doing this.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

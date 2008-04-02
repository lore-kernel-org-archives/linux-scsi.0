From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Wed,  2 Apr 2008 07:09:28 -0700 (PDT)
Message-ID: <20080402140928.DA1D210803B@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbYDBOKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 10:10:00 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m32E9SFm015125
	for <linux-scsi@vger.kernel.org>; Wed, 2 Apr 2008 07:09:30 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #12 from seraph@xs4all.nl  2008-04-02 07:09 -------
Finally, bisecting is done. :-)

Well, it took more reboots than a typical Windows XP installation (and thank
the heavens for my Sparc64 cross compiler on my Core 2 Duo), but this seems to
be the culprit:

5a606b72a4309a656cd1a19ad137dc5557c4b8ea is first bad commit
commit 5a606b72a4309a656cd1a19ad137dc5557c4b8ea
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Mon Jul 9 22:40:36 2007 -0700

    [SPARC64]: Do not ACK an INO if it is disabled or inprogress.

    This is also a partial workaround for a bug in the LDOM firmware which
    double-transmits RX inos during high load.  Without this, such an
    event causes the kernel to loop forever in the interrupt call chain
    ACK'ing but never actually running the IRQ handler (and thus clearing
    the interrupt condition in the device).

    There is still a bad potential effect when double INOs occur,
    not covered by this changeset.  Namely, if the INO is already on
    the per-cpu INO vector list, we still blindly re-insert it and
    thus we can end up losing interrupts already linked in after
    it.

    We could deal with that by traversing the list before insertion,
    but that's too expensive for this edge case.

    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 7e65c9b16e6c37f2c3f83195c5a57b4d2b8f0a7c
e7a7bedcc88d33793a6525e9337a1a51982bc513 M      arch


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

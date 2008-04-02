From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Wed, 2 Apr 2008 16:09:20 +0200
Message-ID: <20080402160920.dc219007.seraph@xs4all.nl>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	<20080401011518.eb683cff.akpm@linux-foundation.org>
	<1207059115.3100.9.camel@localhost.localdomain>
	<20080401210521.abbb443c.seraph@xs4all.nl>
	<1207081169.3100.20.camel@localhost.localdomain>
	<20080401225717.7d936f91.seraph@xs4all.nl>
	<1207084454.3100.31.camel@localhost.localdomain>
	<20080402122944.7fe8e924.seraph@xs4all.nl>
	<20080402120651.GS16451@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearlgates.net ([82.92.180.13]:46692 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbYDBOJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 10:09:22 -0400
In-Reply-To: <20080402120651.GS16451@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

Finally, bisecting is done. :-)

Well, it took more reboots than a typical Windows XP installation (and thank the heavens for my Sparc64 cross compiler on my Core 2 Duo), but this seems to be the culprit:

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

:040000 040000 7e65c9b16e6c37f2c3f83195c5a57b4d2b8f0a7c e7a7bedcc88d33793a6525e9337a1a51982bc513 M      arch

-- 
Jos van der Ende <seraph@xs4all.nl>

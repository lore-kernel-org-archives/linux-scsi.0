From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 08:42:41 -0800 (PST)
Message-ID: <20081223164241.DADBE108047@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbYLWQnN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 11:43:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBNGgfFZ024565
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 08:42:42 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #15 from anonymous@kernel-bugs.osdl.org  2008-12-23 08:42 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-12-23 at 18:30 +0200, Kai Makisara wrote:
> On Tue, 23 Dec 2008, bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12207
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #13 from alan@lxorguk.ukuu.org.uk  2008-12-23 08:18 -------
> > What may have happened is something else changed to trigger the enforcement of
> > that limit on not block paths ?
> > 
> Something like this ;-) From 2.6.16 st.c has used scsi_execute_async() 
> that sends the request to the block layer.

That's probably it!  Realistically, though, allowing st to override the
block limits was wrong.  Most drivers (except USB) don't set these
arbitrarily, they usually represent fundamental hardware limits.  If you
force down a transaction that's larger than they declared themselves
capable of, they'll do strange things like wrap descriptors or truncate
the transaction, which will cause silent data corruption.

Hopefully we can figure out how to get USB working.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

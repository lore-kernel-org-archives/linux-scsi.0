From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 13:20:41 -0700 (PDT)
Message-ID: <20080401202041.3BC3311D108@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907AbYDAUVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 16:21:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m31KKfVB011366
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 13:20:42 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #6 from anonymous@kernel-bugs.osdl.org  2008-04-01 13:20 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-04-01 at 21:05 +0200, Jos van der Ende wrote:
> Hello all,
> 
> 
> I did a bit more testing, and I think this may be related to the order in which modules are loaded.
> 
> If I let udev load sungem, and load sym53c8xx manually, everything works.
> 
> If I let udev load sym53c8xx, and load sungem manually, I get the non-functional network.
> 
> If I let udev load both modules, I also get the non-functional network. While udev loads sungem first and sym53c8xx later, I don't suppose it waits for one module to 'settle' before loading the next. :-)

That's odd ... it's behaving like a resource conflict.  However, the
ports and interrupt trace didn't betray anything.  What does lspci -vv
say for each of the devices?  Also, if you remove the sym2 module in the
problem case, does the sungem come back to life?

I'm afraid I can't see anything relevant looking over the sym2 changes,
so you might need to bisect this to identify the culprit.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

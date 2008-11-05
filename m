From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue,  4 Nov 2008 18:11:15 -0800 (PST)
Message-ID: <20081105021115.1C93B108056@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbYKECLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 21:11:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA52BF12007077
	for <linux-scsi@vger.kernel.org>; Tue, 4 Nov 2008 18:11:16 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #11 from anonymous@kernel-bugs.osdl.org  2008-11-04 18:11 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-11-04 at 19:55 -0600, Mike Christie wrote:
> bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11898
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #9 from alex.shi@intel.com  2008-11-04 17:32 -------
> > I did bisect for this bug and find the following commit cause this problem.
> > 
> > commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
> > Author: Mike Christie <michaelc@cs.wisc.edu>
> 
> Ok, I am looking into this.

I have a theoretical case that might trigger an endless loop:

Supposing we actually get a two deep starved list.  On first pass, we
process the first entry, but set starved_head to be it.  On second pass,
we get a host_busy.  Now we will loop forever (because we have a single
entry sdev and it's not starved_head) under the host lock, which means
we can never unbusy the host.

A fix would be to set starved_head to NULL after we delete sdev from the
list.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

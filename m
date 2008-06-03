From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Tue,  3 Jun 2008 13:15:34 -0700 (PDT)
Message-ID: <20080603201534.BE46411D109@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506AbYFCUQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 16:16:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m53KFYN5009501
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jun 2008 13:15:35 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10846





------- Comment #7 from anonymous@kernel-bugs.osdl.org  2008-06-03 13:15 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-06-03 at 09:09 -0700, bugme-daemon@bugzilla.kernel.org
wrote: 
> Should we consider, that such a difference is normal. You suggest that before
> the kernel was dangerous at writing data?

It's caching too much streaming data, yes.  The danger is largely the
amount of data you lose on a crash and mismanagement of the cache
starving other applications. It's not that much of a problem.  At an
estimated write speed of ~70MB/s your 1GB of data is only around 15s to
effect a full writeout.

> So unpacking linux kernel (for example) is 5x times slower and it is not a
> problem. That's just new way of caching data? We seldom see crashes (thanks to
> linux) and we have power supply.

There are many factors that could account for that.

> I'd like testing on same hardware windows to see its behaviour and speed.
> Anyway thanks for the clarifying of cache: write through. As you say, it was
> not evident. 
> 
> So, now, what can we do to keep 2.6.21 behaviour? That's for a mail system
> writing lots of little files and performance matters too.

Well, initially, I'd try a benchmark that simulates the actual problem,
like postmark.  A streaming write tells you very little about the entire
system performance under a mail server type load.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

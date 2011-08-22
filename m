From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41552] Performance of writing and reading from multiple drives
 decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and beyond)
Date: Mon, 22 Aug 2011 20:24:22 GMT
Message-ID: <201108222024.p7MKOMIQ018089@demeter1.kernel.org>
References: <bug-41552-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41847 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1HVUYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 16:24:24 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7MKOMNI018090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2011 20:24:23 GMT
In-Reply-To: <bug-41552-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41552





--- Comment #7 from Mark Petersen <mpete_06@hotmail.com>  2011-08-22 20:24:20 ---
The majority of the slowdown we found is coming during the writing as we were
doing limited reading for the purpose of the testing.  It may be that it
happens in both areas, but we did not do extensive testing with the reading
portion of it.

> Date: Mon, 22 Aug 2011 12:24:43 -0700
> From: akpm@linux-foundation.org
> To: mpete_06@hotmail.com
> CC: bugme-daemon@bugzilla.kernel.org; axboe@kernel.dk; vgoyal@redhat.com; linux-mm@kvack.org; linux-scsi@vger.kernel.org
> Subject: Re: [Bugme-new] [Bug 41552] New: Performance of writing and reading from multiple drives decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and beyond)
> 
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Mon, 22 Aug 2011 15:20:41 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=41552
> > 
> >            Summary: Performance of writing and reading from multiple
> >                     drives decreases by 40% when going from Linux Kernel
> >                     2.6.36.4 to 2.6.37 (and beyond)
> >            Product: IO/Storage
> >            Version: 2.5
> >     Kernel Version: 2.6.37
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SCSI
> >         AssignedTo: linux-scsi@vger.kernel.org
> >         ReportedBy: mpete_06@hotmail.com
> >         Regression: No
> > 
> > 
> > We have an application that will write and read from every sector on a drive. 
> > The application can perform these tasks on multiple drives at the same time. 
> > It is designed to run on top of the Linux Kernel, which we periodically update
> > so that we can get the latest device drivers.  When performing the last update
> > from 2.6.33.2 to 2.6.37, we found that the performance of a set of drives
> > decreased by some 40% (took 3 hours and 11 minutes to write and read from 5
> > drives on 2.6.37 versus 2 hours and 12 minutes on 2.6.33.3).  I was able to
> > determine that the issue was in the 2.6.37 Kernel as I was able to run it with
> > the 2.6.36.4 kernel, and it had the better performance.   After seeing that I/O
> > throttling was introduced in the 2.6.37 Kernel, I naturally suspected that. 
> > However, by default, all the throttling was turned off (I attached the actual
> > .config that was used to build the kernel).  I then tried to turn on the
> > throttling and set it to a high number to see what would happen.  When I did
> > that, I was able to reduce the time from 3 hours and 11 minutes to 2 hours and
> > 50 minutes.  There seems to be something there that changed that is impacting
> > performance on multiple drives.  When we do this same test with only one drive,
> > the performance is identical between the systems.  This issue still occurs on
> > Kernel 3.0.2.
> > 
> 
> Are you able to determine whether this regression is due to slower
> reading, to slower writing or to both?
> 
> Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

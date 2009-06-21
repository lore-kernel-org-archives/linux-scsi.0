From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sun, 21 Jun 2009 19:07:13 GMT
Message-ID: <200906211907.n5LJ7D51030300@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47663 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZFUTHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 15:07:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5LJ7Dhp030301
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2009 19:07:13 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-06-21 19:07:13 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2009-06-21 at 18:58 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13594
> 
> 
> 
> 
> 
> --- Comment #3 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2009-06-21 18:58:28 ---
> (In reply to comment #1)
> > This is a message the kernel prints out on all recovered error returns
> > (except those marked REQ_QUIET).  It's purely informational and doesn't
> > affect return processing of the command at all, so the kernel is
> > actually treating this as a successful completion not an error.
> 
> OK.
> 
> > So this sounds like the bug ... however, for the LSI card, this bug will
> > be in the SAT layer in the fusion firmware.  I can shut the kernel up by
> > making the recovered error processing clause look for 01/00/1D as well
> > as REQ_QUIET, but it won't affect this problem.
> 
> I tried reporting this to the Linux fusionmpt driver people a while ago, but
> never received any response (thus this bug)... I guess I'm out of luck,

OK, cc'd LSI people, let's see if I get better luck

>  then,
> if there's nothing that can be done for it in the kernel. It's a bit weird,
> though; one would believe people ran smartd on their systems and discovered
> this already.

I can guess that it's some type of firmware mode problem: either it runs
for SMART or it runs for normal commands, hence the hiatus.  If that's
true, you'd likely only see the problem in a large disk setup ... it
might also be possible to work around by simply quiescing the card
before sending down SMART commands (that would be grossly inefficient,
but at least devices wouldn't get errored).

James

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 13594] SMART responses for SATA disks on SAS get
 interpreted as errors
Date: Sun, 21 Jun 2009 14:07:08 -0500
Message-ID: <1245611228.4328.239.camel@mulgrave.site>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
	 <200906211858.n5LIwS5j027520@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37822 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbZFUTHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Jun 2009 15:07:08 -0400
In-Reply-To: <200906211858.n5LIwS5j027520@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

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



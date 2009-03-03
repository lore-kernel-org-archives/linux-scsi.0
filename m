From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 03 Mar 2009 22:39:50 +0000
Message-ID: <1236119990.24019.35.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
	 <1236115544.15993.22.camel@localhost.localdomain>
	 <20090303214454.GA8288@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48371 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbZCCWjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 17:39:55 -0500
In-Reply-To: <20090303214454.GA8288@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org

On Tue, 2009-03-03 at 22:44 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > So the real question is why does the -rt tree even have 
> > > > patches not in the vanilla SCSI tree?  This type of cockup 
> > > > clearly demonstrates why it's a bad idea.
> > > 
> > > Believe me, i have better things to do than to track down your 
> > > regressions. I applied a fix/test patch sent to me by SCSI 
> > > folks.
> > 
> > Look, I've no problem with you collecting random patches.  I 
> > have a problem when you start pushing random SCSI patches into 
> > other trees. [...]
> 
> Both -tip and -rt are generic trees and there's a connection 
> between them that the maintainers of both are one and the same 
> set of people.
> 
> So i'm not sure on what grounds you purport to be able to 
> prevent fixes from flowing from -tip into -rt and vice versa.
> 
> You have no monopoly on the propagation and testing of SCSI 
> fixes. We picked up a v1 patch from the SCSI list and did not 
> add nor remove anything from it.

OK, let me try and make the problem simpler for you:  If you pick up
random patches outside of your area and apply them without any quality
control (like code inspections, or even understanding how the patches
work) you've created a suspect and quality compromised tree.   This is
fine for your own work and others to test and report back (although the
list will start to see your bug reports as correspondingly lower quality
if you have a high proportion of self induced failures like this one).

However, if you base a feature tree off this compromised tree, now
you're causing extra work for other maintainers who see problems
reported with this tree, and have to take the time to investigate what's
going on.

Worse, supposing there is a genuine SCSI bug exposed by the -rt tree
(say something timing or interrupt related).  So I ask the reporter to
retry with the regular kernel tree and the bug goes away. Now everyone
will think "Oh, it's just because of some SCSI crap Ingo put in his
tree".  Result: the bug goes undiagnosed until it bites several people
in the field, which is an avoidable result.

The executive summary is that your "it works for me, so I'm putting it
in my tree" attitude is damaging our quality process.

James



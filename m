From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 01:47:19 +0100
Message-ID: <20090304004719.GC11782@elte.hu>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr> <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <alpine.LFD.2.00.0903040012040.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903040012040.29264@localhost.localdomain>
Sender: linux-rt-users-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> James,
> 
> On Tue, 3 Mar 2009, James Bottomley wrote:
> > However, if you base a feature tree off this compromised tree, now
> > you're causing extra work for other maintainers who see problems
> > reported with this tree, and have to take the time to investigate what's
> > going on.
> 
> Stop this nonsense. That bug stopped me and Ingo from testing code on
> machines with AIC7xxx controllers for quite a while.
> 
> The patch sent by the author of the SCSI commit which caused the
> breakage in the first place (b60af5b: [SCSI] simplify
> scsi_io_completion()) specifically to Ingo in response to Ingo's bug
> report seemed to fix it and it did not explode, so it was left in the
> -rt origin.patch simply because I forgot about it and there was no fix
> in the mainline kernel which would have made it obsolete.
> 
> Yes, I should have noticed the memory leak, but ...
> 
> > Worse, supposing there is a genuine SCSI bug exposed by the -rt tree
> > (say something timing or interrupt related).  So I ask the reporter to
> > retry with the regular kernel tree and the bug goes away. Now everyone
> > will think "Oh, it's just because of some SCSI crap Ingo put in his
> > tree".  Result: the bug goes undiagnosed until it bites several people
> > in the field, which is an avoidable result.
> > 
> > The executive summary is that your "it works for me, so I'm putting it
> > in my tree" attitude is damaging our quality process.
> 
> So according to your executive summary the full failure of 
> test machines due to a SCSI bug is not damaging anything. 
> These machines are^W have been part of the quality process and 
> stopped working due to wreckage induced by your tree in 
> 29-rc1.
> 
> The executive summary is: stop development and testing until 
> SCSI comes up with a blessed fix.
> 
> You have my full understanding that quality processing defined 
> by SCSI has precedence over general testing.
> 
> Once I'm done with cleaning up the mess caused by the crash in 
> linus tree (w/o any unblessed patches) I'm going to fix the 
> power supply of the AIC7xxx system to make sure it is stand by 
> when a blessed solution pops up in the unforeseeable future.

funny ...

I'd laugh about this if the matter wasnt so serious. According 
to two testers so far aic7xxx is essentially useless in 2.6.29. 

James, what is your action plan to deal with it? A bad commit 
was identified and reverting these commits:

c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"
3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting comma
0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
813104e: Revert "[SCSI] simplify scsi_io_completion()"

fixed the bug according to my testing. Something needs to happen 
and you are the SCSI maintainer.

	Ingo

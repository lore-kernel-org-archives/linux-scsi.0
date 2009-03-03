From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 03 Mar 2009 15:25:43 -0600
Message-ID: <1236115544.15993.22.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20090303192212.GA20705@elte.hu>
Sender: linux-rt-users-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-03-03 at 20:22 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Tue, 2009-03-03 at 17:08 +0100, Jan Engelhardt wrote:
> > > On Tuesday 2009-03-03 16:21, James Bottomley wrote:
> > > >> > $ slabtop
> > > >> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > > >> > 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> > > >> > 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
> > > >> >  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
> > > >> >  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
> > > >> >   8927   8574  96%    0.03K     79      113       316K size-32
> > > >> 
> > > >> Looks like a leak, by failing to call scsi_release_buffers()
> > > >> somehow. (Which was changed recently)
> > > >
> > > >Firstly, I have to say I don't see this in the mainline tree, so could
> > > >you try that with your setup just to verify (git head at 2.6.29-rc6).
> > > 
> > > Yes, looking at the rt patch (in broken-out it's in origin.diff),
> > > it seems a bit obvious - the scsi_release_buffers is not called anymore:
> > 
> > OK, this is a bad patch, so just revert it.  It was posted to 
> > linux-scsi initially in this form before the author posted a 
> > new one with the missing release buffers added.  It looks like 
> > the first incarnation got pulled into the -rt tree for some 
> > reasons.
> 
> Uhm. I applied a test-patch from Alan Stern, to possibly fix an 
> SCSI lockup with aic7xxx that _I_ reported to you and then to 
> the scsi-list.
> 
> You were Cc:-ed to that test patch and to my bugreport as well, 
> all the way. Do you claim that you dont remember it?

?  If I've just quoted the patch above why would I not remember it now.
I've just said it's the cause of the problems in the -rt tree.

> The saga is still documented in tip:out-of-tree (which is a 
> special branch with out-of-tree hotfixes):
> 
>  7e4cbd1: fix "scsi: aic7xxx hang since v2.6.28-rc1"
>  e027abc: scsi: temporarily undo scsi reverts
>  813104e: Revert "[SCSI] simplify scsi_io_completion()"
>  84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
>  0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
>  3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting commands"
>  c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"
> 
> I wasnt Cc:-ed on the updated patch AFAICS, so i didnt pick it 
> up.

Actually, you were cc'd, you probably just missed it.

> > So the real question is why does the -rt tree even have 
> > patches not in the vanilla SCSI tree?  This type of cockup 
> > clearly demonstrates why it's a bad idea.
> 
> Believe me, i have better things to do than to track down your 
> regressions. I applied a fix/test patch sent to me by SCSI 
> folks.

Look, I've no problem with you collecting random patches.  I have a
problem when you start pushing random SCSI patches into other trees.  I
think this thread clearly illustrates why it's a problem.

Even if *I* sent you a patch asking if it fixes your bug, it doesn't
mean you should be deploying it on production systems ... we have
process, like code inspection and integration testing to got through
before patches appear in the SCSI trees.

For the particular patch in question (the corrected form).  I don't
actually believe it's a bug fix.  I've gone over it and best I can tell,
it does what it says it does (merely reposition the code) ... there's no
actual logic alterations at all.  So I think, unfortunately, whatever
the bug is, it's timing related (the patch does shorten some code
paths).  Now, sure, we can cover it up and pretend it's gone, but it's
bound to show up again down the road, so I'd like to find it's root
cause now rather than later.

James



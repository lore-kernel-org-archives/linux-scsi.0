From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 3 Mar 2009 20:22:12 +0100
Message-ID: <20090303192212.GA20705@elte.hu>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr> <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:34016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbZCCTW1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 14:22:27 -0500
Content-Disposition: inline
In-Reply-To: <1236097526.3263.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-03-03 at 17:08 +0100, Jan Engelhardt wrote:
> > On Tuesday 2009-03-03 16:21, James Bottomley wrote:
> > >> > $ slabtop
> > >> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > >> > 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> > >> > 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
> > >> >  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
> > >> >  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
> > >> >   8927   8574  96%    0.03K     79      113       316K size-32
> > >> 
> > >> Looks like a leak, by failing to call scsi_release_buffers()
> > >> somehow. (Which was changed recently)
> > >
> > >Firstly, I have to say I don't see this in the mainline tree, so could
> > >you try that with your setup just to verify (git head at 2.6.29-rc6).
> > 
> > Yes, looking at the rt patch (in broken-out it's in origin.diff),
> > it seems a bit obvious - the scsi_release_buffers is not called anymore:
> 
> OK, this is a bad patch, so just revert it.  It was posted to 
> linux-scsi initially in this form before the author posted a 
> new one with the missing release buffers added.  It looks like 
> the first incarnation got pulled into the -rt tree for some 
> reasons.

Uhm. I applied a test-patch from Alan Stern, to possibly fix an 
SCSI lockup with aic7xxx that _I_ reported to you and then to 
the scsi-list.

You were Cc:-ed to that test patch and to my bugreport as well, 
all the way. Do you claim that you dont remember it?

The saga is still documented in tip:out-of-tree (which is a 
special branch with out-of-tree hotfixes):

 7e4cbd1: fix "scsi: aic7xxx hang since v2.6.28-rc1"
 e027abc: scsi: temporarily undo scsi reverts
 813104e: Revert "[SCSI] simplify scsi_io_completion()"
 84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
 0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
 3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting commands"
 c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"

I wasnt Cc:-ed on the updated patch AFAICS, so i didnt pick it 
up.

> So the real question is why does the -rt tree even have 
> patches not in the vanilla SCSI tree?  This type of cockup 
> clearly demonstrates why it's a bad idea.

Believe me, i have better things to do than to track down your 
regressions. I applied a fix/test patch sent to me by SCSI 
folks.

	Ingo

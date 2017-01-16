From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Mon, 16 Jan 2017 06:24:02 -0800
Message-ID: <1484576642.2540.17.camel@HansenPartnership.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
         <1484496665.2405.2.camel@HansenPartnership.com>
         <20170116092255.GB1398@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170116092255.GB1398@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-01-16 at 10:22 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Sun, 2017-01-15 at 10:19 +0100, Ingo Molnar wrote:
> > > So there's a new mpt3sas SCSI driver boot regression, introduced
> > > in 
> > > this merge window, which made one of my servers unbootable.
> > 
> > We're not reverting a fix that would cause regressions for others. 
> 
> You really need to reconsider that stance ...
> 
> > However, The fix was manifestly wrong, so does this fix of the fix
> > work for you:
> > 
> > http://marc.info/?l=linux-scsi&m=148329237807604
> > 
> > It's been languishing a bit because no-one seemed to care enough to
> > test or review it.  IOf you can add a tested by, that will give the
> > two
> > we need to push it.
> 
> I have tested your other patch that you pointed to:
> 
>   http://marc.info/?l=linux-scsi&m=148449968522828
> 
> Which patch fixes the bug too (I removed my revert first) - so you
> can add my:
> 
>   Reported-by: Ingo Molnar <mingo@kernel.org>
>   Tested-by: Ingo Molnar <mingo@kernel.org>

Thanks ... just checking you tested the second version with the
concurrency part?

> BTW., is it wise to work around the out of spec firmware in the 
> mpt3sas code and leave the overly optimistic assumptions in the SCSI 
> code intact? The problem is that other SCSI hardware could be 
> affected as well - and especially enterprise class server hardware 
> has long testing and thus regression latencies (as my example
> proves).

Realistically, there is no other card.  Every other SAS implementation
uses the in-kernel SAT, which does the right thing.  We've suggested on
a few occasions that the mpt SAS might like to use it as well, given we
keep tripping on SAT problems in their firmware.

> Wouldn't it be more robust to only submit one pass-through command at 
> a time from the SCSI layer, and maybe opt-in hardware that is known 
> to implement the SAT standard fully?

Unfortunately it's a lot more complex: the standard gives a queueing
mechanism for SAT pass through, so mostly you *can* have multiple
commands outstanding, so it looks like we shouldn't globally restrict
that.  However, it seems the mpt3 firmware is using a queue single
command model *and* not doing the right thing with return codes hence
the failure.  Since the failure mode is mpt3 specific, I think the best
place for the fix is in their code.  We can revisit this decision if
something else comes along that also has this problem (UAS springs to
mind).

James


> (But I'm just kibitzing here really.)

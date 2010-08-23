From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 11:59:00 -0500
Message-ID: <1282582740.11194.17.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	 <1282077040.16098.47.camel@mulgrave.site> <4C6C1DC1.8090208@vlnb.net>
	 <1282164188.10878.22.camel@mulgrave.site> <4C702030.2070306@vlnb.net>
	 <1282423128.3015.35.camel@mulgrave.site>
	 <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48603 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0HWQ7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 12:59:07 -0400
In-Reply-To: <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gennadiy Nerubayev <parakie@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2010-08-22 at 18:10 -0400, Gennadiy Nerubayev wrote: 
> On Sat, Aug 21, 2010 at 4:38 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Sat, 2010-08-21 at 22:51 +0400, Vladislav Bolkhovitin wrote:
> >> James Bottomley, on 08/19/2010 12:43 AM wrote:
> >> >>>> 1. What don't you like in the transition path for users from STGT to
> >> >>>> SCST, which I proposed:
> >> >>>>
> >> >>>>     - The only people which would be affected by replacing of STGT by SCST
> >> >>>> would be users of ibmvstgt. Other STGT users would not notice it at all.
> >> >>>> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
> >> >>>> the update for its users would be just writing of a simple scstadmin's
> >> >>>> config file.
> >> >>>>
> >> >>>>     - STGT doesn't have backend drivers, which SCST doesn't have, so
> >> >>>> there's nothing to worry here. At max, AIO support should be added to
> >> >>>> fileio_tgt.
> >> >>>>
> >> >>>>     - STGT user space targets can use SCST backend via scst_local module.
> >> >>>> Scst_local module is ready and work very well.
> >> >>>>
> >> >>>> The result would be very clear without any obsolete mess.
> >> >>>
> >> >>> So does that get us up to being a drop in replacement?  I think you're
> >> >>> saying that even with all of this, at least the VSCSI part will need
> >> >>> updating, so the answer seems to be "no".
> >> >>
> >> >> Sorry, I can't understand, "no" for which? For the whole transition
> >> >> path, or just until there is a patch for ibmvstgt to become ibmvscst?
> >> >
> >> > No to the question "does that get us up to being a drop in replacement
> >> > [for STGT]?"
> >>
> >> I'm sorry again, I did my best, but still can't understand. What you
> >> wrote looks for me too ambiguous. My English must be too bad..
> >>
> >> Could elaborate more for what the "no" is, please? What don't you like
> >> in the plan I suggested?
> >
> > No it isn't a plan that gives us a drop in replacement for STGT.  I
> > didn't say migration path to random userspace target, I said reuse of
> > existing code.
> 
> Hi James,
> 
> (disclaimer: I'm a hoi polloi SCST user)
> 
> I'm not sure if I understand why there is a need for a replacement
> target to reuse existing code, and would definitely appreciate a brief
> explanation or a pointer to an earlier one.

The best thread on the topic is this massive one:

http://marc.info/?t=120109820100005

I want replacement because evidence suggests that multiple things doing
the same thing don't get as much attention as a single one.  We need to
support STGT because it's the one that has the in-kernel user base.
Just breaking them constitutes an ABI problem under the new kernel
rules.

> But even that aside, I'm
> curious if the criteria for what a replacement target must have for
> (at least potential) inclusion into the kernel were ever clearly
> outlined in the past. If they were, then there probably would have
> been things like interested contenders, deadlines, feature
> comparisons, code reviews, and so on, right?

Yes, in that thread.

My basic conclusion was that there's no incredible discriminator between
LIO and STGT (although there are reams written on which performs better
in which circumsances, is useful for clustering, supports ALUA, etc.
each with partisans for the features).  If the two communities can't
work together (as seems to be the case) and I have to choose one, I'll
go by what helps me which, as I've said before, are:

     1. That it would be a drop in replacement for STGT (our current
        in-kernel target mode driver), since he only wanted a single
        SCSI target infrastructure. 
        
     2. That it used a modern sysfs based control and configuration
        plane. 
        
     3. That the code was reviewed as clean enough for inclusion.


> Now, I can't claim familiarity with the kernel development process, or
> any "political" workings in it. The aforementioned however would seem
> like a logical way of doing this since I assume that for whatever
> reason, there is a strict limit to only one generic SCSI target in the
> Linux kernel, and obviously as per this thread the current one is
> being replaced.

Well, my preference would be to keep STGT.  However, I indicated to both
target infrastructures that if they could satisfy the above, I'd be OK
with replacing STGT, so I'm not about to go back on that after causing
quite a large amount of work.

James



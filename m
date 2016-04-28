From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 08:40:38 -0700
Message-ID: <1461858038.2307.16.camel@HansenPartnership.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
	 <20160428121108.GA9903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59724 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbcD1Pkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 11:40:41 -0400
In-Reply-To: <20160428121108.GA9903@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On Thu, 2016-04-28 at 08:11 -0400, Mike Snitzer wrote:
> On Wed, Apr 27 2016 at  7:39pm -0400,
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>  
> > Multipath - Mike Snitzer
> > ------------------------
> > 
> > Mike began with a request for feedback, which quickly lead to the
> > complaint that recovery time (and how you recover) was one of the
> > biggest issues in device mapper multipath (dmmp) for those in the room.
> >   This is primarily caused by having to wait for the pending I/O to be
> > released by the failing path. Christoph Hellwig said that NVMe would
> > soon do path failover internally (without any need for dmmp) and asked
> > if people would be interested in a more general implementation of this.
> >  Martin Petersen said he would look at implementing this in SCSI as
> > well.  The discussion noted that internal path failover only works in
> > the case where the transport is the same across all the paths and
> > supports some type of path down notification.  In any cases where this
> > isn't true (such as failover from fibre channel to iSCSI) you still
> > have to use dmmp.  Other benefits of internal path failover are that
> > the transport level code is much better qualified to recognise when the
> > same device appears over multiple paths, so it should make a lot of the
> > configuration seamless.  The consequence for end users would be that
> > now SCSI devices would become handles for end devices rather than
> > handles for paths to end devices.
> 
> I must've been so distracted by the relatively baseless nature of
> Christoph's desire to absorb multipath functionality into NVMe (at least
> as Christoph presented/defended) that I completely missed the existing
> SCSI error recovery woes as something that is DM multipath's fault.
> There was a session earlier in LSF that dealt with the inefficiencies of
> SCSI error recovery and the associated issues have _nothing_ to do with
> DM multipath.  So please clarify how pushing multipath (failover) down
> into the drivers will fix the much more problematic SCSI error recovery.

The specific problem in SCSI is that we can't signal path failure until
the mid layer eh has completed, which can take ages.  I don't believe
anyone said this was the fault of dm.  However, it does have a visible
consequence in dm in that path failover takes forever (in machine
time).

One way of fixing this is to move failover to the transport layer where
path failure is signalled and take the commands away from the failed
path and on to an alternative before the the mid-layer is even aware we
have a problem.

> Also, there was a lot of cross-talk during this session so I never heard
> that Martin is talking about following Christoph's approach to push
> multipath (failover) down to SCSI.  In fact Christoph advocated that DM
> multipath carry on being used for SCSI and that only NVMe adopt his
> approach.  So this comes as a surprise.

Well one other possibility is to take the requests away much sooner in
the eh cycle.  The thing that keeps us from signalling path failure is
the fact that eh is using the existing commands to do the recovery so
they're not released by the mid-layer until eh is completed.  In theory
we can release the commands earlier once we know we hit the device hard
enough.  However, I've got to say doing the failover before eh begins
does look to be much faster.

> What wasn't captured in your summary is the complete lack of substance
> to justify these changes.  The verdict is still very much out on the
> need for NVMe to grow multipath functionality (let alone SCSI drivers).
> Any work that i done in this area really needs to be justified with
> _real_ data.

Well, the entire room, that's vendors, users and implementors
complained that path failover takes far too long.  I think in their
minds this is enough substance to go on.

> The other _major_ gripe expressed during the session was how the
> userspace multipath-tools are too difficult and complex for users.
> IIRC these complaints really weren't expressed in ways that could be
> used to actually _fix_ the perceived shortcomings but nevertheless...

Tooling could be better, but it isn't going to fix the time to failover
problem.

> Full disclosure: I'll be looking at reinstating bio-based DM multipath to
> regain efficiencies that now really matter when issuing IO to extremely
> fast devices (e.g. NVMe).  bio cloning is now very cheap (due to
> immutable biovecs), coupled with the emerging multipage biovec work that
> will help construct larger bios, so I think it is worth pursuing to at
> least keep our options open.

OK, but remember the reason we moved from bio to request was partly to
be nearer to the device but also because at that time requests were
accumulations of bios which had to be broken out, go back up the stack
individually and be re-elevated, which adds to the inefficiency.  In
theory the bio splitting work will mean that we only have one or two
split bios per request (because they were constructed from a split up
huge bio), but when we send them back to the top to be reconstructed as
requests there's no guarantee that the split will be correct a second
time around and we might end up resplitting the already split bios.  If
you do reassembly into the huge bio again before resend down the next
queue, that's starting to look like quite a lot of work as well.


James


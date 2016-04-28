From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 08:11:08 -0400
Message-ID: <20160428121108.GA9903@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbcD1MLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 08:11:11 -0400
Content-Disposition: inline
In-Reply-To: <1461800389.2311.70.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On Wed, Apr 27 2016 at  7:39pm -0400,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
 
> Multipath - Mike Snitzer
> ------------------------
> 
> Mike began with a request for feedback, which quickly lead to the
> complaint that recovery time (and how you recover) was one of the
> biggest issues in device mapper multipath (dmmp) for those in the room.
>   This is primarily caused by having to wait for the pending I/O to be
> released by the failing path. Christoph Hellwig said that NVMe would
> soon do path failover internally (without any need for dmmp) and asked
> if people would be interested in a more general implementation of this.
>  Martin Petersen said he would look at implementing this in SCSI as
> well.  The discussion noted that internal path failover only works in
> the case where the transport is the same across all the paths and
> supports some type of path down notification.  In any cases where this
> isn't true (such as failover from fibre channel to iSCSI) you still
> have to use dmmp.  Other benefits of internal path failover are that
> the transport level code is much better qualified to recognise when the
> same device appears over multiple paths, so it should make a lot of the
> configuration seamless.  The consequence for end users would be that
> now SCSI devices would become handles for end devices rather than
> handles for paths to end devices.

I must've been so distracted by the relatively baseless nature of
Christoph's desire to absorb multipath functionality into NVMe (at least
as Christoph presented/defended) that I completely missed the existing
SCSI error recovery woes as something that is DM multipath's fault.
There was a session earlier in LSF that dealt with the inefficiencies of
SCSI error recovery and the associated issues have _nothing_ to do with
DM multipath.  So please clarify how pushing multipath (failover) down
into the drivers will fix the much more problematic SCSI error recovery.

Also, there was a lot of cross-talk during this session so I never heard
that Martin is talking about following Christoph's approach to push
multipath (failover) down to SCSI.  In fact Christoph advocated that DM
multipath carry on being used for SCSI and that only NVMe adopt his
approach.  So this comes as a surprise.

What wasn't captured in your summary is the complete lack of substance
to justify these changes.  The verdict is still very much out on the
need for NVMe to grow multipath functionality (let alone SCSI drivers).
Any work that i done in this area really needs to be justified with
_real_ data.

The other _major_ gripe expressed during the session was how the
userspace multipath-tools are too difficult and complex for users.
IIRC these complaints really weren't expressed in ways that could be
used to actually _fix_ the perceived shortcomings but nevertheless...

Full disclosure: I'll be looking at reinstating bio-based DM multipath to
regain efficiencies that now really matter when issuing IO to extremely
fast devices (e.g. NVMe).  bio cloning is now very cheap (due to
immutable biovecs), coupled with the emerging multipage biovec work that
will help construct larger bios, so I think it is worth pursuing to at
least keep our options open.

Mike

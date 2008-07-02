From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 02 Jul 2008 11:32:29 -0500
Message-ID: <1215016350.3330.32.camel@localhost.localdomain>
References: <877ic8o4iq.fsf@denkblock.local>
	 <87prpxnv4w.fsf@denkblock.local>
	 <1214963700.3316.41.camel@localhost.localdomain>
	 <87zlp0n4p8.fsf@denkblock.local>
	 <1215009983.3330.14.camel@localhost.localdomain>
	 <87vdzomg4c.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183AbYGBQcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 12:32:33 -0400
In-Reply-To: <87vdzomg4c.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-07-02 at 17:59 +0200, Elias Oltmanns wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Wed, 2008-07-02 at 09:08 +0200, Elias Oltmanns wrote:
> >> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> >> > On Tue, 2008-07-01 at 23:37 +0200, Elias Oltmanns wrote:
> >> >> Hi James,
> >> >
> >> >> 
> >> >> sorry for bothering you but I've just noticed that the patch below has
> >> >> neither been scheduled for the stable review, nor queued up for Linus.
> >> >> May be you just don't consider this serious enough for these trees but I
> >> >> wanted to make sure that the situation will be dealt with eventualy. The
> >> >> patch applies to 2.6.26-rc8.
> >> >
> >> > OK, well at first glance, the locking around device_blocked and
> >> > host_blocked looks pointless.  What are the failure traces you're using
> >> > to decide they need spinlock protection?
> >> 
> >> scsi_queue_insert() as well as scsi_finish_command() can be called at
> >> any time as part of regular command completion or error handling. There
> >> is no reason why the ->request_fn() for the same device or for another
> >> device on the same host should not be in progress at the same time.
> >
> > So would I be correct in deducing you haven't seen an observed failure?
> 
> Yes, I don't even have an SMP machine.
> 
> >
> > The reason no locks are necessary is that there's no race to mediate.
> > The checks are only is it set or not ...
> 
> I'm not sure whether that is of any consequence. Don't get me wrong, I
> really don't know and you may well be right. But how exactly does
> decrementing from 2 to 1 work? Do we know for sure that there will
> always be at least one bit set so reading that address will reliably
> return a non zero value?

both the check and the decrement are under a lock already. But anyway,
for an int, we always read an integral value (that's a guarantee of the
CPU architecture)

> > unless we get down to zero depth in which case the decrements are done
> > under lock.
> 
> Sorry, but this simply doesn't resolve the matter at hand.
> scsi_finish_command() can change (host|device)_blocked values to zero at
> any time currently *not* protected by any lock. In much the same way
> scsi_queue_insert() can change these values from zero to something else
> at any time.

Look more closely at the requirements for the decrements:  There have to
be no outstanding commands: nothing can be in scsi_finish_command for
the device (or the host for host_blocked).  Likewise,
scsi_queue_insert() is called either for retry return (but nothing
outstanding, so can't) or for queuecommand() failure.

The way locking changes in the queue function introduces a race ... the
block check to the queuecommand.  Introducing additional locking around
the variable setting can't mediate that race, so the code has to be
prepared for it (which it is).

> >
> >> > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> >> > itself looks like it might not entirely need the queue lock ... I need
> >> > to investigate more closely.
> >> 
> >> Well, I rather think it does. We have to serialise access to the
> >> unplug_timer and there is a call to __set_bit() which, as I understand,
> >> requires the calling function to ensure atomicity.
> >
> > It does at the moment ... it just looks like it could make use of
> > test_and_set_bit() to avoid the requirement.  The access to the timer
> > uses mod_timer() which is specifically designed not to require
> > serialisation.
> 
> Concurrent calls to mod_timer() are alright; I'm not so sure what
> happens when del_timer() is called at the same time (haven't checked
> though, so you might be right here).

James



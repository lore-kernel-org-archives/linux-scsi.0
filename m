From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 02 Jul 2008 09:46:23 -0500
Message-ID: <1215009983.3330.14.camel@localhost.localdomain>
References: <877ic8o4iq.fsf@denkblock.local>
	 <87prpxnv4w.fsf@denkblock.local>
	 <1214963700.3316.41.camel@localhost.localdomain>
	 <87zlp0n4p8.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34740 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbYGBOq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 10:46:26 -0400
In-Reply-To: <87zlp0n4p8.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-07-02 at 09:08 +0200, Elias Oltmanns wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Tue, 2008-07-01 at 23:37 +0200, Elias Oltmanns wrote:
> >> Hi James,
> >
> >> 
> >> sorry for bothering you but I've just noticed that the patch below has
> >> neither been scheduled for the stable review, nor queued up for Linus.
> >> May be you just don't consider this serious enough for these trees but I
> >> wanted to make sure that the situation will be dealt with eventualy. The
> >> patch applies to 2.6.26-rc8.
> >
> > OK, well at first glance, the locking around device_blocked and
> > host_blocked looks pointless.  What are the failure traces you're using
> > to decide they need spinlock protection?
> 
> scsi_queue_insert() as well as scsi_finish_command() can be called at
> any time as part of regular command completion or error handling. There
> is no reason why the ->request_fn() for the same device or for another
> device on the same host should not be in progress at the same time.

So would I be correct in deducing you haven't seen an observed failure?

The reason no locks are necessary is that there's no race to mediate.
The checks are only is it set or not ... unless we get down to zero
depth in which case the decrements are done under lock.

> > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> > itself looks like it might not entirely need the queue lock ... I need
> > to investigate more closely.
> 
> Well, I rather think it does. We have to serialise access to the
> unplug_timer and there is a call to __set_bit() which, as I understand,
> requires the calling function to ensure atomicity.

It does at the moment ... it just looks like it could make use of
test_and_set_bit() to avoid the requirement.  The access to the timer
uses mod_timer() which is specifically designed not to require
serialisation.

James



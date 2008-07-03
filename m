From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 21:47:43 +0200
Message-ID: <87zloyzr4w.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
	<87zlp0n4p8.fsf@denkblock.local> <20080702115030.GK20055@kernel.dk>
	<1215010189.3330.17.camel@localhost.localdomain>
	<20080702184526.GM20055@kernel.dk>
	<1215029903.3330.38.camel@localhost.localdomain>
	<87mykz1k08.fsf@denkblock.local> <87iqvn1ccf.fsf@denkblock.local>
	<20080703112456.GV20055@kernel.dk>
	<1215102715.3309.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:48234 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbYGCTrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 15:47:52 -0400
In-Reply-To: <1215102715.3309.50.camel@localhost.localdomain> (James
	Bottomley's message of "Thu, 03 Jul 2008 11:31:55 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-07-03 at 13:24 +0200, Jens Axboe wrote:
>> On Thu, Jul 03 2008, Elias Oltmanns wrote:
>
>> > Elias Oltmanns <eo@nebensachen.de> wrote:
>> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> > >> On Wed, 2008-07-02 at 20:45 +0200, Jens Axboe wrote:
>> > >
>> > >>> On Wed, Jul 02 2008, James Bottomley wrote:
>> > >>
>> > >>> > On Wed, 2008-07-02 at 13:50 +0200, Jens Axboe wrote:
>> > >>> > > Yep, blk_plug_device() needs to be called with the queue lock held.
>> > >>> > 
>> > >>> > That's what the comment says ... but if you replaced the test_bit with
>> > >>> > an atomic operation then the rest of it does look to be in no need of
>> > >>> > serialisation ... unless there's something I missed?
>> > >>> 
>> > >>> Indeed, but then you would have to use atomic bitops everywhere and that
>> > >>> is the bit we moved away from.
>> > >>
>> > >> Not necessarily ... only for QUEUE_FLAG_CLUSTER.  That's really only in
>> > >> this one place and then the one in blk_remove_plug would have to become
>> > >> test_and_clear_bit.  All the other places barring loop_unplug() are only
>> > >> tests (which don't affect the atomicity).
>> > >>
>> > >> It's just for SCSI the double spin lock followed by double spin unlock
>> > >> to get the locking right is kind of nasty ... I'm just wondering what
>> > >> the universe would look like if it were rendered unnecessary.
>> > >
>> > > We have to consider one more thing: Without the locking in
>> > > blk_plug_device(), the following sequence of events may occur:
>> > 
>> > Actually, it's worse than that. Locking is required in order to make
>> > absolutely sure that the unplug_timer is active iff QUEUE_FLAG_PLUGGED
>> > is set. Admittedly, it seems *very* unlikely that blk_remove_plug() will
>> > complete before the call to mod_timer() in blk_plug_device() even though
>> > it has started only *after* a call to test_and_set_bit(). However, if
>> > such a thing would ever happen, it could have dire consequences.
>> 
>> Both are races possible without either atomic bitops or the queue lock
>> being held. We can't properly mix eg set_bit() and __set_bit(). The
>> plugged bit is the most hammered, so it's staying non-atomic and SCSI
>> will need to provide proper locking there.
>
> You're the boss.
>
> Actually, after all of this, it looks like the host queue plug is
> superfluous.  If the host actually says not ready from
> scsi_host_queue_ready() we go to the not ready processing clause in
> scsi_prep_fn() which actually checks the outstanding on the current
> device and plugs the queue if there aren't any commands.  This is
> actually more correct behaviour than a blind plug regardless (and it's
> also done under the queue lock), so I think this is the correct fix.

Indeed, a very neat way out. Will this be queued up for stable too?

Regards,

Elias

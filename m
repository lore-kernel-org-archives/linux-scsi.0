From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 09:53:27 +0200
Message-ID: <87mykz1k08.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
	<87zlp0n4p8.fsf@denkblock.local> <20080702115030.GK20055@kernel.dk>
	<1215010189.3330.17.camel@localhost.localdomain>
	<20080702184526.GM20055@kernel.dk>
	<1215029903.3330.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:59763 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937034AbYGCHx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 03:53:56 -0400
In-Reply-To: <1215029903.3330.38.camel@localhost.localdomain> (James
	Bottomley's message of "Wed, 02 Jul 2008 15:18:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-07-02 at 20:45 +0200, Jens Axboe wrote:
>> On Wed, Jul 02 2008, James Bottomley wrote:
>
>> > On Wed, 2008-07-02 at 13:50 +0200, Jens Axboe wrote:
>> > > On Wed, Jul 02 2008, Elias Oltmanns wrote:
>> > > > > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
>> > > > > itself looks like it might not entirely need the queue lock ... I need
>> > > > > to investigate more closely.
>> > > > 
>> > > > Well, I rather think it does. We have to serialise access to the
>> > > > unplug_timer and there is a call to __set_bit() which, as I understand,
>> > > > requires the calling function to ensure atomicity.
>> > > 
>> > > Yep, blk_plug_device() needs to be called with the queue lock held.
>> > 
>> > That's what the comment says ... but if you replaced the test_bit with
>> > an atomic operation then the rest of it does look to be in no need of
>> > serialisation ... unless there's something I missed?
>> 
>> Indeed, but then you would have to use atomic bitops everywhere and that
>> is the bit we moved away from.
>
> Not necessarily ... only for QUEUE_FLAG_CLUSTER.  That's really only in
> this one place and then the one in blk_remove_plug would have to become
> test_and_clear_bit.  All the other places barring loop_unplug() are only
> tests (which don't affect the atomicity).
>
> It's just for SCSI the double spin lock followed by double spin unlock
> to get the locking right is kind of nasty ... I'm just wondering what
> the universe would look like if it were rendered unnecessary.

We have to consider one more thing: Without the locking in
blk_plug_device(), the following sequence of events may occur:

1. Some calls blk_plug_device().
2. Someone else calls blk_stop_queue() right after the check in
   blk_plug_device() has been performed but before the
   test_and_set_bit() has been called.
3. The unplug_timer expires, __generic_unplug_device() discovers that
   the queue has been stopped in the meantime and returns without
   removing the plug.
4. Someone calls blk_start_queue() later on which will execute the
   ->request_fn() even though blk_queue_plugged() is still true.

In order to resolve this, we'd have to switch the calls to
blk_remove_plug() and blk_queue_stopped() in __generic_unplug_device().
I'm not quite sure at the moment whether this would have any further
implications.

Regards,

Elias

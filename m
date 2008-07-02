From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 02 Jul 2008 15:18:23 -0500
Message-ID: <1215029903.3330.38.camel@localhost.localdomain>
References: <877ic8o4iq.fsf@denkblock.local>
	 <87prpxnv4w.fsf@denkblock.local>
	 <1214963700.3316.41.camel@localhost.localdomain>
	 <87zlp0n4p8.fsf@denkblock.local> <20080702115030.GK20055@kernel.dk>
	 <1215010189.3330.17.camel@localhost.localdomain>
	 <20080702184526.GM20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52653 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYGBUS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 16:18:28 -0400
In-Reply-To: <20080702184526.GM20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-07-02 at 20:45 +0200, Jens Axboe wrote:
> On Wed, Jul 02 2008, James Bottomley wrote:
> > On Wed, 2008-07-02 at 13:50 +0200, Jens Axboe wrote:
> > > On Wed, Jul 02 2008, Elias Oltmanns wrote:
> > > > > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> > > > > itself looks like it might not entirely need the queue lock ... I need
> > > > > to investigate more closely.
> > > > 
> > > > Well, I rather think it does. We have to serialise access to the
> > > > unplug_timer and there is a call to __set_bit() which, as I understand,
> > > > requires the calling function to ensure atomicity.
> > > 
> > > Yep, blk_plug_device() needs to be called with the queue lock held.
> > 
> > That's what the comment says ... but if you replaced the test_bit with
> > an atomic operation then the rest of it does look to be in no need of
> > serialisation ... unless there's something I missed?
> 
> Indeed, but then you would have to use atomic bitops everywhere and that
> is the bit we moved away from.

Not necessarily ... only for QUEUE_FLAG_CLUSTER.  That's really only in
this one place and then the one in blk_remove_plug would have to become
test_and_clear_bit.  All the other places barring loop_unplug() are only
tests (which don't affect the atomicity).

It's just for SCSI the double spin lock followed by double spin unlock
to get the locking right is kind of nasty ... I'm just wondering what
the universe would look like if it were rendered unnecessary.

James




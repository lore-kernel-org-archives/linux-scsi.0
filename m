From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 12:38:56 +0200
Message-ID: <87iqvn1ccf.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
	<87zlp0n4p8.fsf@denkblock.local> <20080702115030.GK20055@kernel.dk>
	<1215010189.3330.17.camel@localhost.localdomain>
	<20080702184526.GM20055@kernel.dk>
	<1215029903.3330.38.camel@localhost.localdomain>
	<87mykz1k08.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:50301 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbYGCMT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 08:19:26 -0400
In-Reply-To: <87mykz1k08.fsf@denkblock.local> (Elias Oltmanns's message of
	"Thu, 03 Jul 2008 09:53:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

Elias Oltmanns <eo@nebensachen.de> wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> On Wed, 2008-07-02 at 20:45 +0200, Jens Axboe wrote:
>
>>> On Wed, Jul 02 2008, James Bottomley wrote:
>>
>>> > On Wed, 2008-07-02 at 13:50 +0200, Jens Axboe wrote:
>>> > > Yep, blk_plug_device() needs to be called with the queue lock held.
>>> > 
>>> > That's what the comment says ... but if you replaced the test_bit with
>>> > an atomic operation then the rest of it does look to be in no need of
>>> > serialisation ... unless there's something I missed?
>>> 
>>> Indeed, but then you would have to use atomic bitops everywhere and that
>>> is the bit we moved away from.
>>
>> Not necessarily ... only for QUEUE_FLAG_CLUSTER.  That's really only in
>> this one place and then the one in blk_remove_plug would have to become
>> test_and_clear_bit.  All the other places barring loop_unplug() are only
>> tests (which don't affect the atomicity).
>>
>> It's just for SCSI the double spin lock followed by double spin unlock
>> to get the locking right is kind of nasty ... I'm just wondering what
>> the universe would look like if it were rendered unnecessary.
>
> We have to consider one more thing: Without the locking in
> blk_plug_device(), the following sequence of events may occur:

Actually, it's worse than that. Locking is required in order to make
absolutely sure that the unplug_timer is active iff QUEUE_FLAG_PLUGGED
is set. Admittedly, it seems *very* unlikely that blk_remove_plug() will
complete before the call to mod_timer() in blk_plug_device() even though
it has started only *after* a call to test_and_set_bit(). However, if
such a thing would ever happen, it could have dire consequences.

Regards,

Elias

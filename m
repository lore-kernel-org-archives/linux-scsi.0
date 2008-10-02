From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Block: Fix blk_start_queueing() so as not to process a stopped queue
Date: Thu, 02 Oct 2008 17:55:47 +0200
Message-ID: <8763obq9do.fsf@denkblock.local>
References: <87wsgtb4t6.fsf@denkblock.local>
	<20081001074843.GA19428@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:45521 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYJBPzz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 11:55:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

[Adding linux-scsi since this may be of interest there.]

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Oct 01 2008, Elias Oltmanns wrote:
>> Especially since blk_start_queueing() is used as the unplug_fn() callback
>
>> by the cfq scheduler, we'd better make it behave like a proper unplug
>> function. That is to say, return immediately if the queue is stopped.
>> 
>> Cc: stable <stable@kernel.org>
>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>> ---
>> This is not a recent regression, so it might not be accepted as an rc
>> fix. However, it most definitely is a bug and should go into a stable
>> release. Applies to 2.6.27-rc8.
>
> I don't think this is by far serious enough for -stable. Please let me
> know what bad behaviour you observed due to this bug?

Well, I have come across this bug by applying the out-of-tree disk shock
protection patch. I realise that this is not a good incentive for adding
queueing this up for stable. However, a quick look through the tree
revealed that blk_stop_queue() is used in various places. I probably
have to admit that my vote for inclusion into stable was mainly founded
on the assumption that ``restoring the expected behaviour'' was the safe
option, whereas you are quite right in saying that it is safer to leave
code alone until it has actually proven to behave erroneously. So, here
are some facts and considerations for you to decide for yourself whether
this should go into stable or not:

As far as I can tell, the IDE subsystem is not affected by this bug in
any way. Even though I haven't really made an effor to understand all
the pieces of code in drivers/block/ that use blk_stop_queue(), I am now
under the impression that the bug doesn't cause serious problems there
either. SCSI, on the other hand, seems to be a different matter. Here,
the functions that stop the queue, additionally change the sdev into the
SDEV_BLOCK state. Running the cfq scheduler, I can reliably freeze my
system which I attribute to the following sequence of events:

1. After scsi_request_fn() has exhausted the queue depth of the LLDD, it
   prepares one more request by means of *_prep_fn() and sets the
   DONTPREP flag. Then it realises that the LLDD queue is full and
   leaves the request (fully prepared) on the block layer queue and
   exits eventually.
2. For some reason or other, scsi_internal_device_block() gets called
   which stops the queue and transitions sdev into the SDEV_BLOCK state.
3. When the next FS request arrives, cfq calls blk_start_queueing() from
   cfq_rq_enqueued().
4. Now, the first request scsi_request_fn() takes off the queue is the
   one marked as DONTPREP. Thus, the request is passed on to
   scsi_dispatch_cmd().
5. Here the request is requeued by means of scsi_queue_insert() because
   sdev is in the SDEV_BLOCK state.
6. Eventually, we end up calling __blk_run_queue() and enter a busy loop
   because the second time round the REENTER flag is set and unplug is
   scheduled.

Due to the busy loop entered in step #6, other threads in the system
don't get a chance to put things right and unblock the device. Coming
back to the question at hand (stable patch warranted or not), I can only
reproduce this system freeze by using the out-of-tree shock protection
patch. However, there are in-tree users of scsi_internal_device_block()
in scsi_transport_iscsi.c and scsi_transport_fc.c. Since I don't have an
environment to test either of these code paths, I can't test whether
they will show a similar behaviour. Still, the code suggests to me that
an intermittent network failure may freeze the system in much the same
way as described above. If that is not enough incentive to get this
patch into a stable release and if nobody else can actually test and
confirm my suspicion that iscsi is vulnerable, I have to accept that, of
course.

Apart from everything else, the analysis of this problem has made me
wonder whether some more checks for blk_queue_stopped() are in order.
I'll send you a second patch concerning this issue directly. Please
note, however, that the original patch (the one you have committed
already) is required and, indeed, sufficient to prevent system freezes
as described above. The patch I'm going to send you next is definitely
not critical in that sense but merely ensures consistency, i.e. users of
blk_stop_queue() can rest assured that the ->request_fn() won't be
called before they issue blk_start_queue().

Regards,

Elias

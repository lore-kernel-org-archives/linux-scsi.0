From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] block: Check that queue is alive in blk_insert_cloned_request()
Date: Tue, 12 Jul 2011 17:02:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107121643210.8898-100000@netrider.rowland.org>
References: <1310495298.16900.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39449 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754998Ab1GLVC0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 17:02:26 -0400
In-Reply-To: <1310495298.16900.24.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>

On Tue, 12 Jul 2011, James Bottomley wrote:

> > I think one problem point is q->queue_lock. If driver drops its reference
> > on queue and cleans up its data structures, then it will free up memory
> > associated with q->queue_lock too. (If driver provided its own queue
> > lock). In that case anything which is dependent on queue lock, needs
> > to be freed up on blk_cleanup_queue().
> 
> I don't quite follow.  blk_cleanup_queue() doesn't free anything (well,
> except the elevator).  Final put will free the queue structure which
> contains the lock, but if it's really a final put, you have no other
> possible references, so no-one is using the lock ... well, assuming
> there isn't a programming error, of course ...
> 
> > If we can make sure that request queue reference will keep the spin lock
> > alive, then i guess all cleanup part might be able to go in release
> > queue function.
> 
> As I said: cleanup doesn't free the structure containing the lock,
> release does, so that piece wouldn't be altered by putting
> blk_cleanup_queue() elsewhere.

It's worth taking a closer look at what happened here.  Originally
request_queue->queuedata was set to NULL and blk_cleanup_queue() was
called from scsi_device_dev_release_usercontext() (by way of
scsi_free_queue()).  This caused a problem because there was a window
in which the last reference to the scsi_device had been dropped but the
release routine hadn't yet run, so the queue was still marked as active
(i.e., queuedata was still non-NULL).

Commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b ([SCSI] put stricter 
guards on queue dead checks) was written to fix this problem.  However 
it moved _both_ lines from the release routine into 
__scsi_remove_device().  There was no need for this; all that was 
needed was to make sure queuedata was NULL before the device reference 
was dropped.

And in fact, moving the call to scsi_free_queue() has opened up another
window for bugs.  Now it's possible for requests to get on the queue
(submitted by drivers from another layer that still hold a reference to
the scsi_device) even after the queue's elevator has been freed.  Yes,
the block layer is supposed to prevent this from happening, but there
are multiple paths and they don't all have the requisite checks.

And as Vivek points out, it's questionable whether they _can_ make the 
proper checks.  Checking requires the queue's lock, but the client may 
have deallocated the lock at the time the queue was cleaned up.  Maybe 
SCSI doesn't do this, but other clients of the block layer might.  The 
block layer can't make any assumptions.  The unavoidable conclusion is 
that the clients must be responsible for insuring that no requests are 
added to a queue after its lock has been released.

To help accomplish this in SCSI, I'm suggesting that the call to
scsi_free_queue() be moved back to where it used to be, in
scsi_device_dev_release_usercontext().  Then it won't be possible for
any wayward requests to be added to the queue after it is cleaned up,
because there won't be any outstanding references to the scsi_device.

Alan Stern


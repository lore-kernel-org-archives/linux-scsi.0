From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 21:25:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324202509.GF2371@suse.de>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7F688C.3020009@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Mar 24 2003, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> >On Mon, Mar 24, 2003 at 12:12:07PM -0500, Luben Tuikov wrote:
> >
> >>If scsi_queue_next_request(q, cmd) is running on more than one CPU
> >>and q != q1 then you have a problem with the starved devices list.
> >
> >
> >Not with the current locking: we lock queue_lock (equal to host_lock)
> >at the start of scsi_queue_next_request, and unlock at the end of
> >scsi_queue_next_request.
> 
> Are you sure that all device's request queues will use
> the same lock (the host lock) in the future?
> 
> My problem is that your patch code for scsi_queue_next_request()
> behaves as if q->queue_lock is the same for all devices' request_queues
> of the host.  And this is a _special case_, valid only at the present!!!!
> 
> I absolutely _detest_ the fact that the host_lock is used to lock LLDD's
> entry points, SCSI Core's data, *and* the request queues for
> all devices of the host... Talk about serializaion!
> 
> But okay, if you want to leave it like it is, holding the q->lock
> all over the place, _*PLEASE*_, put a comment saying that
> the q->lock is actually the host_lock and locks all the
> queues for all devices on the host... similar to my ``detest''
> paragraph above.  And if this were to be ever changed then
> the individual locks will have to be attained and released...
> and lots of code _rewritten_.

Irk no, that's quite a bad idea.

I completely agree with you that making assumptions about q->queue_lock
== host lock is really really bad. Don't do that.

-- 
Jens Axboe


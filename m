From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 12:38:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324123813.A11614@beaverton.ibm.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com> <20030324202509.GF2371@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030324202509.GF2371@suse.de>; from axboe@suse.de on Mon, Mar 24, 2003 at 09:25:09PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Luben Tuikov <luben@splentec.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Mar 24, 2003 at 09:25:09PM +0100, Jens Axboe wrote:
> On Mon, Mar 24 2003, Luben Tuikov wrote:
> > Patrick Mansfield wrote:
> > >On Mon, Mar 24, 2003 at 12:12:07PM -0500, Luben Tuikov wrote:
> > >
> > >>If scsi_queue_next_request(q, cmd) is running on more than one CPU
> > >>and q != q1 then you have a problem with the starved devices list.
> > >
> > >
> > >Not with the current locking: we lock queue_lock (equal to host_lock)
> > >at the start of scsi_queue_next_request, and unlock at the end of
> > >scsi_queue_next_request.
> > 
> > Are you sure that all device's request queues will use
> > the same lock (the host lock) in the future?

That is another patch.

> Irk no, that's quite a bad idea.
> 
> I completely agree with you that making assumptions about q->queue_lock
> == host lock is really really bad. Don't do that.
> 
> -- 
> Jens Axboe

Yes, it's bad (with or without the patch in question), I am working on
patches to make queue_lock per scsi_device (queue_lock != host_lock),
where I'm forced to make changes in this same area.

-- Patrick Mansfield

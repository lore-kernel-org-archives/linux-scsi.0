From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 13:56:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324135640.A12273@beaverton.ibm.com>
References: <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com> <20030324202509.GF2371@suse.de> <20030324123813.A11614@beaverton.ibm.com> <3E7F77D6.9040300@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7F77D6.9040300@splentec.com>; from luben@splentec.com on Mon, Mar 24, 2003 at 04:25:42PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Mar 24, 2003 at 04:25:42PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > 
> > That is another patch.
> 
> Then you should've sent it before this one.

I would have if I was modifying the locking code.

> But nevertheless, the code of the patch you posted,
> assumed that q->queue_lock is the same for all
> devices' request queues.  This was my beef
> since the very beginning of this thread.

Yes, and that is no different from the current code.

> >>Irk no, that's quite a bad idea.
> >>
> >>I completely agree with you that making assumptions about q->queue_lock
> >>== host lock is really really bad. Don't do that.
> > 
> > Yes, it's bad (with or without the patch in question), I am working on
> 
> No!  With the patch in question.
> 
> The rest of SCSI Core assumes that q->queue_lock has nothing to do
> with any other q's lock.

The current code in scsi_queue_next_request() assume queue_lock ==
host_lock, as does code in scsi_error.c. We get a queue_lock (or
host_lock), and then iterate over different q's calling
__blk_run_queue(q).

-- Patrick Mansfield

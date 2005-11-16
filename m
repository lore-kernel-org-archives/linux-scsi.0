From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] libata error handling fixes (ATAPI)
Date: Wed, 16 Nov 2005 16:04:05 +0100
Message-ID: <58cb370e0511160704w4803a085h7bd6ab352d8c94e6@mail.gmail.com>
References: <20051114195717.GA24373@havoc.gtf.org>
	 <20051115074148.GA17459@htj.dyndns.org> <4379AA5B.1060900@pobox.com>
	 <4379B28E.9070708@gmail.com> <4379C062.3010302@pobox.com>
	 <20051115120016.GD7787@suse.de> <437A2814.1060308@cs.wisc.edu>
	 <20051115184131.GJ7787@suse.de> <20051116124035.GX7787@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051116124035.GX7787@suse.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/16/05, Jens Axboe <axboe@suse.de> wrote:

> I updated that patch, and converted IDE and SCSI to use it. See the
> results here:
>
> http://brick.kernel.dk/git/?p=linux-2.6-block.git;a=shortlog;h=blk-softirq

I like it but:

* "we know it's either an FS or PC request" assumption in
  ide_softirq_done() is really wrong
* same with "uptodate = rq->errors"
* blk_complete_request() is called with ide_lock hold but
  ide_softirq_done() also takes ide_lock - is this correct?

"There's still room for improvement, as __ide_end_request() really
could drop the lock after getting HWGROUP->rq (why does it need to
hold it in the first place? If ->rq access isn't serialized, we are
screwed anyways)."

ide_preempt?  and yes we are screwed...

Bartlomiej

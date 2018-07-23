From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [stable-4.14 00/23] block/scsi multiqueue performance enhancement and
Date: Mon, 23 Jul 2018 17:00:08 +0200
Message-ID: <CA+res+TE5-mgnQys67zQ8cqRyv+dgNPpTFLOEq81t2izpq1dsw@mail.gmail.com>
References: <1532352285-13589-1-git-send-email-jinpuwang@gmail.com> <20180723133356.GA1333@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180723133356.GA1333@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Wang Jinpu <xjtuwjp@gmail.com>, stable@vger.kernel.org, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

Thanks for quick reply. Please see reply inline.



Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2018=E5=B9=B47=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Jul 23, 2018 at 03:24:22PM +0200, Jack Wang wrote:
> > Hi Greg,
> >
> > Please consider this patchset, which include block/scsi multiqueue perf=
ormance
> > enhancement and bugfix.
>
> What exactly is the performance enhancement?  How can you measure it?
> How did you measure it?
I'm testing on SRP/IBNBD using fio, I've seen +10% with mix IO load,
and 50% improvement on small IO (bs=3D512.) with the patchset.

>
> Which one(s) are the bugfixes in this series?  Why not just submit those
> separately as they should be "obvious fixes", right?
We had queue stall problem on shared hctx restart, my colleague Roman
reported to upstream:
https://lkml.org/lkml/2017/10/18/263
the patch wasn't taken by upstream, and a bigger patchset from Lei
Ming was accepted instread with revert and further bugfix later on.

following patches meant for improving performance on scsi-mq, and also
contains the attempt to fix the queue stall problem
 358a3a6bccb7 ("blk-mq: don't handle TAG_SHARED in restart")
  blk-mq-sched: move actual dispatching into one helper
  blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
  sbitmap: introduce __sbitmap_for_each_set()
  blk-mq-sched: improve dispatching from sw queue
  scsi: allow passing in null rq to scsi_prep_state_check()
  scsi: implement .get_budget and .put_budget for blk-mq
  SCSI: don't get target/host busy_count in scsi_mq_get_budget()
  blk-mq: don't handle TAG_SHARED in restart
  blk-mq: don't restart queue when .get_budget returns BLK_STS_RESOURCE
  blk-mq: don't handle failure in .get_budget

Following is independent fix:
blk-mq: quiesce queue during switching io sched and updating nr_requests
blk-mq: fix issue with shared tag queue re-running

These are clearup for flush request handling:
  blk-flush: don't run queue for requests bypassing flush
  block: pass 'run_queue' to blk_mq_request_bypass_insert
  blk-flush: use blk_mq_request_bypass_insert()
  blk-mq-sched: decide how to handle flush rq via RQF_FLUSH_SEQ
  blk-mq: move blk_mq_put_driver_tag*() into blk-mq.h
  blk-mq: don't allocate driver tag upfront for flush rq

The left are following up fixes.
>
> And why didn't you cc: the subsystem maintainer and mailing list here?
> I need their ack before I could take these.
Sorry, my mistake, now add Jens, linux-block, ilnux-scsi in reply.

Sorry for confusion.
>
> thanks,
>
> greg k-h

Regards,
Jack Wang

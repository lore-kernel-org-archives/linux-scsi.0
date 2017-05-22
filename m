From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 07/18] block: Introduce request_queue.initialize_rq_fn()
Date: Mon, 22 May 2017 17:07:13 +0000
Message-ID: <1495472831.2610.4.camel@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
         <20170519183016.12646-8-bart.vanassche@sandisk.com>
         <20170521063443.GF12287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170521063443.GF12287@lst.de>
Content-Language: en-US
Content-ID: <C2A03BD7A7B24644AF264055BD2A6994@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-05-21 at 08:34 +0200, Christoph Hellwig wrote:
> On Fri, May 19, 2017 at 11:30:05AM -0700, Bart Van Assche wrote:
> > Several block drivers need to initialize the driver-private data
> > after having called blk_get_request() and before .prep_rq_fn() is
> > called, e.g. when submitting a REQ_OP_SCSI_* request. Avoid that
> > that initialization code has to be repeated after every
> > blk_get_request() call by adding a new callback function to struct
> > request_queue.
> >=20
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Jens Axboe <axboe@fb.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Omar Sandoval <osandov@fb.com>
> > Cc: Hannes Reinecke <hare@suse.com>
> > Cc: linux-block@vger.kernel.org
> > ---
> >  block/blk-core.c       | 3 +++
> >  block/blk-mq.c         | 3 +++
> >  include/linux/blkdev.h | 4 ++++
> >  3 files changed, 10 insertions(+)
> >=20
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index a69d420b7ff0..f2540d164679 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -126,6 +126,9 @@ void blk_rq_init(struct request_queue *q, struct re=
quest *rq)
> >  	rq->start_time =3D jiffies;
> >  	set_start_time_ns(rq);
> >  	rq->part =3D NULL;
> > +
> > +	if (q->initialize_rq_fn)
> > +		q->initialize_rq_fn(rq);
>=20
> Can we keep this out of the fast path and only do it from the
> blk_get_request / blk_mq_alloc_request path?  And while were at it
> I think those two should be merged as far as the public interface
> goes, that is we should also expose the flags argument for the
> legacy path.

Hello Christoph,

For blk-mq I could move the .initialize_rq_fn() call from
blk_mq_rq_ctx_init() into blk_mq_sched_get_request(). I can't move it
higher up in the request allocation call chain because otherwise
blk_mq_alloc_request_hctx() wouldn't call .initialize_rq_fn().

For blk-sq I'm not sure that the .initialize_rq_fn() call can be
moved because I'd like all blk_rq_init() callers to call
.initialize_rq_fn(), including ide_prep_sense().

Are you sure it would help to move the .initialize_rq_fn() calls?

Thanks,

Bart.=

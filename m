From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/9] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Thu, 1 Jun 2017 23:09:00 +0000
Message-ID: <1496358538.3075.12.camel@sandisk.com>
References: <20170531123706.20885-1-ming.lei@redhat.com>
         <20170531123706.20885-4-ming.lei@redhat.com>
         <1496244100.2608.3.camel@sandisk.com> <20170601005423.GA23563@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170601005423.GA23563@ming.t460p>
Content-Language: en-US
Content-ID: <9FD2FDAFCD537B4B931F3B0AB502F1A8@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-06-01 at 08:54 +0800, Ming Lei wrote:
> On Wed, May 31, 2017 at 03:21:41PM +0000, Bart Van Assche wrote:
> > On Wed, 2017-05-31 at 20:37 +0800, Ming Lei wrote:
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 99e16ac479e3..ffcf05765e2b 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -3031,7 +3031,10 @@ scsi_internal_device_unblock(struct scsi_devic=
e *sdev,
> > >  		return -EINVAL;
> > > =20
> > >  	if (q->mq_ops) {
> > > -		blk_mq_start_stopped_hw_queues(q, false);
> > > +		if (blk_queue_quiesced(q))
> > > +			blk_mq_unquiesce_queue(q);
> > > +		else
> > > +			blk_mq_start_stopped_hw_queues(q, false);
> > >  	} else {
> > >  		spin_lock_irqsave(q->queue_lock, flags);
> > >  		blk_start_queue(q);
> >=20
> > As I commented on v2, this change is really wrong. All what's needed he=
re is
> > a call to blk_mq_unquiesce_queue() and nothing else. Adding a call to
> > blk_mq_start_stopped_hw_queues() is wrong because it makes it impossibl=
e to
> > use the STOPPED flag in the SCSI core to make the block layer core stop=
 calling
> > .queue_rq() if a SCSI LLD returns "busy".
>=20
> I am not sure if I understand your idea, could you explain a bit why it i=
s wrong?
>=20
> Let's see the function of scsi_internal_device_block():
>=20
> 	if (q->mq_ops) {
>                 if (wait)
>                         blk_mq_quiesce_queue(q);
>                 else
>                         blk_mq_stop_hw_queues(q);
> 	}
>=20
> So the queue may be put into quiesced if 'wait' is true, or it is
> stopped if 'wait' is false.
>=20
> And this patch just makes the two SCSI APIs symmetrical.
>=20
> Since we will not stop queue in blk_mq_quiesce_queue() later,
> I have to unquiese one queue only if it is quiesced.
>=20
> So suppose the queue is put into stopped in scsi_internal_device_block(),
> do we expect not to restart it in scsi_internal_device_unblock() via
> blk_mq_unquiesce_queue()?

Hello Ming,

My opinion is that scsi_internal_device_block() and scsi_internal_device_un=
block()
should be changed as follows for the scsi-mq code path:
* scsi_internal_device_block() should call blk_mq_quiesce_queue(q) if the "=
wait"
  argument is true and should set the QUEUE_FLAG_QUIESCED flag if the "wait=
"
  argument is false.
* scsi_internal_device_unblock() should call blk_mq_unquiesce_queue().

I am aware it sounds weird to set the QUEUE_FLAG_QUIESCED flag without wait=
ing
until ongoing .queue_rq() calls have finished. The only driver that trigger=
s
that code path is the mpt3sas driver. I think it's unfortunate that that dr=
iver
has ever been allowed to call scsi_internal_device_block() because it's the=
 only
driver that calls that function from a context where sleeping is not allowe=
d.
No matter whether the scsi_internal_device_block() call from the mpt3sas dr=
iver
sets the QUEUE_FLAG_QUIESCED or the BLK_MQ_S_STOPPED flag, I don't think th=
at
will have the effect the authors of this driver intended. Unfortunately I'm=
 not
familiar enough with the mpt3sas driver to fix that driver myself.

Note: these changes conflict with a patch SCSI patch series I started worki=
ng on
about two months ago. See also https://www.spinics.net/lists/linux-scsi/msg=
109103.html.

Bart.=

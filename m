From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/6] SCSI: use blk_mq_run_hw_queues() in scsi_kick_queue()
Date: Wed, 12 Jul 2017 15:12:37 +0000
Message-ID: <1499872355.2554.1.camel@wdc.com>
References: <20170711182103.11461-1-ming.lei@redhat.com>
         <20170711182103.11461-3-ming.lei@redhat.com>
         <1499803071.2586.29.camel@wdc.com> <20170712031503.GG13036@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170712031503.GG13036@ming.t460p>
Content-Language: en-US
Content-ID: <62D031D5D1726C45BC4517708EF74259@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-07-12 at 11:15 +0800, Ming Lei wrote:
> On Tue, Jul 11, 2017 at 07:57:53PM +0000, Bart Van Assche wrote:
> > On Wed, 2017-07-12 at 02:20 +0800, Ming Lei wrote:
> > > Now SCSI won't stop queue, and not necessary to use
> > > blk_mq_start_hw_queues(), so switch to blk_mq_run_hw_queues()
> > > instead.
> > >=20
> > > Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> > > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > > Cc: linux-scsi@vger.kernel.org
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/scsi/scsi_lib.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index f6097b89d5d3..91d890356b78 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -333,7 +333,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
> > >  static void scsi_kick_queue(struct request_queue *q)
> > >  {
> > >  	if (q->mq_ops)
> > > -		blk_mq_start_hw_queues(q);
> > > +		blk_mq_run_hw_queues(q, false);
> > >  	else
> > >  		blk_run_queue(q);
> > >  }
> >=20
> > Hello Ming,
> >=20
> > Now that we have separate flags to represent the "stopped" and "quiesce=
d"
> > states, wouldn't it be better not to modify scsi_kick_queue() but inste=
ad to
> > stop a SCSI hardware queue again if scsi_queue_rq() returns BLK_STS_RES=
OURCE?
> > See also commits 36e3cf273977 ("scsi: Avoid that SCSI queues get stuck"=
) and
> > commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped queu=
es").
>=20
> As you can see in the following patches, all stop/start queue APIs will
> be removed, and the 'stopped' state will become a internal state.
>=20
> It doesn't make sense to clear 'stopped' for scsi anymore, since the
> queue won't be stopped actually. So we need this change.

Hello Ming,

As Jens already noticed, this approach won't work properly for concurrent I=
/O
to multiple LUNs associated with the same SCSI host. This approach won't wo=
rk
properly for dm-mpath either. Sorry but I'm not convinced that it's possibl=
e
to replace the stop/start queue API for all block drivers by an algorithm
that is based on estimating the queue depth.

Bart.=

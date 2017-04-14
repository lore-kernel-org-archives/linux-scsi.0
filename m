From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Fri, 14 Apr 2017 17:12:50 +0000
Message-ID: <1492189969.2644.9.camel@sandisk.com>
References: <20170411160958.GA19222@redhat.com>
         <1491928005.2654.6.camel@sandisk.com> <20170411174739.GA19620@redhat.com>
         <1491933092.2654.10.camel@sandisk.com> <20170411180358.GA19660@redhat.com>
         <1491934715.2654.14.camel@sandisk.com> <20170412034229.GA8835@ming.t460p>
         <1492022286.2764.15.camel@sandisk.com> <20170413022030.GD8835@ming.t460p>
         <25ebc19f-f6e0-2f71-f590-8416359d2fd1@sandisk.com>
         <20170414011324.GA29916@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170414011324.GA29916@ming.t460p>
Content-Language: en-US
Content-ID: <AE9D19915D1C354FA4761515ABBF6CDF@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-04-14 at 09:13 +0800, Ming Lei wrote:
> On Thu, Apr 13, 2017 at 09:59:57AM -0700, Bart Van Assche wrote:
> > On 04/12/17 19:20, Ming Lei wrote:
> > > On Wed, Apr 12, 2017 at 06:38:07PM +0000, Bart Van Assche wrote:
> > > > If the blk-mq core would always rerun a hardware queue if a block d=
river
> > > > returns BLK_MQ_RQ_QUEUE_BUSY then that would cause 100% of a single=
 CPU core
> > >=20
> > > It won't casue 100% CPU utilization since we restart queue in complet=
ion
> > > path and at that time at least one tag is available, then progress ca=
n be
> > > made.
> >=20
> > Hello Ming,
> >=20
> > Sorry but you are wrong. If .queue_rq() returns BLK_MQ_RQ_QUEUE_BUSY
> > then it's likely that calling .queue_rq() again after only a few
> > microseconds will cause it to return BLK_MQ_RQ_QUEUE_BUSY again. If you
> > don't believe me, change "if (!blk_mq_sched_needs_restart(hctx) &&
> > !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state)) blk_mq_run_hw_queue(hctx=
,
> > true);" into "blk_mq_run_hw_queue(hctx, true);", trigger a busy
>=20
> Yes, that can be true, but I mean it is still OK to run the queue again
> with
>=20
> 	if (!blk_mq_sched_needs_restart(hctx) &&
> 	    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
> 			blk_mq_run_hw_queue(hctx, true);
>=20
> and restarting queue in __blk_mq_finish_request() when
> BLK_MQ_RQ_QUEUE_BUSY is returned from .queue_rq(). And both are in curren=
t
> blk-mq implementation.
>=20
> Then why do we need blk_mq_delay_run_hw_queue(hctx, 100/*ms*/) in dm?

Because if dm_mq_queue_rq() returns BLK_MQ_RQ_QUEUE_BUSY that there is no
guarantee that __blk_mq_finish_request() will be called later on for the
same queue. dm_mq_queue_rq() can e.g. return BLK_MQ_RQ_QUEUE_BUSY while no
dm requests are in progress because the SCSI error handler is active for
all underlying paths. See also scsi_lld_busy() and scsi_host_in_recovery().

Bart.=

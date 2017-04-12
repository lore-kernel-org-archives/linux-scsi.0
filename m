From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Wed, 12 Apr 2017 18:38:07 +0000
Message-ID: <1492022286.2764.15.camel@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
         <20170407181654.27836-7-bart.vanassche@sandisk.com>
         <20170411160958.GA19222@redhat.com> <1491928005.2654.6.camel@sandisk.com>
         <20170411174739.GA19620@redhat.com> <1491933092.2654.10.camel@sandisk.com>
         <20170411180358.GA19660@redhat.com> <1491934715.2654.14.camel@sandisk.com>
         <20170412034229.GA8835@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54361 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbdDLSiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 14:38:14 -0400
In-Reply-To: <20170412034229.GA8835@ming.t460p>
Content-Language: en-US
Content-ID: <050D402D8C05EC44817B4A65BF718469@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Wed, 2017-04-12 at 11:42 +0800, Ming Lei wrote:
> On Tue, Apr 11, 2017 at 06:18:36PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-04-11 at 14:03 -0400, Mike Snitzer wrote:
> > > Rather than working so hard to use DM code against me, your argument
> > > should be: "blk-mq drivers X, Y and Z rerun the hw queue; this is a w=
ell
> > > established pattern"
> > >=20
> > > I see drivers/nvme/host/fc.c:nvme_fc_start_fcp_op() does.  But that i=
s
> > > only one other driver out of ~20 BLK_MQ_RQ_QUEUE_BUSY returns
> > > tree-wide.
> > >=20
> > > Could be there are some others, but hardly a well-established pattern=
.
> >=20
> > Hello Mike,
> >=20
> > Several blk-mq drivers that can return BLK_MQ_RQ_QUEUE_BUSY from their
> > .queue_rq() implementation stop the request queue=A0(blk_mq_stop_hw_que=
ue())
> > before returning "busy" and restart the queue after the busy condition =
has
> > been cleared (blk_mq_start_stopped_hw_queues()). Examples are virtio_bl=
k and
> > xen-blkfront. However, this approach is not appropriate for the dm-mq c=
ore
> > nor for the scsi core since both drivers already use the "stopped" stat=
e for
> > another purpose than tracking whether or not a hardware queue is busy. =
Hence
> > the blk_mq_delay_run_hw_queue() and blk_mq_run_hw_queue() calls in thes=
e last
> > two drivers to rerun a hardware queue after the busy state has been cle=
ared.
>=20
> But looks this patch just reruns the hw queue after 100ms, which isn't
> that after the busy state has been cleared, right?

Hello Ming,

That patch can be considered as a first step that can be refined further, n=
amely
by modifying the dm-rq code further such that dm-rq queues are only rerun a=
fter
the busy condition has been cleared. The patch at the start of this thread =
is
easier to review and easier to test than any patch that would only rerun dm=
-rq
queues after the busy condition has been cleared.

> Actually if BLK_MQ_RQ_QUEUE_BUSY is returned from .queue_rq(), blk-mq
> will buffer this request into hctx->dispatch and run the hw queue again,
> so looks blk_mq_delay_run_hw_queue() in this situation shouldn't have bee=
n
> needed at my 1st impression.

If the blk-mq core would always rerun a hardware queue if a block driver
returns BLK_MQ_RQ_QUEUE_BUSY then that would cause 100% of a single CPU cor=
e
to be busy with polling a hardware queue until the "busy" condition has bee=
n
cleared. One can see easily that that's not what the blk-mq core does. From
blk_mq_sched_dispatch_requests():

	if (!list_empty(&rq_list)) {
		blk_mq_sched_mark_restart_hctx(hctx);
		did_work =3D blk_mq_dispatch_rq_list(q, &rq_list);
	}

>From the end of blk_mq_dispatch_rq_list():

	if (!list_empty(list)) {
		[ ... ]
		if (!blk_mq_sched_needs_restart(hctx) &&
		=A0=A0=A0=A0!test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
			blk_mq_run_hw_queue(hctx, true);
	}

In other words, the BLK_MQ_S_SCHED_RESTART flag is set before the dispatch =
list
is examined and only if that flag gets cleared while blk_mq_dispatch_rq_lis=
t()
is in progress by a concurrent blk_mq_sched_restart_hctx() call then the
dispatch list will be rerun after a block driver returned=A0BLK_MQ_RQ_QUEUE=
_BUSY.

Bart.=

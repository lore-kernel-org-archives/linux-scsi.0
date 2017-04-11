From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Tue, 11 Apr 2017 18:18:36 +0000
Message-ID: <1491934715.2654.14.camel@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
         <20170407181654.27836-7-bart.vanassche@sandisk.com>
         <20170411160958.GA19222@redhat.com> <1491928005.2654.6.camel@sandisk.com>
         <20170411174739.GA19620@redhat.com> <1491933092.2654.10.camel@sandisk.com>
         <20170411180358.GA19660@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170411180358.GA19660@redhat.com>
Content-Language: en-US
Content-ID: <B7E0FC2196B2C2459F1B969594A247BC@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-11 at 14:03 -0400, Mike Snitzer wrote:
> Rather than working so hard to use DM code against me, your argument
> should be: "blk-mq drivers X, Y and Z rerun the hw queue; this is a well
> established pattern"
>=20
> I see drivers/nvme/host/fc.c:nvme_fc_start_fcp_op() does.  But that is
> only one other driver out of ~20 BLK_MQ_RQ_QUEUE_BUSY returns
> tree-wide.
>=20
> Could be there are some others, but hardly a well-established pattern.

Hello Mike,

Several blk-mq drivers that can return BLK_MQ_RQ_QUEUE_BUSY from their
.queue_rq() implementation stop the request queue=A0(blk_mq_stop_hw_queue()=
)
before returning "busy" and restart the queue after the busy condition has
been cleared (blk_mq_start_stopped_hw_queues()). Examples are virtio_blk an=
d
xen-blkfront. However, this approach is not appropriate for the dm-mq core
nor for the scsi core since both drivers already use the "stopped" state fo=
r
another purpose than tracking whether or not a hardware queue is busy. Henc=
e
the blk_mq_delay_run_hw_queue() and blk_mq_run_hw_queue() calls in these la=
st
two drivers to rerun a hardware queue after the busy state has been cleared=
.

Bart.=

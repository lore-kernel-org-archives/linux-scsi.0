From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH V2 0/8] block/scsi: safe SCSI quiescing
Date: Sat, 02 Sep 2017 09:12:25 +0200
Message-ID: <2212118.DtQQmenjk6@natalenko.name>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

With regard to suspend/resume cycle:

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

On p=C3=A1tek 1. z=C3=A1=C5=99=C3=AD 2017 20:49:49 CEST Ming Lei wrote:
> Hi,
>=20
> The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.
>=20
> Once SCSI device is put into QUIESCE, no new request except for RQF_PREEM=
PT
> can be dispatched to SCSI successfully, and scsi_device_quiesce() just
> simply waits for completion of I/Os dispatched to SCSI stack. It isn't
> enough at all.
>=20
> Because new request still can be allocated, but all the allocated
> requests can't be dispatched successfully, so request pool can be
> consumed up easily.
>=20
> Then request with RQF_PREEMPT can't be allocated, and system may
> hang forever, such as during system suspend or SCSI domain alidation.
>=20
> Both IO hang inside system suspend[1] or SCSI domain validation
> were reported before.
>=20
> This patch tries to solve the issue by freezing block queue during
> SCSI quiescing, and allowing to allocate request of RQF_PREEMPT
> when queue is frozen.
>=20
> Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> them all by introducing preempt version of blk_freeze_queue() and
> blk_unfreeze_queue().
>=20
> V2:
> 	- drop the 1st patch in V1 because percpu_ref_is_dying() is
> 	enough as pointed by Tejun
>=20
> 	- introduce preempt version of blk_[freeze|unfreeze]_queue
>=20
> 	- sync between preempt freeze and normal freeze
>=20
> 	- fix warning from percpu-refcount as reported by Oleksandr
>=20
>=20
> [1] https://marc.info/?t=3D150340250100013&r=3D3&w=3D2
>=20
>=20
>=20
> Ming Lei (8):
>   blk-mq: rename blk_mq_unfreeze_queue as blk_unfreeze_queue
>   blk-mq: rename blk_mq_freeze_queue as blk_freeze_queue
>   blk-mq: only run hw queues for blk-mq
>   blk-mq: rename blk_mq_freeze_queue_wait as blk_freeze_queue_wait
>   block: tracking request allocation with q_usage_counter
>   block: allow to allocate req with REQF_PREEMPT when queue is frozen
>   block: introduce preempt version of blk_[freeze|unfreeze]_queue
>   SCSI: freeze block queue when SCSI device is put into quiesce
>=20
>  block/bfq-iosched.c      |   2 +-
>  block/blk-cgroup.c       |   8 ++--
>  block/blk-core.c         |  50 ++++++++++++++++----
>  block/blk-mq.c           | 119
> ++++++++++++++++++++++++++++++++++++----------- block/blk-mq.h           =
|=20
>  1 -
>  block/blk.h              |   6 +++
>  block/elevator.c         |   4 +-
>  drivers/block/loop.c     |  16 +++----
>  drivers/block/rbd.c      |   2 +-
>  drivers/nvme/host/core.c |   8 ++--
>  drivers/scsi/scsi_lib.c  |  21 ++++++++-
>  include/linux/blk-mq.h   |  15 +++---
>  include/linux/blkdev.h   |  20 +++++++-
>  13 files changed, 206 insertions(+), 66 deletions(-)

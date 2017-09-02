From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH V3 0/8] block/scsi: safe SCSI quiescing
Date: Sat, 02 Sep 2017 16:47:19 +0200
Message-ID: <9524396.xaYzBpxu59@natalenko.name>
References: <20170902130840.24609-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:19780 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752660AbdIBOr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Sep 2017 10:47:27 -0400
In-Reply-To: <20170902130840.24609-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>

Again,

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

On sobota 2. z=C3=A1=C5=99=C3=AD 2017 15:08:32 CEST Ming Lei wrote:
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
> This patch introduces preempt freez, and tries to solve the issue
> by preempt freezing block queue during SCSI quiesce, and allows
> to allocate request of RQF_PREEMPT when queue is preempt-frozen.
>=20
> Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> them all by introducing blk_freeze_queue_preempt() and
> blk_unfreeze_queue_preempt(), also unifying current interfaces for
> freezing queue between block legacy and blk-mq.
>=20
> Oleksandr has verified that this patchset V2 fixes his I/O hang
> during suspend/resume cycle.
>=20
> V3:
> 	- introduce q->preempt_unfreezing to fix one bug of preempt freeze
> 	- call blk_queue_enter_live() only when queue is preempt frozen
> 	- cleanup a bit on the implementation of preempt freeze
> 	- only patch 6 and 7 are changed
>=20
> V2:
> 	- drop the 1st patch in V1 because percpu_ref_is_dying() is
> 	enough as pointed by Tejun
> 	- introduce preempt version of blk_[freeze|unfreeze]_queue
> 	- sync between preempt freeze and normal freeze
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
>   block: introduce preempt version of blk_[freeze|unfreeze]_queue
>   block: allow to allocate req with REQF_PREEMPT when queue is preempt
>     frozen
>   SCSI: preempt freeze block queue when SCSI device is put into quiesce
>=20
>  block/bfq-iosched.c      |   2 +-
>  block/blk-cgroup.c       |   8 +--
>  block/blk-core.c         |  53 ++++++++++++---
>  block/blk-mq.c           | 170
> +++++++++++++++++++++++++++++++++++++++-------- block/blk-mq.h           =
|=20
>  1 -
>  block/blk.h              |  17 +++++
>  block/elevator.c         |   4 +-
>  drivers/block/loop.c     |  16 ++---
>  drivers/block/rbd.c      |   2 +-
>  drivers/nvme/host/core.c |   8 +--
>  drivers/scsi/scsi_lib.c  |  22 +++++-
>  include/linux/blk-mq.h   |  15 +++--
>  include/linux/blkdev.h   |  21 +++++-
>  13 files changed, 273 insertions(+), 66 deletions(-)

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 4 Aug 2016 10:42:36 -0700
Message-ID: <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
References: <1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
	<20160803004013.GA19956@redhat.com>
	<eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
	<20160804161047.GC6989@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160804161047.GC6989@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/04/2016 09:10 AM, Mike Snitzer wrote:
> Anyway, at this point you're having us test too many changes that aren't
> yet upstream:
>
> $ git diff bart/srp-initiator-for-next dm/dm-4.7-mpath-fixes -- drivers block include kernel | diffstat
>  block/bio-integrity.c                   |    1
>  block/blk-cgroup.c                      |    4
>  block/blk-core.c                        |   16 ---
>  block/blk-mq.c                          |   16 ---
>  block/partition-generic.c               |    3
>  drivers/acpi/acpica/nswalk.c            |    1
>  drivers/infiniband/core/rw.c            |   24 +++--
>  drivers/infiniband/core/verbs.c         |    9 --
>  drivers/infiniband/hw/hfi1/Kconfig      |    1
>  drivers/infiniband/hw/mlx4/qp.c         |    6 -
>  drivers/infiniband/sw/rdmavt/Kconfig    |    1
>  drivers/infiniband/ulp/isert/ib_isert.c |    2
>  drivers/infiniband/ulp/isert/ib_isert.h |    1
>  drivers/infiniband/ulp/srp/ib_srp.c     |  131 --------------------------------
>  drivers/infiniband/ulp/srp/ib_srp.h     |    5 -
>  drivers/infiniband/ulp/srpt/ib_srpt.c   |   10 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.h   |    6 -
>  drivers/md/dm-crypt.c                   |    4
>  drivers/md/dm-ioctl.c                   |   77 +++++++++---------
>  drivers/md/dm-mpath.c                   |   32 -------
>  drivers/md/dm.c                         |   22 -----
>  drivers/scsi/scsi_lib.c                 |   36 +-------
>  drivers/scsi/scsi_priv.h                |    2
>  drivers/scsi/scsi_scan.c                |    2
>  drivers/scsi/scsi_sysfs.c               |   48 -----------
>  drivers/scsi/sd.c                       |    6 -
>  drivers/scsi/sg.c                       |    3
>  include/linux/blk-mq.h                  |    3
>  include/linux/blk_types.h               |    5 -
>  include/linux/blkdev.h                  |    1
>  include/linux/dmar.h                    |    2
>  include/rdma/ib_verbs.h                 |    6 -
>  include/scsi/scsi_device.h              |    2
>  kernel/sched/wait.c                     |    2
>  34 files changed, 106 insertions(+), 384 deletions(-)

Hello Mike,

Most of the changes you are referring to either are already upstream, 
are expected to arrive in Linus' tree later this week or only add 
debugging pr_info() statements. The changes that either are already 
upstream or that are expected to be upstream soon are:

$ for b in origin/master dledford-rdma/k.o/for-4.8-1 
dledford-rdma/k.o/for-4.8-2; do git log v4.7..$b --author="Bart Van 
Assche" | grep ^commit -A4 | sed -n 's/^    //p'; done
block: Fix spelling in a source code comment
dm ioctl: Simplify parameter buffer management code
dm crypt: Fix sparse complaints
block/blk-cgroup.c: Declare local symbols static
block/bio-integrity.c: Add #include "blk.h"
block/partition-generic.c: Remove a set-but-not-used variable
IB/hfi1: Disable by default
IB/rdmavt: Disable by default
IB/isert: Remove an unused member variable
IB/srpt: Simplify srpt_queue_response()
IB/srpt: Limit the number of SG elements per work request
IB/core, RDMA RW API: Do not exceed QP SGE send limit
IB/core: Make rdma_rw_ctx_init() initialize all used fields

Bart.

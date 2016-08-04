From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 4 Aug 2016 12:10:47 -0400
Message-ID: <20160804161047.GC6989@redhat.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758802AbcHDQLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 12:11:09 -0400
Content-Disposition: inline
In-Reply-To: <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Aug 03 2016 at 12:55pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/02/2016 05:40 PM, Mike Snitzer wrote:
> >But I asked you to run the v4.7 kernel patches I
> >pointed to _without_ any of your debug patches.
> 
> I need several patches to fix bugs that are not related to the
> device mapper, e.g. "sched: Avoid that __wait_on_bit_lock() hangs"
> (https://lkml.org/lkml/2016/8/3/289).

OK, but you have way more changes than seem needed.  In particular the
blk-mq error handling changes look suspect.

I'm also not sure what REQ_FAIL_IF_NO_PATH is all about (vaguely recall
seeing it before; and suggesting you use SCSI's more traditional
differentiated IO errors).

Anyway, at this point you're having us test too many changes that aren't
yet upstream:

$ git diff bart/srp-initiator-for-next dm/dm-4.7-mpath-fixes -- drivers block include kernel | diffstat
 block/bio-integrity.c                   |    1
 block/blk-cgroup.c                      |    4
 block/blk-core.c                        |   16 ---
 block/blk-mq.c                          |   16 ---
 block/partition-generic.c               |    3
 drivers/acpi/acpica/nswalk.c            |    1
 drivers/infiniband/core/rw.c            |   24 +++--
 drivers/infiniband/core/verbs.c         |    9 --
 drivers/infiniband/hw/hfi1/Kconfig      |    1
 drivers/infiniband/hw/mlx4/qp.c         |    6 -
 drivers/infiniband/sw/rdmavt/Kconfig    |    1
 drivers/infiniband/ulp/isert/ib_isert.c |    2
 drivers/infiniband/ulp/isert/ib_isert.h |    1
 drivers/infiniband/ulp/srp/ib_srp.c     |  131 --------------------------------
 drivers/infiniband/ulp/srp/ib_srp.h     |    5 -
 drivers/infiniband/ulp/srpt/ib_srpt.c   |   10 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h   |    6 -
 drivers/md/dm-crypt.c                   |    4
 drivers/md/dm-ioctl.c                   |   77 +++++++++---------
 drivers/md/dm-mpath.c                   |   32 -------
 drivers/md/dm.c                         |   22 -----
 drivers/scsi/scsi_lib.c                 |   36 +-------
 drivers/scsi/scsi_priv.h                |    2
 drivers/scsi/scsi_scan.c                |    2
 drivers/scsi/scsi_sysfs.c               |   48 -----------
 drivers/scsi/sd.c                       |    6 -
 drivers/scsi/sg.c                       |    3
 include/linux/blk-mq.h                  |    3
 include/linux/blk_types.h               |    5 -
 include/linux/blkdev.h                  |    1
 include/linux/dmar.h                    |    2
 include/rdma/ib_verbs.h                 |    6 -
 include/scsi/scsi_device.h              |    2
 kernel/sched/wait.c                     |    2
 34 files changed, 106 insertions(+), 384 deletions(-)

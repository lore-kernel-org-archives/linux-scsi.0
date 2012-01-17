From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [GIT PULL]: ib_srpt: Initial SRP target merge for v3.3-rc1
Date: Tue, 17 Jan 2012 13:33:41 -0800
Message-ID: <1326836021.16983.38.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

This is the PULL request for an initial merge of the ib_srpt driver
using mainline target infrastructure into v3.3-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

Note that 'target: core updates for v3.3-rc1' should be pulled
first via target-pending.git/for-next, and has gone out in a separate
PULL request. 

Here are full set of review changes from Roland and Bart that have been
made:

v1 -> v2 review changes:

ib_srpt: Fix potential out-of-bounds array access
ib_srpt: Avoid failed multipart RDMA transfers
ib_srpt: Fix srpt_alloc_fabric_acl failure case return value
ib_srpt: Update comments to reference $driver/$port layout
ib_srpt: Fix sport->port_guid formatting code
ib_srpt: Remove legacy use_port_guid_in_session_name module parameter
ib_srpt: Convert srp_max_rdma_size into per port configfs attribute
ib_srpt: Convert srp_max_rsp_size into per port configfs attribute
ib_srpt: Convert srpt_sq_size into per port configfs attribute

v2 -> v3 review changes:

ib_srpt: Fix possible race with srp_sq_size in srpt_create_ch_ib
ib_srpt: Fix possible race with srp_max_rsp_size in srpt_release_channel_work
ib_srpt: Fix up MAX_SRPT_RDMA_SIZE define
ib_srpt: Make srpt_map_sg_to_ib_sge() failure case return -EAGAIN
ib_srpt: Convert port_guid to use subnet_prefix + interface_id formatting
ib_srpt: Make srpt_check_stop_free return kref_put status
ib_srpt: Make compilation with BUG=n proceed`
ib_srpt: Use new target_core_fabric.h include
ib_srpt: Check hex2bin() return code to silence build warning

Please pull ASAP.

Thanks,

--nab

Bart Van Assche (1):
  ib_srpt: Initial SRP Target merge for v3.3-rc1

 drivers/infiniband/Kconfig              |    1 +
 drivers/infiniband/Makefile             |    1 +
 drivers/infiniband/ulp/srpt/Kconfig     |   12 +
 drivers/infiniband/ulp/srpt/Makefile    |    2 +
 drivers/infiniband/ulp/srpt/ib_dm_mad.h |  139 ++
 drivers/infiniband/ulp/srpt/ib_srpt.c   | 4073 +++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h   |  444 ++++
 7 files changed, 4672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/ulp/srpt/Kconfig
 create mode 100644 drivers/infiniband/ulp/srpt/Makefile
 create mode 100644 drivers/infiniband/ulp/srpt/ib_dm_mad.h
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.c
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.h


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

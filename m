From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [RFC-v2 00/12] Add support for iSCSI Extensions for RDMA (ISER) target
Date: Fri, 22 Mar 2013 23:55:24 +0000
Message-ID: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Hi folks,

This series is the second RFC for iSCSI Extensions for RDMA (ISER) target
support with existing iscsi-target TCP based socket code, planned for a
future v3.10 merge.

This includes a basic iscsit_transport API that allows different transports
to reside under a single iscsi-target configfs control plane, using an
pre-defined network portal attribute to enable a rdma_cm listener on top
of existing ipoib portals.

This code is available in git against v3.9-rc3 here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git iser_target-rfc-v2

Thanks to Or Gerlitz, Roland Dreier, Asias He and Andy Grover for their -v1
review comments.

The full changelog since RFC-v1 have been included into the individual patches.
The highlights for drivers/target/iscsi/ code include:

- Add ->iscsit_queue_data_in() to remove extra context switch on RDMA_WRITE
- Add ->iscsit_queue_status() to remove extra context switch on IB_SEND status
- Add ->iscsit_get_dataout() to remove extra context switch on RDMA_READ
- Drop ->iscsit_free_cmd()
- Drop ->iscsit_unmap_cmd()
- Disable iscsit_ack_from_expstatsn() usage for RDMAExtentions=Yes
- Disable iscsit_allocate_datain_req() usage for RDMAExtentions=Yes
- Add target_get_sess_cmd() reference counting to
  iscsit_setup_scsi_cmd()
- Add TFO->lio_check_stop_free() fabric API caller
- Convert existing usage of iscsit_build_r2ts_for_cmd() to
  ->iscsit_get_dataout()
- Drop RDMAExtentions=Yes specific check in iscsit_build_r2ts_for_cmd()
- Add iscsit_queue_rsp() for iscsit_transport->iscsit_queue_data_in()
  and iscsit_transport->iscsit_queue_status()
- Update lio_queue_data_in() to use ->iscsit_queue_data_in()
- Update lio_queue_status() to use ->iscsit_queue_status()

and for drivers/infiniband/ulp/isert/ code:

- Drop isert_cmd->cmd_kref in favor of se_cmd->cmd_kref usage
- Add struct isert_device in order to support multiple EQs + CQ pooling
- Drop tasklets and cqs from isert_conn
- Bump ISERT_MAX_CQ to 64
- Update isert_conn_setup_qp() to assign cq based upon least used
- Add isert_create_device_ib_res() to setup PD, CQs and MRs for each
  underlying struct ib_device, instead of using per isert_conn resources.
- Add isert_free_device_ib_res() to release PD, CQs and MRs for each
  underlying struct ib_device.
- Change isert_connect_request() to drop PD, CQs and MRs allocation,
  and use isert_device_find_by_ib_dev() instead.
- Change isert_connect_release() to decrement cq_active_qps, and drop
  PD, CQs and MRs resource release.
- Make isert_create_device_ib_res() determine device->cqs_used based
  upon num_online_cpus()
- Change isert_put_cmd() to perform per iscsi_opcode specific release
  logic
- Add isert_unmap_cmd() call for ISCSI_OP_SCSI_CMD from isert_put_cmd()
- Drop ISTATE_REMOVE processing from isert_immediate_queue()
- Drop ISTATE_SEND_DATAIN processing from isert_response_queue()
- Drop ISTATE_SEND_STATUS processing from isert_response_queue()
- Drop iscsit_transport->iscsit_unmap_cmd() and ->iscsit_free_cmd()
- Drop ISTATE_SEND_R2T processing from isert_immediate_queue()

As before, review patches are broken down into:

Patch #1 adds the export of target_get_sess_cmd to be used by iscsi-target

Patch #2 -> #4 include iscsi-target API template, conversion of iscsi/tcp
login path to use API template, plus add iser RFC parameter keys.

Patch #5 -> #6 allow external iscsi_cmd descriptor allocation / free, and
refactoring of RX side PDU request handling to allow incoming PDU logic
to be called by external ib_isert workqueue process context.

Patch #7 allows iscsi-target to use per transport API template immediate /
response callbacks in the per-connection TX thread completion path, and
refactoring of response PDU creation for export to external ib_isert code.

Patch #8 adds the pre-defined iser network portal attribute under the
existing iscsi-target configfs tree.

Patch #9 -> #12 is the external ib_isert.ko module code seperated into
individual commits for review.

So at this point this code is functional and pushing sustained RDMA_WRITE +
RDMA_READ traffic using open-iscsi on top of multiple iser network portals +
multiple IB HCA ports + multiple LUNs.  Thus far we're using Mellanox IB HCAs
for initial development, and will be verfiying using RCoE capable NICs as well
in the near future.

Many thanks again to Or Gerlitz and Yaron Haviv from Mellanox for their support.

--nab

Nicholas Bellinger (12):
  target: Add export of target_get_sess_cmd symbol
  iscsi-target: Add iscsit_transport API template
  iscsi-target: Initial traditional TCP conversion to iscsit_transport
  iscsi-target: Add iser-target parameter keys + setup during login
  iscsi-target: Add per transport iscsi_cmd alloc/free
  iscsi-target: Refactor RX PDU logic + export request PDU handling
  iscsi-target: Refactor TX queue logic + export response PDU creation
  iscsi-target: Add iser network portal attribute
  iser-target: Add base + proto includes
  iser-target: Add logic for verbs
  iser-target: Add logic for core
  iser-target: Add Makefile + Kconfig

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/ulp/isert/Kconfig           |    6 +
 drivers/infiniband/ulp/isert/Makefile          |    5 +
 drivers/infiniband/ulp/isert/isert_base.h      |  142 ++
 drivers/infiniband/ulp/isert/isert_core.c      | 1730 ++++++++++++++++++++++++
 drivers/infiniband/ulp/isert/isert_core.h      |   11 +
 drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
 drivers/infiniband/ulp/isert/isert_verbs.c     |  594 ++++++++
 drivers/infiniband/ulp/isert/isert_verbs.h     |    5 +
 drivers/target/iscsi/Makefile                  |    3 +-
 drivers/target/iscsi/iscsi_target.c            | 1132 +++++++++-------
 drivers/target/iscsi/iscsi_target.h            |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   94 ++-
 drivers/target/iscsi/iscsi_target_core.h       |   26 +-
 drivers/target/iscsi/iscsi_target_device.c     |    7 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   13 +-
 drivers/target/iscsi/iscsi_target_login.c      |  468 +++++--
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  182 +---
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   87 ++-
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_transport.c  |   55 +
 drivers/target/iscsi/iscsi_target_util.c       |   53 +-
 drivers/target/iscsi/iscsi_target_util.h       |    1 +
 drivers/target/target_core_transport.c         |    4 +-
 include/target/iscsi/iscsi_transport.h         |   81 ++
 include/target/target_core_fabric.h            |    2 +-
 31 files changed, 3981 insertions(+), 815 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/Kconfig
 create mode 100644 drivers/infiniband/ulp/isert/Makefile
 create mode 100644 drivers/infiniband/ulp/isert/isert_base.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_core.c
 create mode 100644 drivers/infiniband/ulp/isert/isert_core.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_verbs.c
 create mode 100644 drivers/infiniband/ulp/isert/isert_verbs.h
 create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
 create mode 100644 include/target/iscsi/iscsi_transport.h

-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

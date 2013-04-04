From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v3 0/9] Add support for iSCSI Extensions for RDMA (ISER) target mode
Date: Thu,  4 Apr 2013 07:24:07 +0000
Message-ID: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This series is the third RFC for iSCSI Extensions for RDMA (ISER) target
mode support planned for an future v3.10 merge.  This series refactors
existing traditional iscsi-target mode logic in order for external
ib_isert.ko module code to function with areas common to traditional
TCP socket based iSCSI and RDMA verbs based ISER operation.

This includes a basic iscsit_transport API that allows different transports
to reside under the existing iscsi-target configfs control plane, using an
pre-defined network portal attribute to enable a rdma_cm listener on top
of existing ipoib portals.

At this point the code is functional and pushing sustained RDMA_WRITE +
RDMA_READ traffic using open-iscsi on top of multiple iser network portals +
multiple IB HCA ports + multiple LUNs.  Thus far we're using Mellanox IB HCAs
for initial development, and will be verfiying with RCoE capable NICs as well
in the near future.

This RFC-v3 code is available in git against v3.9-rc3 here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git iser_target-rfc-v3

The changes included since RFC-v2 include:

  - Convert to use per isert_cq_desc->cq_[rx,tx]_work + drop tasklets (Or + nab)
  - Move IB_EVENT_QP_LAST_WQE_REACHED warn into correct
    isert_qp_event_callback (Or)
  - Drop unnecessary IB_ACCESS_REMOTE_* access flag usage in
    isert_create_device_ib_res (Or)
  - Add common isert_init_send_wr(), and convert isert_put_* calls (Or)
  - Move to verbs+core logic to single ib_isert.[c,h]  (Or + nab)
  - Add kmem_cache isert_cmd_cache usage for descriptor allocation (nab)
  - Move common ib_post_send() logic used by isert_put_*() to
    isert_post_response() (nab)
  - Add isert_put_reject call in isert_response_queue() for posting
    ISCSI_REJECT response. (nab)
  - Add ISTATE_SEND_REJECT checking in isert_do_control_comp. (nab)
  - Add extra target_put_sess_cmd call in iscsit_add_reject_from_cmd
    after completion
  - Add iscsit_build_reject for REJECT PDU init + convert
    iscsit_send_reject()
  - Add iscsi_post_login_start_timers FIXME for ISER

Many thanks again to Or Gerlitz from Mellanox for v2 review feedback!

With the per isert_cq_desc->cq_[rx,tx]_work cmwq dispatch now in place,
process context switch overhead is reduced to each cq callback, instead
of per each ib_poll_cq ib_wc descriptor as with tasklets in RFC-v2 code.
This allows RFC-v3 to reach within ~%5 of single-lun NULLIO small block
IOPs performance parity vs. existing STGT iser code, at almost 1/10 the
number of total context switches.

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

Note that I'll be dropping #1 -> #8 changes into target-pending/for-next
shortly, and planning to do the same with ib_isert code soon unless there
is an objection from Roland.  Please review..

Thank you!

--nab

Nicholas Bellinger (9):
  target: Add export of target_get_sess_cmd symbol
  iscsi-target: Add iscsit_transport API template
  iscsi-target: Initial traditional TCP conversion to iscsit_transport
  iscsi-target: Add iser-target parameter keys + setup during login
  iscsi-target: Add per transport iscsi_cmd alloc/free
  iscsi-target: Refactor RX PDU logic + export request PDU handling
  iscsi-target: Refactor TX queue logic + export response PDU creation
  iscsi-target: Add iser network portal attribute
  iser-target: Add iSCSI Extensions for RDMA (iSER) target driver

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/ulp/isert/Kconfig           |    6 +
 drivers/infiniband/ulp/isert/Makefile          |    2 +
 drivers/infiniband/ulp/isert/ib_isert.c        | 2270 ++++++++++++++++++++++++
 drivers/infiniband/ulp/isert/ib_isert.h        |  142 ++
 drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
 drivers/target/iscsi/Makefile                  |    3 +-
 drivers/target/iscsi/iscsi_target.c            | 1169 ++++++++-----
 drivers/target/iscsi/iscsi_target.h            |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   94 +-
 drivers/target/iscsi/iscsi_target_core.h       |   26 +-
 drivers/target/iscsi/iscsi_target_device.c     |    7 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   13 +-
 drivers/target/iscsi/iscsi_target_login.c      |  470 ++++--
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  182 +--
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   87 +-
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_transport.c  |   55 +
 drivers/target/iscsi/iscsi_target_util.c       |   53 +-
 drivers/target/iscsi/iscsi_target_util.h       |    1 +
 drivers/target/target_core_transport.c         |    4 +-
 include/target/iscsi/iscsi_transport.h         |   83 +
 include/target/target_core_fabric.h            |    2 +-
 28 files changed, 3938 insertions(+), 826 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/Kconfig
 create mode 100644 drivers/infiniband/ulp/isert/Makefile
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.c
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
 create mode 100644 include/target/iscsi/iscsi_transport.h

-- 
1.7.2.5

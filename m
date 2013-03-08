From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 00/11] Add support for iSCSI Extentions for RDMA (ISER) target
Date: Fri,  8 Mar 2013 01:45:05 +0000
Message-ID: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Folks,

This series is first RFC for iSCSI Extentions for RDMA (ISER) target
support with existing iscsi-target TCP based socket code for a future
v3.10 merge.

This code is available in git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git iser_target-rfcv1

Ths includes a basic iscsit_transport API that allows different transports
to reside under a single iscsi-target configfs control plane, using an
pre-defined network portal attribute to enable a rdma_cm listener on top
of existing ipoib portals.

The review patches are broken down into:

Patch #1 -> #3 include iscsi-target API template, conversion of iscsi/tcp
login path to use API template, plus add iser RFC parameter keys.

Patch #4 -> #5 allow external iscsi_cmd descriptor allocation / free, and
refactoring of RX side PDU request handling to allow incoming PDU logic
to be called by external ib_isert workqueue process context.

Patch #6 allows iscsi-target to use per transport API template immediate /
response callbacks in the per-connection TX thread completion path, and
refactoring of response PDU creation for export to external ib_isert code.

Patch #7 adds the pre-defined iser network portal attribute under the
existing iscsi-target configfs tree.

Patch #8 -> #11 is the external ib_isert.ko module code seperated into
individual commits for review.

So at this point this code is functional and pushing sustained RDMA_WRITE +
RDMA_READ traffic using open-iscsi on top of v3.8-rc7 code.  Thus far we're
using Mellanox IB HCAs for initial development, and will be verfiying using
RCoE capable NICs as well in the near future.

Note there are still plently of performance tuning, active I/O shutdown
testing, and various exception path hardening left to be done over the
upcoming weeks.  The branch at target-pending.git/iser_target-wip will be
updated as review comments + regressions + new bugs are addressed.

Many thanks to Or Gerlitz and Mellanox for their support.

Thank you,

--nab

Nicholas Bellinger (11):
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
 drivers/infiniband/ulp/isert/isert_base.h      |  123 ++
 drivers/infiniband/ulp/isert/isert_core.c      | 1720 ++++++++++++++++++++++++
 drivers/infiniband/ulp/isert/isert_core.h      |   12 +
 drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
 drivers/infiniband/ulp/isert/isert_verbs.c     |  476 +++++++
 drivers/infiniband/ulp/isert/isert_verbs.h     |    5 +
 drivers/target/iscsi/Makefile                  |    3 +-
 drivers/target/iscsi/iscsi_target.c            | 1119 +++++++++-------
 drivers/target/iscsi/iscsi_target.h            |    1 +
 drivers/target/iscsi/iscsi_target_configfs.c   |   75 +
 drivers/target/iscsi/iscsi_target_core.h       |   25 +-
 drivers/target/iscsi/iscsi_target_device.c     |    1 +
 drivers/target/iscsi/iscsi_target_erl1.c       |    8 +-
 drivers/target/iscsi/iscsi_target_login.c      |  466 +++++--
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  185 +---
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   87 ++-
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    1 +
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_transport.c  |   57 +
 drivers/target/iscsi/iscsi_target_util.c       |   62 +-
 drivers/target/iscsi/iscsi_target_util.h       |    2 +
 include/target/iscsi/iscsi_transport.h         |   77 ++
 29 files changed, 3803 insertions(+), 801 deletions(-)
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

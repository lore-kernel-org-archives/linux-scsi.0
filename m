From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/2] iscsi/iser-target: Add per-cpu ida tag pre-allocation for v3.12
Date: Tue, 20 Aug 2013 20:35:59 +0000
Message-ID: <1377030961-19831-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This updated series adds tag pre-allocation support for iscsi_cmd and
isert_cmd descriptor memory within iscsi/iser-target fabric code,
utilizing Kent's latest per-cpu ida bits posted earlier here:

  [PATCH-v3 1/4] idr: Percpu ida
  http://marc.info/?l=linux-virtualization&m=137669883717043&w=2

The first patch converts to use a command priv_size allocation in order
to inline isert_cmd into a single allocation, and drops left-over cruft
for iscsit_transport->iscsit_alloc_cmd().  It also drops the now unused
iscsi_cmd->iscsit_release_cmd() function pointer.

The second patch is a conversion to use percpu_ida_alloc() pre-allocation
in iscsit_allocate_cmd() that locates the memory offset into ->sess_cmd_map,
and updates iscsit_release_cmd() to call percpu_ida_free() based on the
available se_session pointer.

Changes in v2:

  - Bugfix that was triggering an OOPs during SessionType=Discovery
    within iscsi_target_locate_portal().

Please review as v3.12 material.

Thanks!

Nicholas Bellinger (2):
  iscsi/iser-target: Convert to command priv_size usage
  iscsi-target: Convert to per-cpu ida_alloc + ida_free command map

 drivers/infiniband/ulp/isert/ib_isert.c      |  114 +++++++++-----------------
 drivers/infiniband/ulp/isert/ib_isert.h      |    2 +-
 drivers/target/iscsi/iscsi_target.c          |   16 +---
 drivers/target/iscsi/iscsi_target.h          |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 drivers/target/iscsi/iscsi_target_core.h     |    3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   28 ++++++-
 drivers/target/iscsi/iscsi_target_util.c     |   41 ++++-----
 include/target/iscsi/iscsi_transport.h       |    8 +-
 9 files changed, 98 insertions(+), 117 deletions(-)

-- 
1.7.10.4

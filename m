From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.6-rc1
Date: Tue, 22 Mar 2016 11:08:48 -0700
Message-ID: <1458670128.9681.14.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55026 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbcCVSJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 14:09:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hello Linus,

Here are the target updates for v4.6-rc1 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this round include:

  - Add target_alloc_session() w/ callback helper for doing se_session
    allocation + tag + se_node_acl lookup. (HCH + nab)
  - Tree-wide fabric driver conversion to use target_alloc_session()
  - Convert sbp-target to use percpu_ida tag pre-allocation, and
    TARGET_SCF_ACK_KREF I/O krefs (Chris Boot + nab)
  - Convert usb-gadget to use percpu_ida tag pre-allocation, and
    TARGET_SCF_ACK_KREF I/O krefs (Andrzej Pietrasiewicz + nab)
  - Convert xen-scsiback to use percpu_ida tag pre-allocation, and
    TARGET_SCF_ACK_KREF I/O krefs (Juergen Gross + nab)
  - Convert tcm_fc to use TARGET_SCF_ACK_KREF I/O + TMR krefs
  - Convert ib_srpt to use percpu_ida tag pre-allocation
  - Add DebugFS node for qla2xxx target sess list (Quinn)
  - Rework iser-target connection termination (Jenny + Sagi)
  - Convert iser-target to new CQ API (HCH)
  - Add pass-through WRITE_SAME support for IBLOCK (Mike Christie)
  - Introduce data_bitmap for asynchronous access of data area
    (Sheng Yang + Andy)
  - Fix target_release_cmd_kref shutdown comp leak (Himanshu Madhani)

Also, there is a separate PULL request coming for cxgb4 NIC driver
prerequisites for supporting hw iscsi segmentation offload (ISO),
that will be the base for a number of v4.7 developments involving
iscsi-target hw offloads.

Thank you,

--nab

Andy Grover (1):
  target: Remove enum transport_lunflags_table

Christoph Hellwig (6):
  target: Convert demo-mode only drivers to target_alloc_session
  iser-target: Remove ISER_RECV_DATA_SEG_LEN
  iser-target: Split and properly type the login buffer
  iser-target: Convert to new CQ API
  iser-target: Kill struct isert_rdma_wr
  iser-target: Kill the ->isert_cmd back pointer in struct iser_tx_desc

Himanshu Madhani (1):
  target: Fix target_release_cmd_kref shutdown comp leak

Jenny Derzhavetz (6):
  iser-target: Fix identification of login rx descriptor type
  iser-target: Add new state ISER_CONN_BOUND to isert_conn
  iser-target: Separate flows for np listeners and connections cma
    events
  iser-target: Rework connection termination
  iser-target: Remove redundant wait in release_conn
  iser-target: Remove impossible condition from isert_wait_conn

Mike Christie (1):
  target/iblock: pass WRITE_SAME to device if possible

Nicholas Bellinger (15):
  target: Add target_alloc_session() helper function
  vhost/scsi: Convert to target_alloc_session usage
  tcm_qla2xxx: Convert to target_alloc_session usage
  tcm_fc: Convert to target_alloc_session usage
  ib_srpt: Convert to target_alloc_session usage
  sbp-target: Conversion to percpu_ida tag pre-allocation
  sbp-target: Convert to TARGET_SCF_ACK_KREF I/O krefs
  usb-gadget/tcm: Conversion to percpu_ida tag pre-allocation
  usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs
  xen-scsiback: Convert to percpu_ida tag allocation
  xen-scsiback: Convert to TARGET_SCF_ACK_KREF I/O krefs
  tcm_fc: Convert to TARGET_SCF_ACK_KREF I/O + TMR krefs
  ib_srpt: Convert to percpu_ida tag allocation
  target/user: Fix size_t format-spec build warning
  target: Avoid DataIN transfers for non-GOOD SAM status

Quinn Tran (1):
  qla2xxx: Add DebugFS node for target sess list.

Sheng Yang (5):
  target/user: Use iovec[] to describe continuous area
  target/user: Free data ring in unified function
  target/user: Introduce data_bitmap, replace
    data_length/data_head/data_tail
  target/user: Don't free expired command when time out
  target/user: Report capability of handling out-of-order completions to
    userspace

 Documentation/target/tcmu-design.txt         |  11 +-
 drivers/infiniband/ulp/isert/ib_isert.c      | 810 ++++++++++++---------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  72 +--
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  76 +--
 drivers/infiniband/ulp/srpt/ib_srpt.h        |   2 -
 drivers/scsi/qla2xxx/qla_def.h               |   1 +
 drivers/scsi/qla2xxx/qla_dfs.c               |  55 ++
 drivers/scsi/qla2xxx/qla_target.c            |  57 +-
 drivers/scsi/qla2xxx/qla_target.h            |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  79 +--
 drivers/target/loopback/tcm_loop.c           |  46 +-
 drivers/target/sbp/sbp_target.c              |  95 ++--
 drivers/target/target_core_device.c          |  41 +-
 drivers/target/target_core_fabric_configfs.c |  32 +-
 drivers/target/target_core_iblock.c          |  34 ++
 drivers/target/target_core_internal.h        |   8 +-
 drivers/target/target_core_spc.c             |   3 +-
 drivers/target/target_core_tpg.c             |  21 +-
 drivers/target/target_core_transport.c       |  66 ++-
 drivers/target/target_core_user.c            | 267 +++++----
 drivers/target/tcm_fc/tfc_cmd.c              |  20 +-
 drivers/target/tcm_fc/tfc_sess.c             |  44 +-
 drivers/usb/gadget/function/f_tcm.c          | 193 +++----
 drivers/usb/gadget/function/tcm.h            |   2 +
 drivers/vhost/scsi.c                         |  99 ++--
 drivers/xen/xen-scsiback.c                   | 281 +++++-----
 include/target/target_core_base.h            |  11 +-
 include/target/target_core_fabric.h          |   6 +
 include/uapi/linux/target_core_user.h        |   1 +
 29 files changed, 1240 insertions(+), 1195 deletions(-)


From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.1-rc1
Date: Thu, 23 Apr 2015 23:50:46 -0700
Message-ID: <1429858246.21204.37.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending updates for v4.1-rc1 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note you'll hit two minor merge conflicts as reported by SFR:

linux-next: manual merge of the target-updates tree with the xen-tip tree
http://marc.info/?l=xen-devel&m=142865578923608&w=2

linux-next: manual merge of the target-updates tree with the infiniband tree
http://marc.info/?l=linux-next&m=142950419300852&w=2

Lots of activity in target land the last months.

The highlights include:

 - Convert fabric drivers tree-wide to target_register_template() (hch + bart)
 - iser-target hardening fixes + v1.0 improvements (sagi)
 - Convert iscsi_thread_set usage to kthread.h + kill iscsi_target_tq.c (sagi + nab)
 - Add support for T10-PI WRITE_STRIP + READ_INSERT operation (mkp + sagi + nab)
 - DIF fixes for CONFIG_DEBUG_SG=y + UNMAP file emulation (akinobu + sagi + mkp)
 - Extended TCMU ABI v2 for future BIDI + DIF support (andy + ilias)
 - Fix COMPARE_AND_WRITE handling for NO_ALLLOC drivers (hch + nab)

Thanks to everyone who contributed this round with new features,
bug-reports, fixes, cleanups and improvements.

Looking forward, it's currently shaping up to be a busy v4.2 as well.

Thank you,

--nab

Akinobu Mita (5):
  target/rd: reduce code duplication in rd_execute_rw()
  target/rd: Don't pass incomplete scatterlist entries to
    sbc_dif_verify_*
  target/file: Fix BUG() when CONFIG_DEBUG_SG=y and DIF protection
    enabled
  target/file: Fix SG table for prot_buf initialization
  target/file: Fix UNMAP with DIF protection support

Andy Grover (2):
  target: Version 2 of TCMU ABI
  target: Put TCMU under a new config option

Bart Van Assche (3):
  target: Fix two sparse warnings
  target: Remove the unused flag SCF_ACK_KREF
  target: Make core_tmr_abort_task() skip TMFs

Christoph Hellwig (12):
  target: use vfs_iter_read/write in fd_do_rw
  target: rewrite fd_execute_write_same
  target: move external declarations to a headers
  target: mark tcm_loop_primary static
  target: mark iscsit_start_kthreads static
  target: add __releases annotation to target_release_cmd_kref
  target: add missing sense_reason_t annotations
  target: add missing __user annotations
  target: remove the unused SCF_CMD_XCOPY_PASSTHROUGH flag
  target: simplify target_xcopy_init_pt_lun
  target: simplify the target template registration API
  target: fix tcm_mod_builder.py

Ilias Tsitsimpis (1):
  target: Better handling of AllRegistrants reservations

Julia Lawall (1):
  iscsi-target: don't export static symbol

Ming Lin (1):
  tcm_loop: fixup tpgt string to integer conversion

Nicholas Bellinger (26):
  target: Add target_show_dynamic_sessions attribute helper
  iscsi-target: Expose per endpoint dynamic_sessions attribute
  tcm_qla2xxx: Expose per endpoint dynamic_sessions attribute
  target: Convert fabric module autoload failures to pr_debug
  iscsi-target: Convert iscsi_thread_set usage to kthread.h
  iscsi-target: Drop legacy iscsi_target_tq.c logic
  target: Convert DIF emulation to use cmd->prot_type
  target: Add protected fabric + unprotected device support
  target: Update SPC/SBC emulation for sess_prot_type
  target: Move cmd->prot_op check into target_write_prot_action
  target: Add internal WRITE_STRIP support
  target: Move cmd->prot_op check into target_read_prot_action
  target: Add internal READ_INSERT support
  target/file: Add checks for backend DIF emulation
  target/iblock: Add checks for backend DIF emulation
  target/rd: Add checks for backend DIF emulation
  loopback: Add fabric_prot_type attribute support
  vhost/scsi: Add fabric_prot_type attribute support
  tcm_qla2xxx: Set TARGET_PROT_ALL for sup_prot_ops
  tcm_qla2xxx: Add fabric_prot_type attribute support
  iscsi/iser-target: Add fabric_prot_type attribute support
  target: Fix COMPARE_AND_WRITE with SG_TO_MEM_NOALLOC handling
  target: Ensure sess_prot_type is saved across session restart
  target/sbc: Return INVALID_CDB_FIELD if DIF + sess_prot_type disabled
  target/sbc: Make internal DIF emulation honor ->prot_checks
  target/sbc: Update sbc_dif_generate pr_debug output

Sagi Grimberg (18):
  iser-target: Fix session hang in case of an rdma read DIF error
  iser-target: Fix possible deadlock in RDMA_CM connection error
  iser-target: Use a single DMA MR and PD per device
  iser-target: Remove redundant check on recv completion
  iser-target: Remove dead code
  iser-target: Remove redundant local variable
  iser-target: Remove redundant casting on void pointers
  iser-target: Split isert_setup_qp
  iser-target: Introduce isert_[alloc|free]_comps
  iser-target: Remove redundant assignment to local variable
  iser-target: Rename rend/recv completion routines
  iser-target: Rename device find/release routines
  iser-target: Split some logic in isert_connect_request to routines
  iser-target: Get rid of redundant max_accept
  iser-target: Remove redundant check on the device
  iser-target: Remove un-needed rdma_listen backlog
  iser-target: Remove conn_ prefix from struct isert_conn members
  iser-target: Bump version to 1.0

 Documentation/target/tcm_mod_builder.py      |  79 +--
 Documentation/target/tcmu-design.txt         |  43 +-
 drivers/infiniband/ulp/isert/ib_isert.c      | 691 +++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  37 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  49 +-
 drivers/scsi/qla2xxx/qla_target.c            |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 174 ++++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h           |   1 +
 drivers/target/Kconfig                       |   5 +-
 drivers/target/Makefile                      |   2 +-
 drivers/target/iscsi/Makefile                |   1 -
 drivers/target/iscsi/iscsi_target.c          | 131 +++--
 drivers/target/iscsi/iscsi_target.h          |   2 +-
 drivers/target/iscsi/iscsi_target_configfs.c | 208 ++++----
 drivers/target/iscsi/iscsi_target_configfs.h |   7 -
 drivers/target/iscsi/iscsi_target_erl0.c     |  14 +-
 drivers/target/iscsi/iscsi_target_login.c    |  60 ++-
 drivers/target/iscsi/iscsi_target_tpg.c      |  25 +-
 drivers/target/iscsi/iscsi_target_tpg.h      |   1 +
 drivers/target/iscsi/iscsi_target_tq.c       | 495 -------------------
 drivers/target/iscsi/iscsi_target_tq.h       |  84 ----
 drivers/target/iscsi/iscsi_target_util.c     |   1 -
 drivers/target/loopback/tcm_loop.c           | 242 ++++------
 drivers/target/loopback/tcm_loop.h           |   1 +
 drivers/target/sbp/sbp_target.c              |  68 +--
 drivers/target/target_core_configfs.c        | 192 +++-----
 drivers/target/target_core_fabric_configfs.c |  38 +-
 drivers/target/target_core_file.c            | 261 +++++-----
 drivers/target/target_core_iblock.c          |   4 +-
 drivers/target/target_core_internal.h        |   6 +
 drivers/target/target_core_pr.c              |  48 +-
 drivers/target/target_core_rd.c              | 137 ++++--
 drivers/target/target_core_sbc.c             | 109 +++--
 drivers/target/target_core_spc.c             |  16 +-
 drivers/target/target_core_tmr.c             |   4 +-
 drivers/target/target_core_tpg.c             |   2 +-
 drivers/target/target_core_transport.c       | 162 ++++++-
 drivers/target/target_core_user.c            |  52 +-
 drivers/target/target_core_xcopy.c           |  46 +-
 drivers/target/tcm_fc/tcm_fc.h               |   1 -
 drivers/target/tcm_fc/tfc_conf.c             |  89 +---
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |  57 +--
 drivers/vhost/scsi.c                         | 126 ++---
 drivers/xen/xen-scsiback.c                   |  74 +--
 include/target/iscsi/iscsi_target_core.h     |  15 +-
 include/target/target_core_base.h            |  10 +-
 include/target/target_core_configfs.h        |   6 -
 include/target/target_core_fabric.h          |  33 +-
 include/target/target_core_fabric_configfs.h |   5 +
 include/uapi/linux/target_core_user.h        |  44 +-
 50 files changed, 1687 insertions(+), 2273 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.c
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.h

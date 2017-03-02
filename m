From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.11-rc1
Date: Thu, 02 Mar 2017 12:40:13 -0800
Message-ID: <1488487213.8251.15.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the outstanding target pending changes for v4.11-rc1.  Please
go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this round include:

- Enable dual mode (initiator + target) qla2xxx operation. (Quinn + Himanshu)

- Add a framework for qla2xxx async fabric discovery. (Quinn + Himanshu)

- Enable iscsi PDU DDP completion offload in cxgbit/T6 NICs. (Varun)

- Fix target-core handling of aborted failed commands. (Bart)

- Fix a long standing target-core issue NULL pointer dereference with
  active I/O LUN shutdown. (Rob Millner + Bryant + nab)

Things are shaping up to be a busy cycle for v4.12 with a new fabric
driver (efct) in flight, and a number of other patches on the list being
discussed.

For post v4.11-rc1 fixes, there is a qla2xxx series that missed -rc1
that will be sent your way soon, along with a issue reported by Bart
related to ib_srpt + LUN_RESET that we are still going back and forth on
how the bug-fix should work.

Beyond that, the number of folks with dedicated Q/A resources for
upstream target code is steadily increasing, along with the number of
production customers using the mainstream in-tree fabric drivers.

Thank you,

--nab

Bart Van Assche (19):
  qla2xxx: Avoid using variable-length arrays
  target/cxgbit: Fix endianness annotations
  target/tcm_fc: Remove a set-but-not-used variable
  target/iscsi: Fix indentation in iscsi_target_start_negotiation()
  target/iscsi: Fix spelling of "perform"
  target/iscsi: Fix spelling of "reallegiance"
  target/iscsi: Introduce a helper function for TMF translation
  target/iscsi: Fix iSCSI task reassignment handling
  target: Remove se_tmr_req.tmr_lun
  target: Make core_tmr_abort_task() consider all commands
  target: Correct transport_wait_for_tasks() documentation
  target: Stop execution if CMD_T_STOP has been set
  target: Remove an overly chatty debug message
  target: Inline transport_cmd_check_stop()
  target: Move session check from target_put_sess_cmd() into
    target_release_cmd_kref()
  target: Remove command flag CMD_T_BUSY
  target: Remove command flag CMD_T_DEV_ACTIVE
  target: Fix handling of aborted failed commands
  target: Delete tmr from list before processing

Dmitry V. Levin (1):
  uapi: fix linux/target_core_user.h userspace compilation errors

Himanshu Madhani (2):
  qla2xxx: Remove SRR code
  qla2xxx: Remove unused reverse_ini_mode

Joe Carnuccio (1):
  qla2xxx: Simplify usage of SRB structure in driver

Mike Christie (1):
  target: export protocol identifier

Nicholas Bellinger (3):
  target: Fix NULL dereference during LUN lookup + active I/O shutdown
  iscsi-target: Fix early login failure statistics misses
  target: Add counters for ABORT_TASK success + failure

Quinn Tran (10):
  qla2xxx: Remove direct access of scsi_status field in se_cmd
  qla2xxx: Cleanup TMF code translation from qla_target
  qla2xxx: Make trace flags more readable
  qla2xxx: Fix wrong argument in sp done callback
  qla2xxx: Use d_id instead of s_id for more clarity
  qla2xxx: Track I-T nexus as single fc_port struct
  qla2xxx: Add framework for async fabric discovery
  qla2xxx: Add Dual mode support in the driver
  qla2xxx: Improve RSCN handling in driver
  qla2xxx: Fix a warning reported by the "smatch" static checker

Varun Prakash (7):
  target/cxgbit: Use T6 specific macro to set the force bit
  target/iscsi: split iscsit_check_dataout_hdr()
  target/cxgbit: use cxgb4_tp_smt_idx() to get smt idx
  target/cxgbit: Use T6 specific macros to get ETH/IP hdr len
  target/cxgbit: Enable DDP for T6 only if data sequence and pdu are in
    order
  target/cxgbit: add T6 iSCSI DDP completion feature
  target/iscsi: Fix unsolicited data seq_end_offset calculation

 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |    4 +
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    3 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |   23 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  306 ++-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   11 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |  106 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   72 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  726 +++++-
 drivers/scsi/qla2xxx/qla_init.c                    | 1612 +++++++++----
 drivers/scsi/qla2xxx/qla_inline.h                  |   18 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  167 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  317 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  232 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |   48 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  330 ++-
 drivers/scsi/qla2xxx/qla_target.c                  | 2392 +++++++++-----------
 drivers/scsi/qla2xxx/qla_target.h                  |  252 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  256 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |    4 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c            |   30 +-
 drivers/target/iscsi/cxgbit/cxgbit_lro.h           |    5 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c          |   69 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |  173 +-
 drivers/target/iscsi/iscsi_target.c                |  138 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |    6 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |    6 +-
 drivers/target/iscsi/iscsi_target_erl2.h           |    2 +-
 drivers/target/iscsi/iscsi_target_login.c          |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c            |    4 +-
 drivers/target/iscsi/iscsi_target_util.c           |   39 +-
 drivers/target/target_core_device.c                |   11 +-
 drivers/target/target_core_sbc.c                   |    2 +-
 drivers/target/target_core_stat.c                  |   36 +
 drivers/target/target_core_tmr.c                   |   17 +-
 drivers/target/target_core_tpg.c                   |    3 +-
 drivers/target/target_core_transport.c             |  164 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |    2 -
 include/target/iscsi/iscsi_transport.h             |   11 +-
 include/target/target_core_base.h                  |    7 +-
 include/target/target_core_fabric.h                |    2 +-
 include/uapi/linux/target_core_user.h              |   22 +-
 43 files changed, 4790 insertions(+), 2858 deletions(-)

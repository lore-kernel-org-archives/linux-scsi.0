From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.15-rc1
Date: Thu, 23 Nov 2017 14:30:36 -0800
Message-ID: <1511476236.5327.27.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the target-pending updates for v4.15-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

This series is predominantly bug-fixes, with a few small improvements
that have been outstanding over the last release cycle.

As usual, the associated bug-fixes have CC' tags for stable.

Also, things have been particularly quiet wrt new developments the last
months, with most folks continuing to focus on stability atop 4.x stable
kernels for their respective production configurations.

Also at this point, the stable trees have been synced up with mainline.
This will continue to be a priority, as production users tend to run
exclusively atop stable kernels, a few releases behind mainline.

The highlights include:

 - target: Fix PR PREEMPT_AND_ABORT null pointer dereference regression
           in v4.11+ (tangwenji)
 - target/user: Fix OOPs during removing TCMU device (Xiubo Li + Zhang Zhuoyu)
 - target/user: Add netlink command reply supported option for each device
                (Kenjiro Nakayama)
 - cxgbit: Abort the TCP connection in case of data out timeout (Varun Prakash)
 - target: Fix PR/ALUA file path truncation (David Disseldorp)
 - target/user: Fix double se_cmd completion during ->cmd_time_out (Mike Christie)
 - target: Fix QUEUE_FULL + SCSI task attribute handling in 4.1+ (Bryant Ly + nab)
 - target: Fix quiese during transport_write_pending_qf endless loop (nab)
 - target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK in 3.14+
           (Don White + nab)

Thank you,

--nab

Bart Van Assche (9):
  target: Move a declaration of a global variable into a header file
  target: Suppress gcc 7 fallthrough warnings
  target: Inline transport_put_cmd()
  target/iscsi: Define OFFLOAD_BUF_SIZE once
  target/iscsi: Use min() in iscsit_dump_data_payload() instead of
    open-coding it
  target/iscsi: Fix endianness in an error message
  target/iscsi: Modify iscsit_do_crypto_hash_buf() prototype
  target/iscsi: Fix a race condition in iscsit_add_reject_from_cmd()
  target/iscsi: Detect conn_cmd_list corruption early

Dan Carpenter (2):
  tcmu: Fix some memory corruption
  tcmu: Add a missing unlock on an error path

David Disseldorp (2):
  target: fix PR state file path truncation
  target: fix ALUA state file path truncation

Jiang Yi (1):
  target/file: Do not return error for UNMAP if length is zero

Kenjiro Nakayama (2):
  target/tcmu: Use macro to call container_of in tcmu_cmd_time_out_show
  target: Add netlink command reply supported option for each device

Markus Elfring (1):
  iSCSI-target: Use common error handling code in
    iscsi_decode_text_input()

Mike Christie (2):
  target: return SAM_STAT_TASK_SET_FULL for TCM_OUT_OF_RESOURCES
  tcmu: fix double se_cmd completion

Nicholas Bellinger (6):
  target: Fix QUEUE_FULL + SCSI task attribute handling
  target: Fix caw_sem leak in transport_generic_request_failure
  target: Fix quiese during transport_write_pending_qf endless loop
  target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK
  iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
  iscsi-target: Fix non-immediate TMR reference leak

Varun Prakash (1):
  cxgbit: Abort the TCP connection in case of data out timeout

Xiubo Li (1):
  tcmu: fix crash when removing the tcmu device

tangwenji (8):
  target: fix null pointer regression in core_tmr_drain_tmr_list
  target: fix buffer offset in core_scsi3_pri_read_full_status
  target: fix double unmap data sg in
    core_scsi3_emulate_pro_register_and_move()
  target: add sense code INSUFFICIENT REGISTRATION RESOURCES
  target: fix match_token option in target_core_configfs.c
  target:fix condition return in core_pr_dump_initiator_port()
  iscsi-target: fix memory leak in lio_target_tiqn_addtpg()
  iscsi-target: fix memory leak in iscsit_release_discovery_tpg()

 drivers/target/iscsi/cxgbit/cxgbit.h             |   2 +
 drivers/target/iscsi/cxgbit/cxgbit_cm.c          |  45 +++++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c         |   8 +
 drivers/target/iscsi/cxgbit/cxgbit_main.c        |   1 +
 drivers/target/iscsi/iscsi_target.c              |  80 ++++-----
 drivers/target/iscsi/iscsi_target_configfs.c     |   3 +-
 drivers/target/iscsi/iscsi_target_erl1.c         |   7 +-
 drivers/target/iscsi/iscsi_target_parameters.c   |  39 ++---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c |   2 -
 drivers/target/iscsi/iscsi_target_tpg.c          |   7 +-
 drivers/target/iscsi/iscsi_target_util.c         |   4 +
 drivers/target/target_core_alua.c                |  51 +++---
 drivers/target/target_core_alua.h                |   9 -
 drivers/target/target_core_configfs.c            |  14 +-
 drivers/target/target_core_fabric_configfs.c     |   2 -
 drivers/target/target_core_file.c                |   4 +
 drivers/target/target_core_internal.h            |   1 +
 drivers/target/target_core_pr.c                  |  41 ++---
 drivers/target/target_core_tmr.c                 |  12 +-
 drivers/target/target_core_transport.c           |  84 +++++----
 drivers/target/target_core_user.c                | 208 +++++++++++++++--------
 include/target/target_core_base.h                |   2 +
 22 files changed, 387 insertions(+), 239 deletions(-)

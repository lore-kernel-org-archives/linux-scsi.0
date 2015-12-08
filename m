From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 00/20] qla2xxx: Patches for target-pending branch
Date: Mon, 7 Dec 2015 19:48:47 -0500
Message-ID: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

This patch series adds performance improvement for qla2xxx target mode driver.

Please apply this series to target-pending for next mainline merge window.

Thanks,
Himanshu

Alexei Potashnik (2):
  qla2xxx: Delete session if initiator is gone from FW
  qla2xxx: Wait for all conflicts before ack'ing PLOGI

Dilip Kumar Uppugandla (1):
  qla2xxx: Check for online flag instead of active reset when
    transmitting responses

Himanshu Madhani (4):
  qla2xxx: Enable Extended Login support
  qla2xxx: Enable Exchange offload support.
  qla2xxx: Enable Target counters in DebugFS.
  qla2xxx: Added interface to send ELS commands from driver.

Quinn Tran (13):
  qla2xxx: Add FW resource count in DebugFS.
  qla2xxx: Replace QLA_TGT_STATE_ABORTED with a bit.
  qla2xxx: Change check_stop_free to always return 1
  qla2xxx: Fix interaction issue between qla2xxx and Target Core Module
  qla2xxx: Add TAS detection for kernel 3.15 n newer
  target/tmr: LUN reset cause cmd premature free.
  qla2xxx: Remove dependency on hardware_lock to reduce lock
    contention.
  qla2xxx: Add irq affinity notification
  qla2xxx: Add selective command queuing
  qla2xxx: Move atioq to a different lock to reduce lock contention
  qla2xxx: Disable ZIO at start time.
  qla2xxx: Set all queues to 4k
  qla2xxx: Add bulk send for atio & ctio completion paths.

 drivers/scsi/qla2xxx/qla_attr.c        |   36 ++
 drivers/scsi/qla2xxx/qla_dbg.c         |   19 +-
 drivers/scsi/qla2xxx/qla_def.h         |   86 ++++-
 drivers/scsi/qla2xxx/qla_dfs.c         |  106 +++++
 drivers/scsi/qla2xxx/qla_gbl.h         |   19 +-
 drivers/scsi/qla2xxx/qla_init.c        |   58 ++-
 drivers/scsi/qla2xxx/qla_inline.h      |    2 +
 drivers/scsi/qla2xxx/qla_iocb.c        |  190 ++++++++
 drivers/scsi/qla2xxx/qla_isr.c         |  129 +++++-
 drivers/scsi/qla2xxx/qla_mbx.c         |  264 +++++++++++-
 drivers/scsi/qla2xxx/qla_os.c          |  163 +++++++-
 drivers/scsi/qla2xxx/qla_target.c      |  737 +++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_target.h      |   95 +++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  205 ++++++++-
 drivers/target/target_core_tmr.c       |   33 ++-
 drivers/target/target_core_transport.c |   35 ++-
 include/target/target_core_base.h      |    2 +
 17 files changed, 1894 insertions(+), 285 deletions(-)

-- 
1.7.7

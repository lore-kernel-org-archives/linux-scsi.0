From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Fri, 24 Feb 2017 13:37:29 -0800
Message-ID: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

Please consider this series for inclusion in target-pending.

This series contains following changes.

o Fix for the deadlock because of inconsistent lock usage reported by you.
o Added patch to submit non-critical MBX command via IOCB path.
o Improved T10-DIF/PI handling with target stack.
o Changed scsi host lookup method.
o Some minor bug fixes.

Changes from v2 --> v3

o Updated patch to use waitq instead of while loop for waiting.
o Removed duplication of Target stack definitations for T10-DIF/PI.
o In addition, addressed review comments from Bart & Christoph.

Changes from v1 -> v2

o Rebased series based on scsi-target-for-v4.11 branch.

Please apply to target-pending.

Thanks,
Himanshu 

Anil Gurumurthy (1):
  qla2xxx: Export DIF stats via debugfs

Himanshu Madhani (2):
  qla2xxx: Add DebugFS node to display Port Database
  qla2xxx: Update driver version to 9.00.00.00-k

Joe Carnuccio (1):
  qla2xxx: Allow vref count to timeout on vport delete.

Quinn Tran (10):
  qla2xxx: Fix delayed response to command for loop mode/direct connect.
  qla2xxx: Allow relogin to proceed if remote login did not finish
  qla2xxx: Use IOCB interface to submit non-critical MBX.
  qla2xxx: Improve T10-DIF/PI handling in driver.
  qla2xxx: Change scsi host lookup method.
  qla2xxx: Fix memory leak for abts processing
  qla2xxx: Fix request queue corruption.
  qla2xxx: Fix inadequate lock protection for ABTS.
  qla2xxx: Add async new target notification
  qla2xxx: Fix sess_lock & hardware_lock lock order problem.

 drivers/scsi/qla2xxx/Kconfig       |   1 +
 drivers/scsi/qla2xxx/qla_attr.c    |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.h     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  46 ++-
 drivers/scsi/qla2xxx/qla_dfs.c     | 115 +++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  12 +-
 drivers/scsi/qla2xxx/qla_init.c    |  85 ++---
 drivers/scsi/qla2xxx/qla_isr.c     |  41 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     | 304 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |  14 +-
 drivers/scsi/qla2xxx/qla_os.c      |  24 +-
 drivers/scsi/qla2xxx/qla_target.c  | 729 +++++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_target.h  |  36 +-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  49 ++-
 15 files changed, 1049 insertions(+), 418 deletions(-)

-- 
1.8.3.1

From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.11-rc3
Date: Sat, 18 Mar 2017 19:08:00 -0700
Message-ID: <1489889280.27336.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the target-pending fixes for v4.11-rc3 code.  Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The bulk of the changes are in qla2xxx target driver code to address
various issues found during Cavium/QLogic's internal testing (stable
CC's included), along with a few other stability and smaller
miscellaneous improvements.

There are also a couple of different patch sets from Mike Christie,
which have been a result of his work to use target-core ALUA logic
together with tcm-user backend driver.

Finally, a patch to address some long standing issues with pass-through
SCSI export of TYPE_TAPE + TYPE_MEDIUM_CHANGER devices, which will make
folks using physical (or virtual) magnetic tape happy.

Thank you,

--nab

Anil Gurumurthy (1):
  qla2xxx: Export DIF stats via debugfs

Himanshu Madhani (2):
  qla2xxx: Add DebugFS node to display Port Database
  qla2xxx: Update driver version to 9.00.00.00-k

Joe Carnuccio (1):
  qla2xxx: Allow vref count to timeout on vport delete.

Max Lohrmann (1):
  target: Fix VERIFY_16 handling in sbc_parse_cdb

Mike Christie (10):
  tcmu: allow hw_max_sectors greater than 128
  tcmu: return on first Opt parse failure
  target: allow ALUA setup for some passthrough backends
  target: fail ALUA transitions for pscsi
  target: Use system workqueue for ALUA transitions
  target: fix ALUA transition timeout handling
  target: allow userspace to set state to transitioning
  target: fix race during implicit transition work flushes
  tcmu: add helper to check if dev was configured
  tcmu: make cmd timeout configurable

Nicholas Bellinger (3):
  target/pscsi: Fix TYPE_TAPE + TYPE_MEDIMUM_CHANGER export
  target: Drop pointless tfo->check_stop_free check
  tcmu: Convert cmd_time_out into backend device attribute

Quinn Tran (10):
  qla2xxx: Fix memory leak for abts processing
  qla2xxx: Fix request queue corruption.
  qla2xxx: Fix inadequate lock protection for ABTS.
  qla2xxx: Fix sess_lock & hardware_lock lock order problem.
  qla2xxx: Allow relogin to proceed if remote login did not finish
  qla2xxx: Improve T10-DIF/PI handling in driver.
  qla2xxx: Add async new target notification
  qla2xxx: Use IOCB interface to submit non-critical MBX.
  qla2xxx: Change scsi host lookup method.
  qla2xxx: Fix delayed response to command for loop mode/direct connect.

 drivers/scsi/qla2xxx/Kconfig           |   1 +
 drivers/scsi/qla2xxx/qla_attr.c        |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.h         |   1 +
 drivers/scsi/qla2xxx/qla_def.h         |  56 ++-
 drivers/scsi/qla2xxx/qla_dfs.c         | 107 ++++-
 drivers/scsi/qla2xxx/qla_gbl.h         |  18 +-
 drivers/scsi/qla2xxx/qla_init.c        |  85 ++--
 drivers/scsi/qla2xxx/qla_iocb.c        |  13 +-
 drivers/scsi/qla2xxx/qla_isr.c         |  41 +-
 drivers/scsi/qla2xxx/qla_mbx.c         | 304 ++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c         |  14 +-
 drivers/scsi/qla2xxx/qla_os.c          |  23 +-
 drivers/scsi/qla2xxx/qla_target.c      | 748 +++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_target.h      |  39 +-
 drivers/scsi/qla2xxx/qla_version.h     |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  49 ++-
 drivers/target/target_core_alua.c      |  82 ++--
 drivers/target/target_core_configfs.c  |   4 +
 drivers/target/target_core_pscsi.c     |  50 +--
 drivers/target/target_core_sbc.c       |  10 +-
 drivers/target/target_core_tpg.c       |   3 +-
 drivers/target/target_core_transport.c |   3 +-
 drivers/target/target_core_user.c      | 152 +++++--
 include/target/target_core_backend.h   |   7 +-
 include/target/target_core_base.h      |   2 +-
 25 files changed, 1274 insertions(+), 548 deletions(-)

From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/25] qla2xxx: Bug fixes and cleanups
Date: Fri, 19 May 2017 14:53:19 -0700
Message-ID: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0066.outbound.protection.outlook.com ([104.47.38.66]:19289
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755535AbdESVxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:53:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series contains bug fixes and cleanups for the driver that we posted in 4.11. 

Patches 1-10 needs to go in 4.12.0-rcX. Rest of the patches can be queued to for-next branch.
Please let me know if the series is okay to be included in 4.12.0-rcX. if we are too late
for big series in rcX then would you please queue patches 10-25 for 4.13/scsi-queue.

Thanks,
Himnanshu

Himanshu Madhani (1):
  qla2xxx: Fix Target mode configuration for ISP25XX

Joe Carnuccio (6):
  qla2xxx: Reduce excessive debug print during 27xx fwdump.
  qla2xxx: Allow fwdump template T262 to specify same start/end.
  qla2xxx: Set bit 15 for DIAG_ECHO_TEST MBC.
  qla2xxx: Fix mailbox pointer error in classic fwdump.
  qla2xxx: Prevent null pointer dereference of ctx.
  qla2xxx: Simplify debug printing of portid.

Quinn Tran (16):
  qla2xxx: Remove redundant fc_host_port_name call
  qla2xxx: Allow ABTS RX, RIDA on ATIOQ for ISP83XX/27XX
  qla2xxx: Replace usage of spin_lock with spin_lock_irqsave
  qla2xxx: Include Exchange offload/Extended Login into FW dump
  qla2xxx: Fix path recovery
  tcm_qla2xxx: Do not allow aborted cmd to advance.
  qla2xxx: Convert 32-bit LUN usage to 64-bit
  qla2xxx: Fix name server relogin
  qla2xxx: Cleanup debug messager IDs.
  qla2xxx: Turn on FW option for exchange check
  qla2xxx: Replace ql2xexchoffld & ql_dm_tgt_ex_pct parameter
  qla2xxx: Remove redundant code
  qla2xxx: Remove redundant wait when target is stopped.
  qla2xxx: Enable auto SCSI BUSY status for target mode
  qla2xxx: Remove unused irq_cmd_count field.
  qla2xxx: Remove extra register read

Sawan Chandak (2):
  qla2xxx: Fix number of queue pairs creation for MQ
  qla2xxx: Use flag PFLG_DISCONNECTED.

 drivers/scsi/qla2xxx/qla_attr.c    |  28 ++-
 drivers/scsi/qla2xxx/qla_bsg.c     |  28 ++-
 drivers/scsi/qla2xxx/qla_dbg.c     |  58 ++++-
 drivers/scsi/qla2xxx/qla_dbg.h     |  12 +
 drivers/scsi/qla2xxx/qla_def.h     |  10 +-
 drivers/scsi/qla2xxx/qla_dfs.c     |  12 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 225 +++++++++---------
 drivers/scsi/qla2xxx/qla_init.c    | 460 ++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_inline.h  |  50 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  22 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  95 ++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |  97 ++++----
 drivers/scsi/qla2xxx/qla_os.c      | 203 ++++++++++------
 drivers/scsi/qla2xxx/qla_target.c  | 453 +++++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_target.h  |   7 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  18 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  16 +-
 18 files changed, 963 insertions(+), 836 deletions(-)

-- 
2.12.0

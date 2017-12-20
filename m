From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/43] qla2xxx: Driver update
Date: Tue, 19 Dec 2017 22:56:01 -0800
Message-ID: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0072.outbound.protection.outlook.com ([104.47.32.72]:53248
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932295AbdLTG4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:56:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series contains number of improvments in handling of switch 
registration commands in the driver. Switch commands are now submitted
via IOCB patch asynchronously instead of mailbox interface.

Please apply this series to 4.16/scsi-queue branch at your earliest
convenience. 

Thanks,
Himanshu

Anil Gurumurthy (1):
  qla2xxx: Add counters for Exchange Buffer to debugfs

Giridhar Malavali (1):
  qla2xxx: Don't call dma_free_coherent with IRQ disabled.

Himanshu Madhani (4):
  qla2xxx: Use known NPort ID for Management Server login
  qla2xxx: Allow relogin and session creation after reset
  qla2xxx: Check FCF_ASYNC_SENT flag
  qla2xxx: Update driver version to 10.00.00.04-k

Quinn Tran (36):
  qla2xxx: Fix stale memory access for name pointer
  qla2xxx: Fix NULL pointer access for fcport structure
  qla2xxx: Use IOCB path to submit Control VP MBX command
  qla2xxx: Use chip reset to bring down laser on unload.
  qla2xxx: Add boundary checks for exchanges to be offloaded
  qla2xxx: Fix stale mem access for IRQ name
  qla2xxx: Add ability to track IOCB resource for FW
  qla2xxx: Chip reset uses wrong lock during IO flush.
  qla2xxx: Fix Firmware dump size for Extended login and Exchange
    Offload
  qla2xxx: Replace GPDB with async ADISC command
  qla2xxx: Move work element processing out of DPC thread
  qla2xxx: Enable ATIO interrupt handshake for ISP27XX
  qla2xxx: Use shadow register for ISP27XX
  qla2xxx: Add option for use reserve exch for ELS
  qla2xxx: Add ability to send PRLO
  qla2xxx: Allow target mode to accept PRLI in dual mode
  qla2xxx: Tweak resource count dump
  qla2xxx: Fix session cleanup for N2N
  qla2xxx: Add switch command to simplify fabric discovery
  qla2xxx: Add lock protection around host lookup
  qla2xxx: Reduce the use of terminate exchange
  qla2xxx: Reduce trace noise for Async Events
  qla2xxx: Fix login state machine freeze
  qla2xxx: Migrate switch registration commands away from mailbox
    interface
  qla2xxx: Remove session creation redundant code
  qla2xxx: Fix GPNFT/GNNFT error handling
  qla2xxx: Properly extract ADISC error codes
  qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling
  qla2xxx: Increase verbosity of debug messages logged
  qla2xxx: Delay loop id allocation at login
  qla2xxx: Add retry limit for fabric scan logic
  qla2xxx: Prevent multiple active discovery commands per session
  qla2xxx: Prevent relogin trigger from sending too many commands
  qla2xxx: Remove unused argument from qlt_schedule_sess_for_deletion()
  qla2xxx: Serialize session deletion by using work_lock
  qla2xxx: Serialize session free in  qlt_free_session_done

Sawan Chandak (1):
  qla2xxx: Remove calling cancel_work_sync()

 drivers/scsi/qla2xxx/qla_attr.c    |    2 +
 drivers/scsi/qla2xxx/qla_bsg.c     |    7 +-
 drivers/scsi/qla2xxx/qla_def.h     |  220 +++++-
 drivers/scsi/qla2xxx/qla_dfs.c     |  354 +++++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   37 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 1339 +++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_init.c    | 1019 +++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_inline.h  |  103 +++
 drivers/scsi/qla2xxx/qla_iocb.c    |   93 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |   64 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  153 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |  113 ++-
 drivers/scsi/qla2xxx/qla_mr.c      |    2 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |    4 +-
 drivers/scsi/qla2xxx/qla_os.c      |  449 ++++++++----
 drivers/scsi/qla2xxx/qla_target.c  |  728 +++++++++++---------
 drivers/scsi/qla2xxx/qla_target.h  |    7 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   40 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 20 files changed, 3593 insertions(+), 1145 deletions(-)

-- 
2.12.0

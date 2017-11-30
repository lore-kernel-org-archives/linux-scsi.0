From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 00/22]  qla2xxx: Bug fixes for 4.15-rc2
Date: Wed, 29 Nov 2017 19:40:25 -0800
Message-ID: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0063.outbound.protection.outlook.com ([104.47.41.63]:49520
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752980AbdK3Dkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 22:40:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

This series contains bug fixes discovered during error handling test
cases for large fabric.

Please apply this series to 4.15-rc2 at your earliest convenience.

Changes from v1 -> v2

o Updated patch description for patch 14 as per Bart's suggestion.

Thanks,
Himanshu

Giridhar Malavali (2):
  qla2xxx: Defer processing of GS IOCB calls
  qla2xxx: Remove aborting ELS IOCB call issued as part of timeout.

Himanshu Madhani (2):
  qla2xxx: Fix memory leak in dual/target mode
  qla2xxx: Update driver version to 10.00.00.03-k

Quinn Tran (17):
  qla2xxx: Fix system crash for Notify ack timeout handling
  qla2xxx: Fix gpnid error processing
  qla2xxx: Move session delete to driver work queue
  qla2xxx: Skip IRQ affinity for Target QPairs
  qla2xxx: Fix re-login for Nport Handle in use
  qla2xxx: Retry switch command on time out
  qla2xxx: Serialize GPNID for multiple RSCN
  qla2xxx: Fix login state machine stuck at GPDB
  qla2xxx: Relogin to target port on a cable swap
  qla2xxx: Fix Relogin being triggered too fast
  qla2xxx: Clear send ELS LOGO flag after target re-login
  qla2xxx: Fix PRLI state check
  qla2xxx: Fix abort command deadlock due to spinlock
  qla2xxx: Replace fcport alloc with qla2x00_alloc_fcport
  qla2xxx: Fix scan state field for fcport
  qla2xxx: Clear loop id after delete
  qla2xxx: Fix system crash in qlt_plogi_ack_unref

Sawan Chandak (1):
  qla2xxx: Fix NPIV host cleanup in target mode

 drivers/scsi/qla2xxx/qla_def.h     |  49 ++++----
 drivers/scsi/qla2xxx/qla_gs.c      | 230 ++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_init.c    |  69 +++++++++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  13 ---
 drivers/scsi/qla2xxx/qla_isr.c     |   7 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   3 +-
 drivers/scsi/qla2xxx/qla_mid.c     |  42 ++++---
 drivers/scsi/qla2xxx/qla_os.c      |  78 ++++++++++---
 drivers/scsi/qla2xxx/qla_target.c  |  60 +++++++---
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 10 files changed, 405 insertions(+), 148 deletions(-)

-- 
2.12.0

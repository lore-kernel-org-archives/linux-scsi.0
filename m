From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/31] qla2xxx: Patches for scsi "misc" branch
Date: Wed, 23 Aug 2017 15:04:54 -0700
Message-ID: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0076.outbound.protection.outlook.com ([104.47.32.76]:29616
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750715AbdHWWFa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

This series contains various bug fixes and driver updates. Please apply
the following patches to the 4.14/scsi-queue branch at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
Himanshu 


Darren Trap (1):
  qla2xxx: Fix WWPN/WWNN in debug message

Duane Grigsby (2):
  qla2xxx: Add command completion for error path
  qla2xxx: Fix system panic due to pointer access problem

Giridhar Malavali (1):
  qla2xxx: Ability to process multiple SGEs in Command SGL for CT
    passthrough commands.

Himanshu Madhani (3):
  qla2xxx: Update fw_started flags at qpair creation.
  qla2xxx: Enable Async TMF processing
  qla2xxx: Update driver version to 10.00.00.01-k

Joe Carnuccio (10):
  qla2xxx: Correction to vha->vref_count timeout
  qla2xxx: Prevent sp->free null/uninitialized pointer dereference.
  qla2xxx: Use sp->free instead of hard coded call.
  qla2xxx: Move logging default mask to execute once only.
  qla2xxx: Add timeout ability to wait_for_sess_deletion().
  qla2xxx: Allow SNS fabric login to be retried
  qla2xxx: Print correct mailbox registers in failed summary
  qla2xxx: Remove potential macro parameter side-effect in
    ql_dump_regs()
  qla2xxx: Add LR distance support from nvram bit
  qla2xxx: Skip zero queue count entry during FW dump capture

Michael Hernandez (2):
  qla2xxx: Fix target multiqueue configuration
  qla2xxx: Increase ql2xmaxqdepth to 64

Quinn Tran (8):
  qla2xxx: Fix NPIV host enable after chip reset
  qla2xxx: Remove extra register read
  qla2xxx: Change ha->wq max_active value to default
  qla2xxx: Use fabric name for Get Port Speed command
  qla2xxx: Add ability to autodetect SFP type
  qla2xxx: Fix task mgmt handling for NPIV
  qla2xxx: Cleanup NPIV host in target mode during config teardown
  qla2xxx: Recheck session state after RSCN

Sawan Chandak (4):
  qla2xxx: Handle PCIe error for driver
  qla2xxx: Use BIT_6 to acquire FAWWPN from switch
  qla2xxx: Add support for minimum link speed
  qla2xxx: Do not call abort handler function during chip reset

 drivers/scsi/qla2xxx/qla_attr.c    |  78 ++++++++-------
 drivers/scsi/qla2xxx/qla_dbg.c     |   8 +-
 drivers/scsi/qla2xxx/qla_def.h     | 105 +++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |  28 ++++--
 drivers/scsi/qla2xxx/qla_gbl.h     |   7 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  18 ++--
 drivers/scsi/qla2xxx/qla_init.c    | 181 ++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_iocb.c    |  55 +++++++----
 drivers/scsi/qla2xxx/qla_isr.c     |  25 ++---
 drivers/scsi/qla2xxx/qla_mbx.c     | 190 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c     |  14 ++-
 drivers/scsi/qla2xxx/qla_mr.c      |   7 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  21 +++-
 drivers/scsi/qla2xxx/qla_os.c      |  91 +++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.c  |  25 +++--
 drivers/scsi/qla2xxx/qla_target.h  |   2 +
 drivers/scsi/qla2xxx/qla_tmpl.c    |  19 ++--
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 18 files changed, 696 insertions(+), 180 deletions(-)

-- 
2.12.0

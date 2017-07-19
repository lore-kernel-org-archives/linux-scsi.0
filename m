From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/7] qla2xxx: Bug fixes for driver
Date: Wed, 19 Jul 2017 11:51:44 -0700
Message-ID: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0081.outbound.protection.outlook.com ([104.47.38.81]:33851
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753813AbdGSSwL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 14:52:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series addresses review comments for previously submitted series for
Target MQ and FC-NVMe support.

Patch 1, 2 addresses review comments by Johannes for FC-NVMe series 
(https://www.spinics.net/lists/linux-scsi/msg110077.html)
(https://www.spinics.net/lists/linux-scsi/msg109985.html)

Patch 3 adds completion wq for FC-NVMe error path.

Patch 4 adds ZIO support for FC-NVMe.

Patch 5 simplifies waiting for unregistration of local/remote FC-NVMe ports.

Patch 6 fixes handling of remote-port disconnect for FC-NVMe.

Patch 7 address review comments by Bart for Target Multi-queue. 
(https://www.spinics.net/lists/target-devel/msg15563.html)

Please apply these patches to scsi-fixes for inclusion in 4.13.0-rc2. 

Thanks,
Himanshu

Duane Grigsby (2):
  qla2xxx: Add command completion wq for error path
  qla2xxx: Added change to enable ZIO for FC-NVMe devices

Himanshu Madhani (4):
  qla2xxx: Cleanup NVMe code.
  qla2xxx: Move function prototype to correct header
  qla2xxx: Simpify unregistration of FC-NVMe local/remote ports
  qla2xxx: Fix remoteport disconnect for FC-NVMe

Quinn Tran (1):
  qla2xxx: Refactor usage of Active command arrays

 drivers/scsi/qla2xxx/qla_bsg.c    |  51 ++++++------
 drivers/scsi/qla2xxx/qla_dbg.c    |   2 +-
 drivers/scsi/qla2xxx/qla_def.h    |  45 +++++++----
 drivers/scsi/qla2xxx/qla_gbl.h    |  14 +---
 drivers/scsi/qla2xxx/qla_init.c   |   7 +-
 drivers/scsi/qla2xxx/qla_inline.h |  23 +++---
 drivers/scsi/qla2xxx/qla_iocb.c   |  16 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |  74 ++++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c    |  82 +++++++++++++++----
 drivers/scsi/qla2xxx/qla_mr.c     |  19 ++---
 drivers/scsi/qla2xxx/qla_nvme.c   | 162 +++++++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_nvme.h   |  17 ++++
 drivers/scsi/qla2xxx/qla_nx.c     |   6 +-
 drivers/scsi/qla2xxx/qla_os.c     |  69 +++++++++++-----
 drivers/scsi/qla2xxx/qla_target.c |  18 +++--
 drivers/scsi/qla2xxx/qla_target.h |   5 --
 16 files changed, 371 insertions(+), 239 deletions(-)

-- 
2.12.0

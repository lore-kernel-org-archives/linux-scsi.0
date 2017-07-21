From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 0/6] qla2xxx: Bug fixes for driver
Date: Fri, 21 Jul 2017 09:32:22 -0700
Message-ID: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0076.outbound.protection.outlook.com ([104.47.41.76]:53206
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754465AbdGUQce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 12:32:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series addresses review comments for previously submitted series for
target multiqueue and FC-NVMe support in 4.13.0-rc1

Patches 1,2 addresses review comments by Johannes for FC-NVMe series
(https://www.spinics.net/lists/linux-scsi/msg110077.html)
(https://www.spinics.net/lists/linux-scsi/msg109985.html)

Patch 3 adds ZIO support for FC-NVMe

Patch 4 simplifies unregistration of local/remote FC-NVMe ports.

Patch 5 fixes handling of remote-port disconnect for FC-NVMe.

Patch 6 addresses review comments by Bart for Target Multiqueue series.
(https://www.spinics.net/lists/target-devel/msg15563.html)

Changes from v1 --> v2

o Added change log into commit message for cleanup patch.
o Dropped Patch for adding completion WQ for FC-NVMe error path for rework.
o Addressed review comments from Johannes in ZIO support patch.
o Added Reviewed by tag.

Please apply these patches to scsi-fixes for inclusion in 4.13.0-rc2.

Thanks,
Himanshu

Duane Grigsby (1):
  qla2xxx: Added change to enable ZIO for FC-NVMe devices

Himanshu Madhani (4):
  qla2xxx: Cleanup FC-NVMe code
  qla2xxx: Move function prototype to correct header
  qla2xxx: Simpify unregistration of FC-NVMe local/remote ports
  qla2xxx: Fix remoteport disconnect for FC-NVMe

Quinn Tran (1):
  qla2xxx: Refactor usage of Active command arrays

 drivers/scsi/qla2xxx/qla_bsg.c    |  51 +++++++-------
 drivers/scsi/qla2xxx/qla_dbg.c    |   2 +-
 drivers/scsi/qla2xxx/qla_def.h    |  44 +++++++-----
 drivers/scsi/qla2xxx/qla_gbl.h    |  14 +---
 drivers/scsi/qla2xxx/qla_init.c   |   7 +-
 drivers/scsi/qla2xxx/qla_inline.h |  23 +++---
 drivers/scsi/qla2xxx/qla_iocb.c   |  16 ++---
 drivers/scsi/qla2xxx/qla_isr.c    |  74 ++++++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c    |  77 +++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mr.c     |  19 ++---
 drivers/scsi/qla2xxx/qla_nvme.c   | 142 +++++++++++++++-----------------------
 drivers/scsi/qla2xxx/qla_nvme.h   |  17 +++++
 drivers/scsi/qla2xxx/qla_nx.c     |   6 +-
 drivers/scsi/qla2xxx/qla_os.c     |  60 +++++++++++-----
 drivers/scsi/qla2xxx/qla_target.c |  18 +++--
 drivers/scsi/qla2xxx/qla_target.h |   5 --
 16 files changed, 336 insertions(+), 239 deletions(-)

-- 
2.12.0

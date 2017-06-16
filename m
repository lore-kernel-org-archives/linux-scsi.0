From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/6] qla2xxx: Add NVMe FC Fabric support in driver
Date: Fri, 16 Jun 2017 15:47:38 -0700
Message-ID: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0042.outbound.protection.outlook.com ([104.47.33.42]:41711
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750873AbdFPWrt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 18:47:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

Hi Martin,

This patch series adds NVMe FC fabric support for qla2xxx initiator mode driver.

This series depends on the target multiqueue series that was sent out on June 13,207. 
(https://www.spinics.net/lists/linux-scsi/msg109827.html)

There are couple of new files qla_nvme.c and qla_nvme.h created to add the changes needed
for registration to NVMe FC transport template as well as error handling logic.

Patch 1 adds NVMe bits to various driver resources to help with NVMe remote port discovery
and PRLI handling in the driver.

Patch 2 adds NVMe command handling in driver. 

Patch 3 has bulk of NVMe changes which handles NVMe support based on module paramter which
is used for firmware initialization and NVMe transport registration. All the logic to handle
NVMe command and error handling is also included in qla_nvme.c file.

Patch 4 and 5 are trivial changes for FDMI registration to send NVMe FC-4 type to switch
management server.

Please apply this series to for-next for inclusion in 4.13 merge window.

Note: Patch 2 does not compile due to change which are part of patch 3. 
      Please apply patch 1-6 to be able to get compilable driver. 

Thanks,
Himanshu 

Duane Grigsby (5):
  qla2xxx: Add FC-NVMe port discovery and PRLI handling
  qla2xxx: Add FC-NVMe command handling
  qla2xxx: Add FC-NVMe F/W initialization and transport registration
  qla2xxx: Send FC4 type NVMe to the management server
  qla2xxx: Use FC-NMVe FC4 type for FDMI registration

Himanshu Madhani (1):
  qla2xxx: Update Driver version to 10.00.00.00-k

 drivers/scsi/qla2xxx/Makefile      |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   9 +-
 drivers/scsi/qla2xxx/qla_def.h     |  52 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |  41 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |  34 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 134 ++++++-
 drivers/scsi/qla2xxx/qla_init.c    | 187 ++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  57 +++
 drivers/scsi/qla2xxx/qla_isr.c     | 105 +++++
 drivers/scsi/qla2xxx/qla_mbx.c     |  55 ++-
 drivers/scsi/qla2xxx/qla_nvme.c    | 797 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nvme.h    | 132 ++++++
 drivers/scsi/qla2xxx/qla_os.c      |  60 ++-
 drivers/scsi/qla2xxx/qla_target.c  |   4 +-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 15 files changed, 1628 insertions(+), 47 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nvme.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nvme.h

-- 
2.12.0

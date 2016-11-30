From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 0/5] qla2xxx: Features updates for driver
Date: Wed, 30 Nov 2016 12:24:52 -0800
Message-ID: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0082.outbound.protection.outlook.com ([104.47.38.82]:34976
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754816AbcK3U53 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 15:57:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Martin,

Please consider this revised series for scsi-misc inclusion
at your earliest convenience.

Changes from v1 --> v2

o Split up the patches for Multiqueue into infrastucture changes
  and support for adding multiqueue capablity in the driver as
  per Ewan's suggestion.
o Incorporate new pci_irq_alloc_vector call as per Christoph's suggestion.
o To address comments related to Mailbox patches by Ewan, I have
  reworked the patch to clean-up mailbox workqueue cleanup. 

Thanks,
Himanshu

Himanshu Madhani (1):
  qla2xxx: Only allow operational MBX to proceed during RESET.

Michael Hernandez (1):
  qla2xxx: Add multiple queue pair functionality.

Quinn Tran (1):
  qla2xxx: Fix Target mode handling with Multiqueue changes.

Samy (1):
  qla2xxx: Fix mailbox command timeout due to starvation

Sawan Chandak (1):
  qla2xxx: Add Block Multi Queue functionality.

 drivers/scsi/qla2xxx/Makefile     |   3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
 drivers/scsi/qla2xxx/qla_bottom.c | 398 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 118 +++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  34 +++-
 drivers/scsi/qla2xxx/qla_init.c   |  14 +-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
 drivers/scsi/qla2xxx/qla_isr.c    | 160 +++++++--------
 drivers/scsi/qla2xxx/qla_mbx.c    | 176 ++++++++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
 drivers/scsi/qla2xxx/qla_mq.c     | 279 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     | 335 ++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_target.c |   4 +
 drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
 16 files changed, 1453 insertions(+), 405 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
 create mode 100644 drivers/scsi/qla2xxx/qla_top.c

-- 
1.8.3.1


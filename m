From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 0/6] qla2xxx: Feture updates for driver.
Date: Fri, 2 Dec 2016 13:44:51 -0800
Message-ID: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0040.outbound.protection.outlook.com ([104.47.42.40]:52386
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754807AbcLBWBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 17:01:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Martin,

Please consider this revised series for scsi-misc inclusion
at your earliest convenience.

Changes from v2 --> v3

o Added patch to utilize pci_{alloc|free}_irq_vectors call as per
  Christoph's suggestion.
o Clean up IRQ affinity and drop num_online_cpu() usage in driver
  as per review comments from Hannes & Christoph.
o Added patch description for mailbox starvation patch. Also added
  Reviewed-by signature from Hannes.

Changes from v1 --> v2

o Split up the patches for Multiqueue into infrastucture changes
  and support for adding multiqueue capablity in the driver as
  per Ewan's suggestion.
o Incorporate new pci_irq_alloc_vector call as per Christoph's suggestion.
o To address comments related to Mailbox patches by Ewan, I have
  reworked the patch to clean-up mailbox workqueue.

Thanks,
Himanshu

Himanshu Madhani (1):
  qla2xxx: Only allow operational MBX to proceed during RESET.

Michael Hernandez (3):
  qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls.
  qla2xxx: Add multiple queue pair functionality.
  qla2xxx: Add Block Multi Queue functionality.

Quinn Tran (1):
  qla2xxx: Fix Target mode handling with Multiqueue changes.

Samy (1):
  qla2xxx: Fix mailbox command timeout due to starvation

 drivers/scsi/qla2xxx/Makefile     |   3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
 drivers/scsi/qla2xxx/qla_bottom.c | 398 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 110 +++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  32 ++-
 drivers/scsi/qla2xxx/qla_init.c   |  14 +-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
 drivers/scsi/qla2xxx/qla_isr.c    | 196 ++++++++-----------
 drivers/scsi/qla2xxx/qla_mbx.c    | 165 +++++++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
 drivers/scsi/qla2xxx/qla_mq.c     | 236 ++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     | 329 ++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
 15 files changed, 1388 insertions(+), 432 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
 create mode 100644 drivers/scsi/qla2xxx/qla_top.c

-- 
1.8.3.1


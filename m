From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v5 0/5] qla2xxx: Feature updaes for driver.
Date: Mon, 12 Dec 2016 14:40:04 -0800
Message-ID: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0062.outbound.protection.outlook.com ([104.47.36.62]:8482
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751697AbcLLWkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Dec 2016 17:40:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Martin, 

Please consider this revised series for inclusion into scsi-misc. 
This series has incorporated partial changes based on review comments
from Christoph and Hannes. 

Changes from v4 -> v5

o Dropped patch addressing mailbox starvation from current series.
  We'll work on alternate mechanism with customer to address it.  
o Added qla2xxx_map_queues() callback for Block-MQ.
o Current patch does not use pci_alloc_irq_vectors_affinity() callback
  because its not part of scsi-misc tree yet. Once the necesary patches
  are pulled into scsi tree, we'll send new patch incorporating the
  new callback. 

Changes from v3 -> v4

o Removed now stale rsp_q refrence from qla_msix_entry. 
o Merged the multiple files into exsisting code
o Enabled Mutiqueue by default.
o Updated to use kcalloc instead of kzalloc

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

 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++-
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 108 +++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  28 ++-
 drivers/scsi/qla2xxx/qla_init.c   | 173 +++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   | 407 ++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c    | 223 +++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c    |  85 ++++++-
 drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++-----
 drivers/scsi/qla2xxx/qla_os.c     | 475 +++++++++++++++++++++++++++-----------
 11 files changed, 1277 insertions(+), 408 deletions(-)

-- 
1.8.3.1


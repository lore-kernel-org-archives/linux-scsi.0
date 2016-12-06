From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 0/6] qla2xxx: Feature udpates for driver.
Date: Tue, 6 Dec 2016 11:07:40 -0800
Message-ID: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:43583
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751617AbcLFTH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 14:07:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Martin, 

Please consider this revised series for inclusion into scsi-misc. 
This series has incorporated partial changes based on review comments
from Christop and Hannes. 

There were few changes that are left out of this series as they 
will need regression testing and we have patches for target infrastucture
already based on these patch series which I am going to send out soon.
We will submit additional patches with the changes suggested as soon as
we have completed regression with them. 

Here's list of changes that will be posted as seperate series after
they have gone through regression cycle. 

o Converting uint32_t to bitops and macros to inline function. 
o Use waitqueue instead of busy wait.
o Use of srb pool from the scsi_command instead of 
  allocating/deallocatig mempool in the driver.

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

 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++-
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 111 +++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  28 ++-
 drivers/scsi/qla2xxx/qla_init.c   | 173 +++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   | 407 +++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c    | 223 +++++++++--------
 drivers/scsi/qla2xxx/qla_mbx.c    | 165 ++++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    | 116 ++++-----
 drivers/scsi/qla2xxx/qla_os.c     | 487 ++++++++++++++++++++++++++++----------
 11 files changed, 1353 insertions(+), 427 deletions(-)

-- 
1.8.3.1


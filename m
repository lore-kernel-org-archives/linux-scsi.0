From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] mpt3sas: Fix panic when aer correct error occured
Date: Tue, 12 Jul 2016 17:43:25 +0800
Message-ID: <1468316605-788-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Kefeng Wang <wangkefeng.wang@huawei.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

The _scsih_pci_mmio_enabled called if scsih_pci_error_detected returns
PCI_ERS_RESULT_CAN_RECOVER, at this point, read/write to the device
still works, no need to reset slot.

Or the mpt3sas_base_map_resources in scsih_pci_slot_reset will fail,
and iounamp ioc->chip, then we will meet issue when read ioc->chip
in mpt3sas_base_get_iocstate from _base_fault_reset_work.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---

NOTE: I found this with an earlier kernel version, but the logic is not changed.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6bff13e..eedd62e3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9033,8 +9033,11 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 
 	/* TODO - dump whatever for debugging purposes */
 
-	/* Request a slot reset. */
-	return PCI_ERS_RESULT_NEED_RESET;
+	/* This called only if scsih_pci_error_detected returns
+	 * PCI_ERS_RESULT_CAN_RECOVER, read/write to the device
+	 * still works, not need to reset slot.
+	 */
+	return PCI_ERS_RESULT_RECOVERED;
 }
 
 /*
-- 
1.7.12.4

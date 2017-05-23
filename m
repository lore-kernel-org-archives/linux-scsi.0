From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] qla2xxx: don't disable a not previously enabled PCI device
Date: Tue, 23 May 2017 16:50:47 +0200
Message-ID: <20170523145047.5020-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, himanshu.madhani@cavium.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

When pci_enable_device() or pci_enable_device_mem() fail in
qla2x00_probe_one() we bail out but do a call to
pci_disable_device(). This causes the dev_WARN_ON() in
pci_disable_device() to trigger, as the device wasn't enabled
previously.

So instead of taking the 'probe_out' error path we can directly return
*iff* one of the pci_enable_device() calls fails.

Additionally rename the 'probe_out' goto label's name to the more
descriptive 'disable_device'.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: e315cd28b9ef ("[SCSI] qla2xxx: Code changes for qla data structure refactoring")
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7957903283..af25d8afd42a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2623,10 +2623,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (mem_only) {
 		if (pci_enable_device_mem(pdev))
-			goto probe_out;
+			return ret;
 	} else {
 		if (pci_enable_device(pdev))
-			goto probe_out;
+			return ret;
 	}
 
 	/* This may fail but that's ok */
@@ -2636,7 +2636,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ha) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0009,
 		    "Unable to allocate memory for ha.\n");
-		goto probe_out;
+		goto disable_device;
 	}
 	ql_dbg_pci(ql_dbg_init, pdev, 0x000a,
 	    "Memory allocated for ha=%p.\n", ha);
@@ -3254,7 +3254,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
 
-probe_out:
+disable_device:
 	pci_disable_device(pdev);
 	return ret;
 }
-- 
2.12.0

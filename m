From: Anil Chintalapati <achintal@cisco.com>
Subject: [PATCH 1/1] IOMMU Fault occurs when IO and abort IO is out of order
Date: Mon, 17 Nov 2014 14:28:12 -0800
Message-ID: <1416263292-25713-1-git-send-email-achintal@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:4415 "EHLO
	alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaKQWgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Nov 2014 17:36:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hishah@cisco.com, sebaddel@cisco.com, achintal@cisco.com

When I/O is aborted by mid-layer, fnic FW will complete the I/O before completing the abort task. In some cases abort request is completed before the I/O,
which could lead to inconsistent driver and firmware states. In this case firmware reset would clear the inconsistent state

Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index bf8d34c..26270c3 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.11"
+#define DRV_VERSION		"1.6.0.17"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 961bdf5..9ebc933 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1873,6 +1873,21 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		goto fnic_abort_cmd_end;
 	}
 
+	/* IO out of order */
+
+	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
+		spin_unlock_irqrestore(io_lock, flags);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Issuing Host reset due to out of order IO\n");
+
+		if (fnic_host_reset(sc) == FAILED) {
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				"fnic_host_reset failed.\n");
+		}
+		ret = FAILED;
+		goto fnic_abort_cmd_end;
+	}
+
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
 	/*
-- 
1.8.5.4


From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/9] qla2xxx: Correct IOCB queueing mechanism for ISP54XX HBAs.
Date: Wed, 13 Dec 2006 19:20:29 -0800
Message-ID: <1166066433322-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbWLNDdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:46 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code would incorrectly use non-24xx code-paths.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d03523d..36657fa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1413,7 +1413,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sht = &qla2x00_driver_template;
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5422 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432)
 		sht = &qla24xx_driver_template;
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
-- 
1.4.4.2.g4cfec


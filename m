From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Fix for 32-bit platforms with 64-bit resources.
Date: Thu, 17 Jan 2008 09:02:09 -0800
Message-ID: <1200589340-19499-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYAQRCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:31 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The driver stores the contents of PCI resources into unsigned
long's before ioremapping. This breaks on 32-bit platforms which
support 64-bit MMIO resources.

Correct code by removing the temporary variables used during MMIO
PIO mapping and using resource_size_t where applicable.  Also
correct a small typo in a printk() where the wrong region number
was displayed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 +--
 drivers/scsi/qla2xxx/qla_os.c  |   22 +++++++---------------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a33d3d5..d0b78af 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2271,8 +2271,7 @@ typedef struct scsi_qla_host {
 
 	int		bars;
 	device_reg_t __iomem *iobase;		/* Base I/O address */
-	unsigned long	pio_address;
-	unsigned long	pio_length;
+	resource_size_t pio_address;
 #define MIN_IOBASE_LEN		0x100
 
 	/* ISP ring lock, rings, and indexes */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8ecc047..ab7abe0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1479,8 +1479,7 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 static int
 qla2x00_iospace_config(scsi_qla_host_t *ha)
 {
-	unsigned long	pio, pio_len, pio_flags;
-	unsigned long	mmio, mmio_len, mmio_flags;
+	resource_size_t pio;
 
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
@@ -1495,10 +1494,8 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 
 	/* We only need PIO for Flash operations on ISP2312 v2 chips. */
 	pio = pci_resource_start(ha->pdev, 0);
-	pio_len = pci_resource_len(ha->pdev, 0);
-	pio_flags = pci_resource_flags(ha->pdev, 0);
-	if (pio_flags & IORESOURCE_IO) {
-		if (pio_len < MIN_IOBASE_LEN) {
+	if (pci_resource_flags(ha->pdev, 0) & IORESOURCE_IO) {
+		if (pci_resource_len(ha->pdev, 0) < MIN_IOBASE_LEN) {
 			qla_printk(KERN_WARNING, ha,
 			    "Invalid PCI I/O region size (%s)...\n",
 				pci_name(ha->pdev));
@@ -1511,28 +1508,23 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 		pio = 0;
 	}
 	ha->pio_address = pio;
-	ha->pio_length = pio_len;
 
 skip_pio:
 	/* Use MMIO operations for all accesses. */
-	mmio = pci_resource_start(ha->pdev, 1);
-	mmio_len = pci_resource_len(ha->pdev, 1);
-	mmio_flags = pci_resource_flags(ha->pdev, 1);
-
-	if (!(mmio_flags & IORESOURCE_MEM)) {
+	if (!(pci_resource_flags(ha->pdev, 1) & IORESOURCE_MEM)) {
 		qla_printk(KERN_ERR, ha,
-		    "region #0 not an MMIO resource (%s), aborting\n",
+		    "region #1 not an MMIO resource (%s), aborting\n",
 		    pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
-	if (mmio_len < MIN_IOBASE_LEN) {
+	if (pci_resource_len(ha->pdev, 1) < MIN_IOBASE_LEN) {
 		qla_printk(KERN_ERR, ha,
 		    "Invalid PCI mem region size (%s), aborting\n",
 			pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
 
-	ha->iobase = ioremap(mmio, MIN_IOBASE_LEN);
+	ha->iobase = ioremap(pci_resource_start(ha->pdev, 1), MIN_IOBASE_LEN);
 	if (!ha->iobase) {
 		qla_printk(KERN_ERR, ha,
 		    "cannot remap MMIO (%s), aborting\n", pci_name(ha->pdev));
-- 
1.5.4.rc3.14.g44397


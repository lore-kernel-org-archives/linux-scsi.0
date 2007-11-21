From: akpm@linux-foundation.org
Subject: [patch 10/23] ips: PCI API cleanups
Date: Wed, 21 Nov 2007 15:12:22 -0800
Message-ID: <200711212312.lALNCM8P014133@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbXKUXNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:13:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, mark_salyzyn@adaptec.com

From: Jeff Garzik <jeff@garzik.org>

* pass Scsi_Host to ips_remove_device() via pci_set_drvdata(),
  allowing us to eliminate the ips_ha[] search loop and call
  ips_release() directly.

* call pci_{request,release}_regions() and eliminate individual
  request/release_[mem_]region() calls

* call pci_disable_device(), paired with pci_enable_device()

* s/0/NULL/ in a few places

* check ioremap() return value

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   72 ++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff -puN drivers/scsi/ips.c~ips-pci-api-cleanups drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-pci-api-cleanups
+++ a/drivers/scsi/ips.c
@@ -702,10 +702,6 @@ ips_release(struct Scsi_Host *sh)
 	/* free extra memory */
 	ips_free(ha);
 
-	/* Free I/O Region */
-	if (ha->io_addr)
-		release_region(ha->io_addr, ha->io_len);
-
 	/* free IRQ */
 	free_irq(ha->pcidev->irq, ha);
 
@@ -4394,8 +4390,6 @@ ips_free(ips_ha_t * ha)
 			ha->mem_ptr = NULL;
 		}
 
-		if (ha->mem_addr)
-			release_mem_region(ha->mem_addr, ha->mem_len);
 		ha->mem_addr = 0;
 
 	}
@@ -6880,20 +6874,14 @@ ips_register_scsi(int index)
 static void __devexit
 ips_remove_device(struct pci_dev *pci_dev)
 {
-	int i;
-	struct Scsi_Host *sh;
-	ips_ha_t *ha;
+	struct Scsi_Host *sh = pci_get_drvdata(pci_dev);
 
-	for (i = 0; i < IPS_MAX_ADAPTERS; i++) {
-		ha = ips_ha[i];
-		if (ha) {
-			if ((pci_dev->bus->number == ha->pcidev->bus->number) &&
-			    (pci_dev->devfn == ha->pcidev->devfn)) {
-				sh = ips_sh[i];
-				ips_release(sh);
-			}
-		}
-	}
+	pci_set_drvdata(pci_dev, NULL);
+
+	ips_release(sh);
+
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
 }
 
 /****************************************************************************/
@@ -6947,12 +6935,17 @@ module_exit(ips_module_exit);
 static int __devinit
 ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent)
 {
-	int uninitialized_var(index);
+	int index = -1;
 	int rc;
 
 	METHOD_TRACE("ips_insert_device", 1);
-	if (pci_enable_device(pci_dev))
-		return -1;
+	rc = pci_enable_device(pci_dev);
+	if (rc)
+		return rc;
+
+	rc = pci_request_regions(pci_dev, "ips");
+	if (rc)
+		goto err_out;
 
 	rc = ips_init_phase1(pci_dev, &index);
 	if (rc == SUCCESS)
@@ -6968,6 +6961,19 @@ ips_insert_device(struct pci_dev *pci_de
 		ips_num_controllers++;
 
 	ips_next_controller = ips_num_controllers;
+
+	if (rc < 0) {
+		rc = -ENODEV;
+		goto err_out_regions;
+	}
+
+	pci_set_drvdata(pci_dev, ips_sh[index]);
+	return 0;
+
+err_out_regions:
+	pci_release_regions(pci_dev);
+err_out:
+	pci_disable_device(pci_dev);
 	return rc;
 }
 
@@ -7000,7 +7006,7 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	METHOD_TRACE("ips_init_phase1", 1);
 	index = IPS_MAX_ADAPTERS;
 	for (j = 0; j < IPS_MAX_ADAPTERS; j++) {
-		if (ips_ha[j] == 0) {
+		if (ips_ha[j] == NULL) {
 			index = j;
 			break;
 		}
@@ -7037,32 +7043,17 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		uint32_t base;
 		uint32_t offs;
 
-		if (!request_mem_region(mem_addr, mem_len, "ips")) {
-			IPS_PRINTK(KERN_WARNING, pci_dev,
-				   "Couldn't allocate IO Memory space %x len %d.\n",
-				   mem_addr, mem_len);
-			return -1;
-		}
-
 		base = mem_addr & PAGE_MASK;
 		offs = mem_addr - base;
 		ioremap_ptr = ioremap(base, PAGE_SIZE);
+		if (!ioremap_ptr)
+			return -1;
 		mem_ptr = ioremap_ptr + offs;
 	} else {
 		ioremap_ptr = NULL;
 		mem_ptr = NULL;
 	}
 
-	/* setup I/O mapped area (if applicable) */
-	if (io_addr) {
-		if (!request_region(io_addr, io_len, "ips")) {
-			IPS_PRINTK(KERN_WARNING, pci_dev,
-				   "Couldn't allocate IO space %x len %d.\n",
-				   io_addr, io_len);
-			return -1;
-		}
-	}
-
 	/* found a controller */
 	ha = kzalloc(sizeof (ips_ha_t), GFP_KERNEL);
 	if (ha == NULL) {
@@ -7071,7 +7062,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		return -1;
 	}
 
-
 	ips_sh[index] = NULL;
 	ips_ha[index] = ha;
 	ha->active = 1;
_

From: "ed.lin" <ed.lin@promise.com>
Subject: [PATCH 2/5][resend 2] stex: Add new device id
Date: Tue, 27 Jan 2009 06:36:08 +0800
Message-ID: <200901270636.08832.ed.lin@promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:26466 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752438AbZA0GgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 01:36:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

Add new device id for controller type st_seq.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6129db4..12dc0d1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -119,6 +119,7 @@ enum {
  st_vsc     = 1,
  st_vsc1     = 2,
  st_yosemite    = 3,
+ st_seq     = 4,
 
  PASSTHRU_REQ_TYPE   = 0x00000001,
  PASSTHRU_REQ_NO_WAKEUP   = 0x00000100,
@@ -1127,7 +1128,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  hba->cardtype = (unsigned int) id->driver_data;
  if (hba->cardtype == st_vsc && (pdev->subsystem_device & 0xf) == 0x1)
   hba->cardtype = st_vsc1;
- hba->dma_size = (hba->cardtype == st_vsc1) ?
+ hba->dma_size = (hba->cardtype == st_vsc1 || hba->cardtype == st_seq) ?
   (STEX_BUFFER_SIZE + ST_ADDITIONAL_MEM) : (STEX_BUFFER_SIZE);
  hba->dma_mem = dma_alloc_coherent(&pdev->dev,
   hba->dma_size, &hba->dma_handle, GFP_KERNEL);
@@ -1150,7 +1151,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
   host->max_lun = 128;
   host->max_id = 1 + 1;
  } else {
-  /* st_vsc and st_vsc1 */
+  /* st_vsc , st_vsc1 and st_seq */
   host->max_lun = 1;
   host->max_id = 128 + 1;
  }
@@ -1312,6 +1313,9 @@ static struct pci_device_id stex_pci_tbl[] = {
   st_yosemite }, /* SuperTrak EX8654 */
  { 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
   st_yosemite }, /* generic st_yosemite */
+
+ /* st_seq */
+ { 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
  { } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

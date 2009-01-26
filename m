From: Ed Lin <ed.lin@promise.com>
Subject: [PATCH 2/5][resend] stex: Add new device id
Date: Mon, 26 Jan 2009 15:33:50 -0800
Message-ID: <f60baa940901261533h3174b3beub846cb74fa4e490e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:4168 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbZAZXdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 18:33:51 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2681247yxm.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 15:33:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: promise_linux <promise_linux@promise.com>, linux-scsi@vger.kernel.org

Add new device id for controller type st_seq.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6129db4..12dc0d1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -119,6 +119,7 @@ enum {
 	st_vsc					= 1,
 	st_vsc1					= 2,
 	st_yosemite				= 3,
+	st_seq					= 4,

 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -1127,7 +1128,7 @@ stex_probe(struct pci_dev *pdev, const struct
pci_device_id *id)
 	hba->cardtype = (unsigned int) id->driver_data;
 	if (hba->cardtype == st_vsc && (pdev->subsystem_device & 0xf) == 0x1)
 		hba->cardtype = st_vsc1;
-	hba->dma_size = (hba->cardtype == st_vsc1) ?
+	hba->dma_size = (hba->cardtype == st_vsc1 || hba->cardtype == st_seq) ?
 		(STEX_BUFFER_SIZE + ST_ADDITIONAL_MEM) : (STEX_BUFFER_SIZE);
 	hba->dma_mem = dma_alloc_coherent(&pdev->dev,
 		hba->dma_size, &hba->dma_handle, GFP_KERNEL);
@@ -1150,7 +1151,7 @@ stex_probe(struct pci_dev *pdev, const struct
pci_device_id *id)
 		host->max_lun = 128;
 		host->max_id = 1 + 1;
 	} else {
-		/* st_vsc and st_vsc1 */
+		/* st_vsc , st_vsc1 and st_seq */
 		host->max_lun = 1;
 		host->max_id = 128 + 1;
 	}
@@ -1312,6 +1313,9 @@ static struct pci_device_id stex_pci_tbl[] = {
 		st_yosemite }, /* SuperTrak EX8654 */
 	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		st_yosemite }, /* generic st_yosemite */
+
+	/* st_seq */
+	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

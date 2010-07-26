From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Mon, 26 Jul 2010 08:07:44 +0200
Message-ID: <201007260807.45533.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57326 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0GZGHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2010 02:07:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

>From 1c2f6ce5be5890ea7151ada3602699566afdd060 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Wed, 1 Jul 2009 22:43:39 +0200

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/aacraid/linit.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

James, it looks like people at Adaptec don't care if you send patches in. That 
also applies to at least one patch from Julia Lawall that is waiting since 
December. What next?

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 33898b6..cad6f9a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1091,6 +1091,7 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 	struct list_head *insert = &aac_devices;
 	int error = -ENODEV;
 	int unique_id = 0;
+	u64 dmamask;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id)
@@ -1104,17 +1105,18 @@ static int __devinit aac_probe_one(struct pci_dev 
*pdev,
 		goto out;
 	error = -ENODEV;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
-		goto out_disable_pdev;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
 	 * to driver communication memory to be allocated below 2gig
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(31)) ||
-				pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(31)))
-			goto out_disable_pdev;
+		dmamask = DMA_BIT_MASK(31);
+	else
+		dmamask = DMA_BIT_MASK(32);
+
+	if (pci_set_dma_mask(pdev, dmamask) ||
+			pci_set_consistent_dma_mask(pdev, dmamask))
+		goto out_disable_pdev;
 
 	pci_set_master(pdev);
 
-- 
1.7.1


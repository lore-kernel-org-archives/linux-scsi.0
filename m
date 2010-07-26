From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Mon, 26 Jul 2010 06:25:54 -0700
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D03B14F61@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <201007260807.45533.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:46896 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab0GZNyN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 09:54:13 -0400
Content-class: urn:content-classes:message
In-Reply-To: <201007260807.45533.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>, aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Rolf,

The patch looks good for me so from my side we can include it. Sorry for
the delay - I will try to give quick answers for future requests. Please
pay attention that my personal email address has changed because we are
now part of PMC-Sierra Inc. But aacraid@adaptec.com remains active.

Thanks,
Achim Leubner
PMC-Sierra Inc.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Rolf Eike Beer
Sent: Monday, July 26, 2010 8:08 AM
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org; Andrew Morton
Subject: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if
adapter only supports 31

>From 1c2f6ce5be5890ea7151ada3602699566afdd060 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Wed, 1 Jul 2009 22:43:39 +0200

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/aacraid/linit.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

James, it looks like people at Adaptec don't care if you send patches
in. That 
also applies to at least one patch from Julia Lawall that is waiting
since 
December. What next?

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 33898b6..cad6f9a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1091,6 +1091,7 @@ static int __devinit aac_probe_one(struct pci_dev
*pdev,
 	struct list_head *insert = &aac_devices;
 	int error = -ENODEV;
 	int unique_id = 0;
+	u64 dmamask;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id)
@@ -1104,17 +1105,18 @@ static int __devinit aac_probe_one(struct
pci_dev 
*pdev,
 		goto out;
 	error = -ENODEV;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-			pci_set_consistent_dma_mask(pdev,
DMA_BIT_MASK(32)))
-		goto out_disable_pdev;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
 	 * to driver communication memory to be allocated below 2gig
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(31)) ||
-				pci_set_consistent_dma_mask(pdev,
DMA_BIT_MASK(31)))
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

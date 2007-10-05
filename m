From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/17] sym53c8xx: Work around 53c896 erratum
Date: Fri,  5 Oct 2007 15:54:58 -0400
Message-ID: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:47860 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbXJETzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Prevent DMA transfers from crossing the 16MB limit for early 53c896 chips.

From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 3db2232..d5455e3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1531,6 +1531,10 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	BUG_ON(sym2_transport_template == NULL);
 	instance->transportt	= sym2_transport_template;
 
+	/* 53c896 rev 1 errata: DMA may not cross 16MB boundary */
+	if (pdev->device == PCI_DEVICE_ID_NCR_53C896 && np->revision_id < 2)
+		instance->dma_boundary = 0xFFFFFF;
+
 	spin_unlock_irqrestore(instance->host_lock, flags);
 
 	return instance;
-- 
1.4.4.2


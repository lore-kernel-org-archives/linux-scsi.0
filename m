From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/1] aacraid: Fix for arrays are going offline in the system. System hangs
Date: Tue, 18 Jun 2013 17:02:07 +0530
Message-ID: <1371555127-1504-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:46708 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab3FRMPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jun 2013 08:15:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim.Leubner@pmcs.com, Tony.Ruiz@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Hi James,

One of the customer had reported that the set of raid logical arrays will become unavailable (I/O offline) after a long hours of IO stress test.  The OS wouldn`t be accessible afterwards and require a hard reset.

This driver patch has a fix for race condition between the doorbell and the circular buffer. The driver is modified to do an extra read after clearing the doorbell in case there had been a completion posted during the small timing window.

With this fix, we ran IO stress for ~13 days. There were no IO failures.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/src.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 0f56d8d..7e17107 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -93,6 +93,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 			int send_it = 0;
 			extern int aac_sync_mode;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (!aac_sync_mode) {
 				src_writel(dev, MUnit.ODR_C, bellbits);
 				src_readl(dev, MUnit.ODR_C);
-- 
1.7.11.7


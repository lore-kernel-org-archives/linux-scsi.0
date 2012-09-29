From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 01/17] be2iscsi: Fix the issue with soft reset.
Date: Sat, 29 Sep 2012 07:01:20 +0530
Message-ID: <236ee3ce-bfeb-41c1-9446-c11ae77da80b@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5825 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I2BcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:32:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: Minh Tran <minhduc.tran@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Minh Tran <minhduc.tran@emulex.com>

 Fixed soft_reset problem which driver modified
 all 32bit before a write on second pass.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 07d2cb1..05f70bb 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -56,7 +56,7 @@ int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
 	writel(pconline0, (void *)pci_online0_offset);
 	writel(pconline1, (void *)pci_online1_offset);
 
-	sreset = BE2_SET_RESET;
+	sreset |= BE2_SET_RESET;
 	writel(sreset, (void *)pci_reset_offset);
 
 	i = 0;
-- 
1.7.2


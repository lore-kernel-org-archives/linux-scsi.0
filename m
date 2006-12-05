From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 3/8] stex: add value check in hard reset routine
Date: Mon, 4 Dec 2006 17:49:31 -0800
Message-ID: <NONAMEBwIPvlKWzqJX700001570@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18934 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968012AbWLEBtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


During hard reset, an all-1 value from PCI_COMMAND should be invalid.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index ea0d824..92dbac0 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1041,7 +1041,7 @@ static void stex_hard_reset(struct st_hb
 
 	for (i = 0; i < MU_MAX_DELAY_TIME; i++) {
 		pci_read_config_word(hba->pdev, PCI_COMMAND, &pci_cmd);
-		if (pci_cmd & PCI_COMMAND_MASTER)
+		if (pci_cmd != 0xffff && (pci_cmd & PCI_COMMAND_MASTER))
 			break;
 		msleep(1);
 	}



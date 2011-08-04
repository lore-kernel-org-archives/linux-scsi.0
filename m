From: <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Added missing mpt2sas_base_detach call from
 scsih_remove context
Date: Thu, 4 Aug 2011 16:47:50 +0530
Message-ID: <201108041056.p74AuXkJ007223@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:47550 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab1HDK4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 06:56:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

mpt2sas_base_detach() call was removed from _scsih_remove() while doing some code shuffling.
Mainly when we work on adding code for scsih_shutdown().
I have added back mpt2sas_base_detach() which will get callled from _scsih_remove().

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6abd2fc..6bb3986 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7354,6 +7354,7 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	mpt2sas_base_detach(ioc);
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);

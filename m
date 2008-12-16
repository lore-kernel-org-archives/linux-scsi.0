From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] sym53c8xx: fix shost use-after-free and memory leak
Date: Tue, 16 Dec 2008 14:35:50 -0500
Message-ID: <49480316.3000503@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2869 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbYLPUGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 15:06:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This patch fixes two bugs:

1) rmmod sym53c8xx uses shost after freeing it with scsi_put_host(shost).

2) insmod sym53c8xx doesn't call scsi_put_host(shost) if scsi_add_host()
fails, causing a memory leak on the error path.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28-rc8/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2008-12-16 14:18:46.000000000 -0500
+++ linux-2.6.28-rc8/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-12-16 14:19:41.000000000 -0500
@@ -1660,6 +1660,7 @@ static int sym_detach(struct Scsi_Host *
 	OUTB(np, nc_istat, 0);
 
 	sym_free_resources(np, pdev);
+	scsi_host_put(shost);
 
 	return 1;
 }
@@ -1749,7 +1750,6 @@ static void sym2_remove(struct pci_dev *
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
 	scsi_remove_host(shost);
-	scsi_host_put(shost);
 	sym_detach(shost, pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);



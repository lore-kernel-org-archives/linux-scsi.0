From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 1/7] sym53c8xx: fix shost use-after-free and memory leak
Date: Thu, 08 Jan 2009 12:52:32 -0500
Message-ID: <49663D60.2090209@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4525 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZAHRwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:52:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

This patch fixes two bugs:

1) rmmod sym53c8xx uses shost after freeing it with
   scsi_put_host(shost).

2) insmod sym53c8xx doesn't call scsi_put_host(shost) if
   scsi_add_host() fails, causing a memory leak on the error path.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

previously posted here:
http://marc.info/?l=linux-scsi&m=122945812727396&w=4

--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-07 17:30:06.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-07 17:31:07.000000000 -0500
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



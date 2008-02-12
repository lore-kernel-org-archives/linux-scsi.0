From: Sergio Luis <sergio@larces.uece.br>
Subject: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c into
 using pci_get device
Date: Tue, 12 Feb 2008 11:31:42 -0300
Message-ID: <47B1ADCE.40202@larces.uece.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:31194 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310AbYBLOae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 09:30:34 -0500
Received: by wx-out-0506.google.com with SMTP id h31so5157923wxd.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 06:30:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Fix compilation warning in drivers/scsi/gdth.c, using deprecated pci_find_device. 
Change it into using pci_get_device instead:
drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)

Signed-off-by: Sergio Luis <sergio@larces.uece.br>

gdth.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)


diff -urN linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c linux-2.6.25-rc1-git2/drivers/scsi/gdth.c
--- linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c	2008-02-12 09:26:14.000000000 -0300
+++ linux-2.6.25-rc1-git2/drivers/scsi/gdth.c	2008-02-12 10:33:08.000000000 -0300
@@ -642,7 +642,7 @@
           *cnt, vendor, device));
 
     pdev = NULL;
-    while ((pdev = pci_find_device(vendor, device, pdev)) 
+    while ((pdev = pci_get_device(vendor, device, pdev)) 
            != NULL) {
         if (pci_enable_device(pdev))
             continue;


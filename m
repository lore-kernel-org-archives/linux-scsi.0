From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: 2.6 fix panic on module removal
Date: Fri, 10 Dec 2004 11:37:02 -0800
Message-ID: <1102707422.20683.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:51337 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261809AbULJThG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 14:37:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch moves the list_del before the host data is freed up.  The aac
struct is invalid once scsi_host_put is called.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/linit.c 1.42 vs edited =====
--- 1.42/drivers/scsi/aacraid/linit.c	2004-10-20 06:46:09 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-12-10 11:26:09 -08:00
@@ -663,10 +663,9 @@
 	
 	kfree(aac->fibs);
 	
+	list_del(&aac->entry);
 	scsi_host_put(shost);
 	pci_disable_device(pdev);
-
-	list_del(&aac->entry);
 }
 
 static struct pci_driver aac_pci_driver = {

-- 
Mark Haverkamp <markh@osdl.org>


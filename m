From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] inia100.c: pointer used before being set
Date: Mon, 12 Jan 2004 21:07:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112210754.582573ad.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:53718 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263600AbUAMFJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 00:09:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb <james.bottomley@steeleye.com>


drivers/scsi/inia100.c:421: warning: `pHCB' might be used uninitialized in this function

I see a problem there, patch is below.  Warning is still there, however,
so this doesn't fix the warning, just fixes a real bug.

changelog:	use local <port> since pHCB is not set yet;

product_versions: Linux 2.6.1
Please apply.

diffstat:=

diff -Naurp ./drivers/scsi/inia100.c~inia_warn ./drivers/scsi/inia100.c
--- ./drivers/scsi/inia100.c~inia_warn	2004-01-08 22:59:19.000000000 -0800
+++ ./drivers/scsi/inia100.c	2004-01-12 21:01:49.000000000 -0800
@@ -434,9 +434,9 @@ static int __devinit inia100_probe_one(s
 	}
 
 	port = pci_resource_start(pdev, 0);
-	if (!request_region(pHCB->HCS_Base, 256, "inia100")) {
+	if (!request_region(port, 256, "inia100")) {
 		printk(KERN_WARNING "inia100: io port 0x%x, is busy.\n", 
-		       pHCB->HCS_Base);
+		       port);
 		goto out_disable_device; /* XXX: undo init_orchid() ?? */
 	}
 

--
~Randy

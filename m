From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] fusion/mptscsih init/exit sections
Date: Tue, 9 Mar 2004 22:01:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309220145.6a778804.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:42385 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262266AbUCJGML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 01:12:11 -0500
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


V: linux-264-rc2
D: mptscsih_remove() can be called during init, for error handling;

diffstat:=
 drivers/message/fusion/mptscsih.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff -Naurp ./drivers/message/fusion/mptscsih.c~mptscsi_init ./drivers/message/fusion/mptscsih.c
--- ./drivers/message/fusion/mptscsih.c~mptscsi_init	2004-03-06 20:57:05.000000000 -0800
+++ ./drivers/message/fusion/mptscsih.c	2004-03-07 16:16:54.000000000 -0800
@@ -201,7 +201,7 @@ static int  __init   mptscsih_init  (voi
 static void __exit   mptscsih_exit  (void);
 
 static int  __devinit mptscsih_probe (struct pci_dev *, const struct pci_device_id *);
-static void __devexit mptscsih_remove(struct pci_dev *);
+static void mptscsih_remove(struct pci_dev *);
 static void mptscsih_shutdown(struct device *);
 #ifdef CONFIG_PM
 static int mptscsih_suspend(struct pci_dev *pdev, u32 state);
@@ -1718,7 +1718,7 @@ mptscsih_probe_failed:
  *
  *
  */
-static void __devexit
+static void
 mptscsih_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
@@ -1920,7 +1920,7 @@ mptscsih_resume(struct pci_dev *pdev)
 
 static struct mpt_pci_driver mptscsih_driver = {
 	.probe		= mptscsih_probe,
-	.remove		= __devexit_p(mptscsih_remove),
+	.remove		= mptscsih_remove,
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,


--
~Randy

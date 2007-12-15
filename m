From: Mikael Pettersson <mikpe@it.uu.se>
Subject: [PATCH 2.6.24-rc5] sym53c8xx_2 modpost section mismatch fix
Date: Sat, 15 Dec 2007 15:30:02 +0100
Message-ID: <18275.58602.394537.911087@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762724AbXLOOaX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building 2.6.24-rc5 with

# CONFIG_HOTPLUG is not set
CONFIG_SCSI_SYM53C8XX_2=y

results in

WARNING: vmlinux.o(.text+0x14b36c): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_set_cam_result_error')

because sym2_io_error_detected() calls sym2_remove(), which is marked __devexit.

Fixed by removing the __devexit from sym2_remove().

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

--- linux-2.6.24-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c.~1~	2007-12-15 15:37:04.000000000 +0100
+++ linux-2.6.24-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-15 16:22:08.000000000 +0100
@@ -1744,7 +1744,7 @@ static int __devinit sym2_probe(struct p
 	return -ENODEV;
 }
 
-static void __devexit sym2_remove(struct pci_dev *pdev)
+static void sym2_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
@@ -2056,7 +2056,7 @@ static struct pci_driver sym2_driver = {
 	.name		= NAME53C8XX,
 	.id_table	= sym2_id_table,
 	.probe		= sym2_probe,
-	.remove		= __devexit_p(sym2_remove),
+	.remove		= sym2_remove,
 	.err_handler 	= &sym2_err_handler,
 };
 

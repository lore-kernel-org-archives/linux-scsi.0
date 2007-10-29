From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] sym2: fix section mismatch warning
Date: Mon, 29 Oct 2007 11:20:40 -0700
Message-ID: <20071029112040.28955cc0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:26923 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759823AbXJ2SWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 14:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: matthew@wil.cx, jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.text+0x1ff3a2): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_xpt_done')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2624-rc1g4-v1.orig/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ linux-2624-rc1g4-v1/drivers/scsi/sym53c8xx_2/sym_glue.c
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
 

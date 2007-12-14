From: akpm@linux-foundation.org
Subject: [patch 15/30] sym2: fix section mismatch warning
Date: Thu, 13 Dec 2007 16:14:17 -0800
Message-ID: <200712140014.lBE0EHWd026213@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762950AbXLNAQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:16:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, willy@debian.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.text+0x1ff3a2): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_xpt_done')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-fix-section-mismatch-warning drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~sym2-fix-section-mismatch-warning
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
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
 
_

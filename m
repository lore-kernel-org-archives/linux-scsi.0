From: akpm@linux-foundation.org
Subject: [patch 12/17] advansys printk fix
Date: Tue, 02 Oct 2007 14:38:09 -0700
Message-ID: <200710022138.l92Lc9Zp023591@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbXJBViM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

Fix this:

drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:16320: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'

and clean the code up a little.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/advansys.c~advansys-printk-fix drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~advansys-printk-fix
+++ a/drivers/scsi/advansys.c
@@ -14254,10 +14254,11 @@ advansys_board_found(int iop, struct dev
 		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
 					       boardp->asc_n_io_port);
 		if (!boardp->ioremap_addr) {
-			ASC_PRINT3
-			    ("advansys_board_found: board %d: ioremap(%x, %d) returned NULL\n",
-			     boardp->id, pci_resource_start(pdev, 1),
-			     boardp->asc_n_io_port);
+			ASC_PRINT3("advansys_board_found: board %d: "
+				"ioremap(%llx, %d) returned NULL\n",
+				boardp->id,
+				(unsigned long long)pci_resource_start(pdev, 1),
+				boardp->asc_n_io_port);
 			goto err_shost;
 		}
 		adv_dvc_varp->iop_base = (AdvPortAddr)boardp->ioremap_addr
_

From: akpm@linux-foundation.org
Subject: [patch 3/7] qla2xxx printk fixes
Date: Tue, 16 Oct 2007 14:28:20 -0700
Message-ID: <200710162128.l9GLSLBv018170@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965331AbXJPV2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 17:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/qla2xxx/qla_sup.c: In function 'qla24xx_write_flash_data':
drivers/scsi/qla2xxx/qla_sup.c:655: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'
drivers/scsi/qla2xxx/qla_sup.c: In function 'qla25xx_read_optrom_data':
drivers/scsi/qla2xxx/qla_sup.c:1853: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'dma_addr_t'

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_sup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_sup.c~qla2xxx-printk-fixes drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c~qla2xxx-printk-fixes
+++ a/drivers/scsi/qla2xxx/qla_sup.c
@@ -656,7 +656,7 @@ qla24xx_write_flash_data(scsi_qla_host_t
 				    "Unable to burst-write optrom segment "
 				    "(%x/%x/%llx).\n", ret,
 				    flash_data_to_access_addr(faddr),
-				    optrom_dma);
+				    (unsigned long long)optrom_dma);
 				qla_printk(KERN_WARNING, ha,
 				    "Reverting to slow-write.\n");
 
@@ -1853,7 +1853,8 @@ qla25xx_read_optrom_data(struct scsi_qla
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to burst-read optrom segment "
 			    "(%x/%x/%llx).\n", rval,
-			    flash_data_to_access_addr(faddr), optrom_dma);
+			    flash_data_to_access_addr(faddr),
+			    (unsigned long long)optrom_dma);
 			qla_printk(KERN_WARNING, ha,
 			    "Reverting to slow-read.\n");
 
_

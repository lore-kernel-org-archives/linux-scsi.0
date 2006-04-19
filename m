From: akpm@osdl.org
Subject: [patch 15/17] qla2xxx: only free_irq() after request_irq() succeeds
Date: Tue, 18 Apr 2006 21:09:22 -0700
Message-ID: <200604190410.k3J4A47j008254@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38605 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750781AbWDSEKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:10:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, zach.brown@oracle.com, andrew.vasquez@qlogic.com


From: Zach Brown <zach.brown@oracle.com>

If qla2x00_probe_one() fails before calling request_irq() but gets to
qla2x00_free_device() then it will mistakenly try to free an irq it didn't
request.  It's chosing to free based on ha->pdev->irq which is always set.

host->irq is set after request_irq() succeeds so let's use that to decide
to free or not.

This was observed and tested when a silly set of circumstances lead to
firmware loading failing on a 2100.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~qla2xxx-only-free_irq-after-request_irq-succeeds drivers/scsi/qla2xxx/qla_os.c
--- 25/drivers/scsi/qla2xxx/qla_os.c~qla2xxx-only-free_irq-after-request_irq-succeeds	Tue Apr 11 14:12:45 2006
+++ 25-akpm/drivers/scsi/qla2xxx/qla_os.c	Tue Apr 11 14:12:45 2006
@@ -1700,8 +1700,8 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	ha->flags.online = 0;
 
 	/* Detach interrupts */
-	if (ha->pdev->irq)
-		free_irq(ha->pdev->irq, ha);
+	if (ha->host->irq)
+		free_irq(ha->host->irq, ha);
 
 	/* release io space registers  */
 	if (ha->iobase)
_

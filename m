From: akpm@linux-foundation.org
Subject: [patch 11/23] ips: handle scsi_add_host() failure, and other err cleanups
Date: Wed, 21 Nov 2007 15:12:23 -0800
Message-ID: <200711212312.lALNCNYm014136@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817AbXKUXRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:17:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, mark_salyzyn@adaptec.com

From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ips.c~ips-handle-scsi_add_host-failure-and-other-err-cleanups drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-handle-scsi_add_host-failure-and-other-err-cleanups
+++ a/drivers/scsi/ips.c
@@ -6837,13 +6837,10 @@ ips_register_scsi(int index)
 	if (request_irq(ha->pcidev->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_out_sh;
 	}
 
 	kfree(oldha);
-	ips_sh[index] = sh;
-	ips_ha[index] = ha;
 
 	/* Store away needed values for later use */
 	sh->unique_id = (ha->io_addr) ? ha->io_addr : ha->mem_addr;
@@ -6859,10 +6856,21 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	if (scsi_add_host(sh, &ha->pcidev->dev))
+		goto err_out;
+
+	ips_sh[index] = sh;
+	ips_ha[index] = ha;
+
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_out:
+	free_irq(ha->pcidev->irq, ha);
+err_out_sh:
+	scsi_host_put(sh);
+	return -1;
 }
 
 /*---------------------------------------------------------------------------*/
_

From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] libsas: remove spurious sata control register read/write
Date: Sun, 23 Jan 2011 08:34:25 -0600
Message-ID: <1295793265.3007.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1AWOe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:34:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 5BB6E86391
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 15:34:28 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Originally, libata required the illusion that it could access the sata
control register.  Now, however, it can run perfectly well without
them, so remove the dummy routines from libsas which tried to emulate
them (but only ended up causing confusion).

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 571603d..17ff3ac 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -301,55 +301,6 @@ static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 	}
 }
 
-static int sas_ata_scr_write(struct ata_link *link, unsigned int sc_reg_in,
-			      u32 val)
-{
-	struct domain_device *dev = link->ap->private_data;
-
-	SAS_DPRINTK("STUB %s\n", __func__);
-	switch (sc_reg_in) {
-		case SCR_STATUS:
-			dev->sata_dev.sstatus = val;
-			break;
-		case SCR_CONTROL:
-			dev->sata_dev.scontrol = val;
-			break;
-		case SCR_ERROR:
-			dev->sata_dev.serror = val;
-			break;
-		case SCR_ACTIVE:
-			dev->sata_dev.ap->link.sactive = val;
-			break;
-		default:
-			return -EINVAL;
-	}
-	return 0;
-}
-
-static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
-			    u32 *val)
-{
-	struct domain_device *dev = link->ap->private_data;
-
-	SAS_DPRINTK("STUB %s\n", __func__);
-	switch (sc_reg_in) {
-		case SCR_STATUS:
-			*val = dev->sata_dev.sstatus;
-			return 0;
-		case SCR_CONTROL:
-			*val = dev->sata_dev.scontrol;
-			return 0;
-		case SCR_ERROR:
-			*val = dev->sata_dev.serror;
-			return 0;
-		case SCR_ACTIVE:
-			*val = dev->sata_dev.ap->link.sactive;
-			return 0;
-		default:
-			return -EINVAL;
-	}
-}
-
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
@@ -359,8 +310,6 @@ static struct ata_port_operations sas_sata_ops = {
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
 	.port_start		= ata_sas_port_start,
 	.port_stop		= ata_sas_port_stop,
-	.scr_read		= sas_ata_scr_read,
-	.scr_write		= sas_ata_scr_write
 };
 
 static struct ata_port_info sata_port_info = {



From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH: dc395x] "fix" virt_addr calculation on AUTO_REQSENSE
Date: Fri, 20 Jan 2006 01:05:00 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0601200056360.8099@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:47336 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1422695AbWATAEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 19:04:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi

The patch below "fixes" calculation of the virt_addr for the AUTO_REQSENSE 
case. I put "fixes" in quotes because the real fix would be to completely 
remove it, but that's beyond the scope of this patch.

Please consider for inclusion.

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2006-01-20 00:49:55.000000000 +0100
+++ b/drivers/scsi/dc395x.c	2006-01-20 00:50:15.000000000 +0100
@@ -246,6 +246,7 @@
 	 * total_xfer_length in xferred. These values are restored in
 	 * pci_unmap_srb_sense. This is the only place xferred is used.
 	 */
+	unsigned char *virt_addr_req;	/* Saved virtual address of the request buffer */
 	u32 xferred;		        /* Saved copy of total_xfer_length */
 
 	u16 state;
@@ -2017,7 +2018,7 @@
 	sg_verify_length(srb);
 
 	/* we need the corresponding virtual address */
-	if (!segment) {
+	if (!segment || (srb->flag & AUTO_REQSENSE)) {
 		srb->virt_addr += xferred;
 		return;
 	}
@@ -3318,6 +3319,7 @@
 	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address;
 	srb->segment_x[0].length =
 	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].length;
+	srb->virt_addr = srb->virt_addr_req;
 }
 
 
@@ -3711,6 +3713,8 @@
 	srb->xferred = srb->total_xfer_length;
 	/* srb->segment_x : a one entry of S/G list table */
 	srb->total_xfer_length = sizeof(cmd->sense_buffer);
+	srb->virt_addr_req = srb->virt_addr;
+	srb->virt_addr = cmd->sense_buffer;
 	srb->segment_x[0].length = sizeof(cmd->sense_buffer);
 	/* Map sense buffer */
 	srb->segment_x[0].address =

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 3] sd: Correctly handle all combinations of DIF and DIX
Date: Fri, 19 Sep 2008 18:47:21 -0400
Message-ID: <e27c7137f44f2e5ca6c8.1221864441@sermon.lab.mkp.net>
References: <patchbomb.1221864438@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:48237 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbYISW6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 18:58:55 -0400
In-Reply-To: <patchbomb.1221864438@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The old detection code couldn't handle all possible combinations of
DIX and DIF.  This version does, giving priority to DIX if the
controller is capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
3 files changed, 23 insertions(+), 19 deletions(-)
drivers/scsi/sd.c     |    3 ++-
drivers/scsi/sd.h     |    2 +-
drivers/scsi/sd_dif.c |   37 ++++++++++++++++++++-----------------



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -569,7 +569,8 @@ static int sd_prep_fn(struct request_que
 
 	/* If DIF or DIX is enabled, tell HBA how to handle request */
 	if (host_dif || scsi_prot_sg_count(SCpnt))
-		sd_dif_op(SCpnt, sdkp->protection_type, scsi_prot_sg_count(SCpnt));
+		sd_dif_op(SCpnt, host_dif, scsi_prot_sg_count(SCpnt),
+			  sdkp->protection_type);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -99,7 +99,7 @@ struct sd_dif_tuple {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int);
+extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int, unsigned int);
 extern void sd_dif_config_host(struct scsi_disk *);
 extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -311,24 +311,26 @@ void sd_dif_config_host(struct scsi_disk
 	struct scsi_device *sdp = sdkp->device;
 	struct gendisk *disk = sdkp->disk;
 	u8 type = sdkp->protection_type;
+	int dif, dix;
 
-	/* If this HBA doesn't support DIX, resort to normal I/O or DIF */
-	if (scsi_host_dix_capable(sdp->host, type) == 0) {
+	dif = scsi_host_dif_capable(sdp->host, type);
+	dix = scsi_host_dix_capable(sdp->host, type);
 
-		if (type == SD_DIF_TYPE0_PROTECTION)
-			return;
+	if (!dix && scsi_host_dix_capable(sdp->host, 0)) {
+		dif = 0; dix = 1;
+	}
 
-		if (scsi_host_dif_capable(sdp->host, type) == 0) {
-			sd_printk(KERN_INFO, sdkp, "Type %d protection " \
-				  "unsupported by HBA. Disabling DIF.\n", type);
-			return;
-		}
+	if (type) {
+		if (dif)
+			sd_printk(KERN_INFO, sdkp,
+				  "Enabling DIF Type %d protection\n", type);
+		else
+			sd_printk(KERN_INFO, sdkp,
+				  "Disabling DIF Type %d protection\n", type);
+	}
 
-		sd_printk(KERN_INFO, sdkp, "Enabling DIF Type %d protection\n",
-			  type);
-
+	if (!dix)
 		return;
-	}
 
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
@@ -343,10 +345,10 @@ void sd_dif_config_host(struct scsi_disk
 			blk_integrity_register(disk, &dif_type1_integrity_crc);
 
 	sd_printk(KERN_INFO, sdkp,
-		  "Enabling %s integrity protection\n", disk->integrity->name);
+		  "Enabling DIX %s protection\n", disk->integrity->name);
 
 	/* Signal to block layer that we support sector tagging */
-	if (type && sdkp->ATO) {
+	if (dif && type && sdkp->ATO) {
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
 		else
@@ -360,7 +362,7 @@ void sd_dif_config_host(struct scsi_disk
 /*
  * DIF DMA operation magic decoder ring.
  */
-void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix)
+void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsigned int type)
 {
 	int csum_convert, prot_op;
 
@@ -405,7 +407,8 @@ void sd_dif_op(struct scsi_cmnd *scmd, u
 	}
 
 	scsi_set_prot_op(scmd, prot_op);
-	scsi_set_prot_type(scmd, dif);
+	if (dif)
+		scsi_set_prot_type(scmd, type);
 }
 
 /*



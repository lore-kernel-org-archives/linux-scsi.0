From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/5] sd: Detach DIF from block integrity infrastructure
Date: Fri, 11 Sep 2009 15:20:49 -0400
Message-ID: <1252696852-17091-3-git-send-email-martin.petersen@oracle.com>
References: <1252696852-17091-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:20655 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbZIKTU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 15:20:59 -0400
In-Reply-To: <1252696852-17091-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

So far we have only issued DIF commands if CONFIG_BLK_DEV_INTEGRITY is
enabled.  However, communication between initiator and target should be
independent of protection information DMA.  There are DIF-only host
adapters coming out that will be able to take advantage of this.

Move the relevant DIF bits to sd.c.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c        |   61 +++++++++++++++++++++++++++++++--------------
 drivers/scsi/sd.h        |    4 ---
 drivers/scsi/sd_dif.c    |   53 ----------------------------------------
 include/scsi/scsi_host.h |   15 ++++++++---
 4 files changed, 53 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b7b9fec..36e2333 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -370,6 +370,31 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
+{
+	unsigned int prot_op = SCSI_PROT_NORMAL;
+	unsigned int dix = scsi_prot_sg_count(scmd);
+
+	if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
+		if (dif && dix)
+			prot_op = SCSI_PROT_READ_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_READ_STRIP;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_READ_INSERT;
+	} else {
+		if (dif && dix)
+			prot_op = SCSI_PROT_WRITE_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_WRITE_INSERT;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_WRITE_STRIP;
+	}
+
+	scsi_set_prot_op(scmd, prot_op);
+	scsi_set_prot_type(scmd, dif);
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -578,8 +603,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 
 	/* If DIF or DIX is enabled, tell HBA how to handle request */
 	if (host_dif || scsi_prot_sg_count(SCpnt))
-		sd_dif_op(SCpnt, host_dif, scsi_prot_sg_count(SCpnt),
-			  sdkp->protection_type);
+		sd_prot_op(SCpnt, host_dif);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -1238,34 +1262,33 @@ void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	u8 type;
 
 	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
-		type = 0;
-	else
-		type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
+		return;
+
+	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
+
+	if (type == sdkp->protection_type || !sdkp->first_scan)
+		return;
 
 	sdkp->protection_type = type;
 
 	switch (type) {
-	case SD_DIF_TYPE0_PROTECTION:
 	case SD_DIF_TYPE1_PROTECTION:
 	case SD_DIF_TYPE3_PROTECTION:
 		break;
 
-	case SD_DIF_TYPE2_PROTECTION:
-		sd_printk(KERN_ERR, sdkp, "formatted with DIF Type 2 "	\
-			  "protection which is currently unsupported. "	\
-			  "Disabling disk!\n");
-		goto disable;
-
 	default:
-		sd_printk(KERN_ERR, sdkp, "formatted with unknown "	\
-			  "protection type %d. Disabling disk!\n", type);
-		goto disable;
+		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
+			  "protection type %u. Disabling disk!\n", type);
+		sdkp->capacity = 0;
+		return;
 	}
 
-	return;
-
-disable:
-	sdkp->capacity = 0;
+	if (scsi_host_dif_capable(sdp->host, type))
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Enabling DIF Type %u protection\n", type);
+	else
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Disabling DIF Type %u protection\n", type);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 8474b5b..ce1f5f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -101,16 +101,12 @@ struct sd_dif_tuple {
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int, unsigned int);
 extern void sd_dif_config_host(struct scsi_disk *);
 extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-static inline void sd_dif_op(struct scsi_cmnd *cmd, unsigned int a, unsigned int b, unsigned int c)
-{
-}
 static inline void sd_dif_config_host(struct scsi_disk *disk)
 {
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 84224dd..88da977 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -320,15 +320,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		dif = 0; dix = 1;
 	}
 
-	if (type) {
-		if (dif)
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Enabling DIF Type %d protection\n", type);
-		else
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Disabling DIF Type %d protection\n", type);
-	}
-
 	if (!dix)
 		return;
 
@@ -360,50 +351,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 }
 
 /*
- * DIF DMA operation magic decoder ring.
- */
-void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsigned int type)
-{
-	int prot_op;
-
-	prot_op = SCSI_PROT_NORMAL;
-
-	BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] == WRITE_6));
-
-	switch (scmd->cmnd[0]) {
-	case READ_6:
-	case READ_10:
-	case READ_12:
-	case READ_16:
-		if (dif && dix)
-			prot_op = SCSI_PROT_READ_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_READ_STRIP;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_READ_INSERT;
-
-		break;
-
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_12:
-	case WRITE_16:
-		if (dif && dix)
-			prot_op = SCSI_PROT_WRITE_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_WRITE_INSERT;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_WRITE_STRIP;
-
-		break;
-	}
-
-	scsi_set_prot_op(scmd, prot_op);
-	if (dif)
-		scsi_set_prot_type(scmd, type);
-}
-
-/*
  * The virtual start sector is the one that was originally submitted
  * by the block layer.	Due to partitioning, MD/DM cloning, etc. the
  * actual physical start sector is likely to be different.  Remap
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..6e728b1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -798,9 +798,15 @@ static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
 static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
 	switch (target_type) {
-	case 1: return shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION;
-	case 2: return shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION;
-	case 3: return shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION;
+	case 1:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION)
+			return target_type;
+	case 2:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION)
+			return target_type;
+	case 3:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION)
+			return target_type;
 	}
 
 	return 0;
@@ -808,13 +814,14 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
 
 static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
 	switch (target_type) {
 	case 0: return shost->prot_capabilities & SHOST_DIX_TYPE0_PROTECTION;
 	case 1: return shost->prot_capabilities & SHOST_DIX_TYPE1_PROTECTION;
 	case 2: return shost->prot_capabilities & SHOST_DIX_TYPE2_PROTECTION;
 	case 3: return shost->prot_capabilities & SHOST_DIX_TYPE3_PROTECTION;
 	}
-
+#endif
 	return 0;
 }
 
-- 
1.6.0.6


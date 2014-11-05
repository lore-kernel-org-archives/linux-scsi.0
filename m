From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] libata: Implement ATA_DEV_ZAC
Date: Wed,  5 Nov 2014 13:08:21 +0100
Message-ID: <1415189302-108476-3-git-send-email-hare@suse.de>
References: <1415189302-108476-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1415189302-108476-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add new ATA device type for ZAC devices.

Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c      | 20 ++++++++++++++------
 drivers/ata/libata-eh.c        |  7 +++++--
 drivers/ata/libata-scsi.c      |  5 +++--
 drivers/ata/libata-transport.c |  1 +
 include/linux/libata.h         |  6 ++++--
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c5ba15a..5c84fb5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1043,8 +1043,8 @@ const char *sata_spd_string(unsigned int spd)
  *	None.
  *
  *	RETURNS:
- *	Device type, %ATA_DEV_ATA, %ATA_DEV_ATAPI, %ATA_DEV_PMP or
- *	%ATA_DEV_UNKNOWN the event of failure.
+ *	Device type, %ATA_DEV_ATA, %ATA_DEV_ATAPI, %ATA_DEV_PMP,
+ *	%ATA_DEV_ZAC, or %ATA_DEV_UNKNOWN the event of failure.
  */
 unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 {
@@ -1089,6 +1089,11 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 		return ATA_DEV_SEMB;
 	}
 
+	if ((tf->lbam == 0xcd) && (tf->lbah == 0xab)) {
+		DPRINTK("found ZAC device by sig\n");
+		return ATA_DEV_ZAC;
+	}
+
 	DPRINTK("unknown device\n");
 	return ATA_DEV_UNKNOWN;
 }
@@ -1329,7 +1334,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 	int rc;
 
 	/* do we need to do it? */
-	if (dev->class != ATA_DEV_ATA ||
+	if ((dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ZAC) ||
 	    !ata_id_has_lba(dev->id) || !ata_id_hpa_enabled(dev->id) ||
 	    (dev->horkage & ATA_HORKAGE_BROKEN_HPA))
 		return 0;
@@ -1889,6 +1894,7 @@ retry:
 	case ATA_DEV_SEMB:
 		class = ATA_DEV_ATA;	/* some hard drives report SEMB sig */
 	case ATA_DEV_ATA:
+	case ATA_DEV_ZAC:
 		tf.command = ATA_CMD_ID_ATA;
 		break;
 	case ATA_DEV_ATAPI:
@@ -1980,7 +1986,7 @@ retry:
 	rc = -EINVAL;
 	reason = "device reports invalid type";
 
-	if (class == ATA_DEV_ATA) {
+	if (class == ATA_DEV_ATA || class == ATA_DEV_ZAC) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
 			goto err_out;
 		if (ap->host->flags & ATA_HOST_IGNORE_ATA &&
@@ -2015,7 +2021,8 @@ retry:
 			goto retry;
 	}
 
-	if ((flags & ATA_READID_POSTRESET) && class == ATA_DEV_ATA) {
+	if ((flags & ATA_READID_POSTRESET) &&
+	    (class == ATA_DEV_ATA || class == ATA_DEV_ZAC)) {
 		/*
 		 * The exact sequence expected by certain pre-ATA4 drives is:
 		 * SRST RESET
@@ -2280,7 +2287,7 @@ int ata_dev_configure(struct ata_device *dev)
 			sizeof(modelbuf));
 
 	/* ATA-specific feature tests */
-	if (dev->class == ATA_DEV_ATA) {
+	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
 		if (ata_id_is_cfa(id)) {
 			/* CPRM may make this media unusable */
 			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
@@ -4033,6 +4040,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	if (ata_class_enabled(new_class) &&
 	    new_class != ATA_DEV_ATA &&
 	    new_class != ATA_DEV_ATAPI &&
+	    new_class != ATA_DEV_ZAC &&
 	    new_class != ATA_DEV_SEMB) {
 		ata_dev_info(dev, "class mismatch %u != %u\n",
 			     dev->class, new_class);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dad83df..3dbec89 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1809,6 +1809,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 
 	switch (qc->dev->class) {
 	case ATA_DEV_ATA:
+	case ATA_DEV_ZAC:
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & (ATA_UNC | ATA_AMNF))
@@ -3792,7 +3793,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				struct ata_eh_context *ehc = &link->eh_context;
 				unsigned long tmp;
 
-				if (dev->class != ATA_DEV_ATA)
+				if (dev->class != ATA_DEV_ATA &&
+				    dev->class != ATA_DEV_ZAC)
 					continue;
 				if (!(ehc->i.dev_action[dev->devno] &
 				      ATA_EH_PARK))
@@ -3873,7 +3875,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 		/* retry flush if necessary */
 		ata_for_each_dev(dev, link, ALL) {
-			if (dev->class != ATA_DEV_ATA)
+			if (dev->class != ATA_DEV_ATA &&
+			    dev->class != ATA_DEV_ZAC)
 				continue;
 			rc = ata_eh_maybe_retry_flush(dev);
 			if (rc)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0586f66..bea6e7f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -235,7 +235,8 @@ static ssize_t ata_scsi_park_store(struct device *device,
 		rc = -ENODEV;
 		goto unlock;
 	}
-	if (dev->class != ATA_DEV_ATA) {
+	if (dev->class != ATA_DEV_ATA &&
+	    dev->class != ATA_DEV_ZAC) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -3412,7 +3413,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 	ata_xlat_func_t xlat_func;
 	int rc = 0;
 
-	if (dev->class == ATA_DEV_ATA) {
+	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
 		if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index e37413228..3227b7c 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -143,6 +143,7 @@ static struct {
 	{ ATA_DEV_PMP_UNSUP,		"pmp" },
 	{ ATA_DEV_SEMB,			"semb" },
 	{ ATA_DEV_SEMB_UNSUP,		"semb" },
+	{ ATA_DEV_ZAC,			"zac" },
 	{ ATA_DEV_NONE,			"none" }
 };
 ata_bitfield_name_search(class, ata_class_names)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bd5fefe..a26daea 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -191,7 +191,8 @@ enum {
 	ATA_DEV_PMP_UNSUP	= 6,	/* SATA port multiplier (unsupported) */
 	ATA_DEV_SEMB		= 7,	/* SEMB */
 	ATA_DEV_SEMB_UNSUP	= 8,	/* SEMB (unsupported) */
-	ATA_DEV_NONE		= 9,	/* no device */
+	ATA_DEV_ZAC		= 9,	/* ZAC device */
+	ATA_DEV_NONE		= 10,	/* no device */
 
 	/* struct ata_link flags */
 	ATA_LFLAG_NO_HRST	= (1 << 1), /* avoid hardreset */
@@ -1491,7 +1492,8 @@ static inline unsigned int ata_tag_internal(unsigned int tag)
 static inline unsigned int ata_class_enabled(unsigned int class)
 {
 	return class == ATA_DEV_ATA || class == ATA_DEV_ATAPI ||
-		class == ATA_DEV_PMP || class == ATA_DEV_SEMB;
+		class == ATA_DEV_PMP || class == ATA_DEV_SEMB ||
+		class == ATA_DEV_ZAC;
 }
 
 static inline unsigned int ata_class_disabled(unsigned int class)
-- 
1.8.5.2


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] libata: Implement ATA_DEV_ZAC
Date: Wed, 30 Jul 2014 09:55:09 +0200
Message-ID: <1406706911-79510-3-git-send-email-hare@suse.de>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaG3HzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 03:55:16 -0400
In-Reply-To: <1406706911-79510-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add new ATA device type for ZAC devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c      | 20 ++++++++++++++------
 drivers/ata/libata-eh.c        |  7 +++++--
 drivers/ata/libata-scsi.c      |  5 +++--
 drivers/ata/libata-transport.c |  1 +
 include/linux/libata.h         |  6 ++++--
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2c4d742..5f23804 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1044,8 +1044,8 @@ const char *sata_spd_string(unsigned int spd)
  *	None.
  *
  *	RETURNS:
- *	Device type, %ATA_DEV_ATA, %ATA_DEV_ATAPI, %ATA_DEV_PMP or
- *	%ATA_DEV_UNKNOWN the event of failure.
+ *	Device type, %ATA_DEV_ATA, %ATA_DEV_ATAPI, %ATA_DEV_PMP,
+ *	%ATA_DEV_ZAC, or %ATA_DEV_UNKNOWN the event of failure.
  */
 unsigned int ata_dev_classify(u8 lbah, u8 lbam, u8 lbal)
 {
@@ -1090,6 +1090,11 @@ unsigned int ata_dev_classify(u8 lbah, u8 lbam, u8 lbal)
 		return ATA_DEV_SEMB;
 	}
 
+	if ((lbam == 0xcd) && (lbah == 0xab)) {
+		DPRINTK("found ZAC device by sig\n");
+		return ATA_DEV_ZAC;
+	}
+
 	DPRINTK("unknown device\n");
 	return ATA_DEV_UNKNOWN;
 }
@@ -1330,7 +1335,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 	int rc;
 
 	/* do we need to do it? */
-	if (dev->class != ATA_DEV_ATA ||
+	if ((dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ZAC) ||
 	    !ata_id_has_lba(dev->id) || !ata_id_hpa_enabled(dev->id) ||
 	    (dev->horkage & ATA_HORKAGE_BROKEN_HPA))
 		return 0;
@@ -1890,6 +1895,7 @@ retry:
 	case ATA_DEV_SEMB:
 		class = ATA_DEV_ATA;	/* some hard drives report SEMB sig */
 	case ATA_DEV_ATA:
+	case ATA_DEV_ZAC:
 		tf.command = ATA_CMD_ID_ATA;
 		break;
 	case ATA_DEV_ATAPI:
@@ -1981,7 +1987,7 @@ retry:
 	rc = -EINVAL;
 	reason = "device reports invalid type";
 
-	if (class == ATA_DEV_ATA) {
+	if (class == ATA_DEV_ATA || class == ATA_DEV_ZAC) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
 			goto err_out;
 		if (ap->host->flags & ATA_HOST_IGNORE_ATA &&
@@ -2016,7 +2022,8 @@ retry:
 			goto retry;
 	}
 
-	if ((flags & ATA_READID_POSTRESET) && class == ATA_DEV_ATA) {
+	if ((flags & ATA_READID_POSTRESET) &&
+	    (class == ATA_DEV_ATA || class == ATA_DEV_ZAC)) {
 		/*
 		 * The exact sequence expected by certain pre-ATA4 drives is:
 		 * SRST RESET
@@ -2281,7 +2288,7 @@ int ata_dev_configure(struct ata_device *dev)
 			sizeof(modelbuf));
 
 	/* ATA-specific feature tests */
-	if (dev->class == ATA_DEV_ATA) {
+	if (dev->class == ATA_DEV_ATA || dev->class == ATA_DEV_ZAC) {
 		if (ata_id_is_cfa(id)) {
 			/* CPRM may make this media unusable */
 			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
@@ -4034,6 +4041,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	if (ata_class_enabled(new_class) &&
 	    new_class != ATA_DEV_ATA &&
 	    new_class != ATA_DEV_ATAPI &&
+	    new_class != ATA_DEV_ZAC &&
 	    new_class != ATA_DEV_SEMB) {
 		ata_dev_info(dev, "class mismatch %u != %u\n",
 			     dev->class, new_class);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6760fc4..f620c4a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1809,6 +1809,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 
 	switch (qc->dev->class) {
 	case ATA_DEV_ATA:
+	case ATA_DEV_ZAC:
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & ATA_UNC)
@@ -3791,7 +3792,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				struct ata_eh_context *ehc = &link->eh_context;
 				unsigned long tmp;
 
-				if (dev->class != ATA_DEV_ATA)
+				if (dev->class != ATA_DEV_ATA &&
+				    dev->class != ATA_DEV_ZAC)
 					continue;
 				if (!(ehc->i.dev_action[dev->devno] &
 				      ATA_EH_PARK))
@@ -3872,7 +3874,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
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
index 3412aee..37f482b 100644
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
@@ -1490,7 +1491,8 @@ static inline unsigned int ata_tag_internal(unsigned int tag)
 static inline unsigned int ata_class_enabled(unsigned int class)
 {
 	return class == ATA_DEV_ATA || class == ATA_DEV_ATAPI ||
-		class == ATA_DEV_PMP || class == ATA_DEV_SEMB;
+		class == ATA_DEV_PMP || class == ATA_DEV_SEMB ||
+		class == ATA_DEV_ZAC;
 }
 
 static inline unsigned int ata_class_disabled(unsigned int class)
-- 
1.7.12.4


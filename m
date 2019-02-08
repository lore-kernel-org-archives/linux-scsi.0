From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc5
Date: Fri, 08 Feb 2019 14:17:59 -0500
Message-ID: <1549653479.3647.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of five minor fixes (although, tecnhincally, the aicxxx
fix is for a major problem in that the driver won't load without it,
but I think the fact it's taken us since 4.10 to discover this
indicates that the user base for these things has declined).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (1):
      scsi: sd_zbc: Fix zone information messages

David Disseldorp (1):
      scsi: target: make the pi_prot_format ConfigFS path readable

James Bottomley (1):
      scsi: aic94xx: fix module loading

Ross Lagerwall (1):
      Revert "scsi: libfc: Add WARN_ON() when deleting rports"

Vaibhav Jain (1):
      scsi: cxlflash: Prevent deadlock when adapter probe fails

And the diffstat:

 drivers/scsi/aic94xx/aic94xx_init.c   |  8 ++++----
 drivers/scsi/cxlflash/main.c          |  2 ++
 drivers/scsi/libfc/fc_rport.c         |  1 -
 drivers/scsi/sd_zbc.c                 | 12 ++++++++----
 drivers/target/target_core_configfs.c |  8 +++++++-
 5 files changed, 21 insertions(+), 10 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f83f79b07b50..07efcb9b5b94 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -280,7 +280,7 @@ static ssize_t asd_show_dev_rev(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%s\n",
 			asd_dev_rev[asd_ha->revision_id]);
 }
-static DEVICE_ATTR(revision, S_IRUGO, asd_show_dev_rev, NULL);
+static DEVICE_ATTR(aic_revision, S_IRUGO, asd_show_dev_rev, NULL);
 
 static ssize_t asd_show_dev_bios_build(struct device *dev,
 				       struct device_attribute *attr,char *buf)
@@ -477,7 +477,7 @@ static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
 {
 	int err;
 
-	err = device_create_file(&asd_ha->pcidev->dev, &dev_attr_revision);
+	err = device_create_file(&asd_ha->pcidev->dev, &dev_attr_aic_revision);
 	if (err)
 		return err;
 
@@ -499,13 +499,13 @@ static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
 err_biosb:
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_bios_build);
 err_rev:
-	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_revision);
+	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_aic_revision);
 	return err;
 }
 
 static void asd_remove_dev_attrs(struct asd_ha_struct *asd_ha)
 {
-	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_revision);
+	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_aic_revision);
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_bios_build);
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_pcba_sn);
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_update_bios);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index bfa13e3b191c..c8bad2c093b8 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3687,6 +3687,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	host->max_cmd_len = CXLFLASH_MAX_CDB_LEN;
 
 	cfg = shost_priv(host);
+	cfg->state = STATE_PROBING;
 	cfg->host = host;
 	rc = alloc_mem(cfg);
 	if (rc) {
@@ -3775,6 +3776,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	return rc;
 
 out_remove:
+	cfg->state = STATE_PROBED;
 	cxlflash_remove(pdev);
 	goto out;
 }
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 9192a1d9dec6..dfba4921b265 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -184,7 +184,6 @@ void fc_rport_destroy(struct kref *kref)
 	struct fc_rport_priv *rdata;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
-	WARN_ON(!list_empty(&rdata->peers));
 	kfree_rcu(rdata, rcu);
 }
 EXPORT_SYMBOL(fc_rport_destroy);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 83365b29a4d8..fff86940388b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -462,12 +462,16 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	sdkp->device->use_10_for_rw = 0;
 
 	/*
-	 * If something changed, revalidate the disk zone bitmaps once we have
-	 * the capacity, that is on the second revalidate execution during disk
-	 * scan and always during normal revalidate.
+	 * Revalidate the disk zone bitmaps once the block device capacity is
+	 * set on the second revalidate execution during disk scan and if
+	 * something changed when executing a normal revalidate.
 	 */
-	if (sdkp->first_scan)
+	if (sdkp->first_scan) {
+		sdkp->zone_blocks = zone_blocks;
+		sdkp->nr_zones = nr_zones;
 		return 0;
+	}
+
 	if (sdkp->zone_blocks != zone_blocks ||
 	    sdkp->nr_zones != nr_zones ||
 	    disk->queue->nr_zones != nr_zones) {
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 72016d0dfca5..8e7fffbb8802 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -852,6 +852,12 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 	return count;
 }
 
+/* always zero, but attr needs to remain RW to avoid userspace breakage */
+static ssize_t pi_prot_format_show(struct config_item *item, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "0\n");
+}
+
 static ssize_t pi_prot_format_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -1132,7 +1138,7 @@ CONFIGFS_ATTR(, emulate_3pc);
 CONFIGFS_ATTR(, emulate_pr);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
-CONFIGFS_ATTR_WO(, pi_prot_format);
+CONFIGFS_ATTR(, pi_prot_format);
 CONFIGFS_ATTR(, pi_prot_verify);
 CONFIGFS_ATTR(, enforce_pr_isids);
 CONFIGFS_ATTR(, is_nonrot);

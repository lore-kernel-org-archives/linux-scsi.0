From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Add 'tpgs' sysfs attribute for SCSI devices
Date: Wed, 18 Mar 2009 13:02:05 +0100
Message-ID: <20090318120206.0BB1418C79D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:34352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZCRMDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 08:03:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@us.ibm.com, linux-scsi@vger.kernel.org


We need to export the 'TGPS' setting of the
inquiry data to properly support ALUA.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |    1 +
 drivers/scsi/scsi_sysfs.c  |    2 ++
 include/scsi/scsi_device.h |    3 ++-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a14d245..d1619ed 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -836,6 +836,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
+	sdev->tpgs = (inq_result[5] >> 4) & 3;
 
 	if (sdev->scsi_level >= SCSI_3 ||
 			(sdev->inquiry_len > 56 && inq_result[56] & 0x04))
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fa4711d..7513ce5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -560,6 +560,7 @@ sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr (tpgs, "%d\n");
 
 /*
  * TODO: can we make these symlinks to the block layer ones?
@@ -745,6 +746,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_vendor.attr,
 	&dev_attr_model.attr,
 	&dev_attr_rev.attr,
+	&dev_attr_tpgs.attr,
 	&dev_attr_rescan.attr,
 	&dev_attr_delete.attr,
 	&dev_attr_state.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3f566af..22aaf72 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -96,7 +96,8 @@ struct scsi_device {
 	void *hostdata;		/* available to low-level driver */
 	char type;
 	char scsi_level;
-	char inq_periph_qual;	/* PQ from INQUIRY data */	
+	char inq_periph_qual;	/* PQ from INQUIRY data */
+	char tpgs;		/* Target port group support */
 	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
 	unsigned char * inquiry;	/* INQUIRY response data */
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
-- 
1.5.3.2


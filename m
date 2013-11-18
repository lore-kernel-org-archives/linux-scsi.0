From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: Add "missing" sysfs attribute to scsi_device structure
Date: Mon, 18 Nov 2013 12:10:56 -0500
Message-ID: <1384794656-9449-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3KRRK6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 12:10:58 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAIHAvPs004254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2013 12:10:58 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id rAIHAvUQ020318
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2013 12:10:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This change adds a "missing" sysfs attribute to scsi_device
which is set when a previously scanned device no longer appears
in the REPORT LUNS inventory.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_scan.c   | 30 +++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  |  2 ++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2e5fe58..7908c06 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1317,9 +1317,11 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	struct scsi_lun *lunp, *lun_data;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *sdev_i;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
+	unsigned long flags;
+	bool found;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1492,6 +1494,32 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		}
 	}
 
+	/*
+	 * See if all of the LUNs that we know about on the target are
+	 * still being reported in the REPORT LUNS data.  If any are not,
+	 * they have been removed from the target.  Set the "missing" flag.
+	 *
+	 * We only do this for REPORT LUNS scanning, because we do not
+	 * want to set the flag on LUNs that are inaccessible due to a
+	 * transport error.  Here, the target has responded to a command
+	 * and told us that the LUN is not present.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(sdev_i, &starget->devices, same_target_siblings) {
+		found = 0;
+		for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
+			lun = scsilun_to_int(lunp);
+			if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4))
+				continue;
+			else if (lun == sdev_i->lun) {
+				found = 1;
+				break;
+			}
+		}
+		sdev_i->missing = !found;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
  out_err:
 	kfree(lun_data);
  out:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..01635cc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -536,6 +536,7 @@ sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr(missing, "%d\n");
 
 /*
  * TODO: can we make these symlinks to the block layer ones?
@@ -721,6 +722,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_vendor.attr,
 	&dev_attr_model.attr,
 	&dev_attr_rev.attr,
+	&dev_attr_missing.attr,
 	&dev_attr_rescan.attr,
 	&dev_attr_delete.attr,
 	&dev_attr_state.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..79775f1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -152,6 +152,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned missing:1;	/* No longer appears in REPORT LUNS data */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.7


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] hpsa: add 'ctlr_num' sysfs attribute
Date: Fri, 18 Nov 2016 08:32:49 +0100
Message-ID: <1479454369-100281-4-git-send-email-hare@suse.de>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752247AbcKRHcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 02:32:53 -0500
In-Reply-To: <1479454369-100281-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a sysfs attribute 'ctlr_num' holding the current HPSA controller
number. This is required to construct compability 'cciss' links.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3d89f74..5834117 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -867,6 +867,16 @@ static ssize_t path_info_show(struct device *dev,
 	return output_len;
 }
 
+static ssize_t host_show_ctlr_num(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	return snprintf(buf, 20, "%d\n", h->ctlr);
+}
+
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
@@ -890,6 +900,8 @@ static DEVICE_ATTR(resettable, S_IRUGO,
 	host_show_resettable, NULL);
 static DEVICE_ATTR(lockup_detected, S_IRUGO,
 	host_show_lockup_detected, NULL);
+static DEVICE_ATTR(ctlr_num, S_IRUGO,
+	host_show_ctlr_num, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -910,6 +922,7 @@ static DEVICE_ATTR(lockup_detected, S_IRUGO,
 	&dev_attr_hp_ssd_smart_path_status,
 	&dev_attr_raid_offload_debug,
 	&dev_attr_lockup_detected,
+	&dev_attr_ctlr_num,
 	NULL,
 };
 
-- 
1.8.5.6


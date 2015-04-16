From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 07/43] hpsa: allow lockup detected to be viewed via sysfs
Date: Thu, 16 Apr 2015 08:47:19 -0500
Message-ID: <20150416134719.30238.80651.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:49320 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbbDPNsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:48:20 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

expose a detected lockup via sysfs

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 68238dd..adc0ad3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -351,6 +351,20 @@ static int check_for_busy(struct ctlr_info *h, struct CommandList *c)
 	return 1;
 }
 
+static u32 lockup_detected(struct ctlr_info *h);
+static ssize_t host_show_lockup_detected(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ld;
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	ld = lockup_detected(h);
+
+	return sprintf(buf, "ld=%d\n", ld);
+}
+
 static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
@@ -698,12 +712,15 @@ static DEVICE_ATTR(transport_mode, S_IRUGO,
 	host_show_transport_mode, NULL);
 static DEVICE_ATTR(resettable, S_IRUGO,
 	host_show_resettable, NULL);
+static DEVICE_ATTR(lockup_detected, S_IRUGO,
+	host_show_lockup_detected, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,
 	&dev_attr_hp_ssd_smart_path_enabled,
+	&dev_attr_lockup_detected,
 	NULL,
 };
 


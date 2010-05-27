From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 22/24] hpsa: expose controller firmware revision via /sys.
Date: Thu, 27 May 2010 15:14:34 -0500
Message-ID: <20100527201434.3116.38001.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26449 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:55 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: expose controller firmware revision via /sys.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/scsi/hpsa.txt |    7 +++++++
 drivers/scsi/hpsa.c         |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
index 4055657..dca6583 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.txt
@@ -38,6 +38,7 @@ HPSA specific entries in /sys
   ------------------------------
 
   /sys/class/scsi_host/host*/rescan
+  /sys/class/scsi_host/host*/firmware_revision
 
   the host "rescan" attribute is a write only attribute.  Writing to this
   attribute will cause the driver to scan for new, changed, or removed devices
@@ -48,6 +49,12 @@ HPSA specific entries in /sys
   normally have to use this.  It may be useful when hot plugging devices like
   tape drives, or entire storage boxes containing pre-configured logical drives.
 
+  The "firmware_revision" attribute contains the firmware version of the Smart Array.
+  For example:
+
+	root@host:/sys/class/scsi_host/host4# cat firmware_revision
+	7.14
+
   HPSA specific disk attributes:
   ------------------------------
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6abebef..066dde9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -148,6 +148,8 @@ static ssize_t lunid_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
+static ssize_t host_show_firmware_revision(struct device *dev,
+	     struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
@@ -165,6 +167,8 @@ static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(firmware_revision, S_IRUGO,
+	host_show_firmware_revision, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -175,6 +179,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 
 static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_rescan,
+	&dev_attr_firmware_revision,
 	NULL,
 };
 
@@ -260,6 +265,21 @@ static ssize_t host_store_rescan(struct device *dev,
 	return count;
 }
 
+static ssize_t host_show_firmware_revision(struct device *dev,
+	     struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	unsigned char *fwrev;
+
+	h = shost_to_hba(shost);
+	if (!h->hba_inquiry_data)
+		return 0;
+	fwrev = &h->hba_inquiry_data[32];
+	return snprintf(buf, 20, "%c%c%c%c\n",
+		fwrev[0], fwrev[1], fwrev[2], fwrev[3]);
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {


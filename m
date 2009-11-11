From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/17] hpsa:  Allow device rescan to be triggered via sysfs.
Date: Wed, 11 Nov 2009 10:51:14 -0600
Message-ID: <20091111165114.17754.83467.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758102AbZKKQtx@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Allow device rescan to be triggered via sysfs.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 35267cb..dfef62d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -147,10 +147,13 @@ static ssize_t lunid_show(struct device *dev,
 static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
+static ssize_t host_store_rescan(struct device *dev,
+	 struct device_attribute *attr, const char *buf, size_t count);
 
 DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
+DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -159,6 +162,11 @@ struct device_attribute *hpsa_sdev_attrs[] = {
 	NULL,
 };
 
+static struct device_attribute *hpsa_shost_attrs[] = {
+	&dev_attr_rescan,
+	NULL,
+};
+
 static struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "hpsa",
@@ -177,6 +185,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
+	.shost_attrs = hpsa_shost_attrs,
 };
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
@@ -308,6 +317,21 @@ static int scan_thread(__attribute__((unused)) void *data)
 	return 0;
 }
 
+static ssize_t host_store_rescan(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	unsigned long *priv = shost_priv(shost);
+	h = (struct ctlr_info *) *priv;
+	if (add_to_scan_list(h)) {
+		wake_up_process(hpsa_scan_thread);
+		wait_for_completion_interruptible(&h->scan_wait);
+	}
+	return count;
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {

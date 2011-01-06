From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/11] hpsa: Add a per controller commands_outstanding entry
	in /sys
Date: Thu, 06 Jan 2011 14:48:39 -0600
Message-ID: <20110106204839.10753.15372.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ddd729e..c255f46 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -159,6 +159,8 @@ static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static ssize_t host_show_firmware_revision(struct device *dev,
 	     struct device_attribute *attr, char *buf);
+static ssize_t host_show_commands_outstanding(struct device *dev,
+	     struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
@@ -188,6 +190,8 @@ static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 static DEVICE_ATTR(firmware_revision, S_IRUGO,
 	host_show_firmware_revision, NULL);
+static DEVICE_ATTR(commands_outstanding, S_IRUGO,
+	host_show_commands_outstanding, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -199,6 +203,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_rescan,
 	&dev_attr_firmware_revision,
+	&dev_attr_commands_outstanding,
 	NULL,
 };
 
@@ -299,6 +304,15 @@ static ssize_t host_show_firmware_revision(struct device *dev,
 		fwrev[0], fwrev[1], fwrev[2], fwrev[3]);
 }
 
+static ssize_t host_show_commands_outstanding(struct device *dev,
+	     struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ctlr_info *h = shost_to_hba(shost);
+
+	return snprintf(buf, 20, "%d\n", h->commands_outstanding);
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct hlist_head *list, struct CommandList *c)
 {

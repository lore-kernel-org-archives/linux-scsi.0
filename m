From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/6] hpsa: Add transport_mode host attribute in /sys
Date: Tue, 15 Feb 2011 15:32:58 -0600
Message-ID: <20110215213258.5407.32366.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46970 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1BOVc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 16:32:59 -0500
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/scsi/hpsa.txt |    5 +++++
 drivers/scsi/hpsa.c         |   18 +++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
index dca6583..ed524f1 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.txt
@@ -39,6 +39,7 @@ HPSA specific entries in /sys
 
   /sys/class/scsi_host/host*/rescan
   /sys/class/scsi_host/host*/firmware_revision
+  /sys/class/scsi_host/host*/transport_mode
 
   the host "rescan" attribute is a write only attribute.  Writing to this
   attribute will cause the driver to scan for new, changed, or removed devices
@@ -55,6 +56,10 @@ HPSA specific entries in /sys
 	root@host:/sys/class/scsi_host/host4# cat firmware_revision
 	7.14
 
+  The transport_mode indicates whether the controller is in "performant"
+  or "simple" mode.  This is controlled by the "hpsa_simple_mode" module
+  parameter.
+
   HPSA specific disk attributes:
   ------------------------------
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 66ccacf..563d439 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -161,6 +161,8 @@ static ssize_t host_show_firmware_revision(struct device *dev,
 	     struct device_attribute *attr, char *buf);
 static ssize_t host_show_commands_outstanding(struct device *dev,
 	     struct device_attribute *attr, char *buf);
+static ssize_t host_show_transport_mode(struct device *dev,
+	struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
@@ -192,6 +194,8 @@ static DEVICE_ATTR(firmware_revision, S_IRUGO,
 	host_show_firmware_revision, NULL);
 static DEVICE_ATTR(commands_outstanding, S_IRUGO,
 	host_show_commands_outstanding, NULL);
+static DEVICE_ATTR(transport_mode, S_IRUGO,
+	host_show_transport_mode, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -204,6 +208,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_rescan,
 	&dev_attr_firmware_revision,
 	&dev_attr_commands_outstanding,
+	&dev_attr_transport_mode,
 	NULL,
 };
 
@@ -313,6 +318,18 @@ static ssize_t host_show_commands_outstanding(struct device *dev,
 	return snprintf(buf, 20, "%d\n", h->commands_outstanding);
 }
 
+static ssize_t host_show_transport_mode(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	return snprintf(buf, 20, "%s\n",
+		h->transMethod == CFGTBL_Trans_Performant ?
+			"performant" : "simple");
+}
+
 /* Enqueuing and dequeuing functions for cmdlists. */
 static inline void addQ(struct list_head *list, struct CommandList *c)
 {
@@ -3768,7 +3785,6 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->pdev = pdev;
 	h->busy_initializing = 1;
 	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
-	printk(KERN_WARNING "hpsa_simple_mode is %d\n", hpsa_simple_mode);
 	INIT_LIST_HEAD(&h->cmpQ);
 	INIT_LIST_HEAD(&h->reqQ);
 	spin_lock_init(&h->lock);


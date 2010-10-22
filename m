From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/10] hpsa: Add a per controller commands_outstanding entry
	in /sys
Date: Fri, 22 Oct 2010 14:28:06 -0500
Message-ID: <20101022192806.25694.36428.stgit@beardog.cce.hp.com>
References: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27324 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab0JVT2G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 15:28:06 -0400
In-Reply-To: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cba5bf4..862b0ae 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -167,6 +167,8 @@ static ssize_t unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buf);
 static ssize_t host_show_firmware_revision(struct device *dev,
 	     struct device_attribute *attr, char *buf);
+static ssize_t host_show_commands_outstanding(struct device *dev,
+	     struct device_attribute *attr, char *buf);
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
@@ -196,6 +198,8 @@ static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 static DEVICE_ATTR(firmware_revision, S_IRUGO,
 	host_show_firmware_revision, NULL);
+static DEVICE_ATTR(commands_outstanding, S_IRUGO,
+	host_show_commands_outstanding, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -207,6 +211,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_rescan,
 	&dev_attr_firmware_revision,
+	&dev_attr_commands_outstanding,
 	NULL,
 };
 
@@ -307,6 +312,15 @@ static ssize_t host_show_firmware_revision(struct device *dev,
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


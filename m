From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 00:43:55 +0100
Message-ID: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Userspace may wish to make policy decisions based on whether a host
supports device hotplug or not - for example, AHCI link power management
disables hotplug, so may only be desirable on hotplug ports. Add
support for marking hosts as hotpluggable in order to allow userspace to
treat them appropriately.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_sysfs.c |    2 ++
 include/scsi/scsi_host.h  |    9 +++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5fd2da4..5a48bac 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -363,6 +363,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->hotpluggable = sht->hotpluggable;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 91482f2..7669cbf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -246,6 +246,7 @@ static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL)
 
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
+shost_rd_attr(hotpluggable, "%d\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
@@ -257,6 +258,7 @@ shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_unique_id.attr,
 	&dev_attr_host_busy.attr,
+	&dev_attr_hotpluggable.attr,
 	&dev_attr_cmd_per_lun.attr,
 	&dev_attr_can_queue.attr,
 	&dev_attr_sg_tablesize.attr,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..b099493 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -421,6 +421,7 @@ struct scsi_host_template {
 	 */
 	unsigned unchecked_isa_dma:1;
 
+
 	/*
 	 * True if this host adapter can make good use of clustering.
 	 * I originally thought that if the tablesize was large that it
@@ -447,6 +448,11 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * True if host supports hotplugging
+	 */
+	unsigned hotpluggable:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
@@ -622,6 +628,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* 1 if hotpluggable, 0 if not */
+	unsigned hotpluggable:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.6.2.5


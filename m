From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/1] Add 'this_id' host attribute
Date: Wed, 18 Mar 2009 13:21:45 +0100
Message-ID: <20090318122146.26B0918C79D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:37502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZCRMae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 08:30:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@us.ibm.com, linux-scsi@vger.kernel.org


To be able to calculate the TransportID for SPI we
need to detect the SCSI ID of the initiator.
The 'this_id' field of the scsi host structure
carries this information, so we should export it
via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7513ce5..77f358b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -245,6 +245,7 @@ show_shost_active_mode(struct device *dev,
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
 
 shost_rd_attr(unique_id, "%u\n");
+shost_rd_attr(this_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
@@ -256,6 +257,7 @@ shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_unique_id.attr,
+	&dev_attr_this_id.attr,
 	&dev_attr_host_busy.attr,
 	&dev_attr_cmd_per_lun.attr,
 	&dev_attr_can_queue.attr,
-- 
1.5.3.2


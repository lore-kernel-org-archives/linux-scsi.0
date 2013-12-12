From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_error: disable eh_deadline if no host_reset_handler is set
Date: Thu, 12 Dec 2013 12:08:33 +0100
Message-ID: <1386846513-122051-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3LLLIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Dec 2013 06:08:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>

When the host template doesn't declare an eh_host_reset_handler
the eh_deadline mechanism is pointless and will set the
device to offline. So disable eh_deadline if no
eh_host_reset_handler is present.

Cc: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      | 2 +-
 drivers/scsi/scsi_sysfs.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6966def..351afa4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -396,7 +396,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
-	if (shost_eh_deadline == -1)
+	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
 	else if ((ulong) shost_eh_deadline * HZ > INT_MAX) {
 		shost_printk(KERN_WARNING, shost,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..7434e26 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,9 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 	int ret = -EINVAL;
 	unsigned long deadline, flags;
 
-	if (shost->transportt && shost->transportt->eh_strategy_handler)
+	if (shost->transportt &&
+	    (shost->transportt->eh_strategy_handler ||
+	     !shost->transportt->eh_host_reset_handler))
 		return ret;
 
 	if (!strncmp(buf, "off", strlen("off")))
-- 
1.7.12.4


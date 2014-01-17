From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_error: disable eh_deadline if no host_reset_handler is set
Date: Fri, 17 Jan 2014 16:05:38 +0100
Message-ID: <1389971138-111184-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaAQPFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 10:05:40 -0500
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
index f28ea07..3cbb57a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -398,7 +398,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->ordered_tag = sht->ordered_tag;
 	shost->no_write_same = sht->no_write_same;
 
-	if (shost_eh_deadline == -1)
+	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
 	else if ((ulong) shost_eh_deadline * HZ > INT_MAX) {
 		shost_printk(KERN_WARNING, shost,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..f2151cd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -300,7 +300,9 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 	int ret = -EINVAL;
 	unsigned long deadline, flags;
 
-	if (shost->transportt && shost->transportt->eh_strategy_handler)
+	if (shost->transportt &&
+	    (shost->transportt->eh_strategy_handler ||
+	     !shost->hostt->eh_host_reset_handler))
 		return ret;
 
 	if (!strncmp(buf, "off", strlen("off")))
-- 
1.7.12.4


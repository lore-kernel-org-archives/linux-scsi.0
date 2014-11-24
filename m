From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: Enable shared host tag map
Date: Mon, 24 Nov 2014 16:33:55 +0100
Message-ID: <1416843235-35947-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbaKXPd6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 10:33:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The megaraid SAS driver uses a shared host tag map internally,
so we should be telling the block layer about it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f05580e..7fb83d0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2757,6 +2757,7 @@ static struct scsi_host_template megasas_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.change_queue_depth = scsi_change_queue_depth,
 	.no_write_same = 1,
+	.use_blk_tags = 1,
 };
 
 /**
@@ -4996,6 +4997,11 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		host->hostt->eh_bus_reset_handler = NULL;
 	}
 
+	if (scsi_init_shared_tag_map(host, host->can_queue)) {
+		printk(KERN_INFO "megasas: failed to init shared tag map\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
-- 
1.8.5.2


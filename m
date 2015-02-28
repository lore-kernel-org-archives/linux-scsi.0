From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 1/4] scsi: add ability to adjust module reference for scsi host
Date: Sat, 28 Feb 2015 23:16:54 +0900
Message-ID: <1425133017-7216-2-git-send-email-akinobu.mita@gmail.com>
References: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33172 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbbB1OR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 09:17:28 -0500
In-Reply-To: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a scsi_device, the use count of the underlying LLDD module
is incremented.  The module reference is retrieved through .module field of
struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except ufs, unusual usb storage drivers, and sub drivers for esp_scsi.
These drivers consist with core driver and actual LLDDs, and
scsi_host_template is defined in the core driver.  So the actual LLDDs can
be unloaded even if the scsi_device is being accessed.

This adds .module field in struct Scsi_Host and let the module reference
be retrieved though it instead of struct scsi_host_template.  This allows
the actual LLDDs adjust module reference.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
Change from v3
- Rebased to the 4.0-rc1

 drivers/scsi/hosts.c     | 1 +
 drivers/scsi/scsi.c      | 4 ++--
 include/scsi/scsi_host.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..21f1442 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -411,6 +411,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	 */
 	shost->max_cmd_len = 12;
 	shost->hostt = sht;
+	shost->module = sht->module;
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c9c3b57..0d89344 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -981,7 +981,7 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	/* We can fail try_module_get if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	__module_get(sdev->host->hostt->module);
+	__module_get(sdev->host->module);
 
 	return 0;
 }
@@ -997,7 +997,7 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	module_put(sdev->host->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..8742bfd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -620,6 +620,7 @@ struct Scsi_Host {
 	 */
 	unsigned short max_cmd_len;
 
+	struct module *module;
 	int this_id;
 	int can_queue;
 	short cmd_per_lun;
-- 
1.9.1


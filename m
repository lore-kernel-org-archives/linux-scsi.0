From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/3] scsi: add ability to adjust module reference for scsi host
Date: Wed,  7 Jan 2015 23:03:00 +0900
Message-ID: <1420639382-2219-2-git-send-email-akinobu.mita@gmail.com>
References: <1420639382-2219-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60331 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbAGOD0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:03:26 -0500
In-Reply-To: <1420639382-2219-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a scsi_device, the use count of the underlying LLDD module
is incremented.  The module reference is retrieved through .module field of
struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except some scsi drivers (ufs and unusual usb storage drivers).  These
drivers consist with core driver and actual LLDDs, and scsi_host_template
is defined in the core driver.  So the actual LLDDs can be unloaded even if
the scsi_device is being accessed.

This adds .module field in struct Scsi_Host and let the module reference
be retrieved though it instead of struct scsi_host_template.  This allows
the actual LLDDs adjust module reference.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
No change from v1

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
index e028854..5905b83 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -988,7 +988,7 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	/* We can fail this if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	try_module_get(sdev->host->module);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ EXPORT_SYMBOL(scsi_device_get);
 void scsi_device_put(struct scsi_device *sdev)
 {
 #ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
+	struct module *module = sdev->host->module;
 
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 019e668..5133f2f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -617,6 +617,7 @@ struct Scsi_Host {
 	 */
 	unsigned short max_cmd_len;
 
+	struct module *module;
 	int this_id;
 	int can_queue;
 	short cmd_per_lun;
-- 
1.9.1


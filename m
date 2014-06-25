From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] scsi: Implement ch_printk()
Date: Wed, 25 Jun 2014 16:39:56 +0200
Message-ID: <1403707199-102664-4-git-send-email-hare@suse.de>
References: <1403707199-102664-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaFYOkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 10:40:03 -0400
In-Reply-To: <1403707199-102664-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Update the ch driver to use dev_printk() variants instead of
plain printk(); this will prefix logging messages with the
appropriate device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2a32374..ba1c3bf 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -84,15 +84,19 @@ static const char * vendor_labels[CH_TYPES-4] = {
 };
 // module_param_string_array(vendor_labels, NULL, 0444);
 
+#define ch_printk(prefix, ch, fmt, a...) \
+	sdev_printk(prefix, (ch)->device, "[%s] " fmt, \
+		    (ch)->name, ##a)
+
 #define DPRINTK(fmt, arg...)						\
 do {									\
 	if (debug)							\
-		printk(KERN_DEBUG "%s: " fmt, ch->name, ##arg);		\
+		ch_printk(KERN_DEBUG, ch, fmt, ##arg);			\
 } while (0)
 #define VPRINTK(level, fmt, arg...)					\
 do {									\
 	if (verbose)							\
-		printk(level "%s: " fmt, ch->name, ##arg);		\
+		ch_printk(level, ch, fmt, ##arg);			\
 } while (0)
 
 /* ------------------------------------------------------------------- */
@@ -196,7 +200,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 		__scsi_print_command(cmd);
 	}
 
-        result = scsi_execute_req(ch->device, cmd, direction, buffer,
+	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
@@ -924,8 +928,8 @@ static int ch_probe(struct device *dev)
 				  MKDEV(SCSI_CHANGER_MAJOR, ch->minor), ch,
 				  "s%s", ch->name);
 	if (IS_ERR(class_dev)) {
-		printk(KERN_WARNING "ch%d: device_create failed\n",
-		       ch->minor);
+		sdev_printk(KERN_WARNING, sd, "ch%d: device_create failed\n",
+			    ch->minor);
 		ret = PTR_ERR(class_dev);
 		goto remove_idr;
 	}
-- 
1.7.12.4


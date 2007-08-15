From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] ncr53c8xx: Call scsi_host_put in release
Date: Wed, 15 Aug 2007 12:56:56 -0600
Message-ID: <11872042211224-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43129 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <11872042213665-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Since ncr53c8xx_attach() calls scsi_host_put(), make ncr53c8xx_release()
call scsi_host_put() too, for symmetry.  Both callers already expect
it to put the host for them, so that works out nicely.  While the zalon
driver does 'use' the host pointer afterwards, it only compares it for
equality and doesn't dereference it, so that's safe.

While I'm at it, get rid of pointless checks for NULL, use shost_priv()
and change ncr53c8xx_release to return void.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/ncr53c8xx.c |   11 ++++-------
 drivers/scsi/ncr53c8xx.h |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 030ba49..91fa66c 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8528,18 +8528,15 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 }
 
 
-int ncr53c8xx_release(struct Scsi_Host *host)
+void ncr53c8xx_release(struct Scsi_Host *host)
 {
-	struct host_data *host_data;
+	struct host_data *host_data = shost_priv(host);
 #ifdef DEBUG_NCR53C8XX
 	printk("ncr53c8xx: release\n");
 #endif
-	if (!host)
-		return 1;
-	host_data = (struct host_data *)host->hostdata;
-	if (host_data && host_data->ncb)
+	if (host_data->ncb)
 		ncr_detach(host_data->ncb);
-	return 1;
+	scsi_host_put(host);
 }
 
 static void ncr53c8xx_set_period(struct scsi_target *starget, int period)
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index b39357d..0e008da 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -1321,7 +1321,7 @@ struct ncr_device {
 };
 
 extern struct Scsi_Host *ncr_attach(struct scsi_host_template *tpnt, int unit, struct ncr_device *device);
-extern int ncr53c8xx_release(struct Scsi_Host *host);
+extern void ncr53c8xx_release(struct Scsi_Host *host);
 irqreturn_t ncr53c8xx_intr(int irq, void *dev_id);
 extern int ncr53c8xx_init(void);
 extern void ncr53c8xx_exit(void);
-- 
1.5.2.4


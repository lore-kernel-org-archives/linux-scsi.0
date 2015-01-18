From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 05/11] 53c700: prepare move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:03 +0900
Message-ID: <1421593569-5089-6-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42429 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:06:45 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so31609901pdi.7
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:06:45 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this converts NCR_700_detect() into
macro so that LLDDs can pass THIS_MODULE to scsi_host_alloc() through it
instead of scsi_host_template->module.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/53c700.c | 7 ++++---
 drivers/scsi/53c700.h | 7 +++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 82abfce..e70fd05 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -283,8 +283,9 @@ NCR_700_get_SXFER(struct scsi_device *SDp)
 }
 
 struct Scsi_Host *
-NCR_700_detect(struct scsi_host_template *tpnt,
-	       struct NCR_700_Host_Parameters *hostdata, struct device *dev)
+__NCR_700_detect(struct scsi_host_template *tpnt,
+		 struct NCR_700_Host_Parameters *hostdata, struct device *dev,
+		 struct module *owner)
 {
 	dma_addr_t pScript, pSlots;
 	__u8 *memory;
@@ -2101,7 +2102,7 @@ STATIC struct device_attribute *NCR_700_dev_attrs[] = {
 	NULL,
 };
 
-EXPORT_SYMBOL(NCR_700_detect);
+EXPORT_SYMBOL(__NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
 
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e06bdfe..4555958 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -54,8 +54,11 @@
 struct NCR_700_Host_Parameters;
 
 /* These are the externally used routines */
-struct Scsi_Host *NCR_700_detect(struct scsi_host_template *,
-		struct NCR_700_Host_Parameters *, struct device *);
+struct Scsi_Host *__NCR_700_detect(struct scsi_host_template *,
+		struct NCR_700_Host_Parameters *, struct device *,
+		struct module *);
+#define NCR_700_detect(tpnt, hostdata, dev) \
+	__NCR_700_detect(tpnt, hostdata, dev, THIS_MODULE)
 int NCR_700_release(struct Scsi_Host *host);
 irqreturn_t NCR_700_intr(int, void *);
 
-- 
1.9.1


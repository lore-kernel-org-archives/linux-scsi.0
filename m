From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 02/11] iscsi: prepare to move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:00 +0900
Message-ID: <1421593569-5089-3-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34147 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbARPGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:06:36 -0500
Received: by mail-pd0-f181.google.com with SMTP id z10so20088263pdj.12
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:06:35 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this converts iscsi_host_alloc()
into macro so that LLDDs can pass THIS_MODULE to scsi_host_alloc() through
it instead of scsi_host_template->module.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/libiscsi.c | 10 ++++++----
 include/scsi/libiscsi.h |  9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8053f24..4c5be6b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2593,16 +2593,18 @@ int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 EXPORT_SYMBOL_GPL(iscsi_host_add);
 
 /**
- * iscsi_host_alloc - allocate a host and driver data
+ * __iscsi_host_alloc - allocate a host and driver data
  * @sht: scsi host template
  * @dd_data_size: driver host data size
  * @xmit_can_sleep: bool indicating if LLD will queue IO from a work queue
+ * @owner: module which will be the owner of the scsi host
  *
  * This should be called by partial offload and software iscsi drivers.
  * To access the driver specific memory use the iscsi_host_priv() macro.
  */
-struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-				   int dd_data_size, bool xmit_can_sleep)
+struct Scsi_Host *__iscsi_host_alloc(struct scsi_host_template *sht,
+				     int dd_data_size, bool xmit_can_sleep,
+				     struct module *owner)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_host *ihost;
@@ -2630,7 +2632,7 @@ free_host:
 	scsi_host_put(shost);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(iscsi_host_alloc);
+EXPORT_SYMBOL_GPL(__iscsi_host_alloc);
 
 static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4d1c46a..c95d957 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -396,9 +396,12 @@ extern int iscsi_host_set_param(struct Scsi_Host *shost,
 extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
 extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
-extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-					  int dd_data_size,
-					  bool xmit_can_sleep);
+extern struct Scsi_Host *__iscsi_host_alloc(struct scsi_host_template *sht,
+					    int dd_data_size,
+					    bool xmit_can_sleep,
+					    struct module *owner);
+#define iscsi_host_alloc(sht, dd_data_size, xmit_can_sleep) \
+	__iscsi_host_alloc(sht, dd_data_size, xmit_can_sleep, THIS_MODULE)
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
-- 
1.9.1


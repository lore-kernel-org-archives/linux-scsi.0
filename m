From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 03/11] cxgbi: prepare to move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:01 +0900
Message-ID: <1421593569-5089-4-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55754 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:06:38 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so33548849pab.7
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:06:38 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this converts cxgbi_hbas_add() into
macro so that LLDDs can pass THIS_MODULE to __iscsi_host_alloc() through
it instead of scsi_host_template->module.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/cxgbi/libcxgbi.c | 8 ++++----
 drivers/scsi/cxgbi/libcxgbi.h | 6 ++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index eb58afc..f090d63 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -330,9 +330,9 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 }
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
-int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
+int __cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 		unsigned int max_id, struct scsi_host_template *sht,
-		struct scsi_transport_template *stt)
+		struct scsi_transport_template *stt, struct module *owner)
 {
 	struct cxgbi_hba *chba;
 	struct Scsi_Host *shost;
@@ -341,7 +341,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 	log_debug(1 << CXGBI_DBG_DEV, "cdev 0x%p, p#%u.\n", cdev, cdev->nports);
 
 	for (i = 0; i < cdev->nports; i++) {
-		shost = iscsi_host_alloc(sht, sizeof(*chba), 1);
+		shost = __iscsi_host_alloc(sht, sizeof(*chba), 1, owner);
 		if (!shost) {
 			pr_info("0x%p, p%d, %s, host alloc failed.\n",
 				cdev, i, cdev->ports[i]->name);
@@ -383,7 +383,7 @@ err_out:
 	cxgbi_hbas_remove(cdev);
 	return err;
 }
-EXPORT_SYMBOL_GPL(cxgbi_hbas_add);
+EXPORT_SYMBOL_GPL(__cxgbi_hbas_add);
 
 /*
  * iSCSI offload
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index aba1af7..26c8bf7 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -707,9 +707,11 @@ struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
 struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *, int *);
 struct cxgbi_device *cxgbi_device_find_by_netdev_rcu(struct net_device *,
 						     int *);
-int cxgbi_hbas_add(struct cxgbi_device *, u64, unsigned int,
+int __cxgbi_hbas_add(struct cxgbi_device *, u64, unsigned int,
 			struct scsi_host_template *,
-			struct scsi_transport_template *);
+			struct scsi_transport_template *, struct module *);
+#define cxgbi_hbas_add(cdev, max_lun, max_id, sht, stt) \
+	__cxgbi_hbas_add(cdev, max_lun, max_id, sht, stt, THIS_MODULE)
 void cxgbi_hbas_remove(struct cxgbi_device *);
 
 int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
-- 
1.9.1


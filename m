From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 04/11] libfc: prepare to move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:02 +0900
Message-ID: <1421593569-5089-5-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38963 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:06:42 -0500
Received: by mail-pd0-f181.google.com with SMTP id z10so20088610pdj.12
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:06:42 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, fcoe-devel@open-fcoe.org

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this enables libfc_vport_create()
to allocate Scsi_Host with correct module reference through
__libfc_host_alloc() which is introduced while changing libfc_host_alloc()
from inline function to macro and it takes module reference explicitly.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/libfc/fc_lport.c | 26 ++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_npiv.c  |  3 ++-
 include/scsi/libfc.h          | 27 ++++-----------------------
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e01a298..d931e69 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2142,3 +2142,29 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	return rc;
 }
 EXPORT_SYMBOL(fc_lport_bsg_request);
+
+/**
+ * __libfc_host_alloc() - Allocate a Scsi_Host with room for a local port and
+ *                      LLD private data
+ * @sht:       The SCSI host template
+ * @priv_size: Size of private data
+ * @owner: module which will be the owner of the scsi host
+ *
+ * Returns: libfc lport
+ */
+struct fc_lport *__libfc_host_alloc(struct scsi_host_template *sht,
+				    int priv_size, struct module *owner)
+{
+	struct fc_lport *lport;
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
+	if (!shost)
+		return NULL;
+	lport = shost_priv(shost);
+	lport->host = shost;
+	INIT_LIST_HEAD(&lport->ema_list);
+	INIT_LIST_HEAD(&lport->vports);
+	return lport;
+}
+EXPORT_SYMBOL(__libfc_host_alloc);
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index 9fbf78e..86133f9 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -36,7 +36,8 @@ struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fc_lport *vn_port;
 
-	vn_port = libfc_host_alloc(shost->hostt, privsize);
+	vn_port = __libfc_host_alloc(shost->hostt, privsize,
+				     shost->hostt->module);
 	if (!vn_port)
 		return vn_port;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 93d14da..b4fbfc2 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1018,29 +1018,10 @@ static inline void *lport_priv(const struct fc_lport *lport)
 	return (void *)(lport + 1);
 }
 
-/**
- * libfc_host_alloc() - Allocate a Scsi_Host with room for a local port and
- *                      LLD private data
- * @sht:       The SCSI host template
- * @priv_size: Size of private data
- *
- * Returns: libfc lport
- */
-static inline struct fc_lport *
-libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
-{
-	struct fc_lport *lport;
-	struct Scsi_Host *shost;
-
-	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
-	if (!shost)
-		return NULL;
-	lport = shost_priv(shost);
-	lport->host = shost;
-	INIT_LIST_HEAD(&lport->ema_list);
-	INIT_LIST_HEAD(&lport->vports);
-	return lport;
-}
+struct fc_lport *__libfc_host_alloc(struct scsi_host_template *sht,
+				    int priv_size, struct module *owner);
+#define libfc_host_alloc(sht, priv_size) \
+	__libfc_host_alloc(sht, priv_size, THIS_MODULE)
 
 /*
  * FC_FCP HELPER FUNCTIONS
-- 
1.9.1


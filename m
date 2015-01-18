From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 06/11] scsi: legacy: prepare to move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:04 +0900
Message-ID: <1421593569-5089-7-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61143 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:06:48 -0500
Received: by mail-pd0-f179.google.com with SMTP id v10so13426314pde.10
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2015 07:06:48 -0800 (PST)
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this converts scsi_register() into
macro so that legacy LLDDs can pass THIS_MODULE to scsi_host_alloc()
through it instead of scsi_host_template->module.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hosts.c     | 5 +++--
 include/scsi/scsi_host.h | 5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..eb324f1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -499,7 +499,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 }
 EXPORT_SYMBOL(scsi_host_alloc);
 
-struct Scsi_Host *scsi_register(struct scsi_host_template *sht, int privsize)
+struct Scsi_Host *__scsi_register(struct scsi_host_template *sht, int privsize,
+				  struct module *owner)
 {
 	struct Scsi_Host *shost = scsi_host_alloc(sht, privsize);
 
@@ -513,7 +514,7 @@ struct Scsi_Host *scsi_register(struct scsi_host_template *sht, int privsize)
 		list_add_tail(&shost->sht_legacy_list, &sht->legacy_hosts);
 	return shost;
 }
-EXPORT_SYMBOL(scsi_register);
+EXPORT_SYMBOL(__scsi_register);
 
 void scsi_unregister(struct Scsi_Host *shost)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 019e668..0369b4e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -926,7 +926,10 @@ static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
 }
 
 /* legacy interfaces */
-extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
+extern struct Scsi_Host *__scsi_register(struct scsi_host_template *, int,
+					 struct module *);
+#define scsi_register(sht, privsize) \
+	__scsi_register(sht, privsize, THIS_MODULE)
 extern void scsi_unregister(struct Scsi_Host *);
 extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
 
-- 
1.9.1


From: akpm@osdl.org
Subject: [patch 23/24] drivers/scsi/nsp32.h: removal of old scsi code
Date: Mon, 14 Aug 2006 23:09:38 -0700
Message-ID: <200608150609.k7F69ddR013276@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:64661 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965185AbWHOGJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:09:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, michal.k.k.piotrowski@gmail.com

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/nsp32.h |   42 -----------------------------------------
 1 file changed, 42 deletions(-)

diff -puN drivers/scsi/nsp32.h~drivers-scsi-nsp32h-removal-of-old-scsi-code drivers/scsi/nsp32.h
--- a/drivers/scsi/nsp32.h~drivers-scsi-nsp32h-removal-of-old-scsi-code
+++ a/drivers/scsi/nsp32.h
@@ -619,47 +619,5 @@ typedef struct _nsp32_hw_data {
 #define REQSACK_TIMEOUT_TIME	10000	/* max wait time for REQ/SACK assertion
 					   or negation, 10000us == 10ms */
 
-/**************************************************************************
- * Compatibility functions
- */
-
-/* for Kernel 2.4 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-# define scsi_register_host(template) 	scsi_register_module(MODULE_SCSI_HA, template)
-# define scsi_unregister_host(template) scsi_unregister_module(MODULE_SCSI_HA, template)
-# define scsi_host_put(host)            scsi_unregister(host)
-# define pci_name(pci_dev)              ((pci_dev)->slot_name)
-
-typedef void irqreturn_t;
-# define IRQ_NONE      /* */
-# define IRQ_HANDLED   /* */
-# define IRQ_RETVAL(x) /* */
-
-/* This is ad-hoc version of scsi_host_get_next() */
-static inline struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *host)
-{
-	if (host == NULL) {
-		return scsi_hostlist;
-	} else {
-		return host->next;
-	}
-}
-
-/* This is ad-hoc version of scsi_host_hn_get() */
-static inline struct Scsi_Host *scsi_host_hn_get(unsigned short hostno)
-{
-	struct Scsi_Host *host;
-
-	for (host = scsi_host_get_next(NULL); host != NULL;
-	     host = scsi_host_get_next(host)) {
-		if (host->host_no == hostno) {
-			break;
-		}
-	}
-
-	return host;
-}
-#endif
-
 #endif /* _NSP32_H */
 /* end */
_

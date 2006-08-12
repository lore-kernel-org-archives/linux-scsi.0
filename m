From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 8/9] drivers/scsi/nsp32.h Removal of old scsi code
Date: Sat, 12 Aug 2006 23:03:13 +0200
Message-ID: <44DE4211.2000802@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:28050 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1422702AbWHLVCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 17:02:38 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1295188nfc
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 14:02:37 -0700 (PDT)
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, GOTO Masanori <gotom@debian.or.jp>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/nsp32.h linux-work/drivers/scsi/nsp32.h
--- linux-work-clean/drivers/scsi/nsp32.h	2006-03-20 06:53:29.000000000 +0100
+++ linux-work/drivers/scsi/nsp32.h	2006-08-12 20:40:00.000000000 +0200
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


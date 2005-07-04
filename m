From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] qla1280: remove dead per-host flag variables
Date: Mon, 4 Jul 2005 17:48:13 +0200
Message-ID: <20050704154813.GB30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45260 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261288AbVGDPsT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-19 20:47:01.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-19 20:48:30.000000000 +0200
@@ -996,7 +996,6 @@
 		break;
 
 	case ABORT_DEVICE:
-		ha->flags.in_reset = 1;
 		if (qla1280_verbose)
 			printk(KERN_INFO
 			       "scsi(%ld:%d:%d:%d): Queueing abort device "
@@ -1010,7 +1009,6 @@
 			printk(KERN_INFO
 			       "scsi(%ld:%d:%d:%d): Queueing device reset "
 			       "command.\n", ha->host_no, bus, target, lun);
-		ha->flags.in_reset = 1;
 		if (qla1280_device_reset(ha, bus, target) == 0)
 			result = SUCCESS;
 		break;
@@ -1019,7 +1017,6 @@
 		if (qla1280_verbose)
 			printk(KERN_INFO "qla1280(%ld:%d): Issuing BUS "
 			       "DEVICE RESET\n", ha->host_no, bus);
-		ha->flags.in_reset = 1;
 		if (qla1280_bus_reset(ha, bus == 0))
 			result = SUCCESS;
 
@@ -1047,7 +1044,6 @@
 
 	if (!list_empty(&ha->done_q))
 		qla1280_done(ha);
-	ha->flags.in_reset = 0;
 
 	/* If we didn't manage to issue the action, or we have no
 	 * command to wait for, exit here */
@@ -1636,7 +1632,6 @@
 	/* enable risc and host interrupts */
 	WRT_REG_WORD(&reg->ictrl, (ISP_EN_INT | ISP_EN_RISC));
 	RD_REG_WORD(&reg->ictrl);	/* PCI Posted Write flush */
-	ha->flags.ints_enabled = 1;
 }
 
 static inline void
@@ -1648,7 +1643,6 @@
 	/* disable risc and host interrupts */
 	WRT_REG_WORD(&reg->ictrl, 0);
 	RD_REG_WORD(&reg->ictrl);	/* PCI Posted Write flush */
-	ha->flags.ints_enabled = 0;
 }
 
 /*
@@ -1679,7 +1673,6 @@
 	ha->flags.reset_active = 0;
 	ha->flags.abort_isp_active = 0;
 
-	ha->flags.ints_enabled = 0;
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 	if (ia64_platform_is("sn2")) {
 		printk(KERN_INFO "scsi(%li): Enabling SN2 PCI DMA "
Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-19 20:47:01.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-19 20:48:36.000000000 +0200
@@ -1082,10 +1082,6 @@
 		uint32_t reset_active:1;		/* 3 */
 		uint32_t abort_isp_active:1;		/* 4 */
 		uint32_t disable_risc_code_load:1;	/* 5 */
-		uint32_t enable_64bit_addressing:1;	/* 6 */
-		uint32_t in_reset:1;			/* 7 */
-		uint32_t ints_enabled:1;
-		uint32_t ignore_nvram:1;
 #ifdef __ia64__
 		uint32_t use_pci_vchannel:1;
 #endif

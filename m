From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] scsi: remove LINUX_VERSION_CODE macro usage from nsp32
Date: Sat, 14 Jan 2006 18:57:22 +0200
Message-ID: <1137257843.9318.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:23719 "EHLO
	mail.cs.helsinki.fi") by vger.kernel.org with ESMTP
	id S1750940AbWANQ5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 11:57:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes LINUX_VERSION_CODE macro usage from the nsp32 driver in
drivers/scsi/.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/scsi/nsp32.c |   72 ---------------------------------------------------
 drivers/scsi/nsp32.h |   42 -----------------------------
 2 files changed, 114 deletions(-)

Index: 2.6/drivers/scsi/nsp32.c
===================================================================
--- 2.6.orig/drivers/scsi/nsp32.c
+++ 2.6/drivers/scsi/nsp32.c
@@ -49,10 +49,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-# include <linux/blk.h>
-#endif
-
 #include "nsp32.h"
 
 
@@ -199,17 +195,9 @@ static int  __init    init_nsp32  (void)
 static void __exit    exit_nsp32  (void);
 
 /* struct struct scsi_host_template */
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 static int         nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
-#else
-static int         nsp32_proc_info   (char *, char **, off_t, int, int, int);
-#endif
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 static int         nsp32_detect      (struct pci_dev *pdev);
-#else
-static int         nsp32_detect      (struct scsi_host_template *);
-#endif
 static int         nsp32_queuecommand(struct scsi_cmnd *,
 		void (*done)(struct scsi_cmnd *));
 static const char *nsp32_info        (struct Scsi_Host *);
@@ -296,15 +284,6 @@ static struct scsi_host_template nsp32_t
 	.eh_abort_handler       	= nsp32_eh_abort,
 	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,74))
-	.detect				= nsp32_detect,
-	.release			= nsp32_release,
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
-	.use_new_eh_code        	= 1,
-#else
-/*	.highmem_io			= 1, */
-#endif
 };
 
 #include "nsp32_io.h"
@@ -1211,12 +1190,8 @@ static irqreturn_t do_nsp32_isr(int irq,
 	int ret;
 	int handled = 0;
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 	struct Scsi_Host *host = data->Host;
 	spin_lock_irqsave(host->host_lock, flags);
-#else
-	spin_lock_irqsave(&io_request_lock, flags);
-#endif
 
 	/*
 	 * IRQ check, then enable IRQ mask
@@ -1480,11 +1455,7 @@ static irqreturn_t do_nsp32_isr(int irq,
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
  out2:
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 	spin_unlock_irqrestore(host->host_lock, flags);
-#else
-	spin_unlock_irqrestore(&io_request_lock, flags);
-#endif
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
@@ -1500,27 +1471,18 @@ static irqreturn_t do_nsp32_isr(int irq,
 		} \
 	} while(0)
 static int nsp32_proc_info(
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
 	struct Scsi_Host *host,
-#endif
 	char             *buffer,
 	char            **start,
 	off_t             offset,
 	int               length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
-	int               hostno,
-#endif
 	int               inout)
 {
 	char             *pos = buffer;
 	int               thislength;
 	unsigned long     flags;
 	nsp32_hw_data    *data;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
 	int               hostno;
-#else
-	struct Scsi_Host *host;
-#endif
 	unsigned int      base;
 	unsigned char     mode_reg;
 	int               id, speed;
@@ -1531,15 +1493,7 @@ static int nsp32_proc_info(
 		return -EINVAL;
 	}
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
 	hostno = host->host_no;
-#else
-	/* search this HBA host */
-	host = scsi_host_hn_get(hostno);
-	if (host == NULL) {
-		return -ESRCH;
-	}
-#endif
 	data = (nsp32_hw_data *)host->hostdata;
 	base = host->io_port;
 
@@ -2674,17 +2628,10 @@ static void nsp32_sack_negate(nsp32_hw_d
  *	0x900-0xbff: (map same 0x800-0x8ff I/O port image repeatedly)
  *	0xc00-0xfff: CardBus status registers
  */
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 #define DETECT_OK 0
 #define DETECT_NG 1
 #define PCIDEV    pdev
 static int nsp32_detect(struct pci_dev *pdev)
-#else
-#define DETECT_OK 1
-#define DETECT_NG 0
-#define PCIDEV    (data->Pci)
-static int nsp32_detect(struct scsi_host_template *sht)
-#endif
 {
 	struct Scsi_Host *host;	/* registered host structure */
 	struct resource  *res;
@@ -2697,11 +2644,7 @@ static int nsp32_detect(struct scsi_host
 	/*
 	 * register this HBA as SCSI device
 	 */
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	host = scsi_host_alloc(&nsp32_template, sizeof(nsp32_hw_data));
-#else
-	host = scsi_register(sht, sizeof(nsp32_hw_data));
-#endif
 	if (host == NULL) {
 		nsp32_msg (KERN_ERR, "failed to scsi register");
 		goto err;
@@ -2719,9 +2662,6 @@ static int nsp32_detect(struct scsi_host
 	host->unique_id = data->BaseAddress;
 	host->n_io_port	= data->NumAddress;
 	host->base      = (unsigned long)data->MmioAddress;
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,63))
-	scsi_set_pci_device(host, PCIDEV);
-#endif
 
 	data->Host      = host;
 	spin_lock_init(&(data->Lock));
@@ -2884,10 +2824,8 @@ static int nsp32_detect(struct scsi_host
 		goto free_irq;
         }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	scsi_add_host (host, &PCIDEV->dev);
 	scsi_scan_host(host);
-#endif
 	pci_set_drvdata(PCIDEV, host);
 	return DETECT_OK;
 
@@ -3519,11 +3457,7 @@ static int __devinit nsp32_probe(struct 
 
 	pci_set_master(pdev);
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	ret = nsp32_detect(pdev);
-#else
-	ret = scsi_register_host(&nsp32_template);
-#endif
 
 	nsp32_msg(KERN_INFO, "irq: %i mmio: %p+0x%lx slot: %s model: %s",
 		  pdev->irq,
@@ -3538,21 +3472,15 @@ static int __devinit nsp32_probe(struct 
 
 static void __devexit nsp32_remove(struct pci_dev *pdev)
 {
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
-#endif
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
         scsi_remove_host(host);
 
 	nsp32_release(host);
 
 	scsi_host_put(host);
-#else
-	scsi_unregister_host(&nsp32_template);	
-#endif
 }
 
 
Index: 2.6/drivers/scsi/nsp32.h
===================================================================
--- 2.6.orig/drivers/scsi/nsp32.h
+++ 2.6/drivers/scsi/nsp32.h
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



From: akpm@linux-foundation.org
Subject: [patch 17/25] drivers/scsi/nsp32.c: remove kernel 2.4 code
Date: Wed, 23 May 2007 14:41:46 -0700
Message-ID: <200705232141.l4NLflwm001213@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991AbXEWWEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:04:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de, gotom@sanori.org

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: GOTO Masanori <gotom@sanori.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/nsp32.c |  109 ++++-------------------------------------
 1 files changed, 13 insertions(+), 96 deletions(-)

diff -puN drivers/scsi/nsp32.c~drivers-scsi-nsp32c-remove-kernel-24-code drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~drivers-scsi-nsp32c-remove-kernel-24-code
+++ a/drivers/scsi/nsp32.c
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
@@ -296,15 +284,7 @@ static struct scsi_host_template nsp32_t
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
 /*	.highmem_io			= 1, */
-#endif
 };
 
 #include "nsp32_io.h"
@@ -1210,13 +1190,9 @@ static irqreturn_t do_nsp32_isr(int irq,
 	unsigned long flags;
 	int ret;
 	int handled = 0;
-
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 	struct Scsi_Host *host = data->Host;
+
 	spin_lock_irqsave(host->host_lock, flags);
-#else
-	spin_lock_irqsave(&io_request_lock, flags);
-#endif
 
 	/*
 	 * IRQ check, then enable IRQ mask
@@ -1480,11 +1456,7 @@ static irqreturn_t do_nsp32_isr(int irq,
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
  out2:
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 	spin_unlock_irqrestore(host->host_lock, flags);
-#else
-	spin_unlock_irqrestore(&io_request_lock, flags);
-#endif
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
@@ -1499,28 +1471,15 @@ static irqreturn_t do_nsp32_isr(int irq,
 			nsp32_dbg(NSP32_DEBUG_PROC, "buffer=0x%p pos=0x%p length=%d %d\n", buffer, pos, length,  length - (pos - buffer));\
 		} \
 	} while(0)
-static int nsp32_proc_info(
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
-	struct Scsi_Host *host,
-#endif
-	char             *buffer,
-	char            **start,
-	off_t             offset,
-	int               length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73)) 
-	int               hostno,
-#endif
-	int               inout)
+
+static int nsp32_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+			   off_t offset, int length, int inout)
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
@@ -1531,15 +1490,7 @@ static int nsp32_proc_info(
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
 
@@ -2674,17 +2625,7 @@ static void nsp32_sack_negate(nsp32_hw_d
  *	0x900-0xbff: (map same 0x800-0x8ff I/O port image repeatedly)
  *	0xc00-0xfff: CardBus status registers
  */
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-#define DETECT_OK 0
-#define DETECT_NG 1
-#define PCIDEV    pdev
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
@@ -2697,11 +2638,7 @@ static int nsp32_detect(struct scsi_host
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
@@ -2719,9 +2656,6 @@ static int nsp32_detect(struct scsi_host
 	host->unique_id = data->BaseAddress;
 	host->n_io_port	= data->NumAddress;
 	host->base      = (unsigned long)data->MmioAddress;
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,63))
-	scsi_set_pci_device(host, PCIDEV);
-#endif
 
 	data->Host      = host;
 	spin_lock_init(&(data->Lock));
@@ -2776,7 +2710,7 @@ static int nsp32_detect(struct scsi_host
 	/*
 	 * setup DMA 
 	 */
-	if (pci_set_dma_mask(PCIDEV, DMA_32BIT_MASK) != 0) {
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
@@ -2784,7 +2718,7 @@ static int nsp32_detect(struct scsi_host
 	/*
 	 * allocate autoparam DMA resource.
 	 */
-	data->autoparam = pci_alloc_consistent(PCIDEV, sizeof(nsp32_autoparam), &(data->auto_paddr));
+	data->autoparam = pci_alloc_consistent(pdev, sizeof(nsp32_autoparam), &(data->auto_paddr));
 	if (data->autoparam == NULL) {
 		nsp32_msg(KERN_ERR, "failed to allocate DMA memory");
 		goto scsi_unregister;
@@ -2793,7 +2727,7 @@ static int nsp32_detect(struct scsi_host
 	/*
 	 * allocate scatter-gather DMA resource.
 	 */
-	data->sg_list = pci_alloc_consistent(PCIDEV, NSP32_SG_TABLE_SIZE,
+	data->sg_list = pci_alloc_consistent(pdev, NSP32_SG_TABLE_SIZE,
 					     &(data->sg_paddr));
 	if (data->sg_list == NULL) {
 		nsp32_msg(KERN_ERR, "failed to allocate DMA memory");
@@ -2883,16 +2817,14 @@ static int nsp32_detect(struct scsi_host
 		goto free_irq;
         }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-	ret = scsi_add_host(host, &PCIDEV->dev);
+	ret = scsi_add_host(host, &pdev->dev);
 	if (ret) {
 		nsp32_msg(KERN_ERR, "failed to add scsi host");
 		goto free_region;
 	}
 	scsi_scan_host(host);
-#endif
-	pci_set_drvdata(PCIDEV, host);
-	return DETECT_OK;
+	pci_set_drvdata(pdev, host);
+	return 0;
 
  free_region:
 	release_region(host->io_port, host->n_io_port);
@@ -2901,22 +2833,19 @@ static int nsp32_detect(struct scsi_host
 	free_irq(host->irq, data);
 
  free_sg_list:
-	pci_free_consistent(PCIDEV, NSP32_SG_TABLE_SIZE,
+	pci_free_consistent(pdev, NSP32_SG_TABLE_SIZE,
 			    data->sg_list, data->sg_paddr);
 
  free_autoparam:
-	pci_free_consistent(PCIDEV, sizeof(nsp32_autoparam),
+	pci_free_consistent(pdev, sizeof(nsp32_autoparam),
 			    data->autoparam, data->auto_paddr);
 	
  scsi_unregister:
 	scsi_host_put(host);
 
  err:
-	return DETECT_NG;
+	return 1;
 }
-#undef DETECT_OK
-#undef DETECT_NG
-#undef PCIDEV
 
 static int nsp32_release(struct Scsi_Host *host)
 {
@@ -3525,11 +3454,7 @@ static int __devinit nsp32_probe(struct 
 
 	pci_set_master(pdev);
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	ret = nsp32_detect(pdev);
-#else
-	ret = scsi_register_host(&nsp32_template);
-#endif
 
 	nsp32_msg(KERN_INFO, "irq: %i mmio: %p+0x%lx slot: %s model: %s",
 		  pdev->irq,
@@ -3544,25 +3469,17 @@ static int __devinit nsp32_probe(struct 
 
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
 
-
-
 static struct pci_driver nsp32_driver = {
 	.name		= "nsp32",
 	.id_table	= nsp32_pci_table,
_

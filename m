From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Tue, 25 Apr 2017 00:07:21 -0700
Message-ID: <20170425070721.GA13214@infradead.org>
References: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1170624AbdDYHHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 03:07:32 -0400
Content-Disposition: inline
In-Reply-To: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Cc: Dave Carroll <david.carroll@microsemi.com>, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

On Wed, Apr 05, 2017 at 04:14:16PM +0530, Mahesh Rajashekhara wrote:
> There were pci_alloc_consistent() failures on ARM64 platform.
> Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.
> 
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
> ---
> v2:
>  - Removed platform specific MACRO and call dma_*_coherent routines directly.
>  - Removed all the casts to and from void * in the arguments and return values 

The indentation is weird, and you're also adding memsets of the
allocations which is a behavior change.  Please take a look at the the
attached version that fixes this up.

If you really need the zeroing please send an additional patch to switch
to dma_zalloc_coherent.

---
>From 522b355c4fe021822d385332de525c7de5c2b290 Mon Sep 17 00:00:00 2001
From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Date: Wed, 5 Apr 2017 16:14:16 +0530
Subject: aacraid: pci_alloc_consistent() failures on ARM64

There were pci_alloc_consistent() failures on ARM64 platform.
Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.

Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
[hch: tweaked indentation, removed memsets]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aacraid/aachba.c   | 13 ++++++-------
 drivers/scsi/aacraid/commctrl.c |  6 ++++--
 drivers/scsi/aacraid/comminit.c |  3 +--
 drivers/scsi/aacraid/commsup.c  | 20 +++++++++++---------
 drivers/scsi/aacraid/linit.c    |  8 ++++----
 drivers/scsi/aacraid/rx.c       | 16 +++++++++-------
 6 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index e3e93def722b..43d88389e899 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1678,8 +1678,8 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 			sizeof(struct sgentry) + sizeof(struct sgentry64);
 	datasize = sizeof(struct aac_ciss_identify_pd);
 
-	identify_resp =  pci_alloc_consistent(dev->pdev, datasize, &addr);
-
+	identify_resp = dma_alloc_coherent(&dev->pdev->dev, datasize, &addr,
+					   GFP_KERNEL);
 	if (!identify_resp)
 		goto fib_free_ptr;
 
@@ -1720,7 +1720,7 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 		dev->hba_map[bus][target].qd_limit =
 			identify_resp->current_queue_depth_limit;
 
-	pci_free_consistent(dev->pdev, datasize, (void *)identify_resp, addr);
+	dma_free_coherent(&dev->pdev->dev, datasize, identify_resp, addr);
 
 	aac_fib_complete(fibptr);
 
@@ -1814,9 +1814,8 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 	datasize = sizeof(struct aac_ciss_phys_luns_resp)
 			+ (AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
 
-	phys_luns = (struct aac_ciss_phys_luns_resp *) pci_alloc_consistent(
-			dev->pdev, datasize, &addr);
-
+	phys_luns = dma_alloc_coherent(&dev->pdev->dev, datasize, &addr,
+				       GFP_KERNEL);
 	if (phys_luns == NULL) {
 		rcode = -ENOMEM;
 		goto err_out;
@@ -1861,7 +1860,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 		aac_update_hba_map(dev, phys_luns, rescan);
 	}
 
-	pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
+	dma_free_coherent(&dev->pdev->dev, datasize, phys_luns, addr);
 err_out:
 	return rcode;
 }
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index f6afd50579c0..d2f8d5954840 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -100,7 +100,8 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 			goto cleanup;
 		}
 
-		kfib = pci_alloc_consistent(dev->pdev, size, &daddr);
+		kfib = dma_alloc_coherent(&dev->pdev->dev, size, &daddr,
+					  GFP_KERNEL);
 		if (!kfib) {
 			retval = -ENOMEM;
 			goto cleanup;
@@ -160,7 +161,8 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		retval = -EFAULT;
 cleanup:
 	if (hw_fib) {
-		pci_free_consistent(dev->pdev, size, kfib, fibptr->hw_fib_pa);
+		dma_free_coherent(&dev->pdev->dev, size, kfib,
+				  fibptr->hw_fib_pa);
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib_va = hw_fib;
 	}
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 35607005f7e1..1151505853cf 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -99,8 +99,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	size = fibsize + aac_init_size + commsize + commalign +
 			printfbufsiz + host_rrq_size;
 
-	base = pci_alloc_consistent(dev->pdev, size, &phys);
-
+	base = dma_alloc_coherent(&dev->pdev->dev, size, &phys, GFP_KERNEL);
 	if (base == NULL) {
 		printk(KERN_ERR "aacraid: unable to create mapping.\n");
 		return 0;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3ad04293487..d08920d4b92c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -73,13 +73,13 @@ static int fib_map_alloc(struct aac_dev *dev)
 	}
 
 	dprintk((KERN_INFO
-	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
-	  dev->pdev, dev->max_cmd_size, dev->scsi_host_ptr->can_queue,
+	  "allocate hardware fibs dma_alloc_coherent(%p, %d * (%d + %d), %p)\n",
+	  &dev->pdev->dev, dev->max_cmd_size, dev->scsi_host_ptr->can_queue,
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
-	dev->hw_fib_va = pci_alloc_consistent(dev->pdev,
+	dev->hw_fib_va = dma_alloc_coherent(&dev->pdev->dev,
 		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
 		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
-		&dev->hw_fib_pa);
+		&dev->hw_fib_pa, GFP_KERNEL);
 	if (dev->hw_fib_va == NULL)
 		return -ENOMEM;
 	return 0;
@@ -106,8 +106,8 @@ void aac_fib_map_free(struct aac_dev *dev)
 	fib_size = dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	alloc_size = fib_size * num_fibs + ALIGN32 - 1;
 
-	pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
-							dev->hw_fib_pa);
+	dma_free_coherent(&dev->pdev->dev, alloc_size, dev->hw_fib_va,
+			  dev->hw_fib_pa);
 
 	dev->hw_fib_va = NULL;
 	dev->hw_fib_pa = 0;
@@ -1571,7 +1571,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * case.
 	 */
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
+			  aac->comm_phys);
 	aac->comm_addr = NULL;
 	aac->comm_phys = 0;
 	kfree(aac->queues);
@@ -2320,7 +2321,8 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	if (!fibptr)
 		goto out;
 
-	dma_buf = pci_alloc_consistent(dev->pdev, datasize, &addr);
+	dma_buf = dma_alloc_coherent(&dev->pdev->dev, datasize, &addr,
+				     GFP_KERNEL);
 	if (!dma_buf)
 		goto fib_free_out;
 
@@ -2355,7 +2357,7 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	ret = aac_fib_send(ScsiPortCommand64, fibptr, sizeof(struct aac_srb),
 				FsaNormal, 1, 1, NULL, NULL);
 
-	pci_free_consistent(dev->pdev, datasize, (void *)dma_buf, addr);
+	dma_free_coherent(&dev->pdev->dev, datasize, dma_buf, addr);
 
 	/*
 	 * Do not set XferState to zero unless
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 520ada8266af..372a07533026 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1592,8 +1592,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
  out_unmap:
 	aac_fib_map_free(aac);
 	if (aac->comm_addr)
-		pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
-		  aac->comm_phys);
+		dma_free_coherent(&aac->pdev->dev, aac->comm_size,
+				  aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
 	kfree(aac->fibs);
@@ -1729,8 +1729,8 @@ static void aac_remove_one(struct pci_dev *pdev)
 
 	__aac_shutdown(aac);
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
-			aac->comm_phys);
+	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
+			  aac->comm_phys);
 	kfree(aac->queues);
 
 	aac_adapter_ioremap(aac, 0);
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 5d19c31e3bba..93ef7c37e568 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -355,14 +355,16 @@ static int aac_rx_check_health(struct aac_dev *dev)
 
 		if (likely((status & 0xFF000000L) == 0xBC000000L))
 			return (status >> 16) & 0xFF;
-		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
+		buffer = dma_alloc_coherent(&dev->pdev->dev, 512, &baddr,
+					    GFP_KERNEL);
 		ret = -2;
 		if (unlikely(buffer == NULL))
 			return ret;
-		post = pci_alloc_consistent(dev->pdev,
-		  sizeof(struct POSTSTATUS), &paddr);
+		post = dma_alloc_coherent(&dev->pdev->dev,
+					  sizeof(struct POSTSTATUS), &paddr,
+					  GFP_KERNEL);
 		if (unlikely(post == NULL)) {
-			pci_free_consistent(dev->pdev, 512, buffer, baddr);
+			dma_free_coherent(&dev->pdev->dev, 512, buffer, baddr);
 			return ret;
 		}
 		memset(buffer, 0, 512);
@@ -371,13 +373,13 @@ static int aac_rx_check_health(struct aac_dev *dev)
 		rx_writel(dev, MUnit.IMRx[0], paddr);
 		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, 0, 0, 0, 0, 0,
 		  NULL, NULL, NULL, NULL, NULL);
-		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
-		  post, paddr);
+		dma_free_coherent(&dev->pdev->dev, sizeof(struct POSTSTATUS),
+				  post, paddr);
 		if (likely((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X')))) {
 			ret = (hex_to_bin(buffer[2]) << 4) +
 				hex_to_bin(buffer[3]);
 		}
-		pci_free_consistent(dev->pdev, 512, buffer, baddr);
+		dma_free_coherent(&dev->pdev->dev, 512, buffer, baddr);
 		return ret;
 	}
 	/*
-- 
2.11.0

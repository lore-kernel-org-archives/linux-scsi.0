From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Subject: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Wed, 5 Apr 2017 16:14:16 +0530
Message-ID: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0047.outbound.protection.outlook.com ([104.47.37.47]:3349
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933426AbdDEKoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 06:44:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

There were pci_alloc_consistent() failures on ARM64 platform.
Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.

Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
---
v2:
 - Removed platform specific MACRO and call dma_*_coherent routines directly.
 - Removed all the casts to and from void * in the arguments and return values 

 drivers/scsi/aacraid/aachba.c   | 23 ++++++++++++++++++-----
 drivers/scsi/aacraid/commctrl.c | 11 +++++++++--
 drivers/scsi/aacraid/comminit.c |  6 +++++-
 drivers/scsi/aacraid/commsup.c  | 30 +++++++++++++++++++++---------
 drivers/scsi/aacraid/linit.c    | 12 ++++++++----
 drivers/scsi/aacraid/rx.c       | 28 +++++++++++++++++++++-------
 6 files changed, 82 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index e3e93de..e89fe09 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1678,11 +1678,15 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 			sizeof(struct sgentry) + sizeof(struct sgentry64);
 	datasize = sizeof(struct aac_ciss_identify_pd);
 
-	identify_resp =  pci_alloc_consistent(dev->pdev, datasize, &addr);
+	identify_resp = dma_alloc_coherent(&dev->pdev->dev,
+					   datasize,
+					   &addr,
+					   GFP_KERNEL);
 
 	if (!identify_resp)
 		goto fib_free_ptr;
 
+	memset(identify_resp, 0, datasize);
 	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
 	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_target);
 
@@ -1720,7 +1724,10 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 		dev->hba_map[bus][target].qd_limit =
 			identify_resp->current_queue_depth_limit;
 
-	pci_free_consistent(dev->pdev, datasize, (void *)identify_resp, addr);
+	dma_free_coherent(&dev->pdev->dev,
+			  datasize,
+			  identify_resp,
+			  addr);
 
 	aac_fib_complete(fibptr);
 
@@ -1814,14 +1821,17 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 	datasize = sizeof(struct aac_ciss_phys_luns_resp)
 			+ (AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
 
-	phys_luns = (struct aac_ciss_phys_luns_resp *) pci_alloc_consistent(
-			dev->pdev, datasize, &addr);
+	phys_luns = dma_alloc_coherent(&dev->pdev->dev,
+				       datasize,
+				       &addr,
+				       GFP_KERNEL);
 
 	if (phys_luns == NULL) {
 		rcode = -ENOMEM;
 		goto err_out;
 	}
 
+	memset(phys_luns, 0, datasize);
 	vbus = (u32) le16_to_cpu(
 			dev->supplement_adapter_info.virt_device_bus);
 	vid = (u32) le16_to_cpu(
@@ -1861,7 +1871,10 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 		aac_update_hba_map(dev, phys_luns, rescan);
 	}
 
-	pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
+	dma_free_coherent(&dev->pdev->dev,
+			  datasize,
+			  phys_luns,
+			  addr);
 err_out:
 	return rcode;
 }
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index f6afd50..93df1d1 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -100,12 +100,16 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 			goto cleanup;
 		}
 
-		kfib = pci_alloc_consistent(dev->pdev, size, &daddr);
+		kfib = dma_alloc_coherent(&dev->pdev->dev,
+					  size,
+					  &daddr,
+					  GFP_KERNEL);
 		if (!kfib) {
 			retval = -ENOMEM;
 			goto cleanup;
 		}
 
+		memset(kfib, 0, size);
 		/* Highjack the hw_fib */
 		hw_fib = fibptr->hw_fib_va;
 		hw_fib_pa = fibptr->hw_fib_pa;
@@ -160,7 +164,10 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		retval = -EFAULT;
 cleanup:
 	if (hw_fib) {
-		pci_free_consistent(dev->pdev, size, kfib, fibptr->hw_fib_pa);
+		dma_free_coherent(&dev->pdev->dev,
+				  size,
+				  kfib,
+				  fibptr->hw_fib_pa);
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib_va = hw_fib;
 	}
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 3560700..0d83a73 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -99,13 +99,17 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	size = fibsize + aac_init_size + commsize + commalign +
 			printfbufsiz + host_rrq_size;
 
-	base = pci_alloc_consistent(dev->pdev, size, &phys);
+	base = dma_alloc_coherent(&dev->pdev->dev,
+				  size,
+				  &phys,
+				  GFP_KERNEL);
 
 	if (base == NULL) {
 		printk(KERN_ERR "aacraid: unable to create mapping.\n");
 		return 0;
 	}
 
+	memset(base, 0, size);
 	dev->comm_addr = (void *)base;
 	dev->comm_phys = phys;
 	dev->comm_size = size;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3ad042..669b72b 100644
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
@@ -106,8 +106,10 @@ void aac_fib_map_free(struct aac_dev *dev)
 	fib_size = dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	alloc_size = fib_size * num_fibs + ALIGN32 - 1;
 
-	pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
-							dev->hw_fib_pa);
+	dma_free_coherent(&dev->pdev->dev,
+			  alloc_size,
+			  dev->hw_fib_va,
+			  dev->hw_fib_pa);
 
 	dev->hw_fib_va = NULL;
 	dev->hw_fib_pa = 0;
@@ -1571,7 +1573,10 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * case.
 	 */
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	dma_free_coherent(&aac->pdev->dev,
+			  aac->comm_size,
+			  aac->comm_addr,
+			  aac->comm_phys);
 	aac->comm_addr = NULL;
 	aac->comm_phys = 0;
 	kfree(aac->queues);
@@ -2320,10 +2325,14 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	if (!fibptr)
 		goto out;
 
-	dma_buf = pci_alloc_consistent(dev->pdev, datasize, &addr);
+	dma_buf = dma_alloc_coherent(&dev->pdev->dev,
+				     datasize,
+				     &addr,
+				     GFP_KERNEL);
 	if (!dma_buf)
 		goto fib_free_out;
 
+	memset(dma_buf, 0, datasize);
 	aac_fib_init(fibptr);
 
 	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
@@ -2355,7 +2364,10 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	ret = aac_fib_send(ScsiPortCommand64, fibptr, sizeof(struct aac_srb),
 				FsaNormal, 1, 1, NULL, NULL);
 
-	pci_free_consistent(dev->pdev, datasize, (void *)dma_buf, addr);
+	dma_free_coherent(&dev->pdev->dev,
+			  datasize,
+			  dma_buf,
+			  addr);
 
 	/*
 	 * Do not set XferState to zero unless
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 520ada8..ba7d394 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1592,8 +1592,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
  out_unmap:
 	aac_fib_map_free(aac);
 	if (aac->comm_addr)
-		pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
-		  aac->comm_phys);
+		dma_free_coherent(&aac->pdev->dev,
+				  aac->comm_size,
+				  aac->comm_addr,
+				  aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
 	kfree(aac->fibs);
@@ -1729,8 +1731,10 @@ static void aac_remove_one(struct pci_dev *pdev)
 
 	__aac_shutdown(aac);
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
-			aac->comm_phys);
+	dma_free_coherent(&aac->pdev->dev,
+			  aac->comm_size,
+			  aac->comm_addr,
+			  aac->comm_phys);
 	kfree(aac->queues);
 
 	aac_adapter_ioremap(aac, 0);
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 5d19c31..6d14b19 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -355,29 +355,43 @@ static int aac_rx_check_health(struct aac_dev *dev)
 
 		if (likely((status & 0xFF000000L) == 0xBC000000L))
 			return (status >> 16) & 0xFF;
-		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
+		buffer = dma_alloc_coherent(&dev->pdev->dev,
+					    512,
+					    &baddr,
+					    GFP_KERNEL);
 		ret = -2;
 		if (unlikely(buffer == NULL))
 			return ret;
-		post = pci_alloc_consistent(dev->pdev,
-		  sizeof(struct POSTSTATUS), &paddr);
+		post = dma_alloc_coherent(&dev->pdev->dev,
+					  sizeof(struct POSTSTATUS),
+					  &paddr,
+					  GFP_KERNEL);
 		if (unlikely(post == NULL)) {
-			pci_free_consistent(dev->pdev, 512, buffer, baddr);
+			dma_free_coherent(&dev->pdev->dev,
+					  512,
+					  buffer,
+					  baddr);
 			return ret;
 		}
 		memset(buffer, 0, 512);
+		memset(post, 0, sizeof(struct POSTSTATUS));
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
 		post->Post_Address = cpu_to_le32(baddr);
 		rx_writel(dev, MUnit.IMRx[0], paddr);
 		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, 0, 0, 0, 0, 0,
 		  NULL, NULL, NULL, NULL, NULL);
-		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
-		  post, paddr);
+		dma_free_coherent(&dev->pdev->dev,
+				  sizeof(struct POSTSTATUS),
+				  post,
+				  paddr);
 		if (likely((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X')))) {
 			ret = (hex_to_bin(buffer[2]) << 4) +
 				hex_to_bin(buffer[3]);
 		}
-		pci_free_consistent(dev->pdev, 512, buffer, baddr);
+		dma_free_coherent(&dev->pdev->dev,
+				  512,
+				  buffer,
+				  baddr);
 		return ret;
 	}
 	/*
-- 
2.7.4

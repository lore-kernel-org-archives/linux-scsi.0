From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Subject: [PATCH 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Tue, 4 Apr 2017 12:23:19 +0530
Message-ID: <1491288799-18659-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:32854
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750926AbdDDGx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 02:53:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

There were pci_alloc_consistent() failures on ARM64 platform.
Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.

Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c   | 13 +++++++++----
 drivers/scsi/aacraid/aacraid.h  | 22 ++++++++++++++++++++++
 drivers/scsi/aacraid/commctrl.c |  7 +++++--
 drivers/scsi/aacraid/comminit.c |  4 ++--
 drivers/scsi/aacraid/commsup.c  | 16 ++++++++++------
 drivers/scsi/aacraid/linit.c    |  8 +++++---
 drivers/scsi/aacraid/rx.c       | 11 ++++++-----
 7 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index e3e93de..d07da1a 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1678,11 +1678,12 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 			sizeof(struct sgentry) + sizeof(struct sgentry64);
 	datasize = sizeof(struct aac_ciss_identify_pd);
 
-	identify_resp =  pci_alloc_consistent(dev->pdev, datasize, &addr);
+	identify_resp =  aac_pci_alloc_consistent(dev->pdev, datasize, &addr);
 
 	if (!identify_resp)
 		goto fib_free_ptr;
 
+	memset(identify_resp, 0, datasize);
 	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
 	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_target);
 
@@ -1720,7 +1721,10 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 		dev->hba_map[bus][target].qd_limit =
 			identify_resp->current_queue_depth_limit;
 
-	pci_free_consistent(dev->pdev, datasize, (void *)identify_resp, addr);
+	aac_pci_free_consistent(dev->pdev,
+				datasize,
+				(void *)identify_resp,
+				addr);
 
 	aac_fib_complete(fibptr);
 
@@ -1814,7 +1818,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 	datasize = sizeof(struct aac_ciss_phys_luns_resp)
 			+ (AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
 
-	phys_luns = (struct aac_ciss_phys_luns_resp *) pci_alloc_consistent(
+	phys_luns = (struct aac_ciss_phys_luns_resp *) aac_pci_alloc_consistent(
 			dev->pdev, datasize, &addr);
 
 	if (phys_luns == NULL) {
@@ -1822,6 +1826,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 		goto err_out;
 	}
 
+	memset(phys_luns, 0, datasize);
 	vbus = (u32) le16_to_cpu(
 			dev->supplement_adapter_info.virt_device_bus);
 	vid = (u32) le16_to_cpu(
@@ -1861,7 +1866,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 		aac_update_hba_map(dev, phys_luns, rescan);
 	}
 
-	pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
+	aac_pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
 err_out:
 	return rcode;
 }
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d036a80..12121d6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2692,4 +2692,26 @@ extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
 extern int aac_fib_dump;
+#if defined(CONFIG_ARM64)
+static inline void *
+aac_pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
+		     dma_addr_t *dma_handle) {
+	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
+				  size,
+				  dma_handle,
+				  GFP_KERNEL);
+}
+#else
+static inline void *
+aac_pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
+		     dma_addr_t *dma_handle) {
+	return pci_alloc_consistent(hwdev, size, dma_handle);
+}
+#endif
+static inline void
+aac_pci_free_consistent(struct pci_dev *hwdev, size_t size,
+			void *vaddr, dma_addr_t dma_handle)
+{
+	pci_free_consistent(hwdev, size, vaddr, dma_handle);
+}
 #endif
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index f6afd50..7d1757a 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -100,12 +100,13 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 			goto cleanup;
 		}
 
-		kfib = pci_alloc_consistent(dev->pdev, size, &daddr);
+		kfib = aac_pci_alloc_consistent(dev->pdev, size, &daddr);
 		if (!kfib) {
 			retval = -ENOMEM;
 			goto cleanup;
 		}
 
+		memset(kfib, 0, size);
 		/* Highjack the hw_fib */
 		hw_fib = fibptr->hw_fib_va;
 		hw_fib_pa = fibptr->hw_fib_pa;
@@ -160,7 +161,9 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		retval = -EFAULT;
 cleanup:
 	if (hw_fib) {
-		pci_free_consistent(dev->pdev, size, kfib, fibptr->hw_fib_pa);
+		aac_pci_free_consistent(dev->pdev,
+					size, kfib,
+					fibptr->hw_fib_pa);
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib_va = hw_fib;
 	}
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 3560700..c06977c 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -99,13 +99,13 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	size = fibsize + aac_init_size + commsize + commalign +
 			printfbufsiz + host_rrq_size;
 
-	base = pci_alloc_consistent(dev->pdev, size, &phys);
+	base = aac_pci_alloc_consistent(dev->pdev, size, &phys);
 
 	if (base == NULL) {
 		printk(KERN_ERR "aacraid: unable to create mapping.\n");
 		return 0;
 	}
-
+	memset(base, 0, size);
 	dev->comm_addr = (void *)base;
 	dev->comm_phys = phys;
 	dev->comm_size = size;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a3ad042..c34aa5f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -73,10 +73,10 @@ static int fib_map_alloc(struct aac_dev *dev)
 	}
 
 	dprintk((KERN_INFO
-	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
+	  "allocate hardware fibs aac_pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
 	  dev->pdev, dev->max_cmd_size, dev->scsi_host_ptr->can_queue,
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
-	dev->hw_fib_va = pci_alloc_consistent(dev->pdev,
+	dev->hw_fib_va = aac_pci_alloc_consistent(dev->pdev,
 		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
 		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
 		&dev->hw_fib_pa);
@@ -106,7 +106,7 @@ void aac_fib_map_free(struct aac_dev *dev)
 	fib_size = dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	alloc_size = fib_size * num_fibs + ALIGN32 - 1;
 
-	pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
+	aac_pci_free_consistent(dev->pdev, alloc_size, dev->hw_fib_va,
 							dev->hw_fib_pa);
 
 	dev->hw_fib_va = NULL;
@@ -1571,7 +1571,10 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * case.
 	 */
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	aac_pci_free_consistent(aac->pdev,
+				aac->comm_size,
+				aac->comm_addr,
+				aac->comm_phys);
 	aac->comm_addr = NULL;
 	aac->comm_phys = 0;
 	kfree(aac->queues);
@@ -2320,10 +2323,11 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	if (!fibptr)
 		goto out;
 
-	dma_buf = pci_alloc_consistent(dev->pdev, datasize, &addr);
+	dma_buf = aac_pci_alloc_consistent(dev->pdev, datasize, &addr);
 	if (!dma_buf)
 		goto fib_free_out;
 
+	memset(dma_buf, 0, datasize);
 	aac_fib_init(fibptr);
 
 	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
@@ -2355,7 +2359,7 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	ret = aac_fib_send(ScsiPortCommand64, fibptr, sizeof(struct aac_srb),
 				FsaNormal, 1, 1, NULL, NULL);
 
-	pci_free_consistent(dev->pdev, datasize, (void *)dma_buf, addr);
+	aac_pci_free_consistent(dev->pdev, datasize, (void *)dma_buf, addr);
 
 	/*
 	 * Do not set XferState to zero unless
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 520ada8..cd721e9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1592,8 +1592,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
  out_unmap:
 	aac_fib_map_free(aac);
 	if (aac->comm_addr)
-		pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
-		  aac->comm_phys);
+		aac_pci_free_consistent(aac->pdev,
+					aac->comm_size,
+					aac->comm_addr,
+					aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
 	kfree(aac->fibs);
@@ -1729,7 +1731,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 
 	__aac_shutdown(aac);
 	aac_fib_map_free(aac);
-	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
+	aac_pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
 			aac->comm_phys);
 	kfree(aac->queues);
 
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 5d19c31..6c1f633 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -355,29 +355,30 @@ static int aac_rx_check_health(struct aac_dev *dev)
 
 		if (likely((status & 0xFF000000L) == 0xBC000000L))
 			return (status >> 16) & 0xFF;
-		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
+		buffer = aac_pci_alloc_consistent(dev->pdev, 512, &baddr);
 		ret = -2;
 		if (unlikely(buffer == NULL))
 			return ret;
-		post = pci_alloc_consistent(dev->pdev,
+		post = aac_pci_alloc_consistent(dev->pdev,
 		  sizeof(struct POSTSTATUS), &paddr);
 		if (unlikely(post == NULL)) {
-			pci_free_consistent(dev->pdev, 512, buffer, baddr);
+			aac_pci_free_consistent(dev->pdev, 512, buffer, baddr);
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
+		aac_pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
 		if (likely((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X')))) {
 			ret = (hex_to_bin(buffer[2]) << 4) +
 				hex_to_bin(buffer[3]);
 		}
-		pci_free_consistent(dev->pdev, 512, buffer, baddr);
+		aac_pci_free_consistent(dev->pdev, 512, buffer, baddr);
 		return ret;
 	}
 	/*
-- 
2.7.4

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.8-rc2
Date: Fri, 19 Aug 2016 07:40:15 -0700
Message-ID: <1471617615.2440.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six fairly small fixes.  The ipr, mpt3sas and ses ones all trigger
oopses.  The megaraid one fixes an attach failure on io mapped only
cards, the fcoe one is an obvious problem in the error path and the
aacraid one is a theoretical security issue (ability to trick the
kernel into a buffer overrun).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      ipr: Fix sync scsi scan

Calvin Owens (1):
      ses: Fix racy cleanup of /sys in remove_dev()

Dave Carroll (1):
      aacraid: Check size values after double-fetch from user

Greg Edwards (1):
      mpt3sas: Fix resume on WarpDrive flash cards

Wei Yongjun (1):
      fcoe: Use kfree_skb() instead of kfree()

Yinghai Lu (1):
      megaraid_sas: Fix probing cards without io port

And the diffstat:

 drivers/scsi/aacraid/commctrl.c             | 13 +++++++++++--
 drivers/scsi/fcoe/fcoe_ctlr.c               |  2 +-
 drivers/scsi/ipr.c                          | 11 ++++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 22 +++++++++++-----------
 drivers/scsi/ses.c                          |  3 ++-
 7 files changed, 35 insertions(+), 24 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index b381b37..5648b71 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -63,7 +63,7 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	struct fib *fibptr;
 	struct hw_fib * hw_fib = (struct hw_fib *)0;
 	dma_addr_t hw_fib_pa = (dma_addr_t)0LL;
-	unsigned size;
+	unsigned int size, osize;
 	int retval;
 
 	if (dev->in_reset) {
@@ -87,7 +87,8 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	 *	will not overrun the buffer when we copy the memory. Return
 	 *	an error if we would.
 	 */
-	size = le16_to_cpu(kfib->header.Size) + sizeof(struct aac_fibhdr);
+	osize = size = le16_to_cpu(kfib->header.Size) +
+		sizeof(struct aac_fibhdr);
 	if (size < le16_to_cpu(kfib->header.SenderSize))
 		size = le16_to_cpu(kfib->header.SenderSize);
 	if (size > dev->max_fib_size) {
@@ -118,6 +119,14 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		goto cleanup;
 	}
 
+	/* Sanity check the second copy */
+	if ((osize != le16_to_cpu(kfib->header.Size) +
+		sizeof(struct aac_fibhdr))
+		|| (size < le16_to_cpu(kfib->header.SenderSize))) {
+		retval = -EINVAL;
+		goto cleanup;
+	}
+
 	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
 		aac_adapter_interrupt(dev);
 		/*
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a569c65..dcf3653 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2923,7 +2923,7 @@ static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	mutex_unlock(&fip->ctlr_mutex);
 
 drop:
-	kfree(skb);
+	kfree_skb(skb);
 	return rc;
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index bf85974..17d04c7 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10410,8 +10410,11 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		__ipr_remove(pdev);
 		return rc;
 	}
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	ioa_cfg->scan_enabled = 1;
+	schedule_work(&ioa_cfg->work_q);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 
-	scsi_scan_host(ioa_cfg->host);
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
@@ -10421,10 +10424,8 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		}
 	}
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	ioa_cfg->scan_enabled = 1;
-	schedule_work(&ioa_cfg->work_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	scsi_scan_host(ioa_cfg->host);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2dab3dc..c1ed25a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5037,7 +5037,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
-	if (pci_request_selected_regions(instance->pdev, instance->bar,
+	if (pci_request_selected_regions(instance->pdev, 1<<instance->bar,
 					 "megasas: LSI")) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO memory region busy!\n");
 		return -EBUSY;
@@ -5339,7 +5339,7 @@ fail_ready_state:
 	iounmap(instance->reg_set);
 
       fail_ioremap:
-	pci_release_selected_regions(instance->pdev, instance->bar);
+	pci_release_selected_regions(instance->pdev, 1<<instance->bar);
 
 	return -EINVAL;
 }
@@ -5360,7 +5360,7 @@ static void megasas_release_mfi(struct megasas_instance *instance)
 
 	iounmap(instance->reg_set);
 
-	pci_release_selected_regions(instance->pdev, instance->bar);
+	pci_release_selected_regions(instance->pdev, 1<<instance->bar);
 }
 
 /**
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ec83754..52d8bbf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2603,7 +2603,7 @@ megasas_release_fusion(struct megasas_instance *instance)
 
 	iounmap(instance->reg_set);
 
-	pci_release_selected_regions(instance->pdev, instance->bar);
+	pci_release_selected_regions(instance->pdev, 1<<instance->bar);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 751f13e..750f82c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2188,6 +2188,17 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	} else
 		ioc->msix96_vector = 0;
 
+	if (ioc->is_warpdrive) {
+		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
+		    &ioc->chip->ReplyPostHostIndex;
+
+		for (i = 1; i < ioc->cpu_msix_table_sz; i++)
+			ioc->reply_post_host_index[i] =
+			(resource_size_t __iomem *)
+			((u8 __iomem *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
+			* 4)));
+	}
+
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
 		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
 		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
@@ -5280,17 +5291,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	if (ioc->is_warpdrive) {
-		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
-		    &ioc->chip->ReplyPostHostIndex;
-
-		for (i = 1; i < ioc->cpu_msix_table_sz; i++)
-			ioc->reply_post_host_index[i] =
-			(resource_size_t __iomem *)
-			((u8 __iomem *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
-			* 4)));
-	}
-
 	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
 	if (r)
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 53ef1cb..0e8601a 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -778,6 +778,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	if (!edev)
 		return;
 
+	enclosure_unregister(edev);
+
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
@@ -789,7 +791,6 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
-	enclosure_unregister(edev);
 }
 
 static void ses_intf_remove(struct device *cdev,

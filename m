From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 3/3] fnic: Use shost_printk and print host no in print messages
Date: Wed, 25 Mar 2009 10:45:50 -0700
Message-ID: <20090325174505.21346.60368.stgit@feynman.nuovasystems.com>
References: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:41581 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758525AbZCYRpw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 13:45:52 -0400
In-Reply-To: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |   16 ++--
 drivers/scsi/fnic/fnic_fcs.c  |   38 +++++-----
 drivers/scsi/fnic/fnic_isr.c  |   15 ++--
 drivers/scsi/fnic/fnic_main.c |  116 ++++++++++++++++-------------
 drivers/scsi/fnic/fnic_res.c  |   80 ++++++++++++--------
 drivers/scsi/fnic/fnic_scsi.c |  164 ++++++++++++++++++++++-------------------
 6 files changed, 234 insertions(+), 195 deletions(-)


diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 13fa4c5..fc6d720 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -94,21 +94,21 @@ do {								\
 		} while (0);					\
 } while (0)
 
-#define FNIC_MAIN_DBG(kern_level, fmt, args...)		\
+#define FNIC_MAIN_DBG(kern_level, host, fmt, args...)		\
 	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
-			 printk(kern_level fmt, ##args);)
+			 shost_printk(kern_level, host, fmt, ##args);)
 
-#define FNIC_FCS_DBG(kern_level, fmt, args...)			\
+#define FNIC_FCS_DBG(kern_level, host, fmt, args...)		\
 	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
-			 printk(kern_level fmt, ##args);)
+			 shost_printk(kern_level, host, fmt, ##args);)
 
-#define FNIC_SCSI_DBG(kern_level, fmt, args...)			\
+#define FNIC_SCSI_DBG(kern_level, host, fmt, args...)		\
 	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,			\
-			 printk(kern_level fmt, ##args);)
+			 shost_printk(kern_level, host, fmt, ##args);)
 
-#define FNIC_ISR_DBG(kern_level, fmt, args...)			\
+#define FNIC_ISR_DBG(kern_level, host, fmt, args...)		\
 	FNIC_CHECK_LOGGING(FNIC_ISR_LOGGING,			\
-			 printk(kern_level fmt, ##args);)
+			 shost_printk(kern_level, host, fmt, ##args);)
 
 extern const char *fnic_state_str[];
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 9233b8e..9cb15fe 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -66,11 +66,11 @@ void fnic_handle_link(struct work_struct *work)
 				/* UP -> DOWN -> UP */
 				fnic->lport->host_stats.link_failure_count++;
 				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-				FNIC_FCS_DBG(KERN_DEBUG, DFX "link down\n",
-					     fnic->fnic_no);
+				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+					     "link down\n");
 				fc_linkdown(fnic->lport);
-				FNIC_FCS_DBG(KERN_DEBUG, DFX "link up\n",
-					     fnic->fnic_no);
+				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+					     "link up\n");
 				fc_linkup(fnic->lport);
 			} else
 				/* UP -> UP */
@@ -79,13 +79,13 @@ void fnic_handle_link(struct work_struct *work)
 	} else if (fnic->link_status) {
 		/* DOWN -> UP */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, DFX "link up\n", fnic->fnic_no);
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link up\n");
 		fc_linkup(fnic->lport);
 	} else {
 		/* UP -> DOWN */
 		fnic->lport->host_stats.link_failure_count++;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, DFX "link down\n", fnic->fnic_no);
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link down\n");
 		fc_linkdown(fnic->lport);
 	}
 
@@ -194,9 +194,10 @@ static inline int fnic_handle_flogi_resp(struct fnic *fnic,
 		 * issued by libFC might have changed the fnic cached oxid
 		 */
 		if (fnic->flogi_oxid != ntohs(fh->fh_ox_id)) {
-			FNIC_FCS_DBG(KERN_DEBUG, DFX "Flogi response oxid not"
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				     "Flogi response oxid not"
 				     " matching cached oxid, dropping frame"
-				     "\n", fnic->fnic_no);
+				     "\n");
 			ret = -1;
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			dev_kfree_skb_irq(fp_skb(fp));
@@ -238,7 +239,8 @@ static inline int fnic_handle_flogi_resp(struct fnic *fnic,
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
 
 	} else {
-		FNIC_FCS_DBG(KERN_DEBUG, PFX "Unexpected fnic state %s while"
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Unexpected fnic state %s while"
 			     " processing flogi resp\n",
 			     fnic_state_to_str(fnic->state));
 		ret = -1;
@@ -358,16 +360,17 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 	} else {
 		/* wrong CQ type*/
-		printk(KERN_ERR DFX "fnic rq_cmpl wrong cq type x%x\n",
-		       fnic->fnic_no, type);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "fnic rq_cmpl wrong cq type x%x\n", type);
 		goto drop;
 	}
 
 	if (!fcs_ok || packet_error || !fcoe_fc_crc_ok || fcoe_enc_error) {
-		FNIC_FCS_DBG(KERN_DEBUG, DFX "fnic rq_cmpl fcoe x%x fcsok x%x"
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+			     "fnic rq_cmpl fcoe x%x fcsok x%x"
 			     " pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err"
 			     " x%x\n",
-			     fnic->fnic_no, fcoe, fcs_ok, packet_error,
+			     fcoe, fcs_ok, packet_error,
 			     fcoe_fc_crc_ok, fcoe_enc_error);
 		goto drop;
 	}
@@ -438,8 +441,9 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 		if (cur_work_done) {
 			err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 			if (err)
-				printk(KERN_ERR DFX "fnic_alloc_rq_frame"
-				       " cant alloc frame\n", fnic->fnic_no);
+				shost_printk(KERN_ERR, fnic->lport->host,
+					     "fnic_alloc_rq_frame cant alloc"
+					     " frame\n");
 		}
 		tot_rq_work_done += cur_work_done;
 	}
@@ -462,8 +466,8 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	len = FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
 	skb = dev_alloc_skb(len);
 	if (!skb) {
-		FNIC_FCS_DBG(KERN_DEBUG, DFX "Unable to allocate RQ sk_buff\n",
-			     fnic->fnic_no);
+		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Unable to allocate RQ sk_buff\n");
 		return -ENOMEM;
 	}
 	skb_reset_mac_header(skb);
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index b4f4771..f5cff08 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -202,8 +202,9 @@ int fnic_request_intr(struct fnic *fnic)
 					  fnic->msix[i].devname,
 					  fnic->msix[i].devid);
 			if (err) {
-				printk(KERN_ERR PFX "MSIX: request_irq"
-				       " failed %d\n", err);
+				shost_printk(KERN_ERR, fnic->lport->host,
+					     "MSIX: request_irq"
+					     " failed %d\n", err);
 				fnic_free_intr(fnic);
 				break;
 			}
@@ -253,8 +254,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 			fnic->intr_count = n + m + o + 1;
 			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
 
-			FNIC_ISR_DBG(KERN_DEBUG,
-				     PFX "Using MSI-X Interrupts\n");
+			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+				     "Using MSI-X Interrupts\n");
 			vnic_dev_set_intr_mode(fnic->vdev,
 					       VNIC_DEV_INTR_MODE_MSIX);
 			return 0;
@@ -280,7 +281,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->intr_count = 1;
 		fnic->err_intr_offset = 0;
 
-		FNIC_ISR_DBG(KERN_DEBUG, PFX "Using MSI Interrupts\n");
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Using MSI Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
 
 		return 0;
@@ -305,7 +307,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->cq_count = 3;
 		fnic->intr_count = 3;
 
-		FNIC_ISR_DBG(KERN_DEBUG, PFX "Using Legacy Interrupts\n");
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Using Legacy Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
 
 		return 0;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index e66d5d1..cdcb2b8 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -187,8 +187,9 @@ static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, DFX "fnic: Get vnic stats failed"
-			      " 0x%x", fnic->fnic_no, ret);
+		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
+			      "fnic: Get vnic stats failed"
+			      " 0x%x", ret);
 		return stats;
 	}
 	vs = fnic->stats;
@@ -214,22 +215,25 @@ void fnic_log_q_error(struct fnic *fnic)
 	for (i = 0; i < fnic->raw_wq_count; i++) {
 		error_status = ioread32(&fnic->wq[i].ctrl->error_status);
 		if (error_status)
-			printk(KERN_ERR DFX "WQ[%d] error_status"
-			       " %d\n", fnic->fnic_no, i, error_status);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "WQ[%d] error_status"
+				     " %d\n", i, error_status);
 	}
 
 	for (i = 0; i < fnic->rq_count; i++) {
 		error_status = ioread32(&fnic->rq[i].ctrl->error_status);
 		if (error_status)
-			printk(KERN_ERR DFX "RQ[%d] error_status"
-			       " %d\n", fnic->fnic_no, i, error_status);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "RQ[%d] error_status"
+				     " %d\n", i, error_status);
 	}
 
 	for (i = 0; i < fnic->wq_copy_count; i++) {
 		error_status = ioread32(&fnic->wq_copy[i].ctrl->error_status);
 		if (error_status)
-			printk(KERN_ERR DFX "CWQ[%d] error_status"
-			       " %d\n", fnic->fnic_no, i, error_status);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "CWQ[%d] error_status"
+				     " %d\n", i, error_status);
 	}
 }
 
@@ -263,9 +267,10 @@ static int fnic_notify_set(struct fnic *fnic)
 		err = vnic_dev_notify_set(fnic->vdev, FNIC_MSIX_ERR_NOTIFY);
 		break;
 	default:
-		printk(KERN_ERR DFX "Interrupt mode should be set up"
-		       " before devcmd notify set %d\n", fnic->fnic_no,
-		       vnic_dev_get_intr_mode(fnic->vdev));
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Interrupt mode should be set up"
+			     " before devcmd notify set %d\n",
+			     vnic_dev_get_intr_mode(fnic->vdev));
 		err = -1;
 		break;
 	}
@@ -452,7 +457,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 	err = scsi_init_shared_tag_map(host, FNIC_MAX_IO_REQ);
 	if (err) {
-		printk(KERN_ERR PFX "Unable to alloc shared tag map\n");
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Unable to alloc shared tag map\n");
 		goto err_out_free_hba;
 	}
 
@@ -463,15 +469,15 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR DFX "Cannot enable PCI device, aborting.\n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Cannot enable PCI device, aborting.\n");
 		goto err_out_free_hba;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		printk(KERN_ERR DFX "Cannot enable PCI resources, aborting\n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Cannot enable PCI resources, aborting\n");
 		goto err_out_disable_device;
 	}
 
@@ -485,31 +491,32 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	if (err) {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (err) {
-			printk(KERN_ERR DFX "No usable DMA configuration "
-			       "aborting\n", fnic->fnic_no);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "No usable DMA configuration "
+				     "aborting\n");
 			goto err_out_release_regions;
 		}
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 		if (err) {
-			printk(KERN_ERR DFX "Unable to obtain 32-bit DMA "
-			       "for consistent allocations, aborting.\n",
-			       fnic->fnic_no);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "Unable to obtain 32-bit DMA "
+				     "for consistent allocations, aborting.\n");
 			goto err_out_release_regions;
 		}
 	} else {
 		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
 		if (err) {
-			printk(KERN_ERR DFX "Unable to obtain 40-bit DMA "
-			       "for consistent allocations, aborting.\n",
-			       fnic->fnic_no);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "Unable to obtain 40-bit DMA "
+				     "for consistent allocations, aborting.\n");
 			goto err_out_release_regions;
 		}
 	}
 
 	/* Map vNIC resources from BAR0 */
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		printk(KERN_ERR DFX "BAR0 not memory-map'able, aborting.\n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "BAR0 not memory-map'able, aborting.\n");
 		err = -ENODEV;
 		goto err_out_release_regions;
 	}
@@ -519,16 +526,18 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fnic->bar0.len = pci_resource_len(pdev, 0);
 
 	if (!fnic->bar0.vaddr) {
-		printk(KERN_ERR DFX "Cannot memory-map BAR0 res hdr, "
-		       "aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Cannot memory-map BAR0 res hdr, "
+			     "aborting.\n");
 		err = -ENODEV;
 		goto err_out_release_regions;
 	}
 
 	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
 	if (!fnic->vdev) {
-		printk(KERN_ERR DFX "vNIC registration failed, "
-		       "aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vNIC registration failed, "
+			     "aborting.\n");
 		err = -ENODEV;
 		goto err_out_iounmap;
 	}
@@ -536,30 +545,31 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
 			    vnic_dev_open_done, 0);
 	if (err) {
-		printk(KERN_ERR DFX
-		       "vNIC dev open failed, aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vNIC dev open failed, aborting.\n");
 		goto err_out_vnic_unregister;
 	}
 
 	err = vnic_dev_init(fnic->vdev, 0);
 	if (err) {
-		printk(KERN_ERR DFX
-		       "vNIC dev init failed, aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vNIC dev init failed, aborting.\n");
 		goto err_out_dev_close;
 	}
 
 	err = vnic_dev_mac_addr(fnic->vdev, fnic->mac_addr);
 	if (err) {
-		printk(KERN_ERR DFX "vNIC get MAC addr failed \n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vNIC get MAC addr failed \n");
 		goto err_out_dev_close;
 	}
 
 	/* Get vNIC configuration */
 	err = fnic_get_vnic_config(fnic);
 	if (err) {
-		printk(KERN_ERR DFX "Get vNIC configuration failed, "
-		       "aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Get vNIC configuration failed, "
+			     "aborting.\n");
 		goto err_out_dev_close;
 	}
 	host->max_lun = fnic->config.luns_per_tgt;
@@ -569,21 +579,24 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 
 	err = fnic_set_intr_mode(fnic);
 	if (err) {
-		printk(KERN_ERR DFX "Failed to set intr mode, "
-		  "aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Failed to set intr mode, "
+			     "aborting.\n");
 		goto err_out_dev_close;
 	}
 
 	err = fnic_request_intr(fnic);
 	if (err) {
-		printk(KERN_ERR DFX "Unable to request irq.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Unable to request irq.\n");
 		goto err_out_clear_intr;
 	}
 
 	err = fnic_alloc_vnic_resources(fnic);
 	if (err) {
-		printk(KERN_ERR DFX "Failed to alloc vNIC resources, "
-		       "aborting.\n", fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Failed to alloc vNIC resources, "
+			     "aborting.\n");
 		goto err_out_free_intr;
 	}
 
@@ -635,9 +648,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	/* Setup notification buffer area */
 	err = fnic_notify_set(fnic);
 	if (err) {
-		printk(KERN_ERR DFX
-		       "Failed to alloc notify buffer, aborting.\n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Failed to alloc notify buffer, aborting.\n");
 		goto err_out_free_max_pool;
 	}
 
@@ -645,15 +657,13 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	setup_timer(&fnic->notify_timer,
 		    fnic_notify_timer, (unsigned long)fnic);
 
-	FNIC_MAIN_DBG(KERN_DEBUG, DFX "host no %d\n",
-		      fnic->fnic_no, host->host_no);
-
 	/* allocate RQ buffers and post them to RQ*/
 	for (i = 0; i < fnic->rq_count; i++) {
 		err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 		if (err) {
-			printk(KERN_ERR DFX "fnic_alloc_rq_frame can't alloc "
-			       "frame\n", fnic->fnic_no);
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "fnic_alloc_rq_frame can't alloc "
+				     "frame\n");
 			goto err_out_free_rq_buf;
 		}
 	}
@@ -664,8 +674,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	 */
 	err = scsi_add_host(lp->host, &pdev->dev);
 	if (err) {
-		printk(KERN_ERR DFX "fnic: scsi_add_host failed...exiting\n",
-		       fnic->fnic_no);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "fnic: scsi_add_host failed...exiting\n");
 		goto err_out_free_rq_buf;
 	}
 
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 95785f9..e2cef11 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -43,8 +43,9 @@ int fnic_get_vnic_config(struct fnic *fnic)
 				    offsetof(struct vnic_fc_config, m), \
 				    sizeof(c->m), &c->m); \
 		if (err) { \
-			printk(KERN_ERR PFX "Error getting %s, %d\n", #m, \
-			       err); \
+			shost_printk(KERN_ERR, fnic->lport->host, \
+				     "Error getting %s, %d\n", #m, \
+				     err); \
 			return err; \
 		} \
 	} while (0);
@@ -143,27 +144,37 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	c->intr_timer = min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
 	c->intr_timer_type = c->intr_timer_type;
 
-	printk(KERN_INFO PFX "vNIC MAC addr %02x:%02x:%02x:%02x:%02x:%02x "
-		"wq/wq_copy/rq %d/%d/%d\n",
-		fnic->mac_addr[0], fnic->mac_addr[1], fnic->mac_addr[2],
-		fnic->mac_addr[3], fnic->mac_addr[4], fnic->mac_addr[5],
-		c->wq_enet_desc_count, c->wq_copy_desc_count, c->rq_desc_count);
-	printk(KERN_INFO PFX "vNIC node wwn %llx port wwn %llx\n",
-		c->node_wwn, c->port_wwn);
-	printk(KERN_INFO PFX "vNIC ed_tov %d ra_tov %d\n",
-		c->ed_tov, c->ra_tov);
-	printk(KERN_INFO PFX "vNIC mtu %d intr timer %d\n",
-		c->maxdatafieldsize, c->intr_timer);
-	printk(KERN_INFO PFX "vNIC flags 0x%x luns per tgt %d\n",
-	       c->flags, c->luns_per_tgt);
-	printk(KERN_INFO PFX "vNIC flogi_retries %d flogi timeout %d\n",
-	       c->flogi_retries, c->flogi_timeout);
-	printk(KERN_INFO PFX "vNIC plogi retries %d plogi timeout %d\n",
-	       c->plogi_retries, c->plogi_timeout);
-	printk(KERN_INFO PFX "vNIC io throttle count %d link dn timeout %d\n",
-	       c->io_throttle_count, c->link_down_timeout);
-	printk(KERN_INFO PFX "vNIC port dn io retries %d port dn timeout %d\n",
-	       c->port_down_io_retries, c->port_down_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC MAC addr %02x:%02x:%02x:%02x:%02x:%02x "
+		     "wq/wq_copy/rq %d/%d/%d\n",
+		     fnic->mac_addr[0], fnic->mac_addr[1], fnic->mac_addr[2],
+		     fnic->mac_addr[3], fnic->mac_addr[4], fnic->mac_addr[5],
+		     c->wq_enet_desc_count, c->wq_copy_desc_count,
+		     c->rq_desc_count);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC node wwn %llx port wwn %llx\n",
+		     c->node_wwn, c->port_wwn);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC ed_tov %d ra_tov %d\n",
+		     c->ed_tov, c->ra_tov);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC mtu %d intr timer %d\n",
+		     c->maxdatafieldsize, c->intr_timer);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC flags 0x%x luns per tgt %d\n",
+		     c->flags, c->luns_per_tgt);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC flogi_retries %d flogi timeout %d\n",
+		     c->flogi_retries, c->flogi_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC plogi retries %d plogi timeout %d\n",
+		     c->plogi_retries, c->plogi_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC io throttle count %d link dn timeout %d\n",
+		     c->io_throttle_count, c->link_down_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC port dn io retries %d port dn timeout %d\n",
+		     c->port_down_io_retries, c->port_down_timeout);
 
 	return 0;
 }
@@ -231,15 +242,16 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 
 	intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
 
-	printk(KERN_INFO PFX "vNIC interrupt mode: %s\n",
-		intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
-		intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
-		intr_mode == VNIC_DEV_INTR_MODE_MSIX ? "MSI-X" : "unknown");
+	shost_printk(KERN_INFO, fnic->lport->host, "vNIC interrupt mode: %s\n",
+		     intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
+		     intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
+		     intr_mode == VNIC_DEV_INTR_MODE_MSIX ?
+		     "MSI-X" : "unknown");
 
-	printk(KERN_INFO PFX "vNIC resources avail: "
-	       "wq %d cp_wq %d raw_wq %d rq %d cq %d intr %d\n",
-	       fnic->wq_count, fnic->wq_copy_count, fnic->raw_wq_count,
-	       fnic->rq_count, fnic->cq_count, fnic->intr_count);
+	shost_printk(KERN_INFO, fnic->lport->host, "vNIC resources avail: "
+		     "wq %d cp_wq %d raw_wq %d rq %d cq %d intr %d\n",
+		     fnic->wq_count, fnic->wq_copy_count, fnic->raw_wq_count,
+		     fnic->rq_count, fnic->cq_count, fnic->intr_count);
 
 	/* Allocate Raw WQ used for FCS frames */
 	for (i = 0; i < fnic->raw_wq_count; i++) {
@@ -312,7 +324,8 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 				RES_TYPE_INTR_PBA_LEGACY, 0);
 
 	if (!fnic->legacy_pba && intr_mode == VNIC_DEV_INTR_MODE_INTX) {
-		printk(KERN_ERR "Failed to hook legacy pba resource\n");
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Failed to hook legacy pba resource\n");
 		err = -ENODEV;
 		goto err_out_cleanup;
 	}
@@ -415,7 +428,8 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 	/* init the stats memory by making the first call here */
 	err = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
 	if (err) {
-		printk(KERN_ERR "vnic_dev_stats_dump failed - x%x\n", err);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vnic_dev_stats_dump failed - x%x\n", err);
 		goto err_out_cleanup;
 	}
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0760abe..b2a4ed5 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -193,11 +193,11 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 
 	if (!ret)
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Issued fw reset\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Issued fw reset\n");
 	else
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Failed to issue fw reset\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Failed to issue fw reset\n");
 	return ret;
 }
 
@@ -237,8 +237,8 @@ flogi_reg_ioreq_end:
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 
 	if (!ret)
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "flog reg issued\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "flog reg issued\n");
 
 	return ret;
 }
@@ -481,14 +481,14 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) {
 		/* Check status of reset completion */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, DFX "reset cmpl success\n",
-				      fnic->fnic_no);
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				      "reset cmpl success\n");
 			/* Ready to send flogi out */
 			fnic->state = FNIC_IN_ETH_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
-				      DFX "fnic fw_reset : failed %s\n",
-				      fnic->fnic_no,
+				      fnic->lport->host,
+				      "fnic fw_reset : failed %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 
 			/*
@@ -502,9 +502,9 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 		}
 	} else {
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "Unexpected state %s while processing"
-			      " reset cmpl\n", fnic->fnic_no,
-			      fnic_state_to_str(fnic->state));
+			      fnic->lport->host,
+			      "Unexpected state %s while processing"
+			      " reset cmpl\n", fnic_state_to_str(fnic->state));
 		ret = -1;
 	}
 
@@ -560,21 +560,22 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 
 		/* Check flogi registration completion status */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, DFX "flog reg succeeded\n",
-				      fnic->fnic_no);
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				      "flog reg succeeded\n");
 			fnic->state = FNIC_IN_FC_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
-				      DFX "fnic flogi reg :failed %s\n",
-				      fnic->fnic_no,
+				      fnic->lport->host,
+				      "fnic flogi reg :failed %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 			fnic->state = FNIC_IN_ETH_MODE;
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Unexpected fnic state %s while"
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Unexpected fnic state %s while"
 			      " processing flogi reg completion\n",
-			      fnic->fnic_no, fnic_state_to_str(fnic->state));
+			      fnic_state_to_str(fnic->state));
 		ret = -1;
 	}
 
@@ -732,13 +733,15 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 						 t_sdev->queue_depth - 1);
 					if (qd == -1)
 						qd = t_sdev->host->cmd_per_lun;
-					printk(KERN_INFO DFX "scsi[%d:%d:%d:%d"
-					       "] queue full detected, new"
-					       " depth = %d\n", fnic->fnic_no,
-					       t_sdev->host->host_no,
-					       t_sdev->channel, t_sdev->id,
-					       t_sdev->lun,
-					       t_sdev->queue_depth);
+					shost_printk(KERN_INFO,
+						     fnic->lport->host,
+						     "scsi[%d:%d:%d:%d"
+						     "] queue full detected,"
+						     "new depth = %d\n",
+						     t_sdev->host->host_no,
+						     t_sdev->channel,
+						     t_sdev->id, t_sdev->lun,
+						     t_sdev->queue_depth);
 				}
 			}
 		}
@@ -768,8 +771,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	case FCPIO_MSS_INVALID:      /* request was aborted due to mss error */
 	case FCPIO_FW_ERR:           /* request was terminated due fw error */
 	default:
-		printk(KERN_ERR DFX "hdr status = %s\n", fnic->fnic_no,
-		       fnic_fcpio_status_to_str(hdr_status));
+		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
+			     fnic_fcpio_status_to_str(hdr_status));
 		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 	}
@@ -843,9 +846,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_ABTS_STATUS(sc) = hdr_status;
 
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "abts cmpl recd. id %d status %s\n",
-			      fnic->fnic_no, (int)(id & FNIC_TAG_MASK),
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "abts cmpl recd. id %d status %s\n",
+			      (int)(id & FNIC_TAG_MASK),
 			      fnic_fcpio_status_to_str(hdr_status));
 
 		/*
@@ -857,9 +860,8 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			complete(io_req->abts_done);
 			spin_unlock_irqrestore(io_lock, flags);
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG,
-				      DFX "abts cmpl, completing IO\n",
-				      fnic->fnic_no);
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				      "abts cmpl, completing IO\n");
 			CMD_SP(sc) = NULL;
 			sc->result = (DID_ERROR << 16);
 
@@ -875,18 +877,18 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		/* Completion of device reset */
 		CMD_LR_STATUS(sc) = hdr_status;
 		CMD_STATE(sc) = FNIC_IOREQ_CMD_COMPLETE;
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "dev reset cmpl recd. id %d status %s\n",
-			      fnic->fnic_no, (int)(id & FNIC_TAG_MASK),
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "dev reset cmpl recd. id %d status %s\n",
+			      (int)(id & FNIC_TAG_MASK),
 			      fnic_fcpio_status_to_str(hdr_status));
 		if (io_req->dr_done)
 			complete(io_req->dr_done);
 		spin_unlock_irqrestore(io_lock, flags);
 
 	} else {
-		printk(KERN_ERR DFX "Unexpected itmf io state %s tag %x\n",
-		       fnic->fnic_no, fnic_ioreq_state_to_str(CMD_STATE(sc)),
-		       id);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Unexpected itmf io state %s tag %x\n",
+			     fnic_ioreq_state_to_str(CMD_STATE(sc)), id);
 		spin_unlock_irqrestore(io_lock, flags);
 	}
 
@@ -925,8 +927,9 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	default:
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "firmware completion type %d\n",
-			      fnic->fnic_no, desc->hdr.type);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "firmware completion type %d\n",
+			      desc->hdr.type);
 		break;
 	}
 
@@ -990,8 +993,8 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 
 cleanup_scsi_cmd:
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "fnic_cleanup_io:"
-			      " DID_TRANSPORT_DISRUPTED\n", fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "fnic_cleanup_io:"
+			      " DID_TRANSPORT_DISRUPTED\n");
 
 		/* Complete the command to SCSI */
 		if (sc->scsi_done)
@@ -1042,8 +1045,8 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 
 wq_copy_cleanup_scsi_cmd:
 	sc->result = DID_NO_CONNECT << 16;
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "wq_copy_cleanup_handler:"
-		      " DID_NO_CONNECT\n", fnic->fnic_no);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
+		      " DID_NO_CONNECT\n");
 
 	if (sc->scsi_done)
 		sc->scsi_done(sc);
@@ -1084,8 +1087,9 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	enum fnic_ioreq_state old_ioreq_state;
 
 	FNIC_SCSI_DBG(KERN_DEBUG,
-		      DFX "fnic_rport_reset_exch called portid 0x%06x\n",
-		      fnic->fnic_no, port_id);
+		      fnic->lport->host,
+		      "fnic_rport_reset_exch called portid 0x%06x\n",
+		      port_id);
 
 	if (fnic->in_remove)
 		return;
@@ -1119,9 +1123,8 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 		BUG_ON(io_req->abts_done);
 
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "fnic_rport_reset_exch: Issuing abts\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "fnic_rport_reset_exch: Issuing abts\n");
 
 		spin_unlock_irqrestore(io_lock, flags);
 
@@ -1163,9 +1166,9 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 	enum fnic_ioreq_state old_ioreq_state;
 
 	FNIC_SCSI_DBG(KERN_DEBUG,
-		      DFX "fnic_terminate_rport_io called"
+		      fnic->lport->host, "fnic_terminate_rport_io called"
 		      " wwpn 0x%llx, wwnn0x%llx, portid 0x%06x\n",
-		      fnic->fnic_no, rport->port_name, rport->node_name,
+		      rport->port_name, rport->node_name,
 		      rport->port_id);
 
 	if (fnic->in_remove)
@@ -1205,8 +1208,8 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		BUG_ON(io_req->abts_done);
 
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "fnic_terminate_rport_io: Issuing abts\n",
-			      fnic->fnic_no);
+			      fnic->lport->host,
+			      "fnic_terminate_rport_io: Issuing abts\n");
 
 		spin_unlock_irqrestore(io_lock, flags);
 
@@ -1275,8 +1278,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	fnic = lport_priv(lp);
 	FNIC_SCSI_DBG(KERN_DEBUG,
-		      DFX "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
-		      fnic->fnic_no,
+		      fnic->lport->host,
+		      "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
 		      (starget_to_rport(scsi_target(sc->device)))->port_id,
 		      sc->device->lun, sc->request->tag);
 
@@ -1392,8 +1395,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	mempool_free(io_req, fnic->io_req_pool);
 
 fnic_abort_cmd_end:
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "Returning from abort cmd %s\n",
-		      fnic->fnic_no, (ret == SUCCESS) ?
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "Returning from abort cmd %s\n",
+		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
 	return ret;
 }
@@ -1474,8 +1478,8 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 * Found IO that is still pending with firmware and
 		 * belongs to the LUN that we are resetting
 		 */
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Found IO in %s on lun\n",
-			      fnic->fnic_no,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Found IO in %s on lun\n",
 			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
 		BUG_ON(CMD_STATE(sc) != FNIC_IOREQ_ABTS_PENDING);
@@ -1557,8 +1561,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	fnic = lport_priv(lp);
 	FNIC_SCSI_DBG(KERN_DEBUG,
-		      DFX "Device reset called FCID 0x%x, LUN 0x%x\n",
-		      fnic->fnic_no,
+		      fnic->lport->host,
+		      "Device reset called FCID 0x%x, LUN 0x%x\n",
 		      (starget_to_rport(scsi_target(sc->device)))->port_id,
 		      sc->device->lun);
 
@@ -1594,8 +1598,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "TAG %d\n",
-		      fnic->fnic_no, sc->request->tag);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %d\n",
+		      sc->request->tag);
 
 	/*
 	 * issue the device reset, if enqueue failed, clean up the ioreq
@@ -1632,8 +1636,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * gets cleaned up during higher levels of EH
 	 */
 	if (status == FCPIO_INVALID_CODE) {
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Device reset timed out\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Device reset timed out\n");
 		goto fnic_device_reset_end;
 	}
 
@@ -1641,8 +1645,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (status != FCPIO_SUCCESS) {
 		spin_lock_irqsave(io_lock, flags);
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      DFX "Device reset completed - failed\n",
-			      fnic->fnic_no);
+			      fnic->lport->host,
+			      "Device reset completed - failed\n");
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		goto fnic_device_reset_clean;
 	}
@@ -1657,9 +1661,9 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Device reset failed"
-			      " since could not abort all IOs\n",
-			      fnic->fnic_no);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "Device reset failed"
+			      " since could not abort all IOs\n");
 		goto fnic_device_reset_clean;
 	}
 
@@ -1682,8 +1686,9 @@ fnic_device_reset_clean:
 	}
 
 fnic_device_reset_end:
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "Returning from device reset %s\n",
-		      fnic->fnic_no, (ret == SUCCESS) ?
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "Returning from device reset %s\n",
+		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
 	return ret;
 }
@@ -1698,7 +1703,8 @@ int fnic_reset(struct Scsi_Host *shost)
 	lp = shost_priv(shost);
 	fnic = lport_priv(lp);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "fnic_reset called\n", fnic->fnic_no);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "fnic_reset called\n");
 
 	/*
 	 * Reset local port, this will clean up libFC exchanges,
@@ -1707,8 +1713,9 @@ int fnic_reset(struct Scsi_Host *shost)
 	if (lp->tt.lport_reset(lp))
 		ret = FAILED;
 
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "Returning from fnic reset %s\n",
-		      fnic->fnic_no, (ret == SUCCESS) ?
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "Returning from fnic reset %s\n",
+		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
 
 	return ret;
@@ -1788,7 +1795,8 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->remove_wait = NULL;
-	FNIC_SCSI_DBG(KERN_DEBUG, DFX "fnic_scsi_abort_io %s\n", fnic->fnic_no,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "fnic_scsi_abort_io %s\n",
 		      (fnic->state == FNIC_IN_ETH_MODE) ?
 		      "SUCCESS" : "FAILED");
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);



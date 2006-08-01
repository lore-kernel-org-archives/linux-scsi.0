From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/6] lpfc 8.1.7 : Short bug fixes
Date: Tue, 01 Aug 2006 07:34:00 -0400
Message-ID: <1154432040.18162.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:1737 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932661AbWHALeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 07:34:04 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BY31q000891
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:34:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Short bug fixes:
 - Fix iocbq list corruption due to missing list_del's in ct handling
 - Missing unlock in lpfc_sli_next_iotag()
 - Fix initialization of can_queue value
 - Differentiate sysfs mailbox errors with different codes.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2006-08-01 07:12:15.000000000 -0400
@@ -131,6 +131,7 @@ lpfc_ct_unsol_event(struct lpfc_hba * ph
 	}
 
 ct_unsol_event_exit_piocbq:
+	list_del(&head);
 	if (pmbuf) {
 		list_for_each_entry_safe(matp, next_matp, &pmbuf->list, list) {
 			lpfc_mbuf_free(phba, matp->virt, matp->phys);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-08-01 07:12:16.000000000 -0400
@@ -1616,7 +1616,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_free_iocbq;
 	}
 
-	/* We can rely on a queue depth attribute only after SLI HBA setup */
+	/*
+	 * Set initial can_queue value since 0 is no longer supported and
+	 * scsi_add_host will fail. This will be adjusted later based on the
+	 * max xri value determined in hba setup.
+	 */
 	host->can_queue = phba->cfg_hba_queue_depth - 10;
 
 	/* Tell the midlayer we support 16 byte commands */
@@ -1656,6 +1660,12 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_free_irq;
 	}
 
+	/*
+	 * hba setup may have changed the hba_queue_depth so we need to adjust
+	 * the value of can_queue.
+	 */
+	host->can_queue = phba->cfg_hba_queue_depth - 10;
+
 	lpfc_discovery_wait(phba);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:11:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:12:16.000000000 -0400
@@ -320,7 +320,8 @@ lpfc_sli_next_iotag(struct lpfc_hba * ph
 			kfree(old_arr);
 			return iotag;
 		}
-	}
+	} else
+		spin_unlock_irq(phba->host->host_lock);
 
 	lpfc_printf_log(phba, KERN_ERR,LOG_SLI,
 			"%d:0318 Failed to allocate IOTAG.last IOTAG is %d\n",
@@ -1399,11 +1400,11 @@ lpfc_sli_handle_slow_ring_event(struct l
 								 next_iocb,
 								 &saveq->list,
 								 list) {
+						list_del(&rspiocbp->list);
 						lpfc_sli_release_iocbq(phba,
 								     rspiocbp);
 					}
 				}
-
 				lpfc_sli_release_iocbq(phba, saveq);
 			}
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-08-01 07:10:11.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-08-01 07:14:21.000000000 -0400
@@ -884,7 +884,7 @@ sysfs_mbox_write(struct kobject *kobj, c
 		    phba->sysfs_mbox.mbox   == NULL ) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(host->host_lock);
-			return -EINVAL;
+			return -EAGAIN;
 		}
 	}
 
@@ -1008,7 +1008,7 @@ sysfs_mbox_read(struct kobject *kobj, ch
 		if (rc != MBX_SUCCESS) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(host->host_lock);
-			return -ENODEV;
+			return  (rc == MBX_TIMEOUT) ? -ETIME : -ENODEV;
 		}
 		phba->sysfs_mbox.state = SMBOX_READING;
 	}
@@ -1017,7 +1017,7 @@ sysfs_mbox_read(struct kobject *kobj, ch
 		printk(KERN_WARNING  "mbox_read: Bad State\n");
 		sysfs_mbox_idle(phba);
 		spin_unlock_irq(host->host_lock);
-		return -EINVAL;
+		return -EAGAIN;
 	}
 
 	memcpy(buf, (uint8_t *) & phba->sysfs_mbox.mbox->mb + off, count);



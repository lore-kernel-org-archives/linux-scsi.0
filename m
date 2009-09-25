From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/4] bfa: fixed checkpatch errors for bfad files
Date: Fri, 25 Sep 2009 12:29:54 -0700
Message-ID: <200909251929.n8PJTs3Y011884@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:51181 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZIYT3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 15:29:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch fixes checkpatch errors/warnings in bfad files.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfad.c           |    6 +++---
 bfad_fwimg.c     |    8 ++++----
 bfad_im.c        |    2 +-
 bfad_im_compat.h |    2 +-
 bfad_intr.c      |    3 +--
 5 files changed, 10 insertions(+), 11 deletions(-)

diff -urpN orig/drivers/scsi/bfa/bfad.c patch/drivers/scsi/bfa/bfad.c
--- orig/drivers/scsi/bfa/bfad.c	2009-09-24 23:41:14.000000000 -0700
+++ patch/drivers/scsi/bfa/bfad.c	2009-09-24 23:41:14.000000000 -0700
@@ -188,8 +188,8 @@ static struct bfad_port_s *
 bfad_get_drv_port(struct bfad_s *bfad, struct bfad_vf_s *vf_drv,
 		  struct bfad_vport_s *vp_drv)
 {
-	return ((vp_drv) ? (&(vp_drv)->drv_port)
-		: ((vf_drv) ? (&(vf_drv)->base_port) : (&(bfad)->pport)));
+	return (vp_drv) ? (&(vp_drv)->drv_port)
+		: ((vf_drv) ? (&(vf_drv)->base_port) : (&(bfad)->pport));
 }
 
 struct bfad_port_s *
@@ -716,7 +716,7 @@ bfad_drv_init(struct bfad_s *bfad)
 	if ((bfad->bfad_flags & BFAD_MSIX_ON)
 	    && bfad_install_msix_handler(bfad)) {
 		printk(KERN_WARNING "%s: install_msix failed, bfad%d\n",
-		       __FUNCTION__, bfad->inst_no);
+		       __func__, bfad->inst_no);
 	}
 
 	bfad_init_timer(bfad);
diff -urpN orig/drivers/scsi/bfa/bfad_fwimg.c patch/drivers/scsi/bfa/bfad_fwimg.c
--- orig/drivers/scsi/bfa/bfad_fwimg.c	2009-09-24 23:41:14.000000000 -0700
+++ patch/drivers/scsi/bfa/bfad_fwimg.c	2009-09-24 23:41:14.000000000 -0700
@@ -63,10 +63,10 @@ bfad_read_firmware(struct pci_dev *pdev,
 	memcpy(*bfi_image, fw->data, fw->size);
 	*bfi_image_size = fw->size/sizeof(u32);
 
-	return(*bfi_image);
+	return *bfi_image;
 
 error:
-	return(NULL);
+	return NULL;
 }
 
 u32 *
@@ -76,12 +76,12 @@ bfad_get_firmware_buf(struct pci_dev *pd
 		if (bfi_image_ct_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_ct,
 				&bfi_image_ct_size, BFAD_FW_FILE_CT);
-		return(bfi_image_ct);
+		return bfi_image_ct;
 	} else {
 		if (bfi_image_cb_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_cb,
 				&bfi_image_cb_size, BFAD_FW_FILE_CB);
-		return(bfi_image_cb);
+		return bfi_image_cb;
 	}
 }
 
diff -urpN orig/drivers/scsi/bfa/bfad_im.c patch/drivers/scsi/bfa/bfad_im.c
--- orig/drivers/scsi/bfa/bfad_im.c	2009-09-24 23:41:14.000000000 -0700
+++ patch/drivers/scsi/bfa/bfad_im.c	2009-09-24 23:41:14.000000000 -0700
@@ -1050,7 +1050,7 @@ bfad_im_itnim_work_handler(struct work_s
 		} else {
 			printk(KERN_WARNING
 				"%s: itnim %llx is already in online state\n",
-				__FUNCTION__,
+				__func__,
 				bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
 		}
 
diff -urpN orig/drivers/scsi/bfa/bfad_im_compat.h patch/drivers/scsi/bfa/bfad_im_compat.h
--- orig/drivers/scsi/bfa/bfad_im_compat.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfad_im_compat.h	2009-09-24 23:41:15.000000000 -0700
@@ -31,7 +31,7 @@ u32 *bfad_read_firmware(struct pci_dev *
 static inline u32 *
 bfad_load_fwimg(struct pci_dev *pdev)
 {
-	return(bfad_get_firmware_buf(pdev));
+	return bfad_get_firmware_buf(pdev);
 }
 
 static inline void
diff -urpN orig/drivers/scsi/bfa/bfad_intr.c patch/drivers/scsi/bfa/bfad_intr.c
--- orig/drivers/scsi/bfa/bfad_intr.c	2009-09-24 23:41:14.000000000 -0700
+++ patch/drivers/scsi/bfa/bfad_intr.c	2009-09-24 23:41:14.000000000 -0700
@@ -23,13 +23,12 @@ BFA_TRC_FILE(LDRV, INTR);
 /**
  *  bfa_isr BFA driver interrupt functions
  */
-irqreturn_t bfad_intx(int irq, void *dev_id);
 static int msix_disable;
 module_param(msix_disable, int, S_IRUGO | S_IWUSR);
 /**
  * Line based interrupt handler.
  */
-irqreturn_t
+static irqreturn_t
 bfad_intx(int irq, void *dev_id)
 {
 	struct bfad_s         *bfad = dev_id;

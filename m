From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH v2] advansys: fix regression with request_firmware change
Date: Fri, 26 Mar 2010 20:05:08 -0300
Message-ID: <201003262005.09121.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:47590 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0CZXFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2010 19:05:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

On newer kernels users of advansys module are reporting system hang when
trying to load it without firmware files present. After looking closely
at description on https://qa.mandriva.com/show_bug.cgi?id=53220, I think
this is related to commit "[SCSI] advansys: use request_firmware". The
problem is that after switch to request_firmware, asc_dvc->err_code
isn't being set when firmware files aren't found or loading fails.

err_code is used by the driver to judge if there was a fatal error or
not, as can be seen for example on advansys_board_found, which will only
return -ENODEV when err_code is set. Because err_code isn't being set
when request_firmware fails, this is a change of behaviour of the code
before request_firmware addition, making it continue to load and it
fails later as the firmware wasn't really loaded.

Also, error handling on advansys_board_found is fixed, because it's
buggy in the case we have an ASC_NARROW_BOARD set and failure happens on
AscInitAsc1000Driver step: it was freeing items of wrong struct in the
dvc_var union of struct asc_board, which could lead to an oops in the
case we set some of the fields in struct of narrow board as code was
choosing to always freeing wide board fields, and not everything wasn't
being freed/released properly.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/scsi/advansys.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

v2 fixes error handling in advansys_board_found, so code will not oops anymore
if firmware files are not found. users tested this change and reported it to be
ok (no more freeze or oops when firmware files are not found)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 22626ab..9a3c68f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4781,12 +4781,14 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -5110,12 +5112,14 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -5624,12 +5628,14 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -6124,12 +6130,14 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -12303,7 +12311,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
 		if (!asc_dvc_varp->overrun_buf) {
 			ret = -ENOMEM;
-			goto err_free_wide_mem;
+			goto err_free_irq;
 		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
@@ -12314,28 +12322,37 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					asc_dvc_varp->err_code);
 			if (asc_dvc_varp->err_code) {
 				ret = -ENODEV;
-				kfree(asc_dvc_varp->overrun_buf);
+				goto err_free_mem;
 			}
 		}
 	} else {
-		if (advansys_wide_init_chip(shost))
+		if (advansys_wide_init_chip(shost)) {
 			ret = -ENODEV;
+			goto err_free_mem;
+		}
 	}
 
-	if (ret)
-		goto err_free_wide_mem;
-
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	ret = scsi_add_host(shost, boardp->dev);
 	if (ret)
-		goto err_free_wide_mem;
+		goto err_free_mem;
 
 	scsi_scan_host(shost);
 	return 0;
 
- err_free_wide_mem:
-	advansys_wide_free_mem(boardp);
+ err_free_mem:
+	if (ASC_NARROW_BOARD(boardp)) {
+		if ((asc_dvc_varp->err_code & ASC_IERR_SET_PC_ADDR) ||
+		    (asc_dvc_varp->err_code & ASC_IERR_START_STOP_CHIP) ||
+		    (!asc_dvc_varp->err_code))
+			dma_unmap_single(boardp->dev, asc_dvc_varp->overrun_dma,
+					 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
+	} else {
+		advansys_wide_free_mem(boardp);
+	}
+ err_free_irq:
 	free_irq(boardp->irq, shost);
  err_free_dma:
 #ifdef CONFIG_ISA
-- 
1.7.0.3

From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH] advansys: fix regression with request_firmware change
Date: Fri, 19 Mar 2010 19:37:26 -0300
Message-ID: <201003191937.26808.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:42523 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0CSXFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 19:05:54 -0400
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

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/scsi/advansys.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

Note that I'm still waiting for user on bug report to test this patch, but so
far this is safe and should be ok to solve the bug, so I'm sending it already.

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 22626ab..9201afe 100644
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
-- 
1.7.0.2

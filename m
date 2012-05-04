From: akpm@linux-foundation.org
Subject: [patch 2/5] drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
Date: Fri, 04 May 2012 14:35:09 -0700
Message-ID: <20120504213509.7187CA04FA@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42638 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2EDWGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 18:06:14 -0400
Received: by wibhj13 with SMTP id hj13so114880wib.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2012 15:06:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, svenkatr@ti.com, linkinjeon@gmail.com, santoshsy@gmail.com

From: Venkatraman S <svenkatr@ti.com>
Subject: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic

Otherwise it counter intuitively returns 0 if device is present.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -232,11 +232,11 @@ static inline u32 ufshcd_get_ufs_version
  *			      the host controller
  * @reg_hcs - host controller status register value
  *
- * Returns 0 if device present, non-zero if no device detected
+ * Returns 1 if device present, 0 if no device detected
  */
 static inline int ufshcd_is_device_present(u32 reg_hcs)
 {
-	return (DEVICE_PRESENT & reg_hcs) ? 0 : -1;
+	return (DEVICE_PRESENT & reg_hcs) ? 1 : 0;
 }
 
 /**
@@ -911,7 +911,7 @@ static int ufshcd_make_hba_operational(s
 
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
-	if (ufshcd_is_device_present(reg)) {
+	if (!ufshcd_is_device_present(reg)) {
 		dev_err(&hba->pdev->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
_

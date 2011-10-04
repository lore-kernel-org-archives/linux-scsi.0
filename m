From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Add support to flash FPGA and flash back DRAM images
Date: Mon, 03 Oct 2011 20:54:37 -0700
Message-ID: <4E8A837D.5090206@linux.vnet.ibm.com>
References: <20111004035136.190411310@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46984 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab1JDDyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 23:54:41 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-scsi@vger.kernel.org> from <wayneb@linux.vnet.ibm.com>;
	Mon, 3 Oct 2011 23:54:40 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p943sc8S262658
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2011 23:54:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p943scLi030464
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2011 23:54:38 -0400
In-Reply-To: <20111004035136.190411310@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@br.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

The write buffer command is used to download and burn new IOA FW images.
The same interface can now be used to flash FPGA and flash back DRAM images.
To download and flash the new images takes more than 15 minutes, so increase
the write buffer command timeout to 30 minutes.

The FPGA and flash back DRAM images don't have the same card_type as the IOA FW
image. So, remove the sanity checking from the driver.  The adapter has sanity
checking and will only accept a valid image.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   10 ++--------
 drivers/scsi/ipr.h |    2 +-
 2 files changed, 3 insertions(+), 9 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-09-14 15:53:52.771934805 -0700
+++ b/drivers/scsi/ipr.c	2011-10-03 20:38:27.709101216 -0700
@@ -3751,14 +3751,6 @@ static ssize_t ipr_store_update_fw(struc

 	image_hdr = (struct ipr_ucode_image_header *)fw_entry->data;

-	if (be32_to_cpu(image_hdr->header_length) > fw_entry->size ||
-	    (ioa_cfg->vpd_cbs->page3_data.card_type &&
-	     ioa_cfg->vpd_cbs->page3_data.card_type != image_hdr->card_type)) {
-		dev_err(&ioa_cfg->pdev->dev, "Invalid microcode buffer\n");
-		release_firmware(fw_entry);
-		return -EINVAL;
-	}
-
 	src = (u8 *)image_hdr + be32_to_cpu(image_hdr->header_length);
 	dnld_size = fw_entry->size - be32_to_cpu(image_hdr->header_length);
 	sglist = ipr_alloc_ucode_buffer(dnld_size);
@@ -3777,6 +3769,8 @@ static ssize_t ipr_store_update_fw(struc
 		goto out;
 	}

+	ipr_info("Updating microcode, please be patient.  This may take up to 30 minutes.\n");
+
 	result = ipr_update_ioa_ucode(ioa_cfg, sglist);

 	if (!result)
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2011-09-14 15:53:52.739933466 -0700
+++ b/drivers/scsi/ipr.h	2011-09-14 16:56:27.476756895 -0700
@@ -208,7 +208,7 @@
 #define IPR_CANCEL_ALL_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_ABORT_TASK_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_INTERNAL_TIMEOUT			(ipr_fastfail ? 10 * HZ : 30 * HZ)
-#define IPR_WRITE_BUFFER_TIMEOUT		(10 * 60 * HZ)
+#define IPR_WRITE_BUFFER_TIMEOUT		(30 * 60 * HZ)
 #define IPR_SET_SUP_DEVICE_TIMEOUT		(2 * 60 * HZ)
 #define IPR_REQUEST_SENSE_TIMEOUT		(10 * HZ)
 #define IPR_OPERATIONAL_TIMEOUT		(5 * 60)


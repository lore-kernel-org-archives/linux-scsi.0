From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.1-rc4
Date: Sat, 23 May 2015 15:01:06 -0700
Message-ID: <1432418466.2192.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46700 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbbEWWBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2015 18:01:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of five fixes:  Two MAINTAINER email updates (urgent
because the non-avagotech emails will start bouncing) an lpfc big endian
oops fix, a 256 byte sector hang fix (to eliminate 256 byte sectors) and
a storvsc fix which could cause test unit ready failures on bringup.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alexey Kardashevskiy (1):
      lpfc: Fix breakage on big endian kernels

James Smart (1):
      MAINTAINERS: Revise lpfc maintainers for Avago Technologies ownership of Emulex

K. Y. Srinivasan (1):
      storvsc: Set the SRB flags correctly when no data transfer is needed

Mark Hounschell (1):
      sd: Disable support for 256 byte/sector disks

Minh Tran (1):
      MAINTAINERS, be2iscsi: change email domain

And the diffstat:

 MAINTAINERS                      | 13 ++++++++-----
 drivers/scsi/be2iscsi/be.h       |  6 +++---
 drivers/scsi/be2iscsi/be_cmds.c  |  6 +++---
 drivers/scsi/be2iscsi/be_cmds.h  |  6 +++---
 drivers/scsi/be2iscsi/be_iscsi.c |  8 ++++----
 drivers/scsi/be2iscsi/be_iscsi.h |  8 ++++----
 drivers/scsi/be2iscsi/be_main.c  | 12 ++++++------
 drivers/scsi/be2iscsi/be_main.h  | 10 +++++-----
 drivers/scsi/be2iscsi/be_mgmt.c  |  8 ++++----
 drivers/scsi/be2iscsi/be_mgmt.h  |  8 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c    | 41 ++++++++++++++++++++--------------------
 drivers/scsi/sd.c                | 19 +++++--------------
 drivers/scsi/storvsc_drv.c       |  3 +--
 13 files changed, 71 insertions(+), 77 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 2e5bbc0..d42115a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3803,10 +3803,11 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
-EMULEX LPFC FC SCSI DRIVER
-M:	James Smart <james.smart@emulex.com>
+EMULEX/AVAGO LPFC FC/FCOE SCSI DRIVER
+M:	James Smart <james.smart@avagotech.com>
+M:	Dick Kennedy <dick.kennedy@avagotech.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://sourceforge.net/projects/lpfcxxxx
+W:	http://www.avagotech.com
 S:	Supported
 F:	drivers/scsi/lpfc/
 
@@ -8794,9 +8795,11 @@ F:	drivers/misc/phantom.c
 F:	include/uapi/linux/phantom.h
 
 SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
-M:	Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
+M:	Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
+M:	Minh Tran <minh.tran@avagotech.com>
+M:	John Soni Jose <sony.john-n@avagotech.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.emulex.com
+W:	http://www.avagotech.com
 S:	Supported
 F:	drivers/scsi/be2iscsi/
 
diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 81e83a6..3207009 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1028760..447cf7c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 98897434..f11d325 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b7391a3..2f07007 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index e0b3b2d..0c84e1c 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 923a2b5..1f74760 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -50,7 +50,7 @@ static unsigned int enable_msix = 1;
 
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
-MODULE_AUTHOR("Emulex Corporation");
+MODULE_AUTHOR("Avago Technologies");
 MODULE_LICENSE("GPL");
 module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
@@ -552,7 +552,7 @@ MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 
 static struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
-	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
+	.name = "Avago Technologies 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
 	.change_queue_depth = scsi_change_queue_depth,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 7ee0ffc..e70ea26b 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -37,7 +37,7 @@
 
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"10.4.114.0"
-#define BE_NAME			"Emulex OneConnect" \
+#define BE_NAME			"Avago Technologies OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 681d4e8..c2c4d69 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index bd81446..9356b9a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cb73cf9..c140f99 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1130,25 +1130,6 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
- * @data: A pointer to the immediate command data portion of the IOCB.
- * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
- *
- * The routine copies the entire FCP command from @fcp_cmnd to @data while
- * byte swapping the data to big endian format for transmission on the wire.
- **/
-static void
-lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
-{
-	int i, j;
-
-	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
-	     i += sizeof(uint32_t), j++) {
-		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
-	}
-}
-
-/**
  * lpfc_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
@@ -1283,7 +1264,6 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * we need to set word 4 of IOCB here
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
-	lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	return 0;
 }
 
@@ -4147,6 +4127,24 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 }
 
 /**
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
+ * @data: A pointer to the immediate command data portion of the IOCB.
+ * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ *
+ * The routine copies the entire FCP command from @fcp_cmnd to @data while
+ * byte swapping the data to big endian format for transmission on the wire.
+ **/
+static void
+lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
+{
+	int i, j;
+	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
+	     i += sizeof(uint32_t), j++) {
+		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
+	}
+}
+
+/**
  * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
@@ -4225,6 +4223,9 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		fcp_cmnd->fcpCntl3 = 0;
 		phba->fc4ControlRequests++;
 	}
+	if (phba->sli_rev == 3 &&
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
+		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	/*
 	 * Finish initializing those IOCB fields that are independent
 	 * of the scsi_cmnd request_buffer
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 79beebf..7f9d65f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1600,6 +1600,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
 	u64 start_lba = blk_rq_pos(scmd->request);
 	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
+	u64 factor = scmd->device->sector_size / 512;
 	u64 bad_lba;
 	int info_valid;
 	/*
@@ -1621,16 +1622,9 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	if (scsi_bufflen(scmd) <= scmd->device->sector_size)
 		return 0;
 
-	if (scmd->device->sector_size < 512) {
-		/* only legitimate sector_size here is 256 */
-		start_lba <<= 1;
-		end_lba <<= 1;
-	} else {
-		/* be careful ... don't want any overflows */
-		unsigned int factor = scmd->device->sector_size / 512;
-		do_div(start_lba, factor);
-		do_div(end_lba, factor);
-	}
+	/* be careful ... don't want any overflows */
+	do_div(start_lba, factor);
+	do_div(end_lba, factor);
 
 	/* The bad lba was reported incorrectly, we have no idea where
 	 * the error is.
@@ -2188,8 +2182,7 @@ got_data:
 	if (sector_size != 512 &&
 	    sector_size != 1024 &&
 	    sector_size != 2048 &&
-	    sector_size != 4096 &&
-	    sector_size != 256) {
+	    sector_size != 4096) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
@@ -2244,8 +2237,6 @@ got_data:
 		sdkp->capacity <<= 2;
 	else if (sector_size == 1024)
 		sdkp->capacity <<= 1;
-	else if (sector_size == 256)
-		sdkp->capacity >>= 1;
 
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index d9dad90..3c6584f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1600,8 +1600,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		break;
 	default:
 		vm_srb->data_in = UNKNOWN_TYPE;
-		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
-						     SRB_FLAGS_DATA_OUT);
+		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_NO_DATA_TRANSFER;
 		break;
 	}
 



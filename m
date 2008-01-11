From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 2/3] mpt fusion: Fix for module unload problem in flash less controller environment
Date: Fri, 11 Jan 2008 14:42:17 +0530
Message-ID: <20080111091217.GC4161@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56916 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760315AbYAKJWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:22:35 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m0B9FLCm008867
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 01:19:50 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch fixes the module unload problem in flash less 1030 controller 
environment where firmware download boot functionality is invoked. 
The problem is due to the firmware download is being done in the reverse order,
which this patch solves by insureing the download occurs to the last controller 
being reset.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9476ad2..d733438 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2086,7 +2086,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 						ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 						    "mpt_upload:  alt_%s has cached_fw=%p \n",
 						    ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
-						ioc->alt_ioc->cached_fw = NULL;
+						ioc->cached_fw = NULL;
 					}
 				} else {
 					printk(MYIOC_s_WARN_FMT
@@ -2292,10 +2292,12 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	int ret;
 
 	if (ioc->cached_fw != NULL) {
-		ddlprintk(ioc, printk(MYIOC_s_INFO_FMT
-		    "mpt_adapter_disable: Pushing FW onto adapter\n", ioc->name));
-		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)ioc->cached_fw, NO_SLEEP)) < 0) {
-			printk(MYIOC_s_WARN_FMT "firmware downloadboot failure (%d)!\n",
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: Pushing FW onto "
+		    "adapter\n", __FUNCTION__, ioc->name));
+		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)
+		    ioc->cached_fw, CAN_SLEEP)) < 0) {
+			printk(MYIOC_s_WARN_FMT
+			    ": firmware downloadboot failure (%d)!\n",
 			    ioc->name, ret);
 		}
 	}
@@ -2333,13 +2335,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		ioc->alloc_total -= sz;
 	}
 
-	if (ioc->cached_fw != NULL) {
-		sz = ioc->facts.FWImageSize;
-		pci_free_consistent(ioc->pcidev, sz,
-			ioc->cached_fw, ioc->cached_fw_dma);
-		ioc->cached_fw = NULL;
-		ioc->alloc_total -= sz;
-	}
+	mpt_free_fw_memory(ioc);
 
 	kfree(ioc->spi_data.nvram);
 	mpt_inactive_raid_list_free(ioc);
@@ -3080,44 +3076,62 @@ SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag)
  *
  *	If memory has already been allocated, the same (cached) value
  *	is returned.
- */
-void
+ *
+ *	Return 0 if successfull, or non-zero for failure
+ **/
+int
 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size)
 {
-	if (ioc->cached_fw)
-		return;  /* use already allocated memory */
-	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
+	int rc;
+
+	if (ioc->cached_fw) {
+		rc = 0;  /* use already allocated memory */
+		goto out;
+	}
+	else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
 		ioc->cached_fw = ioc->alt_ioc->cached_fw;  /* use alt_ioc's memory */
 		ioc->cached_fw_dma = ioc->alt_ioc->cached_fw_dma;
-		ioc->alloc_total += size;
-		ioc->alt_ioc->alloc_total -= size;
+		rc = 0;
+		goto out;
+	}
+	ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma);
+	if (!ioc->cached_fw) {
+		printk(MYIOC_s_ERR_FMT "Unable to allocate memory for the cached firmware image!\n",
+		    ioc->name);
+		rc = -1;
 	} else {
-		if ( (ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma) ) )
-			ioc->alloc_total += size;
+		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+		    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, size, size));
+		ioc->alloc_total += size;
+		rc = 0;
 	}
+ out:
+	return rc;
 }
+
 /**
  *	mpt_free_fw_memory - free firmware memory
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
  *	If alt_img is NULL, delete from ioc structure.
  *	Else, delete a secondary image in same format.
- */
+ **/
 void
 mpt_free_fw_memory(MPT_ADAPTER *ioc)
 {
 	int sz;
 
+	if (!ioc->cached_fw)
+		return;
+
 	sz = ioc->facts.FWImageSize;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
-	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
+		 ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 	pci_free_consistent(ioc->pcidev, sz, ioc->cached_fw, ioc->cached_fw_dma);
+	ioc->alloc_total -= sz;
 	ioc->cached_fw = NULL;
-
-	return;
 }
 
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_do_upload - Construct and Send FWUpload request to MPT adapter port.
@@ -3149,17 +3163,12 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	if ((sz = ioc->facts.FWImageSize) == 0)
 		return 0;
 
-	mpt_alloc_fw_memory(ioc, sz);
+	if (mpt_alloc_fw_memory(ioc, ioc->facts.FWImageSize) != 0)
+		return -ENOMEM;
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 	    ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
 
-	if (ioc->cached_fw == NULL) {
-		/* Major Failure.
-		 */
-		return -ENOMEM;
-	}
-
 	prequest = (sleepFlag == NO_SLEEP) ? kzalloc(ioc->req_sz, GFP_ATOMIC) :
 	    kzalloc(ioc->req_sz, GFP_KERNEL);
 	if (!prequest) {
@@ -3531,12 +3540,12 @@ KickStart(MPT_ADAPTER *ioc, int force, int sleepFlag)
 static int
 mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 {
-	MPT_ADAPTER	*iocp=NULL;
 	u32 diag0val;
 	u32 doorbell;
 	int hard_reset_done = 0;
 	int count = 0;
 	u32 diag1val = 0;
+	MpiFwHeader_t *cached_fw;	/* Pointer to FW */
 
 	/* Clear any existing interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
@@ -3668,22 +3677,24 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 		}
 
 		if (ioc->cached_fw)
-			iocp = ioc;
+			cached_fw = (MpiFwHeader_t *)ioc->cached_fw;
 		else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
-			iocp = ioc->alt_ioc;
-		if (iocp) {
+			cached_fw = (MpiFwHeader_t *)ioc->alt_ioc->cached_fw;
+		else
+			cached_fw = NULL;
+		if (cached_fw) {
 			/* If the DownloadBoot operation fails, the
 			 * IOC will be left unusable. This is a fatal error
 			 * case.  _diag_reset will return < 0
 			 */
 			for (count = 0; count < 30; count ++) {
-				diag0val = CHIPREG_READ32(&iocp->chip->Diagnostic);
+				diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
 				if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
 					break;
 				}
 
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "cached_fw: diag0val=%x count=%d\n",
-					iocp->name, diag0val, count));
+					ioc->name, diag0val, count));
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
 					msleep (1000);
@@ -3691,8 +3702,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 					mdelay (1000);
 				}
 			}
-			if ((count = mpt_downloadboot(ioc,
-				(MpiFwHeader_t *)iocp->cached_fw, sleepFlag)) < 0) {
+			if ((count = mpt_downloadboot(ioc, cached_fw, sleepFlag)) < 0) {
 				printk(MYIOC_s_WARN_FMT
 					"firmware downloadboot failure (%d)!\n", ioc->name, count);
 			}
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 4031c15..44c98c5 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -908,7 +908,7 @@ extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size, int len, int showlan);
 extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *cfg);
-extern void	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
+extern int	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);

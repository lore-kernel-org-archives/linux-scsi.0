From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 7/9] mptfusion: firmware download boot fix's
Date: Tue, 11 Jul 2006 17:33:13 -0600
Message-ID: <20060711233312.GB8622@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57554 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932259AbWGKXqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:46:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Fix's to insure download boot could occur when
either channel of 1030 is reset. Necessary in order
for onboard controller in flashless environment
to become operational.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-07-11 12:34:35.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-07-11 13:03:29.000000000 -0600
@@ -1760,9 +1760,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 						 * chips (mpt_adapter_disable,
 						 * mpt_diag_reset)
 						 */
-						ioc->cached_fw = NULL;
 						ddlprintk((MYIOC_s_INFO_FMT ": mpt_upload:  alt_%s has cached_fw=%p \n",
 							ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
+						ioc->alt_ioc->cached_fw = NULL;
 					}
 				} else {
 					printk(KERN_WARNING MYNAM ": firmware upload failure!\n");
@@ -1883,7 +1883,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		/* FIXME?  Examine results here? */
 	}
 
-out:
+ out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
 		if (mpt_msi_enable)
@@ -2735,6 +2735,8 @@ mpt_alloc_fw_memory(MPT_ADAPTER *ioc, in
 	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
 		ioc->cached_fw = ioc->alt_ioc->cached_fw;  /* use alt_ioc's memory */
 		ioc->cached_fw_dma = ioc->alt_ioc->cached_fw_dma;
+		ioc->alloc_total += size;
+		ioc->alt_ioc->alloc_total -= size;
 	} else {
 		if ( (ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma) ) )
 			ioc->alloc_total += size;
@@ -3164,6 +3166,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 static int
 mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 {
+	MPT_ADAPTER	*iocp=NULL;
 	u32 diag0val;
 	u32 doorbell;
 	int hard_reset_done = 0;
@@ -3299,17 +3302,23 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			/* FIXME?  Examine results here? */
 		}
 
-		if (ioc->cached_fw) {
+		if (ioc->cached_fw)
+			iocp = ioc;
+		else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
+			iocp = ioc->alt_ioc;
+		if (iocp) {
 			/* If the DownloadBoot operation fails, the
 			 * IOC will be left unusable. This is a fatal error
 			 * case.  _diag_reset will return < 0
 			 */
 			for (count = 0; count < 30; count ++) {
-				diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+				diag0val = CHIPREG_READ32(&iocp->chip->Diagnostic);
 				if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
 					break;
 				}
 
+				dprintk((MYIOC_s_INFO_FMT "cached_fw: diag0val=%x count=%d\n",
+					iocp->name, diag0val, count));
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
 					msleep (1000);
@@ -3318,7 +3327,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				}
 			}
 			if ((count = mpt_downloadboot(ioc,
-				(MpiFwHeader_t *)ioc->cached_fw, sleepFlag)) < 0) {
+				(MpiFwHeader_t *)iocp->cached_fw, sleepFlag)) < 0) {
 				printk(KERN_WARNING MYNAM
 					": firmware downloadboot failure (%d)!\n", count);
 			}
@@ -3905,18 +3914,18 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int
 
 	if (sleepFlag == CAN_SLEEP) {
 		while (--cntdn) {
+			msleep (1);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
-			msleep (1);
 			count++;
 		}
 	} else {
 		while (--cntdn) {
+			mdelay (1);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
-			mdelay (1);
 			count++;
 		}
 	}
@@ -4881,6 +4890,7 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 		pIoc4 = pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
 		if (!pIoc4)
 			return;
+		ioc->alloc_total += iocpage4sz;
 	} else {
 		ioc4_dma = ioc->spi_data.IocPg4_dma;
 		iocpage4sz = ioc->spi_data.IocPg4Sz;
@@ -4897,6 +4907,7 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 	} else {
 		pci_free_consistent(ioc->pcidev, iocpage4sz, pIoc4, ioc4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
+		ioc->alloc_total -= iocpage4sz;
 	}
 }
 
@@ -6404,7 +6415,6 @@ EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
 
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	fusion_init - Fusion MPT base driver initialization routine.

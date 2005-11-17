From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 5/7]  mptfusion - prep for removing domain validation
Date: Wed, 16 Nov 2005 18:54:23 -0700
Message-ID: <200511161854.23185.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PL+eD1w9sC89R3g"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7042 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161094AbVKQB7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:54 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1tCSW011550
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:12 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xsfW001963
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_PL+eD1w9sC89R3g
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This moves some functions around from within the #define MPTSCSIH_ENABLE_DOMAIN_VALIDATION area,
in preperation for generic domain validation.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--Boundary-00=_PL+eD1w9sC89R3g
Content-Type: text/x-diff;
  charset="us-ascii";
  name="5-dvprep-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="5-dvprep-fix.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-11-16 18:09:23.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2005-11-16 18:10:22.000000000 -0700
@@ -152,7 +152,6 @@
 
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen);
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
-static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id);
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int target, int flags);
@@ -160,18 +159,19 @@
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum);
+static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
 
 static struct work_struct   mptscsih_persistTask;
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD *io);
 static void	mptscsih_domainValidation(void *hd);
-static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
 static void	mptscsih_qas_check(MPT_SCSI_HOST *hd, int id);
 static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int target);
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage);
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int width);
 static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);
+static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
 #endif
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -993,8 +993,10 @@
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 	int 		 	count;
 	unsigned long	 	flags;
+#endif
 	int sz1;
 
 	if(!host) {
@@ -2597,9 +2599,9 @@
 
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
 	{
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 		pMpiEventDataRaid_t pRaidEventData =
 		    (pMpiEventDataRaid_t) pEvReply->Data;
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 		/* Domain Validation Needed */
 		if (ioc->bus_type == SPI &&
 		    pRaidEventData->ReasonCode ==
@@ -2926,94 +2928,6 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* If DV disabled (negoNvram set to USE_NVARM) or if not LUN 0, return.
- * Else set the NEED_DV flag after Read Capacity Issued (disks)
- * or Mode Sense (cdroms).
- *
- * Tapes, initTarget will set this flag on completion of Inquiry command.
- * Called only if DV_NOT_DONE flag is set
- */
-static void
-mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)
-{
-	MPT_ADAPTER	*ioc = hd->ioc;
-	u8 cmd;
-	SpiCfgData	*pSpi;
-
-	ddvtprintk((MYIOC_s_NOTE_FMT
-		" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
-		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));
-
-	if ((pReq->LUN[1] != 0) || (hd->negoNvram != 0))
-		return;
-
-	cmd = pReq->CDB[0];
-
-	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
-		pSpi = &ioc->spi_data;
-		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && ioc->raid_data.pIocPg3) {
-			/* Set NEED_DV for all hidden disks
-			 */
-			Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
-			int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-
-			while (numPDisk) {
-				pSpi->dvStatus[pPDisk->PhysDiskID] |= MPT_SCSICFG_NEED_DV;
-				ddvtprintk(("NEED_DV set for phys disk id %d\n", pPDisk->PhysDiskID));
-				pPDisk++;
-				numPDisk--;
-			}
-		}
-		pSpi->dvStatus[pReq->TargetID] |= MPT_SCSICFG_NEED_DV;
-		ddvtprintk(("NEED_DV set for visible disk id %d\n", pReq->TargetID));
-	}
-}
-
-/* mptscsih_raid_set_dv_flags()
- *
- * New or replaced disk. Set DV flag and schedule DV.
- */
-static void
-mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)
-{
-	MPT_ADAPTER	*ioc = hd->ioc;
-	SpiCfgData	*pSpi = &ioc->spi_data;
-	Ioc3PhysDisk_t	*pPDisk;
-	int		 numPDisk;
-
-	if (hd->negoNvram != 0)
-		return;
-
-	ddvtprintk(("DV requested for phys disk id %d\n", id));
-	if (ioc->raid_data.pIocPg3) {
-		pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
-		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
-		while (numPDisk) {
-			if (id == pPDisk->PhysDiskNum) {
-				pSpi->dvStatus[pPDisk->PhysDiskID] =
-				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);
-				pSpi->forceDv = MPT_SCSICFG_NEED_DV;
-				ddvtprintk(("NEED_DV set for phys disk id %d\n",
-				    pPDisk->PhysDiskID));
-				break;
-			}
-			pPDisk++;
-			numPDisk--;
-		}
-
-		if (numPDisk == 0) {
-			/* The physical disk that needs DV was not found
-			 * in the stored IOC Page 3. The driver must reload
-			 * this page. DV routine will set the NEED_DV flag for
-			 * all phys disks that have DV_NOT_DONE set.
-			 */
-			pSpi->forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
-			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 Flag\n",id));
-		}
-	}
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  * If no Target, bus reset on 1st I/O. Set the flag to
  * prevent any future negotiations to this device.
@@ -4064,6 +3978,26 @@
 	return 0;
 }
 
+/* Search IOC page 3 to determine if this is hidden physical disk
+ */
+/* Search IOC page 3 to determine if this is hidden physical disk
+ */
+static int
+mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
+{
+	int i;
+
+	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)
+		return 0;
+
+	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+		if (id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
+			return 1;
+	}
+
+	return 0;
+}
+
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -4207,26 +4141,6 @@
 	return;
 }
 
-/* Search IOC page 3 to determine if this is hidden physical disk
- */
-/* Search IOC page 3 to determine if this is hidden physical disk
- */
-static int
-mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
-{
-	int i;
-
-	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)
-		return 0;
-
-	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
-		if (id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
-			return 1;
-	}
-
-	return 0;
-}
-
 /* Write SDP1 if no QAS has been enabled
  */
 static void
@@ -5590,6 +5504,95 @@
 		break;
 	}
 }
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/* If DV disabled (negoNvram set to USE_NVARM) or if not LUN 0, return.
+ * Else set the NEED_DV flag after Read Capacity Issued (disks)
+ * or Mode Sense (cdroms).
+ *
+ * Tapes, initTarget will set this flag on completion of Inquiry command.
+ * Called only if DV_NOT_DONE flag is set
+ */
+static void
+mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)
+{
+	MPT_ADAPTER	*ioc = hd->ioc;
+	u8 cmd;
+	SpiCfgData	*pSpi;
+
+	ddvtprintk((MYIOC_s_NOTE_FMT
+		" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
+		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));
+
+	if ((pReq->LUN[1] != 0) || (hd->negoNvram != 0))
+		return;
+
+	cmd = pReq->CDB[0];
+
+	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
+		pSpi = &ioc->spi_data;
+		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && ioc->raid_data.pIocPg3) {
+			/* Set NEED_DV for all hidden disks
+			 */
+			Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
+			int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
+
+			while (numPDisk) {
+				pSpi->dvStatus[pPDisk->PhysDiskID] |= MPT_SCSICFG_NEED_DV;
+				ddvtprintk(("NEED_DV set for phys disk id %d\n", pPDisk->PhysDiskID));
+				pPDisk++;
+				numPDisk--;
+			}
+		}
+		pSpi->dvStatus[pReq->TargetID] |= MPT_SCSICFG_NEED_DV;
+		ddvtprintk(("NEED_DV set for visible disk id %d\n", pReq->TargetID));
+	}
+}
+
+/* mptscsih_raid_set_dv_flags()
+ *
+ * New or replaced disk. Set DV flag and schedule DV.
+ */
+static void
+mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)
+{
+	MPT_ADAPTER	*ioc = hd->ioc;
+	SpiCfgData	*pSpi = &ioc->spi_data;
+	Ioc3PhysDisk_t	*pPDisk;
+	int		 numPDisk;
+
+	if (hd->negoNvram != 0)
+		return;
+
+	ddvtprintk(("DV requested for phys disk id %d\n", id));
+	if (ioc->raid_data.pIocPg3) {
+		pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
+		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
+		while (numPDisk) {
+			if (id == pPDisk->PhysDiskNum) {
+				pSpi->dvStatus[pPDisk->PhysDiskID] =
+				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);
+				pSpi->forceDv = MPT_SCSICFG_NEED_DV;
+				ddvtprintk(("NEED_DV set for phys disk id %d\n",
+				    pPDisk->PhysDiskID));
+				break;
+			}
+			pPDisk++;
+			numPDisk--;
+		}
+
+		if (numPDisk == 0) {
+			/* The physical disk that needs DV was not found
+			 * in the stored IOC Page 3. The driver must reload
+			 * this page. DV routine will set the NEED_DV flag for
+			 * all phys disks that have DV_NOT_DONE set.
+			 */
+			pSpi->forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
+			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 Flag\n",id));
+		}
+	}
+}
+
 #endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
 
 EXPORT_SYMBOL(mptscsih_remove);

--Boundary-00=_PL+eD1w9sC89R3g--

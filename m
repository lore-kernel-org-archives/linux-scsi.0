From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 4/7]  mptfusion - bus_type, change SCSI to SPI
Date: Wed, 16 Nov 2005 18:54:20 -0700
Message-ID: <200511161854.20218.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ML+eDVItXh1seAz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6530 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161093AbVKQB7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:51 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1t9SW011544
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:09 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xp3W001945
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_ML+eDVItXh1seAz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This changes to SPI for the bus_type enumeration.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--Boundary-00=_ML+eDVItXh1seAz
Content-Type: text/x-diff;
  charset="us-ascii";
  name="4-spi-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="4-spi-fix.patch"

diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2005-11-16 18:19:44.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2005-11-16 18:19:59.000000000 -0700
@@ -313,13 +313,13 @@
 		u32	 log_info = le32_to_cpu(mr->u.reply.IOCLogInfo);
 		if (ioc->bus_type == FC)
 			mpt_fc_log_info(ioc, log_info);
-		else if (ioc->bus_type == SCSI)
+		else if (ioc->bus_type == SPI)
 			mpt_sp_log_info(ioc, log_info);
 		else if (ioc->bus_type == SAS)
 			mpt_sas_log_info(ioc, log_info);
 	}
 	if (ioc_stat & MPI_IOCSTATUS_MASK) {
-		if (ioc->bus_type == SCSI &&
+		if (ioc->bus_type == SPI &&
 		    cb_idx != mpt_stm_index &&
 		    cb_idx != mpt_lan_index)
 			mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);
@@ -1381,7 +1381,7 @@
 	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_53C1030) {
 		ioc->prod_name = "LSI53C1030";
-		ioc->bus_type = SCSI;
+		ioc->bus_type = SPI;
 		/* 1030 Chip Fix. Disable Split transactions
 		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
 		 */
@@ -1394,7 +1394,7 @@
 	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_1030_53C1035) {
 		ioc->prod_name = "LSI53C1035";
-		ioc->bus_type = SCSI;
+		ioc->bus_type = SPI;
 	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064) {
 		ioc->prod_name = "LSISAS1064";
@@ -3047,7 +3047,7 @@
 	/* Clear the internal flash bad bit - autoincrementing register,
 	 * so must do two writes.
 	 */
-	if (ioc->bus_type == SCSI) {
+	if (ioc->bus_type == SPI) {
 		/*
 		 * 1030 and 1035 H/W errata, workaround to access
 		 * the ClearFlashBadSignatureBit
@@ -3157,7 +3157,7 @@
 	int cnt,cntdn;
 
 	dinitprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", ioc->name));
-	if (ioc->bus_type == SCSI) {
+	if (ioc->bus_type == SPI) {
 		/* Always issue a Msg Unit Reset first. This will clear some
 		 * SCSI bus hang conditions.
 		 */
@@ -3585,7 +3585,7 @@
 	dinitprintk((KERN_INFO MYNAM ": %s Now numSGE=%d num_sge=%d num_chain=%d\n",
 		ioc->name, numSGE, num_sge, num_chain));
 
-	if (ioc->bus_type == SCSI)
+	if (ioc->bus_type == SPI)
 		num_chain *= MPT_SCSI_CAN_QUEUE;
 	else
 		num_chain *= MPT_FC_CAN_QUEUE;
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-11-16 17:18:36.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2005-11-16 17:33:57.000000000 -0700
@@ -903,7 +903,7 @@
 
 typedef enum {
 	FC,
-	SCSI,
+	SPI,
 	SAS
 } BUS_TYPE;
 
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-11-16 17:15:55.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2005-11-16 18:09:23.000000000 -0700
@@ -677,7 +677,7 @@
 			sc->result = DID_RESET << 16;
 
 			/* GEM Workaround. */
-			if (ioc->bus_type == SCSI)
+			if (ioc->bus_type == SPI)
 				mptscsih_no_negotiate(hd, sc->device->id);
 			break;
 
@@ -1403,7 +1403,7 @@
 	SCpnt->host_scribble = NULL;
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	if (hd->ioc->bus_type == SCSI) {
+	if (hd->ioc->bus_type == SPI) {
 		int dvStatus = hd->ioc->spi_data.dvStatus[pTarget->target_id];
 		int issueCmd = 1;
 
@@ -2183,7 +2183,7 @@
 	vdev->bus_id = device->channel;
 	vdev->raidVolume = 0;
 	hd->Targets[device->id] = vdev;
-	if (hd->ioc->bus_type == SCSI) {
+	if (hd->ioc->bus_type == SPI) {
 		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {
 			vdev->raidVolume = 1;
 			ddvtprintk((KERN_INFO
@@ -2225,7 +2225,7 @@
 	kfree(hd->Targets[target]);
 	hd->Targets[target] = NULL;
 
-	if (hd->ioc->bus_type == SCSI) {
+	if (hd->ioc->bus_type == SPI) {
 		if (mptscsih_is_phys_disk(hd->ioc, target)) {
 			hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
 		} else {
@@ -2261,7 +2261,7 @@
 	if (!(pTarget = hd->Targets[sdev->id]))
 		return 0;
 
-	if (hd->ioc->bus_type == SCSI) {
+	if (hd->ioc->bus_type == SPI) {
 		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
 			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 				max_depth = 1;
@@ -2503,9 +2503,9 @@
 		/* 2. Chain Buffer initialization
 		 */
 
-		/* 4. Renegotiate to all devices, if SCSI
+		/* 4. Renegotiate to all devices, if SPI
 		 */
-		if (ioc->bus_type == SCSI) {
+		if (ioc->bus_type == SPI) {
 			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));
 			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | MPT_SCSICFG_USE_NVRAM);
 		}
@@ -2534,7 +2534,7 @@
 
 		/* 7. Set flag to force DV and re-read IOC Page 3
 		 */
-		if (ioc->bus_type == SCSI) {
+		if (ioc->bus_type == SPI) {
 			ioc->spi_data.forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
 			ddvtprintk(("Set reload IOC Pg3 Flag\n"));
 		}
@@ -2576,7 +2576,7 @@
 		break;
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		if (hd && (ioc->bus_type == SCSI) && (hd->soft_resets < -1))
+		if (hd && (ioc->bus_type == SPI) && (hd->soft_resets < -1))
 			hd->soft_resets++;
 		break;
 	case MPI_EVENT_LOGOUT:				/* 09 */
@@ -2601,7 +2601,7 @@
 		    (pMpiEventDataRaid_t) pEvReply->Data;
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 		/* Domain Validation Needed */
-		if (ioc->bus_type == SCSI &&
+		if (ioc->bus_type == SPI &&
 		    pRaidEventData->ReasonCode ==
 		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)
 			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);
@@ -2682,7 +2682,7 @@
 	indexed_lun = (lun % 32);
 	vdev->luns[lun_index] |= (1 << indexed_lun);
 
-	if (hd->ioc->bus_type == SCSI) {
+	if (hd->ioc->bus_type == SPI) {
 		if ((data[0] == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
 			/* Treat all Processors as SAF-TE if
 			 * command line option is set */
@@ -3968,10 +3968,10 @@
 	if (id == hostId)
 		id++;
 
-	/* Write SDP1 for all SCSI devices
+	/* Write SDP1 for all SPI devices
 	 * Alloc memory and set up config buffer
 	 */
-	if (ioc->bus_type == SCSI) {
+	if (ioc->bus_type == SPI) {
 		if (ioc->spi_data.sdp1length > 0) {
 			pcfg1Data = (SCSIDevicePage1_t *)pci_alloc_consistent(ioc->pcidev,
 					 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);
@@ -4113,8 +4113,8 @@
 
 			msleep(250);
 
-			/* DV only to SCSI adapters */
-			if (ioc->bus_type != SCSI)
+			/* DV only to SPI adapters */
+			if (ioc->bus_type != SPI)
 				continue;
 
 			/* Make sure everything looks ok */

--Boundary-00=_ML+eDVItXh1seAz--

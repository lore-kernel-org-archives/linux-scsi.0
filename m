From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fusion RAID class support
Date: Sun, 29 Jan 2006 12:45:59 -0600
Message-ID: <1138560359.3352.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:12939 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751046AbWA2SqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jan 2006 13:46:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This refreshes the RAID class support to match the current driver.  It
still only applies the raid class to the 1030 (I suppose it could also
be applied now to the SAS raid devices, but I haven't yet looked into
that).

James

[PATCH] Add raid_class support to mptspi

This adds basic raid monitoring (via the raid class) to the mptspi
driver.


Index: BUILD-2.6/drivers/message/fusion/Kconfig
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/Kconfig	2006-01-29 12:17:43.000000000 -0600
+++ BUILD-2.6/drivers/message/fusion/Kconfig	2006-01-29 12:25:26.000000000 -0600
@@ -10,6 +10,7 @@
 	depends on PCI && SCSI
 	select FUSION
 	select SCSI_SPI_ATTRS
+	select RAID_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
 
Index: BUILD-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptbase.h	2006-01-29 12:17:43.000000000 -0600
+++ BUILD-2.6/drivers/message/fusion/mptbase.h	2006-01-29 12:25:26.000000000 -0600
@@ -332,6 +332,8 @@
  */
 typedef struct _VirtTarget {
 	struct scsi_target	*starget;
+	RaidVolumePage0_t	*raidVolume;	/* set, if RAID Volume */
+	int			 raidpg0size;
 	u8			 tflags;
 	u8			 ioc_id;
 	u8			 target_id;
@@ -340,7 +342,6 @@
 	u8			 maxOffset;	/* 0 if async */
 	u8			 maxWidth;	/* 0 if narrow, 1 if wide */
 	u8			 negoFlags;	/* bit field, see above */
-	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
 	u32			 num_luns;
 	u32			 luns[8];		/* Max LUNs is 256 */
@@ -894,10 +895,15 @@
 typedef struct _MPT_LOCAL_REPLY {
 	ConfigPageHeader_t header;
 	int	completion;
-	u8	sense[SCSI_STD_SENSE_BYTES];
-	u8	scsiStatus;
-	u8	skip;
-	u32	pad;
+	union {
+		struct {
+			u8	sense[SCSI_STD_SENSE_BYTES];
+			u8	scsiStatus;
+			u8	skip;
+			u32	pad;
+		} s;
+		u64	r[6];
+	} u;
 } MPT_LOCAL_REPLY;
 
 #define MPT_HOST_BUS_UNKNOWN		(0xFF)
Index: BUILD-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptscsih.c	2006-01-29 12:23:05.000000000 -0600
+++ BUILD-2.6/drivers/message/fusion/mptscsih.c	2006-01-29 12:29:31.000000000 -0600
@@ -2114,7 +2114,15 @@
 		vtarget->bus_id = sdev->channel;
 		if (hd->ioc->bus_type == SPI && sdev->channel == 0) {
 			if (hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
-				vtarget->raidVolume = 1;
+				struct _CONFIG_PAGE_HEADER hdr;
+				if (mptscsih_read_raid_page0(sdev, (struct _CONFIG_PAGE_RAID_VOL_0 *)&hdr, sizeof(hdr), 0) < 0)
+					goto out_free;
+				vtarget->raidpg0size = hdr.PageLength * 4;
+				vtarget->raidVolume = kmalloc(vtarget->raidpg0size, GFP_KERNEL);
+				if (!vtarget->raidVolume)
+					goto out_free;
+				if (mptscsih_read_raid_page0(sdev, vtarget->raidVolume, vtarget->raidpg0size, hdr.PageVersion) < 0)
+					goto out_free;
 				ddvtprintk((KERN_INFO
 				    "RAID Volume @ id %d\n", sdev->id));
 			}
@@ -2122,6 +2130,12 @@
 	}
 	vtarget->num_luns++;
 	return 0;
+ out_free:
+	sdev_printk(KERN_ERR, sdev, "failed to allocate RAID data\n");
+	if (vtarget)
+		kfree(vtarget->raidVolume);
+	kfree(vdev);
+	return -EINVAL;
 }
 
 /*
@@ -2159,6 +2173,7 @@
 	if (vtarget->num_luns == 0) {
 		mptscsih_negotiate_to_asyn_narrow(hd, vtarget);
 		hd->Targets[sdev->id] = NULL;
+		kfree(vtarget->raidVolume);
 	}
 	mptscsih_synchronize_cache(hd, vdevice);
 	kfree(vdevice);
@@ -2637,7 +2652,7 @@
 			 * bit 1 QAS support, non-raid only
 			 * bit 0 IU support
 			 */
-			if (target->raidVolume == 1) {
+			if (target->raidVolume) {
 				noQas = 0;
 			}
 		} else {
@@ -2900,7 +2915,7 @@
 			hd->ioc->name, mf, mr, req_idx));
 
 	hd->pLocal = &hd->localReply;
-	hd->pLocal->scsiStatus = 0;
+	hd->pLocal->u.s.scsiStatus = 0;
 
 	/* If target struct exists, clear sense valid flag.
 	 */
@@ -2954,7 +2969,9 @@
 					completionCode = MPT_SCANDV_GOOD;
 				else
 					completionCode = MPT_SCANDV_SOME_ERROR;
-				memcpy(hd->pLocal->sense, pr, sizeof(hd->pLocal->sense));
+				memcpy(hd->pLocal->u.r, pr,
+				       min((size_t)pr->MsgLength*4,
+					   sizeof(hd->pLocal->u.r)));
 
 			} else if (pReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
 				u8		*sense_data;
@@ -2963,13 +2980,13 @@
 				/* save sense data in global structure
 				 */
 				completionCode = MPT_SCANDV_SENSE;
-				hd->pLocal->scsiStatus = scsi_status;
+				hd->pLocal->u.s.scsiStatus = scsi_status;
 				sense_data = ((u8 *)hd->ioc->sense_buf_pool +
 					(req_idx * MPT_SENSE_BUFFER_ALLOC));
 
 				sz = min_t(int, pReq->SenseBufferLength,
 							SCSI_STD_SENSE_BYTES);
-				memcpy(hd->pLocal->sense, sense_data, sz);
+				memcpy(hd->pLocal->u.s.sense, sense_data, sz);
 
 				ddvprintk((KERN_NOTICE "  Check Condition, sense ptr %p\n",
 						sense_data));
@@ -2985,7 +3002,7 @@
 				completionCode = MPT_SCANDV_DID_RESET;
 			else {
 				completionCode = MPT_SCANDV_GOOD;
-				hd->pLocal->scsiStatus = scsi_status;
+				hd->pLocal->u.s.scsiStatus = scsi_status;
 			}
 			break;
 
@@ -3301,7 +3318,7 @@
 
 	if (hd->pLocal) {
 		rc = hd->pLocal->completion;
-		hd->pLocal->skip = 0;
+		hd->pLocal->u.s.skip = 0;
 
 		/* Always set fatal error codes in some cases.
 		 */
@@ -3439,6 +3456,153 @@
 		mptscsih_do_cmd(hd, &iocmd);
 }
 
+int
+mptscsih_raid_action(MPT_SCSI_HOST *hd, int action, int volume, int volbus,
+		     MpiRaidActionReply_t *pRep, int repLen)
+{
+	MpiRaidActionRequest_t	*pReq;
+	MPT_FRAME_HDR		*mf;
+
+	/* Get and Populate a free Frame
+	 */
+	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
+		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
+					hd->ioc->name));
+		return -EAGAIN;
+	}
+	pReq = (MpiRaidActionRequest_t *)mf;
+	pReq->Action = action;
+	pReq->Reserved1 = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_RAID_ACTION;
+	pReq->VolumeID = volume;
+	pReq->VolumeBus = volbus;
+	pReq->PhysDiskNum = 0;
+	pReq->MsgFlags = 0;
+	pReq->Reserved2 = 0;
+	pReq->ActionDataWord = 0; /* Reserved for this action */
+
+	mpt_add_sge((char *)&pReq->ActionDataSGE,
+		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
+
+	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
+			hd->ioc->name, action, io->id));
+
+	hd->pLocal = NULL;
+	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
+	hd->scandv_wait_done = 0;
+
+	/* Save cmd pointer, for resource free if timeout or
+	 * FW reload occurs
+	 */
+	hd->cmdPtr = mf;
+
+	add_timer(&hd->timer);
+	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);
+	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
+
+	if ((hd->pLocal == NULL) || (hd->pLocal->completion != 0))
+		return -1;
+
+	if (pRep)
+		memcpy(pRep, hd->pLocal->u.r, repLen);
+
+	return 0;
+}
+EXPORT_SYMBOL(mptscsih_raid_action);
+
+int
+mptscsih_read_raid_page0(struct scsi_device *sdev,
+			 struct _CONFIG_PAGE_RAID_VOL_0 *pass_pg0,
+			 int pg0len, int version)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_RAID_VOL_0 *pg0;
+	dma_addr_t pg0_dma;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, pg0len, &pg0_dma, GFP_KERNEL);
+	if (pg0 == NULL) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			   "dma_alloc_coherent for raid failed\n");
+		return -EINVAL;
+	}
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = version;
+	hdr.PageLength = pg0len / 4;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.dir = 0;
+	cfg.pageAddr = sdev->id;
+
+	if (mpt_config(ioc, &cfg)) {
+		dev_printk(KERN_ERR, &sdev->sdev_gendev, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+	memcpy(pass_pg0, pg0, pg0len);
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, pg0len, pg0, pg0_dma);
+	return err;
+}
+EXPORT_SYMBOL(mptscsih_read_raid_page0);
+
+static int
+mptscsih_find_physDiskNum(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID)
+{
+	int i;
+
+	struct _CONFIG_PAGE_IOC_3 *pg3 = hd->ioc->raid_data.pIocPg3;
+
+	for (i = 0; i < pg3->NumPhysDisks; i++) {
+		if (physDiskID == pg3->PhysDisk[i].PhysDiskID &&
+		    physDiskBus == pg3->PhysDisk[i].PhysDiskBus) {
+			return pg3->PhysDisk[i].PhysDiskNum;
+		}
+	}
+	return -1;
+}
+
+struct scsi_device *
+mptscsih_find_raid_device(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID)
+{
+	struct Scsi_Host *shost = hd->ioc->sh;
+	struct scsi_device *sdev, *sdev_found = NULL;
+	int physDiskNum = mptscsih_find_physDiskNum(hd, physDiskBus, physDiskID);
+	if (physDiskNum < 0)
+		return NULL;
+
+	shost_for_each_device(sdev, shost) {
+		struct scsi_target *starget = scsi_target(sdev);
+		VirtTarget *vtarget = starget->hostdata;
+		int j;
+
+		if (!vtarget || !vtarget->raidVolume)
+			continue;
+		for (j = 0; j < vtarget->raidVolume->NumPhysDisks; j++) {
+			if (vtarget->raidVolume->PhysDisk[j].PhysDiskNum ==
+			    physDiskNum)
+				sdev_found = sdev;
+		}
+	}
+	return sdev_found;
+}
+EXPORT_SYMBOL(mptscsih_find_raid_device);
+
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
 #ifdef CONFIG_PM
Index: BUILD-2.6/drivers/message/fusion/mptscsih.h
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptscsih.h	2006-01-29 12:17:43.000000000 -0600
+++ BUILD-2.6/drivers/message/fusion/mptscsih.h	2006-01-29 12:26:21.000000000 -0600
@@ -99,3 +99,12 @@
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
+extern int mptscsih_raid_action(MPT_SCSI_HOST *hd, int action, int volume,
+				int volbus, MpiRaidActionReply_t *pRep,
+				int repLen);
+extern int mptscsih_read_raid_page0(struct scsi_device *sdev,
+				    struct _CONFIG_PAGE_RAID_VOL_0 *pass_pg0,
+				    int pg0len, int version);
+extern struct scsi_device *
+mptscsih_find_raid_device(struct _MPT_SCSI_HOST *hd, int physDiskBus,
+			  int physDiskID);
Index: BUILD-2.6/drivers/message/fusion/mptspi.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptspi.c	2006-01-29 12:17:43.000000000 -0600
+++ BUILD-2.6/drivers/message/fusion/mptspi.c	2006-01-29 12:25:26.000000000 -0600
@@ -91,6 +91,7 @@
 static void mptspi_write_width(struct scsi_target *, int);
 
 static struct scsi_transport_template *mptspi_transport_template = NULL;
+static struct raid_template *mptspi_raid_template = NULL;
 
 static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
@@ -222,64 +223,12 @@
 	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
 }
 
-static int
-mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, int disk)
-{
-	MpiRaidActionRequest_t	*pReq;
-	MPT_FRAME_HDR		*mf;
-
-	/* Get and Populate a free Frame
-	 */
-	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
-		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
-					hd->ioc->name));
-		return -EAGAIN;
-	}
-	pReq = (MpiRaidActionRequest_t *)mf;
-	if (quiesce)
-		pReq->Action = MPI_RAID_ACTION_QUIESCE_PHYS_IO;
-	else
-		pReq->Action = MPI_RAID_ACTION_ENABLE_PHYS_IO;
-	pReq->Reserved1 = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_RAID_ACTION;
-	pReq->VolumeID = disk;
-	pReq->VolumeBus = 0;
-	pReq->PhysDiskNum = 0;
-	pReq->MsgFlags = 0;
-	pReq->Reserved2 = 0;
-	pReq->ActionDataWord = 0; /* Reserved for this action */
-
-	mpt_add_sge((char *)&pReq->ActionDataSGE,
-		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
-
-	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
-			hd->ioc->name, action, io->id));
-
-	hd->pLocal = NULL;
-	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
-	hd->scandv_wait_done = 0;
-
-	/* Save cmd pointer, for resource free if timeout or
-	 * FW reload occurs
-	 */
-	hd->cmdPtr = mf;
-
-	add_timer(&hd->timer);
-	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);
-	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
-
-	if ((hd->pLocal == NULL) || (hd->pLocal->completion != 0))
-		return -1;
-
-	return 0;
-}
-
 static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
 			     struct scsi_device *sdev)
 {
 	if (sdev->channel &&
-	    mptscsih_quiesce_raid(hd, 1, sdev->id) < 0) {
+	    mptscsih_raid_action(hd, MPI_RAID_ACTION_QUIESCE_PHYS_IO,
+				 sdev->id, 0, NULL, 0) < 0) {
 		starget_printk(KERN_ERR, scsi_target(sdev),
 			       "Integrated RAID quiesce failed\n");
 		return;
@@ -288,7 +237,8 @@
 	spi_dv_device(sdev);
 
 	if (sdev->channel &&
-	    mptscsih_quiesce_raid(hd, 0, sdev->id) < 0)
+	    mptscsih_raid_action(hd, MPI_RAID_ACTION_ENABLE_PHYS_IO,
+				 sdev->id, 0, NULL, 0) < 0)
 		starget_printk(KERN_ERR, scsi_target(sdev),
 			       "Integrated RAID resume failed\n");
 
@@ -324,6 +274,29 @@
 	if (ret)
 		return ret;
 
+	if (!sdev->channel && (hd->ioc->raid_data.isRaid & (1 << sdev->id))) {
+		enum raid_level level = RAID_LEVEL_UNKNOWN;
+
+		switch (hd->ioc->raid_data.pIocPg2->RaidVolume[sdev->id].VolumeType) {
+		case MPI_RAID_VOL_TYPE_IS:
+			level = RAID_LEVEL_0;
+			break;
+		case MPI_RAID_VOL_TYPE_IME:
+		case MPI_RAID_VOL_TYPE_IM:
+		case MPI_RAID_VOL_TYPE_RAID_10:
+			level = RAID_LEVEL_1;
+			break;
+		case MPI_RAID_VOL_TYPE_RAID_5:
+		case MPI_RAID_VOL_TYPE_RAID_50:
+			level = RAID_LEVEL_5;
+			break;
+		case MPI_RAID_VOL_TYPE_RAID_6:
+			level = RAID_LEVEL_6;
+			break;
+		}
+		raid_set_level(mptspi_raid_template, &sdev->sdev_gendev, level);
+	}
+
 	if ((sdev->channel || !(hd->ioc->raid_data.isRaid & (1 << sdev->id))) &&
 	    !spi_initial_dv(sdev->sdev_target))
 		mptspi_dv_device(hd, sdev);
@@ -703,6 +676,104 @@
 	.deny_binding	= mptspi_deny_binding,
 };
 
+static int mptspi_is_raid(struct device *dev) {
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	return ((hd->ioc->raid_data.isRaid & (1 << sdev->id)) &&
+		sdev->channel == 0) ? 1 : 0;
+}
+
+static void mptspi_get_resync(struct device *dev)
+{
+	struct {
+		MpiRaidActionReply_t r;
+		u32	pad[sizeof(MpiRaidVolIndicator_t)/sizeof(u32) - 1];
+	} buf;
+	u32 total, remain;
+	int shift;
+	MpiRaidVolIndicator_t *ri = (MpiRaidVolIndicator_t *)&buf.r.ActionData;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (mptscsih_raid_action(hd, MPI_RAID_ACTION_INDICATOR_STRUCT,
+				 sdev->id, 0, &buf.r, sizeof(buf)) < 0) {
+		sdev_printk(KERN_ERR, sdev,
+			   "Integrated RAID indicator failed\n");
+		return;
+	}
+	shift = fls(le32_to_cpu(ri->TotalBlocks.High));
+	if (shift > 0) {
+		total = le32_to_cpu(ri->TotalBlocks.Low) >> shift;
+		total |= le32_to_cpu(ri->TotalBlocks.High) << (32 - shift);
+		remain = le32_to_cpu(ri->BlocksRemaining.Low) >> shift;
+		remain |= le32_to_cpu(ri->BlocksRemaining.High) << (32 - shift);
+	} else {
+		total = le32_to_cpu(ri->TotalBlocks.Low);
+		remain = le32_to_cpu(ri->BlocksRemaining.Low);
+	}
+	total /= RAID_MAX_RESYNC;
+	remain /= RAID_MAX_RESYNC;
+	remain = total - remain;
+	remain *= RAID_MAX_RESYNC;
+	if (total)
+		raid_set_resync(mptspi_raid_template, dev, remain/total);
+	else
+		raid_set_resync(mptspi_raid_template, dev, 0);
+}
+
+static void mptspi_get_state(struct device *dev)
+{
+	MpiRaidActionReply_t r;
+	enum raid_state state = RAID_STATE_UNKNOWN;
+	u32 volstate;
+
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (mptscsih_raid_action(hd, MPI_RAID_ACTION_STATUS,
+				 sdev->id, 0, &r, sizeof(r)) < 0) {
+		sdev_printk(KERN_ERR, sdev,
+			   "Integrated RAID status failed\n");
+		return;
+	}
+
+	volstate = le32_to_cpu(r.VolumeStatus);
+
+	if (volstate & MPI_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS)
+		state = RAID_STATE_RESYNCING;
+	else
+		switch((volstate >> 8) & 0xff) {
+		case MPI_RAIDVOL0_STATUS_STATE_OPTIMAL:
+			state = RAID_STATE_ACTIVE;
+			break;
+		case  MPI_RAIDVOL0_STATUS_STATE_DEGRADED:
+			state = RAID_STATE_DEGRADED;
+			break;
+		case MPI_RAIDVOL0_STATUS_STATE_FAILED:
+		case MPI_RAIDVOL0_STATUS_STATE_MISSING:
+			state = RAID_STATE_OFFLINE;
+			break;
+		default:
+			sdev_printk(KERN_ERR, sdev,
+				   "Integrated RAID status unknown value = 0x%x\n", r.VolumeStatus);
+			break;
+		}
+
+	raid_set_state(mptspi_raid_template, dev, state);
+}
+
+static struct raid_function_template mptspi_raid_functions = {
+	.cookie		= &mptspi_driver_template,
+	.is_raid	= mptspi_is_raid,
+	.get_resync	= mptspi_get_resync,
+	.get_state	= mptspi_get_state,
+};
+
+
 /****************************************************************************
  * Supported hardware
  */
@@ -937,6 +1008,23 @@
 	}
 
 	scsi_scan_host(sh);
+	if (hd->ioc->raid_data.isRaid) {
+		struct scsi_device *sdev;
+
+		/* now assemble the raid devices */
+		shost_for_each_device(sdev, sh) {
+			struct scsi_target *starget = scsi_target(sdev);
+			VirtTarget *vtarget = starget->hostdata;
+			struct scsi_device *sdev_raid;
+			if ((vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) == 0)
+				continue;
+			sdev_raid = mptscsih_find_raid_device(hd, 0, sdev->id);
+			if(sdev_raid != NULL)
+				raid_component_add(mptspi_raid_template,
+						   &sdev_raid->sdev_gendev,
+						   &sdev->sdev_gendev);
+		}
+	}
 	return 0;
 
 out_mptspi_probe:
@@ -972,6 +1060,11 @@
 	mptspi_transport_template = spi_attach_transport(&mptspi_transport_functions);
 	if (!mptspi_transport_template)
 		return -ENODEV;
+	mptspi_raid_template = raid_class_attach(&mptspi_raid_functions);
+	if (!mptspi_raid_template) {
+		spi_release_transport(mptspi_transport_template);
+		return -ENODEV;
+	}
 
 	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
 	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
@@ -1013,6 +1106,7 @@
 	mpt_deregister(mptspiTaskCtx);
 	mpt_deregister(mptspiDoneCtx);
 	spi_release_transport(mptspi_transport_template);
+	raid_class_release(mptspi_raid_template);
 }
 
 module_init(mptspi_init);



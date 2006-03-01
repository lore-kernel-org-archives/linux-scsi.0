From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH 1/2] mptspi: Add transport class Domain Validation
Date: Wed, 01 Mar 2006 09:02:49 -0600
Message-ID: <1141225370.3276.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1928 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030209AbWCAPC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 10:02:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>

This is the first half of a patch to add the generic domain validation
to mptspi.  It also creates a secondary "virtual" channel for raid
component devices since these are now exported with no_uld_attach.

What Eric and I would have really liked is to export all physical
components on channel 0 and all raid components on channel 1.
Unfortunately, this would result in device renumbering on platforms with
mixed RAID/Physical devices which was considered unacceptable for
userland stability reasons.

Still to be done is to plug back the extra parameter setting and DV
pieces on reset and hotplug.

James

diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -9,6 +9,7 @@ config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
 	select FUSION
+	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
 
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1120,65 +1120,6 @@ mpt_verify_adapter(int iocid, MPT_ADAPTE
 	return -1;
 }
 
-int
-mpt_alt_ioc_wait(MPT_ADAPTER *ioc)
-{
-	int loop_count = 30 * 4;  /* Wait 30 seconds */
-	int status = -1; /* -1 means failed to get board READY */
-
-	do {
-		spin_lock(&ioc->initializing_hba_lock);
-		if (ioc->initializing_hba_lock_flag == 0) {
-			ioc->initializing_hba_lock_flag=1;
-			spin_unlock(&ioc->initializing_hba_lock);
-			status = 0;
-			break;
-		}
-		spin_unlock(&ioc->initializing_hba_lock);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ/4);
-	} while (--loop_count);
-
-	return status;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	mpt_bringup_adapter - This is a wrapper function for mpt_do_ioc_recovery
- *	@ioc: Pointer to MPT adapter structure
- *	@sleepFlag: Use schedule if CAN_SLEEP else use udelay.
- *
- *	This routine performs all the steps necessary to bring the IOC
- *	to a OPERATIONAL state.
- *
- *      Special Note: This function was added with spin lock's so as to allow
- *      the dv(domain validation) work thread to succeed on the other channel
- *      that maybe occuring at the same time when this function is called.
- *      Without this lock, the dv would fail when message frames were
- *      requested during hba bringup on the alternate ioc.
- */
-static int
-mpt_bringup_adapter(MPT_ADAPTER *ioc, int sleepFlag)
-{
-	int r;
-
-	if(ioc->alt_ioc) {
-		if((r=mpt_alt_ioc_wait(ioc->alt_ioc)!=0))
-			return r;
-	}
-
-	r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
-	    CAN_SLEEP);
-
-	if(ioc->alt_ioc) {
-		spin_lock(&ioc->alt_ioc->initializing_hba_lock);
-		ioc->alt_ioc->initializing_hba_lock_flag=0;
-		spin_unlock(&ioc->alt_ioc->initializing_hba_lock);
-	}
-
-return r;
-}
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mpt_attach - Install a PCI intelligent MPT adapter.
@@ -1482,7 +1423,8 @@ mpt_attach(struct pci_dev *pdev, const s
 	 */
 	mpt_detect_bound_ports(ioc, pdev);
 
-	if ((r = mpt_bringup_adapter(ioc, CAN_SLEEP)) != 0){
+	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
+	    CAN_SLEEP)) != 0){
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
@@ -1629,7 +1571,6 @@ mpt_resume(struct pci_dev *pdev)
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
-	int ii;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1643,14 +1584,6 @@ mpt_resume(struct pci_dev *pdev)
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
 	ioc->active = 1;
 
-	/* F/W not running */
-	if(!CHIPREG_READ32(&ioc->chip->Doorbell)) {
-		/* enable domain validation flags */
-		for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-			ioc->spi_data.dvStatus[ii] |= MPT_SCSICFG_NEED_DV;
-		}
-	}
-
 	printk(MYIOC_s_INFO_FMT
 		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
 		ioc->name,
@@ -6435,7 +6368,6 @@ EXPORT_SYMBOL(mpt_read_ioc_pg_3);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
-EXPORT_SYMBOL(mpt_alt_ioc_wait);
 EXPORT_SYMBOL(mptbase_GetFcPortPage0);
 
 
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -331,6 +331,7 @@ typedef struct _SYSIF_REGS
  *	VirtDevice - FC LUN device or SCSI target device
  */
 typedef struct _VirtTarget {
+	struct scsi_target	*starget;
 	u8			 tflags;
 	u8			 ioc_id;
 	u8			 target_id;
@@ -343,7 +344,6 @@ typedef struct _VirtTarget {
 	u8			 type;		/* byte 0 of Inquiry data */
 	u32			 num_luns;
 	u32			 luns[8];		/* Max LUNs is 256 */
-	u8			 inq_data[8];
 } VirtTarget;
 
 typedef struct _VirtDevice {
@@ -364,6 +364,7 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_Q_YES		0x08
 #define MPT_TARGET_FLAGS_VALID_56	0x10
 #define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20
+#define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
 
 /*
  *	/proc/mpt interface
@@ -447,13 +448,6 @@ typedef struct _mpt_ioctl_events {
  *	Substructure to store SCSI specific configuration page data
  */
 						/* dvStatus defines: */
-#define MPT_SCSICFG_NEGOTIATE		0x01	/* Negotiate on next IO */
-#define MPT_SCSICFG_NEED_DV		0x02	/* Schedule DV */
-#define MPT_SCSICFG_DV_PENDING		0x04	/* DV on this physical id pending */
-#define MPT_SCSICFG_DV_NOT_DONE		0x08	/* DV has not been performed */
-#define MPT_SCSICFG_BLK_NEGO		0x10	/* WriteSDP1 with WDTR and SDTR disabled */
-#define MPT_SCSICFG_RELOAD_IOC_PG3	0x20	/* IOC Pg 3 data is obsolete */
-						/* Args passed to writeSDP1: */
 #define MPT_SCSICFG_USE_NVRAM		0x01	/* WriteSDP1 using NVRAM */
 #define MPT_SCSICFG_ALL_IDS		0x02	/* WriteSDP1 to all IDS */
 /* #define MPT_SCSICFG_BLK_NEGO		0x10	   WriteSDP1 with WDTR and SDTR disabled */
@@ -464,7 +458,6 @@ typedef	struct _SpiCfgData {
 	IOCPage4_t	*pIocPg4;		/* SEP devices addressing */
 	dma_addr_t	 IocPg4_dma;		/* Phys Addr of IOCPage4 data */
 	int		 IocPg4Sz;		/* IOCPage4 size */
-	u8		 dvStatus[MPT_MAX_SCSI_DEVICES];
 	u8		 minSyncFactor;		/* 0xFF if async */
 	u8		 maxSyncOffset;		/* 0 if async */
 	u8		 maxBusWidth;		/* 0 if narrow, 1 if wide */
@@ -474,13 +467,11 @@ typedef	struct _SpiCfgData {
 	u8		 sdp0version;		/* SDP0 version */
 	u8		 sdp0length;		/* SDP0 length  */
 	u8		 dvScheduled;		/* 1 if scheduled */
-	u8		 forceDv;		/* 1 to force DV scheduling */
 	u8		 noQas;			/* Disable QAS for this adapter */
 	u8		 Saf_Te;		/* 1 to force all Processors as
 						 * SAF-TE if Inquiry data length
 						 * is too short to check for SAF-TE
 						 */
-	u8		 mpt_dv;		/* command line option: enhanced=1, basic=0 */
 	u8		 bus_reset;		/* 1 to allow bus reset */
 	u8		 rsvd[1];
 }SpiCfgData;
@@ -1033,7 +1024,6 @@ extern int	 mpt_findImVolumes(MPT_ADAPTE
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 extern int	 mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
-extern int	 mpt_alt_ioc_wait(MPT_ADAPTER *ioc);
 
 /*
  *  Public data decl's...
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -60,16 +60,6 @@
 
 #define MPT_SCSI_MAX_SECTORS    8192
 
-/* To disable domain validation, uncomment the
- * following line. No effect for FC devices.
- * For SCSI devices, driver will negotiate to
- * NVRAM settings (if available) or to maximum adapter
- * capabilities.
- */
-
-#define MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-
-
 /* SCSI driver setup structure. Settings can be overridden
  * by command line options.
  */
@@ -109,3 +99,4 @@ extern int mptscsih_ioc_reset(MPT_ADAPTE
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
+extern int mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -56,12 +56,15 @@
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/raid_class.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -76,20 +79,6 @@ MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
 /* Command line args */
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-static int mpt_dv = MPTSCSIH_DOMAIN_VALIDATION;
-module_param(mpt_dv, int, 0);
-MODULE_PARM_DESC(mpt_dv, " DV Algorithm: enhanced=1, basic=0 (default=MPTSCSIH_DOMAIN_VALIDATION=1)");
-
-static int mpt_width = MPTSCSIH_MAX_WIDTH;
-module_param(mpt_width, int, 0);
-MODULE_PARM_DESC(mpt_width, " Max Bus Width: wide=1, narrow=0 (default=MPTSCSIH_MAX_WIDTH=1)");
-
-static ushort mpt_factor = MPTSCSIH_MIN_SYNC;
-module_param(mpt_factor, ushort, 0);
-MODULE_PARM_DESC(mpt_factor, " Min Sync Factor (default=MPTSCSIH_MIN_SYNC=0x08)");
-#endif
-
 static int mpt_saf_te = MPTSCSIH_SAF_TE;
 module_param(mpt_saf_te, int, 0);
 MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: enable=1  (default=MPTSCSIH_SAF_TE=0)");
@@ -98,10 +87,308 @@ static int mpt_pq_filter = 0;
 module_param(mpt_pq_filter, int, 0);
 MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
 
+static void mptspi_write_offset(struct scsi_target *, int);
+static void mptspi_write_width(struct scsi_target *, int);
+static int mptspi_write_spi_device_pg1(struct scsi_target *,
+				       struct _CONFIG_PAGE_SCSI_DEVICE_1 *);
+
+static struct scsi_transport_template *mptspi_transport_template = NULL;
+
 static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
+static int mptspi_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	int ret;
+
+	if (hd == NULL)
+		return -ENODEV;
+
+	ret = mptscsih_target_alloc(starget);
+	if (ret)
+		return ret;
+
+	/* if we're a device on virtual channel 1 and we're not part
+	 * of an array, just return here (otherwise the setup below
+	 * may actually affect a real physical device on channel 0 */
+	if (starget->channel == 1 &&
+	    mptscsih_raid_id_to_num(hd, starget->id) < 0)
+		return 0;
+
+	if (hd->ioc->spi_data.nvram &&
+	    hd->ioc->spi_data.nvram[starget->id] != MPT_HOST_NVRAM_INVALID) {
+		u32 nvram = hd->ioc->spi_data.nvram[starget->id];
+		spi_min_period(starget) = (nvram & MPT_NVRAM_SYNC_MASK) >> MPT_NVRAM_SYNC_SHIFT;
+		spi_max_width(starget) = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
+	} else {
+		spi_min_period(starget) = hd->ioc->spi_data.minSyncFactor;
+		spi_max_width(starget) = hd->ioc->spi_data.maxBusWidth;
+	}
+	spi_max_offset(starget) = hd->ioc->spi_data.maxSyncOffset;
+
+	spi_offset(starget) = 0;
+	mptspi_write_width(starget, 0);
+
+	return 0;
+}
+
+static int mptspi_read_spi_device_pg0(struct scsi_target *starget,
+			     struct _CONFIG_PAGE_SCSI_DEVICE_0 *pass_pg0)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 *pg0;
+	dma_addr_t pg0_dma;
+	int size;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	/* No SPI parameters for RAID devices */
+	if (starget->channel == 0 &&
+	    (hd->ioc->raid_data.isRaid & (1 << starget->id)))
+		return -1;
+
+	size = ioc->spi_data.sdp0length * 4;
+	/*
+	if (ioc->spi_data.sdp0length & 1)
+		size += size + 4;
+	size += 2048;
+	*/
+
+	pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg0_dma, GFP_KERNEL);
+	if (pg0 == NULL) {
+		starget_printk(KERN_ERR, starget, "dma_alloc_coherent for parameters failed\n");
+		return -EINVAL;
+	}
+
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = ioc->spi_data.sdp0version;
+	hdr.PageLength = ioc->spi_data.sdp0length;
+	hdr.PageNumber = 0;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg0_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.dir = 0;
+	cfg.pageAddr = starget->id;
+
+	if (mpt_config(ioc, &cfg)) {
+		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+	memcpy(pass_pg0, pg0, size);
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, size, pg0, pg0_dma);
+	return err;
+}
+
+static u32 mptspi_getRP(struct scsi_target *starget)
+{
+	u32 nego = 0;
+
+	nego |= spi_iu(starget) ? MPI_SCSIDEVPAGE1_RP_IU : 0;
+	nego |= spi_dt(starget) ? MPI_SCSIDEVPAGE1_RP_DT : 0;
+	nego |= spi_qas(starget) ? MPI_SCSIDEVPAGE1_RP_QAS : 0;
+	nego |= spi_hold_mcs(starget) ? MPI_SCSIDEVPAGE1_RP_HOLD_MCS : 0;
+	nego |= spi_wr_flow(starget) ? MPI_SCSIDEVPAGE1_RP_WR_FLOW : 0;
+	nego |= spi_rd_strm(starget) ? MPI_SCSIDEVPAGE1_RP_RD_STRM : 0;
+	nego |= spi_rti(starget) ? MPI_SCSIDEVPAGE1_RP_RTI : 0;
+	nego |= spi_pcomp_en(starget) ? MPI_SCSIDEVPAGE1_RP_PCOMP_EN : 0;
+
+	nego |= (spi_period(starget) <<  MPI_SCSIDEVPAGE1_RP_SHIFT_MIN_SYNC_PERIOD) & MPI_SCSIDEVPAGE1_RP_MIN_SYNC_PERIOD_MASK;
+	nego |= (spi_offset(starget) << MPI_SCSIDEVPAGE1_RP_SHIFT_MAX_SYNC_OFFSET) & MPI_SCSIDEVPAGE1_RP_MAX_SYNC_OFFSET_MASK;
+	nego |= spi_width(starget) ?  MPI_SCSIDEVPAGE1_RP_WIDE : 0;
+
+	return nego;
+}
+
+static void mptspi_read_parameters(struct scsi_target *starget)
+{
+	int nego;
+	struct _CONFIG_PAGE_SCSI_DEVICE_0 pg0;
+
+	mptspi_read_spi_device_pg0(starget, &pg0);
+
+	nego = le32_to_cpu(pg0.NegotiatedParameters);
+
+	spi_iu(starget) = (nego & MPI_SCSIDEVPAGE0_NP_IU) ? 1 : 0;
+	spi_dt(starget) = (nego & MPI_SCSIDEVPAGE0_NP_DT) ? 1 : 0;
+	spi_qas(starget) = (nego & MPI_SCSIDEVPAGE0_NP_QAS) ? 1 : 0;
+	spi_wr_flow(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WR_FLOW) ? 1 : 0;
+	spi_rd_strm(starget) = (nego & MPI_SCSIDEVPAGE0_NP_RD_STRM) ? 1 : 0;
+	spi_rti(starget) = (nego & MPI_SCSIDEVPAGE0_NP_RTI) ? 1 : 0;
+	spi_pcomp_en(starget) = (nego & MPI_SCSIDEVPAGE0_NP_PCOMP_EN) ? 1 : 0;
+	spi_hold_mcs(starget) = (nego & MPI_SCSIDEVPAGE0_NP_HOLD_MCS) ? 1 : 0;
+	spi_period(starget) = (nego & MPI_SCSIDEVPAGE0_NP_NEG_SYNC_PERIOD_MASK) >> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_PERIOD;
+	spi_offset(starget) = (nego & MPI_SCSIDEVPAGE0_NP_NEG_SYNC_OFFSET_MASK) >> MPI_SCSIDEVPAGE0_NP_SHIFT_SYNC_OFFSET;
+	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
+}
+
+static int
+mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, int disk)
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
+	if (quiesce)
+		pReq->Action = MPI_RAID_ACTION_QUIESCE_PHYS_IO;
+	else
+		pReq->Action = MPI_RAID_ACTION_ENABLE_PHYS_IO;
+	pReq->Reserved1 = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_RAID_ACTION;
+	pReq->VolumeID = disk;
+	pReq->VolumeBus = 0;
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
+	return 0;
+}
+
+static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
+			     struct scsi_device *sdev)
+{
+	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
+
+	/* no DV on RAID devices */
+	if (sdev->channel == 0 &&
+	    (hd->ioc->raid_data.isRaid & (1 << sdev->id)))
+		return;
+
+	/* If this is a piece of a RAID, then quiesce first */
+	if (sdev->channel == 1 &&
+	    mptscsih_quiesce_raid(hd, 1, vtarget->target_id) < 0) {
+		starget_printk(KERN_ERR, scsi_target(sdev),
+			       "Integrated RAID quiesce failed\n");
+		return;
+	}
+
+	spi_dv_device(sdev);
+
+	if (sdev->channel == 1 &&
+	    mptscsih_quiesce_raid(hd, 0, vtarget->target_id) < 0)
+		starget_printk(KERN_ERR, scsi_target(sdev),
+			       "Integrated RAID resume failed\n");
+
+	mptspi_read_parameters(sdev->sdev_target);
+	spi_display_xfer_agreement(sdev->sdev_target);
+	mptspi_read_parameters(sdev->sdev_target);
+}
+
+static int mptspi_slave_alloc(struct scsi_device *sdev)
+{
+	int ret;
+	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	/* gcc doesn't see that all uses of this variable occur within
+	 * the if() statements, so stop it from whining */
+	int physdisknum = 0;
+
+	if (sdev->channel == 1) {
+		physdisknum = mptscsih_raid_id_to_num(hd, sdev->id);
+
+		if (physdisknum < 0)
+			return physdisknum;
+	}
+
+	ret = mptscsih_slave_alloc(sdev);
+
+	if (ret)
+		return ret;
+
+	if (sdev->channel == 1) {
+		VirtDevice *vdev = sdev->hostdata;
+		sdev->no_uld_attach = 1;
+		vdev->vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
+		/* The real channel for this device is zero */
+		vdev->bus_id = 0;
+		/* The actual physdisknum (for RAID passthrough) */
+		vdev->target_id = physdisknum;
+	}
+
+	return 0;
+}
+
+static int mptspi_slave_configure(struct scsi_device *sdev)
+{
+	int ret = mptscsih_slave_configure(sdev);
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+
+	if (ret)
+		return ret;
+
+	if ((sdev->channel == 1 ||
+	     !(hd->ioc->raid_data.isRaid & (1 << sdev->id))) &&
+	    !spi_initial_dv(sdev->sdev_target))
+		mptspi_dv_device(hd, sdev);
+
+	return 0;
+}
+
+static void mptspi_slave_destroy(struct scsi_device *sdev)
+{
+	struct scsi_target *starget = scsi_target(sdev);
+	VirtTarget *vtarget = starget->hostdata;
+	VirtDevice *vdevice = sdev->hostdata;
+
+	/* Will this be the last lun on a non-raid device? */
+	if (vtarget->num_luns == 1 && vdevice->configured_lun) {
+		struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+
+		/* Async Narrow */
+		pg1.RequestedParameters = 0;
+		pg1.Reserved = 0;
+		pg1.Configuration = 0;
+
+		mptspi_write_spi_device_pg1(starget, &pg1);
+	}
+
+	mptscsih_slave_destroy(sdev);
+}
+
 static struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
@@ -109,11 +396,11 @@ static struct scsi_host_template mptspi_
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptscsih_qcmd,
-	.target_alloc			= mptscsih_target_alloc,
-	.slave_alloc			= mptscsih_slave_alloc,
-	.slave_configure		= mptscsih_slave_configure,
+	.target_alloc			= mptspi_target_alloc,
+	.slave_alloc			= mptspi_slave_alloc,
+	.slave_configure		= mptspi_slave_configure,
 	.target_destroy			= mptscsih_target_destroy,
-	.slave_destroy			= mptscsih_slave_destroy,
+	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
@@ -128,6 +415,360 @@ static struct scsi_host_template mptspi_
 	.use_clustering			= ENABLE_CLUSTERING,
 };
 
+static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
+			       struct _CONFIG_PAGE_SCSI_DEVICE_1 *pass_pg1)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_ADAPTER *ioc = hd->ioc;
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 *pg1;
+	dma_addr_t pg1_dma;
+	int size;
+	struct _x_config_parms cfg;
+	struct _CONFIG_PAGE_HEADER hdr;
+	int err = -EBUSY;
+
+	/* don't allow updating nego parameters on RAID devices */
+	if (starget->channel == 0 &&
+	    (hd->ioc->raid_data.isRaid & (1 << starget->id)))
+		return -1;
+
+	size = ioc->spi_data.sdp1length * 4;
+
+	pg1 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg1_dma, GFP_KERNEL);
+	if (pg1 == NULL) {
+		starget_printk(KERN_ERR, starget, "dma_alloc_coherent for parameters failed\n");
+		return -EINVAL;
+	}
+
+	memset(&hdr, 0, sizeof(hdr));
+
+	hdr.PageVersion = ioc->spi_data.sdp1version;
+	hdr.PageLength = ioc->spi_data.sdp1length;
+	hdr.PageNumber = 1;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_SCSI_DEVICE;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = pg1_dma;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	cfg.dir = 1;
+	cfg.pageAddr = starget->id;
+
+	memcpy(pg1, pass_pg1, size);
+
+	pg1->Header.PageVersion = hdr.PageVersion;
+	pg1->Header.PageLength = hdr.PageLength;
+	pg1->Header.PageNumber = hdr.PageNumber;
+	pg1->Header.PageType = hdr.PageType;
+
+	if (mpt_config(ioc, &cfg)) {
+		starget_printk(KERN_ERR, starget, "mpt_config failed\n");
+		goto out_free;
+	}
+	err = 0;
+
+ out_free:
+	dma_free_coherent(&ioc->pcidev->dev, size, pg1, pg1_dma);
+	return err;
+}
+
+static void mptspi_write_offset(struct scsi_target *starget, int offset)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (offset < 0)
+		offset = 0;
+
+	if (offset > 255)
+		offset = 255;
+
+	if (spi_offset(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	spi_offset(starget) = offset;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+static void mptspi_write_period(struct scsi_target *starget, int period)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (period < 8)
+		period = 8;
+
+	if (period > 255)
+		period = 255;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (period == 8) {
+		spi_iu(starget) = 1;
+		spi_dt(starget) = 1;
+	} else if (period == 9) {
+		spi_dt(starget) = 1;
+	}
+
+	spi_period(starget) = period;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+static void mptspi_write_dt(struct scsi_target *starget, int dt)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (!dt && spi_period(starget) < 10)
+		spi_period(starget) = 10;
+
+	spi_dt(starget) = dt;
+
+	nego = mptspi_getRP(starget);
+
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+static void mptspi_write_iu(struct scsi_target *starget, int iu)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (spi_period(starget) == -1)
+		mptspi_read_parameters(starget);
+
+	if (!iu && spi_period(starget) < 9)
+		spi_period(starget) = 9;
+
+	spi_iu(starget) = iu;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+#define MPTSPI_SIMPLE_TRANSPORT_PARM(parm) 				\
+static void mptspi_write_##parm(struct scsi_target *starget, int parm)\
+{									\
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;				\
+	u32 nego;							\
+									\
+	spi_##parm(starget) = parm;					\
+									\
+	nego = mptspi_getRP(starget);					\
+									\
+	pg1.RequestedParameters = cpu_to_le32(nego);			\
+	pg1.Reserved = 0;						\
+	pg1.Configuration = 0;						\
+									\
+	mptspi_write_spi_device_pg1(starget, &pg1);				\
+}
+
+MPTSPI_SIMPLE_TRANSPORT_PARM(rd_strm)
+MPTSPI_SIMPLE_TRANSPORT_PARM(wr_flow)
+MPTSPI_SIMPLE_TRANSPORT_PARM(rti)
+MPTSPI_SIMPLE_TRANSPORT_PARM(hold_mcs)
+MPTSPI_SIMPLE_TRANSPORT_PARM(pcomp_en)
+
+static void mptspi_write_qas(struct scsi_target *starget, int qas)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	VirtTarget *vtarget = starget->hostdata;
+	u32 nego;
+
+	if ((vtarget->negoFlags & MPT_TARGET_NO_NEGO_QAS) ||
+	    hd->ioc->spi_data.noQas)
+		spi_qas(starget) = 0;
+	else
+		spi_qas(starget) = qas;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+static void mptspi_write_width(struct scsi_target *starget, int width)
+{
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
+
+	if (!width) {
+		spi_dt(starget) = 0;
+		if (spi_period(starget) < 10)
+			spi_period(starget) = 10;
+	}
+
+	spi_width(starget) = width;
+
+	nego = mptspi_getRP(starget);
+
+	pg1.RequestedParameters = cpu_to_le32(nego);
+	pg1.Reserved = 0;
+	pg1.Configuration = 0;
+
+	mptspi_write_spi_device_pg1(starget, &pg1);
+}
+
+struct work_queue_wrapper {
+	struct work_struct	work;
+	struct _MPT_SCSI_HOST	*hd;
+	int			disk;
+};
+
+static void mpt_work_wrapper(void *data)
+{
+	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
+	struct _MPT_SCSI_HOST *hd = wqw->hd;
+	struct Scsi_Host *shost = hd->ioc->sh;
+	struct scsi_device *sdev;
+	int disk = wqw->disk;
+	struct _CONFIG_PAGE_IOC_3 *pg3;
+
+	kfree(wqw);
+
+	mpt_findImVolumes(hd->ioc);
+	pg3 = hd->ioc->raid_data.pIocPg3;
+	if (!pg3)
+		return;
+
+	shost_for_each_device(sdev,shost) {
+		struct scsi_target *starget = scsi_target(sdev);
+		VirtTarget *vtarget = starget->hostdata;
+
+		/* only want to search RAID components */
+		if (sdev->channel != 1)
+			continue;
+
+		/* The target_id is the raid PhysDiskNum, even if
+		 * starget->id is the actual target address */
+		if(vtarget->target_id != disk)
+			continue;
+
+		starget_printk(KERN_INFO, vtarget->starget,
+			       "Integrated RAID requests DV of new device\n");
+		mptspi_dv_device(hd, sdev);
+	}
+	shost_printk(KERN_INFO, shost,
+		     "Integrated RAID detects new device %d\n", disk);
+	scsi_scan_target(&hd->ioc->sh->shost_gendev, 1, disk, 0, 1);
+}
+
+
+static void mpt_dv_raid(struct _MPT_SCSI_HOST *hd, int disk)
+{
+	struct work_queue_wrapper *wqw = kmalloc(sizeof(*wqw), GFP_ATOMIC);
+
+	if (!wqw) {
+		shost_printk(KERN_ERR, hd->ioc->sh,
+			     "Failed to act on RAID event for physical disk %d\n",
+			   disk);
+		return;
+	}
+	INIT_WORK(&wqw->work, mpt_work_wrapper, wqw);
+	wqw->hd = hd;
+	wqw->disk = disk;
+
+	schedule_work(&wqw->work);
+}
+
+static int
+mptspi_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
+{
+	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+
+	if (hd && event ==  MPI_EVENT_INTEGRATED_RAID) {
+		int reason
+			= (le32_to_cpu(pEvReply->Data[0]) & 0x00FF0000) >> 16;
+
+		if (reason == MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {
+			int disk = (le32_to_cpu(pEvReply->Data[0]) & 0xFF000000) >> 24;
+			mpt_dv_raid(hd, disk);
+		}
+	}
+	return mptscsih_event_process(ioc, pEvReply);
+}
+
+static int
+mptspi_deny_binding(struct scsi_target *starget)
+{
+	struct _MPT_SCSI_HOST *hd =
+		(struct _MPT_SCSI_HOST *)dev_to_shost(starget->dev.parent)->hostdata;
+	return ((hd->ioc->raid_data.isRaid & (1 << starget->id)) &&
+		starget->channel == 0) ? 1 : 0;
+}
+
+static struct spi_function_template mptspi_transport_functions = {
+	.get_offset	= mptspi_read_parameters,
+	.set_offset	= mptspi_write_offset,
+	.show_offset	= 1,
+	.get_period	= mptspi_read_parameters,
+	.set_period	= mptspi_write_period,
+	.show_period	= 1,
+	.get_width	= mptspi_read_parameters,
+	.set_width	= mptspi_write_width,
+	.show_width	= 1,
+	.get_iu		= mptspi_read_parameters,
+	.set_iu		= mptspi_write_iu,
+	.show_iu	= 1,
+	.get_dt		= mptspi_read_parameters,
+	.set_dt		= mptspi_write_dt,
+	.show_dt	= 1,
+	.get_qas	= mptspi_read_parameters,
+	.set_qas	= mptspi_write_qas,
+	.show_qas	= 1,
+	.get_wr_flow	= mptspi_read_parameters,
+	.set_wr_flow	= mptspi_write_wr_flow,
+	.show_wr_flow	= 1,
+	.get_rd_strm	= mptspi_read_parameters,
+	.set_rd_strm	= mptspi_write_rd_strm,
+	.show_rd_strm	= 1,
+	.get_rti	= mptspi_read_parameters,
+	.set_rti	= mptspi_write_rti,
+	.show_rti	= 1,
+	.get_pcomp_en	= mptspi_read_parameters,
+	.set_pcomp_en	= mptspi_write_pcomp_en,
+	.show_pcomp_en	= 1,
+	.get_hold_mcs	= mptspi_read_parameters,
+	.set_hold_mcs	= mptspi_write_hold_mcs,
+	.show_hold_mcs	= 1,
+	.deny_binding	= mptspi_deny_binding,
+};
 
 /****************************************************************************
  * Supported hardware
@@ -242,7 +883,14 @@ mptspi_probe(struct pci_dev *pdev, const
 	sh->max_id = MPT_MAX_SCSI_DEVICES;
 
 	sh->max_lun = MPT_LAST_LUN + 1;
-	sh->max_channel = 0;
+	/*
+	 * If RAID Firmware Detected, setup virtual channel
+	 */
+	if ((ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
+	    > MPI_FW_HEADER_PID_PROD_TARGET_SCSI)
+		sh->max_channel = 1;
+	else
+		sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
 	/* Required entry.
@@ -301,7 +949,8 @@ mptspi_probe(struct pci_dev *pdev, const
 	 * indicates a device exists.
 	 * max_id = 1 + maximum id (hosts.h)
 	 */
-	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
+	hd->Targets = kcalloc(sh->max_id * (sh->max_channel + 1),
+			      sizeof(void *), GFP_ATOMIC);
 	if (!hd->Targets) {
 		error = -ENOMEM;
 		goto out_mptspi_probe;
@@ -334,49 +983,23 @@ mptspi_probe(struct pci_dev *pdev, const
 	ioc->spi_data.Saf_Te = mpt_saf_te;
 	hd->mpt_pq_filter = mpt_pq_filter;
 
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-	if (ioc->spi_data.maxBusWidth > mpt_width)
-		ioc->spi_data.maxBusWidth = mpt_width;
-	if (ioc->spi_data.minSyncFactor < mpt_factor)
-		ioc->spi_data.minSyncFactor = mpt_factor;
-	if (ioc->spi_data.minSyncFactor == MPT_ASYNC) {
-		ioc->spi_data.maxSyncOffset = 0;
-	}
-	ioc->spi_data.mpt_dv = mpt_dv;
-	hd->negoNvram = 0;
-
-	ddvprintk((MYIOC_s_INFO_FMT
-		"dv %x width %x factor %x saf_te %x mpt_pq_filter %x\n",
-		ioc->name,
-		mpt_dv,
-		mpt_width,
-		mpt_factor,
-		mpt_saf_te,
-		mpt_pq_filter));
-#else
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk((MYIOC_s_INFO_FMT
 		"saf_te %x mpt_pq_filter %x\n",
 		ioc->name,
 		mpt_saf_te,
 		mpt_pq_filter));
-#endif
-
-	ioc->spi_data.forceDv = 0;
 	ioc->spi_data.noQas = 0;
 
-	for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++)
-		ioc->spi_data.dvStatus[ii] =
-		  MPT_SCSICFG_NEGOTIATE;
-
-	for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++)
-		ioc->spi_data.dvStatus[ii] |=
-		  MPT_SCSICFG_DV_NOT_DONE;
-
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
 
+	/* Some versions of the firmware don't support page 0; without
+	 * that we can't get the parameters */
+	if (hd->ioc->spi_data.sdp0length != 0)
+		sh->transportt = mptspi_transport_template;
+
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
 		dprintk((KERN_ERR MYNAM
@@ -423,14 +1046,17 @@ static struct pci_driver mptspi_driver =
 static int __init
 mptspi_init(void)
 {
-
 	show_mptmod_ver(my_NAME, my_VERSION);
 
+	mptspi_transport_template = spi_attach_transport(&mptspi_transport_functions);
+	if (!mptspi_transport_template)
+		return -ENODEV;
+
 	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
 	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
 	mptspiInternalCtx = mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
 
-	if (mpt_event_register(mptspiDoneCtx, mptscsih_event_process) == 0) {
+	if (mpt_event_register(mptspiDoneCtx, mptspi_event_process) == 0) {
 		devtprintk((KERN_INFO MYNAM
 		  ": Registered for IOC event notifications\n"));
 	}
@@ -465,6 +1091,7 @@ mptspi_exit(void)
 	mpt_deregister(mptspiInternalCtx);
 	mpt_deregister(mptspiTaskCtx);
 	mpt_deregister(mptspiDoneCtx);
+	spi_release_transport(mptspi_transport_template);
 }
 
 module_init(mptspi_init);



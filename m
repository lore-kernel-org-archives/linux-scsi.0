From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/9] - fusion - Greater than 255 target and lun support
Date: Mon, 29 Jan 2007 09:42:20 -0700
Message-ID: <20070129164220.GA1880@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60441 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXA2Qlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:41:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Add support for greater than 255 target and luns.
Kill the hd->Target[] field, and change all references
of bus_id/target_id, to channel/id.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/Makefile	2007-01-28 12:57:28.000000000 -0700
@@ -8,6 +8,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_INIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_EXIT
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
+#EXTRA_CFLAGS += -DMPT_DEBUG_TM
 
 #
 # driver/module specifics...
@@ -22,7 +23,6 @@
 #  For mptscsih:
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_DV
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_NEGO
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_TM
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_REPLY
 #
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2007-01-28 12:57:28.000000000 -0700
@@ -82,6 +82,10 @@ static int mpt_msi_enable;
 module_param(mpt_msi_enable, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
 
+static int mpt_channel_mapping;
+module_param(mpt_channel_mapping, int, 0);
+MODULE_PARM_DESC(mpt_channel_mapping, " Mapping id's to channels (default=0)");
+
 #ifdef MFCNT
 static int mfcounter = 0;
 #define PRINT_MF_COUNT 20000
@@ -2505,6 +2509,7 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 	int			 ii;
 	int			 req_sz;
 	int			 reply_sz;
+	int			 max_id;
 
 	/* IOC *must* NOT be in RESET state! */
 	if (ioc->last_state == MPI_IOC_STATE_RESET) {
@@ -2552,6 +2557,21 @@ GetPortFacts(MPT_ADAPTER *ioc, int portn
 	pfacts->MaxPersistentIDs = le16_to_cpu(pfacts->MaxPersistentIDs);
 	pfacts->MaxLanBuckets = le16_to_cpu(pfacts->MaxLanBuckets);
 
+	max_id = (ioc->bus_type == SAS) ? pfacts->PortSCSIID :
+	    pfacts->MaxDevices;
+	ioc->devices_per_bus = (max_id > 255) ? 256 : max_id;
+	ioc->number_of_buses = (ioc->devices_per_bus < 256) ? 1 : max_id/256;
+
+	/*
+	 * Place all the devices on channels
+	 *
+	 * (for debuging)
+	 */
+	if (mpt_channel_mapping) {
+		ioc->devices_per_bus = 1;
+		ioc->number_of_buses = (max_id > 255) ? 255 : max_id;
+	}
+
 	return 0;
 }
 
@@ -2592,13 +2612,8 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	ddlprintk((MYIOC_s_INFO_FMT "upload_fw %d facts.Flags=%x\n",
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));
 
-	if(ioc->bus_type == SAS)
-		ioc_init.MaxDevices = ioc->facts.MaxDevices;
-	else if(ioc->bus_type == FC)
-		ioc_init.MaxDevices = MPT_MAX_FC_DEVICES;
-	else
-		ioc_init.MaxDevices = MPT_MAX_SCSI_DEVICES;
-	ioc_init.MaxBuses = MPT_MAX_BUS;
+	ioc_init.MaxDevices = (U8)ioc->devices_per_bus;
+	ioc_init.MaxBuses = (U8)ioc->number_of_buses;
 	dinitprintk((MYIOC_s_INFO_FMT "facts.MsgVersion=%x\n",
 		   ioc->name, ioc->facts.MsgVersion));
 	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05) {
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:28.000000000 -0700
@@ -334,8 +334,8 @@ typedef struct _VirtTarget {
 	struct scsi_target	*starget;
 	u8			 tflags;
 	u8			 ioc_id;
-	u8			 target_id;
-	u8			 bus_id;
+	u8			 id;
+	u8			 channel;
 	u8			 minSyncFactor;	/* 0xFF is async */
 	u8			 maxOffset;	/* 0 if async */
 	u8			 maxWidth;	/* 0 if narrow, 1 if wide */
@@ -344,13 +344,12 @@ typedef struct _VirtTarget {
 	u8			 type;		/* byte 0 of Inquiry data */
 	u8			 deleted;	/* target in process of being removed */
 	u32			 num_luns;
-	u32			 luns[8];		/* Max LUNs is 256 */
 } VirtTarget;
 
 typedef struct _VirtDevice {
 	VirtTarget		*vtarget;
 	u8			 configured_lun;
-	u32			 lun;
+	int			 lun;
 } VirtDevice;
 
 /*
@@ -412,7 +411,7 @@ typedef struct _MPT_IOCTL {
 	u8			 rsvd;
 	u8			 status;	/* current command status */
 	u8			 reset;		/* 1 if bus reset allowed */
-	u8			 target;	/* target for reset */
+	u8			 id;		/* target for reset */
 	struct mutex		 ioctl_mutex;
 } MPT_IOCTL;
 
@@ -528,6 +527,8 @@ typedef struct _MPT_ADAPTER
 	u32			 mem_phys;	/* == f4020000 (mmap) */
 	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */
 	int			 mem_size;	/* mmap memory size */
+	int			 number_of_buses;
+	int			 devices_per_bus;
 	int			 alloc_total;
 	u32			 last_state;
 	int			 active;
@@ -957,7 +958,6 @@ typedef struct _MPT_SCSI_HOST {
 	int			  port;
 	u32			  pad0;
 	struct scsi_cmnd	**ScsiLookup;
-	VirtTarget		**Targets;
 	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */
 	struct timer_list	  timer;
 		/* Pool of memory for holding SCpnts before doing
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2007-01-28 12:57:28.000000000 -0700
@@ -361,7 +361,7 @@ static int mptctl_bus_reset(MPT_IOCTL *i
 			ioctl->ioc->name, mf));
 
 	pScsiTm = (SCSITaskMgmt_t *) mf;
-	pScsiTm->TargetID = ioctl->target;
+	pScsiTm->TargetID = ioctl->id;
 	pScsiTm->Bus = hd->port;	/* 0 */
 	pScsiTm->ChainOffset = 0;
 	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
@@ -1159,15 +1159,12 @@ mptctl_getiocinfo (unsigned long arg, un
 	struct mpt_ioctl_iocinfo *karg;
 	MPT_ADAPTER		*ioc;
 	struct pci_dev		*pdev;
-	struct Scsi_Host	*sh;
-	MPT_SCSI_HOST		*hd;
 	int			iocnum;
-	int			numDevices = 0;
-	unsigned int		max_id;
-	int			ii;
 	unsigned int		port;
 	int			cim_rev;
 	u8			revision;
+	struct scsi_device 	*sdev;
+	VirtDevice		*vdev;
 
 	dctlprintk((": mptctl_getiocinfo called.\n"));
 	/* Add of PCI INFO results in unaligned access for
@@ -1257,23 +1254,16 @@ mptctl_getiocinfo (unsigned long arg, un
 
 	/* Get number of devices
          */
-	if ((sh = ioc->sh) != NULL) {
-		 /* sh->max_id = maximum target ID + 1
-		 */
-		max_id = sh->max_id - 1;
-		hd = (MPT_SCSI_HOST *) sh->hostdata;
-
-		/* Check all of the target structures and
-		 * keep a counter.
-		 */
-		if (hd && hd->Targets) {
-			for (ii = 0; ii <= max_id; ii++) {
-				if (hd->Targets[ii])
-					numDevices++;
-			}
+	karg->numDevices = 0;
+	if (ioc->sh) {
+		shost_for_each_device(sdev, ioc->sh) {
+			vdev = sdev->hostdata;
+			if (vdev->vtarget->tflags &
+			    MPT_TARGET_FLAGS_RAID_COMPONENT)
+				continue;
+			karg->numDevices++;
 		}
 	}
-	karg->numDevices = numDevices;
 
 	/* Set the BIOS and FW Version
 	 */
@@ -1319,21 +1309,16 @@ mptctl_gettargetinfo (unsigned long arg)
 	struct mpt_ioctl_targetinfo __user *uarg = (void __user *) arg;
 	struct mpt_ioctl_targetinfo karg;
 	MPT_ADAPTER		*ioc;
-	struct Scsi_Host	*sh;
-	MPT_SCSI_HOST		*hd;
-	VirtTarget		*vdev;
+	VirtDevice		*vdev;
 	char			*pmem;
 	int			*pdata;
-	IOCPage2_t		*pIoc2;
-	IOCPage3_t		*pIoc3;
 	int			iocnum;
 	int			numDevices = 0;
-	unsigned int		max_id;
-	int			id, jj, indexed_lun, lun_index;
-	u32			lun;
+	int			lun;
 	int			maxWordsLeft;
 	int			numBytes;
-	u8			port, devType, bus_id;
+	u8			port;
+	struct scsi_device 	*sdev;
 
 	dctlprintk(("mptctl_gettargetinfo called.\n"));
 	if (copy_from_user(&karg, uarg, sizeof(struct mpt_ioctl_targetinfo))) {
@@ -1389,74 +1374,22 @@ mptctl_gettargetinfo (unsigned long arg)
 
 	/* Get number of devices
          */
-	if ((sh = ioc->sh) != NULL) {
-
-		max_id = sh->max_id - 1;
-		hd = (MPT_SCSI_HOST *) sh->hostdata;
-
-		/* Check all of the target structures.
-		 * Save the Id and increment the counter,
-		 * if ptr non-null.
-		 * sh->max_id = maximum target ID + 1
-		 */
-		if (hd && hd->Targets) {
-			mpt_findImVolumes(ioc);
-			pIoc2 = ioc->raid_data.pIocPg2;
-			for ( id = 0; id <= max_id; ) {
-				if ( pIoc2 && pIoc2->NumActiveVolumes ) {
-					if ( id == pIoc2->RaidVolume[0].VolumeID ) {
-						if (maxWordsLeft <= 0) {
-							printk(KERN_ERR "mptctl_gettargetinfo - "
-			"buffer is full but volume is available on ioc %d\n, numDevices=%d", iocnum, numDevices);
-							goto data_space_full;
-						}
-						if ( ( pIoc2->RaidVolume[0].Flags & MPI_IOCPAGE2_FLAG_VOLUME_INACTIVE ) == 0 )
-                        				devType = 0x80;
-                    				else
-                        				devType = 0xC0;
-						bus_id = pIoc2->RaidVolume[0].VolumeBus;
-	            				numDevices++;
-                    				*pdata = ( (devType << 24) | (bus_id << 8) | id );
-						dctlprintk((KERN_ERR "mptctl_gettargetinfo - "
-		"volume ioc=%d target=%x numDevices=%d pdata=%p\n", iocnum, *pdata, numDevices, pdata));
-                    				pdata++;
-						--maxWordsLeft;
-						goto next_id;
-					} else {
-						pIoc3 = ioc->raid_data.pIocPg3;
-            					for ( jj = 0; jj < pIoc3->NumPhysDisks; jj++ ) {
-                    					if ( pIoc3->PhysDisk[jj].PhysDiskID == id )
-								goto next_id;
-						}
-					}
-				}
-				if ( (vdev = hd->Targets[id]) ) {
-					for (jj = 0; jj <= MPT_LAST_LUN; jj++) {
-						lun_index = (jj >> 5);
-						indexed_lun = (jj % 32);
-						lun = (1 << indexed_lun);
-						if (vdev->luns[lun_index] & lun) {
-							if (maxWordsLeft <= 0) {
-								printk(KERN_ERR "mptctl_gettargetinfo - "
-			"buffer is full but more targets are available on ioc %d numDevices=%d\n", iocnum, numDevices);
-								goto data_space_full;
-							}
-							bus_id = vdev->bus_id;
-							numDevices++;
-                            				*pdata = ( (jj << 16) | (bus_id << 8) | id );
-							dctlprintk((KERN_ERR "mptctl_gettargetinfo - "
-		"target ioc=%d target=%x numDevices=%d pdata=%p\n", iocnum, *pdata, numDevices, pdata));
-							pdata++;
-							--maxWordsLeft;
-						}
-					}
-				}
-next_id:
-				id++;
-			}
+	if (ioc->sh){
+		shost_for_each_device(sdev, ioc->sh) {
+			if (!maxWordsLeft)
+				continue;
+			vdev = sdev->hostdata;
+			if (vdev->vtarget->tflags &
+			    MPT_TARGET_FLAGS_RAID_COMPONENT)
+				continue;
+			lun = (vdev->vtarget->raidVolume) ? 0x80 : vdev->lun;
+			*pdata = (((u8)lun << 16) + (vdev->vtarget->channel << 8) +
+			    (vdev->vtarget->id ));
+			pdata++;
+			numDevices++;
+			--maxWordsLeft;
 		}
 	}
-data_space_full:
 	karg.numDevices = numDevices;
 
 	/* Copy part of the data from kernel memory to user memory
@@ -1821,6 +1754,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	int		msgContext;
 	u16		req_idx;
 	ulong 		timeout;
+	struct scsi_device *sdev;
 
 	dctlprintk(("mptctl_do_mpt_command called.\n"));
 	bufIn.kptr = bufOut.kptr = NULL;
@@ -1902,14 +1836,13 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	case MPI_FUNCTION_SCSI_IO_REQUEST:
 		if (ioc->sh) {
 			SCSIIORequest_t *pScsiReq = (SCSIIORequest_t *) mf;
-			VirtTarget	*pTarget = NULL;
-			MPT_SCSI_HOST	*hd = NULL;
 			int qtag = MPI_SCSIIO_CONTROL_UNTAGGED;
 			int scsidir = 0;
-			int target = (int) pScsiReq->TargetID;
 			int dataSize;
+			u32 id;
 
-			if ((target < 0) || (target >= ioc->sh->max_id)) {
+			id = (ioc->devices_per_bus == 0) ? 256 : ioc->devices_per_bus;
+			if (pScsiReq->TargetID > id) {
 				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
 					"Target ID out of bounds. \n",
 					__FILE__, __LINE__);
@@ -1917,6 +1850,14 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				goto done_free_mem;
 			}
 
+			if (pScsiReq->Bus >= ioc->number_of_buses) {
+				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+					"Target Bus out of bounds. \n",
+					__FILE__, __LINE__);
+				rc = -ENODEV;
+				goto done_free_mem;
+			}
+
 			pScsiReq->MsgFlags &= ~MPI_SCSIIO_MSGFLGS_SENSE_WIDTH;
 			pScsiReq->MsgFlags |= mpt_msg_flags();
 
@@ -1936,14 +1877,16 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 				cpu_to_le32(ioc->sense_buf_low_dma
 				   + (req_idx * MPT_SENSE_BUFFER_ALLOC));
 
-			if ((hd = (MPT_SCSI_HOST *) ioc->sh->hostdata)) {
-				if (hd->Targets)
-					pTarget = hd->Targets[target];
+			shost_for_each_device(sdev, ioc->sh) {
+				struct scsi_target *starget = scsi_target(sdev);
+				VirtTarget *vtarget = starget->hostdata;
+
+				if ((pScsiReq->TargetID == vtarget->id) &&
+				    (pScsiReq->Bus == vtarget->channel) &&
+				    (vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
+					qtag = MPI_SCSIIO_CONTROL_SIMPLEQ;
 			}
 
-			if (pTarget &&(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
-				qtag = MPI_SCSIIO_CONTROL_SIMPLEQ;
-
 			/* Have the IOCTL driver set the direction based
 			 * on the dataOutSize (ordering issue with Sparc).
 			 */
@@ -1959,7 +1902,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
 			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->target = target;
+			ioc->ioctl->id = pScsiReq->TargetID;
 
 		} else {
 			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
@@ -2038,7 +1981,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 			pScsiReq->DataLength = cpu_to_le32(dataSize);
 
 			ioc->ioctl->reset = MPTCTL_RESET_OK;
-			ioc->ioctl->target = pScsiReq->TargetID;
+			ioc->ioctl->id = pScsiReq->TargetID;
 		} else {
 			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
 				"SCSI driver is not loaded. \n",
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptfc.c	2007-01-28 12:57:28.000000000 -0700
@@ -86,6 +86,12 @@ MODULE_PARM_DESC(mptfc_dev_loss_tmo, " I
 				     " return following a device loss event."
 				     "  Default=60.");
 
+/* scsi-mid layer global parmeter is max_report_luns, which is 511 */
+#define MPTFC_MAX_LUN (16895)
+static int max_lun = MPTFC_MAX_LUN;
+module_param(max_lun, int, 0);
+MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
+
 static int	mptfcDoneCtx = -1;
 static int	mptfcTaskCtx = -1;
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
@@ -292,10 +298,9 @@ mptfc_GetFcDevPage0(MPT_ADAPTER *ioc, in
 	U32			 port_id = 0xffffff;
 	int			 num_targ = 0;
 	int			 max_bus = ioc->facts.MaxBuses;
-	int			 max_targ = ioc->facts.MaxDevices;
+	int			 max_targ;
 
-	if (max_bus == 0 || max_targ == 0)
-		goto out;
+	max_targ = (ioc->facts.MaxDevices == 0) ? 256 : ioc->facts.MaxDevices;
 
 	data_sz = sizeof(FCDevicePage0_t) * max_bus * max_targ;
 	p_p0 = p0_array =  kzalloc(data_sz, GFP_KERNEL);
@@ -467,8 +472,8 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int
 			if (ri->starget) {
 				vtarget = ri->starget->hostdata;
 				if (vtarget) {
-					vtarget->target_id = pg0->CurrentTargetID;
-					vtarget->bus_id = pg0->CurrentBus;
+					vtarget->id = pg0->CurrentTargetID;
+					vtarget->channel = pg0->CurrentBus;
 				}
 			}
 			*((struct mptfc_rport_info **)rport->dd_data) = ri;
@@ -540,8 +545,8 @@ mptfc_target_alloc(struct scsi_target *s
 	if (rport) {
 		ri = *((struct mptfc_rport_info **)rport->dd_data);
 		if (ri) {	/* better be! */
-			vtarget->target_id = ri->pg0.CurrentTargetID;
-			vtarget->bus_id = ri->pg0.CurrentBus;
+			vtarget->id = ri->pg0.CurrentTargetID;
+			vtarget->channel = ri->pg0.CurrentBus;
 			ri->starget = starget;
 			rc = 0;
 		}
@@ -592,7 +597,6 @@ mptfc_slave_alloc(struct scsi_device *sd
 	if (vtarget->num_luns == 0) {
 		vtarget->ioc_id = hd->ioc->id;
 		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
-		hd->Targets[sdev->id] = vtarget;
 	}
 
 	vdev->vtarget = vtarget;
@@ -630,16 +634,17 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void
 	struct mptfc_rport_info	*ri;
 	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
 	int		err;
+	VirtDevice	*vdev = SCpnt->device->hostdata;
 
-	err = fc_remote_port_chkready(rport);
-	if (unlikely(err)) {
-		SCpnt->result = err;
+	if (!vdev || !vdev->vtarget) {
+		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
 	}
 
-	if (!SCpnt->device->hostdata) {	/* vdev */
-		SCpnt->result = DID_NO_CONNECT << 16;
+	err = fc_remote_port_chkready(rport);
+	if (unlikely(err)) {
+		SCpnt->result = err;
 		done(SCpnt);
 		return 0;
 	}
@@ -1143,7 +1148,7 @@ mptfc_probe(struct pci_dev *pdev, const 
 		printk(MYIOC_s_WARN_FMT
 			"Skipping ioc=%p because SCSI Initiator mode is NOT enabled!\n",
 			ioc->name, ioc);
-		return -ENODEV;
+		return 0;
 	}
 
 	sh = scsi_host_alloc(&mptfc_driver_template, sizeof(MPT_SCSI_HOST));
@@ -1173,10 +1178,9 @@ mptfc_probe(struct pci_dev *pdev, const 
 	/* set 16 byte cdb's */
 	sh->max_cmd_len = 16;
 
-	sh->max_id = MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;
+	sh->max_id = ioc->pfacts->MaxDevices;
+	sh->max_lun = max_lun;
 
-	sh->max_lun = MPT_LAST_LUN + 1;
-	sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
 	/* Required entry.
@@ -1230,19 +1234,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
-	/* Allocate memory for the device structures.
-	 * A non-Null pointer at an offset
-	 * indicates a device exists.
-	 * max_id = 1 + maximum id (hosts.h)
-	 */
-	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
-	if (!hd->Targets) {
-		error = -ENOMEM;
-		goto out_mptfc_probe;
-	}
-
-	dprintk((KERN_INFO "  vdev @ %p\n", hd->Targets));
-
 	/* Clear the TM flags
 	 */
 	hd->tmPending = 0;
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2007-01-28 12:57:28.000000000 -0700
@@ -83,6 +83,12 @@ MODULE_PARM_DESC(mpt_pt_clear,
 		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
 
+/* scsi-mid layer global parmeter is max_report_luns, which is 511 */
+#define MPTSAS_MAX_LUN (16895)
+static int max_lun = MPTSAS_MAX_LUN;
+module_param(max_lun, int, 0);
+MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
+
 static int	mptsasDoneCtx = -1;
 static int	mptsasTaskCtx = -1;
 static int	mptsasInternalCtx = -1; /* Used only for internal commands */
@@ -568,12 +574,12 @@ mptsas_target_reset(MPT_ADAPTER *ioc, Vi
 
 	if (mptscsih_TMHandler(hd,
 	     MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-	     vtarget->bus_id, vtarget->target_id, 0, 0, 5) < 0) {
+	     vtarget->channel, vtarget->id, 0, 0, 5) < 0) {
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
 		printk(MYIOC_s_WARN_FMT
 	       "Error processing TaskMgmt id=%d TARGET_RESET\n",
-			ioc->name, vtarget->target_id);
+			ioc->name, vtarget->id);
 	}
 }
 
@@ -661,8 +667,7 @@ mptsas_target_alloc(struct scsi_target *
 	struct Scsi_Host *host = dev_to_shost(&starget->dev);
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	VirtTarget		*vtarget;
-	u32			target_id;
-	u32			channel;
+	u8			id, channel;
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
 	int 			 i;
@@ -673,15 +678,19 @@ mptsas_target_alloc(struct scsi_target *
 
 	vtarget->starget = starget;
 	vtarget->ioc_id = hd->ioc->id;
-	vtarget->tflags = MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;
-
-	target_id = starget->id;
+	vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
+	id = starget->id;
 	channel = 0;
 
-	hd->Targets[target_id] = vtarget;
-
-	if (starget->channel == MPTSAS_RAID_CHANNEL)
+	/*
+	 * RAID volumes placed beyond the last expected port.
+	 */
+	if (starget->channel == MPTSAS_RAID_CHANNEL) {
+		for (i=0; i < hd->ioc->raid_data.pIocPg2->NumActiveVolumes; i++)
+			if (id == hd->ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID)
+				channel = hd->ioc->raid_data.pIocPg2->RaidVolume[i].VolumeBus;
 		goto out;
+	}
 
 	rphy = dev_to_rphy(starget->dev.parent);
 	mutex_lock(&hd->ioc->sas_topology_mutex);
@@ -690,16 +699,16 @@ mptsas_target_alloc(struct scsi_target *
 			if (p->phy_info[i].attached.sas_address !=
 					rphy->identify.sas_address)
 				continue;
-			target_id = p->phy_info[i].attached.id;
+			id = p->phy_info[i].attached.id;
 			channel = p->phy_info[i].attached.channel;
 			mptsas_set_starget(&p->phy_info[i], starget);
 
 			/*
 			 * Exposing hidden raid components
 			 */
-			if (mptscsih_is_phys_disk(hd->ioc, target_id)) {
-				target_id = mptscsih_raid_id_to_num(hd,
-						target_id);
+			if (mptscsih_is_phys_disk(hd->ioc, channel, id)) {
+				id = mptscsih_raid_id_to_num(hd->ioc,
+						channel, id);
 				vtarget->tflags |=
 				    MPT_TARGET_FLAGS_RAID_COMPONENT;
 			}
@@ -713,8 +722,8 @@ mptsas_target_alloc(struct scsi_target *
 	return -ENXIO;
 
  out:
-	vtarget->target_id = target_id;
-	vtarget->bus_id = channel;
+	vtarget->id = id;
+	vtarget->channel = channel;
 	starget->hostdata = vtarget;
 	return 0;
 }
@@ -786,7 +795,8 @@ mptsas_slave_alloc(struct scsi_device *s
 			 * Exposing hidden raid components
 			 */
 			if (mptscsih_is_phys_disk(hd->ioc,
-					p->phy_info[i].attached.id))
+			    p->phy_info[i].attached.channel,
+			    p->phy_info[i].attached.id))
 				sdev->no_uld_attach = 1;
 			mutex_unlock(&hd->ioc->sas_topology_mutex);
 			goto out;
@@ -808,13 +818,14 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, voi
 {
 	VirtDevice	*vdev = SCpnt->device->hostdata;
 
-//	scsi_print_command(SCpnt);
-	if (vdev->vtarget->deleted) {
+	if (!vdev || !vdev->vtarget || vdev->vtarget->deleted) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
 		return 0;
 	}
 
+//	scsi_print_command(SCpnt);
+
 	return mptscsih_qcmd(SCpnt,done);
 }
 
@@ -1976,7 +1987,7 @@ mptsas_scan_sas_topology(MPT_ADAPTER *io
 		goto out;
 	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
 		goto out;
-	for (i=0; i<ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+	for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
 		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
 		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
 	}
@@ -2160,7 +2171,7 @@ mptsas_hotplug_work(struct work_struct *
 			 * Handling  RAID components
 			 */
 			if (ev->phys_disk_num_valid) {
-				vtarget->target_id = ev->phys_disk_num;
+				vtarget->id = ev->phys_disk_num;
 				vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
 				mptsas_reprobe_target(starget, 1);
 				break;
@@ -2233,7 +2244,7 @@ mptsas_hotplug_work(struct work_struct *
 			 */
 			if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 				vtarget->tflags &= ~MPT_TARGET_FLAGS_RAID_COMPONENT;
-				vtarget->target_id = ev->id;
+				vtarget->id = ev->id;
 				mptsas_reprobe_target(starget, 0);
 			}
 			break;
@@ -2611,12 +2622,11 @@ mptsas_probe(struct pci_dev *pdev, const
 	/* set 16 byte cdb's */
 	sh->max_cmd_len = 16;
 
-	sh->max_id = ioc->pfacts->MaxDevices + 1;
+	sh->max_id = ioc->pfacts[0].PortSCSIID;
+	sh->max_lun = max_lun;
 
 	sh->transportt = mptsas_transport_template;
 
-	sh->max_lun = MPT_LAST_LUN + 1;
-	sh->max_channel = 0;
 	sh->this_id = ioc->pfacts[0].PortSCSIID;
 
 	/* Required entry.
@@ -2676,19 +2686,6 @@ mptsas_probe(struct pci_dev *pdev, const
 	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
-	/* Allocate memory for the device structures.
-	 * A non-Null pointer at an offset
-	 * indicates a device exists.
-	 * max_id = 1 + maximum id (hosts.h)
-	 */
-	hd->Targets = kcalloc(sh->max_id, sizeof(void *), GFP_ATOMIC);
-	if (!hd->Targets) {
-		error = -ENOMEM;
-		goto out_mptsas_probe;
-	}
-
-	dprintk((KERN_INFO "  vtarget @ %p\n", hd->Targets));
-
 	/* Clear the TM flags
 	 */
 	hd->tmPending = 0;
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:28.000000000 -0700
@@ -79,43 +79,6 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-
-typedef struct _BIG_SENSE_BUF {
-	u8		data[MPT_SENSE_BUFFER_ALLOC];
-} BIG_SENSE_BUF;
-
-#define MPT_SCANDV_GOOD			(0x00000000) /* must be 0 */
-#define MPT_SCANDV_DID_RESET		(0x00000001)
-#define MPT_SCANDV_SENSE		(0x00000002)
-#define MPT_SCANDV_SOME_ERROR		(0x00000004)
-#define MPT_SCANDV_SELECTION_TIMEOUT	(0x00000008)
-#define MPT_SCANDV_ISSUE_SENSE		(0x00000010)
-#define MPT_SCANDV_FALLBACK		(0x00000020)
-
-#define MPT_SCANDV_MAX_RETRIES		(10)
-
-#define MPT_ICFLAG_BUF_CAP	0x01	/* ReadBuffer Read Capacity format */
-#define MPT_ICFLAG_ECHO		0x02	/* ReadBuffer Echo buffer format */
-#define MPT_ICFLAG_EBOS		0x04	/* ReadBuffer Echo buffer has EBOS */
-#define MPT_ICFLAG_PHYS_DISK	0x08	/* Any SCSI IO but do Phys Disk Format */
-#define MPT_ICFLAG_TAGGED_CMD	0x10	/* Do tagged IO */
-#define MPT_ICFLAG_DID_RESET	0x20	/* Bus Reset occurred with this command */
-#define MPT_ICFLAG_RESERVED	0x40	/* Reserved has been issued */
-
-typedef struct _internal_cmd {
-	char		*data;		/* data pointer */
-	dma_addr_t	data_dma;	/* data dma address */
-	int		size;		/* transfer size */
-	u8		cmd;		/* SCSI Op Code */
-	u8		bus;		/* bus number */
-	u8		id;		/* SCSI ID (virtual) */
-	u8		lun;
-	u8		flags;		/* Bit Field - See above */
-	u8		physDiskNum;	/* Phys disk number, -1 else */
-	u8		rsvd2;
-	u8		rsvd;
-} INTERNAL_CMD;
-
 /*
  *  Other private/forward protos...
  */
@@ -131,14 +94,14 @@ static int	mptscsih_tm_pending_wait(MPT_
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 static int	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
+static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
-static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
+static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
@@ -517,13 +480,13 @@ mptscsih_issue_sep_command(MPT_ADAPTER *
 
 	SEPMsg = (SEPRequest_t *)mf;
 	SEPMsg->Function = MPI_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
-	SEPMsg->Bus = vtarget->bus_id;
-	SEPMsg->TargetID = vtarget->target_id;
+	SEPMsg->Bus = vtarget->channel;
+	SEPMsg->TargetID = vtarget->id;
 	SEPMsg->Action = MPI_SEP_REQ_ACTION_WRITE_STATUS;
 	SEPMsg->SlotStatus = SlotStatus;
 	devtverboseprintk((MYIOC_s_WARN_FMT
-	    "Sending SEP cmd=%x id=%d bus=%d\n",
-	    ioc->name, SlotStatus, SEPMsg->TargetID, SEPMsg->Bus));
+	    "Sending SEP cmd=%x channel=%d id=%d\n",
+	    ioc->name, SlotStatus, SEPMsg->Bus, SEPMsg->TargetID));
 	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
 }
 
@@ -955,9 +918,10 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 	int		 ii;
 	int		 max = hd->ioc->req_depth;
 	struct scsi_cmnd *sc;
+	int		 lun;
 
-	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max %d\n",
-			vdevice->vtarget->target_id, vdevice->lun, max));
+	dsprintk((KERN_INFO MYNAM ": search_running channel %d id %d lun %d max %d\n",
+	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
 
 	for (ii=0; ii < max; ii++) {
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
@@ -965,9 +929,12 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);
 			if (mf == NULL)
 				continue;
-			dsprintk(( "search_running: found (sc=%p, mf = %p) target %d, lun %d \n",
-					hd->ScsiLookup[ii], mf, mf->TargetID, mf->LUN[1]));
-			if ((mf->TargetID != ((u8)vdevice->vtarget->target_id)) || (mf->LUN[1] != ((u8) vdevice->lun)))
+			lun = scsilun_to_int((struct scsi_lun *)mf->LUN);
+			dsprintk(( "search_running: found (sc=%p, mf = %p) chanel %d id %d, lun %d \n",
+			    hd->ScsiLookup[ii], mf, mf->Bus, mf->TargetID, lun));
+			if ((mf->Bus != vdevice->vtarget->channel) ||
+			    (mf->TargetID != vdevice->vtarget->id) ||
+			    (lun != vdevice->lun))
 				continue;
 
 			/* Cleanup
@@ -1065,12 +1032,6 @@ mptscsih_remove(struct pci_dev *pdev)
 		hd->ScsiLookup = NULL;
 	}
 
-	/*
-	 * Free pointer array.
-	 */
-	kfree(hd->Targets);
-	hd->Targets = NULL;
-
 	dprintk((MYIOC_s_INFO_FMT
 	    "Free'd ScsiLookup (%d) memory\n",
 	    hd->ioc->name, sz1));
@@ -1317,14 +1278,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	if ((hd->ioc->bus_type == SPI) &&
-	    vdev->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT &&
-	    mptscsih_raid_id_to_num(hd, SCpnt->device->id) < 0) {
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done(SCpnt);
-		return 0;
-	}
-
 	/*
 	 *  Put together a MPT SCSI request...
 	 */
@@ -1368,8 +1321,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 
 	/* Use the above information to set up the message frame
 	 */
-	pScsiReq->TargetID = (u8) vdev->vtarget->target_id;
-	pScsiReq->Bus = vdev->vtarget->bus_id;
+	pScsiReq->TargetID = (u8) vdev->vtarget->id;
+	pScsiReq->Bus = vdev->vtarget->channel;
 	pScsiReq->ChainOffset = 0;
 	if (vdev->vtarget->tflags &  MPT_TARGET_FLAGS_RAID_COMPONENT)
 		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
@@ -1379,14 +1332,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
 	pScsiReq->Reserved = 0;
 	pScsiReq->MsgFlags = mpt_msg_flags();
-	pScsiReq->LUN[0] = 0;
-	pScsiReq->LUN[1] = lun;
-	pScsiReq->LUN[2] = 0;
-	pScsiReq->LUN[3] = 0;
-	pScsiReq->LUN[4] = 0;
-	pScsiReq->LUN[5] = 0;
-	pScsiReq->LUN[6] = 0;
-	pScsiReq->LUN[7] = 0;
+	int_to_scsilun(SCpnt->device->lun, (struct scsi_lun *)pScsiReq->LUN);
 	pScsiReq->Control = cpu_to_le32(scsictl);
 
 	/*
@@ -1498,7 +1444,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@type: Task Management type
- *	@target: Logical Target ID for reset (if appropriate)
+ *	@id: Logical Target ID for reset (if appropriate)
  *	@lun: Logical Unit for reset (if appropriate)
  *	@ctx2abort: Context for the task to be aborted (if appropriate)
  *
@@ -1510,7 +1456,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *	Returns 0 for SUCCESS or -1 if FAILED.
  */
 int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout)
+mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
 	MPT_ADAPTER	*ioc;
 	int		 rc = -1;
@@ -1590,7 +1536,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 		 */
 		if (hd->hard_resets < -1)
 			hd->hard_resets++;
-		rc = mptscsih_IssueTaskMgmt(hd, type, channel, target, lun, ctx2abort, timeout);
+		rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun, ctx2abort, timeout);
 		if (rc) {
 			printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n", hd->ioc->name);
 		} else {
@@ -1624,7 +1570,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
  *	@hd: Pointer to MPT_SCSI_HOST structure
  *	@type: Task Management type
- *	@target: Logical Target ID for reset (if appropriate)
+ *	@id: Logical Target ID for reset (if appropriate)
  *	@lun: Logical Unit for reset (if appropriate)
  *	@ctx2abort: Context for the task to be aborted (if appropriate)
  *
@@ -1637,7 +1583,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	else other non-zero value returned.
  */
 static int
-mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout)
+mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
@@ -1657,7 +1603,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 	/* Format the Request
 	 */
 	pScsiTm = (SCSITaskMgmt_t *) mf;
-	pScsiTm->TargetID = target;
+	pScsiTm->TargetID = id;
 	pScsiTm->Bus = channel;
 	pScsiTm->ChainOffset = 0;
 	pScsiTm->Function = MPI_FUNCTION_SCSI_TASK_MGMT;
@@ -1668,10 +1614,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 	pScsiTm->MsgFlags = (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS)
                     ? MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION : 0;
 
-	for (ii= 0; ii < 8; ii++) {
-		pScsiTm->LUN[ii] = 0;
-	}
-	pScsiTm->LUN[1] = lun;
+	int_to_scsilun(lun, (struct scsi_lun *)pScsiTm->LUN);
 
 	for (ii=0; ii < 7; ii++)
 		pScsiTm->Reserved2[ii] = 0;
@@ -1789,7 +1732,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-		vdev->vtarget->bus_id, vdev->vtarget->target_id, vdev->lun,
+		vdev->vtarget->channel, vdev->vtarget->id, vdev->lun,
 		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
 
 	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
@@ -1845,7 +1788,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		vdev->vtarget->bus_id, vdev->vtarget->target_id,
+		vdev->vtarget->channel, vdev->vtarget->id,
 		0, 0, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
@@ -1896,7 +1839,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		vdev->vtarget->bus_id, 0, 0, 0, mptscsih_get_tm_timeout(hd->ioc));
+		vdev->vtarget->channel, 0, 0, 0, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -2191,7 +2134,7 @@ mptscsih_bios_param(struct scsi_device *
 
 	dprintk((KERN_NOTICE
 		": bios_param: Id=%i Lun=%i Channel=%i CHS=%i/%i/%i\n",
-		sdev->id, sdev->lun,sdev->channel,(int)cylinders,heads,sectors));
+		sdev->id, sdev->lun, sdev->channel, (int)cylinders, heads, sectors));
 
 	return 0;
 }
@@ -2200,115 +2143,46 @@ mptscsih_bios_param(struct scsi_device *
  *
  */
 int
-mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
+mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
 	int i;
+	int rc = 0;
 
-	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)
-		return 0;
+	if (!ioc->raid_data.pIocPg3)
+		goto out;
 	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
-                if (id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
-                        return 1;
-        }
-        return 0;
-}
-EXPORT_SYMBOL(mptscsih_is_phys_disk);
-
-int
-mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid)
-{
-	int i;
-
-	if (!hd->ioc->raid_data.isRaid || !hd->ioc->raid_data.pIocPg3)
-		return -ENXIO;
-
-	for (i = 0; i < hd->ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
-		if (physdiskid ==
-		    hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
-			return hd->ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum;
+		if ((id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID) &&
+		    (channel == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskBus)) {
+			rc = 1;
+			goto out;
+		}
 	}
 
-	return -ENXIO;
-}
-EXPORT_SYMBOL(mptscsih_raid_id_to_num);
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	OS entry point to allow host driver to alloc memory
- *	for each scsi target. Called once per device the bus scan.
- *	Return non-zero if allocation fails.
- */
-int
-mptscsih_target_alloc(struct scsi_target *starget)
-{
-	VirtTarget		*vtarget;
-
-	vtarget = kzalloc(sizeof(VirtTarget), GFP_KERNEL);
-	if (!vtarget)
-		return -ENOMEM;
-	starget->hostdata = vtarget;
-	vtarget->starget = starget;
-	return 0;
+ out:
+	return rc;
 }
+EXPORT_SYMBOL(mptscsih_is_phys_disk);
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	OS entry point to allow host driver to alloc memory
- *	for each scsi device. Called once per device the bus scan.
- *	Return non-zero if allocation fails.
- */
-int
-mptscsih_slave_alloc(struct scsi_device *sdev)
+u8
+mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
-	struct Scsi_Host	*host = sdev->host;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
-	VirtTarget		*vtarget;
-	VirtDevice		*vdev;
-	struct scsi_target 	*starget;
-
-	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
-	if (!vdev) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
-				hd->ioc->name, sizeof(VirtDevice));
-		return -ENOMEM;
-	}
-
-	vdev->lun = sdev->lun;
-	sdev->hostdata = vdev;
-
-	starget = scsi_target(sdev);
-	vtarget = starget->hostdata;
-
-	vdev->vtarget = vtarget;
+	int i;
+	int rc = -ENXIO;
 
-	if (vtarget->num_luns == 0) {
-		hd->Targets[sdev->id] = vtarget;
-		vtarget->ioc_id = hd->ioc->id;
-		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
-		vtarget->target_id = sdev->id;
-		vtarget->bus_id = sdev->channel;
-		if (hd->ioc->bus_type == SPI && sdev->channel == 0 &&
-		    hd->ioc->raid_data.isRaid & (1 << sdev->id)) {
-			vtarget->raidVolume = 1;
-			ddvtprintk((KERN_INFO
-				    "RAID Volume @ id %d\n", sdev->id));
+	if (!ioc->raid_data.pIocPg3)
+		goto out;
+	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+		if ((id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID) &&
+		    (channel == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskBus)) {
+			rc = ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum;
+			goto out;
 		}
 	}
-	vtarget->num_luns++;
-	return 0;
-}
 
-/*
- *	OS entry point to allow for host driver to free allocated memory
- *	Called if no device present or device being unloaded
- */
-void
-mptscsih_target_destroy(struct scsi_target *starget)
-{
-	if (starget->hostdata)
-		kfree(starget->hostdata);
-	starget->hostdata = NULL;
+ out:
+	return rc;
 }
+EXPORT_SYMBOL(mptscsih_raid_id_to_num);
 
 /*
  *	OS entry point to allow for host driver to free allocated memory
@@ -2328,11 +2202,7 @@ mptscsih_slave_destroy(struct scsi_devic
 	vdevice = sdev->hostdata;
 
 	mptscsih_search_running_cmds(hd, vdevice);
-	vtarget->luns[0] &= ~(1 << vdevice->lun);
 	vtarget->num_luns--;
-	if (vtarget->num_luns == 0) {
-		hd->Targets[sdev->id] = NULL;
-	}
 	mptscsih_synchronize_cache(hd, vdevice);
 	kfree(vdevice);
 	sdev->hostdata = NULL;
@@ -2394,15 +2264,14 @@ mptscsih_slave_configure(struct scsi_dev
 	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sh->hostdata;
-	int			indexed_lun, lun_index;
 
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 	vdevice = sdev->hostdata;
 
 	dsprintk((MYIOC_s_INFO_FMT
-		"device @ %p, id=%d, LUN=%d, channel=%d\n",
-		hd->ioc->name, sdev, sdev->id, sdev->lun, sdev->channel));
+		"device @ %p, channel=%d, id=%d, lun=%d\n",
+		hd->ioc->name, sdev, sdev->channel, sdev->id, sdev->lun));
 	if (hd->ioc->bus_type == SPI)
 		dsprintk((MYIOC_s_INFO_FMT
 		    "sdtr %d wdtr %d ppr %d inq length=%d\n",
@@ -2415,10 +2284,7 @@ mptscsih_slave_configure(struct scsi_dev
 		goto slave_configure_exit;
 	}
 
-	vdevice->configured_lun=1;
-	lun_index = (vdevice->lun >> 5);  /* 32 luns per lun_index */
-	indexed_lun = (vdevice->lun % 32);
-	vtarget->luns[lun_index] |= (1 << indexed_lun);
+	vdevice->configured_lun = 1;
 	mptscsih_initTarget(hd, vtarget, sdev);
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2699,8 +2565,8 @@ static void
 mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
 		    struct scsi_device *sdev)
 {
-	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
-		hd->ioc->name, vtarget->bus_id, vtarget->target_id,
+	dinitprintk((MYIOC_s_INFO_FMT "initTarget channel=%d id=%d lun=%d hd=%p\n",
+		hd->ioc->name, vtarget->channel, vtarget->id,
 		sdev->lun, hd));
 
 	/* Is LUN supported? If so, upper 2 bits will be 0
@@ -2721,7 +2587,7 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, V
 		/* Treat all Processors as SAF-TE if
 		 * command line option is set */
 		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-		mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
+		mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
 	}else if ((sdev->type == TYPE_PROCESSOR) &&
 		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
 		if (sdev->inquiry_len > 49 ) {
@@ -2732,7 +2598,7 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, V
 			    sdev->inquiry[48] == 'T' &&
 			    sdev->inquiry[49] == 'E' ) {
 				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-				mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);
+				mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
 			}
 		}
 	}
@@ -2750,7 +2616,7 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
 			    struct scsi_device *sdev)
 {
 	SpiCfgData *pspi_data = &hd->ioc->spi_data;
-	int  id = (int) target->target_id;
+	int  id = (int) target->id;
 	int  nvram;
 	u8 width = MPT_NARROW;
 	u8 factor = MPT_ASYNC;
@@ -2887,7 +2753,8 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*	mptscsih_writeIOCPage4  - write IOC Page 4
  *	@hd: Pointer to a SCSI Host Structure
- *	@target_id: write IOC Page4 for this ID & Bus
+ *	@channel: write IOC Page4 for this Bus
+ *	@id: write IOC Page4 for this ID
  *
  *	Return: -EAGAIN if unable to obtain a Message Frame
  *		or 0 if success.
@@ -2895,7 +2762,7 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
  *	Remark: We do not wait for a return, write pages sequentially.
  */
 static int
-mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus)
+mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
 {
 	MPT_ADAPTER		*ioc = hd->ioc;
 	Config_t		*pReq;
@@ -2936,13 +2803,13 @@ mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd
 		pReq->Reserved2[ii] = 0;
 	}
 
-       	IOCPage4Ptr = ioc->spi_data.pIocPg4;
-       	dataDma = ioc->spi_data.IocPg4_dma;
-       	ii = IOCPage4Ptr->ActiveSEP++;
-       	IOCPage4Ptr->SEP[ii].SEPTargetID = target_id;
-       	IOCPage4Ptr->SEP[ii].SEPBus = bus;
-       	pReq->Header = IOCPage4Ptr->Header;
-	pReq->PageAddress = cpu_to_le32(target_id | (bus << 8 ));
+	IOCPage4Ptr = ioc->spi_data.pIocPg4;
+	dataDma = ioc->spi_data.IocPg4_dma;
+	ii = IOCPage4Ptr->ActiveSEP++;
+	IOCPage4Ptr->SEP[ii].SEPTargetID = id;
+	IOCPage4Ptr->SEP[ii].SEPBus = channel;
+	pReq->Header = IOCPage4Ptr->Header;
+	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));
 
 	/* Add a SGE to the config request.
 	 */
@@ -2952,8 +2819,8 @@ mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd
 	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
 
 	dinitprintk((MYIOC_s_INFO_FMT
-		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
-			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, target_id, bus));
+		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d channel=%d id=%d \n",
+			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, channel, id));
 
 	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
 
@@ -3343,7 +3210,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		pScsiReq->Function = MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
 	} else {
 		pScsiReq->TargetID = io->id;
-		pScsiReq->Bus = io->bus;
+		pScsiReq->Bus = io->channel;
 		pScsiReq->ChainOffset = 0;
 		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
 	}
@@ -3356,9 +3223,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 	pScsiReq->MsgFlags = mpt_msg_flags();
 	/* MsgContext set in mpt_get_msg_fram call  */
 
-	for (ii=0; ii < 8; ii++)
-		pScsiReq->LUN[ii] = 0;
-	pScsiReq->LUN[1] = io->lun;
+	int_to_scsilun(io->lun, (struct scsi_lun *)pScsiReq->LUN);
 
 	if (io->flags & MPT_ICFLAG_TAGGED_CMD)
 		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_SIMPLEQ);
@@ -3379,7 +3244,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 					   + (my_idx * MPT_SENSE_BUFFER_ALLOC));
 
 	ddvprintk((MYIOC_s_INFO_FMT "Sending Command 0x%x for (%d:%d:%d)\n",
-			hd->ioc->name, cmd, io->bus, io->id, io->lun));
+			hd->ioc->name, cmd, io->channel, io->id, io->lun));
 
 	if (dir == MPI_SCSIIO_CONTROL_READ) {
 		mpt_add_sge((char *) &pScsiReq->SGL,
@@ -3462,9 +3327,9 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	iocmd.data_dma = -1;
 	iocmd.size = 0;
 	iocmd.rsvd = iocmd.rsvd2 = 0;
-	iocmd.bus = vdevice->vtarget->bus_id;
-	iocmd.id = vdevice->vtarget->target_id;
-	iocmd.lun = (u8)vdevice->lun;
+	iocmd.channel = vdevice->vtarget->channel;
+	iocmd.id = vdevice->vtarget->id;
+	iocmd.lun = vdevice->lun;
 
 	if ((vdevice->vtarget->type == TYPE_DISK) &&
 	    (vdevice->configured_lun))
@@ -3480,9 +3345,6 @@ EXPORT_SYMBOL(mptscsih_resume);
 EXPORT_SYMBOL(mptscsih_proc_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
-EXPORT_SYMBOL(mptscsih_target_alloc);
-EXPORT_SYMBOL(mptscsih_slave_alloc);
-EXPORT_SYMBOL(mptscsih_target_destroy);
 EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.h	2007-01-28 12:57:28.000000000 -0700
@@ -53,6 +53,24 @@
  *	SCSI Public stuff...
  */
 
+#define MPT_SCANDV_GOOD			(0x00000000) /* must be 0 */
+#define MPT_SCANDV_DID_RESET		(0x00000001)
+#define MPT_SCANDV_SENSE		(0x00000002)
+#define MPT_SCANDV_SOME_ERROR		(0x00000004)
+#define MPT_SCANDV_SELECTION_TIMEOUT	(0x00000008)
+#define MPT_SCANDV_ISSUE_SENSE		(0x00000010)
+#define MPT_SCANDV_FALLBACK		(0x00000020)
+
+#define MPT_SCANDV_MAX_RETRIES		(10)
+
+#define MPT_ICFLAG_BUF_CAP	0x01	/* ReadBuffer Read Capacity format */
+#define MPT_ICFLAG_ECHO		0x02	/* ReadBuffer Echo buffer format */
+#define MPT_ICFLAG_EBOS		0x04	/* ReadBuffer Echo buffer has EBOS */
+#define MPT_ICFLAG_PHYS_DISK	0x08	/* Any SCSI IO but do Phys Disk Format */
+#define MPT_ICFLAG_TAGGED_CMD	0x10	/* Do tagged IO */
+#define MPT_ICFLAG_DID_RESET	0x20	/* Bus Reset occurred with this command */
+#define MPT_ICFLAG_RESERVED	0x40	/* Reserved has been issued */
+
 #define MPT_SCSI_CMD_PER_DEV_HIGH	64
 #define MPT_SCSI_CMD_PER_DEV_LOW	32
 
@@ -69,9 +87,22 @@
 #define MPTSCSIH_SAF_TE                 0
 #define MPTSCSIH_PT_CLEAR               0
 
-
 #endif
 
+typedef struct _internal_cmd {
+	char		*data;		/* data pointer */
+	dma_addr_t	data_dma;	/* data dma address */
+	int		size;		/* transfer size */
+	u8		cmd;		/* SCSI Op Code */
+	u8		channel;	/* bus number */
+	u8		id;		/* SCSI ID (virtual) */
+	int		lun;
+	u8		flags;		/* Bit Field - See above */
+	u8		physDiskNum;	/* Phys disk number, -1 else */
+	u8		rsvd2;
+	u8		rsvd;
+} INTERNAL_CMD;
+
 extern void mptscsih_remove(struct pci_dev *);
 extern void mptscsih_shutdown(struct pci_dev *);
 #ifdef CONFIG_PM
@@ -81,9 +112,6 @@ extern int mptscsih_resume(struct pci_de
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
-extern int mptscsih_target_alloc(struct scsi_target *starget);
-extern int mptscsih_slave_alloc(struct scsi_device *device);
-extern void mptscsih_target_destroy(struct scsi_target *starget);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
@@ -98,6 +126,6 @@ extern int mptscsih_event_process(MPT_AD
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
-extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
-extern int mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid);
-extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
+extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
+extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
+extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-01-28 12:57:28.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-01-28 12:57:28.000000000 -0700
@@ -95,25 +95,76 @@ static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
+
+/**
+ *	mptspi_is_raid - Determines whether target is belonging to volume
+ *	@hd: Pointer to a SCSI HOST structure
+ *	@id: target device id
+ *
+ *	Return:
+ *		non-zero = true
+ *		zero = false
+ *
+ */
+static int
+mptspi_is_raid(struct _MPT_SCSI_HOST *hd, u32 id)
+{
+	int i, rc = 0;
+
+	if (!hd->ioc->raid_data.pIocPg2)
+		goto out;
+
+	if (!hd->ioc->raid_data.pIocPg2->NumActiveVolumes)
+		goto out;
+	for (i=0; i < hd->ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+		if (hd->ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID == id) {
+			rc = 1;
+			goto out;
+		}
+	}
+
+ out:
+	return rc;
+}
+
 static int mptspi_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
-	int ret;
+	VirtTarget		*vtarget;
 
 	if (hd == NULL)
 		return -ENODEV;
 
-	ret = mptscsih_target_alloc(starget);
-	if (ret)
-		return ret;
+	vtarget = kzalloc(sizeof(VirtTarget), GFP_KERNEL);
+	if (!vtarget)
+		return -ENOMEM;
+
+	vtarget->ioc_id = hd->ioc->id;
+	vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
+	vtarget->id = (u8)starget->id;
+	vtarget->channel = (u8)starget->channel;
+	vtarget->starget = starget;
+	starget->hostdata = vtarget;
+
+	if (starget->channel == 1) {
+		if (mptscsih_is_phys_disk(hd->ioc, 0, starget->id) == 0)
+			return 0;
+		vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
+		/* The real channel for this device is zero */
+		vtarget->channel = 0;
+		/* The actual physdisknum (for RAID passthrough) */
+		vtarget->id = mptscsih_raid_id_to_num(hd->ioc, 0,
+		    starget->id);
+	}
 
-	/* if we're a device on virtual channel 1 and we're not part
-	 * of an array, just return here (otherwise the setup below
-	 * may actually affect a real physical device on channel 0 */
-	if (starget->channel == 1 &&
-	    mptscsih_raid_id_to_num(hd, starget->id) < 0)
-		return 0;
+	if (starget->channel == 0 &&
+	    mptspi_is_raid(hd, starget->id)) {
+		vtarget->raidVolume = 1;
+		ddvprintk((KERN_INFO
+		    "RAID Volume @ channel=%d id=%d\n", starget->channel,
+		    starget->id));
+	}
 
 	if (hd->ioc->spi_data.nvram &&
 	    hd->ioc->spi_data.nvram[starget->id] != MPT_HOST_NVRAM_INVALID) {
@@ -132,6 +183,14 @@ static int mptspi_target_alloc(struct sc
 	return 0;
 }
 
+void
+mptspi_target_destroy(struct scsi_target *starget)
+{
+	if (starget->hostdata)
+		kfree(starget->hostdata);
+	starget->hostdata = NULL;
+}
+
 static int mptspi_read_spi_device_pg0(struct scsi_target *starget,
 			     struct _CONFIG_PAGE_SCSI_DEVICE_0 *pass_pg0)
 {
@@ -147,7 +206,7 @@ static int mptspi_read_spi_device_pg0(st
 
 	/* No SPI parameters for RAID devices */
 	if (starget->channel == 0 &&
-	    (hd->ioc->raid_data.isRaid & (1 << starget->id)))
+	    mptspi_is_raid(hd, starget->id))
 		return -1;
 
 	size = ioc->spi_data.sdp0length * 4;
@@ -233,7 +292,7 @@ static void mptspi_read_parameters(struc
 }
 
 static int
-mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, int disk)
+mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 {
 	MpiRaidActionRequest_t	*pReq;
 	MPT_FRAME_HDR		*mf;
@@ -253,8 +312,8 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 	pReq->Reserved1 = 0;
 	pReq->ChainOffset = 0;
 	pReq->Function = MPI_FUNCTION_RAID_ACTION;
-	pReq->VolumeID = disk;
-	pReq->VolumeBus = 0;
+	pReq->VolumeID = id;
+	pReq->VolumeBus = channel;
 	pReq->PhysDiskNum = 0;
 	pReq->MsgFlags = 0;
 	pReq->Reserved2 = 0;
@@ -263,8 +322,8 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 	mpt_add_sge((char *)&pReq->ActionDataSGE,
 		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
-	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action %x id %d\n",
-			hd->ioc->name, action, io->id));
+	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action=%x channel=%d id=%d\n",
+			hd->ioc->name, pReq->Action, channel, id));
 
 	hd->pLocal = NULL;
 	hd->timer.expires = jiffies + HZ*10; /* 10 second timeout */
@@ -292,12 +351,12 @@ static void mptspi_dv_device(struct _MPT
 
 	/* no DV on RAID devices */
 	if (sdev->channel == 0 &&
-	    (hd->ioc->raid_data.isRaid & (1 << sdev->id)))
+	    mptspi_is_raid(hd, sdev->id))
 		return;
 
 	/* If this is a piece of a RAID, then quiesce first */
 	if (sdev->channel == 1 &&
-	    mptscsih_quiesce_raid(hd, 1, vtarget->target_id) < 0) {
+	    mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) < 0) {
 		starget_printk(KERN_ERR, scsi_target(sdev),
 			       "Integrated RAID quiesce failed\n");
 		return;
@@ -306,7 +365,7 @@ static void mptspi_dv_device(struct _MPT
 	spi_dv_device(sdev);
 
 	if (sdev->channel == 1 &&
-	    mptscsih_quiesce_raid(hd, 0, vtarget->target_id) < 0)
+	    mptscsih_quiesce_raid(hd, 0, vtarget->channel, vtarget->id) < 0)
 		starget_printk(KERN_ERR, scsi_target(sdev),
 			       "Integrated RAID resume failed\n");
 
@@ -317,33 +376,32 @@ static void mptspi_dv_device(struct _MPT
 
 static int mptspi_slave_alloc(struct scsi_device *sdev)
 {
-	int ret;
 	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
-	/* gcc doesn't see that all uses of this variable occur within
-	 * the if() statements, so stop it from whining */
-	int physdisknum = 0;
+	VirtTarget		*vtarget;
+	VirtDevice		*vdev;
+	struct scsi_target 	*starget;
 
-	if (sdev->channel == 1) {
-		physdisknum = mptscsih_raid_id_to_num(hd, sdev->id);
+	if (sdev->channel == 1 &&
+		mptscsih_is_phys_disk(hd->ioc, 0, sdev->id) == 0)
+			return -ENXIO;
 
-		if (physdisknum < 0)
-			return physdisknum;
+	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdev) {
+		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+				hd->ioc->name, sizeof(VirtDevice));
+		return -ENOMEM;
 	}
 
-	ret = mptscsih_slave_alloc(sdev);
+	vdev->lun = sdev->lun;
+	sdev->hostdata = vdev;
 
-	if (ret)
-		return ret;
+	starget = scsi_target(sdev);
+	vtarget = starget->hostdata;
+	vdev->vtarget = vtarget;
+	vtarget->num_luns++;
 
-	if (sdev->channel == 1) {
-		VirtDevice *vdev = sdev->hostdata;
+	if (sdev->channel == 1)
 		sdev->no_uld_attach = 1;
-		vdev->vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
-		/* The real channel for this device is zero */
-		vdev->vtarget->bus_id = 0;
-		/* The actual physdisknum (for RAID passthrough) */
-		vdev->vtarget->target_id = physdisknum;
-	}
 
 	return 0;
 }
@@ -358,13 +416,35 @@ static int mptspi_slave_configure(struct
 		return ret;
 
 	if ((sdev->channel == 1 ||
-	     !(hd->ioc->raid_data.isRaid & (1 << sdev->id))) &&
+	     !(mptspi_is_raid(hd, sdev->id))) &&
 	    !spi_initial_dv(sdev->sdev_target))
 		mptspi_dv_device(hd, sdev);
 
 	return 0;
 }
 
+static int
+mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+{
+	struct _MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
+	VirtDevice	*vdev = SCpnt->device->hostdata;
+
+	if (!vdev || !vdev->vtarget) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
+	if (SCpnt->device->channel == 1 &&
+		mptscsih_is_phys_disk(hd->ioc, 0, SCpnt->device->id) == 0) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
+	return mptscsih_qcmd(SCpnt,done);
+}
+
 static void mptspi_slave_destroy(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = scsi_target(sdev);
@@ -392,11 +472,11 @@ static struct scsi_host_template mptspi_
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptscsih_qcmd,
+	.queuecommand			= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
 	.slave_alloc			= mptspi_slave_alloc,
 	.slave_configure		= mptspi_slave_configure,
-	.target_destroy			= mptscsih_target_destroy,
+	.target_destroy			= mptspi_target_destroy,
 	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
@@ -427,7 +507,7 @@ static int mptspi_write_spi_device_pg1(s
 
 	/* don't allow updating nego parameters on RAID devices */
 	if (starget->channel == 0 &&
-	    (hd->ioc->raid_data.isRaid & (1 << starget->id)))
+	    mptspi_is_raid(hd, starget->id))
 		return -1;
 
 	size = ioc->spi_data.sdp1length * 4;
@@ -672,9 +752,9 @@ static void mpt_work_wrapper(struct work
 		if (sdev->channel != 1)
 			continue;
 
-		/* The target_id is the raid PhysDiskNum, even if
+		/* The id is the raid PhysDiskNum, even if
 		 * starget->id is the actual target address */
-		if(vtarget->target_id != disk)
+		if(vtarget->id != disk)
 			continue;
 
 		starget_printk(KERN_INFO, vtarget->starget,
@@ -727,7 +807,7 @@ mptspi_deny_binding(struct scsi_target *
 {
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)dev_to_shost(starget->dev.parent)->hostdata;
-	return ((hd->ioc->raid_data.isRaid & (1 << starget->id)) &&
+	return ((mptspi_is_raid(hd, starget->id)) &&
 		starget->channel == 0) ? 1 : 0;
 }
 
@@ -945,7 +1025,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	 * max_lun = 1 + actual last lun,
 	 *	see hosts.h :o(
 	 */
-	sh->max_id = MPT_MAX_SCSI_DEVICES;
+	sh->max_id = ioc->devices_per_bus;
 
 	sh->max_lun = MPT_LAST_LUN + 1;
 	/*
@@ -1009,20 +1089,6 @@ mptspi_probe(struct pci_dev *pdev, const
 	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
-	/* Allocate memory for the device structures.
-	 * A non-Null pointer at an offset
-	 * indicates a device exists.
-	 * max_id = 1 + maximum id (hosts.h)
-	 */
-	hd->Targets = kcalloc(sh->max_id * (sh->max_channel + 1),
-			      sizeof(void *), GFP_ATOMIC);
-	if (!hd->Targets) {
-		error = -ENOMEM;
-		goto out_mptspi_probe;
-	}
-
-	dprintk((KERN_INFO "  vdev @ %p\n", hd->Targets));
-
 	/* Clear the TM flags
 	 */
 	hd->tmPending = 0;

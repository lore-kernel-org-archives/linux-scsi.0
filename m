From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 4/8] mptfusion: replace chip_type
Date: Thu, 18 Nov 2004 16:33:07 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C54677B@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CDC6.F5832D90"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12991 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261452AbUKSQLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:11:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CDC6.F5832D90
Content-Type: text/plain;
	charset="iso-8859-1"

This replaces chip_type with bus_type.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>






------_=_NextPart_000_01C4CDC6.F5832D90
Content-Type: application/octet-stream;
	name="mptfusion-4.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-4.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2004-11-18 11:23:04.000000000 =
-0700=0A=
@@ -337,15 +337,13 @@=0A=
 			ioc_stat =3D le16_to_cpu(mr->u.reply.IOCStatus);=0A=
 			if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {=0A=
 				u32	 log_info =3D le32_to_cpu(mr->u.reply.IOCLogInfo);=0A=
-				if ((int)ioc->chip_type <=3D (int)FC929)=0A=
+				if (ioc->bus_type =3D=3D FC)=0A=
 					mpt_fc_log_info(ioc, log_info);=0A=
-				else=0A=
+				else if (ioc->bus_type =3D=3D SCSI)=0A=
 					mpt_sp_log_info(ioc, log_info);=0A=
 			}=0A=
 			if (ioc_stat & MPI_IOCSTATUS_MASK) {=0A=
-				if ((int)ioc->chip_type <=3D (int)FC929)=0A=
-						;=0A=
-				else=0A=
+				if (ioc->bus_type =3D=3D SCSI)=0A=
 					mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);=0A=
 			}=0A=
 		} else {=0A=
@@ -392,7 +390,7 @@=0A=
 		}=0A=
 =0A=
 #ifdef MPT_DEBUG_IRQ=0A=
-		if ((int)ioc->chip_type > (int)FC929) {=0A=
+		if (ioc->bus_type =3D=3D SCSI) {=0A=
 			/* Verify mf, mr are reasonable.=0A=
 			 */=0A=
 			if ((mf) && ((mf >=3D MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))=0A=
@@ -1220,22 +1218,21 @@=0A=
 		ioc->pio_chip =3D (SYSIF_REGS __iomem *)pmem;=0A=
 	}=0A=
 =0A=
-	ioc->chip_type =3D FCUNK;=0A=
 	if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC909) {=0A=
-		ioc->chip_type =3D FC909;=0A=
 		ioc->prod_name =3D "LSIFC909";=0A=
+		ioc->bus_type =3D FC;=0A=
 	}=0A=
 	if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC929) {=0A=
-		ioc->chip_type =3D FC929;=0A=
 		ioc->prod_name =3D "LSIFC929";=0A=
+		ioc->bus_type =3D FC;=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC919) {=0A=
-		ioc->chip_type =3D FC919;=0A=
 		ioc->prod_name =3D "LSIFC919";=0A=
+		ioc->bus_type =3D FC;=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC929X) {=0A=
-		ioc->chip_type =3D FC929X;=0A=
 		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);=0A=
+		ioc->bus_type =3D FC;=0A=
 		if (revision < XL_929) {=0A=
 			ioc->prod_name =3D "LSIFC929X";=0A=
 			/* 929X Chip Fix. Set Split transactions level=0A=
@@ -1254,8 +1251,8 @@=0A=
 		}=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC919X) {=0A=
-		ioc->chip_type =3D FC919X;=0A=
 		ioc->prod_name =3D "LSIFC919X";=0A=
+		ioc->bus_type =3D FC;=0A=
 		/* 919X Chip Fix. Set Split transactions level=0A=
 		 * for PCIX. Set MOST bits to zero.=0A=
 		 */=0A=
@@ -1264,8 +1261,8 @@=0A=
 		pci_write_config_byte(pdev, 0x6a, pcixcmd);=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_53C1030) {=0A=
-		ioc->chip_type =3D C1030;=0A=
 		ioc->prod_name =3D "LSI53C1030";=0A=
+		ioc->bus_type =3D SCSI;=0A=
 		/* 1030 Chip Fix. Disable Split transactions=0A=
 		 * for PCIX. Set MOST bits to zero if Rev < C0( =3D 8).=0A=
 		 */=0A=
@@ -1277,8 +1274,8 @@=0A=
 		}=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_1030_53C1035) =
{=0A=
-		ioc->chip_type =3D C1035;=0A=
 		ioc->prod_name =3D "LSI53C1035";=0A=
+		ioc->bus_type =3D SCSI;=0A=
 	}=0A=
 =0A=
 	sprintf(ioc->name, "ioc%d", ioc->id);=0A=
@@ -1326,9 +1323,7 @@=0A=
 	/* NEW!  20010220 -sralston=0A=
 	 * Check for "bound ports" (929, 929X, 1030, 1035) to reduce =
redundant resets.=0A=
 	 */=0A=
-	if ((ioc->chip_type =3D=3D FC929) || (ioc->chip_type =3D=3D C1030)=0A=
-			|| (ioc->chip_type =3D=3D C1035) || (ioc->chip_type =3D=3D =
FC929X))=0A=
-		mpt_detect_bound_ports(ioc, pdev);=0A=
+	mpt_detect_bound_ports(ioc, pdev);=0A=
 =0A=
 	if ((r =3D mpt_do_ioc_recovery(ioc,=0A=
 	  MPT_HOSTEVENT_IOC_BRINGUP, CAN_SLEEP)) !=3D 0) {=0A=
@@ -1760,7 +1755,7 @@=0A=
 	 *	and we try GetLanConfigPages again...=0A=
 	 */=0A=
 	if ((ret =3D=3D 0) && (reason =3D=3D MPT_HOSTEVENT_IOC_BRINGUP)) {=0A=
-		if ((int)ioc->chip_type <=3D (int)FC929) {=0A=
+		if (ioc->bus_type =3D=3D FC) {=0A=
 			/*=0A=
 			 *  Pre-fetch FC port WWN and stuff...=0A=
 			 *  (FCPortPage0_t stuff)=0A=
@@ -2103,20 +2098,8 @@=0A=
 	}=0A=
 =0A=
 	/* Is it already READY? */=0A=
-	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) =3D=3D =
MPI_IOC_STATE_READY) {=0A=
-		if ((int)ioc->chip_type <=3D (int)FC929)=0A=
-			return 0;=0A=
-		else {=0A=
-			return 0;=0A=
-			/* Workaround from broken 1030 FW.=0A=
-			 * Force a diagnostic reset if fails.=0A=
-			 */=0A=
-/*			if ((r =3D SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, =
sleepFlag)) =3D=3D 0)=0A=
-				return 0;=0A=
-			else=0A=
-				statefault =3D 4; */=0A=
-		}=0A=
-	}=0A=
+	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) =3D=3D =
MPI_IOC_STATE_READY) =0A=
+		return 0;=0A=
 =0A=
 	/*=0A=
 	 *	Check to see if IOC is in FAULT state.=0A=
@@ -2513,11 +2496,11 @@=0A=
 	ddlprintk((MYIOC_s_INFO_FMT "upload_fw %d facts.Flags=3D%x\n",=0A=
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));=0A=
 =0A=
-	if ((int)ioc->chip_type <=3D (int)FC929) {=0A=
+	if (ioc->bus_type =3D=3D FC)=0A=
 		ioc_init.MaxDevices =3D MPT_MAX_FC_DEVICES;=0A=
-	} else {=0A=
+	else=0A=
 		ioc_init.MaxDevices =3D MPT_MAX_SCSI_DEVICES;=0A=
-	}=0A=
+	=0A=
 	ioc_init.MaxBuses =3D MPT_MAX_BUS;=0A=
 =0A=
 	ioc_init.ReplyFrameSize =3D cpu_to_le16(ioc->reply_sz);	/* in BYTES =
*/=0A=
@@ -2622,7 +2605,7 @@=0A=
 =0A=
 	/* RAID FW may take a long time to enable=0A=
 	 */=0A=
-	if ((int)ioc->chip_type <=3D (int)FC929) {=0A=
+	if (ioc->bus_type =3D=3D FC) {=0A=
 		ii =3D mpt_handshake_req_reply_wait(ioc, req_sz, =
(u32*)&port_enable,=0A=
 				reply_sz, (u16*)&reply_buf, 65 /*seconds*/, sleepFlag);=0A=
 	} else {=0A=
@@ -2992,7 +2975,7 @@=0A=
 	int cnt,cntdn;=0A=
 =0A=
 	dinitprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", =
ioc->name));=0A=
-	if ((int)ioc->chip_type > (int)FC929) {=0A=
+	if (ioc->bus_type =3D=3D SCSI) {=0A=
 		/* Always issue a Msg Unit Reset first. This will clear some=0A=
 		 * SCSI bus hang conditions.=0A=
 		 */=0A=
@@ -3420,7 +3403,7 @@=0A=
 	dinitprintk((KERN_INFO MYNAM ": %s Now numSGE=3D%d num_sge=3D%d =
num_chain=3D%d\n",=0A=
 		ioc->name, numSGE, num_sge, num_chain));=0A=
 =0A=
-	if ((int) ioc->chip_type > (int) FC929)=0A=
+	if (ioc->bus_type =3D=3D SCSI)=0A=
 		num_chain *=3D MPT_SCSI_CAN_QUEUE;=0A=
 	else=0A=
 		num_chain *=3D MPT_FC_CAN_QUEUE;=0A=
@@ -5277,7 +5260,7 @@=0A=
 		len +=3D sprintf(buf+len, "  PortNumber =3D %d (of %d)\n",=0A=
 				p+1,=0A=
 				ioc->facts.NumberOfPorts);=0A=
-		if ((int)ioc->chip_type <=3D (int)FC929) {=0A=
+		if (ioc->bus_type =3D=3D FC) {=0A=
 			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {=0A=
 				u8 *a =3D (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;=0A=
 				len +=3D sprintf(buf+len, "    LanAddr =3D =
%02X:%02X:%02X:%02X:%02X:%02X\n",=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-11-18 09:47:28.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-11-18 13:11:37.000000000 =
-0700=0A=
@@ -296,23 +296,6 @@=0A=
 	SGESimple64_t	 sge[1];=0A=
 } MPT_SGL64_HDR;=0A=
 =0A=
-=0A=
-/*=0A=
- *  Chip-specific stuff... FC929 delineates break between=0A=
- *  FC and Parallel SCSI parts. Do NOT re-order.=0A=
- */=0A=
-=0A=
-typedef enum {=0A=
-	FC919X =3D 0x0819,=0A=
-	FC929X =3D 0x0829,=0A=
-	FC909 =3D 0x0909,=0A=
-	FC919 =3D 0x0919,=0A=
-	FC929 =3D 0x0929,=0A=
-	C1030 =3D 0x1030,=0A=
-	C1035 =3D 0x1035,=0A=
-	FCUNK =3D 0xFBAD=0A=
-} CHIP_TYPE;=0A=
-=0A=
 /*=0A=
  *  System interface register set=0A=
  */=0A=
@@ -517,6 +500,7 @@=0A=
 	char			*prod_name;	/* "LSIFC9x9"         */=0A=
 	SYSIF_REGS __iomem	*chip;		/* =3D=3D c8817000 (mmap) */=0A=
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */=0A=
+	u8			 bus_type;=0A=
 	u32			 mem_phys;	/* =3D=3D f4020000 (mmap) */=0A=
 	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */=0A=
 	int			 mem_size;	/* mmap memory size */=0A=
@@ -543,7 +527,6 @@=0A=
 	dma_addr_t		 ChainBufferDMA;=0A=
 	struct list_head	 FreeChainQ;=0A=
 	spinlock_t		 FreeChainQlock;=0A=
-	CHIP_TYPE		 chip_type;=0A=
 		/* We (host driver) get to manage our own RequestQueue! */=0A=
 	dma_addr_t		 req_frames_dma;=0A=
 	MPT_FRAME_HDR		*req_frames;	/* Request msg frames - rounded up! */=0A=
@@ -888,6 +871,12 @@=0A=
 #define	TM_STATE_IN_PROGRESS   (1)=0A=
 #define	TM_STATE_ERROR	       (2)=0A=
 =0A=
+typedef enum {=0A=
+	FC,=0A=
+	SCSI,=0A=
+	SAS=0A=
+} BUS_TYPE;=0A=
+=0A=
 typedef struct _MPT_SCSI_HOST {=0A=
 	MPT_ADAPTER		 *ioc;=0A=
 	int			  port;=0A=
@@ -903,7 +892,6 @@=0A=
 		 */=0A=
 	u8			  tmPending;=0A=
 	u8			  resetPending;=0A=
-	u8			  is_spi;		/* Parallel SCSI i/f */=0A=
 	u8			  negoNvram;		/* DV disabled, nego NVRAM */=0A=
 	u8			  pad1;=0A=
 	u8                        tmState;=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptctl.c	2004-11-18 11:17:58.000000000 =
-0700=0A=
@@ -1218,7 +1218,7 @@=0A=
 	/* Fill in the data and return the structure to the calling=0A=
 	 * program=0A=
 	 */=0A=
-	if ((int)ioc->chip_type <=3D (int) FC929)=0A=
+	if (ioc->bus_type =3D=3D FC)=0A=
 		karg->adapterType =3D MPT_IOCTL_INTERFACE_FC;=0A=
 	else=0A=
 		karg->adapterType =3D MPT_IOCTL_INTERFACE_SCSI;=0A=
@@ -1518,7 +1518,7 @@=0A=
 #ifdef MFCNT=0A=
 	karg.chip_type =3D ioc->mfcnt;=0A=
 #else=0A=
-	karg.chip_type =3D ioc->chip_type;=0A=
+	karg.chip_type =3D ioc->pcidev->device;=0A=
 #endif=0A=
 	strncpy (karg.name, ioc->name, MPT_MAX_NAME);=0A=
 	karg.name[MPT_MAX_NAME-1]=3D'\0';=0A=
@@ -2470,7 +2470,7 @@=0A=
 =0A=
 	karg.base_io_addr =3D pci_resource_start(pdev, 0);=0A=
 =0A=
-	if ((int)ioc->chip_type <=3D (int) FC929)=0A=
+	if (ioc->bus_type =3D=3D FC)=0A=
 		karg.bus_phys_width =3D HP_BUS_WIDTH_UNK;=0A=
 	else=0A=
 		karg.bus_phys_width =3D HP_BUS_WIDTH_16;=0A=
@@ -2559,7 +2559,7 @@=0A=
 =0A=
 	/*  There is nothing to do for FCP parts.=0A=
 	 */=0A=
-	if ((int) ioc->chip_type <=3D (int) FC929)=0A=
+	if (ioc->bus_type =3D=3D FC)=0A=
 		return 0;=0A=
 =0A=
 	if ((ioc->spi_data.sdp0length =3D=3D 0) || (ioc->sh =3D=3D NULL))=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 11:41:44.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 12:56:39.000000000 =
-0700=0A=
@@ -712,7 +712,7 @@=0A=
 			sc->result =3D DID_RESET << 16;=0A=
 =0A=
 			/* GEM Workaround. */=0A=
-			if (hd->is_spi)=0A=
+			if (ioc->bus_type =3D=3D SCSI)=0A=
 				mptscsih_no_negotiate(hd, sc->device->id);=0A=
 			break;=0A=
 =0A=
@@ -1107,7 +1107,7 @@=0A=
 	 * max_lun =3D 1 + actual last lun,=0A=
 	 *	see hosts.h :o(=0A=
 	 */=0A=
-	if ((int)ioc->chip_type > (int)FC929) {=0A=
+	if (ioc->bus_type =3D=3D SCSI) {=0A=
 		sh->max_id =3D MPT_MAX_SCSI_DEVICES;=0A=
 	} else {=0A=
 	/* For FC, increase the queue depth=0A=
@@ -1166,9 +1166,6 @@=0A=
 	hd =3D (MPT_SCSI_HOST *) sh->hostdata;=0A=
 	hd->ioc =3D ioc;=0A=
 =0A=
-	if ((int)ioc->chip_type > (int)FC929)=0A=
-		hd->is_spi =3D 1;=0A=
-=0A=
 	/* SCSI needs scsi_cmnd lookup table!=0A=
 	 * (with size equal to req_depth*PtrSz!)=0A=
 	 */=0A=
@@ -1234,7 +1231,7 @@=0A=
 	/* Moved Earlier Pam D */=0A=
 	/* ioc->sh =3D sh;	*/=0A=
 =0A=
-	if (hd->is_spi) {=0A=
+	if (ioc->bus_type =3D=3D SCSI) {=0A=
 		/* Update with the driver setup=0A=
 		 * values.=0A=
 		 */=0A=
@@ -1801,7 +1798,7 @@=0A=
 	SCpnt->host_scribble =3D NULL;=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
-	if (hd->is_spi) {=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		int dvStatus =3D hd->ioc->spi_data.dvStatus[target];=0A=
 		int issueCmd =3D 1;=0A=
 =0A=
@@ -2255,9 +2252,9 @@=0A=
 	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! =
(sc=3D%p)\n",=0A=
 	       hd->ioc->name, SCpnt);=0A=
 =0A=
-	/* Unsupported for SCSI. Supported for FCP=0A=
+	/* Supported for FC only.=0A=
 	 */=0A=
-	if (hd->is_spi)=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) =0A=
 		return FAILED;=0A=
 =0A=
 	spin_unlock_irq(host_lock);=0A=
@@ -2589,7 +2586,7 @@=0A=
 	vdev->bus_id =3D device->channel;=0A=
 	vdev->raidVolume =3D 0;=0A=
 	hd->Targets[device->id] =3D vdev;=0A=
-	if (hd->is_spi) {=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		if (hd->ioc->spi_data.isRaid & (1 << device->id)) {=0A=
 			vdev->raidVolume =3D 1;=0A=
 			ddvtprintk((KERN_INFO=0A=
@@ -2645,7 +2642,7 @@=0A=
 	kfree(hd->Targets[target]);=0A=
 	hd->Targets[target] =3D NULL;=0A=
 	=0A=
-	if (hd->is_spi) {=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		if (mptscsih_is_raid_volume(hd, target)) {=0A=
 			hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 		} else {=0A=
@@ -2667,7 +2664,7 @@=0A=
 	int	max_depth;=0A=
 	int	tagged;=0A=
 =0A=
-	if (hd->is_spi) {=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {=0A=
 			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))=0A=
 				max_depth =3D 1;=0A=
@@ -2946,7 +2943,7 @@=0A=
 =0A=
 		/* 4. Renegotiate to all devices, if SCSI=0A=
 		 */=0A=
-		if (hd->is_spi) {=0A=
+		if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));=0A=
 			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | =
MPT_SCSICFG_USE_NVRAM);=0A=
 		}=0A=
@@ -2975,7 +2972,7 @@=0A=
 =0A=
 		/* 7. Set flag to force DV and re-read IOC Page 3=0A=
 		 */=0A=
-		if (hd->is_spi) {=0A=
+		if (ioc->bus_type =3D=3D SCSI) {=0A=
 			ioc->spi_data.forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 			ddvtprintk(("Set reload IOC Pg3 Flag\n"));=0A=
 		}=0A=
@@ -3006,7 +3003,7 @@=0A=
 		hd =3D NULL;=0A=
 		if (ioc->sh) {=0A=
 			hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
-			if (hd && (hd->is_spi) && (hd->soft_resets < -1))=0A=
+			if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->soft_resets < -1))=0A=
 				hd->soft_resets++;=0A=
 		}=0A=
 		break;=0A=
@@ -3035,7 +3032,7 @@=0A=
 		if (ioc->sh)=0A=
 			hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
 =0A=
-		if (hd && (hd->is_spi) && (hd->negoNvram =3D=3D 0)) {=0A=
+		if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->negoNvram =3D=3D 0)) =
{=0A=
 			ScsiCfgData	*pSpi;=0A=
 			Ioc3PhysDisk_t	*pPDisk;=0A=
 			int		 numPDisk;=0A=
@@ -3182,7 +3179,7 @@=0A=
 	indexed_lun =3D (lun % 32);=0A=
 	vdev->luns[lun_index] |=3D (1 << indexed_lun);=0A=
 =0A=
-	if (hd->is_spi) {=0A=
+	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		if ((data[0] =3D=3D TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) =
{=0A=
 			/* Treat all Processors as SAF-TE if=0A=
 			 * command line option is set */=0A=
@@ -4463,7 +4460,7 @@=0A=
 	/* Write SDP1 for all SCSI devices=0A=
 	 * Alloc memory and set up config buffer=0A=
 	 */=0A=
-	if (hd->is_spi) {=0A=
+	if (ioc->bus_type =3D=3D SCSI) {=0A=
 		if (ioc->spi_data.sdp1length > 0) {=0A=
 			pcfg1Data =3D (SCSIDevicePage1_t =
*)pci_alloc_consistent(ioc->pcidev,=0A=
 					 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);=0A=
@@ -4606,7 +4603,7 @@=0A=
 			msleep(250);=0A=
 =0A=
 			/* DV only to SCSI adapters */=0A=
-			if ((int)ioc->chip_type <=3D (int)FC929)=0A=
+			if (ioc->bus_type !=3D SCSI)=0A=
 				continue;=0A=
 =0A=
 			/* Make sure everything looks ok */=0A=

------_=_NextPart_000_01C4CDC6.F5832D90--

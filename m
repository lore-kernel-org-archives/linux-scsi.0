From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] - mptfusion - fix mapping for transport (FC/SPI/SAS) supp
	ort
Date: Fri, 11 Nov 2005 16:47:42 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04DEBFC7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5E71A.4E0D39A8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27618 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750702AbVKKXsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 18:48:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, hch@infradead.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5E71A.4E0D39A8
Content-Type: text/plain

Here is a patch for review.

This is to fix proper mid-layer to mpt fw mapping. 
This is in preparation for James Bottomley's 
SPI and RAID transport, and SGI's FC Transport support.
The SAS mapping implementation is currently broken in several
areas, to include error handling, which this patch fix's.   

The hd->Target[] data area will go away once
in driver domain validation is replaced with 
James SPI transport support.  This is replaced with
the usage of scsi_device->hostdata and 
scsi_target->hostdata. I've added support for 
scsi_host->target_alloc and scsi_host->target_destroy.
You will notice that hd->Target[] only is 
present in the domain validation path.

I've also added scsi_host->module = THIS_MODULE, so 
you will not be able to unload the driver when file handle is open. 

TODO:
(1) IOCTL path - add support for converting scsi-mid layer
to f/w mapping.
(2) RAID support in SAS - This implementation of sas transport
layer doesn't recognize raid volumes; i.e. a raid volume doesn't 
exist as a remote phy, so can we report it so block layer sees it??


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



------_=_NextPart_000_01C5E71A.4E0D39A8
Content-Type: application/octet-stream;
	name="mapping.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mapping.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-11-09 18:34:59.000000000 =
-0700=0A=
@@ -314,13 +314,13 @@=0A=
 		u32	 log_info =3D le32_to_cpu(mr->u.reply.IOCLogInfo);=0A=
 		if (ioc->bus_type =3D=3D FC)=0A=
 			mpt_fc_log_info(ioc, log_info);=0A=
-		else if (ioc->bus_type =3D=3D SCSI)=0A=
+		else if (ioc->bus_type =3D=3D SPI)=0A=
 			mpt_sp_log_info(ioc, log_info);=0A=
 		else if (ioc->bus_type =3D=3D SAS)=0A=
 			mpt_sas_log_info(ioc, log_info);=0A=
 	}=0A=
 	if (ioc_stat & MPI_IOCSTATUS_MASK) {=0A=
-		if (ioc->bus_type =3D=3D SCSI &&=0A=
+		if (ioc->bus_type =3D=3D SPI &&=0A=
 		    cb_idx !=3D mpt_stm_index &&=0A=
 		    cb_idx !=3D mpt_lan_index)=0A=
 			mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);=0A=
@@ -1317,7 +1317,7 @@=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_53C1030) {=0A=
 		ioc->prod_name =3D "LSI53C1030";=0A=
-		ioc->bus_type =3D SCSI;=0A=
+		ioc->bus_type =3D SPI;=0A=
 		/* 1030 Chip Fix. Disable Split transactions=0A=
 		 * for PCIX. Set MOST bits to zero if Rev < C0( =3D 8).=0A=
 		 */=0A=
@@ -1330,7 +1330,7 @@=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_1030_53C1035) =
{=0A=
 		ioc->prod_name =3D "LSI53C1035";=0A=
-		ioc->bus_type =3D SCSI;=0A=
+		ioc->bus_type =3D SPI;=0A=
 	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_SAS1064) {=0A=
 		ioc->prod_name =3D "LSISAS1064";=0A=
@@ -2984,7 +2984,7 @@=0A=
 	/* Clear the internal flash bad bit - autoincrementing register,=0A=
 	 * so must do two writes.=0A=
 	 */=0A=
-	if (ioc->bus_type =3D=3D SCSI) {=0A=
+	if (ioc->bus_type =3D=3D SPI) {=0A=
 		/*=0A=
 		 * 1030 and 1035 H/W errata, workaround to access=0A=
 		 * the ClearFlashBadSignatureBit=0A=
@@ -3094,7 +3094,7 @@=0A=
 	int cnt,cntdn;=0A=
 =0A=
 	dinitprintk((KERN_WARNING MYNAM ": KickStarting %s!\n", =
ioc->name));=0A=
-	if (ioc->bus_type =3D=3D SCSI) {=0A=
+	if (ioc->bus_type =3D=3D SPI) {=0A=
 		/* Always issue a Msg Unit Reset first. This will clear some=0A=
 		 * SCSI bus hang conditions.=0A=
 		 */=0A=
@@ -3522,7 +3522,7 @@=0A=
 	dinitprintk((KERN_INFO MYNAM ": %s Now numSGE=3D%d num_sge=3D%d =
num_chain=3D%d\n",=0A=
 		ioc->name, numSGE, num_sge, num_chain));=0A=
 =0A=
-	if (ioc->bus_type =3D=3D SCSI)=0A=
+	if (ioc->bus_type =3D=3D SPI)=0A=
 		num_chain *=3D MPT_SCSI_CAN_QUEUE;=0A=
 	else=0A=
 		num_chain *=3D MPT_FC_CAN_QUEUE;=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-11-07 08:53:47.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-11-11 13:42:28.000000000 =
-0700=0A=
@@ -77,8 +77,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.03.04"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.04"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.05"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.05"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -322,7 +322,7 @@=0A=
  *	Dynamic Multi-Pathing specific stuff...=0A=
  */=0A=
 =0A=
-/* VirtDevice negoFlags field */=0A=
+/* VirtTarget negoFlags field */=0A=
 #define MPT_TARGET_NO_NEGO_WIDE		0x01=0A=
 #define MPT_TARGET_NO_NEGO_SYNC		0x02=0A=
 #define MPT_TARGET_NO_NEGO_QAS		0x04=0A=
@@ -331,8 +331,7 @@=0A=
 /*=0A=
  *	VirtDevice - FC LUN device or SCSI target device=0A=
  */=0A=
-typedef struct _VirtDevice {=0A=
-	struct scsi_device	*device;=0A=
+typedef struct _VirtTarget {=0A=
 	u8			 tflags;=0A=
 	u8			 ioc_id;=0A=
 	u8			 target_id;=0A=
@@ -343,21 +342,18 @@=0A=
 	u8			 negoFlags;	/* bit field, see above */=0A=
 	u8			 raidVolume;	/* set, if RAID Volume */=0A=
 	u8			 type;		/* byte 0 of Inquiry data */=0A=
-	u8			 cflags;	/* controller flags */=0A=
-	u8			 rsvd1raid;=0A=
-	u16			 fc_phys_lun;=0A=
-	u16			 fc_xlat_lun;=0A=
 	u32			 num_luns;=0A=
 	u32			 luns[8];		/* Max LUNs is 256 */=0A=
-	u8			 pad[4];=0A=
 	u8			 inq_data[8];=0A=
-		/* IEEE Registered Extended Identifier=0A=
-		   obtained via INQUIRY VPD page 0x83 */=0A=
-		/* NOTE: Do not separate uniq_prepad and uniq_data=0A=
-		   as they are treateed as a single entity in the code */=0A=
-	u8			 uniq_prepad[8];=0A=
-	u8			 uniq_data[20];=0A=
-	u8			 pad2[4];=0A=
+} VirtTarget;=0A=
+=0A=
+typedef struct _VirtDevice {=0A=
+	VirtTarget	 	*vtarget;=0A=
+	u8			 ioc_id;=0A=
+	u8			 bus_id;=0A=
+	u8			 target_id;=0A=
+	u8			 configured_lun;=0A=
+	u32			 lun;=0A=
 } VirtDevice;=0A=
 =0A=
 /*=0A=
@@ -902,7 +898,7 @@=0A=
 =0A=
 typedef enum {=0A=
 	FC,=0A=
-	SCSI,=0A=
+	SPI,=0A=
 	SAS=0A=
 } BUS_TYPE;=0A=
 =0A=
@@ -911,7 +907,7 @@=0A=
 	int			  port;=0A=
 	u32			  pad0;=0A=
 	struct scsi_cmnd	**ScsiLookup;=0A=
-	VirtDevice		**Targets;=0A=
+	VirtTarget		**Targets;=0A=
 	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */=0A=
 	struct timer_list	  timer;=0A=
 		/* Pool of memory for holding SCpnts before doing=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2005-11-11 11:42:57.000000000 =
-0700=0A=
@@ -1246,7 +1246,7 @@=0A=
 	MPT_ADAPTER		*ioc;=0A=
 	struct Scsi_Host	*sh;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
-	VirtDevice		*vdev;=0A=
+	VirtTarget		*vdev;=0A=
 	char			*pmem;=0A=
 	int			*pdata;=0A=
 	IOCPage2_t		*pIoc2;=0A=
@@ -1823,7 +1823,7 @@=0A=
 	case MPI_FUNCTION_SCSI_IO_REQUEST:=0A=
 		if (ioc->sh) {=0A=
 			SCSIIORequest_t *pScsiReq =3D (SCSIIORequest_t *) mf;=0A=
-			VirtDevice	*pTarget =3D NULL;=0A=
+			VirtTarget	*pTarget =3D NULL;=0A=
 			MPT_SCSI_HOST	*hd =3D NULL;=0A=
 			int qtag =3D MPI_SCSIIO_CONTROL_UNTAGGED;=0A=
 			int scsidir =3D 0;=0A=
diff -uarN b/drivers/message/fusion/mptfc.c =
a/drivers/message/fusion/mptfc.c=0A=
--- b/drivers/message/fusion/mptfc.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptfc.c	2005-11-11 10:36:50.000000000 =
-0700=0A=
@@ -84,13 +84,16 @@=0A=
 static int	mptfcInternalCtx =3D -1; /* Used only for internal commands =
*/=0A=
 =0A=
 static struct scsi_host_template mptfc_driver_template =3D {=0A=
+	.module				=3D THIS_MODULE,=0A=
 	.proc_name			=3D "mptfc",=0A=
 	.proc_info			=3D mptscsih_proc_info,=0A=
 	.name				=3D "MPT FC Host",=0A=
 	.info				=3D mptscsih_info,=0A=
 	.queuecommand			=3D mptscsih_qcmd,=0A=
+	.target_alloc			=3D mptscsih_target_alloc,=0A=
 	.slave_alloc			=3D mptscsih_slave_alloc,=0A=
 	.slave_configure		=3D mptscsih_slave_configure,=0A=
+	.target_destroy			=3D mptscsih_target_destroy,=0A=
 	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,=0A=
 	.eh_abort_handler		=3D mptscsih_abort,=0A=
@@ -288,10 +291,10 @@=0A=
 	}=0A=
 =0A=
 	memset(mem, 0, sz);=0A=
-	hd->Targets =3D (VirtDevice **) mem;=0A=
+	hd->Targets =3D (VirtTarget **) mem;=0A=
 =0A=
 	dprintk((KERN_INFO=0A=
-	  "  Targets @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
+	  "  vdev @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
 =0A=
 	/* Clear the TM flags=0A=
 	 */=0A=
diff -uarN b/drivers/message/fusion/mptsas.c =
a/drivers/message/fusion/mptsas.c=0A=
--- b/drivers/message/fusion/mptsas.c	2005-11-07 08:53:47.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptsas.c	2005-11-11 16:13:09.000000000 =
-0700=0A=
@@ -228,31 +228,35 @@=0A=
  * implement ->target_alloc.=0A=
  */=0A=
 static int=0A=
-mptsas_slave_alloc(struct scsi_device *device)=0A=
+mptsas_slave_alloc(struct scsi_device *sdev)=0A=
 {=0A=
-	struct Scsi_Host	*host =3D device->host;=0A=
+	struct Scsi_Host	*host =3D sdev->host;=0A=
 	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 	struct sas_rphy		*rphy;=0A=
 	struct mptsas_portinfo	*p;=0A=
+	VirtTarget		*vtarget;=0A=
 	VirtDevice		*vdev;=0A=
-	uint			target =3D device->id;=0A=
+	struct scsi_target 	*starget;=0A=
 	int i;=0A=
 =0A=
-	if ((vdev =3D hd->Targets[target]) !=3D NULL)=0A=
-		goto out;=0A=
-=0A=
 	vdev =3D kmalloc(sizeof(VirtDevice), GFP_KERNEL);=0A=
 	if (!vdev) {=0A=
 		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",=0A=
 				hd->ioc->name, sizeof(VirtDevice));=0A=
 		return -ENOMEM;=0A=
 	}=0A=
-=0A=
 	memset(vdev, 0, sizeof(VirtDevice));=0A=
-	vdev->tflags =3D =
MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
 	vdev->ioc_id =3D hd->ioc->id;=0A=
+	sdev->hostdata =3D vdev;=0A=
+	starget =3D scsi_target(sdev);=0A=
+	vtarget =3D starget->hostdata;=0A=
+	vdev->vtarget =3D vtarget;=0A=
+	if (vtarget->num_luns =3D=3D 0) {=0A=
+		vtarget->tflags =3D =
MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
+		hd->Targets[sdev->id] =3D vtarget;=0A=
+	}=0A=
 =0A=
-	rphy =3D dev_to_rphy(device->sdev_target->dev.parent);=0A=
+	rphy =3D dev_to_rphy(sdev->sdev_target->dev.parent);=0A=
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {=0A=
 		for (i =3D 0; i < p->num_phys; i++) {=0A=
 			if (p->phy_info[i].attached.sas_address =3D=3D=0A=
@@ -260,7 +264,7 @@=0A=
 				vdev->target_id =3D=0A=
 					p->phy_info[i].attached.target;=0A=
 				vdev->bus_id =3D p->phy_info[i].attached.bus;=0A=
-				hd->Targets[device->id] =3D vdev;=0A=
+				vdev->lun =3D sdev->lun;=0A=
 				goto out;=0A=
 			}=0A=
 		}=0A=
@@ -271,19 +275,24 @@=0A=
 	return -ENODEV;=0A=
 =0A=
  out:=0A=
-	vdev->num_luns++;=0A=
-	device->hostdata =3D vdev;=0A=
+	vtarget->ioc_id =3D vdev->ioc_id;=0A=
+	vtarget->target_id =3D vdev->target_id;=0A=
+	vtarget->bus_id =3D vdev->bus_id;=0A=
+	vtarget->num_luns++;=0A=
 	return 0;=0A=
 }=0A=
 =0A=
 static struct scsi_host_template mptsas_driver_template =3D {=0A=
+	.module				=3D THIS_MODULE,=0A=
 	.proc_name			=3D "mptsas",=0A=
 	.proc_info			=3D mptscsih_proc_info,=0A=
 	.name				=3D "MPT SPI Host",=0A=
 	.info				=3D mptscsih_info,=0A=
 	.queuecommand			=3D mptscsih_qcmd,=0A=
+	.target_alloc			=3D mptscsih_target_alloc,=0A=
 	.slave_alloc			=3D mptsas_slave_alloc,=0A=
 	.slave_configure		=3D mptscsih_slave_configure,=0A=
+	.target_destroy			=3D mptscsih_target_destroy,=0A=
 	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,=0A=
 	.eh_abort_handler		=3D mptscsih_abort,=0A=
@@ -986,7 +995,6 @@=0A=
 		goto out_free_port_info;=0A=
 =0A=
 	list_add_tail(&port_info->list, &ioc->sas_topology);=0A=
-=0A=
 	for (i =3D 0; i < port_info->num_phys; i++) {=0A=
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],=0A=
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<=0A=
@@ -1259,10 +1267,10 @@=0A=
 	}=0A=
 =0A=
 	memset(mem, 0, sz);=0A=
-	hd->Targets =3D (VirtDevice **) mem;=0A=
+	hd->Targets =3D (VirtTarget **) mem;=0A=
 =0A=
 	dprintk((KERN_INFO=0A=
-	  "  Targets @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
+	  "  vtarget @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
 =0A=
 	/* Clear the TM flags=0A=
 	 */=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-11-11 16:14:44.000000000 =
-0700=0A=
@@ -150,28 +150,29 @@=0A=
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t =
*pEvReply);=0A=
 =0A=
-static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int =
target_id, u8 lun, char *data, int dlen);=0A=
-static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56);=0A=
-static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t =
*pReq);=0A=
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget =
*vtarget, u8 lun, char *data, int dlen);=0A=
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget =
*vtarget, char byte56);=0A=
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 =
offset, int *requestedPtr, int *configurationPtr, u8 flags);=0A=
-static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int =
target_id);=0A=
+static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd =
*sc);=0A=
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int =
target, int flags);=0A=
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, =
int bus);=0A=
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);=0A=
-static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int =
portnum);=0A=
+static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice =
*vdevice);=0A=
+static void	mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, =
VirtTarget *vtarget);=0A=
+static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);=0A=
 =0A=
 static struct work_struct   mptscsih_persistTask;=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD =
*io);=0A=
 static void	mptscsih_domainValidation(void *hd);=0A=
-static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);=0A=
 static void	mptscsih_qas_check(MPT_SCSI_HOST *hd, int id);=0A=
 static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int =
target);=0A=
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void =
*pPage);=0A=
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int =
width);=0A=
 static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);=0A=
+static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd =
*sc);=0A=
 #endif=0A=
 =0A=
 void 		mptscsih_remove(struct pci_dev *);=0A=
@@ -627,7 +628,7 @@=0A=
 		dreplyprintk((KERN_NOTICE "Reply ha=3D%d id=3D%d lun=3D%d:\n"=0A=
 			"IOCStatus=3D%04xh SCSIState=3D%02xh SCSIStatus=3D%02xh\n"=0A=
 			"resid=3D%d bufflen=3D%d xfer_cnt=3D%d\n",=0A=
-			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
+			ioc->id, sc->device->id, sc->device->lun,=0A=
 			status, scsi_state, scsi_status, sc->resid,=0A=
 			sc->request_bufflen, xfer_cnt));=0A=
 =0A=
@@ -641,7 +642,7 @@=0A=
 		    pScsiReply->ResponseInfo) {=0A=
 			printk(KERN_NOTICE "ha=3D%d id=3D%d lun=3D%d: "=0A=
 			"FCP_ResponseInfo=3D%08xh\n",=0A=
-			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
+			ioc->id, sc->device->id, sc->device->lun,=0A=
 			le32_to_cpu(pScsiReply->ResponseInfo));=0A=
 		}=0A=
 =0A=
@@ -677,8 +678,8 @@=0A=
 			sc->result =3D DID_RESET << 16;=0A=
 =0A=
 			/* GEM Workaround. */=0A=
-			if (ioc->bus_type =3D=3D SCSI)=0A=
-				mptscsih_no_negotiate(hd, sc->device->id);=0A=
+			if (ioc->bus_type =3D=3D SPI)=0A=
+				mptscsih_no_negotiate(hd, sc);=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */=0A=
@@ -892,16 +893,15 @@=0A=
  *		when a lun is disable by mid-layer.=0A=
  *		Do NOT access the referenced scsi_cmnd structure or=0A=
  *		members. Will cause either a paging or NULL ptr error.=0A=
- *	@hd: Pointer to a SCSI HOST structure=0A=
- *	@target: target id=0A=
- *	@lun: lun=0A=
+ *      @hd: Pointer to a SCSI HOST structure=0A=
+ *	@vdevice: per device private data=0A=
  *=0A=
  *	Returns: None.=0A=
  *=0A=
  *	Called from slave_destroy.=0A=
  */=0A=
 static void=0A=
-mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, uint target, uint =
lun)=0A=
+mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice =
*vdevice)=0A=
 {=0A=
 	SCSIIORequest_t	*mf =3D NULL;=0A=
 	int		 ii;=0A=
@@ -909,7 +909,7 @@=0A=
 	struct scsi_cmnd *sc;=0A=
 =0A=
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max =
%d\n",=0A=
-			target, lun, max));=0A=
+			vdevice->target_id, vdevice->lun, max));=0A=
 =0A=
 	for (ii=3D0; ii < max; ii++) {=0A=
 		if ((sc =3D hd->ScsiLookup[ii]) !=3D NULL) {=0A=
@@ -919,7 +919,7 @@=0A=
 			dsprintk(( "search_running: found (sc=3D%p, mf =3D %p) target %d, =
lun %d \n",=0A=
 					hd->ScsiLookup[ii], mf, mf->TargetID, mf->LUN[1]));=0A=
 =0A=
-			if ((mf->TargetID !=3D ((u8)target)) || (mf->LUN[1] !=3D ((u8) =
lun)))=0A=
+			if ((mf->TargetID !=3D ((u8)vdevice->target_id)) || (mf->LUN[1] =
!=3D ((u8) vdevice->lun)))=0A=
 				continue;=0A=
 =0A=
 			/* Cleanup=0A=
@@ -993,8 +993,10 @@=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
 	struct Scsi_Host 	*host =3D ioc->sh;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 	int 		 	count;=0A=
 	unsigned long	 	flags;=0A=
+#endif	=0A=
 	int sz1;=0A=
 =0A=
 	if(!host) {=0A=
@@ -1077,11 +1079,6 @@=0A=
 =0A=
 	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 =0A=
-	/* Flush the cache of this adapter=0A=
-	 */=0A=
-	if(hd !=3D NULL)=0A=
-		mptscsih_synchronize_cache(hd, 0);=0A=
-=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_PM=0A=
@@ -1288,7 +1285,7 @@=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 	MPT_FRAME_HDR		*mf;=0A=
 	SCSIIORequest_t		*pScsiReq;=0A=
-	VirtDevice		*pTarget =3D SCpnt->device->hostdata;=0A=
+	VirtDevice		*vdev =3D SCpnt->device->hostdata;=0A=
 	int	 lun;=0A=
 	u32	 datalen;=0A=
 	u32	 scsictl;=0A=
@@ -1343,8 +1340,8 @@=0A=
 	/* Default to untagged. Once a target structure has been =
allocated,=0A=
 	 * use the Inquiry data to determine if device supports tagged.=0A=
 	 */=0A=
-	if (pTarget=0A=
-	    && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
+	if (vdev=0A=
+	    && (vdev->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
 	    && (SCpnt->device->tagged_supported)) {=0A=
 		scsictl =3D scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;=0A=
 	} else {=0A=
@@ -1353,8 +1350,8 @@=0A=
 =0A=
 	/* Use the above information to set up the message frame=0A=
 	 */=0A=
-	pScsiReq->TargetID =3D (u8) pTarget->target_id;=0A=
-	pScsiReq->Bus =3D pTarget->bus_id;=0A=
+	pScsiReq->TargetID =3D (u8) vdev->target_id;=0A=
+	pScsiReq->Bus =3D vdev->bus_id;=0A=
 	pScsiReq->ChainOffset =3D 0;=0A=
 	pScsiReq->Function =3D MPI_FUNCTION_SCSI_IO_REQUEST;=0A=
 	pScsiReq->CDBLength =3D SCpnt->cmd_len;=0A=
@@ -1405,8 +1402,8 @@=0A=
 	SCpnt->host_scribble =3D NULL;=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		int dvStatus =3D hd->ioc->spi_data.dvStatus[pTarget->target_id];=0A=
+	if (hd->ioc->bus_type =3D=3D SPI) {=0A=
+		int dvStatus =3D hd->ioc->spi_data.dvStatus[vdev->target_id];=0A=
 		int issueCmd =3D 1;=0A=
 =0A=
 		if (dvStatus || hd->ioc->spi_data.forceDv) {=0A=
@@ -1439,7 +1436,7 @@=0A=
 			/* Set the DV flags.=0A=
 			 */=0A=
 			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)=0A=
-				mptscsih_set_dvflags(hd, pScsiReq);=0A=
+				mptscsih_set_dvflags(hd, SCpnt);=0A=
 =0A=
 			if (!issueCmd)=0A=
 				goto fail;=0A=
@@ -1743,6 +1740,7 @@=0A=
 	u32		 ctx2abort;=0A=
 	int		 scpnt_idx;=0A=
 	int		 retval;=0A=
+	VirtDevice	 *vdev;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
@@ -1792,8 +1790,9 @@=0A=
 =0A=
 	hd->abortSCpnt =3D SCpnt;=0A=
 =0A=
+	vdev =3D SCpnt->device->hostdata;=0A=
 	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,=0A=
-		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,=0A=
+		vdev->bus_id, vdev->target_id, vdev->lun,=0A=
 		ctx2abort, 2 /* 2 second timeout */);=0A=
 =0A=
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=3D%p)\n",=0A=
@@ -1824,6 +1823,7 @@=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
 	int		 retval;=0A=
+	VirtDevice	 *vdev;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
@@ -1841,8 +1841,9 @@=0A=
 	       hd->ioc->name, SCpnt);=0A=
 	scsi_print_command(SCpnt);=0A=
 =0A=
+	vdev =3D SCpnt->device->hostdata;=0A=
 	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,=0A=
-		SCpnt->device->channel, SCpnt->device->id,=0A=
+		vdev->bus_id, vdev->target_id,=0A=
 		0, 0, 5 /* 5 second timeout */);=0A=
 =0A=
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=3D%p)\n",=0A=
@@ -1873,6 +1874,7 @@=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
 	int		 retval;=0A=
+	VirtDevice	 *vdev;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
@@ -1890,8 +1892,9 @@=0A=
 	if (hd->timeouts < -1)=0A=
 		hd->timeouts++;=0A=
 =0A=
+	vdev =3D SCpnt->device->hostdata;=0A=
 	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,=0A=
-		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */);=0A=
+		vdev->bus_id, 0, 0, 0, 5 /* 5 second timeout */);=0A=
 =0A=
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=3D%p)\n",=0A=
 		hd->ioc->name,=0A=
@@ -2153,23 +2156,36 @@=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	OS entry point to allow host driver to alloc memory=0A=
+ *	for each scsi target. Called once per device the bus scan.=0A=
+ *	Return non-zero if allocation fails.=0A=
+ */=0A=
+int=0A=
+mptscsih_target_alloc(struct scsi_target *starget)=0A=
+{=0A=
+	VirtTarget		*vtarget;=0A=
+=0A=
+	vtarget =3D kmalloc(sizeof(VirtTarget), GFP_KERNEL);=0A=
+	if (!vtarget)=0A=
+		return -ENOMEM;=0A=
+	memset(vtarget, 0, sizeof(VirtTarget));=0A=
+	starget->hostdata =3D vtarget;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+ *	OS entry point to allow host driver to alloc memory=0A=
  *	for each scsi device. Called once per device the bus scan.=0A=
  *	Return non-zero if allocation fails.=0A=
- *	Init memory once per id (not LUN).=0A=
  */=0A=
 int=0A=
-mptscsih_slave_alloc(struct scsi_device *device)=0A=
+mptscsih_slave_alloc(struct scsi_device *sdev)=0A=
 {=0A=
-	struct Scsi_Host	*host =3D device->host;=0A=
+	struct Scsi_Host	*host =3D sdev->host;=0A=
 	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	VirtTarget		*vtarget;=0A=
 	VirtDevice		*vdev;=0A=
-	uint			target =3D device->id;=0A=
-=0A=
-	if (hd =3D=3D NULL)=0A=
-		return -ENODEV;=0A=
-=0A=
-	if ((vdev =3D hd->Targets[target]) !=3D NULL)=0A=
-		goto out;=0A=
+	struct scsi_target 	*starget;=0A=
 =0A=
 	vdev =3D kmalloc(sizeof(VirtDevice), GFP_KERNEL);=0A=
 	if (!vdev) {=0A=
@@ -2179,25 +2195,33 @@=0A=
 	}=0A=
 =0A=
 	memset(vdev, 0, sizeof(VirtDevice));=0A=
-	vdev->tflags =3D MPT_TARGET_FLAGS_Q_YES;=0A=
 	vdev->ioc_id =3D hd->ioc->id;=0A=
-	vdev->target_id =3D device->id;=0A=
-	vdev->bus_id =3D device->channel;=0A=
-	vdev->raidVolume =3D 0;=0A=
-	hd->Targets[device->id] =3D vdev;=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {=0A=
-			vdev->raidVolume =3D 1;=0A=
-			ddvtprintk((KERN_INFO=0A=
-			    "RAID Volume @ id %d\n", device->id));=0A=
+	vdev->target_id =3D sdev->id;=0A=
+	vdev->bus_id =3D sdev->channel;=0A=
+	vdev->lun =3D sdev->lun;=0A=
+	sdev->hostdata =3D vdev;=0A=
+=0A=
+	starget =3D scsi_target(sdev);=0A=
+	vtarget =3D starget->hostdata;=0A=
+	vdev->vtarget =3D vtarget;=0A=
+=0A=
+	if (vtarget->num_luns =3D=3D 0) {=0A=
+		hd->Targets[sdev->id] =3D vtarget;=0A=
+		vtarget->ioc_id =3D hd->ioc->id;=0A=
+		vtarget->tflags =3D MPT_TARGET_FLAGS_Q_YES;=0A=
+		vtarget->target_id =3D sdev->id;=0A=
+		vtarget->bus_id =3D sdev->channel;=0A=
+		if (hd->ioc->bus_type =3D=3D SPI) {=0A=
+			if (hd->ioc->raid_data.isRaid & (1 << sdev->id)) {=0A=
+				vtarget->raidVolume =3D 1;=0A=
+				ddvtprintk((KERN_INFO=0A=
+				    "RAID Volume @ id %d\n", sdev->id));=0A=
+			}=0A=
+		} else {=0A=
+			vtarget->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
 		}=0A=
-	} else {=0A=
-		vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
 	}=0A=
-=0A=
- out:=0A=
-	vdev->num_luns++;=0A=
-	device->hostdata =3D vdev;=0A=
+	vtarget->num_luns++;=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -2206,40 +2230,52 @@=0A=
  *	Called if no device present or device being unloaded=0A=
  */=0A=
 void=0A=
-mptscsih_slave_destroy(struct scsi_device *device)=0A=
+mptscsih_target_destroy(struct scsi_target *starget)=0A=
 {=0A=
-	struct Scsi_Host	*host =3D device->host;=0A=
-	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
-	VirtDevice		*vdev;=0A=
-	uint			target =3D device->id;=0A=
-	uint			lun =3D device->lun;=0A=
-=0A=
-	if (hd =3D=3D NULL)=0A=
-		return;=0A=
-=0A=
-	mptscsih_search_running_cmds(hd, target, lun);=0A=
-=0A=
-	vdev =3D hd->Targets[target];=0A=
-	vdev->luns[0] &=3D ~(1 << lun);=0A=
-	if (--vdev->num_luns)=0A=
-		return;=0A=
-=0A=
-	kfree(hd->Targets[target]);=0A=
-	hd->Targets[target] =3D NULL;=0A=
-=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if (mptscsih_is_phys_disk(hd->ioc, target)) {=0A=
-			hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
-		} else {=0A=
-			hd->ioc->spi_data.dvStatus[target] =3D=0A=
-				MPT_SCSICFG_NEGOTIATE;=0A=
+	if (starget->hostdata)=0A=
+		kfree(starget->hostdata);=0A=
+	starget->hostdata =3D NULL;=0A=
+}=0A=
 =0A=
-			if (!hd->negoNvram) {=0A=
-				hd->ioc->spi_data.dvStatus[target] |=3D=0A=
-					MPT_SCSICFG_DV_NOT_DONE;=0A=
+/*=0A=
+ *	OS entry point to allow for host driver to free allocated memory=0A=
+ *	Called if no device present or device being unloaded=0A=
+ */=0A=
+void=0A=
+mptscsih_slave_destroy(struct scsi_device *sdev)=0A=
+{=0A=
+	struct Scsi_Host	*host =3D sdev->host;=0A=
+	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	VirtTarget		*vtarget;=0A=
+	VirtDevice		*vdevice;=0A=
+	struct scsi_target 	*starget;=0A=
+=0A=
+	starget =3D scsi_target(sdev);=0A=
+	vtarget =3D starget->hostdata;=0A=
+	vdevice =3D sdev->hostdata;=0A=
+=0A=
+	mptscsih_search_running_cmds(hd, vdevice);=0A=
+	vtarget->luns[0] &=3D ~(1 << vdevice->lun);=0A=
+	vtarget->num_luns--;=0A=
+	if (vtarget->num_luns =3D=3D 0) {=0A=
+		mptscsih_negotiate_to_asyn_narrow(hd, vtarget);=0A=
+		if (hd->ioc->bus_type =3D=3D SPI) {=0A=
+			if (mptscsih_is_phys_disk(hd->ioc, vtarget->target_id)) {=0A=
+				hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
+			} else {=0A=
+				hd->ioc->spi_data.dvStatus[vtarget->target_id] =3D=0A=
+					MPT_SCSICFG_NEGOTIATE;=0A=
+				if (!hd->negoNvram) {=0A=
+					hd->ioc->spi_data.dvStatus[vtarget->target_id] |=3D=0A=
+						MPT_SCSICFG_DV_NOT_DONE;=0A=
+				}=0A=
 			}=0A=
 		}=0A=
+		hd->Targets[sdev->id] =3D NULL;=0A=
 	}=0A=
+	mptscsih_synchronize_cache(hd, vdevice);=0A=
+	kfree(vdevice);=0A=
+	sdev->hostdata =3D NULL;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -2253,22 +2289,21 @@=0A=
 int=0A=
 mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)=0A=
 {=0A=
-	MPT_SCSI_HOST	*hd =3D (MPT_SCSI_HOST *)sdev->host->hostdata;=0A=
-	VirtDevice *pTarget;=0A=
-	int	max_depth;=0A=
-	int	tagged;=0A=
-=0A=
-	if (hd =3D=3D NULL)=0A=
-		return 0;=0A=
-	if (!(pTarget =3D hd->Targets[sdev->id]))=0A=
-		return 0;=0A=
-=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {=0A=
-			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))=0A=
+	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)sdev->host->hostdata;=0A=
+	VirtTarget 		*vtarget;=0A=
+	struct scsi_target 	*starget;=0A=
+	int			max_depth;=0A=
+	int			tagged;=0A=
+=0A=
+	starget =3D scsi_target(sdev);=0A=
+	vtarget =3D starget->hostdata;=0A=
+=0A=
+	if (hd->ioc->bus_type =3D=3D SPI) {=0A=
+		if (vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {=0A=
+			if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))=0A=
 				max_depth =3D 1;=0A=
-			else if (((pTarget->inq_data[0] & 0x1f) =3D=3D 0x00) &&=0A=
-			         (pTarget->minSyncFactor <=3D MPT_ULTRA160 ))=0A=
+			else if (((vtarget->inq_data[0] & 0x1f) =3D=3D 0x00) &&=0A=
+			         (vtarget->minSyncFactor <=3D MPT_ULTRA160 ))=0A=
 				max_depth =3D MPT_SCSI_CMD_PER_DEV_HIGH;=0A=
 			else=0A=
 				max_depth =3D MPT_SCSI_CMD_PER_DEV_LOW;=0A=
@@ -2297,64 +2332,58 @@=0A=
  *	Return non-zero if fails.=0A=
  */=0A=
 int=0A=
-mptscsih_slave_configure(struct scsi_device *device)=0A=
+mptscsih_slave_configure(struct scsi_device *sdev)=0A=
 {=0A=
-	struct Scsi_Host	*sh =3D device->host;=0A=
-	VirtDevice		*pTarget;=0A=
+	struct Scsi_Host	*sh =3D sdev->host;=0A=
+	VirtTarget		*vtarget;=0A=
+	VirtDevice		*vdevice;=0A=
+	struct scsi_target 	*starget;=0A=
 	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)sh->hostdata;=0A=
+	int			indexed_lun, lun_index;=0A=
 =0A=
-	if ((hd =3D=3D NULL) || (hd->Targets =3D=3D NULL)) {=0A=
-		return 0;=0A=
-	}=0A=
+	starget =3D scsi_target(sdev);=0A=
+	vtarget =3D starget->hostdata;=0A=
+	vdevice =3D sdev->hostdata;=0A=
 =0A=
 	dsprintk((MYIOC_s_INFO_FMT=0A=
 		"device @ %p, id=3D%d, LUN=3D%d, channel=3D%d\n",=0A=
-		hd->ioc->name, device, device->id, device->lun, =
device->channel));=0A=
-	dsprintk((MYIOC_s_INFO_FMT=0A=
-		"sdtr %d wdtr %d ppr %d inq length=3D%d\n",=0A=
-		hd->ioc->name, device->sdtr, device->wdtr,=0A=
-		device->ppr, device->inquiry_len));=0A=
+		hd->ioc->name, sdev, sdev->id, sdev->lun, sdev->channel));=0A=
+	if (hd->ioc->bus_type =3D=3D SPI)=0A=
+		dsprintk((MYIOC_s_INFO_FMT=0A=
+		    "sdtr %d wdtr %d ppr %d inq length=3D%d\n",=0A=
+		    hd->ioc->name, sdev->sdtr, sdev->wdtr,=0A=
+		    sdev->ppr, sdev->inquiry_len));=0A=
 =0A=
-	if (device->id > sh->max_id) {=0A=
+	if (sdev->id > sh->max_id) {=0A=
 		/* error case, should never happen */=0A=
-		scsi_adjust_queue_depth(device, 0, 1);=0A=
+		scsi_adjust_queue_depth(sdev, 0, 1);=0A=
 		goto slave_configure_exit;=0A=
 	}=0A=
 =0A=
-	pTarget =3D hd->Targets[device->id];=0A=
-=0A=
-	if (pTarget =3D=3D NULL) {=0A=
-		/* Driver doesn't know about this device.=0A=
-		 * Kernel may generate a "Dummy Lun 0" which=0A=
-		 * may become a real Lun if a=0A=
-		 * "scsi add-single-device" command is executed=0A=
-		 * while the driver is active (hot-plug a=0A=
-		 * device).  LSI Raid controllers need=0A=
-		 * queue_depth set to DEV_HIGH for this reason.=0A=
-		 */=0A=
-		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,=0A=
-			MPT_SCSI_CMD_PER_DEV_HIGH);=0A=
-		goto slave_configure_exit;=0A=
-	}=0A=
-=0A=
-	mptscsih_initTarget(hd, device->channel, device->id, device->lun,=0A=
-		device->inquiry, device->inquiry_len );=0A=
-	mptscsih_change_queue_depth(device, MPT_SCSI_CMD_PER_DEV_HIGH);=0A=
+	vdevice->configured_lun=3D1;=0A=
+	lun_index =3D (vdevice->lun >> 5);  /* 32 luns per lun_index */=0A=
+	indexed_lun =3D (vdevice->lun % 32);=0A=
+	vtarget->luns[lun_index] |=3D (1 << indexed_lun);=0A=
+	mptscsih_initTarget(hd, vtarget, sdev->lun, sdev->inquiry,=0A=
+	    sdev->inquiry_len );=0A=
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);=0A=
 =0A=
 	dsprintk((MYIOC_s_INFO_FMT=0A=
 		"Queue depth=3D%d, tflags=3D%x\n",=0A=
-		hd->ioc->name, device->queue_depth, pTarget->tflags));=0A=
+		hd->ioc->name, sdev->queue_depth, vtarget->tflags));=0A=
 =0A=
-	dsprintk((MYIOC_s_INFO_FMT=0A=
-		"negoFlags=3D%x, maxOffset=3D%x, SyncFactor=3D%x\n",=0A=
-		hd->ioc->name, pTarget->negoFlags, pTarget->maxOffset, =
pTarget->minSyncFactor));=0A=
+	if (hd->ioc->bus_type =3D=3D SPI)=0A=
+		dsprintk((MYIOC_s_INFO_FMT=0A=
+		    "negoFlags=3D%x, maxOffset=3D%x, SyncFactor=3D%x\n",=0A=
+		    hd->ioc->name, vtarget->negoFlags, vtarget->maxOffset,=0A=
+		    vtarget->minSyncFactor));=0A=
 =0A=
 slave_configure_exit:=0A=
 =0A=
 	dsprintk((MYIOC_s_INFO_FMT=0A=
 		"tagged %d, simple %d, ordered %d\n",=0A=
-		hd->ioc->name,device->tagged_supported, device->simple_tags,=0A=
-		device->ordered_tags));=0A=
+		hd->ioc->name,sdev->tagged_supported, sdev->simple_tags,=0A=
+		sdev->ordered_tags));=0A=
 =0A=
 	return 0;=0A=
 }=0A=
@@ -2372,16 +2401,14 @@=0A=
 static void=0A=
 mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, =
MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)=0A=
 {=0A=
-	VirtDevice	*target;=0A=
+	VirtDevice	*vdev;=0A=
 	SCSIIORequest_t	*pReq;=0A=
 	u32		 sense_count =3D le32_to_cpu(pScsiReply->SenseCount);=0A=
-	int		 index;=0A=
 =0A=
 	/* Get target structure=0A=
 	 */=0A=
 	pReq =3D (SCSIIORequest_t *) mf;=0A=
-	index =3D (int) pReq->TargetID;=0A=
-	target =3D hd->Targets[index];=0A=
+	vdev =3D sc->device->hostdata;=0A=
 =0A=
 	if (sense_count) {=0A=
 		u8 *sense_data;=0A=
@@ -2395,7 +2422,7 @@=0A=
 		/* Log SMART data (asc =3D 0x5D, non-IM case only) if required.=0A=
 		 */=0A=
 		if ((hd->ioc->events) && (hd->ioc->eventTypes & (1 << =
MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE))) {=0A=
-			if ((sense_data[12] =3D=3D 0x5D) && (target->raidVolume =3D=3D 0)) =
{=0A=
+			if ((sense_data[12] =3D=3D 0x5D) && (vdev->vtarget->raidVolume =
=3D=3D 0)) {=0A=
 				int idx;=0A=
 				MPT_ADAPTER *ioc =3D hd->ioc;=0A=
 =0A=
@@ -2405,7 +2432,7 @@=0A=
 =0A=
 				ioc->events[idx].data[0] =3D (pReq->LUN[1] << 24) ||=0A=
 					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||=0A=
-					(pReq->Bus << 8) || pReq->TargetID;=0A=
+					(sc->device->channel << 8) || sc->device->id;=0A=
 =0A=
 				ioc->events[idx].data[1] =3D (sense_data[13] << 8) || =
sense_data[12];=0A=
 =0A=
@@ -2507,7 +2534,7 @@=0A=
 =0A=
 		/* 4. Renegotiate to all devices, if SCSI=0A=
 		 */=0A=
-		if (ioc->bus_type =3D=3D SCSI) {=0A=
+		if (ioc->bus_type =3D=3D SPI) {=0A=
 			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));=0A=
 			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | =
MPT_SCSICFG_USE_NVRAM);=0A=
 		}=0A=
@@ -2536,7 +2563,7 @@=0A=
 =0A=
 		/* 7. Set flag to force DV and re-read IOC Page 3=0A=
 		 */=0A=
-		if (ioc->bus_type =3D=3D SCSI) {=0A=
+		if (ioc->bus_type =3D=3D SPI) {=0A=
 			ioc->spi_data.forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 			ddvtprintk(("Set reload IOC Pg3 Flag\n"));=0A=
 		}=0A=
@@ -2578,7 +2605,7 @@=0A=
 		break;=0A=
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */=0A=
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */=0A=
-		if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->soft_resets < -1))=0A=
+		if (hd && (ioc->bus_type =3D=3D SPI) && (hd->soft_resets < -1))=0A=
 			hd->soft_resets++;=0A=
 		break;=0A=
 	case MPI_EVENT_LOGOUT:				/* 09 */=0A=
@@ -2599,11 +2626,11 @@=0A=
 =0A=
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */=0A=
 	{=0A=
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 		pMpiEventDataRaid_t pRaidEventData =3D=0A=
 		    (pMpiEventDataRaid_t) pEvReply->Data;=0A=
-#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 		/* Domain Validation Needed */=0A=
-		if (ioc->bus_type =3D=3D SCSI &&=0A=
+		if (ioc->bus_type =3D=3D SPI &&=0A=
 		    pRaidEventData->ReasonCode =3D=3D=0A=
 		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)=0A=
 			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);=0A=
@@ -2634,8 +2661,7 @@=0A=
 /*=0A=
  *	mptscsih_initTarget - Target, LUN alloc/free functionality.=0A=
  *	@hd: Pointer to MPT_SCSI_HOST structure=0A=
- *	@bus_id: Bus number (?)=0A=
- *	@target_id: SCSI target id=0A=
+ *	@vtarget: per target private data=0A=
  *	@lun: SCSI LUN id=0A=
  *	@data: Pointer to data=0A=
  *	@dlen: Number of INQUIRY bytes=0A=
@@ -2648,15 +2674,14 @@=0A=
  *=0A=
  */=0A=
 static void=0A=
-mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 =
lun, char *data, int dlen)=0A=
+mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, u8 lun, =
char *data, int dlen)=0A=
 {=0A=
-	int		indexed_lun, lun_index;=0A=
-	VirtDevice	*vdev;=0A=
 	SpiCfgData	*pSpi;=0A=
 	char		data_56;=0A=
+	int		inq_len;=0A=
 =0A=
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=3D%d id=3D%d lun=3D%d =
hd=3D%p\n",=0A=
-			hd->ioc->name, bus_id, target_id, lun, hd));=0A=
+		hd->ioc->name, vtarget->bus_id, vtarget->target_id, lun, hd));=0A=
 =0A=
 	/*=0A=
 	 * If the peripheral qualifier filter is enabled then if the target =
reports a 0x1=0A=
@@ -2676,75 +2701,68 @@=0A=
 	if (data[0] & 0xe0)=0A=
 		return;=0A=
 =0A=
-	if ((vdev =3D hd->Targets[target_id]) =3D=3D NULL) {=0A=
+	if (vtarget =3D=3D NULL)=0A=
 		return;=0A=
-	}=0A=
 =0A=
-	lun_index =3D (lun >> 5);  /* 32 luns per lun_index */=0A=
-	indexed_lun =3D (lun % 32);=0A=
-	vdev->luns[lun_index] |=3D (1 << indexed_lun);=0A=
-=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if ((data[0] =3D=3D TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) =
{=0A=
-			/* Treat all Processors as SAF-TE if=0A=
-			 * command line option is set */=0A=
-			vdev->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;=0A=
-			mptscsih_writeIOCPage4(hd, target_id, bus_id);=0A=
-		}else if ((data[0] =3D=3D TYPE_PROCESSOR) &&=0A=
-			!(vdev->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {=0A=
-			if ( dlen > 49 ) {=0A=
-				vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
-				if ( data[44] =3D=3D 'S' &&=0A=
-				     data[45] =3D=3D 'A' &&=0A=
-				     data[46] =3D=3D 'F' &&=0A=
-				     data[47] =3D=3D '-' &&=0A=
-				     data[48] =3D=3D 'T' &&=0A=
-				     data[49] =3D=3D 'E' ) {=0A=
-					vdev->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;=0A=
-					mptscsih_writeIOCPage4(hd, target_id, bus_id);=0A=
-				}=0A=
+	if (data)=0A=
+		vtarget->type =3D data[0];=0A=
+=0A=
+	if (hd->ioc->bus_type !=3D SPI)=0A=
+		return;=0A=
+=0A=
+	if ((data[0] =3D=3D TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) =
{=0A=
+		/* Treat all Processors as SAF-TE if=0A=
+		 * command line option is set */=0A=
+		vtarget->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;=0A=
+		mptscsih_writeIOCPage4(hd, vtarget->target_id, vtarget->bus_id);=0A=
+	}else if ((data[0] =3D=3D TYPE_PROCESSOR) &&=0A=
+		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {=0A=
+		if ( dlen > 49 ) {=0A=
+			vtarget->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
+			if ( data[44] =3D=3D 'S' &&=0A=
+			     data[45] =3D=3D 'A' &&=0A=
+			     data[46] =3D=3D 'F' &&=0A=
+			     data[47] =3D=3D '-' &&=0A=
+			     data[48] =3D=3D 'T' &&=0A=
+			     data[49] =3D=3D 'E' ) {=0A=
+				vtarget->tflags |=3D MPT_TARGET_FLAGS_SAF_TE_ISSUED;=0A=
+				mptscsih_writeIOCPage4(hd, vtarget->target_id, =
vtarget->bus_id);=0A=
 			}=0A=
 		}=0A=
-		if (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {=0A=
-			if ( dlen > 8 ) {=0A=
-				memcpy (vdev->inq_data, data, 8);=0A=
-			} else {=0A=
-				memcpy (vdev->inq_data, data, dlen);=0A=
-			}=0A=
-=0A=
-			/* If have not done DV, set the DV flag.=0A=
+	}=0A=
+	if (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY)) {=0A=
+		inq_len =3D dlen < 8 ? dlen : 8;=0A=
+		memcpy (vtarget->inq_data, data, inq_len);=0A=
+		/* If have not done DV, set the DV flag.=0A=
+		 */=0A=
+		pSpi =3D &hd->ioc->spi_data;=0A=
+		if ((data[0] =3D=3D TYPE_TAPE) || (data[0] =3D=3D TYPE_PROCESSOR)) =
{=0A=
+			if (pSpi->dvStatus[vtarget->target_id] & =
MPT_SCSICFG_DV_NOT_DONE)=0A=
+				pSpi->dvStatus[vtarget->target_id] |=3D MPT_SCSICFG_NEED_DV;=0A=
+		}=0A=
+		vtarget->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
+=0A=
+		data_56 =3D 0x0F;  /* Default to full capabilities if Inq data =
length is < 57 */=0A=
+		if (dlen > 56) {=0A=
+			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {=0A=
+			/* Update the target capabilities=0A=
 			 */=0A=
-			pSpi =3D &hd->ioc->spi_data;=0A=
-			if ((data[0] =3D=3D TYPE_TAPE) || (data[0] =3D=3D TYPE_PROCESSOR)) =
{=0A=
-				if (pSpi->dvStatus[target_id] & MPT_SCSICFG_DV_NOT_DONE)=0A=
-					pSpi->dvStatus[target_id] |=3D MPT_SCSICFG_NEED_DV;=0A=
-			}=0A=
-=0A=
-			vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
-=0A=
-=0A=
-			data_56 =3D 0x0F;  /* Default to full capabilities if Inq data =
length is < 57 */=0A=
-			if (dlen > 56) {=0A=
-				if ( (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {=0A=
-				/* Update the target capabilities=0A=
-				 */=0A=
-					data_56 =3D data[56];=0A=
-					vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_56;=0A=
-				}=0A=
+				data_56 =3D data[56];=0A=
+				vtarget->tflags |=3D MPT_TARGET_FLAGS_VALID_56;=0A=
 			}=0A=
-			mptscsih_setTargetNegoParms(hd, vdev, data_56);=0A=
-		} else {=0A=
-			/* Initial Inquiry may not request enough data bytes to=0A=
-			 * obtain byte 57.  DV will; if target doesn't return=0A=
-			 * at least 57 bytes, data[56] will be zero. */=0A=
-			if (dlen > 56) {=0A=
-				if ( (!(vdev->tflags & MPT_TARGET_FLAGS_VALID_56))) {=0A=
-				/* Update the target capabilities=0A=
-				 */=0A=
-					data_56 =3D data[56];=0A=
-					vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_56;=0A=
-					mptscsih_setTargetNegoParms(hd, vdev, data_56);=0A=
-				}=0A=
+		}=0A=
+		mptscsih_setTargetNegoParms(hd, vtarget, data_56);=0A=
+	} else {=0A=
+		/* Initial Inquiry may not request enough data bytes to=0A=
+		 * obtain byte 57.  DV will; if target doesn't return=0A=
+		 * at least 57 bytes, data[56] will be zero. */=0A=
+		if (dlen > 56) {=0A=
+			if ( (!(vtarget->tflags & MPT_TARGET_FLAGS_VALID_56))) {=0A=
+			/* Update the target capabilities=0A=
+			 */=0A=
+				data_56 =3D data[56];=0A=
+				vtarget->tflags |=3D MPT_TARGET_FLAGS_VALID_56;=0A=
+				mptscsih_setTargetNegoParms(hd, vtarget, data_56);=0A=
 			}=0A=
 		}=0A=
 	}=0A=
@@ -2757,12 +2775,12 @@=0A=
  *=0A=
  */=0A=
 static void=0A=
-mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, =
char byte56)=0A=
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target, =
char byte56)=0A=
 {=0A=
 	SpiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
 	int  id =3D (int) target->target_id;=0A=
 	int  nvram;=0A=
-	VirtDevice	*vdev;=0A=
+	VirtTarget	*vtarget;=0A=
 	int ii;=0A=
 	u8 width =3D MPT_NARROW;=0A=
 	u8 factor =3D MPT_ASYNC;=0A=
@@ -2907,9 +2925,9 @@=0A=
 =0A=
 			ddvtprintk((KERN_INFO "Disabling QAS due to noQas=3D%02x on =
id=3D%d!\n", noQas, id));=0A=
 			for (ii =3D 0; ii < id; ii++) {=0A=
-				if ( (vdev =3D hd->Targets[ii]) ) {=0A=
-					vdev->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;=0A=
-					mptscsih_writeSDP1(hd, 0, ii, vdev->negoFlags);=0A=
+				if ( (vtarget =3D hd->Targets[ii]) ) {=0A=
+					vtarget->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;=0A=
+					mptscsih_writeSDP1(hd, 0, ii, vtarget->negoFlags);=0A=
 				}=0A=
 			}=0A=
 		}=0A=
@@ -2928,105 +2946,17 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/* If DV disabled (negoNvram set to USE_NVARM) or if not LUN 0, =
return.=0A=
- * Else set the NEED_DV flag after Read Capacity Issued (disks)=0A=
- * or Mode Sense (cdroms).=0A=
- *=0A=
- * Tapes, initTarget will set this flag on completion of Inquiry =
command.=0A=
- * Called only if DV_NOT_DONE flag is set=0A=
- */=0A=
-static void=0A=
-mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)=0A=
-{=0A=
-	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
-	u8 cmd;=0A=
-	SpiCfgData	*pSpi;=0A=
-=0A=
-	ddvtprintk((MYIOC_s_NOTE_FMT=0A=
-		" set_dvflags: id=3D%d lun=3D%d negoNvram=3D%x cmd=3D%x\n",=0A=
-		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, =
pReq->CDB[0]));=0A=
-=0A=
-	if ((pReq->LUN[1] !=3D 0) || (hd->negoNvram !=3D 0))=0A=
-		return;=0A=
-=0A=
-	cmd =3D pReq->CDB[0];=0A=
-=0A=
-	if ((cmd =3D=3D READ_CAPACITY) || (cmd =3D=3D MODE_SENSE)) {=0A=
-		pSpi =3D &ioc->spi_data;=0A=
-		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && =
ioc->raid_data.pIocPg3) {=0A=
-			/* Set NEED_DV for all hidden disks=0A=
-			 */=0A=
-			Ioc3PhysDisk_t *pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
-			int		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
-=0A=
-			while (numPDisk) {=0A=
-				pSpi->dvStatus[pPDisk->PhysDiskID] |=3D MPT_SCSICFG_NEED_DV;=0A=
-				ddvtprintk(("NEED_DV set for phys disk id %d\n", =
pPDisk->PhysDiskID));=0A=
-				pPDisk++;=0A=
-				numPDisk--;=0A=
-			}=0A=
-		}=0A=
-		pSpi->dvStatus[pReq->TargetID] |=3D MPT_SCSICFG_NEED_DV;=0A=
-		ddvtprintk(("NEED_DV set for visible disk id %d\n", =
pReq->TargetID));=0A=
-	}=0A=
-}=0A=
-=0A=
-/* mptscsih_raid_set_dv_flags()=0A=
- *=0A=
- * New or replaced disk. Set DV flag and schedule DV.=0A=
- */=0A=
-static void=0A=
-mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)=0A=
-{=0A=
-	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
-	SpiCfgData	*pSpi =3D &ioc->spi_data;=0A=
-	Ioc3PhysDisk_t	*pPDisk;=0A=
-	int		 numPDisk;=0A=
-=0A=
-	if (hd->negoNvram !=3D 0)=0A=
-		return;=0A=
-=0A=
-	ddvtprintk(("DV requested for phys disk id %d\n", id));=0A=
-	if (ioc->raid_data.pIocPg3) {=0A=
-		pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
-		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
-		while (numPDisk) {=0A=
-			if (id =3D=3D pPDisk->PhysDiskNum) {=0A=
-				pSpi->dvStatus[pPDisk->PhysDiskID] =3D=0A=
-				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);=0A=
-				pSpi->forceDv =3D MPT_SCSICFG_NEED_DV;=0A=
-				ddvtprintk(("NEED_DV set for phys disk id %d\n",=0A=
-				    pPDisk->PhysDiskID));=0A=
-				break;=0A=
-			}=0A=
-			pPDisk++;=0A=
-			numPDisk--;=0A=
-		}=0A=
-=0A=
-		if (numPDisk =3D=3D 0) {=0A=
-			/* The physical disk that needs DV was not found=0A=
-			 * in the stored IOC Page 3. The driver must reload=0A=
-			 * this page. DV routine will set the NEED_DV flag for=0A=
-			 * all phys disks that have DV_NOT_DONE set.=0A=
-			 */=0A=
-			pSpi->forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
-			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 =
Flag\n",id));=0A=
-		}=0A=
-	}=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  * If no Target, bus reset on 1st I/O. Set the flag to=0A=
  * prevent any future negotiations to this device.=0A=
  */=0A=
 static void=0A=
-mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id)=0A=
+mptscsih_no_negotiate(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)=0A=
 {=0A=
+	VirtDevice	*vdev;=0A=
 =0A=
-	if ((hd->Targets) && (hd->Targets[target_id] =3D=3D NULL))=0A=
-		hd->ioc->spi_data.dvStatus[target_id] |=3D MPT_SCSICFG_BLK_NEGO;=0A=
-=0A=
+	if ((vdev =3D sc->device->hostdata) !=3D NULL)=0A=
+		hd->ioc->spi_data.dvStatus[vdev->target_id] |=3D =
MPT_SCSICFG_BLK_NEGO;=0A=
 	return;=0A=
 }=0A=
 =0A=
@@ -3102,7 +3032,7 @@=0A=
 	MPT_ADAPTER		*ioc =3D hd->ioc;=0A=
 	Config_t		*pReq;=0A=
 	SCSIDevicePage1_t	*pData;=0A=
-	VirtDevice		*pTarget=3DNULL;=0A=
+	VirtTarget		*vtarget=3DNULL;=0A=
 	MPT_FRAME_HDR		*mf;=0A=
 	dma_addr_t		 dataDma;=0A=
 	u16			 req_idx;=0A=
@@ -3182,11 +3112,11 @@=0A=
 		/* If id is not a raid volume, get the updated=0A=
 		 * transmission settings from the target structure.=0A=
 		 */=0A=
-		if (hd->Targets && (pTarget =3D hd->Targets[id]) && =
!pTarget->raidVolume) {=0A=
-			width =3D pTarget->maxWidth;=0A=
-			factor =3D pTarget->minSyncFactor;=0A=
-			offset =3D pTarget->maxOffset;=0A=
-			negoFlags =3D pTarget->negoFlags;=0A=
+		if (hd->Targets && (vtarget =3D hd->Targets[id]) && =
!vtarget->raidVolume) {=0A=
+			width =3D vtarget->maxWidth;=0A=
+			factor =3D vtarget->minSyncFactor;=0A=
+			offset =3D vtarget->maxOffset;=0A=
+			negoFlags =3D vtarget->negoFlags;=0A=
 		}=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
@@ -3906,149 +3836,139 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
- *	mptscsih_synchronize_cache - Send SYNCHRONIZE_CACHE to all =
disks.=0A=
- *	@hd: Pointer to MPT_SCSI_HOST structure=0A=
- *	@portnum: IOC port number=0A=
+ *	mptscsih_negotiate_to_asyn_narrow - Restore devices to default =
state=0A=
+ *	@hd: Pointer to a SCSI HOST structure=0A=
+ *	@vtarget: per device private data=0A=
  *=0A=
  *	Uses the ISR, but with special processing.=0A=
  *	MUST be single-threaded.=0A=
  *=0A=
- *	Return: 0 on completion=0A=
  */=0A=
-static int=0A=
-mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum)=0A=
+static void=0A=
+mptscsih_negotiate_to_asyn_narrow(MPT_SCSI_HOST *hd, VirtTarget =
*vtarget)=0A=
 {=0A=
 	MPT_ADAPTER		*ioc=3D hd->ioc;=0A=
-	VirtDevice		*pTarget;=0A=
-	SCSIDevicePage1_t	*pcfg1Data =3D NULL;=0A=
-	INTERNAL_CMD		 iocmd;=0A=
+	SCSIDevicePage1_t	*pcfg1Data;=0A=
 	CONFIGPARMS		 cfg;=0A=
-	dma_addr_t		 cfg1_dma_addr =3D -1;=0A=
-	ConfigPageHeader_t	 header1;=0A=
-	int			 bus =3D 0;=0A=
-	int			 id =3D 0;=0A=
-	int			 lun;=0A=
-	int			 indexed_lun, lun_index;=0A=
-	int			 hostId =3D ioc->pfacts[portnum].PortSCSIID;=0A=
-	int			 max_id;=0A=
-	int			 requested, configuration, data;=0A=
-	int			 doConfig =3D 0;=0A=
+	dma_addr_t		 cfg1_dma_addr;=0A=
+	ConfigPageHeader_t	 header;=0A=
+	int			 id;=0A=
+	int			 requested, configuration, data,i;=0A=
 	u8			 flags, factor;=0A=
 =0A=
-	max_id =3D ioc->sh->max_id - 1;=0A=
-=0A=
-	/* Following parameters will not change=0A=
-	 * in this routine.=0A=
-	 */=0A=
-	iocmd.cmd =3D SYNCHRONIZE_CACHE;=0A=
-	iocmd.flags =3D 0;=0A=
-	iocmd.physDiskNum =3D -1;=0A=
-	iocmd.data =3D NULL;=0A=
-	iocmd.data_dma =3D -1;=0A=
-	iocmd.size =3D 0;=0A=
-	iocmd.rsvd =3D iocmd.rsvd2 =3D 0;=0A=
-=0A=
-	/* No SCSI hosts=0A=
-	 */=0A=
-	if (hd->Targets =3D=3D NULL)=0A=
-		return 0;=0A=
-=0A=
-	/* Skip the host=0A=
-	 */=0A=
-	if (id =3D=3D hostId)=0A=
-		id++;=0A=
-=0A=
-	/* Write SDP1 for all SCSI devices=0A=
-	 * Alloc memory and set up config buffer=0A=
-	 */=0A=
-	if (ioc->bus_type =3D=3D SCSI) {=0A=
-		if (ioc->spi_data.sdp1length > 0) {=0A=
-			pcfg1Data =3D (SCSIDevicePage1_t =
*)pci_alloc_consistent(ioc->pcidev,=0A=
-					 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);=0A=
-=0A=
-			if (pcfg1Data !=3D NULL) {=0A=
-				doConfig =3D 1;=0A=
-				header1.PageVersion =3D ioc->spi_data.sdp1version;=0A=
-				header1.PageLength =3D ioc->spi_data.sdp1length;=0A=
-				header1.PageNumber =3D 1;=0A=
-				header1.PageType =3D MPI_CONFIG_PAGETYPE_SCSI_DEVICE;=0A=
-				cfg.cfghdr.hdr =3D &header1;=0A=
-				cfg.physAddr =3D cfg1_dma_addr;=0A=
-				cfg.action =3D MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;=0A=
-				cfg.dir =3D 1;=0A=
-				cfg.timeout =3D 0;=0A=
-			}=0A=
-		}=0A=
-	}=0A=
+	if (ioc->bus_type !=3D SPI)=0A=
+		return;=0A=
 =0A=
-	/* loop through all devices on this port=0A=
-	 */=0A=
-	while (bus < MPT_MAX_BUS) {=0A=
-		iocmd.bus =3D bus;=0A=
-		iocmd.id =3D id;=0A=
-		pTarget =3D hd->Targets[(int)id];=0A=
+	if (!ioc->spi_data.sdp1length)=0A=
+		return;=0A=
 =0A=
-		if (doConfig) {=0A=
+	pcfg1Data =3D (SCSIDevicePage1_t =
*)pci_alloc_consistent(ioc->pcidev,=0A=
+		 ioc->spi_data.sdp1length * 4, &cfg1_dma_addr);=0A=
 =0A=
-			/* Set the negotiation flags */=0A=
-			if (pTarget && (pTarget =3D hd->Targets[id]) && =
!pTarget->raidVolume) {=0A=
-				flags =3D pTarget->negoFlags;=0A=
-			} else {=0A=
-				flags =3D hd->ioc->spi_data.noQas;=0A=
-				if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] !=3D =
MPT_HOST_NVRAM_INVALID)) {=0A=
-					data =3D hd->ioc->spi_data.nvram[id];=0A=
+	if (pcfg1Data =3D=3D NULL)=0A=
+		return;=0A=
 =0A=
-					if (data & MPT_NVRAM_WIDE_DISABLE)=0A=
-						flags |=3D MPT_TARGET_NO_NEGO_WIDE;=0A=
+	header.PageVersion =3D ioc->spi_data.sdp1version;=0A=
+	header.PageLength =3D ioc->spi_data.sdp1length;=0A=
+	header.PageNumber =3D 1;=0A=
+	header.PageType =3D MPI_CONFIG_PAGETYPE_SCSI_DEVICE;=0A=
+	cfg.cfghdr.hdr =3D &header;=0A=
+	cfg.physAddr =3D cfg1_dma_addr;=0A=
+	cfg.action =3D MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;=0A=
+	cfg.dir =3D 1;=0A=
+	cfg.timeout =3D 0;=0A=
 =0A=
-					factor =3D (data & MPT_NVRAM_SYNC_MASK) >> =
MPT_NVRAM_SYNC_SHIFT;=0A=
-					if ((factor =3D=3D 0) || (factor =3D=3D MPT_ASYNC))=0A=
-						flags |=3D MPT_TARGET_NO_NEGO_SYNC;=0A=
-				}=0A=
+	if (vtarget->raidVolume && ioc->raid_data.pIocPg3) {=0A=
+		for (i =3D 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {=0A=
+			id =3D ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID;=0A=
+			flags =3D hd->ioc->spi_data.noQas;=0A=
+			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] !=3D =
MPT_HOST_NVRAM_INVALID)) {=0A=
+				data =3D hd->ioc->spi_data.nvram[id];=0A=
+				if (data & MPT_NVRAM_WIDE_DISABLE)=0A=
+					flags |=3D MPT_TARGET_NO_NEGO_WIDE;=0A=
+				factor =3D (data & MPT_NVRAM_SYNC_MASK) >> =
MPT_NVRAM_SYNC_SHIFT;=0A=
+				if ((factor =3D=3D 0) || (factor =3D=3D MPT_ASYNC))=0A=
+					flags |=3D MPT_TARGET_NO_NEGO_SYNC;=0A=
 			}=0A=
-=0A=
-			/* Force to async, narrow */=0A=
 			mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,=0A=
-					&configuration, flags);=0A=
+				&configuration, flags);=0A=
 			dnegoprintk(("syncronize cache: id=3D%d width=3D0 =
factor=3DMPT_ASYNC "=0A=
 				"offset=3D0 negoFlags=3D%x request=3D%x config=3D%x\n",=0A=
 				id, flags, requested, configuration));=0A=
 			pcfg1Data->RequestedParameters =3D cpu_to_le32(requested);=0A=
 			pcfg1Data->Reserved =3D 0;=0A=
 			pcfg1Data->Configuration =3D cpu_to_le32(configuration);=0A=
-			cfg.pageAddr =3D (bus<<8) | id;=0A=
+			cfg.pageAddr =3D (vtarget->bus_id<<8) | id;=0A=
 			mpt_config(hd->ioc, &cfg);=0A=
 		}=0A=
+	} else {=0A=
+		flags =3D vtarget->negoFlags;=0A=
+		mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0, &requested,=0A=
+				&configuration, flags);=0A=
+		dnegoprintk(("syncronize cache: id=3D%d width=3D0 factor=3DMPT_ASYNC =
"=0A=
+			"offset=3D0 negoFlags=3D%x request=3D%x config=3D%x\n",=0A=
+			vtarget->target_id, flags, requested, configuration));=0A=
+		pcfg1Data->RequestedParameters =3D cpu_to_le32(requested);=0A=
+		pcfg1Data->Reserved =3D 0;=0A=
+		pcfg1Data->Configuration =3D cpu_to_le32(configuration);=0A=
+		cfg.pageAddr =3D (vtarget->bus_id<<8) | vtarget->target_id;=0A=
+		mpt_config(hd->ioc, &cfg);=0A=
+	}=0A=
 =0A=
-		/* If target Ptr NULL or if this target is NOT a disk, skip.=0A=
-		 */=0A=
-		if ((pTarget) && (pTarget->inq_data[0] =3D=3D TYPE_DISK)){=0A=
-			for (lun=3D0; lun <=3D MPT_LAST_LUN; lun++) {=0A=
-				/* If LUN present, issue the command=0A=
-				 */=0A=
-				lun_index =3D (lun >> 5);  /* 32 luns per lun_index */=0A=
-				indexed_lun =3D (lun % 32);=0A=
-				if (pTarget->luns[lun_index] & (1<<indexed_lun)) {=0A=
-					iocmd.lun =3D lun;=0A=
-					(void) mptscsih_do_cmd(hd, &iocmd);=0A=
-				}=0A=
-			}=0A=
-		}=0A=
+	if (pcfg1Data)=0A=
+		pci_free_consistent(ioc->pcidev, header.PageLength * 4, pcfg1Data, =
cfg1_dma_addr);=0A=
+}=0A=
 =0A=
-		/* get next relevant device */=0A=
-		id++;=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/**=0A=
+ *	mptscsih_synchronize_cache - Send SYNCHRONIZE_CACHE to all =
disks.=0A=
+ *	@hd: Pointer to a SCSI HOST structure=0A=
+ *	@vtarget: per device private data=0A=
+ *	@lun: lun=0A=
+ *=0A=
+ *	Uses the ISR, but with special processing.=0A=
+ *	MUST be single-threaded.=0A=
+ *=0A=
+ */=0A=
+static void=0A=
+mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice)=0A=
+{=0A=
+	INTERNAL_CMD		 iocmd;=0A=
 =0A=
-		if (id =3D=3D hostId)=0A=
-			id++;=0A=
+	/* Following parameters will not change=0A=
+	 * in this routine.=0A=
+	 */=0A=
+	iocmd.cmd =3D SYNCHRONIZE_CACHE;=0A=
+	iocmd.flags =3D 0;=0A=
+	iocmd.physDiskNum =3D -1;=0A=
+	iocmd.data =3D NULL;=0A=
+	iocmd.data_dma =3D -1;=0A=
+	iocmd.size =3D 0;=0A=
+	iocmd.rsvd =3D iocmd.rsvd2 =3D 0;=0A=
+	iocmd.bus =3D vdevice->bus_id;=0A=
+	iocmd.id =3D vdevice->target_id;=0A=
+	iocmd.lun =3D (u8)vdevice->lun;=0A=
+=0A=
+	if ((vdevice->vtarget->type & TYPE_DISK) && =0A=
+	    (vdevice->configured_lun))=0A=
+		mptscsih_do_cmd(hd, &iocmd);=0A=
+}=0A=
 =0A=
-		if (id > max_id) {=0A=
-			id =3D 0;=0A=
-			bus++;=0A=
-		}=0A=
-	}=0A=
+/* Search IOC page 3 to determine if this is hidden physical disk=0A=
+ */=0A=
+/* Search IOC page 3 to determine if this is hidden physical disk=0A=
+ */=0A=
+static int=0A=
+mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)=0A=
+{=0A=
+	int i;=0A=
+=0A=
+	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)=0A=
+		return 0;=0A=
 =0A=
-	if (pcfg1Data) {=0A=
-		pci_free_consistent(ioc->pcidev, header1.PageLength * 4, pcfg1Data, =
cfg1_dma_addr);=0A=
+	for (i =3D 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {=0A=
+		if (id =3D=3D ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)=0A=
+			return 1;=0A=
 	}=0A=
 =0A=
 	return 0;=0A=
@@ -4103,8 +4023,8 @@=0A=
 =0A=
 			msleep(250);=0A=
 =0A=
-			/* DV only to SCSI adapters */=0A=
-			if (ioc->bus_type !=3D SCSI)=0A=
+			/* DV only to SPI adapters */=0A=
+			if (ioc->bus_type !=3D SPI)=0A=
 				continue;=0A=
 =0A=
 			/* Make sure everything looks ok */=0A=
@@ -4197,32 +4117,12 @@=0A=
 	return;=0A=
 }=0A=
 =0A=
-/* Search IOC page 3 to determine if this is hidden physical disk=0A=
- */=0A=
-/* Search IOC page 3 to determine if this is hidden physical disk=0A=
- */=0A=
-static int=0A=
-mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)=0A=
-{=0A=
-	int i;=0A=
-=0A=
-	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)=0A=
-		return 0;=0A=
-=0A=
-	for (i =3D 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {=0A=
-		if (id =3D=3D ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)=0A=
-			return 1;=0A=
-	}=0A=
-=0A=
-	return 0;=0A=
-}=0A=
-=0A=
 /* Write SDP1 if no QAS has been enabled=0A=
  */=0A=
 static void=0A=
 mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)=0A=
 {=0A=
-	VirtDevice *pTarget;=0A=
+	VirtTarget *vtarget;=0A=
 	int ii;=0A=
 =0A=
 	if (hd->Targets =3D=3D NULL)=0A=
@@ -4235,11 +4135,11 @@=0A=
 		if ((hd->ioc->spi_data.dvStatus[ii] & MPT_SCSICFG_DV_NOT_DONE) !=3D =
0)=0A=
 			continue;=0A=
 =0A=
-		pTarget =3D hd->Targets[ii];=0A=
+		vtarget =3D hd->Targets[ii];=0A=
 =0A=
-		if ((pTarget !=3D NULL) && (!pTarget->raidVolume)) {=0A=
-			if ((pTarget->negoFlags & hd->ioc->spi_data.noQas) =3D=3D 0) {=0A=
-				pTarget->negoFlags |=3D hd->ioc->spi_data.noQas;=0A=
+		if ((vtarget !=3D NULL) && (!vtarget->raidVolume)) {=0A=
+			if ((vtarget->negoFlags & hd->ioc->spi_data.noQas) =3D=3D 0) {=0A=
+				vtarget->negoFlags |=3D hd->ioc->spi_data.noQas;=0A=
 				dnegoprintk(("writeSDP1: id=3D%d flags=3D0\n", id));=0A=
 				mptscsih_writeSDP1(hd, 0, ii, 0);=0A=
 			}=0A=
@@ -4279,7 +4179,7 @@=0A=
 mptscsih_doDv(MPT_SCSI_HOST *hd, int bus_number, int id)=0A=
 {=0A=
 	MPT_ADAPTER		*ioc =3D hd->ioc;=0A=
-	VirtDevice		*pTarget;=0A=
+	VirtTarget		*vtarget;=0A=
 	SCSIDevicePage1_t	*pcfg1Data;=0A=
 	SCSIDevicePage0_t	*pcfg0Data;=0A=
 	u8			*pbuf1;=0A=
@@ -4350,12 +4250,12 @@=0A=
 	iocmd.physDiskNum =3D -1;=0A=
 	iocmd.rsvd =3D iocmd.rsvd2 =3D 0;=0A=
 =0A=
-	pTarget =3D hd->Targets[id];=0A=
+	vtarget =3D hd->Targets[id];=0A=
 =0A=
 	/* Use tagged commands if possible.=0A=
 	 */=0A=
-	if (pTarget) {=0A=
-		if (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
+	if (vtarget) {=0A=
+		if (vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)=0A=
 			iocmd.flags |=3D MPT_ICFLAG_TAGGED_CMD;=0A=
 		else {=0A=
 			if (hd->ioc->facts.FWVersion.Word < 0x01000600)=0A=
@@ -4571,7 +4471,7 @@=0A=
 		/* Reset the size for disks=0A=
 		 */=0A=
 		inq0 =3D (*pbuf1) & 0x1F;=0A=
-		if ((inq0 =3D=3D 0) && pTarget && !pTarget->raidVolume) {=0A=
+		if ((inq0 =3D=3D 0) && vtarget && !vtarget->raidVolume) {=0A=
 			sz =3D 0x40;=0A=
 			iocmd.size =3D sz;=0A=
 		}=0A=
@@ -4581,8 +4481,7 @@=0A=
 		 */=0A=
 		if (inq0 =3D=3D TYPE_PROCESSOR) {=0A=
 			mptscsih_initTarget(hd,=0A=
-				bus,=0A=
-				id,=0A=
+				vtarget,=0A=
 				lun,=0A=
 				pbuf1,=0A=
 				sz);=0A=
@@ -4596,22 +4495,22 @@=0A=
 			goto target_done;=0A=
 =0A=
 		if (sz =3D=3D 0x40) {=0A=
-			if ((pTarget->maxWidth =3D=3D 1) && (pTarget->maxOffset) && =
(nfactor < 0x0A)=0A=
-				&& (pTarget->minSyncFactor > 0x09)) {=0A=
+			if ((vtarget->maxWidth =3D=3D 1) && (vtarget->maxOffset) && =
(nfactor < 0x0A)=0A=
+				&& (vtarget->minSyncFactor > 0x09)) {=0A=
 				if ((pbuf1[56] & 0x04) =3D=3D 0)=0A=
 					;=0A=
 				else if ((pbuf1[56] & 0x01) =3D=3D 1) {=0A=
-					pTarget->minSyncFactor =3D=0A=
+					vtarget->minSyncFactor =3D=0A=
 					    nfactor > MPT_ULTRA320 ? nfactor : MPT_ULTRA320;=0A=
 				} else {=0A=
-					pTarget->minSyncFactor =3D=0A=
+					vtarget->minSyncFactor =3D=0A=
 					    nfactor > MPT_ULTRA160 ? nfactor : MPT_ULTRA160;=0A=
 				}=0A=
 =0A=
-				dv.max.factor =3D pTarget->minSyncFactor;=0A=
+				dv.max.factor =3D vtarget->minSyncFactor;=0A=
 =0A=
 				if ((pbuf1[56] & 0x02) =3D=3D 0) {=0A=
-					pTarget->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;=0A=
+					vtarget->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;=0A=
 					hd->ioc->spi_data.noQas =3D MPT_TARGET_NO_NEGO_QAS;=0A=
 					ddvprintk((MYIOC_s_NOTE_FMT=0A=
 					    "DV: Start Basic noQas on id=3D%d due to =
pbuf1[56]=3D%x\n",=0A=
@@ -4694,8 +4593,7 @@=0A=
 						    "DV:Inquiry compared id=3D%d, calling initTarget\n", =
ioc->name, id));=0A=
 						hd->ioc->spi_data.dvStatus[id] &=3D ~MPT_SCSICFG_DV_NOT_DONE;=0A=
 						mptscsih_initTarget(hd,=0A=
-							bus,=0A=
-							id,=0A=
+							vtarget,=0A=
 							lun,=0A=
 							pbuf1,=0A=
 							sz);=0A=
@@ -5196,7 +5094,7 @@=0A=
 static void=0A=
 mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage)=0A=
 {=0A=
-	VirtDevice		*pTarget;=0A=
+	VirtTarget		*vtarget;=0A=
 	SCSIDevicePage0_t	*pPage0;=0A=
 	SCSIDevicePage1_t	*pPage1;=0A=
 	int			val =3D 0, data, configuration;=0A=
@@ -5216,11 +5114,11 @@=0A=
 		 * already throttled back.=0A=
 		 */=0A=
 		negoFlags =3D hd->ioc->spi_data.noQas;=0A=
-		if ((hd->Targets)&&((pTarget =3D hd->Targets[(int)id]) !=3D NULL) && =
!pTarget->raidVolume) {=0A=
-			width =3D pTarget->maxWidth;=0A=
-			offset =3D pTarget->maxOffset;=0A=
-			factor =3D pTarget->minSyncFactor;=0A=
-			negoFlags |=3D pTarget->negoFlags;=0A=
+		if ((hd->Targets)&&((vtarget =3D hd->Targets[(int)id]) !=3D NULL) && =
!vtarget->raidVolume) {=0A=
+			width =3D vtarget->maxWidth;=0A=
+			offset =3D vtarget->maxOffset;=0A=
+			factor =3D vtarget->minSyncFactor;=0A=
+			negoFlags |=3D vtarget->negoFlags;=0A=
 		} else {=0A=
 			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] !=3D =
MPT_HOST_NVRAM_INVALID)) {=0A=
 				data =3D hd->ioc->spi_data.nvram[id];=0A=
@@ -5422,11 +5320,11 @@=0A=
 		 * or overwrite nvram (phys disks only).=0A=
 		 */=0A=
 =0A=
-		if ((hd->Targets)&&((pTarget =3D hd->Targets[(int)id]) !=3D NULL) && =
!pTarget->raidVolume ) {=0A=
-			pTarget->maxWidth =3D dv->now.width;=0A=
-			pTarget->maxOffset =3D dv->now.offset;=0A=
-			pTarget->minSyncFactor =3D dv->now.factor;=0A=
-			pTarget->negoFlags =3D dv->now.flags;=0A=
+		if ((hd->Targets)&&((vtarget =3D hd->Targets[(int)id]) !=3D NULL) && =
!vtarget->raidVolume ) {=0A=
+			vtarget->maxWidth =3D dv->now.width;=0A=
+			vtarget->maxOffset =3D dv->now.offset;=0A=
+			vtarget->minSyncFactor =3D dv->now.factor;=0A=
+			vtarget->negoFlags =3D dv->now.flags;=0A=
 		} else {=0A=
 			/* Preserv all flags, use=0A=
 			 * read-modify-write algorithm=0A=
@@ -5580,6 +5478,94 @@=0A=
 		break;=0A=
 	}=0A=
 }=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/* If DV disabled (negoNvram set to USE_NVARM) or if not LUN 0, =
return.=0A=
+ * Else set the NEED_DV flag after Read Capacity Issued (disks)=0A=
+ * or Mode Sense (cdroms).=0A=
+ *=0A=
+ * Tapes, initTarget will set this flag on completion of Inquiry =
command.=0A=
+ * Called only if DV_NOT_DONE flag is set=0A=
+ */=0A=
+static void=0A=
+mptscsih_set_dvflags(MPT_SCSI_HOST *hd, struct scsi_cmnd *sc)=0A=
+{=0A=
+	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
+	u8 cmd;=0A=
+	SpiCfgData	*pSpi;=0A=
+=0A=
+	ddvtprintk((MYIOC_s_NOTE_FMT=0A=
+		" set_dvflags: id=3D%d lun=3D%d negoNvram=3D%x cmd=3D%x\n",=0A=
+		hd->ioc->name, sc->device->id, sc->device->lun , hd->negoNvram, =
sc->cmnd[0]));=0A=
+=0A=
+	if ((sc->device->lun !=3D 0) || (hd->negoNvram !=3D 0))=0A=
+		return;=0A=
+=0A=
+	cmd =3D sc->cmnd[0];=0A=
+=0A=
+	if ((cmd =3D=3D READ_CAPACITY) || (cmd =3D=3D MODE_SENSE)) {=0A=
+		pSpi =3D &ioc->spi_data;=0A=
+		if ((ioc->raid_data.isRaid & (1 << sc->device->id)) && =
ioc->raid_data.pIocPg3) {=0A=
+			/* Set NEED_DV for all hidden disks=0A=
+			 */=0A=
+			Ioc3PhysDisk_t *pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
+			int		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
+=0A=
+			while (numPDisk) {=0A=
+				pSpi->dvStatus[pPDisk->PhysDiskID] |=3D MPT_SCSICFG_NEED_DV;=0A=
+				ddvtprintk(("NEED_DV set for phys disk id %d\n", =
pPDisk->PhysDiskID));=0A=
+				pPDisk++;=0A=
+				numPDisk--;=0A=
+			}=0A=
+		}=0A=
+		pSpi->dvStatus[sc->device->id] |=3D MPT_SCSICFG_NEED_DV;=0A=
+		ddvtprintk(("NEED_DV set for visible disk id %d\n", =
sc->device->id));=0A=
+	}=0A=
+}=0A=
+=0A=
+/* mptscsih_raid_set_dv_flags()=0A=
+ *=0A=
+ * New or replaced disk. Set DV flag and schedule DV.=0A=
+ */=0A=
+static void=0A=
+mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)=0A=
+{=0A=
+	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
+	SpiCfgData	*pSpi =3D &ioc->spi_data;=0A=
+	Ioc3PhysDisk_t	*pPDisk;=0A=
+	int		 numPDisk;=0A=
+=0A=
+	if (hd->negoNvram !=3D 0)=0A=
+		return;=0A=
+=0A=
+	ddvtprintk(("DV requested for phys disk id %d\n", id));=0A=
+	if (ioc->raid_data.pIocPg3) {=0A=
+		pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
+		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
+		while (numPDisk) {=0A=
+			if (id =3D=3D pPDisk->PhysDiskNum) {=0A=
+				pSpi->dvStatus[pPDisk->PhysDiskID] =3D=0A=
+				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);=0A=
+				pSpi->forceDv =3D MPT_SCSICFG_NEED_DV;=0A=
+				ddvtprintk(("NEED_DV set for phys disk id %d\n",=0A=
+				    pPDisk->PhysDiskID));=0A=
+				break;=0A=
+			}=0A=
+			pPDisk++;=0A=
+			numPDisk--;=0A=
+		}=0A=
+=0A=
+		if (numPDisk =3D=3D 0) {=0A=
+			/* The physical disk that needs DV was not found=0A=
+			 * in the stored IOC Page 3. The driver must reload=0A=
+			 * this page. DV routine will set the NEED_DV flag for=0A=
+			 * all phys disks that have DV_NOT_DONE set.=0A=
+			 */=0A=
+			pSpi->forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
+			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 =
Flag\n",id));=0A=
+		}=0A=
+	}=0A=
+}=0A=
 #endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */=0A=
 =0A=
 EXPORT_SYMBOL(mptscsih_remove);=0A=
@@ -5591,7 +5577,9 @@=0A=
 EXPORT_SYMBOL(mptscsih_proc_info);=0A=
 EXPORT_SYMBOL(mptscsih_info);=0A=
 EXPORT_SYMBOL(mptscsih_qcmd);=0A=
+EXPORT_SYMBOL(mptscsih_target_alloc);=0A=
 EXPORT_SYMBOL(mptscsih_slave_alloc);=0A=
+EXPORT_SYMBOL(mptscsih_target_destroy);=0A=
 EXPORT_SYMBOL(mptscsih_slave_destroy);=0A=
 EXPORT_SYMBOL(mptscsih_slave_configure);=0A=
 EXPORT_SYMBOL(mptscsih_abort);=0A=
diff -uarN b/drivers/message/fusion/mptscsih.h =
a/drivers/message/fusion/mptscsih.h=0A=
--- b/drivers/message/fusion/mptscsih.h	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.h	2005-11-11 13:52:12.000000000 =
-0700=0A=
@@ -91,7 +91,9 @@=0A=
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, =
char **start, off_t offset, int length, int func);=0A=
 extern const char * mptscsih_info(struct Scsi_Host *SChost);=0A=
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct =
scsi_cmnd *));=0A=
+extern int mptscsih_target_alloc(struct scsi_target *starget);=0A=
 extern int mptscsih_slave_alloc(struct scsi_device *device);=0A=
+extern void mptscsih_target_destroy(struct scsi_target *starget);=0A=
 extern void mptscsih_slave_destroy(struct scsi_device *device);=0A=
 extern int mptscsih_slave_configure(struct scsi_device *device);=0A=
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);=0A=
diff -uarN b/drivers/message/fusion/mptspi.c =
a/drivers/message/fusion/mptspi.c=0A=
--- b/drivers/message/fusion/mptspi.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptspi.c	2005-11-11 10:36:21.000000000 =
-0700=0A=
@@ -103,13 +103,16 @@=0A=
 static int	mptspiInternalCtx =3D -1; /* Used only for internal =
commands */=0A=
 =0A=
 static struct scsi_host_template mptspi_driver_template =3D {=0A=
+	.module				=3D THIS_MODULE,=0A=
 	.proc_name			=3D "mptspi",=0A=
 	.proc_info			=3D mptscsih_proc_info,=0A=
 	.name				=3D "MPT SPI Host",=0A=
 	.info				=3D mptscsih_info,=0A=
 	.queuecommand			=3D mptscsih_qcmd,=0A=
+	.target_alloc			=3D mptscsih_target_alloc,=0A=
 	.slave_alloc			=3D mptscsih_slave_alloc,=0A=
 	.slave_configure		=3D mptscsih_slave_configure,=0A=
+	.target_destroy			=3D mptscsih_target_destroy,=0A=
 	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,=0A=
 	.eh_abort_handler		=3D mptscsih_abort,=0A=
@@ -308,10 +311,10 @@=0A=
 	}=0A=
 =0A=
 	memset(mem, 0, sz);=0A=
-	hd->Targets =3D (VirtDevice **) mem;=0A=
+	hd->Targets =3D (VirtTarget **) mem;=0A=
 =0A=
 	dprintk((KERN_INFO=0A=
-	  "  Targets @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
+	  "  vdev @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
 =0A=
 	/* Clear the TM flags=0A=
 	 */=0A=

------_=_NextPart_000_01C5E71A.4E0D39A8--

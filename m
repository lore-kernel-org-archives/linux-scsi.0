From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: MPT Fusion FC909 support
Date: Thu, 22 Apr 2004 10:55:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570442C904@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C42879.D8803050"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23482 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264101AbUDVOzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 10:55:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C42879.D8803050
Content-Type: text/plain;
	charset="iso-8859-1"

Here is a patch to add FC909 support back.
This will be mpt driver version 3.01.05.

Please apply.

You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.05



On Thursday, April 22, 2004 8:28 AM,  James Bottomley wrote:
> 
> On Thu, 2004-04-22 at 10:23, Moore, Eric Dean wrote:
> > I'm sorry. It was my understanding this card was
> > not being used by anyone, and my manager said it was
> > okay to remove this support. This support was removed to 
> > to honor some request from Jeff Garzik [jgarzik@pobox.com]
> > to clean up the code macro's for accessing the hardware.
> 
> Well, if there's hardware in the field, I think the driver 
> support needs
> to go back in.
> 
> Thanks,
> 
> James
> 
> 


------_=_NextPart_000_01C42879.D8803050
Content-Type: application/octet-stream;
	name="mptlinux-3.01.05.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.05.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2004-04-22 08:38:03.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2004-04-22 08:45:20.192169096 =
-0600=0A=
@@ -223,6 +223,7 @@=0A=
 =0A=
 //int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);=0A=
 static int	ProcessEventNotification(MPT_ADAPTER *ioc, =
EventNotificationReply_t *evReply, int *evHandlers);=0A=
+static void	mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, =
MPT_FRAME_HDR *mf);=0A=
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
 static void	mpt_sp_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
 =0A=
@@ -263,6 +264,8 @@=0A=
  */=0A=
 =0A=
 static struct pci_device_id mptbase_pci_table[] =3D {=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC909,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929,=0A=
 		PCI_ANY_ID, PCI_ANY_ID },=0A=
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919,=0A=
@@ -389,6 +392,12 @@=0A=
 				else=0A=
 					mpt_sp_log_info(ioc, log_info);=0A=
 			}=0A=
+			if (ioc_stat & MPI_IOCSTATUS_MASK) {=0A=
+				if ((int)ioc->chip_type <=3D (int)FC929)=0A=
+						;=0A=
+				else=0A=
+					mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);=0A=
+			}=0A=
 		} else {=0A=
 			/*=0A=
 			 *  Process turbo (context) reply...=0A=
@@ -1350,6 +1359,10 @@=0A=
 	}=0A=
 =0A=
 	ioc->chip_type =3D FCUNK;=0A=
+	if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC909) {=0A=
+		ioc->chip_type =3D FC909;=0A=
+		ioc->prod_name =3D "LSIFC909";=0A=
+	}=0A=
 	if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC929) {=0A=
 		ioc->chip_type =3D FC929;=0A=
 		ioc->prod_name =3D "LSIFC929";=0A=
@@ -6086,12 +6099,156 @@=0A=
 	case 0x00080000:=0A=
 		desc =3D "Outbound DMA Overrun";=0A=
 		break;=0A=
+	=0A=
+	case 0x00090000:=0A=
+		desc =3D "Task Management";=0A=
+		break;=0A=
+=0A=
+	case 0x000A0000:=0A=
+		desc =3D "Device Problem";=0A=
+		break;=0A=
+=0A=
+	case 0x000B0000:=0A=
+		desc =3D "Invalid Phase Change";=0A=
+		break;=0A=
+=0A=
+	case 0x000C0000:=0A=
+		desc =3D "Untagged Table Size";=0A=
+		break;=0A=
+	=0A=
 	}=0A=
 =0A=
 	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): F/W: %s\n", ioc->name, =
log_info, desc);=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+ *	mpt_sp_ioc_info - IOC information returned from SCSI Parallel =
IOC.=0A=
+ *	@ioc: Pointer to MPT_ADAPTER structure=0A=
+ *	@ioc_status: U32 IOCStatus word from IOC=0A=
+ *	@mf: Pointer to MPT request frame=0A=
+ *=0A=
+ *	Refer to lsi/mpi.h.=0A=
+ */=0A=
+static void=0A=
+mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR =
*mf)=0A=
+{=0A=
+	u32 status =3D ioc_status & MPI_IOCSTATUS_MASK;=0A=
+	char *desc =3D "";=0A=
+=0A=
+	switch (status) {=0A=
+	case MPI_IOCSTATUS_INVALID_FUNCTION: /* 0x0001 */=0A=
+		desc =3D "Invalid Function";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_BUSY: /* 0x0002 */=0A=
+		desc =3D "Busy";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_INVALID_SGL: /* 0x0003 */=0A=
+		desc =3D "Invalid SGL";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_INTERNAL_ERROR: /* 0x0004 */=0A=
+		desc =3D "Internal Error";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_RESERVED: /* 0x0005 */=0A=
+		desc =3D "Reserved";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_INSUFFICIENT_RESOURCES: /* 0x0006 */=0A=
+		desc =3D "Insufficient Resources";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_INVALID_FIELD: /* 0x0007 */=0A=
+		desc =3D "Invalid Field";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_INVALID_STATE: /* 0x0008 */=0A=
+		desc =3D "Invalid State";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_CONFIG_INVALID_ACTION: /* 0x0020 */=0A=
+	case MPI_IOCSTATUS_CONFIG_INVALID_TYPE:   /* 0x0021 */=0A=
+	case MPI_IOCSTATUS_CONFIG_INVALID_PAGE:   /* 0x0022 */=0A=
+	case MPI_IOCSTATUS_CONFIG_INVALID_DATA:   /* 0x0023 */=0A=
+	case MPI_IOCSTATUS_CONFIG_NO_DEFAULTS:    /* 0x0024 */=0A=
+	case MPI_IOCSTATUS_CONFIG_CANT_COMMIT:    /* 0x0025 */=0A=
+		/* No message for Config IOCStatus values */=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR: /* 0x0040 */=0A=
+		/* No message for recovered error=0A=
+		desc =3D "SCSI Recovered Error";=0A=
+		*/=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_INVALID_BUS: /* 0x0041 */=0A=
+		desc =3D "SCSI Invalid Bus";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID: /* 0x0042 */=0A=
+		desc =3D "SCSI Invalid TargetID";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE: /* 0x0043 */=0A=
+	  {=0A=
+		SCSIIORequest_t *pScsiReq =3D (SCSIIORequest_t *) mf;=0A=
+		U8 cdb =3D pScsiReq->CDB[0];=0A=
+		if (cdb !=3D 0x12) { /* Inquiry is issued for device scanning */=0A=
+			desc =3D "SCSI Device Not There";=0A=
+		}=0A=
+		break;=0A=
+	  }=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN: /* 0x0044 */=0A=
+		desc =3D "SCSI Data Overrun";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN: /* 0x0045 */=0A=
+		/* This error is checked in scsi_io_done(). Skip. =0A=
+		desc =3D "SCSI Data Underrun";=0A=
+		*/=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR: /* 0x0046 */=0A=
+		desc =3D "SCSI I/O Data Error";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR: /* 0x0047 */=0A=
+		desc =3D "SCSI Protocol Error";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */=0A=
+		desc =3D "SCSI Task Terminated";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH: /* 0x0049 */=0A=
+		desc =3D "SCSI Residual Mismatch";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED: /* 0x004A */=0A=
+		desc =3D "SCSI Task Management Failed";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED: /* 0x004B */=0A=
+		desc =3D "SCSI IOC Terminated";=0A=
+		break;=0A=
+=0A=
+	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED: /* 0x004C */=0A=
+		desc =3D "SCSI Ext Terminated";=0A=
+		break;=0A=
+=0A=
+	default:=0A=
+		desc =3D "Others";=0A=
+		break;=0A=
+	}=0A=
+	if (desc !=3D "")=0A=
+		printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04x): %s\n", ioc->name, =
status, desc);=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mpt_register_ascqops_strings - Register SCSI ASC/ASCQ and SCSI=0A=
  *	OpCode strings from the (optional) isense module.=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-04-22 08:38:03.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-04-22 08:46:29.707601144 =
-0600=0A=
@@ -81,8 +81,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.03"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.03"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.05"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.05"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2004-04-22 08:38:03.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2004-04-13 16:47:46.000000000 =
-0600=0A=
@@ -1199,7 +1199,7 @@=0A=
 mptctl_getiocinfo (unsigned long arg, unsigned int data_size)=0A=
 {=0A=
 	struct mpt_ioctl_iocinfo *uarg =3D (struct mpt_ioctl_iocinfo *) =
arg;=0A=
-	struct mpt_ioctl_iocinfo karg;=0A=
+	struct mpt_ioctl_iocinfo *karg;=0A=
 	MPT_ADAPTER		*ioc;=0A=
 	struct pci_dev		*pdev;=0A=
 	struct Scsi_Host	*sh;=0A=
@@ -1219,34 +1219,46 @@=0A=
 	 */=0A=
 	if (data_size =3D=3D sizeof(struct mpt_ioctl_iocinfo_rev0))=0A=
 		cim_rev =3D 0;=0A=
-	else if (data_size =3D=3D sizeof(struct mpt_ioctl_iocinfo))=0A=
+	else if (data_size =3D=3D sizeof(struct mpt_ioctl_iocinfo_rev1))=0A=
 		cim_rev =3D 1;=0A=
+	else if (data_size =3D=3D sizeof(struct mpt_ioctl_iocinfo))=0A=
+		cim_rev =3D 2;=0A=
 	else if (data_size =3D=3D (sizeof(struct =
mpt_ioctl_iocinfo_rev0)+12))=0A=
 		cim_rev =3D 0;	/* obsolete */=0A=
 	else=0A=
 		return -EFAULT;=0A=
-=0A=
-	if (copy_from_user(&karg, uarg, data_size)) {=0A=
+	=0A=
+	karg =3D kmalloc(data_size, GFP_KERNEL);=0A=
+	if (karg =3D=3D NULL) {=0A=
+		printk(KERN_ERR "%s::mpt_ioctl_iocinfo() @%d - no memory =
available!\n",=0A=
+				__FILE__, __LINE__);=0A=
+		return -ENOMEM;=0A=
+	}=0A=
+		=0A=
+	if (copy_from_user(karg, uarg, data_size)) {=0A=
 		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "=0A=
 			"Unable to read in mpt_ioctl_iocinfo struct @ %p\n",=0A=
 				__FILE__, __LINE__, (void*)uarg);=0A=
+		kfree(karg);=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
-	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) =
||=0A=
+	if (((iocnum =3D mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) =
||=0A=
 	    (ioc =3D=3D NULL)) {=0A=
 		dctlprintk((KERN_ERR "%s::mptctl_getiocinfo() @%d - ioc%d not =
found!\n",=0A=
 				__FILE__, __LINE__, iocnum));=0A=
+		kfree(karg);=0A=
 		return -ENODEV;=0A=
 	}=0A=
 =0A=
 	/* Verify the data transfer size is correct.=0A=
 	 * Ignore the port setting.=0A=
 	 */=0A=
-	if (karg.hdr.maxDataSize !=3D data_size) {=0A=
+	if (karg->hdr.maxDataSize !=3D data_size) {=0A=
 		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "=0A=
 			"Structure size mismatch. Command not completed.\n",=0A=
 				__FILE__, __LINE__);=0A=
+		kfree(karg);=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
@@ -1254,29 +1266,37 @@=0A=
 	 * program=0A=
 	 */=0A=
 	if ((int)ioc->chip_type <=3D (int) FC929)=0A=
-		karg.adapterType =3D MPT_IOCTL_INTERFACE_FC;=0A=
+		karg->adapterType =3D MPT_IOCTL_INTERFACE_FC;=0A=
 	else=0A=
-		karg.adapterType =3D MPT_IOCTL_INTERFACE_SCSI;=0A=
+		karg->adapterType =3D MPT_IOCTL_INTERFACE_SCSI;=0A=
 =0A=
-	port =3D karg.hdr.port;=0A=
+	port =3D karg->hdr.port;=0A=
 =0A=
-	karg.port =3D port;=0A=
+	karg->port =3D port;=0A=
 	pdev =3D (struct pci_dev *) ioc->pcidev;=0A=
 =0A=
-	karg.pciId =3D pdev->device;=0A=
+	karg->pciId =3D pdev->device;=0A=
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);=0A=
-	karg.hwRev =3D revision;=0A=
+	karg->hwRev =3D revision;=0A=
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,0)=0A=
-	karg.subSystemDevice =3D pdev->subsystem_device;=0A=
-	karg.subSystemVendor =3D pdev->subsystem_vendor;=0A=
+	karg->subSystemDevice =3D pdev->subsystem_device;=0A=
+	karg->subSystemVendor =3D pdev->subsystem_vendor;=0A=
 #endif=0A=
 =0A=
 	if (cim_rev =3D=3D 1) {=0A=
 		/* Get the PCI bus, device, and function numbers for the IOC=0A=
 		 */=0A=
-		karg.pciInfo.u.bits.busNumber =3D pdev->bus->number;=0A=
-		karg.pciInfo.u.bits.deviceNumber =3D PCI_SLOT( pdev->devfn );=0A=
-		karg.pciInfo.u.bits.functionNumber =3D PCI_FUNC( pdev->devfn );=0A=
+		karg->pciInfo.u.bits.busNumber =3D pdev->bus->number;=0A=
+		karg->pciInfo.u.bits.deviceNumber =3D PCI_SLOT( pdev->devfn );=0A=
+		karg->pciInfo.u.bits.functionNumber =3D PCI_FUNC( pdev->devfn );=0A=
+	} else if (cim_rev =3D=3D 2) {=0A=
+		/* Get the PCI bus, device, function and segment ID numbers =0A=
+		   for the IOC */=0A=
+		karg->pciInfo.u.bits.busNumber =3D pdev->bus->number;=0A=
+		karg->pciInfo.u.bits.deviceNumber =3D PCI_SLOT( pdev->devfn );=0A=
+		karg->pciInfo.u.bits.functionNumber =3D PCI_FUNC( pdev->devfn );=0A=
+		karg->pciInfo.u.bits.functionNumber =3D PCI_FUNC( pdev->devfn );=0A=
+		karg->pciInfo.segmentID =3D pci_domain_nr(pdev->bus);=0A=
 	}=0A=
 =0A=
 	/* Get number of devices=0A=
@@ -1297,31 +1317,33 @@=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-	karg.numDevices =3D numDevices;=0A=
+	karg->numDevices =3D numDevices;=0A=
 =0A=
 	/* Set the BIOS and FW Version=0A=
 	 */=0A=
-	karg.FWVersion =3D ioc->facts.FWVersion.Word;=0A=
-	karg.BIOSVersion =3D ioc->biosVersion;=0A=
+	karg->FWVersion =3D ioc->facts.FWVersion.Word;=0A=
+	karg->BIOSVersion =3D ioc->biosVersion;=0A=
 =0A=
 	/* Set the Version Strings.=0A=
 	 */=0A=
-	strncpy (karg.driverVersion, MPT_LINUX_PACKAGE_NAME, =
MPT_IOCTL_VERSION_LENGTH);=0A=
-	karg.driverVersion[MPT_IOCTL_VERSION_LENGTH-1]=3D'\0';=0A=
+	strncpy (karg->driverVersion, MPT_LINUX_PACKAGE_NAME, =
MPT_IOCTL_VERSION_LENGTH);=0A=
+	karg->driverVersion[MPT_IOCTL_VERSION_LENGTH-1]=3D'\0';=0A=
 =0A=
-	karg.busChangeEvent =3D 0;=0A=
-	karg.hostId =3D ioc->pfacts[port].PortSCSIID;=0A=
-	karg.rsvd[0] =3D karg.rsvd[1] =3D 0;=0A=
+	karg->busChangeEvent =3D 0;=0A=
+	karg->hostId =3D ioc->pfacts[port].PortSCSIID;=0A=
+	karg->rsvd[0] =3D karg->rsvd[1] =3D 0;=0A=
 =0A=
 	/* Copy the data from kernel memory to user memory=0A=
 	 */=0A=
-	if (copy_to_user((char *)arg, &karg, data_size)) {=0A=
+	if (copy_to_user((char *)arg, karg, data_size)) {=0A=
 		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "=0A=
 			"Unable to write out mpt_ioctl_iocinfo struct @ %p\n",=0A=
 				__FILE__, __LINE__, (void*)uarg);=0A=
+		kfree(karg);=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
+	kfree(karg);=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -2909,6 +2931,8 @@=0A=
 	if (++where && err) goto out_fail;=0A=
 	err =3D register_ioctl32_conversion(MPTIOCINFO1, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
+	err =3D register_ioctl32_conversion(MPTIOCINFO2, =
compat_mptctl_ioctl);=0A=
+	if (++where && err) goto out_fail;=0A=
 	err =3D register_ioctl32_conversion(MPTTARGETINFO, =
compat_mptctl_ioctl);=0A=
 	if (++where && err) goto out_fail;=0A=
 	err =3D register_ioctl32_conversion(MPTTEST, compat_mptctl_ioctl);=0A=
@@ -2968,6 +2992,7 @@=0A=
 			" (%d:err=3D%d)\n", where, err);=0A=
 	unregister_ioctl32_conversion(MPTIOCINFO);=0A=
 	unregister_ioctl32_conversion(MPTIOCINFO1);=0A=
+	unregister_ioctl32_conversion(MPTIOCINFO2);=0A=
 	unregister_ioctl32_conversion(MPTTARGETINFO);=0A=
 	unregister_ioctl32_conversion(MPTTEST);=0A=
 	unregister_ioctl32_conversion(MPTEVENTQUERY);=0A=
@@ -3018,6 +3043,7 @@=0A=
 #ifdef CONFIG_COMPAT=0A=
 	unregister_ioctl32_conversion(MPTIOCINFO);=0A=
 	unregister_ioctl32_conversion(MPTIOCINFO1);=0A=
+	unregister_ioctl32_conversion(MPTIOCINFO2);=0A=
 	unregister_ioctl32_conversion(MPTTARGETINFO);=0A=
 	unregister_ioctl32_conversion(MPTTEST);=0A=
 	unregister_ioctl32_conversion(MPTEVENTQUERY);=0A=
diff -uarN b/drivers/message/fusion/mptctl.h =
a/drivers/message/fusion/mptctl.h=0A=
--- b/drivers/message/fusion/mptctl.h	2004-04-03 20:37:06.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptctl.h	2004-04-13 15:07:41.000000000 =
-0600=0A=
@@ -91,6 +91,7 @@=0A=
 =0A=
 #define MPTIOCINFO		_IOWR(MPT_MAGIC_NUMBER,17,struct =
mpt_ioctl_iocinfo)=0A=
 #define MPTIOCINFO1		_IOWR(MPT_MAGIC_NUMBER,17,struct =
mpt_ioctl_iocinfo_rev0)=0A=
+#define MPTIOCINFO2		_IOWR(MPT_MAGIC_NUMBER,17,struct =
mpt_ioctl_iocinfo_rev1)=0A=
 #define MPTTARGETINFO		_IOWR(MPT_MAGIC_NUMBER,18,struct =
mpt_ioctl_targetinfo)=0A=
 #define MPTTEST			_IOWR(MPT_MAGIC_NUMBER,19,struct mpt_ioctl_test)=0A=
 #define MPTEVENTQUERY		_IOWR(MPT_MAGIC_NUMBER,21,struct =
mpt_ioctl_eventquery)=0A=
@@ -165,6 +166,18 @@=0A=
 	} u;=0A=
 };=0A=
 =0A=
+struct mpt_ioctl_pci_info2 {=0A=
+	union {=0A=
+		struct {=0A=
+			unsigned int  deviceNumber   :  5;=0A=
+			unsigned int  functionNumber :  3;=0A=
+			unsigned int  busNumber      : 24;=0A=
+		} bits;=0A=
+		unsigned int  asUlong;=0A=
+	} u;=0A=
+  int segmentID;=0A=
+};=0A=
+=0A=
 /*=0A=
  *  Adapter Information Page=0A=
  *  Read only.=0A=
@@ -189,6 +202,24 @@=0A=
 	char		 busChangeEvent;=0A=
 	char		 hostId;=0A=
 	char		 rsvd[2];=0A=
+	struct mpt_ioctl_pci_info2  pciInfo; /* Added Rev 2 */=0A=
+};=0A=
+=0A=
+struct mpt_ioctl_iocinfo_rev1 {=0A=
+	mpt_ioctl_header hdr;=0A=
+	int		 adapterType;	/* SCSI or FCP */=0A=
+	int		 port;		/* port number */=0A=
+	int		 pciId;		/* PCI Id. */=0A=
+	int		 hwRev;		/* hardware revision */=0A=
+	int		 subSystemDevice;	/* PCI subsystem Device ID */=0A=
+	int		 subSystemVendor;	/* PCI subsystem Vendor ID */=0A=
+	int		 numDevices;		/* number of devices */=0A=
+	int		 FWVersion;		/* FW Version (integer) */=0A=
+	int		 BIOSVersion;		/* BIOS Version (integer) */=0A=
+	char		 driverVersion[MPT_IOCTL_VERSION_LENGTH];	/* Driver Version =
(string) */=0A=
+	char		 busChangeEvent;=0A=
+	char		 hostId;=0A=
+	char		 rsvd[2];=0A=
 	struct mpt_ioctl_pci_info  pciInfo; /* Added Rev 1 */=0A=
 };=0A=
 =0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-04-22 08:38:03.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-04-13 15:35:31.000000000 =
-0600=0A=
@@ -805,6 +805,14 @@=0A=
 =0A=
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)=0A=
 			copy_sense_data(sc, hd, mf, pScsiReply);=0A=
+                =0A=
+		/*=0A=
+		 *  Look for + dump FCP ResponseInfo[]!=0A=
+		 */=0A=
+		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID) {=0A=
+			printk(KERN_NOTICE "  FCP_ResponseInfo=3D%08xh\n",=0A=
+			le32_to_cpu(pScsiReply->ResponseInfo));=0A=
+		}=0A=
 =0A=
 		switch(status) {=0A=
 		case MPI_IOCSTATUS_BUSY:			/* 0x0002 */=0A=
@@ -1106,16 +1114,21 @@=0A=
 			 * Do OS callback=0A=
 			 * Free driver resources (chain, msg buffers)=0A=
 			 */=0A=
-			if (SCpnt->use_sg) {=0A=
-				pci_unmap_sg(hd->ioc->pcidev, (struct scatterlist *) =
SCpnt->request_buffer,=0A=
-					    SCpnt->use_sg, =
scsi_to_pci_dma_dir(SCpnt->sc_data_direction));=0A=
-			} else if (SCpnt->request_bufflen) {=0A=
-				scPrivate	*my_priv;=0A=
-=0A=
-				my_priv =3D (scPrivate *) &SCpnt->SCp;=0A=
-				pci_unmap_single(hd->ioc->pcidev, =
(dma_addr_t)(ulong)my_priv->p1,=0A=
-					   SCpnt->request_bufflen,=0A=
-					   scsi_to_pci_dma_dir(SCpnt->sc_data_direction));=0A=
+			if (scsi_device_online(SCpnt->device)) {=0A=
+				if (SCpnt->use_sg) {=0A=
+					pci_unmap_sg(hd->ioc->pcidev,=0A=
+						(struct scatterlist *) SCpnt->request_buffer,=0A=
+						SCpnt->use_sg,=0A=
+						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));=0A=
+				} else if (SCpnt->request_bufflen) {=0A=
+					scPrivate	*my_priv;=0A=
+=0A=
+					my_priv =3D (scPrivate *) &SCpnt->SCp;=0A=
+					pci_unmap_single(hd->ioc->pcidev,=0A=
+						(dma_addr_t)(ulong)my_priv->p1,=0A=
+						SCpnt->request_bufflen,=0A=
+						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));=0A=
+				}=0A=
 			}=0A=
 			SCpnt->result =3D DID_RESET << 16;=0A=
 			SCpnt->host_scribble =3D NULL;=0A=

------_=_NextPart_000_01C42879.D8803050--

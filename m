From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 3/4] fusion - ioctl updates
Date: Wed, 1 Jun 2005 10:47:39 -0600
Message-ID: <200506011047.39883.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_raenCeqlqpNbEkA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56037 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261463AbVFAQu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 12:50:57 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j51Glao7007769
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:47:36 -0700 (PDT)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id j51GouJm005835
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:50:56 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_raenCeqlqpNbEkA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mptfusion patch 3/4:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.03/

Changelog:
* Please note: NO NEW IOCTLS ARE BEING ADDED !!!
* adding new define MPT_IOCTL_INTERFACE_SAS, and handle respective cases
* removed RAID related data from the _SpiCfgData struct, and moved to
new structure called _RaidCfgData
* The currently implemented IOCTL called MPT_COMMAND is the mpi 
firmware passthru ioctl.  This patch enables support for new firmware functions
when using the existing MPT_COMMAND ioctl. Here they are:
	{ MPI_FUNCTION_TOOLBOX, MPI_FUNCTION_SAS_IO_UNIT_CONTROL,
	MPI_FUNCTION_SMP_PASSTHROUGH, MPI_FUNCTION_SATA_PASSTHROUGH}

Signed-off-by: Eric.Moore<Eric.Moore@lsil.com>

--Boundary-00=_raenCeqlqpNbEkA
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sas_upates3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sas_upates3.patch"

--- b/drivers/message/fusion/mptctl.h	2005-05-05 10:19:45.000000000 -0600
+++ a/drivers/message/fusion/mptctl.h	2005-05-27 10:25:06.000000000 -0600
@@ -172,6 +172,7 @@
  */
 #define MPT_IOCTL_INTERFACE_FC		(0x01)
 #define MPT_IOCTL_INTERFACE_SCSI	(0x00)
+#define MPT_IOCTL_INTERFACE_SAS		(0x02)
 #define MPT_IOCTL_VERSION_LENGTH	(32)
 
 struct mpt_ioctl_iocinfo {
--- b/drivers/message/fusion/mptctl.c	2005-05-10 14:27:13.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2005-05-31 13:18:13.000000000 -0600
@@ -194,6 +194,8 @@
  *  will be returned to the message pool when we return from the IRQ
  *
  *  This runs in irq context so be short and sweet.
+ *
+ *  Returns 1 indicating alloc'd request frame ptr should be freed.
  */
 static int
 mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
@@ -213,8 +215,7 @@
 
 		if (reply==NULL) {
 
-			dctlprintk(("mptctl_reply() NULL Reply "
-				"Function=%x!\n", cmd));
+			dctlprintk(("mptctl_reply() NULL Reply Function=%x!\n", cmd));
 
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
 			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
@@ -227,8 +228,7 @@
 
 		}
 
-		dctlprintk(("mptctl_reply() with req=%p "
-			"reply=%p Function=%x!\n", req, reply, cmd));
+		dctlprintk(("mptctl_reply() with req=%p reply=%p Function=%x!\n", req, reply, cmd));
 
 		/* Copy the reply frame (which much exist
 		 * for non-SCSI I/O) to the IOC structure.
@@ -251,22 +251,18 @@
 			ioc->ioctl->reset &= ~MPTCTL_RESET_OK;
 
 			if ((iocStatus == MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||
-			(iocStatus == MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {
-			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
+				(iocStatus == MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {
+				ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
 			}
 		}
 
 		/* Copy the sense data - if present
 		 */
 		if ((cmd == MPI_FUNCTION_SCSI_IO_REQUEST) &&
-			(reply->u.sreply.SCSIState &
-			 MPI_SCSI_STATE_AUTOSENSE_VALID)){
+			(reply->u.sreply.SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID)){
 			sz = req->u.scsireq.SenseBufferLength;
-			req_index =
-			    le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);
-			sense_data =
-			    ((u8 *)ioc->sense_buf_pool +
-			     (req_index * MPT_SENSE_BUFFER_ALLOC));
+			req_index = le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);
+			sense_data = ((u8 *)ioc->sense_buf_pool + (req_index * MPT_SENSE_BUFFER_ALLOC));
 			memcpy(ioc->ioctl->sense, sense_data, sz);
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_SENSE_VALID;
 		}
@@ -288,7 +284,8 @@
  * Expecting an interrupt, however timed out.
  *
  */
-static void mptctl_timeout_expired (MPT_IOCTL *ioctl)
+static void
+mptctl_timeout_expired (MPT_IOCTL *ioctl)
 {
 	int rc = 1;
 
@@ -318,7 +315,8 @@
  * Bus reset code.
  *
  */
-static int mptctl_bus_reset(MPT_IOCTL *ioctl)
+static int
+mptctl_bus_reset(MPT_IOCTL *ioctl)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
@@ -397,7 +395,6 @@
 
 mptctl_bus_reset_done:
 
-	mpt_free_msg_frame(hd->ioc, mf);
 	mptctl_free_tm_flags(ioctl->ioc);
 	return retval;
 }
@@ -510,12 +507,6 @@
 		return -ENODEV;
 	}
 
-	if (!iocp->active) {
-		printk(KERN_ERR "%s::mptctl_ioctl() @%d - Controller disabled.\n",
-				__FILE__, __LINE__);
-		return -EFAULT;
-	}
-
 	/* Handle those commands that are just returning
 	 * information stored in the driver.
 	 * These commands should never time out and are unaffected
@@ -703,7 +694,10 @@
 	dlmsg->ChainOffset = 0;
 	dlmsg->Function = MPI_FUNCTION_FW_DOWNLOAD;
 	dlmsg->Reserved1[0] = dlmsg->Reserved1[1] = dlmsg->Reserved1[2] = 0;
-	dlmsg->MsgFlags = 0;
+	if (iocp->facts.MsgVersion >= MPI_VERSION_01_05)
+		dlmsg->MsgFlags = MPI_FW_DOWNLOAD_MSGFLGS_LAST_SEGMENT;
+	else
+		dlmsg->MsgFlags = 0;
 
 	/* Set up the Transaction SGE.
 	 */
@@ -804,7 +798,7 @@
 	/*
 	 * Finally, perform firmware download.
 	 */
-	iocp->ioctl->wait_done = 0;
+	ReplyMsg = NULL;
 	mpt_put_msg_frame(mptctl_id, iocp, mf);
 
 	/* Now wait for the command to complete */
@@ -1146,7 +1140,9 @@
 	/* Fill in the data and return the structure to the calling
 	 * program
 	 */
-	if (ioc->bus_type == FC)
+	if (ioc->bus_type == SAS)
+		karg->adapterType = MPT_IOCTL_INTERFACE_SAS;
+	else if (ioc->bus_type == FC)
 		karg->adapterType = MPT_IOCTL_INTERFACE_FC;
 	else
 		karg->adapterType = MPT_IOCTL_INTERFACE_SCSI;
@@ -1171,12 +1167,11 @@
 		karg->pciInfo.u.bits.deviceNumber = PCI_SLOT( pdev->devfn );
 		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
 	} else if (cim_rev == 2) {
-		/* Get the PCI bus, device, function and segment ID numbers 
+		/* Get the PCI bus, device, function and segment ID numbers
 		   for the IOC */
 		karg->pciInfo.u.bits.busNumber = pdev->bus->number;
 		karg->pciInfo.u.bits.deviceNumber = PCI_SLOT( pdev->devfn );
 		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
-		karg->pciInfo.u.bits.functionNumber = PCI_FUNC( pdev->devfn );
 		karg->pciInfo.segmentID = pci_domain_nr(pdev->bus);
 	}
 
@@ -1326,7 +1321,7 @@
 		 */
 		if (hd && hd->Targets) {
 			mpt_findImVolumes(ioc);
-			pIoc2 = ioc->spi_data.pIocPg2;
+			pIoc2 = ioc->raid_data.pIocPg2;
 			for ( id = 0; id <= max_id; ) {
 				if ( pIoc2 && pIoc2->NumActiveVolumes ) {
 					if ( id == pIoc2->RaidVolume[0].VolumeID ) {
@@ -1348,7 +1343,7 @@
 						--maxWordsLeft;
 						goto next_id;
 					} else {
-						pIoc3 = ioc->spi_data.pIocPg3;
+						pIoc3 = ioc->raid_data.pIocPg3;
             					for ( jj = 0; jj < pIoc3->NumPhysDisks; jj++ ) {
                     					if ( pIoc3->PhysDisk[jj].PhysDiskID == id )
 								goto next_id;
@@ -1818,6 +1813,8 @@
 	case MPI_FUNCTION_SCSI_ENCLOSURE_PROCESSOR:
 	case MPI_FUNCTION_FW_DOWNLOAD:
 	case MPI_FUNCTION_FC_PRIMITIVE_SEND:
+	case MPI_FUNCTION_TOOLBOX:
+	case MPI_FUNCTION_SAS_IO_UNIT_CONTROL:
 		break;
 
 	case MPI_FUNCTION_SCSI_IO_REQUEST:
@@ -1838,11 +1835,12 @@
 				goto done_free_mem;
 			}
 
-			pScsiReq->MsgFlags = mpt_msg_flags();
+			pScsiReq->MsgFlags &= ~MPI_SCSIIO_MSGFLGS_SENSE_WIDTH;
+			pScsiReq->MsgFlags |= mpt_msg_flags();
 
 			/* verify that app has not requested
-			 *	more sense data than driver
-			 *	can provide, if so, reset this parameter
+			 * more sense data than driver
+			 * can provide, if so, reset this parameter
 			 * set the sense buffer pointer low address
 			 * update the control field to specify Q type
 			 */
@@ -1889,6 +1887,25 @@
 		}
 		break;
 
+	case MPI_FUNCTION_SMP_PASSTHROUGH:
+		/* Check mf->PassthruFlags to determine if
+		 * transfer is ImmediateMode or not.
+		 * Immediate mode returns data in the ReplyFrame.
+		 * Else, we are sending request and response data
+		 * in two SGLs at the end of the mf.
+		 */
+		break;
+
+	case MPI_FUNCTION_SATA_PASSTHROUGH:
+		if (!ioc->sh) {
+			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "
+				"SCSI driver is not loaded. \n",
+					__FILE__, __LINE__);
+			rc = -EFAULT;
+			goto done_free_mem;
+		}
+		break;
+
 	case MPI_FUNCTION_RAID_ACTION:
 		/* Just add a SGE
 		 */
@@ -1901,11 +1918,12 @@
 			int scsidir = MPI_SCSIIO_CONTROL_READ;
 			int dataSize;
 
-			pScsiReq->MsgFlags = mpt_msg_flags();
+			pScsiReq->MsgFlags &= ~MPI_SCSIIO_MSGFLGS_SENSE_WIDTH;
+			pScsiReq->MsgFlags |= mpt_msg_flags();
 
 			/* verify that app has not requested
-			 *	more sense data than driver
-			 *	can provide, if so, reset this parameter
+			 * more sense data than driver
+			 * can provide, if so, reset this parameter
 			 * set the sense buffer pointer low address
 			 * update the control field to specify Q type
 			 */
@@ -2087,7 +2105,16 @@
 		}
 
 		if (karg.dataInSize > 0) {
-			flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
+			if ((karg.dataOutSize > 0) &&
+			    (hdr->Function == MPI_FUNCTION_SMP_PASSTHROUGH)){
+				flagsLength = ( MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+						MPI_SGE_FLAGS_END_OF_BUFFER |
+						MPI_SGE_FLAGS_DIRECTION |
+						mpt_addr_size() )
+						<< MPI_SGE_FLAGS_SHIFT;
+			} else {
+				flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
+			}
 			flagsLength |= karg.dataInSize;
 
 			bufIn.len = karg.dataInSize;
@@ -2371,7 +2398,7 @@
 
 	karg.base_io_addr = pci_resource_start(pdev, 0);
 
-	if (ioc->bus_type == FC)
+	if ((ioc->bus_type == SAS) || (ioc->bus_type == FC))
 		karg.bus_phys_width = HP_BUS_WIDTH_UNK;
 	else
 		karg.bus_phys_width = HP_BUS_WIDTH_16;
@@ -2460,7 +2487,7 @@
 
 	/*  There is nothing to do for FCP parts.
 	 */
-	if (ioc->bus_type == FC)
+	if ((ioc->bus_type == SAS) || (ioc->bus_type == FC))
 		return 0;
 
 	if ((ioc->spi_data.sdp0length == 0) || (ioc->sh == NULL))

--Boundary-00=_raenCeqlqpNbEkA--

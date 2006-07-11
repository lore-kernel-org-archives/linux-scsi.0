From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Tue, 11 Jul 2006 17:21:09 -0600
Message-ID: <20060711232109.GA12249@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48337 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932250AbWGKXeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:34:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Transport Layer Retry support for SAS Tapes.
Detects whether firmware supports TLR, then
issues special scsi opcode to enable TLR in
the end device.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-07-11 16:38:27.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-07-11 16:47:23.000000000 -0600
@@ -646,16 +646,68 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
 	return error;
 }
 
+/*
+ * Enabling Transport Layer Retries
+ */
+static void
+mptsas_issue_tlr(MPT_SCSI_HOST *hd, struct scsi_device *sdev)
+{
+	INTERNAL_CMD	*iocmd;
+	VirtDevice	*vdev = sdev->hostdata;
+	u8		retries;
+	u8		rc;
+
+	if ( sdev->inquiry[8]  == 'H' &&
+	     sdev->inquiry[9]  == 'P' &&
+	     sdev->inquiry[10] == ' ' &&
+	     sdev->inquiry[11] == ' ' &&
+	     sdev->inquiry[12] == ' ' &&
+	     sdev->inquiry[13] == ' ' &&
+	     sdev->inquiry[14] == ' ' &&
+	     sdev->inquiry[15] == ' ' ) {
+
+		iocmd = kzalloc(sizeof(INTERNAL_CMD), GFP_KERNEL);
+		if (!iocmd) {
+			printk(MYIOC_s_ERR_FMT "%s: kzalloc(%zd) FAILED!\n",
+			__FUNCTION__, hd->ioc->name, sizeof(INTERNAL_CMD));
+			return;
+		}
+		iocmd->id = vdev->vtarget->target_id;
+		iocmd->bus = vdev->vtarget->bus_id;
+		iocmd->lun = vdev->lun;
+		iocmd->physDiskNum = -1;
+		iocmd->cmd = TRANSPORT_LAYER_RETRIES;
+		iocmd->data_dma = -1;
+		for (retries = 0, rc = -1; retries < 3; retries++) {
+			rc = mptscsih_do_cmd(hd, iocmd);
+			if (!rc)
+				break;
+		}
+		if (rc != 0)
+			printk(MYIOC_s_INFO_FMT "unable to enable TLR on"
+			   " channel=%d id=%d lun=%d\n",
+			   hd->ioc->name, sdev->channel, sdev->id, sdev->lun);
+		kfree(iocmd);
+	}
+}
+
 static int
 mptsas_slave_configure(struct scsi_device *sdev)
 {
+	struct Scsi_Host	*host = sdev->host;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 
 	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	sas_read_port_mode_page(sdev);
 
- out:
+	if (sdev->type == TYPE_TAPE &&
+		    (hd->ioc->facts.IOCCapabilities &
+		    MPI_IOCFACTS_CAPABILITY_TLR ))
+			mptsas_issue_tlr(hd, sdev);
+
+out:
 	return mptscsih_slave_configure(sdev);
 }
 
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-07-10 11:28:52.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-07-11 12:44:08.000000000 -0600
@@ -100,20 +100,6 @@ typedef struct _BIG_SENSE_BUF {
 #define MPT_ICFLAG_DID_RESET	0x20	/* Bus Reset occurred with this command */
 #define MPT_ICFLAG_RESERVED	0x40	/* Reserved has been issued */
 
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
@@ -138,7 +124,6 @@ static void	mptscsih_initTarget(MPT_SCSI
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
-static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -3003,6 +2988,8 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 				completionCode = MPT_SCANDV_DID_RESET;
 			else if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
 				completionCode = MPT_SCANDV_DID_RESET;
+			else if (scsi_status == MPI_SCSI_STATUS_BUSY)
+				completionCode = MPT_SCANDV_SOME_ERROR;
 			else {
 				completionCode = MPT_SCANDV_GOOD;
 				hd->pLocal->scsiStatus = scsi_status;
@@ -3109,7 +3096,7 @@ mptscsih_timer_expired(unsigned long dat
  *
  *		 > 0 if command complete but some type of completion error.
  */
-static int
+int
 mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 {
 	MPT_FRAME_HDR	*mf;
@@ -3120,7 +3107,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 	int		in_isr;
 	char		 cmdLen;
 	char		 CDB[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
-	char		 cmd = io->cmd;
+	u8		 cmd = io->cmd;
 
 	in_isr = in_interrupt();
 	if (in_isr) {
@@ -3219,6 +3206,14 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 		cmdTimeout = 10;
 		break;
 
+	case TRANSPORT_LAYER_RETRIES:
+		CDB[0] = cmd;
+		CDB[1] = 0x01;
+		cmdLen = 6;
+		dir = MPI_SCSIIO_CONTROL_READ;
+		cmdTimeout = 10;
+		break;
+
 	default:
 		/* Error Case */
 		return -EFAULT;
@@ -3401,5 +3396,5 @@ EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
 EXPORT_SYMBOL(mptscsih_TMHandler);
-
+EXPORT_SYMBOL(mptscsih_do_cmd);
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2006-07-11 12:01:03.000000000 -0600
@@ -69,9 +69,23 @@
 #define MPTSCSIH_SAF_TE                 0
 #define MPTSCSIH_PT_CLEAR               0
 
-
+#define TRANSPORT_LAYER_RETRIES		0xC2
 #endif
 
+typedef struct _internal_cmd {
+	char		*data;		/* data pointer */
+	dma_addr_t	data_dma;	/* data dma address */
+	int		size;		/* transfer size */
+	u8		cmd;		/* SCSI Op Code */
+	u8		bus;		/* bus number */
+	u8		id;		/* SCSI ID (virtual) */
+	u8		lun;
+	u8		flags;		/* Bit Field - See above */
+	u8		physDiskNum;	/* Phys disk number, -1 else */
+	u8		rsvd2;
+	u8		rsvd;
+} INTERNAL_CMD;
+
 extern void mptscsih_remove(struct pci_dev *);
 extern void mptscsih_shutdown(struct pci_dev *);
 #ifdef CONFIG_PM
@@ -101,3 +115,4 @@ extern void mptscsih_timer_expired(unsig
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 extern int mptscsih_raid_id_to_num(MPT_SCSI_HOST *hd, uint physdiskid);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
+extern int mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);

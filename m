From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] remove ->emulated from host template
Date: Wed, 31 Mar 2004 19:01:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406B5BC7.2080309@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050909060009000906010901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53713 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262120AbUDAAB1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 19:01:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050909060009000906010901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


I think the comment and usage in drivers/block/scsi_ioctl.c says it all, 
but just in case...

This ->emulated exists solely to export an unneeded distinction to 
userspace.  As you can see from sg_emulated_host() in scsi_ioctl.c, the 
value in today's 2.6.x kernels is pretty much completely meaningless.



--------------050909060009000906010901
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== arch/mips/kernel/ioctl32.c 1.17 vs edited =====
--- 1.17/arch/mips/kernel/ioctl32.c	Sun Mar  7 02:04:56 2004
+++ edited/arch/mips/kernel/ioctl32.c	Wed Mar 31 17:57:59 2004
@@ -1074,7 +1074,6 @@
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
-COMPATIBLE_IOCTL(SG_EMULATED_HOST)
 COMPATIBLE_IOCTL(SG_SET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_GET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_SET_RESERVED_SIZE)
===== drivers/block/scsi_ioctl.c 1.41 vs edited =====
--- 1.41/drivers/block/scsi_ioctl.c	Thu Mar 11 07:19:52 2004
+++ edited/drivers/block/scsi_ioctl.c	Wed Mar 31 17:58:29 2004
@@ -96,15 +96,6 @@
 	return 0;
 }
 
-/*
- * will always return that we are ATAPI even for a real SCSI drive, I'm not
- * so sure this is worth doing anything about (why would you care??)
- */
-static int sg_emulated_host(request_queue_t *q, int *p)
-{
-	return put_user(1, p);
-}
-
 static int sg_io(request_queue_t *q, struct gendisk *bd_disk,
 		 struct sg_io_hdr *hdr)
 {
@@ -344,9 +335,6 @@
 			break;
 		case SG_SET_RESERVED_SIZE:
 			err = sg_set_reserved_size(q, (int *) arg);
-			break;
-		case SG_EMULATED_HOST:
-			err = sg_emulated_host(q, (int *) arg);
 			break;
 		case SG_IO: {
 			struct sg_io_hdr hdr;
===== drivers/scsi/3w-xxxx.c 1.40 vs edited =====
--- 1.40/drivers/scsi/3w-xxxx.c	Tue Sep 23 11:00:30 2003
+++ edited/drivers/scsi/3w-xxxx.c	Wed Mar 31 17:53:33 2004
@@ -3494,7 +3494,6 @@
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
-	.emulated		= 1
 };
 #include "scsi_module.c"
 
===== drivers/scsi/ata_piix.c 1.12 vs edited =====
--- 1.12/drivers/scsi/ata_piix.c	Thu Mar 18 13:22:43 2004
+++ edited/drivers/scsi/ata_piix.c	Wed Mar 31 17:53:35 2004
@@ -106,7 +106,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/ide-scsi.c 1.38 vs edited =====
--- 1.38/drivers/scsi/ide-scsi.c	Tue Mar 16 15:21:04 2004
+++ edited/drivers/scsi/ide-scsi.c	Wed Mar 31 17:53:39 2004
@@ -1077,7 +1077,6 @@
 	.cmd_per_lun		= 5,
 	.max_sectors		= 128,
 	.use_clustering		= DISABLE_CLUSTERING,
-	.emulated		= 1,
 	.proc_name		= "ide-scsi",
 };
 
===== drivers/scsi/sata_promise.c 1.29 vs edited =====
--- 1.29/drivers/scsi/sata_promise.c	Thu Mar 18 17:55:44 2004
+++ edited/drivers/scsi/sata_promise.c	Wed Mar 31 17:53:42 2004
@@ -185,7 +185,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/sata_sil.c 1.20 vs edited =====
--- 1.20/drivers/scsi/sata_sil.c	Thu Mar 18 17:55:44 2004
+++ edited/drivers/scsi/sata_sil.c	Wed Mar 31 17:53:45 2004
@@ -108,7 +108,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/sata_svw.c 1.14 vs edited =====
--- 1.14/drivers/scsi/sata_svw.c	Fri Mar 19 03:19:21 2004
+++ edited/drivers/scsi/sata_svw.c	Wed Mar 31 17:53:47 2004
@@ -207,7 +207,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/sata_via.c 1.11 vs edited =====
--- 1.11/drivers/scsi/sata_via.c	Wed Mar 31 06:47:24 2004
+++ edited/drivers/scsi/sata_via.c	Wed Mar 31 17:53:49 2004
@@ -84,7 +84,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/sata_vsc.c 1.6 vs edited =====
--- 1.6/drivers/scsi/sata_vsc.c	Fri Mar 19 03:19:21 2004
+++ edited/drivers/scsi/sata_vsc.c	Wed Mar 31 17:53:52 2004
@@ -191,7 +191,6 @@
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.max_sectors		= ATA_MAX_SECTORS,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
===== drivers/scsi/sg.c 1.85 vs edited =====
--- 1.85/drivers/scsi/sg.c	Sat Mar 20 08:48:28 2004
+++ edited/drivers/scsi/sg.c	Wed Mar 31 17:54:43 2004
@@ -952,10 +952,6 @@
 			return (__copy_to_user((void *) arg, rinfo,
 			        SZ_SG_REQ_INFO * SG_MAX_QUEUE) ? -EFAULT : 0);
 		}
-	case SG_EMULATED_HOST:
-		if (sdp->detached)
-			return -ENODEV;
-		return put_user(sdp->device->host->hostt->emulated, (int *) arg);
 	case SG_SCSI_RESET:
 		if (sdp->detached)
 			return -ENODEV;
@@ -3035,11 +3031,10 @@
 				seq_printf(s, "detached pending close ");
 			else
 				seq_printf
-				    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+				    (s, "scsi%d chan=%d id=%d lun=%d   em=0",
 				     scsidp->host->host_no,
 				     scsidp->channel, scsidp->id,
-				     scsidp->lun,
-				     scsidp->host->hostt->emulated);
+				     scsidp->lun);
 			seq_printf(s, " sg_tablesize=%d excl=%d\n",
 				   sdp->sg_tablesize, sdp->exclude);
 		}
===== drivers/usb/image/hpusbscsi.c 1.34 vs edited =====
--- 1.34/drivers/usb/image/hpusbscsi.c	Tue Mar  9 11:41:37 2004
+++ edited/drivers/usb/image/hpusbscsi.c	Wed Mar 31 17:55:19 2004
@@ -34,7 +34,6 @@
 	.this_id		= -1,
 	.cmd_per_lun		= 1,
 	.use_clustering		= 1,
-	.emulated		= 1,
 };
 
 static int
===== drivers/usb/image/microtek.c 1.35 vs edited =====
--- 1.35/drivers/usb/image/microtek.c	Tue Mar  9 11:50:21 2004
+++ edited/drivers/usb/image/microtek.c	Wed Mar 31 17:55:24 2004
@@ -639,7 +639,6 @@
 	.this_id =		-1,
 	.cmd_per_lun =		1,
 	.use_clustering =	1,
-	.emulated =		1,
 };
 
 struct vendor_product
===== drivers/usb/storage/scsiglue.c 1.59 vs edited =====
--- 1.59/drivers/usb/storage/scsiglue.c	Wed Feb 25 04:49:27 2004
+++ edited/drivers/usb/storage/scsiglue.c	Wed Mar 31 17:55:28 2004
@@ -391,9 +391,6 @@
 	 */
 	.use_clustering =		TRUE,
 
-	/* emulated HBA */
-	.emulated =			TRUE,
-
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
 
===== include/linux/compat_ioctl.h 1.20 vs edited =====
--- 1.20/include/linux/compat_ioctl.h	Wed Mar 24 20:13:00 2004
+++ edited/include/linux/compat_ioctl.h	Wed Mar 31 17:58:37 2004
@@ -264,7 +264,6 @@
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
-COMPATIBLE_IOCTL(SG_EMULATED_HOST)
 ULONG_IOCTL(SG_SET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_GET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_SET_RESERVED_SIZE)
===== include/linux/libata.h 1.15 vs edited =====
--- 1.15/include/linux/libata.h	Thu Mar 18 06:27:31 2004
+++ edited/include/linux/libata.h	Wed Mar 31 17:52:59 2004
@@ -78,7 +78,6 @@
 	ATA_DEF_BUSY_WAIT	= 10000,
 	ATA_SHORT_PAUSE		= (HZ >> 6) + 1,
 
-	ATA_SHT_EMULATED	= 1,
 	ATA_SHT_CMD_PER_LUN	= 1,
 	ATA_SHT_THIS_ID		= -1,
 	ATA_SHT_USE_CLUSTERING	= 0,
===== include/scsi/sg.h 1.12 vs edited =====
--- 1.12/include/scsi/sg.h	Thu May 29 00:00:52 2003
+++ edited/include/scsi/sg.h	Wed Mar 31 17:58:46 2004
@@ -182,8 +182,6 @@
  [Those that only apply to the SG 2.x drivers are at the end of the file.]
  (_GET_s yield result via 'int *' 3rd argument unless otherwise indicated) */
 
-#define SG_EMULATED_HOST 0x2203 /* true for emulated host adapter (ATAPI) */
-
 /* Used to configure SCSI command transformation layer for ATAPI devices */
 /* Only supported by the ide-scsi driver */
 #define SG_SET_TRANSFORM 0x2204 /* N.B. 3rd arg is not pointer but value: */

--------------050909060009000906010901--


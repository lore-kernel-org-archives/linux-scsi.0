From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH] megaraid 1.18d for kernel 2.4.x
Date: Thu, 10 Oct 2002 16:49:45 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210101637560.5986-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tux.us.dell.com (tux.us.dell.com [143.166.152.29])
	by smtp2.us.dell.com (8.12.1/8.12.5) with ESMTP id g9AMktre027781
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 17:46:55 -0500
Received: from humbolt.us.dell.com ([10.180.92.254])
	by tux.us.dell.com (8.11.0/8.11.0) with ESMTP id g9ALnjj09808
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 16:50:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's megaraid 1.18d for kernel 2.4.x.  It consists of exactly the 1.18d
driver present in Red Hat Linux 8.0, plus two trivial fixups already
present in the stock kernel tree: 1) change __LP64__ to BITS_PER_LONG==64
everywhere 2) remove unused variable that gave a compile warning

This brings the megaraid driver into 2002 in a stable manner.  The 
megaraid 2.00 driver, when released, will be submitted as 'megaraid2' to 
maintain maximum stability of the 2.4.x kernel series.

This was posted to linux-megaraid-devel@dell.com last Monday, there have
been no objections there.  If there are no objections from linux-scsi, 
I'll submit this to Alan and Marcelo on Monday 11/14.  Patch below is 
against 2.4.20-pre9.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--- linux-2.4/drivers/scsi/megaraid.h	Mon Oct  7 10:56:09 2002
+++ linux-2.4-megaraid-1.18d/drivers/scsi/megaraid.h	Mon Oct  7 15:43:27 2002
@@ -30,7 +30,7 @@
 #define M_RD_IOCTL_CMD_NEW		0x81
 #define M_RD_DRIVER_IOCTL_INTERFACE	0x82
 
-#define MEGARAID_VERSION "v1.18 (Release Date: Thu Oct 11 15:02:53 EDT 2001)\n"
+#define MEGARAID_VERSION "v1.18d (Release Date: Wed Aug  7 18:51:51 EDT 2002)\n"
 
 #define MEGARAID_IOCTL_VERSION 	114
 
@@ -73,6 +73,7 @@
 #define MEGA_MBOXCMD_LWRITE64		0xA8
 #define MEGA_MBOXCMD_PASSTHRU		0x03
 #define MEGA_MBOXCMD_EXTPASSTHRU	0xE3
+#define MEGA_MBOXCMD_PASSTHRU64		0xC3
 #define MEGA_MBOXCMD_ADAPTERINQ		0x05
 
 
@@ -121,6 +122,10 @@
 #define ENABLE_INTR(base)	WRITE_PORT(base,I_TOGGLE_PORT,ENABLE_INTR_BYTE)
 #define DISABLE_INTR(base)	WRITE_PORT(base,I_TOGGLE_PORT,DISABLE_INTR_BYTE)
 
+#ifndef PCI_VENDOR_ID_LSI_LOGIC
+#define PCI_VENDOR_ID_LSI_LOGIC		0x1000
+#endif
+
 /* Define AMI's PCI codes */
 #ifndef PCI_VENDOR_ID_AMI
 #define PCI_VENDOR_ID_AMI		0x101E
@@ -138,6 +143,15 @@
 #define PCI_DEVICE_ID_AMI_MEGARAID3	0x1960
 #endif
 
+#define PCI_VENDOR_ID_DISCOVERY		0x1028
+#define PCI_DEVICE_ID_DISCOVERY		0x000E
+
+#define PCI_VENDOR_ID_PERC4_DI_YSTONE	0x1028
+#define PCI_DEVICE_ID_PERC4_DI_YSTONE	0x000F
+
+#define PCI_VENDOR_ID_PERC4_QC_VERDE	0x1000
+#define PCI_DEVICE_ID_PERC4_QC_VERDE	0x0407
+
 /* Special Adapter Commands */
 #define FW_FIRE_WRITE   	0x2C
 #define FW_FIRE_FLASH   	0x2D
@@ -172,6 +186,7 @@
 #define PCI_CONF_AMISIG64		0xa4
 
 /* Sub-System Vendor ID sorted on alphabetical order*/
+#define LSI_SUBSYS_ID                  0x1000
 #define	AMI_SUBSYS_ID			0x101E
 #define DELL_SUBSYS_ID			0x1028
 #define	HP_SUBSYS_ID			0x103C
@@ -704,12 +719,15 @@ struct _mega_scb {
 #define INTR_ENB	0	/* do not disable interrupt while manipulating */
 #define INTR_DIS	1	/* disable interrupt while manipulating */
 
+#define NVIRT_CHAN		4	/* # of virtual channels to represent 60 logical
+							drives */
+
 /* Per-controller data */
 typedef struct _mega_host_config {
 	u8 numldrv;
 	u32 flag;
 
-#if BITS_PER_LONG==64
+#ifdef __LP64__
 	u64 base;
 #else
 	u32 base;
@@ -769,8 +787,12 @@ typedef struct _mega_host_config {
 	struct proc_dir_entry *controller_proc_dir_entry;
 	struct proc_dir_entry *proc_read, *proc_stat, *proc_status, *proc_mbox;
 	int		support_ext_cdb;
-	int		boot_ldrv_enabled;
-	int		boot_ldrv;
+
+	u8		boot_ldrv_enabled;	/* boot from logical drive */
+	u8		boot_ldrv;			/* boot logical drive */
+	u8		boot_pdrv_enabled;	/* boot from physical drive */
+	u8		boot_pdrv_ch;		/* boot physical drive channel */
+	u8		boot_pdrv_tgt;		/* boot physical drive target */
 
 	int		support_random_del;	/* Do we support random deletion of logdrvs */
 	int		read_ldidmap;	/* set after logical drive deltion. The logical
@@ -782,6 +804,9 @@ typedef struct _mega_host_config {
 	mega_scb	*int_qh;	/* commands are queued in the internal queue */
 	mega_scb	*int_qt;	/* while the hba is quiescent */
 	int			int_qlen;
+	char		logdrv_chan[MAX_CHANNEL+NVIRT_CHAN]; /* logical drive are on
+														 what channels. */
+	int			mega_ch_class;
 } mega_host_config;
 
 typedef struct _driver_info {
@@ -916,8 +941,8 @@ struct private_bios_data {
 							 * Others values are invalid
 							 */
 	u8		unused:4;		/* bits 4-7 are unused */
-	u8		boot_ldrv;		/*
-							 * logical drive set as boot drive
+	u8		boot_drv;		/*
+							 * logical/physical drive set as boot drive
 							 * 0..7 - for 8LD cards
 							 * 0..39 - for 40LD cards
 							 */
@@ -926,9 +951,6 @@ struct private_bios_data {
 };
 #pragma pack()
 
-#define NVIRT_CHAN		4	/* # of virtual channels to represent 60 logical
-							drives */
-
 /*
  * Command for random deletion of logical drives
  */
@@ -994,13 +1016,13 @@ static void mega_swap_hosts (struct Scsi
 static void mega_create_proc_entry (int index, struct proc_dir_entry *);
 static int mega_support_ext_cdb(mega_host_config *);
 static mega_passthru* mega_prepare_passthru(mega_host_config *, mega_scb *,
-		Scsi_Cmnd *);
+		Scsi_Cmnd *, int, int);
 static mega_ext_passthru* mega_prepare_extpassthru(mega_host_config *,
-		mega_scb *, Scsi_Cmnd *);
+		mega_scb *, Scsi_Cmnd *, int, int);
 static void mega_enum_raid_scsi(mega_host_config *);
 static int mega_partsize(Disk *, kdev_t, int *);
-static void mega_get_boot_ldrv(mega_host_config *);
-static int mega_get_lun(mega_host_config *, Scsi_Cmnd *);
+static void mega_get_boot_drv(mega_host_config *);
+static int mega_get_ldrv_num(mega_host_config *, Scsi_Cmnd *, int);
 static int mega_support_random_del(mega_host_config *);
 static int mega_del_logdrv(mega_host_config *, int);
 static int mega_do_del_logdrv(mega_host_config *, int);
--- linux-2.4/drivers/scsi/megaraid.c	Mon Oct  7 10:51:09 2002
+++ linux-2.4-megaraid-1.18d/drivers/scsi/megaraid.c	Mon Oct  7 15:43:27 2002
@@ -2,14 +2,14 @@
  *
  *                    Linux MegaRAID device driver
  *
- * Copyright 2001  American Megatrends Inc.
+ * Copyright 2001  LSI Logic Corporation.
  *
  *              This program is free software; you can redistribute it and/or
  *              modify it under the terms of the GNU General Public License
  *              as published by the Free Software Foundation; either version
  *              2 of the License, or (at your option) any later version.
  *
- * Version : v1.18 (Oct 11, 2001)
+ * Version : v1.18d (Aug 7, 2002)
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
@@ -459,6 +459,43 @@
  *
  * References to AMI have been changed to LSI Logic.
  *
+ * Version 1.18a
+ * Mon Mar 11 11:38:38 EST 2002 - Atul Mukker <Atul.Mukker@lsil.com>
+ *
+ * RAID On MotherBoard (ROMB) - boot from logical or physical drives
+ *
+ * Support added for discovery(ROMB) vendor and device ids.
+ *
+ * Data transfer length for passthru commands must be valid even if the
+ * command has an associated scatter-gather list.
+ *
+ *
+ * Version 1.18b
+ * Tue Apr 23 11:01:58 EDT 2002 - Atul Mukker <Atul.Mukker@lsil.com>
+ *
+ * typo corrected for scsi condition CHECK_CONDITION in mega_cmd_done()
+ *
+ * Support added for PCI_VENDOR_ID_LSI_LOGIC with device id
+ * PCI_DEVICE_ID_AMI_MEGARAID3.
+ *
+ *
+ * Version 1.18c
+ * Thu May 16 10:27:55 EDT 2002 - Atul Mukker <Atul.Mukker@lsil.com>
+ *
+ * Retrun valid return status for mega passthru commands resulting in
+ * contingent allegiance condition. Check for 64-bit passthru commands also.
+ *
+ * Do not check_region() anymore and check for return value of
+ * request_region()
+ *
+ * Send valid sense data to appliations using the private ioctl interface.
+ *
+ *
+ * Version 1.18d
+ * Wed Aug  7 18:51:51 EDT 2002 - Atul Mukker <atul.mukker@lsil.com>
+ *
+ * Added support for yellowstone and verde controller
+ *
  *
  * BUGS:
  *     Some older 2.1 kernels (eg. 2.1.90) have a bug in pci.c that
@@ -772,7 +809,7 @@ static struct file_operations megadev_fo
 static struct mcontroller mcontroller[MAX_CONTROLLERS];
 
 /* The current driver version */
-static u32 driver_ver = 114;
+static u32 driver_ver = 0x118C;
 
 /* major number used by the device for character interface */
 static int major;
@@ -795,8 +832,7 @@ static struct proc_dir_entry proc_scsi_m
 extern struct proc_dir_entry proc_root;
 #endif
 
-static char mega_ch_class;	/* channels are raid or scsi */
-#define	IS_RAID_CH(ch)	( (mega_ch_class >> (ch)) & 0x01 )
+#define	IS_RAID_CH(this, ch)	( (this->mega_ch_class >> (ch)) & 0x01 )
 
 #if SERDEBUG
 static char strbuf[MAX_SERBUF + 1];
@@ -1076,11 +1112,14 @@ static void mega_cmd_done (mega_host_con
 		panic(KERN_ERR "megaraid:Problem...!\n");
 	}
 
+#if 0
 	islogical = ( (SCpnt->channel >= megaCfg->productInfo.SCSIChanPresent) &&
 					(SCpnt->channel <= megaCfg->host->max_channel) );
+#endif
 #if 0
 	islogical = (SCpnt->channel == megaCfg->host->max_channel);
 #endif
+	islogical = megaCfg->logdrv_chan[SCpnt->channel];
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	/* Special Case to handle PassThrough->XferAddrress > 4GB */
@@ -1117,7 +1156,7 @@ static void mega_cmd_done (mega_host_con
 			status = 0xF0;
 		}
 #endif
-		if( IS_RAID_CH(SCpnt->channel) && ((c & 0x1F ) == TYPE_DISK) ) {
+		if(IS_RAID_CH(megaCfg, SCpnt->channel) && ((c & 0x1F) == TYPE_DISK)) {
 			status = 0xF0;
 		}
 	}
@@ -1126,7 +1165,7 @@ static void mega_cmd_done (mega_host_con
 	/* clear result; otherwise, success returns corrupt value */
 	SCpnt->result = 0;
 
-	if ((SCpnt->cmnd[0] & M_RD_IOCTL_CMD)) {	/* i.e. ioctl cmd such as M_RD_IOCTL_CMD, M_RD_IOCTL_CMD_NEW of megamgr */
+	if ( 0 && SCpnt->cmnd[0] & M_RD_IOCTL_CMD ) {	/* i.e. ioctl cmd such as M_RD_IOCTL_CMD, M_RD_IOCTL_CMD_NEW of megamgr */
 		switch (status) {
 		case 2:
 		case 0xF0:
@@ -1146,18 +1185,21 @@ static void mega_cmd_done (mega_host_con
 		case 0x02:	/* ERROR_ABORTED, i.e. SCSI_STATUS_CHECK_CONDITION */
 
 			/*set sense_buffer and result fields */
-			if (mbox->cmd == MEGA_MBOXCMD_PASSTHRU) {
+			if (mbox->cmd == MEGA_MBOXCMD_PASSTHRU || mbox->cmd ==
+							MEGA_MBOXCMD_PASSTHRU64 ) {
+
 				memcpy (SCpnt->sense_buffer, pthru->reqsensearea, 14);
+
+				SCpnt->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
+						(CHECK_CONDITION << 1);
+
 			} else if (mbox->cmd == MEGA_MBOXCMD_EXTPASSTHRU) {
-				SCpnt->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | (CHECK_CONDITION << 1);
-				memcpy(
-					SCpnt->sense_buffer,
-					epthru->reqsensearea, 14
-				);
-				SCpnt->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | (CHECK_CONDITION << 1);
-				/*SCpnt->result =
-					(DRIVER_SENSE << 24) |
-					(DID_ERROR << 16) | status;*/
+
+				memcpy( SCpnt->sense_buffer, epthru->reqsensearea, 14);
+
+				SCpnt->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
+						(CHECK_CONDITION << 1);
+
 			} else {
 				SCpnt->sense_buffer[0] = 0x70;
 				SCpnt->sense_buffer[2] = ABORTED_COMMAND;
@@ -1204,8 +1246,10 @@ static mega_scb *mega_build_cmd (mega_ho
 	mega_ext_passthru *epthru;
 	long seg;
 	char islogical;
-	int lun = SCpnt->lun;
-	int		max_lun;
+	int		max_ldrv_num;
+	int		channel = 0;
+	int		target = 0;
+	int		ldrv_num = 0;	/* logical drive number */
 
 	if ((SCpnt->cmnd[0] == MEGADEVIOC))
 		return megadev_doioctl (megaCfg, SCpnt);
@@ -1222,15 +1266,61 @@ static mega_scb *mega_build_cmd (mega_ho
 	}
 #endif
 
+#if 0
 	islogical = ( (SCpnt->channel >= megaCfg->productInfo.SCSIChanPresent) &&
 					(SCpnt->channel <= megaCfg->host->max_channel) );
+#endif
 #if 0
 	islogical = (IS_RAID_CH(SCpnt->channel) && /* virtual ch is raid - AM */
 						(SCpnt->channel == megaCfg->host->max_channel));
 #endif
 
+	/*
+	 * We know on what channels are our logical drives - mega_findCard()
+	 */
+	islogical = megaCfg->logdrv_chan[SCpnt->channel];
+
+	/*
+	 * The theory: If physical drive is chosen for boot, all the physical
+	 * devices are exported before the logical drives, otherwise physical
+	 * devices are pushed after logical drives, in which case - Kernel sees
+	 * the physical devices on virtual channel which is obviously converted
+	 * to actual channel on the HBA.
+	 */
+	if( megaCfg->boot_pdrv_enabled ) {
+		if( islogical ) {
+			/* logical channel */
+			channel = SCpnt->channel - megaCfg->productInfo.SCSIChanPresent;
+		}
+		else {
+			channel = SCpnt->channel; /* this is physical channel */
+			target = SCpnt->target;
+
+			/*
+			 * boot from a physical disk, that disk needs to be exposed first
+			 * IF both the channels are SCSI, then booting from the second
+			 * channel is not allowed.
+			 */
+			if( target == 0 ) {
+				target = megaCfg->boot_pdrv_tgt;
+			}
+			else if( target == megaCfg->boot_pdrv_tgt ) {
+				target = 0;
+			}
+		}
+	}
+	else {
+		if( islogical ) {
+			channel = SCpnt->channel; /* this is the logical channel */
+		}
+		else {
+			channel = SCpnt->channel - NVIRT_CHAN;	/* physical channel */
+			target = SCpnt->target;
+		}
+	}
+
 	if ( ! megaCfg->support_ext_cdb ) {
-		if (!islogical && lun != 0) {
+		if (!islogical && SCpnt->lun != 0) {
 			SCpnt->result = (DID_BAD_TARGET << 16);
 			callDone (SCpnt);
 			return NULL;
@@ -1252,39 +1342,26 @@ static mega_scb *mega_build_cmd (mega_ho
 			return NULL;
 		}
 
-		lun = mega_get_lun(megaCfg, SCpnt);
+		ldrv_num = mega_get_ldrv_num(megaCfg, SCpnt, channel);
 
-	    max_lun = (megaCfg->flag & BOARD_40LD) ?
+	    max_ldrv_num = (megaCfg->flag & BOARD_40LD) ?
 						FC_MAX_LOGICAL_DRIVES : MAX_LOGICAL_DRIVES;
 
 		 /*
-		  * max_lun increases by 0x80 if some logical drive was deleted.
+		  * max_ldrv_num increases by 0x80 if some logical drive was deleted.
 		  */
 		if(megaCfg->read_ldidmap) {
-			max_lun += 0x80;
+			max_ldrv_num += 0x80;
 		}
 
-		if( lun > max_lun ) {
+		if( ldrv_num > max_ldrv_num ) {
 			SCpnt->result = (DID_BAD_TARGET << 16);
 			callDone (SCpnt);
 			return NULL;
 		}
 
-		/*
-		 * If we have a logical drive with boot enabled, project it first
-		 */
-		if( megaCfg->boot_ldrv_enabled ) {
-			if( lun == 0 ) {
-				lun = megaCfg->boot_ldrv;
-			}
-			else {
-				if( lun <= megaCfg->boot_ldrv ) {
-					lun--;
-				}
-			}
-		}
 	} else {
-		if ( lun > 7) {
+		if ( SCpnt->lun > 7) {
 				/* Do not support lun >7 for physically accessed devices */
 			SCpnt->result = (DID_BAD_TARGET << 16);
 			callDone (SCpnt);
@@ -1312,6 +1389,14 @@ static mega_scb *mega_build_cmd (mega_ho
 
 		case READ_CAPACITY:
 		case INQUIRY:
+			if(!(megaCfg->flag & (1L << SCpnt->channel))) {
+				printk(KERN_NOTICE
+					"scsi%d: scanning virtual channel %d for logical drives.\n",
+					megaCfg->host->host_no, channel);
+
+				megaCfg->flag |= (1L << SCpnt->channel);
+			}
+
 			/* Allocate a SCB and initialize passthru */
 			if ((pScb = mega_allocateSCB (megaCfg, SCpnt)) == NULL) {
 				SCpnt->result = (DID_ERROR << 16);
@@ -1331,7 +1416,7 @@ static mega_scb *mega_build_cmd (mega_ho
 			pthru->ars = 1;
 			pthru->reqsenselen = 14;
 			pthru->islogical = 1;
-			pthru->logdrv = lun;
+			pthru->logdrv = ldrv_num;
 			pthru->cdblen = SCpnt->cmd_len;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -1386,7 +1471,7 @@ static mega_scb *mega_build_cmd (mega_ho
 			mbox = (mega_mailbox *) & pScb->mboxData;
 
 			memset (mbox, 0, sizeof (pScb->mboxData));
-			mbox->logdrv = lun;
+			mbox->logdrv = ldrv_num;
 
 			if (megaCfg->flag & BOARD_64BIT) {
 				mbox->cmd = (*SCpnt->cmnd == READ_6
@@ -1410,12 +1495,12 @@ static mega_scb *mega_build_cmd (mega_ho
 				mbox->lba &= 0x1FFFFF;
 
 				if (*SCpnt->cmnd == READ_6) {
-					megaCfg->nReads[(int) lun]++;
-					megaCfg->nReadBlocks[(int) lun] +=
+					megaCfg->nReads[(int)ldrv_num]++;
+					megaCfg->nReadBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				} else {
-					megaCfg->nWrites[(int) lun]++;
-					megaCfg->nWriteBlocks[(int) lun] +=
+					megaCfg->nWrites[(int)ldrv_num]++;
+					megaCfg->nWriteBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				}
 			}
@@ -1432,12 +1517,12 @@ static mega_scb *mega_build_cmd (mega_ho
 				    (u32) SCpnt->cmnd[5];
 
 				if (*SCpnt->cmnd == READ_10) {
-					megaCfg->nReads[(int) lun]++;
-					megaCfg->nReadBlocks[(int) lun] +=
+					megaCfg->nReads[(int)ldrv_num]++;
+					megaCfg->nReadBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				} else {
-					megaCfg->nWrites[(int) lun]++;
-					megaCfg->nWriteBlocks[(int) lun] +=
+					megaCfg->nWrites[(int)ldrv_num]++;
+					megaCfg->nWriteBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				}
 			}
@@ -1457,12 +1542,12 @@ static mega_scb *mega_build_cmd (mega_ho
 				    (u32) SCpnt->cmnd[9];
 
 				if (*SCpnt->cmnd == READ_12) {
-					megaCfg->nReads[(int) lun]++;
-					megaCfg->nReadBlocks[(int) lun] +=
+					megaCfg->nReads[(int)ldrv_num]++;
+					megaCfg->nReadBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				} else {
-					megaCfg->nWrites[(int) lun]++;
-					megaCfg->nWriteBlocks[(int) lun] +=
+					megaCfg->nWrites[(int)ldrv_num]++;
+					megaCfg->nWriteBlocks[(int)ldrv_num] +=
 					    mbox->numsectors;
 				}
 			}
@@ -1516,7 +1601,8 @@ static mega_scb *mega_build_cmd (mega_ho
 		memset (mbox, 0, sizeof (pScb->mboxData));
 
 		if ( megaCfg->support_ext_cdb && SCpnt->cmd_len > 10 ) {
-			epthru = mega_prepare_extpassthru(megaCfg, pScb, SCpnt);
+			epthru = mega_prepare_extpassthru(megaCfg, pScb, SCpnt, channel,
+					target);
 			mbox->cmd = MEGA_MBOXCMD_EXTPASSTHRU;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			mbox->xferaddr = pScb->dma_ext_passthruhandle64;
@@ -1531,7 +1617,8 @@ static mega_scb *mega_build_cmd (mega_ho
 #endif
 		}
 		else {
-			pthru = mega_prepare_passthru(megaCfg, pScb, SCpnt);
+			pthru = mega_prepare_passthru(megaCfg, pScb, SCpnt, channel,
+					target);
 
 			/* Initialize mailbox */
 			mbox->cmd = MEGA_MBOXCMD_PASSTHRU;
@@ -1553,18 +1640,30 @@ static mega_scb *mega_build_cmd (mega_ho
 }
 
 static int
-mega_get_lun(mega_host_config *this_hba, Scsi_Cmnd *sc)
+mega_get_ldrv_num(mega_host_config *this_hba, Scsi_Cmnd *sc, int channel)
 {
 	int		tgt;
-	int		lun;
-	int		virt_chan;
+	int		ldrv_num;
 
 	tgt = sc->target;
 	
 	if ( tgt > 7 ) tgt--;	/* we do not get inquires for tgt 7 */
 
-	virt_chan = sc->channel - this_hba->productInfo.SCSIChanPresent;
-	lun = (virt_chan * 15) + tgt;
+	ldrv_num = (channel * 15) + tgt; /* 14 targets per channel */
+
+	/*
+	 * If we have a logical drive with boot enabled, project it first
+	 */
+	if( this_hba->boot_ldrv_enabled ) {
+		if( ldrv_num == 0 ) {
+			ldrv_num = this_hba->boot_ldrv;
+		}
+		else {
+			if( ldrv_num <= this_hba->boot_ldrv ) {
+				ldrv_num--;
+			}
+		}
+	}
 
 	/*
 	 * If "delete logical drive" feature is enabled on this controller.
@@ -1582,16 +1681,17 @@ mega_get_lun(mega_host_config *this_hba,
 		case WRITE_6:	/* fall through */
 		case READ_10:	/* fall through */
 		case WRITE_10:
-			lun += 0x80;
+			ldrv_num += 0x80;
 		}
 	 }
 
-	 return lun;
+	 return ldrv_num;
 }
 
 
 static mega_passthru *
-mega_prepare_passthru(mega_host_config *megacfg, mega_scb *scb, Scsi_Cmnd *sc)
+mega_prepare_passthru(mega_host_config *megacfg, mega_scb *scb, Scsi_Cmnd *sc,
+		int channel, int target)
 {
 	mega_passthru *pthru;
 
@@ -1608,9 +1708,9 @@ mega_prepare_passthru(mega_host_config *
 	pthru->ars = 1;
 	pthru->reqsenselen = 14;
 	pthru->islogical = 0;
-	pthru->channel = (megacfg->flag & BOARD_40LD) ? 0 : sc->channel;
+	pthru->channel = (megacfg->flag & BOARD_40LD) ? 0 : channel;
 	pthru->target = (megacfg->flag & BOARD_40LD) ?
-	    (sc->channel << 4) | sc->target : sc->target;
+	    (channel << 4) | target : target;
 	pthru->cdblen = sc->cmd_len;
 	pthru->logdrv = sc->lun;
 
@@ -1624,6 +1724,15 @@ mega_prepare_passthru(mega_host_config *
 	switch (sc->cmnd[0]) {
 	case INQUIRY:
 	case READ_CAPACITY:
+
+		if(!(megacfg->flag & (1L << sc->channel))) {
+			printk(KERN_NOTICE
+				"scsi%d: scanning physical channel %d for devices.\n",
+				megacfg->host->host_no, channel);
+
+			megacfg->flag |= (1L << sc->channel);
+		}
+
 		pthru->numsgelements = 0;
 		pthru->dataxferaddr = scb->dma_bounce_buffer;
 		pthru->dataxferlen = sc->request_bufflen;
@@ -1647,7 +1756,8 @@ mega_prepare_passthru(mega_host_config *
 }
 
 static mega_ext_passthru *
-mega_prepare_extpassthru(mega_host_config *megacfg, mega_scb *scb, Scsi_Cmnd *sc)
+mega_prepare_extpassthru(mega_host_config *megacfg, mega_scb *scb,
+		Scsi_Cmnd *sc, int channel, int target)
 {
 	mega_ext_passthru *epthru;
 
@@ -1664,9 +1774,9 @@ mega_prepare_extpassthru(mega_host_confi
 	epthru->ars = 1;
 	epthru->reqsenselen = 14;
 	epthru->islogical = 0;
-	epthru->channel = (megacfg->flag & BOARD_40LD) ? 0 : sc->channel;
+	epthru->channel = (megacfg->flag & BOARD_40LD) ? 0 : channel;
 	epthru->target = (megacfg->flag & BOARD_40LD) ?
-	    (sc->channel << 4) | sc->target : sc->target;
+	    (channel << 4) | target : target;
 	epthru->cdblen = sc->cmd_len;
 	epthru->logdrv = sc->lun;
 
@@ -1680,6 +1790,14 @@ mega_prepare_extpassthru(mega_host_confi
 	switch (sc->cmnd[0]) {
 	case INQUIRY:
 	case READ_CAPACITY:
+		if(!(megacfg->flag & (1L << sc->channel))) {
+			printk(KERN_NOTICE
+				"scsi%d: scanning physical channel %d for devices.\n",
+				megacfg->host->host_no, channel);
+
+			megacfg->flag |= (1L << sc->channel);
+		}
+
 		epthru->numsgelements = 0;
 		epthru->dataxferaddr = scb->dma_bounce_buffer;
 		epthru->dataxferlen = sc->request_bufflen;
@@ -2439,7 +2557,7 @@ mega_build_sglist (mega_host_config * me
 			scb->sg64List[0].address = scb->dma_h_bulkdata;
 			scb->sg64List[0].length = scb->SCpnt->request_bufflen;
 			*buffer = scb->dma_sghandle64;
-			*length = 0;
+			*length = (u32)scb->SCpnt->request_bufflen;
 			scb->sglist_count = 1;
 			return 1;
 		} else {
@@ -2520,7 +2638,15 @@ mega_build_sglist (mega_host_config * me
 #else
 	*buffer = virt_to_bus (scb->sgList);
 #endif
+
+#if 0
 	*length = 0;
+#endif
+	/*
+	 * For passthru command, dataxferlen must be set, even for commands with a
+	 * sg list
+	 */
+	*length = (u32)scb->SCpnt->request_bufflen;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	/* Return count of SG requests */
@@ -2743,12 +2869,7 @@ static int mega_i_query_adapter (mega_ho
 		megaCfg->productInfo.SCSIChanPresent + NVIRT_CHAN -1;
 
 	megaCfg->host->max_id = 16;	/* max targets per channel */
-	/*(megaCfg->flag & BOARD_40LD)?FC_MAX_TARGETS_PER_CHANNEL:MAX_TARGET+1; */
-#if 0
-	megaCfg->host->max_lun =	/* max lun */
-	    (megaCfg->flag & BOARD_40LD) ?
-			FC_MAX_LOGICAL_DRIVES : MAX_LOGICAL_DRIVES;
-#endif
+
 	megaCfg->host->max_lun = 7;	/* Upto 7 luns for non disk devices */
 
 	megaCfg->host->cmd_per_lun = MAX_CMD_PER_LUN;
@@ -2760,12 +2881,6 @@ static int mega_i_query_adapter (mega_ho
 
 	megaCfg->host->can_queue = megaCfg->max_cmds - 1;
 
-#if 0
-	if (megaCfg->host->can_queue >= MAX_COMMANDS) {
-		megaCfg->host->can_queue = MAX_COMMANDS - 16;
-	}
-#endif
-
 	/* use HP firmware and bios version encoding */
 	if (megaCfg->productInfo.subSystemVendorID == HP_SUBSYS_ID) {
 		sprintf (megaCfg->fwVer, "%c%d%d.%d%d",
@@ -2833,7 +2948,7 @@ static int mega_findCard (Scsi_Host_Temp
 	u32 magic64;
 #endif
 
-	int		i;
+	int		i, j;
 
 #if BITS_PER_LONG==64
 	u64 megaBase;
@@ -2863,20 +2978,29 @@ static int mega_findCard (Scsi_Host_Temp
 		pciDevFun = pdev->devfn;
 #endif
 		if ((flag & BOARD_QUARTZ) && (skip_id == -1)) {
-			pcibios_read_config_word (pciBus, pciDevFun,
-						  PCI_CONF_AMISIG, &magic);
-			if ((magic != AMI_SIGNATURE)
-			    && (magic != AMI_SIGNATURE_471)) {
-				pciIdx++;
-				continue;	/* not an AMI board */
-			}
+				if( (pciVendor == PCI_VENDOR_ID_PERC4_DI_YSTONE &&
+					pciDev == PCI_DEVICE_ID_PERC4_DI_YSTONE) ||
+					(pciVendor == PCI_VENDOR_ID_PERC4_QC_VERDE &&
+					pciDev == PCI_DEVICE_ID_PERC4_QC_VERDE) ) {
+
+					flag |= BOARD_64BIT;
+				}
+				else {
+					pcibios_read_config_word (pciBus, pciDevFun,
+								  PCI_CONF_AMISIG, &magic);
+					if ((magic != AMI_SIGNATURE)
+						&& (magic != AMI_SIGNATURE_471)) {
+						pciIdx++;
+						continue;	/* not an AMI board */
+					}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-			pcibios_read_config_dword (pciBus, pciDevFun,
-						   PCI_CONF_AMISIG64, &magic64);
+					pcibios_read_config_dword (pciBus, pciDevFun,
+								   PCI_CONF_AMISIG64, &magic64);
 
-			if (magic64 == AMI_64BIT_SIGNATURE)
-				flag |= BOARD_64BIT;
+					if (magic64 == AMI_64BIT_SIGNATURE)
+						flag |= BOARD_64BIT;
 #endif
+				}
 		}
 
 		/* Hmmm...Should we not make this more modularized so that in future we dont add
@@ -2898,24 +3022,15 @@ static int mega_findCard (Scsi_Host_Temp
 					      PCI_SUBSYSTEM_ID, &subsysid);
 #endif
 
-#if 0
 			/*
-			 * This routine is called with well know values and we
-			 * should not be getting what we have not asked.
-			 * Also, the check is not right. It should have been for
-			 * pci_vendor_id not subsysvid - AM
-			 */
-
-			/* If we dont detect this valid subsystem vendor id's 
-			   we refuse to load the driver 
-			   PART of PC200X compliance
+			 * If we do not find the valid subsys vendor id, refuse to load
+			 * the driver. This is part of PCI200X compliance
 			 */
+			if( (subsysvid != AMI_SUBSYS_ID) &&
+					(subsysvid != DELL_SUBSYS_ID) &&
+					(subsysvid != LSI_SUBSYS_ID) &&
+					(subsysvid != HP_SUBSYS_ID) ) continue;
 
-			if ((subsysvid != AMI_SUBSYS_ID)
-			    && (subsysvid != DELL_SUBSYS_ID)
-			    && (subsysvid != HP_SUBSYS_ID))
-				continue;
-#endif
 		}
 
 		printk (KERN_NOTICE
@@ -3004,11 +3119,10 @@ static int mega_findCard (Scsi_Host_Temp
 		megaCtlrs[numCtlrs] = megaCfg;
 
 		if (!(flag & BOARD_QUARTZ)) {
+
 			/* Request our IO Range */
-			if (!request_region(megaBase, 16, "megaraid")) {
-				printk(KERN_WARNING "megaraid: Couldn't register I/O range!\n");
+			if( !request_region(megaBase, 16, "megaraid") )
 				goto err_unregister;
-			}
 		}
 
 		/* Request our IRQ */
@@ -3097,18 +3211,35 @@ static int mega_findCard (Scsi_Host_Temp
 		 * Find out which channel is raid and which is scsi
 		 */
 		mega_enum_raid_scsi(megaCfg);
-		for( i = 0; i < megaCfg->productInfo.SCSIChanPresent; i++ ) {
-			if(IS_RAID_CH(i))
-				printk(KERN_NOTICE"megaraid: channel[%d] is raid.\n", i+1);
-			else
-				printk(KERN_NOTICE"megaraid: channel[%d] is scsi.\n", i+1);
-		}
 
 		/*
 		 * Find out if a logical drive is set as the boot drive. If there is
 		 * one, will make that as the first logical drive.
+		 * ROMB: Do we have to boot from a physical drive. Then all the
+		 * physical drives would appear before the logical disks. Else, all
+		 * the physical drives would be exported to the mid layer after
+		 * logical disks.
 		 */
-		mega_get_boot_ldrv(megaCfg);
+		mega_get_boot_drv(megaCfg);
+
+		if( ! megaCfg->boot_pdrv_enabled ) {
+			for( i = 0; i < NVIRT_CHAN; i++ )
+				megaCfg->logdrv_chan[i] = 1;
+
+			for( i = NVIRT_CHAN; i < MAX_CHANNEL + NVIRT_CHAN; i++ )
+				megaCfg->logdrv_chan[i] = 0;
+
+			megaCfg->mega_ch_class <<= NVIRT_CHAN;
+		}
+		else {
+			j = megaCfg->productInfo.SCSIChanPresent;
+			for( i = 0; i < j; i++ )
+				megaCfg->logdrv_chan[i] = 0;
+
+			for( i = j; i < NVIRT_CHAN + j; i++ )
+				megaCfg->logdrv_chan[i] = 1;
+		}
+
 
 		mega_hbas[numCtlrs].hostdata_addr = megaCfg;
 
@@ -3208,6 +3339,12 @@ int megaraid_detect (Scsi_Host_Template 
 
 	memset (mega_hbas, 0, sizeof (mega_hbas));
 
+	/* Detect ROMBs first */
+	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_DISCOVERY,
+				PCI_DEVICE_ID_DISCOVERY, BOARD_QUARTZ);
+	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_PERC4_DI_YSTONE,
+				PCI_DEVICE_ID_PERC4_DI_YSTONE, BOARD_QUARTZ);
+	/* Then detect cards based on date they were produced, oldest first */
 	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_AMI,
 				PCI_DEVICE_ID_AMI_MEGARAID, 0);
 	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_AMI,
@@ -3216,6 +3353,10 @@ int megaraid_detect (Scsi_Host_Template 
 				PCI_DEVICE_ID_AMI_MEGARAID3, BOARD_QUARTZ);
 	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_AMI,
 				PCI_DEVICE_ID_AMI_MEGARAID3, BOARD_QUARTZ);
+	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_LSI_LOGIC,
+				PCI_DEVICE_ID_AMI_MEGARAID3, BOARD_QUARTZ);
+	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_PERC4_QC_VERDE,
+				PCI_DEVICE_ID_PERC4_QC_VERDE, BOARD_QUARTZ);
 
 	mega_reorder_hosts ();
 
@@ -3366,7 +3507,7 @@ static int mega_is_bios_enabled (mega_ho
 /*
  * Find out what channels are RAID/SCSI
  */
-void
+static void
 mega_enum_raid_scsi(mega_host_config *megacfg)
 {
 	mega_mailbox *mboxp;
@@ -3401,16 +3542,16 @@ mega_enum_raid_scsi(mega_host_config *me
 	 * Non-ROMB firware fail this command, so all channels
 	 * must be shown RAID
 	 */
+	megacfg->mega_ch_class = 0xFF;
 	if( megaIssueCmd(megacfg, mbox, NULL, 0) == 0 ) {
-		mega_ch_class = *((char *)megacfg->mega_buffer);
-
-		for( i = 0; i < NVIRT_CHAN; i++ ) {
-			/* logical drives channel is RAID */
-			mega_ch_class |= (0x01 << (megacfg->productInfo.SCSIChanPresent+i));
-		}
+		megacfg->mega_ch_class = *((char *)megacfg->mega_buffer);
 	}
-	else {
-		mega_ch_class = 0xFF;
+
+	for( i = 0; i < megacfg->productInfo.SCSIChanPresent; i++ ) {
+		if( (megacfg->mega_ch_class >> i) & 0x01 )
+			printk(KERN_NOTICE"megaraid: channel[%d] is raid.\n", i+1);
+		else
+			printk(KERN_NOTICE"megaraid: channel[%d] is scsi.\n", i+1);
 	}
 
 
@@ -3426,13 +3567,14 @@ mega_enum_raid_scsi(mega_host_config *me
  * get the boot logical drive number if enabled
  */
 void
-mega_get_boot_ldrv(mega_host_config *megacfg)
+mega_get_boot_drv(mega_host_config *megacfg)
 {
 	mega_mailbox *mboxp;
 	unsigned char mbox[16];
 	struct private_bios_data *prv_bios_data;
 	u16		cksum = 0;
-	char	*cksum_p;
+	u8		*cksum_p;
+	u8		boot_pdrv;
 	int		i;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -3459,19 +3601,35 @@ mega_get_boot_ldrv(mega_host_config *meg
 
 	megacfg->boot_ldrv_enabled = 0;
 	megacfg->boot_ldrv = 0;
-	if( megaIssueCmd(megacfg, mbox, NULL, 0) == 0 ) {
 
+	megacfg->boot_pdrv_enabled = 0;
+	megacfg->boot_pdrv_ch = 0;
+	megacfg->boot_pdrv_tgt = 0;
+
+	if( megaIssueCmd(megacfg, mbox, NULL, 0) == 0 ) {
 		prv_bios_data = (struct private_bios_data *)megacfg->mega_buffer;
 
 		cksum = 0;
-		cksum_p = (char *)prv_bios_data;
+		cksum_p = (u8 *)prv_bios_data;
 		for( i = 0; i < 14; i++ ) {
-			cksum += (u16)(*cksum_p++);
+			cksum += *cksum_p++;
 		}
 
 		if( prv_bios_data->cksum == (u16)(0-cksum) ) {
-			megacfg->boot_ldrv_enabled = 1;
-			megacfg->boot_ldrv = prv_bios_data->boot_ldrv;
+
+			/*
+			 * If MSB is set, a physical drive is set as boot device
+			 */
+			if( prv_bios_data->boot_drv & 0x80 ) {
+				megacfg->boot_pdrv_enabled = 1;
+				boot_pdrv = prv_bios_data->boot_drv & 0x7F;
+				megacfg->boot_pdrv_ch = boot_pdrv / 16;
+				megacfg->boot_pdrv_tgt = boot_pdrv % 16;
+			}
+			else {
+				megacfg->boot_ldrv_enabled = 1;
+				megacfg->boot_ldrv = prv_bios_data->boot_drv;
+			}
 		}
 	}
 
@@ -3681,7 +3839,7 @@ const char *megaraid_info (struct Scsi_H
 	sprintf (buffer,
 		 "LSI Logic MegaRAID %s %d commands %d targs %d chans %d luns",
 		 megaCfg->fwVer, megaCfg->productInfo.MaxConcCmds,
-		 megaCfg->host->max_id, megaCfg->host->max_channel,
+		 megaCfg->host->max_id-1, megaCfg->host->max_channel,
 		 megaCfg->host->max_lun);
 	return buffer;
 }
@@ -3710,6 +3868,7 @@ int megaraid_queue (Scsi_Cmnd * SCpnt, v
 	megaCfg = (mega_host_config *) SCpnt->host->hostdata;
 	DRIVER_LOCK (megaCfg);
 
+#if 0
 	if (!(megaCfg->flag & (1L << SCpnt->channel))) {
 		if (SCpnt->channel < megaCfg->productInfo.SCSIChanPresent)
 			printk ( KERN_NOTICE
@@ -3723,6 +3882,7 @@ int megaraid_queue (Scsi_Cmnd * SCpnt, v
 
 		megaCfg->flag |= (1L << SCpnt->channel);
 	}
+#endif
 
 	SCpnt->scsi_done = pktComp;
 
@@ -4232,7 +4392,7 @@ int megaraid_biosparam (Disk * disk, kde
 	/* Get pointer to host config structure */
 	megaCfg = (mega_host_config *) disk->device->host->hostdata;
 
-	if( IS_RAID_CH(disk->device->channel)) {
+	if( IS_RAID_CH(megaCfg, disk->device->channel)) {
 			/* Default heads (64) & sectors (32) */
 			heads = 64;
 			sectors = 32;
@@ -4297,7 +4457,15 @@ mega_partsize(Disk * disk, kdev_t dev, i
 	int heads, cyls, sectors;
 	int capacity = disk->capacity;
 
-	if(!(bh = bread(MKDEV(MAJOR(dev), MINOR(dev)&~0xf), 0, block_size(dev))))
+	int ma = MAJOR(dev);
+	int mi = (MINOR(dev) & ~0xf);
+
+	int block = 1024; 
+
+	if(blksize_size[ma])
+		block = blksize_size[ma][mi];
+		
+	if(!(bh = bread(MKDEV(ma,mi), 0, block)))
 		return -1;
 
 	if( *(unsigned short *)(bh->b_data + 510) == 0xAA55 ) {
@@ -4626,9 +4794,10 @@ static int megadev_ioctl (struct inode *
 			/*
 			 * Copy struct mcontroller to user area
 			 */
-			copy_to_user (ioc.data,
+			if (copy_to_user (ioc.data,
 				      mcontroller + adapno,
-				      sizeof (struct mcontroller));
+				      sizeof (struct mcontroller)))
+				      return -EFAULT;
 			return 0;
 
 		default:
@@ -4745,7 +4914,8 @@ static int megadev_ioctl (struct inode *
 		down(&mimd_ioctl_sem);
 
 		if( !scsicmd->result && outlen ) {
-			copy_to_user(uaddr, kvaddr, length);
+			if (copy_to_user(uaddr, kvaddr, length))
+				return -EFAULT;
 		}
 
 		/*
@@ -4755,6 +4925,9 @@ static int megadev_ioctl (struct inode *
 
 		if( ioc.mbox[0] == MEGA_MBOXCMD_PASSTHRU ) {
 			put_user( scsicmd->result, &uioc->pthru.scsistatus );
+			if (copy_to_user( uioc->pthru.reqsensearea, scsicmd->sense_buffer,
+							  MAX_REQ_SENSE_LEN ));
+				ret= -EFAULT;
 		} else {
 			put_user(1, &uioc->mbox[16]);	/* numstatus */
 			/* status */
@@ -4894,9 +5067,11 @@ static int megadev_ioctl (struct inode *
 
 		if (!scsicmd->result && outlen) {
 			if (ioc.mbox[0] == MEGA_MBOXCMD_PASSTHRU) {
-				copy_to_user (uaddr, kvaddr, ioc.pthru.dataxferlen);
+				if (copy_to_user (uaddr, kvaddr, ioc.pthru.dataxferlen))	
+					ret = -EFAULT;
 			} else {
-				copy_to_user (uaddr, kvaddr, outlen);
+				if (copy_to_user (uaddr, kvaddr, outlen)) 
+					ret = -EFAULT;
 			}
 		}
 
@@ -4907,6 +5082,15 @@ static int megadev_ioctl (struct inode *
 
 		if (ioc.mbox[0] == MEGA_MBOXCMD_PASSTHRU) {
 			put_user (scsicmd->result, &uioc->pthru.scsistatus);
+
+			/*
+			 * If scsicmd->result is 0x02 (CHECK CONDITION) then copy the
+			 * SCSI sense data into user area
+			 */
+			if (copy_to_user( uioc->pthru.reqsensearea, scsicmd->sense_buffer,
+							  MAX_REQ_SENSE_LEN ))
+				ret = -EFAULT;
+							
 		} else {
 			put_user (1, &uioc->mbox[16]);	/* numstatus */
 			put_user (scsicmd->result, &uioc->mbox[17]); /* status */
@@ -4995,7 +5179,7 @@ megadev_doioctl (mega_host_config * mega
 			scb->sg64List[0].length = 4096;	// TODO: Check this
 			pthru->dataxferaddr = scb->dma_sghandle64;
 			pthru->numsgelements = 1;
-			mboxpthru->cmd = 0xC3;
+			mboxpthru->cmd = MEGA_MBOXCMD_PASSTHRU64;
 		} else {
 			mboxpthru->dataxferaddr = scb->dma_passthruhandle64;
 			pthru->dataxferaddr =


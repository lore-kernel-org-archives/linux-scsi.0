From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] megaraid 2.00.09
Date: 08 Oct 2003 07:02:46 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065576771.2684.1.camel@fuzzy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-WePd9sYt3fTfBygvVw1a"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:12548 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261176AbTJHBdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 21:33:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: atulm@lsil.com


--=-WePd9sYt3fTfBygvVw1a
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi All,

This is a patch to the megaraid driver from LSI.

James


--=-WePd9sYt3fTfBygvVw1a
Content-Disposition: attachment;
	filename*0=diff_megaraid2-2003-linux-2.6.0-test6_and_megaraid2-2009.patc;
	filename*1=h
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch;
	name=diff_megaraid2-2003-linux-2.6.0-test6_and_megaraid2-2009.patch;
	charset=ISO-8859-1

diff -Naur megaraid2-2003-linux-2.6.0-test6/megaraid.c megaraid2-2009/megar=
aid.c
--- megaraid2-2003-linux-2.6.0-test6/megaraid.c	2003-10-06 12:56:03.0000000=
00 -0400
+++ megaraid2-2009/megaraid.c	2003-10-03 17:44:58.000000000 -0400
@@ -2,7 +2,7 @@
  *
  *			Linux MegaRAID device driver
  *
- * Copyright =A9 2002  LSI Logic Corporation.
+ * Copyright =C2=A9 2002  LSI Logic Corporation.
  *
  *	   This program is free software; you can redistribute it and/or
  *	   modify it under the terms of the GNU General Public License
@@ -14,7 +14,8 @@
  *	  - speed-ups (list handling fixes, issued_list, optimizations.)
  *	  - lots of cleanups.
  *
- * Version : v2.00.3 (Feb 19, 2003) - Atul Mukker <Atul.Mukker@lsil.com>
+ * Version : v2.00.9a-kernel 2.6 (Oct 03, 2003) -
+ *					Atul Mukker <Atul.Mukker@lsil.com>
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
@@ -77,7 +78,9 @@
=20
 static int hba_count;
 static adapter_t *hba_soft_state[MAX_CONTROLLERS];
+#ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *mega_proc_dir_entry;
+#endif
=20
 static struct notifier_block mega_notifier =3D {
 	.notifier_call =3D megaraid_reboot_notify
@@ -160,16 +163,11 @@
 		PCI_VENDOR_ID_INTEL,		PCI_DEVICE_ID_AMI_MEGARAID3,=20
 		PCI_VENDOR_ID_LSI_LOGIC,	PCI_DEVICE_ID_AMI_MEGARAID3 };
=20
-	host_template->proc_name =3D "megaraid";
=20
 	printk(KERN_NOTICE "megaraid: " MEGARAID_VERSION);
=20
 	megaraid_validate_parms();
=20
-	memset(mega_hbas, 0, sizeof (mega_hbas));
-
-	hba_count =3D 0;
-
 	/*
 	 * Scan PCI bus for our all devices.
 	 */
@@ -250,6 +248,7 @@
 	u8	did_ioremap_f =3D 0;
 	u8	did_req_region_f =3D 0;
 	u8	did_scsi_reg_f =3D 0;
+	u8	got_ipdev_f =3D 0;
 	u8	alloc_int_buf_f =3D 0;
 	u8	alloc_scb_f =3D 0;
 	u8	got_irq_f =3D 0;
@@ -260,6 +259,16 @@
=20
 	while((pdev =3D pci_find_device(pci_vendor, pci_device, pdev))) {
=20
+		// reset flags for all controllers in this class
+		did_ioremap_f =3D 0;
+		did_req_region_f =3D 0;
+		did_scsi_reg_f =3D 0;
+		got_ipdev_f =3D 0;
+		alloc_int_buf_f =3D 0;
+		alloc_scb_f =3D 0;
+		got_irq_f =3D 0;
+		did_setup_mbox_f =3D 0;
+
 		if(pci_enable_device (pdev)) continue;
=20
 		pci_bus =3D pdev->bus->number;
@@ -295,6 +304,7 @@
 		if( subsysvid && (subsysvid !=3D AMI_SUBSYS_VID) &&
 				(subsysvid !=3D DELL_SUBSYS_VID) &&
 				(subsysvid !=3D HP_SUBSYS_VID) &&
+				(subsysvid !=3D INTEL_SUBSYS_VID) &&
 				(subsysvid !=3D LSI_SUBSYS_VID) ) continue;
=20
=20
@@ -358,6 +368,21 @@
 		adapter =3D (adapter_t *)host->hostdata;
 		memset(adapter, 0, sizeof(adapter_t));
=20
+		/*
+		 * Allocate a pci device structure for allocations done
+		 * internally - all of which would be in memory <4GB
+		 */
+		adapter->ipdev =3D kmalloc(sizeof(struct pci_dev), GFP_KERNEL);
+
+		if( adapter->ipdev =3D=3D NULL ) goto fail_attach;
+
+		got_ipdev_f =3D 1;
+
+		memcpy(adapter->ipdev, pdev, sizeof(struct pci_dev));
+
+		if( pci_set_dma_mask(adapter->ipdev, 0xffffffff) !=3D 0 )
+			goto fail_attach;
+
 		printk(KERN_NOTICE
 			"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
 			host->host_no, mega_baseport, irq);
@@ -367,10 +392,12 @@
 		/* Copy resource info into structure */
 		INIT_LIST_HEAD(&adapter->free_list);
 		INIT_LIST_HEAD(&adapter->pending_list);
-		INIT_LIST_HEAD(&adapter->completed_list);
=20
 		adapter->flag =3D flag;
 		spin_lock_init(&adapter->lock);
+
+		adapter->host_lock =3D &adapter->lock;
+
 		scsi_assign_lock(host, &adapter->lock);
=20
 		host->cmd_per_lun =3D max_cmd_per_lun;
@@ -593,7 +620,7 @@
 			pci_set_dma_mask(pdev, 0xffffffff);
 			adapter->has_64bit_addr =3D 0;
 		}
-	=09
+
 		init_MUTEX(&adapter->int_mtx);
 		init_waitqueue_head(&adapter->int_waitq);
=20
@@ -642,6 +669,8 @@
 					adapter->buf_dma_handle);
 		}
=20
+		if( got_ipdev_f ) kfree(adapter->ipdev);
+
 		if( did_scsi_reg_f ) scsi_unregister(host);
=20
 		if( did_ioremap_f ) {
@@ -672,7 +701,7 @@
 			sizeof(mbox64_t), &adapter->una_mbox64_dma);
=20
 	if( !adapter->una_mbox64 ) return -1;
-	=09
+
 	adapter->mbox =3D &adapter->una_mbox64->mbox;
=20
 	adapter->mbox =3D (mbox_t *)((((unsigned long) adapter->mbox) + 15) &
@@ -725,7 +754,7 @@
 {
 	dma_addr_t	prod_info_dma_handle;
 	mega_inquiry3	*inquiry3;
-	u8	raw_mbox[sizeof(struct mbox_out)];
+	u8	raw_mbox[sizeof(mbox_t)];
 	mbox_t	*mbox;
 	int	retval;
=20
@@ -734,14 +763,14 @@
 	mbox =3D (mbox_t *)raw_mbox;
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	/*
 	 * Try to issue Inquiry3 command
 	 * if not succeeded, then issue MEGA_MBOXCMD_ADAPTERINQ command and
 	 * update enquiry3 structure
 	 */
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	inquiry3 =3D (mega_inquiry3 *)adapter->mega_buffer;
=20
@@ -764,10 +793,10 @@
=20
 		inq =3D &ext_inq->raid_inq;
=20
-		mbox->m_out.xferaddr =3D (u32)dma_handle;
+		mbox->xferaddr =3D (u32)dma_handle;
=20
 		/*issue old 0x04 command to adapter */
-		mbox->m_out.cmd =3D MEGA_MBOXCMD_ADPEXTINQ;
+		mbox->cmd =3D MEGA_MBOXCMD_ADPEXTINQ;
=20
 		issue_scb_block(adapter, raw_mbox);
=20
@@ -792,7 +821,7 @@
 				&adapter->product_info,
 				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
=20
-		mbox->m_out.xferaddr =3D prod_info_dma_handle;
+		mbox->xferaddr =3D prod_info_dma_handle;
=20
 		raw_mbox[0] =3D FC_NEW_CONFIG;	/* i.e. mbox->cmd=3D0xA1 */
 		raw_mbox[2] =3D NC_SUBOP_PRODUCT_INFO;	/* i.e. 0x0E */
@@ -986,7 +1015,7 @@
 		}
 		else {
 			/* this is physical channel */
-			channel =3D cmd->device->channel;=20
+			channel =3D cmd->device->channel;
 			target =3D cmd->device->id;
=20
 			/*
@@ -1005,11 +1034,11 @@
 	else {
 		if( islogical ) {
 			/* this is the logical channel */
-			channel =3D cmd->device->channel;=09
+			channel =3D cmd->device->channel;
 		}
 		else {
 			/* physical channel */
-			channel =3D cmd->device->channel - NVIRT_CHAN;=09
+			channel =3D cmd->device->channel - NVIRT_CHAN;
 			target =3D cmd->device->id;
 		}
 	}
@@ -1143,10 +1172,10 @@
 			memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
=20
 			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU64;
+				mbox->cmd =3D MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
-				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU;
+				mbox->cmd =3D MEGA_MBOXCMD_PASSTHRU;
 			}
=20
 			scb->dma_direction =3D PCI_DMA_FROMDEVICE;
@@ -1154,7 +1183,7 @@
 			pthru->numsgelements =3D mega_build_sglist(adapter, scb,
 				&pthru->dataxferaddr, &pthru->dataxferlen);
=20
-			mbox->m_out.xferaddr =3D scb->pthru_dma_addr;
+			mbox->xferaddr =3D scb->pthru_dma_addr;
=20
 			return scb;
=20
@@ -1177,19 +1206,19 @@
 			mbox =3D (mbox_t *)scb->raw_mbox;
=20
 			memset(mbox, 0, sizeof(scb->raw_mbox));
-			mbox->m_out.logdrv =3D ldrv_num;
+			mbox->logdrv =3D ldrv_num;
=20
 			/*
 			 * A little hack: 2nd bit is zero for all scsi read
 			 * commands and is set for all scsi write commands
 			 */
 			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd =3D (*cmd->cmnd & 0x02) ?
+				mbox->cmd =3D (*cmd->cmnd & 0x02) ?
 					MEGA_MBOXCMD_LWRITE64:
 					MEGA_MBOXCMD_LREAD64 ;
 			}
 			else {
-				mbox->m_out.cmd =3D (*cmd->cmnd & 0x02) ?
+				mbox->cmd =3D (*cmd->cmnd & 0x02) ?
 					MEGA_MBOXCMD_LWRITE:
 					MEGA_MBOXCMD_LREAD ;
 			}
@@ -1198,13 +1227,13 @@
 			 * 6-byte READ(0x08) or WRITE(0x0A) cdb
 			 */
 			if( cmd->cmd_len =3D=3D 6 ) {
-				mbox->m_out.numsectors =3D (u32) cmd->cmnd[4];
-				mbox->m_out.lba =3D
+				mbox->numsectors =3D (u32) cmd->cmnd[4];
+				mbox->lba =3D
 					((u32)cmd->cmnd[1] << 16) |
 					((u32)cmd->cmnd[2] << 8) |
 					(u32)cmd->cmnd[3];
=20
-				mbox->m_out.lba &=3D 0x1FFFFF;
+				mbox->lba &=3D 0x1FFFFF;
=20
 #if MEGA_HAVE_STATS
 				/*
@@ -1215,11 +1244,11 @@
 				if (*cmd->cmnd =3D=3D READ_6) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				}
 #endif
 			}
@@ -1228,10 +1257,10 @@
 			 * 10-byte READ(0x28) or WRITE(0x2A) cdb
 			 */
 			if( cmd->cmd_len =3D=3D 10 ) {
-				mbox->m_out.numsectors =3D
+				mbox->numsectors =3D
 					(u32)cmd->cmnd[8] |
 					((u32)cmd->cmnd[7] << 8);
-				mbox->m_out.lba =3D
+				mbox->lba =3D
 					((u32)cmd->cmnd[2] << 24) |
 					((u32)cmd->cmnd[3] << 16) |
 					((u32)cmd->cmnd[4] << 8) |
@@ -1241,11 +1270,11 @@
 				if (*cmd->cmnd =3D=3D READ_10) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				}
 #endif
 			}
@@ -1254,13 +1283,13 @@
 			 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
 			 */
 			if( cmd->cmd_len =3D=3D 12 ) {
-				mbox->m_out.lba =3D
+				mbox->lba =3D
 					((u32)cmd->cmnd[2] << 24) |
 					((u32)cmd->cmnd[3] << 16) |
 					((u32)cmd->cmnd[4] << 8) |
 					(u32)cmd->cmnd[5];
=20
-				mbox->m_out.numsectors =3D
+				mbox->numsectors =3D
 					((u32)cmd->cmnd[6] << 24) |
 					((u32)cmd->cmnd[7] << 16) |
 					((u32)cmd->cmnd[8] << 8) |
@@ -1270,11 +1299,11 @@
 				if (*cmd->cmnd =3D=3D READ_12) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=3D
-						mbox->m_out.numsectors;
+						mbox->numsectors;
 				}
 #endif
 			}
@@ -1290,8 +1319,8 @@
 			}
=20
 			/* Calculate Scatter-Gather info */
-			mbox->m_out.numsgelements =3D mega_build_sglist(adapter, scb,
-					(u32 *)&mbox->m_out.xferaddr, (u32 *)&seg);
+			mbox->numsgelements =3D mega_build_sglist(adapter, scb,
+					(u32 *)&mbox->xferaddr, (u32 *)&seg);
=20
 			return scb;
=20
@@ -1359,9 +1388,9 @@
 			epthru =3D mega_prepare_extpassthru(adapter, scb, cmd,
 					channel, target);
=20
-			mbox->m_out.cmd =3D MEGA_MBOXCMD_EXTPTHRU;
+			mbox->cmd =3D MEGA_MBOXCMD_EXTPTHRU;
=20
-			mbox->m_out.xferaddr =3D scb->epthru_dma_addr;
+			mbox->xferaddr =3D scb->epthru_dma_addr;
=20
 		}
 		else {
@@ -1371,13 +1400,13 @@
=20
 			/* Initialize mailbox */
 			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU64;
+				mbox->cmd =3D MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
-				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU;
+				mbox->cmd =3D MEGA_MBOXCMD_PASSTHRU;
 			}
=20
-			mbox->m_out.xferaddr =3D scb->pthru_dma_addr;
+			mbox->xferaddr =3D scb->pthru_dma_addr;
=20
 		}
 		return scb;
@@ -1595,21 +1624,20 @@
 	volatile mbox_t		*mbox =3D adapter->mbox;
 	unsigned int	i =3D 0;
=20
-	if(unlikely(mbox->m_in.busy)) {
+	if(unlikely(mbox->busy)) {
 		do {
 			udelay(1);
 			i++;
-		} while( mbox->m_in.busy && (i < max_mbox_busy_wait) );
+		} while( mbox->busy && (i < max_mbox_busy_wait) );
=20
-		if(mbox->m_in.busy) return -1;
+		if(mbox->busy) return -1;
 	}
=20
 	/* Copy mailbox data into host structure */
-	memcpy((char *)&mbox->m_out, (char *)scb->raw_mbox,=20
-			sizeof(struct mbox_out));
+	memcpy((char *)mbox, (char *)scb->raw_mbox, 16);
=20
-	mbox->m_out.cmdid =3D scb->idx;	/* Set cmdid */
-	mbox->m_in.busy =3D 1;		/* Set busy */
+	mbox->cmdid =3D scb->idx;	/* Set cmdid */
+	mbox->busy =3D 1;		/* Set busy */
=20
=20
 	/*
@@ -1617,14 +1645,16 @@
 	 */
 	atomic_inc(&adapter->pend_cmds);
=20
-	switch (mbox->m_out.cmd) {
+	switch (mbox->cmd) {
+	case MEGA_MBOXCMD_EXTPTHRU:
+		if( !adapter->has_64bit_addr ) break;
+		// else fall through
 	case MEGA_MBOXCMD_LREAD64:
 	case MEGA_MBOXCMD_LWRITE64:
 	case MEGA_MBOXCMD_PASSTHRU64:
-	case MEGA_MBOXCMD_EXTPTHRU:
-		mbox64->xfer_segment_lo =3D mbox->m_out.xferaddr;
+		mbox64->xfer_segment_lo =3D mbox->xferaddr;
 		mbox64->xfer_segment_hi =3D 0;
-		mbox->m_out.xferaddr =3D 0xFFFFFFFF;
+		mbox->xferaddr =3D 0xFFFFFFFF;
 		break;
 	default:
 		mbox64->xfer_segment_lo =3D 0;
@@ -1637,8 +1667,8 @@
 	scb->state |=3D SCB_ISSUED;
=20
 	if( likely(adapter->flag & BOARD_MEMMAP) ) {
-		mbox->m_in.poll =3D 0;
-		mbox->m_in.ack =3D 0;
+		mbox->poll =3D 0;
+		mbox->ack =3D 0;
 		WRINDOOR(adapter, adapter->mbox_dma | 0x1);
 	}
 	else {
@@ -1663,24 +1693,28 @@
 	volatile mbox64_t *mbox64 =3D adapter->mbox64;
 	volatile mbox_t *mbox =3D adapter->mbox;
 	u8	byte;
+	u8	status;
+	int	i;
=20
 	/* Wait until mailbox is free */
 	if(mega_busywait_mbox (adapter))
 		goto bug_blocked_mailbox;
=20
 	/* Copy mailbox data into host structure */
-	memcpy((char *) mbox, raw_mbox, sizeof(struct mbox_out));
-	mbox->m_out.cmdid =3D 0xFE;
-	mbox->m_in.busy =3D 1;
+	memcpy((char *) mbox, raw_mbox, 16);
+	mbox->cmdid =3D 0xFE;
+	mbox->busy =3D 1;
=20
 	switch (raw_mbox[0]) {
+	case MEGA_MBOXCMD_EXTPTHRU:
+		if( !adapter->has_64bit_addr ) break;
+		// else fall through
 	case MEGA_MBOXCMD_LREAD64:
 	case MEGA_MBOXCMD_LWRITE64:
 	case MEGA_MBOXCMD_PASSTHRU64:
-	case MEGA_MBOXCMD_EXTPTHRU:
-		mbox64->xfer_segment_lo =3D mbox->m_out.xferaddr;
+		mbox64->xfer_segment_lo =3D mbox->xferaddr;
 		mbox64->xfer_segment_hi =3D 0;
-		mbox->m_out.xferaddr =3D 0xFFFFFFFF;
+		mbox->xferaddr =3D 0xFFFFFFFF;
 		break;
 	default:
 		mbox64->xfer_segment_lo =3D 0;
@@ -1688,22 +1722,28 @@
 	}
=20
 	if( likely(adapter->flag & BOARD_MEMMAP) ) {
-		mbox->m_in.poll =3D 0;
-		mbox->m_in.ack =3D 0;
-		mbox->m_in.numstatus =3D 0xFF;
-		mbox->m_in.status =3D 0xFF;
+		mbox->poll =3D 0;
+		mbox->ack =3D 0;
+		mbox->numstatus =3D 0xFF;
+		mbox->status =3D 0xFF;
 		WRINDOOR(adapter, adapter->mbox_dma | 0x1);
=20
-		while((volatile u8)mbox->m_in.numstatus =3D=3D 0xFF)
+		while (mbox->numstatus =3D=3D 0xFF)
 			cpu_relax();
=20
-		mbox->m_in.numstatus =3D 0xFF;
+		mbox->numstatus =3D 0xFF;
=20
-		while( (volatile u8)mbox->m_in.poll !=3D 0x77 )
+		while (mbox->status =3D=3D 0xFF)
 			cpu_relax();
=20
-		mbox->m_in.poll =3D 0;
-		mbox->m_in.ack =3D 0x77;
+		status =3D mbox->status;
+		mbox->status =3D 0xFF;
+
+		while (mbox->poll !=3D 0x77 )
+			cpu_relax();
+
+		mbox->poll =3D 0;
+		mbox->ack =3D 0x77;
=20
 		WRINDOOR(adapter, adapter->mbox_dma | 0x2);
=20
@@ -1717,12 +1757,22 @@
 		while (!((byte =3D irq_state(adapter)) & INTR_VALID))
 			cpu_relax();
=20
+		status =3D mbox->status;
+		mbox->numstatus =3D 0xFF;
+		mbox->status =3D 0xFF;
+
 		set_irq_state(adapter, byte);
 		irq_enable(adapter);
 		irq_ack(adapter);
 	}
=20
-	return mbox->m_in.status;
+	// invalidate the completed command id array. After command
+	// completion, firmware would write the valid id.
+	for (i =3D 0; i < MAX_FIRMWARE_STATUS; i++) {
+		mbox->completed[i] =3D 0xFF;
+	}
+
+	return status;
=20
 bug_blocked_mailbox:
 	printk(KERN_WARNING "megaraid: Blocked mailbox......!!\n");
@@ -1746,65 +1796,86 @@
 {
 	adapter_t	*adapter =3D devp;
 	unsigned long	flags;
+	int		rval;
+
+
+	spin_lock_irqsave(adapter->host_lock, flags);
+
+	rval =3D megaraid_iombox_ack_sequence(adapter);
+
+	/* Loop through any pending requests */
+	if( atomic_read(&adapter->quiescent ) =3D=3D 0) {
+		mega_runpendq(adapter);
+	}
+
+	spin_unlock_irqrestore(adapter->host_lock, flags);
+
+	return IRQ_RETVAL(rval);
+}
+
+
+/**
+ * megaraid_iombox_ack_sequence - interrupt ack sequence for IO mapped HBA=
s
+ * @adapter	- controller's soft state
+ *
+ * Interrupt ackrowledgement sequence for IO mapped HBAs
+ */
+static inline int
+megaraid_iombox_ack_sequence(adapter_t *adapter)
+{
 	u8	status;
 	u8	nstatus;
 	u8	completed[MAX_FIRMWARE_STATUS];
 	u8	byte;
-	int	handled =3D 0;
+	int	i;
+	int	irq_handled =3D 0;
=20
=20
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
-
 	do {
 		/* Check if a valid interrupt is pending */
 		byte =3D irq_state(adapter);
 		if( (byte & VALID_INTR_BYTE) =3D=3D 0 ) {
-			/*
-			 * No more pending commands
-			 */
-			goto out_unlock;
+			return irq_handled;
 		}
 		set_irq_state(adapter, byte);
=20
-		while((nstatus =3D (volatile u8)adapter->mbox->m_in.numstatus)
-				=3D=3D 0xFF)
+		while ((nstatus =3D adapter->mbox->numstatus) =3D=3D 0xFF) {
 			cpu_relax();
-		adapter->mbox->m_in.numstatus =3D 0xFF;
+		}
+		adapter->mbox->numstatus =3D 0xFF;
+
+		for (i =3D 0; i < nstatus; i++) {
+			while ((completed[i] =3D adapter->mbox->completed[i])
+					=3D=3D 0xFF) {
+				cpu_relax();
+			}
+
+			adapter->mbox->completed[i] =3D 0xFF;
+		}
=20
-		status =3D adapter->mbox->m_in.status;
+		// we must read the valid status now
+		if ((status =3D adapter->mbox->status) =3D=3D 0xFF) {
+			printk(KERN_WARNING
+			"megaraid critical: status 0xFF from firmware.\n");
+		}
+		adapter->mbox->status =3D 0xFF;
=20
 		/*
 		 * decrement the pending queue counter
 		 */
 		atomic_sub(nstatus, &adapter->pend_cmds);
=20
-		memcpy(completed, (void *)adapter->mbox->m_in.completed,=20
-				nstatus);
-
 		/* Acknowledge interrupt */
 		irq_ack(adapter);
=20
 		mega_cmd_done(adapter, completed, nstatus, status);
=20
-		mega_rundoneq(adapter);
-
-		handled =3D 1;
-
-		/* Loop through any pending requests */
-		if(atomic_read(&adapter->quiescent) =3D=3D 0) {
-			mega_runpendq(adapter);
-		}
+		irq_handled =3D 1;
=20
 	} while(1);
-
- out_unlock:
-
-	spin_unlock_irqrestore(&adapter->lock, flags);
-
-	return IRQ_RETVAL(handled);
 }
=20
=20
@@ -1823,69 +1894,94 @@
 {
 	adapter_t	*adapter =3D devp;
 	unsigned long	flags;
+	int		rval;
+
+
+	spin_lock_irqsave(adapter->host_lock, flags);
+
+	rval =3D megaraid_memmbox_ack_sequence(adapter);
+
+	/* Loop through any pending requests */
+	if(atomic_read(&adapter->quiescent) =3D=3D 0) {
+		mega_runpendq(adapter);
+	}
+
+	spin_unlock_irqrestore(adapter->host_lock, flags);
+
+	return IRQ_RETVAL(rval);
+}
+
+
+/**
+ * megaraid_memmbox_ack_sequence - interrupt ack sequence for memory mappe=
d HBAs
+ * @adapter	- controller's soft state
+ *
+ * Interrupt ackrowledgement sequence for memory mapped HBAs
+ */
+static inline int
+megaraid_memmbox_ack_sequence(adapter_t *adapter)
+{
 	u8	status;
 	u32	dword =3D 0;
 	u8	nstatus;
 	u8	completed[MAX_FIRMWARE_STATUS];
-	int	handled =3D 0;
+	int	i;
+	int	irq_handled =3D 0;
=20
=20
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
-
 	do {
 		/* Check if a valid interrupt is pending */
 		dword =3D RDOUTDOOR(adapter);
-		if(dword !=3D 0x10001234) {
+		if( dword !=3D 0x10001234 ) {
 			/*
 			 * No more pending commands
 			 */
-			goto out_unlock;
+			return irq_handled;
 		}
 		WROUTDOOR(adapter, 0x10001234);
=20
-		while((nstatus =3D (volatile u8)adapter->mbox->m_in.numstatus)
-				=3D=3D 0xFF) {
+		while ((nstatus =3D adapter->mbox->numstatus) =3D=3D 0xFF) {
 			cpu_relax();
 		}
-		adapter->mbox->m_in.numstatus =3D 0xFF;
+		adapter->mbox->numstatus =3D 0xFF;
=20
-		status =3D adapter->mbox->m_in.status;
+		for (i =3D 0; i < nstatus; i++ ) {
+			while ((completed[i] =3D adapter->mbox->completed[i])
+					=3D=3D 0xFF) {
+				cpu_relax();
+			}
+
+			adapter->mbox->completed[i] =3D 0xFF;
+		}
+
+		// we must read the valid status now
+		if ((status =3D adapter->mbox->status) =3D=3D 0xFF) {
+			printk(KERN_WARNING
+			"megaraid critical: status 0xFF from firmware.\n");
+		}
+		adapter->mbox->status =3D 0xFF;
=20
 		/*
 		 * decrement the pending queue counter
 		 */
 		atomic_sub(nstatus, &adapter->pend_cmds);
=20
-		memcpy(completed, (void *)adapter->mbox->m_in.completed,=20
-				nstatus);
-
 		/* Acknowledge interrupt */
 		WRINDOOR(adapter, 0x2);
=20
-		handled =3D 1;
-
 		while( RDINDOOR(adapter) & 0x02 ) cpu_relax();
=20
 		mega_cmd_done(adapter, completed, nstatus, status);
=20
-		mega_rundoneq(adapter);
-
-		/* Loop through any pending requests */
-		if(atomic_read(&adapter->quiescent) =3D=3D 0) {
-			mega_runpendq(adapter);
-		}
+		irq_handled =3D 1;
=20
 	} while(1);
+}
=20
- out_unlock:
-
-	spin_unlock_irqrestore(&adapter->lock, flags);
=20
-	return IRQ_RETVAL(handled);
-}
 /**
  * mega_cmd_done()
  * @adapter - pointer to our soft state
@@ -1903,9 +1999,9 @@
 	Scsi_Cmnd	*cmd =3D NULL;
 	mega_passthru	*pthru =3D NULL;
 	mbox_t	*mbox =3D NULL;
+	int	islogical;
 	u8	c;
 	scb_t	*scb;
-	int	islogical;
 	int	cmdid;
 	int	i;
=20
@@ -1931,6 +2027,10 @@
 		}
 		else {
 			scb =3D &adapter->scb_list[cmdid];
+			cmd =3D scb->cmd;
+			pthru =3D scb->pthru;
+			epthru =3D scb->epthru;
+			mbox =3D (mbox_t *)scb->raw_mbox;
=20
 			/*
 			 * Make sure f/w has completed a valid command
@@ -1945,21 +2045,20 @@
 			}
=20
 			/*
-			 * Was a abort issued for this command
+			 * Was an abort issued for this command
 			 */
 			if( scb->state & SCB_ABORT ) {
=20
-				printk(KERN_WARNING
+				printk(KERN_NOTICE
 				"megaraid: aborted cmd %lx[%x] complete.\n",
 					scb->cmd->serial_number, scb->idx);
=20
-				scb->cmd->result =3D (DID_ABORT << 16);
-
-				list_add_tail(SCSI_LIST(scb->cmd),
-						&adapter->completed_list);
+				cmd->result =3D (DID_ABORT << 16);
=20
 				mega_free_scb(adapter, scb);
=20
+				cmd->scsi_done(cmd);
+
 				continue;
 			}
=20
@@ -1974,25 +2073,20 @@
=20
 				scb->cmd->result =3D (DID_RESET << 16);
=20
-				list_add_tail(SCSI_LIST(scb->cmd),
-						&adapter->completed_list);
-
 				mega_free_scb (adapter, scb);
=20
+				cmd->scsi_done(cmd);
+
 				continue;
 			}
=20
-			cmd =3D scb->cmd;
-			pthru =3D scb->pthru;
-			epthru =3D scb->epthru;
-			mbox =3D (mbox_t *)scb->raw_mbox;
-
 #if MEGA_HAVE_STATS
 			{
=20
-			int	logdrv =3D mbox->m_out.logdrv;
+			int	logdrv =3D mbox->logdrv;
=20
 			islogical =3D adapter->logdrv_chan[cmd->channel];
+
 			/*
 			 * Maintain an error counter for the logical drive.
 			 * Some application like SNMP agent need such
@@ -2029,7 +2123,7 @@
 		 * PJ
 		 */
 		islogical =3D adapter->logdrv_chan[cmd->device->channel];
-		if( cmd->cmnd[0] =3D=3D INQUIRY && !islogical ) {
+		if (cmd->cmnd[0] =3D=3D INQUIRY && !islogical) {
=20
 			if( cmd->use_sg ) {
 				sgl =3D (struct scatterlist *)
@@ -2037,8 +2131,8 @@
=20
 				if( sgl->page ) {
 					c =3D *(unsigned char *)
-					page_address((&sgl[0])->page) +
-					(&sgl[0])->offset;=20
+						page_address((&sgl[0])->page) +
+						(&sgl[0])->offset;
 				}
 				else {
 					printk(KERN_WARNING
@@ -2069,8 +2163,8 @@
 				   SCSI_STATUS_CHECK_CONDITION */
=20
 			/* set sense_buffer and result fields */
-			if( mbox->m_out.cmd =3D=3D MEGA_MBOXCMD_PASSTHRU ||
-				mbox->m_out.cmd =3D=3D MEGA_MBOXCMD_PASSTHRU64 ) {
+			if( mbox->cmd =3D=3D MEGA_MBOXCMD_PASSTHRU ||
+				mbox->cmd =3D=3D MEGA_MBOXCMD_PASSTHRU64 ) {
=20
 				memcpy(cmd->sense_buffer, pthru->reqsensearea,
 						14);
@@ -2080,7 +2174,7 @@
 					(CHECK_CONDITION << 1);
 			}
 			else {
-				if (mbox->m_out.cmd =3D=3D MEGA_MBOXCMD_EXTPTHRU) {
+				if (mbox->cmd =3D=3D MEGA_MBOXCMD_EXTPTHRU) {
=20
 					memcpy(cmd->sense_buffer,
 						epthru->reqsensearea, 14);
@@ -2148,32 +2242,11 @@
 			mega_free_scb(adapter, scb);
 		}
=20
-		/* Add Scsi_Command to end of completed queue */
-		list_add_tail(SCSI_LIST(cmd), &adapter->completed_list);
-	}
-}
-
-
-/*
- * mega_runpendq()
- *
- * Run through the list of completed requests and finish it
- */
-static void
-mega_rundoneq (adapter_t *adapter)
-{
-	Scsi_Cmnd *cmd;
-	struct list_head *pos;
-
-	list_for_each(pos, &adapter->completed_list) {
-
-		Scsi_Pointer* spos =3D (Scsi_Pointer *)pos;
-
-		cmd =3D list_entry(spos, Scsi_Cmnd, SCp);
+		/*
+		 * Call the mid-layer callback for this command
+		 */
 		cmd->scsi_done(cmd);
 	}
-
-	INIT_LIST_HEAD(&adapter->completed_list);
 }
=20
=20
@@ -2194,8 +2267,7 @@
 			scb->cmd->request_bufflen, scb->dma_direction);
=20
 		if( scb->dma_direction =3D=3D PCI_DMA_FROMDEVICE ) {
-			pci_dma_sync_single(adapter->dev,
-					scb->dma_h_bulkdata,
+			pci_dma_sync_single(adapter->dev, scb->dma_h_bulkdata,
 					scb->cmd->request_bufflen,
 					PCI_DMA_FROMDEVICE);
 		}
@@ -2207,8 +2279,7 @@
 			scb->cmd->use_sg, scb->dma_direction);
=20
 		if( scb->dma_direction =3D=3D PCI_DMA_FROMDEVICE ) {
-			pci_dma_sync_sg(adapter->dev,
-					scb->cmd->request_buffer,
+			pci_dma_sync_sg(adapter->dev, scb->cmd->request_buffer,
 					scb->cmd->use_sg, PCI_DMA_FROMDEVICE);
 		}
=20
@@ -2237,7 +2308,7 @@
 static inline int
 mega_busywait_mbox (adapter_t *adapter)
 {
-	if (adapter->mbox->m_in.busy)
+	if (adapter->mbox->busy)
 		return __mega_busywait_mbox(adapter);
 	return 0;
 }
@@ -2249,7 +2320,7 @@
 	long counter;
=20
 	for (counter =3D 0; counter < 10000; counter++) {
-		if (!mbox->m_in.busy)
+		if (!mbox->busy)
 			return 0;
 		udelay(100); yield();
 	}
@@ -2278,8 +2349,7 @@
 		page =3D virt_to_page(cmd->request_buffer);
 		offset =3D offset_in_page(cmd->request_buffer);
=20
-		scb->dma_h_bulkdata =3D pci_map_page(adapter->dev,
-						  page, offset,
+		scb->dma_h_bulkdata =3D pci_map_page(adapter->dev, page, offset,
 						  cmd->request_bufflen,
 						  scb->dma_direction);
 		scb->dma_type =3D MEGA_BULK_DATA;
@@ -2317,8 +2387,7 @@
 	 *
 	 * The number of sg elements returned must not exceed our limit
 	 */
-	sgcnt =3D pci_map_sg(adapter->dev, sgl, cmd->use_sg,
-			scb->dma_direction);
+	sgcnt =3D pci_map_sg(adapter->dev, sgl, cmd->use_sg, scb->dma_direction);
=20
 	scb->dma_type =3D MEGA_SGLIST;
=20
@@ -2395,6 +2464,7 @@
 		enquiry3->pdrv_state[i] =3D inquiry->pdrv_info.pdrv_state[i];
 }
=20
+
 /*
  * Release the controller's resources
  */
@@ -2403,8 +2473,10 @@
 {
 	adapter_t	*adapter;
 	mbox_t	*mbox;
-	u_char	raw_mbox[sizeof(struct mbox_out)];
+	u_char	raw_mbox[sizeof(mbox_t)];
+#ifdef CONFIG_PROC_FS
 	char	buf[12] =3D { 0 };
+#endif
=20
 	adapter =3D (adapter_t *)host->hostdata;
 	mbox =3D (mbox_t *)raw_mbox;
@@ -2412,7 +2484,7 @@
 	printk(KERN_NOTICE "megaraid: being unloaded...");
=20
 	/* Flush adapter cache */
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
 	raw_mbox[0] =3D FLUSH_ADAPTER;
=20
 	irq_disable(adapter);
@@ -2422,7 +2494,7 @@
 	issue_scb_block(adapter, raw_mbox);
=20
 	/* Flush disks cache */
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
 	raw_mbox[0] =3D FLUSH_SYSTEM;
=20
 	/* Issue a blocking (interrupts disabled) command to the card */
@@ -2483,6 +2555,8 @@
 	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
 			(void *)adapter->una_mbox64, adapter->una_mbox64_dma);
=20
+	kfree(adapter->ipdev);
+
 	hba_count--;
=20
 	if( hba_count =3D=3D 0 ) {
@@ -2572,25 +2646,106 @@
 	return buffer;
 }
=20
-/*
+
+/**
+ * megaraid_abort - abort the scsi command
+ * @scp	- command to be aborted
+ *
  * Abort a previous SCSI request. Only commands on the pending list can be
  * aborted. All the commands issued to the F/W must complete.
  */
 static int
-megaraid_abort(Scsi_Cmnd *cmd)
+megaraid_abort(Scsi_Cmnd *scp)
 {
-	adapter_t	*adapter;
-	int		rval;
+	adapter_t		*adapter;
+	struct list_head	*pos, *next;
+	scb_t			*scb;
+	long			iter;
+	int			rval =3D SUCCESS;
=20
-	adapter =3D (adapter_t *)cmd->device->host->hostdata;
+	adapter =3D (adapter_t *)scp->device->host->hostdata;
+
+	ASSERT( spin_is_locked(adapter->host_lock) );
=20
-	rval =3D  megaraid_abort_and_reset(adapter, cmd, SCB_ABORT);
+	printk("megaraid: aborting-%ld cmd=3D%x <c=3D%d t=3D%d l=3D%d>\n",
+		scp->serial_number, scp->cmnd[0], scp->device->channel,
+		scp->device->id, scp->device->lun);
+
+
+	list_for_each_safe( pos, next, &adapter->pending_list ) {
+
+		scb =3D list_entry(pos, scb_t, list);
+
+		if( scb->cmd =3D=3D scp ) { /* Found command */
+
+			scb->state |=3D SCB_ABORT;
+
+			/*
+			 * Check if this command was never issued. If this is
+			 * the case, take it off from the pending list and
+			 * complete.
+			 */
+			if( !(scb->state & SCB_ISSUED) ) {
+
+				printk(KERN_WARNING
+				"megaraid: %ld:%d, driver owner.\n",
+					scp->serial_number, scb->idx);
+
+				scp->result =3D (DID_ABORT << 16);
+
+				mega_free_scb(adapter, scb);
+
+				scp->scsi_done(scp);
+
+				break;
+			}
+		}
+	}
=20
 	/*
-	 * This is required here to complete any completed requests
-	 * to be communicated over to the mid layer.
+	 * By this time, either all commands are completed or aborted by
+	 * mid-layer. Do not return until all the commands are actually
+	 * completed by the firmware
 	 */
-	mega_rundoneq(adapter);
+	iter =3D 0;
+	while( atomic_read(&adapter->pend_cmds) > 0 ) {
+		/*
+		 * Perform the ack sequence, since interrupts are not
+		 * available right now!
+		 */
+		if( adapter->flag & BOARD_MEMMAP ) {
+			megaraid_memmbox_ack_sequence(adapter);
+		}
+		else {
+			megaraid_iombox_ack_sequence(adapter);
+		}
+
+		/*
+		 * print a message once every second only
+		 */
+		if( !(iter % 1000) ) {
+			printk(
+			"megaraid: Waiting for %d commands to flush: iter:%ld\n",
+				atomic_read(&adapter->pend_cmds), iter);
+		}
+
+		if( iter++ < MBOX_ABORT_SLEEP*1000 ) {
+			mdelay(1);
+		}
+		else {
+			printk(KERN_WARNING
+				"megaraid: critical hardware error!\n");
+
+			rval =3D FAILED;
+
+			break;
+		}
+	}
+
+	if( rval =3D=3D SUCCESS ) {
+		printk(KERN_INFO
+			"megaraid: abort sequence successfully complete.\n");
+	}
=20
 	return rval;
 }
@@ -2601,15 +2756,23 @@
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
-	int		rval;
+	long		iter;
+	int		rval =3D SUCCESS;
=20
 	adapter =3D (adapter_t *)cmd->device->host->hostdata;
=20
+	ASSERT( spin_is_locked(adapter->host_lock) );
+
+	printk("megaraid: reset-%ld cmd=3D%x <c=3D%d t=3D%d l=3D%d>\n",
+		cmd->serial_number, cmd->cmnd[0], cmd->device->channel,
+		cmd->device->id, cmd->device->lun);
+
+
 #if MEGA_HAVE_CLUSTERING
 	mc.cmd =3D MEGA_CLUSTER_CMD;
 	mc.opcode =3D MEGA_RESET_RESERVATIONS;
=20
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock_irq(adapter->host_lock);
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) !=3D 0 ) {
 		printk(KERN_WARNING
 				"megaraid: reservation reset failed.\n");
@@ -2617,97 +2780,54 @@
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
 	}
-	spin_lock_irq(&adapter->lock);
+	spin_lock_irq(adapter->host_lock);
 #endif
=20
-	rval =3D  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
-
 	/*
-	 * This is required here to complete any completed requests
-	 * to be communicated over to the mid layer.
+	 * Do not return until all the commands are actually completed by the
+	 * firmware
 	 */
-	mega_rundoneq(adapter);
-
-	return rval;
-}
-
-
-
-/**
- * megaraid_abort_and_reset()
- * @adapter - megaraid soft state
- * @cmd - scsi command to be aborted or reset
- * @aor - abort or reset flag
- *
- * Try to locate the scsi command in the pending queue. If found and is no=
t
- * issued to the controller, abort/reset it. Otherwise return failure
- */
-static int
-megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
-{
-	struct list_head	*pos, *next;
-	scb_t			*scb;
-
-	printk(KERN_WARNING "megaraid: %s-%lx cmd=3D%x <c=3D%d t=3D%d l=3D%d>\n",
-	     (aor =3D=3D SCB_ABORT)? "ABORTING":"RESET", cmd->serial_number,
-	     cmd->cmnd[0], cmd->device->channel,=20
-	     cmd->device->id, cmd->device->lun);
-
-	if(list_empty(&adapter->pending_list))
-		return FALSE;
-
-	list_for_each_safe(pos, next, &adapter->pending_list) {
-
-		scb =3D list_entry(pos, scb_t, list);
-
-		if (scb->cmd =3D=3D cmd) { /* Found command */
-
-			scb->state |=3D aor;
-
-			/*
-			 * Check if this command has firmare owenership. If
-			 * yes, we cannot reset this command. Whenever, f/w
-			 * completes this command, we will return appropriate
-			 * status from ISR.
-			 */
-			if( scb->state & SCB_ISSUED ) {
-
-				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], fw owner.\n",
-					(aor=3D=3DSCB_ABORT) ? "ABORTING":"RESET",
-					cmd->serial_number, scb->idx);
-
-				return FALSE;
-			}
-			else {
-
-				/*
-				 * Not yet issued! Remove from the pending
-				 * list
-				 */
-				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], driver owner.\n",
-					(aor=3D=3DSCB_ABORT) ? "ABORTING":"RESET",
-					cmd->serial_number, scb->idx);
+	iter =3D 0;
+	while( atomic_read(&adapter->pend_cmds) > 0 ) {
+		/*
+		 * Perform the ack sequence, since interrupts are not
+		 * available right now!
+		 */
+		if( adapter->flag & BOARD_MEMMAP ) {
+			megaraid_memmbox_ack_sequence(adapter);
+		}
+		else {
+			megaraid_iombox_ack_sequence(adapter);
+		}
=20
-				mega_free_scb(adapter, scb);
+		/*
+		 * print a message once every second only
+		 */
+		if( !(iter % 1000) ) {
+			printk(
+			"megaraid: Waiting for %d commands to flush: iter:%ld\n",
+				atomic_read(&adapter->pend_cmds), iter);
+		}
=20
-				if( aor =3D=3D SCB_ABORT ) {
-					cmd->result =3D (DID_ABORT << 16);
-				}
-				else {
-					cmd->result =3D (DID_RESET << 16);
-				}
+		if( iter++ < MBOX_RESET_SLEEP*1000 ) {
+			mdelay(1);
+		}
+		else {
+			printk(KERN_WARNING
+				"megaraid: critical hardware error!\n");
=20
-				list_add_tail(SCSI_LIST(cmd),
-						&adapter->completed_list);
+			rval =3D FAILED;
=20
-				return TRUE;
-			}
+			break;
 		}
 	}
=20
-	return FALSE;
+	if( rval =3D=3D SUCCESS ) {
+		printk(KERN_INFO
+			"megaraid: reset sequence successfully complete.\n");
+	}
+
+	return rval;
 }
=20
=20
@@ -2953,24 +3073,16 @@
 	int	len =3D 0;
=20
 	len =3D sprintf(page, "Contents of Mail Box Structure\n");
-	len +=3D sprintf(page+len, "  Fw Command   =3D 0x%02x\n",=20
-			mbox->m_out.cmd);
-	len +=3D sprintf(page+len, "  Cmd Sequence =3D 0x%02x\n",=20
-			mbox->m_out.cmdid);
-	len +=3D sprintf(page+len, "  No of Sectors=3D %04d\n",=20
-			mbox->m_out.numsectors);
-	len +=3D sprintf(page+len, "  LBA          =3D 0x%02x\n",=20
-			mbox->m_out.lba);
-	len +=3D sprintf(page+len, "  DTA          =3D 0x%08x\n",=20
-			mbox->m_out.xferaddr);
-	len +=3D sprintf(page+len, "  Logical Drive=3D 0x%02x\n",=20
-			mbox->m_out.logdrv);
+	len +=3D sprintf(page+len, "  Fw Command   =3D 0x%02x\n", mbox->cmd);
+	len +=3D sprintf(page+len, "  Cmd Sequence =3D 0x%02x\n", mbox->cmdid);
+	len +=3D sprintf(page+len, "  No of Sectors=3D %04d\n", mbox->numsectors)=
;
+	len +=3D sprintf(page+len, "  LBA          =3D 0x%02x\n", mbox->lba);
+	len +=3D sprintf(page+len, "  DTA          =3D 0x%08x\n", mbox->xferaddr)=
;
+	len +=3D sprintf(page+len, "  Logical Drive=3D 0x%02x\n", mbox->logdrv);
 	len +=3D sprintf(page+len, "  No of SG Elmt=3D 0x%02x\n",
-			mbox->m_out.numsgelements);
-	len +=3D sprintf(page+len, "  Busy         =3D %01x\n",=20
-			mbox->m_in.busy);
-	len +=3D sprintf(page+len, "  Status       =3D 0x%02x\n",=20
-			mbox->m_in.status);
+			mbox->numsgelements);
+	len +=3D sprintf(page+len, "  Busy         =3D %01x\n", mbox->busy);
+	len +=3D sprintf(page+len, "  Status       =3D 0x%02x\n", mbox->status);
=20
 	*eof =3D 1;
=20
@@ -2999,13 +3111,9 @@
 	struct pci_dev	*pdev;
 	int	len =3D 0;
=20
-	if( make_local_pdev(adapter, &pdev) !=3D 0 ) {
-		*eof =3D 1;
-		return len;
-	}
+	pdev =3D adapter->ipdev;
=20
 	if( (inquiry =3D mega_allocate_inquiry(&dma_handle, pdev)) =3D=3D NULL ) =
{
-		free_local_pdev(pdev);
 		*eof =3D 1;
 		return len;
 	}
@@ -3018,8 +3126,6 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		*eof =3D 1;
=20
 		return len;
@@ -3038,8 +3144,6 @@
=20
 	mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-	free_local_pdev(pdev);
-
 	*eof =3D 1;
=20
 	return len;
@@ -3069,13 +3173,9 @@
 	char	str[256];
 	int	len =3D 0;
=20
-	if( make_local_pdev(adapter, &pdev) !=3D 0 ) {
-		*eof =3D 1;
-		return len;
-	}
+	pdev =3D adapter->ipdev;
=20
 	if( (inquiry =3D mega_allocate_inquiry(&dma_handle, pdev)) =3D=3D NULL ) =
{
-		free_local_pdev(pdev);
 		*eof =3D 1;
 		return len;
 	}
@@ -3088,8 +3188,6 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		*eof =3D 1;
=20
 		return len;
@@ -3137,8 +3235,6 @@
=20
 	mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-	free_local_pdev(pdev);
-
 	*eof =3D 1;
=20
 	return len;
@@ -3260,12 +3356,9 @@
 	char	str[80];
 	int	i;
=20
-	if( make_local_pdev(adapter, &pdev) !=3D 0 ) {
-		return len;
-	}
+	pdev =3D adapter->ipdev;
=20
 	if( (inquiry =3D mega_allocate_inquiry(&dma_handle, pdev)) =3D=3D NULL ) =
{
-		free_local_pdev(pdev);
 		return len;
 	}
=20
@@ -3277,8 +3370,6 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		return len;
 	}
=20
@@ -3290,8 +3381,6 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		return len;
 	}
=20
@@ -3374,8 +3463,6 @@
=20
 	mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-	free_local_pdev(pdev);
-
 	return len;
 }
=20
@@ -3543,13 +3630,11 @@
 	u32	array_sz;
 	int	len =3D 0;
 	int	i;
+	u8	span8_flag =3D 1;
=20
-	if( make_local_pdev(adapter, &pdev) !=3D 0 ) {
-		return len;
-	}
+	pdev =3D adapter->ipdev;
=20
 	if( (inquiry =3D mega_allocate_inquiry(&dma_handle, pdev)) =3D=3D NULL ) =
{
-		free_local_pdev(pdev);
 		return len;
 	}
=20
@@ -3561,14 +3646,13 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		return len;
 	}
=20
 	memset(&mc, 0, sizeof(megacmd_t));
=20
 	if( adapter->flag & BOARD_40LD ) {
+	=09
 		array_sz =3D sizeof(disk_array_40ld);
=20
 		rdrv_state =3D ((mega_inquiry3 *)inquiry)->ldrv_state;
@@ -3576,7 +3660,12 @@
 		num_ldrv =3D ((mega_inquiry3 *)inquiry)->num_ldrv;
 	}
 	else {
-		array_sz =3D sizeof(disk_array_8ld);
+		/*
+		 * 'array_sz' is either the size of diskarray_span4_t or the
+		 * size of disk_array_span8_t. We use span8_t's size because
+		 * it is bigger of the two.
+		 */
+		array_sz =3D sizeof( diskarray_span8_t );
=20
 		rdrv_state =3D ((mraid_ext_inquiry *)inquiry)->
 			raid_inq.logdrv_info.ldrv_state;
@@ -3593,8 +3682,6 @@
=20
 		mega_free_inquiry(inquiry, dma_handle, pdev);
=20
-		free_local_pdev(pdev);
-
 		return len;
 	}
=20
@@ -3613,17 +3700,22 @@
 			pci_free_consistent(pdev, array_sz, disk_array,
 					disk_array_dma_handle);
=20
-			free_local_pdev(pdev);
-
 			return len;
 		}
=20
 	}
 	else {
+		/*
+		 * Try 8-Span "read config" command
+		 */
 		mc.cmd =3D NEW_READ_CONFIG_8LD;
=20
 		if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) ) {
=20
+			/*
+			 * 8-Span command failed; try 4-Span command
+			 */
+			span8_flag =3D 0;
 			mc.cmd =3D READ_CONFIG_8LD;
=20
 			if( mega_internal_command(adapter, LOCK_INT, &mc,
@@ -3638,8 +3730,6 @@
 						disk_array,
 						disk_array_dma_handle);
=20
-				free_local_pdev(pdev);
-
 				return len;
 			}
 		}
@@ -3652,8 +3742,14 @@
 			&((disk_array_40ld *)disk_array)->ldrv[i].lparam;
 		}
 		else {
-			lparam =3D
-			&((disk_array_8ld *)disk_array)->ldrv[i].lparam;
+			if( span8_flag ) {
+				lparam =3D (logdrv_param*) &((diskarray_span8_t*)
+						(disk_array))->log_drv[i];
+			}
+			else {
+				lparam =3D (logdrv_param*) &((diskarray_span4_t*)
+						(disk_array))->log_drv[i];
+			}=09
 		}
=20
 		/*
@@ -3764,8 +3860,6 @@
 	pci_free_consistent(pdev, array_sz, disk_array,
 			disk_array_dma_handle);
=20
-	free_local_pdev(pdev);
-
 	return len;
 }
=20
@@ -3848,6 +3942,7 @@
 	return 0;
 }
=20
+
 /**
  * megaraid_reboot_notify()
  * @this - unused
@@ -3863,9 +3958,9 @@
 {
 	adapter_t *adapter;
 	struct Scsi_Host *host;
-	u8 raw_mbox[sizeof(struct mbox_out)];
+	u8 raw_mbox[sizeof(mbox_t)];
 	mbox_t *mbox;
-	int i,j;
+	int i;
=20
 	/*
 	 * Flush the controller's cache irrespective of the codes coming down.
@@ -3879,7 +3974,7 @@
 		mbox =3D (mbox_t *)raw_mbox;
=20
 		/* Flush adapter cache */
-		memset(&mbox->m_out, 0, sizeof(raw_mbox));
+		memset(raw_mbox, 0, sizeof(raw_mbox));
 		raw_mbox[0] =3D FLUSH_ADAPTER;
=20
 		irq_disable(adapter);
@@ -3892,7 +3987,7 @@
 		issue_scb_block(adapter, raw_mbox);
=20
 		/* Flush disks cache */
-		memset(&mbox->m_out, 0, sizeof(raw_mbox));
+		memset(raw_mbox, 0, sizeof(raw_mbox));
 		raw_mbox[0] =3D FLUSH_SYSTEM;
=20
 		issue_scb_block(adapter, raw_mbox);
@@ -3908,12 +4003,13 @@
 	 * Have a delibrate delay to make sure all the caches are
 	 * actually flushed.
 	 */
-	printk("megaraid: cache flush delay: ");
-	for( j =3D 10; j >=3D 0; j-- ) {
-		printk("[%d] ", j);
+	printk(KERN_INFO "megaraid: cache flush delay:   ");
+	for( i =3D 9; i >=3D 0; i-- ) {
+		printk("\b\b\b[%d]", i);
 		mdelay(1000);
 	}
-	printk("\n");
+	printk("\b\b\b[done]\n");
+	mdelay(1000);
=20
 	return NOTIFY_DONE;
 }
@@ -4209,8 +4305,7 @@
 		 * For all internal commands, the buffer must be allocated in
 		 * <4GB address range
 		 */
-		if( make_local_pdev(adapter, &pdev) !=3D 0 )
-			return -EIO;
+		pdev =3D adapter->ipdev;
=20
 		/* Is it a passthru command or a DCMD */
 		if( uioc.uioc_rmbox[0] =3D=3D MEGA_MBOXCMD_PASSTHRU ) {
@@ -4221,7 +4316,6 @@
 					&pthru_dma_hndl);
=20
 			if( pthru =3D=3D NULL ) {
-				free_local_pdev(pdev);
 				return (-ENOMEM);
 			}
=20
@@ -4240,8 +4334,6 @@
 						sizeof(mega_passthru), pthru,
 						pthru_dma_hndl);
=20
-				free_local_pdev(pdev);
-
 				return (-EFAULT);
 			}
=20
@@ -4259,8 +4351,6 @@
 							pthru,
 							pthru_dma_hndl);
=20
-					free_local_pdev(pdev);
-
 					return (-ENOMEM);
 				}
=20
@@ -4329,8 +4419,6 @@
 			pci_free_consistent(pdev, sizeof(mega_passthru),
 					pthru, pthru_dma_hndl);
=20
-			free_local_pdev(pdev);
-
 			return rval;
 		}
 		else {
@@ -4344,7 +4432,6 @@
 						uioc.xferlen, &data_dma_hndl);
=20
 				if( data =3D=3D NULL ) {
-					free_local_pdev(pdev);
 					return (-ENOMEM);
 				}
=20
@@ -4365,8 +4452,6 @@
 							uioc.xferlen,
 							data, data_dma_hndl);
=20
-					free_local_pdev(pdev);
-
 					return (-EFAULT);
 				}
 			}
@@ -4389,8 +4474,6 @@
 							data_dma_hndl);
 				}
=20
-				free_local_pdev(pdev);
-
 				return rval;
 			}
=20
@@ -4411,8 +4494,6 @@
 						data_dma_hndl);
 			}
=20
-			free_local_pdev(pdev);
-
 			return rval;
 		}
=20
@@ -4564,6 +4645,7 @@
 {
 	nitioctl_t	*uiocp;
 	megacmd_t	*umc;
+	megacmd_t	kmc;
 	mega_passthru	*upthru;
 	struct uioctl_t	*uioc_mimd;
 	char	signature[8] =3D {0};
@@ -4600,8 +4682,10 @@
 		if( mc->cmd =3D=3D MEGA_MBOXCMD_PASSTHRU ) {
=20
 			umc =3D (megacmd_t *)uioc_mimd->mbox;
+			if (copy_from_user(&kmc, umc, sizeof(megacmd_t)))
+				return -EFAULT;
=20
-			upthru =3D (mega_passthru *)umc->xferaddr;
+			upthru =3D (mega_passthru *)kmc.xferaddr;
=20
 			if( put_user(mc->status, (u8 *)&upthru->scsistatus) )
 				return (-EFAULT);
@@ -4625,17 +4709,17 @@
 static int
 mega_is_bios_enabled(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(struct mbox_out)];
+	unsigned char	raw_mbox[sizeof(mbox_t)];
 	mbox_t	*mbox;
 	int	ret;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
=20
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	raw_mbox[0] =3D IS_BIOS_ENABLED;
 	raw_mbox[2] =3D GET_BIOS;
@@ -4658,13 +4742,13 @@
 static void
 mega_enum_raid_scsi(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(struct mbox_out)];
+	unsigned char raw_mbox[sizeof(mbox_t)];
 	mbox_t *mbox;
 	int i;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	/*
 	 * issue command to find out what channels are raid/scsi
@@ -4674,7 +4758,7 @@
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
=20
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	/*
 	 * Non-ROMB firware fail this command, so all channels
@@ -4713,7 +4797,7 @@
 mega_get_boot_drv(adapter_t *adapter)
 {
 	struct private_bios_data	*prv_bios_data;
-	unsigned char	raw_mbox[sizeof(struct mbox_out)];
+	unsigned char	raw_mbox[sizeof(mbox_t)];
 	mbox_t	*mbox;
 	u16	cksum =3D 0;
 	u8	*cksum_p;
@@ -4722,14 +4806,14 @@
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	raw_mbox[0] =3D BIOS_PVT_DATA;
 	raw_mbox[2] =3D GET_BIOS_PVT_DATA;
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
=20
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	adapter->boot_ldrv_enabled =3D 0;
 	adapter->boot_ldrv =3D 0;
@@ -4779,13 +4863,13 @@
 static int
 mega_support_random_del(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(struct mbox_out)];
+	unsigned char raw_mbox[sizeof(mbox_t)];
 	mbox_t *mbox;
 	int rval;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	/*
 	 * issue command
@@ -4808,13 +4892,13 @@
 static int
 mega_support_ext_cdb(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(struct mbox_out)];
+	unsigned char raw_mbox[sizeof(mbox_t)];
 	mbox_t *mbox;
 	int rval;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
 	/*
 	 * issue command to find out if controller supports extended CDBs.
 	 */
@@ -4843,6 +4927,8 @@
 	scb_t *scb;
 	int rval;
=20
+	ASSERT( !spin_is_locked(adapter->host_lock) );
+
 	/*
 	 * Stop sending commands to the controller, queue them internally.
 	 * When deletion is complete, ISR will flush the queue.
@@ -4853,15 +4939,15 @@
 	 * Wait till all the issued commands are complete and there are no
 	 * commands in the pending queue
 	 */
-	while( atomic_read(&adapter->pend_cmds) > 0 ||
-			!list_empty(&adapter->pending_list) ) {
+	while( atomic_read(&adapter->pend_cmds) > 0 ) {
=20
 		sleep_on_timeout( &wq, 1*HZ );	/* sleep for 1s */
 	}
=20
 	rval =3D mega_do_del_logdrv(adapter, logdrv);
=20
-	spin_lock_irqsave(&adapter->lock, flags);
+
+	spin_lock_irqsave(adapter->host_lock, flags);
=20
 	/*
 	 * If delete operation was successful, add 0x80 to the logical drive
@@ -4871,8 +4957,8 @@
 		struct list_head *pos;
 		list_for_each(pos, &adapter->pending_list) {
 			scb =3D list_entry(pos, scb_t, list);
-			if (scb->pthru->logdrv < 0x80 )
-				scb->pthru->logdrv +=3D 0x80;
+			if (((mbox_t *)scb->raw_mbox)->logdrv < 0x80 )
+				((mbox_t *)scb->raw_mbox)->logdrv +=3D 0x80 ;
 		}
 	}
=20
@@ -4880,7 +4966,7 @@
=20
 	mega_runpendq(adapter);
=20
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(adapter->host_lock, flags);
=20
 	return rval;
 }
@@ -4889,16 +4975,17 @@
 static int
 mega_do_del_logdrv(adapter_t *adapter, int logdrv)
 {
-	megacmd_t	mc;
 	int	rval;
+	u8	raw_mbox[sizeof(mbox_t)];
=20
-	memset( &mc, 0, sizeof(megacmd_t));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
-	mc.cmd =3D FC_DEL_LOGDRV;
-	mc.opcode =3D OP_DEL_LOGDRV;
-	mc.subopcode =3D logdrv;
+	raw_mbox[0] =3D FC_DEL_LOGDRV;
+	raw_mbox[2] =3D OP_DEL_LOGDRV;
+	raw_mbox[3] =3D logdrv;
=20
-	rval =3D mega_internal_command(adapter, LOCK_INT, &mc, NULL);
+	/* Issue a blocking command to the card */
+	rval =3D issue_scb_block(adapter, raw_mbox);
=20
 	/* log this event */
 	if(rval) {
@@ -4926,16 +5013,16 @@
 static void
 mega_get_max_sgl(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(struct mbox_out)];
+	unsigned char	raw_mbox[sizeof(mbox_t)];
 	mbox_t	*mbox;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(mbox, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
=20
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	raw_mbox[0] =3D MAIN_MISC_OPCODE;
 	raw_mbox[2] =3D GET_MAX_SG_SUPPORT;
@@ -4971,16 +5058,16 @@
 static int
 mega_support_cluster(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(struct mbox_out)];
+	unsigned char	raw_mbox[sizeof(mbox_t)];
 	mbox_t	*mbox;
=20
 	mbox =3D (mbox_t *)raw_mbox;
=20
-	memset(mbox, 0, sizeof(raw_mbox));
+	memset(raw_mbox, 0, sizeof(raw_mbox));
=20
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
=20
-	mbox->m_out.xferaddr =3D (u32)adapter->buf_dma_handle;
+	mbox->xferaddr =3D (u32)adapter->buf_dma_handle;
=20
 	/*
 	 * Try to get the initiator id. This command will succeed iff the
@@ -5021,7 +5108,7 @@
 	int		ldrv_num;
=20
 	tgt =3D cmd->device->id;
-=09
+
 	if ( tgt > adapter->this_id )
 		tgt--;	/* we do not get inquires for initiator id */
=20
@@ -5065,6 +5152,7 @@
 }
=20
=20
+#ifdef CONFIG_PROC_FS
 /**
  * mega_adapinq()
  * @adapter - pointer to our soft state
@@ -5144,13 +5232,12 @@
 	 * For all internal commands, the buffer must be allocated in <4GB
 	 * address range
 	 */
-	if( make_local_pdev(adapter, &pdev) !=3D 0 ) return -1;
+	pdev =3D adapter->ipdev;
=20
 	pthru =3D pci_alloc_consistent(pdev, sizeof(mega_passthru),
 			&pthru_dma_handle);
=20
 	if( pthru =3D=3D NULL ) {
-		free_local_pdev(pdev);
 		return -1;
 	}
=20
@@ -5186,10 +5273,9 @@
 	pci_free_consistent(pdev, sizeof(mega_passthru), pthru,
 			pthru_dma_handle);
=20
-	free_local_pdev(pdev);
-
 	return rval;
 }
+#endif	// #ifdef CONFIG_PROC_FS
=20
=20
 /**
@@ -5236,6 +5322,7 @@
 	scmd->device =3D sdev;
=20
 	scmd->device->host =3D adapter->host;
+
 	scmd->buffer =3D (void *)scb;
 	scmd->cmnd[0] =3D MEGA_INTERNAL_CMD;
=20
@@ -5259,16 +5346,18 @@
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
-	if( ls =3D=3D LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
+	if( ls =3D=3D LOCK_INT ) spin_lock_irqsave(adapter->host_lock, flags);
=20
 	megaraid_queue(scmd, mega_internal_done);
=20
-	if( ls =3D=3D LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+	if( ls =3D=3D LOCK_INT ) spin_unlock_irqrestore(adapter->host_lock, flags=
);
=20
 	/*
 	 * Wait till this command finishes. Do not use
 	 * wait_event_interruptible(). It causes panic if CTRL-C is hit when
 	 * dumping e.g., physical disk information through /proc interface.
+	 * Catching the return value should solve the issue but for now keep
+	 * the call non-interruptible.
 	 */
 #if 0
 	wait_event_interruptible(adapter->int_waitq, scmd->state);
@@ -5277,8 +5366,8 @@
=20
 	rval =3D scmd->result;
 	mc->status =3D scmd->result;
-	kfree(sdev);
=20
+	kfree(sdev);
 	/*
 	 * Print a debug message for all failed commands. Applications can use
 	 * this information.
@@ -5320,36 +5409,12 @@
=20
 }
=20
-
-static inline int
-make_local_pdev(adapter_t *adapter, struct pci_dev **pdev)
-{
-	*pdev =3D kmalloc(sizeof(struct pci_dev), GFP_KERNEL);
-
-	if( *pdev =3D=3D NULL ) return -1;
-
-	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
-
-	if( pci_set_dma_mask(*pdev, 0xffffffff) !=3D 0 ) {
-		kfree(*pdev);
-		return -1;
-	}
-
-	return 0;
-}
-
-static inline void
-free_local_pdev(struct pci_dev *pdev)
-{
-	kfree(pdev);
-}
-
 static Scsi_Host_Template driver_template =3D {
 	.name =3D				"MegaRAID",
 	.detect =3D			megaraid_detect,
 	.release =3D			megaraid_release,
 	.info =3D				megaraid_info,
-	.queuecommand =3D			megaraid_queue,=09
+	.queuecommand =3D			megaraid_queue,
 	.bios_param =3D			megaraid_biosparam,
 	.max_sectors =3D			MAX_SECTORS_PER_IO,
 	.can_queue =3D			MAX_COMMANDS,
@@ -5362,6 +5427,7 @@
 	.eh_bus_reset_handler =3D		megaraid_reset,
 	.eh_host_reset_handler =3D	megaraid_reset,
 };
+
 #include "scsi_module.c"
=20
 /* vi: set ts=3D8 sw=3D8 tw=3D78: */
diff -Naur megaraid2-2003-linux-2.6.0-test6/megaraid.h megaraid2-2009/megar=
aid.h
--- megaraid2-2003-linux-2.6.0-test6/megaraid.h	2003-10-06 12:56:03.0000000=
00 -0400
+++ megaraid2-2009/megaraid.h	2003-10-03 17:45:25.000000000 -0400
@@ -5,7 +5,7 @@
=20
=20
 #define MEGARAID_VERSION	\
-	"v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)\n"
+	"v2.00.9.a.10.03.2003 (Release Date: Fri Oct  3 18:59:41 EDT 2003)\n"
=20
 /*
  * Driver features - change the values to enable or disable features in th=
e
@@ -82,6 +82,7 @@
 #define DELL_SUBSYS_VID			0x1028
 #define	HP_SUBSYS_VID			0x103C
 #define LSI_SUBSYS_VID			0x1000
+#define INTEL_SUBSYS_VID		0x8086
=20
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
@@ -119,7 +120,8 @@
=20
 #define NVIRT_CHAN		4	/* # of virtual channels to represent
 					   up to 60 logical drives */
-struct mbox_out {
+
+typedef struct {
 	/* 0x0 */ u8 cmd;
 	/* 0x1 */ u8 cmdid;
 	/* 0x2 */ u16 numsectors;
@@ -128,20 +130,12 @@
 	/* 0xC */ u8 logdrv;
 	/* 0xD */ u8 numsgelements;
 	/* 0xE */ u8 resvd;
-} __attribute__ ((packed));
-
-struct mbox_in {
 	/* 0xF */ volatile u8 busy;
 	/* 0x10 */ volatile u8 numstatus;
 	/* 0x11 */ volatile u8 status;
 	/* 0x12 */ volatile u8 completed[MAX_FIRMWARE_STATUS];
 	volatile u8 poll;
 	volatile u8 ack;
-} __attribute__ ((packed));
-
-typedef struct {
-	struct mbox_out	m_out;
-	struct mbox_in	m_in;
 } __attribute__ ((packed)) mbox_t;
=20
 typedef struct {
@@ -487,6 +481,70 @@
 	phys_drv	pdrv[MAX_PHYSICAL_DRIVES];
 }__attribute__ ((packed)) disk_array_8ld;
=20
+/*
+ *    FW Definitions & Data Structures for 8LD 4-Span and 8-Span Controlle=
rs
+ */
+#define	MAX_STRIPES	8
+#define SPAN4_DEPTH	4
+#define SPAN8_DEPTH	8
+#define MAX_PHYDRVS	5 * 16	/* 5 Channels * 16 Targets */
+
+typedef struct  {
+	unsigned char	channel;
+	unsigned char	target;=20
+}__attribute__ ((packed)) device_t;
+
+typedef struct {=20
+	unsigned long	start_blk;
+	unsigned long	total_blks;
+	device_t	device[ MAX_STRIPES ];
+}__attribute__ ((packed)) span_t;
+
+typedef struct {
+	unsigned char	type;
+	unsigned char	curr_status;
+	unsigned char	tag_depth;
+	unsigned char	resvd1;
+	unsigned long	size;
+}__attribute__ ((packed)) phydrv_t;
+
+typedef struct {=20
+	unsigned char	span_depth;
+	unsigned char	raid;
+	unsigned char	read_ahead;	/* 0=3DNo rdahead,1=3DRDAHEAD,2=3Dadaptive */=20
+	unsigned char	stripe_sz;
+	unsigned char	status;
+	unsigned char	write_policy;	/* 0=3Dwrthru,1=3Dwrbak */=20
+	unsigned char	direct_io;   	/* 1=3Ddirectio,0=3Dcached */=20
+	unsigned char	no_stripes;
+	span_t		span[ SPAN4_DEPTH ];
+}__attribute__ ((packed)) ld_span4_t;
+
+typedef struct {=20
+	unsigned char	span_depth;
+	unsigned char	raid;
+	unsigned char	read_ahead;	/* 0=3DNo rdahead,1=3DRDAHEAD,2=3Dadaptive */=20
+	unsigned char	stripe_sz;
+	unsigned char	status;
+	unsigned char	write_policy;	/* 0=3Dwrthru,1=3Dwrbak */=20
+	unsigned char	direct_io;   	/* 1=3Ddirectio,0=3Dcached */=20
+	unsigned char	no_stripes;
+	span_t		span[ SPAN8_DEPTH ];
+}__attribute__ ((packed)) ld_span8_t;
+
+typedef struct {=20
+	unsigned char	no_log_drives;
+	unsigned char	pad[3];
+	ld_span4_t	log_drv[ MAX_LOGICAL_DRIVES_8LD ];
+	phydrv_t	phys_drv[ MAX_PHYDRVS ];
+}__attribute__ ((packed)) diskarray_span4_t;
+
+typedef struct {=20
+	unsigned char	no_log_drives;
+	unsigned char	pad[3];
+	ld_span8_t	log_drv[ MAX_LOGICAL_DRIVES_8LD ];
+	phydrv_t	phys_drv[ MAX_PHYDRVS ];
+}__attribute__ ((packed)) diskarray_span8_t;
=20
 /*
  * User ioctl structure.
@@ -790,8 +848,6 @@
 #define DIRECT_IO		1
=20
=20
-#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
-
 /*
  * Each controller's soft state
  */
@@ -811,10 +867,10 @@
 	dma_addr_t		mbox_dma;
=20
 	struct pci_dev	*dev;
+	struct pci_dev	*ipdev;		/* for internal allocation */
=20
 	struct list_head	free_list;
 	struct list_head	pending_list;
-	struct list_head	completed_list;
=20
 	struct Scsi_Host	*host;
=20
@@ -828,7 +884,7 @@
 	scb_t		*scb_list;
=20
 	atomic_t	pend_cmds;	/* maintain a counter for pending
-					   commands in firmware */
+					commands in firmware */
=20
 #if MEGA_HAVE_STATS
 	u32	nreads[MAX_LOGICAL_DRIVES_40LD];
@@ -879,6 +935,7 @@
 					   sending requests to the hba till
 					   delete operation is completed */
 	spinlock_t	lock;
+	spinlock_t	*host_lock;	// pointer to appropriate lock
=20
 	u8	logdrv_chan[MAX_CHANNELS+NVIRT_CHAN]; /* logical drive are on
 							what channels. */
@@ -986,6 +1043,22 @@
  * End of SYSDEP area
  */
=20
+/*
+ * ASSERT macro for megaraid. This should panic but printk should do for n=
ow
+ */
+#ifdef DEBUG
+#define ASSERT( expression )						\
+	if( !(expression) ) {						\
+		panic("assertion failed: %s, file: %s, line: %d\n",	\
+				#expression, __FILE__, __LINE__);	\
+	}
+#else
+#define ASSERT(expression)
+#endif
+
+#define MBOX_ABORT_SLEEP	60
+#define MBOX_RESET_SLEEP	30
+
 const char *megaraid_info (struct Scsi_Host *);
=20
 static int megaraid_detect(Scsi_Host_Template *);
@@ -1002,23 +1075,22 @@
 static int issue_scb_block(adapter_t *, u_char *);
=20
 static irqreturn_t megaraid_isr_memmapped(int, void *, struct pt_regs *);
+static inline int megaraid_memmbox_ack_sequence(adapter_t *);
 static irqreturn_t megaraid_isr_iomapped(int, void *, struct pt_regs *);
+static inline int megaraid_iombox_ack_sequence(adapter_t *);
=20
 static void mega_free_scb(adapter_t *, scb_t *);
=20
 static int megaraid_release (struct Scsi_Host *);
 static int megaraid_abort(Scsi_Cmnd *);
 static int megaraid_reset(Scsi_Cmnd *);
-static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int []);
-static int mega_print_inquiry(char *, char *);
+	sector_t, int []);
=20
 static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
 			      u32 *buffer, u32 *length);
 static inline int mega_busywait_mbox (adapter_t *);
 static int __mega_busywait_mbox (adapter_t *);
-static void mega_rundoneq (adapter_t *);
 static inline void mega_cmd_done(adapter_t *, u8 [], int, int);
 static inline void mega_free_sgl (adapter_t *adapter);
 static void mega_8_to_40ld (mraid_inquiry *inquiry,
@@ -1031,9 +1103,7 @@
 		unsigned long);
 static int mega_m_to_n(void *, nitioctl_t *);
 static int mega_n_to_m(void *, megacmd_t *);
-
 static int mega_init_scb (adapter_t *);
-
 static int mega_is_bios_enabled (adapter_t *);
=20
 #ifdef CONFIG_PROC_FS
@@ -1053,14 +1123,13 @@
 static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv(adapter_t *, char *, int, int);
-#endif
=20
 static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
 static inline caddr_t mega_allocate_inquiry(dma_addr_t *, struct pci_dev *=
);
 static inline void mega_free_inquiry(caddr_t, dma_addr_t, struct pci_dev *=
);
-static inline int make_local_pdev(adapter_t *, struct pci_dev **);
-static inline void free_local_pdev(struct pci_dev *);
+static int mega_print_inquiry(char *, char *);
+#endif
=20
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,

--=-WePd9sYt3fTfBygvVw1a--


From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] megaraid driver update
Date: 09 Jun 2003 14:03:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1055192595.6091.86.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:49892 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261989AbTFIUs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 16:48:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Atul Mukker <atulm@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>

James, Atul,

This is a patch for the megaraid driver that splits the mbox_t structure
into two sections.  The raw_mbox automatics are sized based on the
mbox_out part.  This saves quite a few bytes on the stack (for the
raw_mbox arrays) and limits the amount of bytes in the mbox_t structure
that are cleared.

In issue_scb_block, I changed setting the cmdid and busy elements from
being set in the raw_mbox to being set in the mbox itself after the
memcpy.


Mark.

===== drivers/scsi/megaraid.c 1.47 vs edited =====
--- 1.47/drivers/scsi/megaraid.c	Tue Jun  3 00:25:23 2003
+++ edited/drivers/scsi/megaraid.c	Fri Jun  6 09:41:26 2003
@@ -723,7 +723,7 @@
 {
 	dma_addr_t	prod_info_dma_handle;
 	mega_inquiry3	*inquiry3;
-	u8	raw_mbox[sizeof(mbox_t)];
+	u8	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
 	int	retval;
 
@@ -732,14 +732,14 @@
 	mbox = (mbox_t *)raw_mbox;
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 
 	/*
 	 * Try to issue Inquiry3 command
 	 * if not succeeded, then issue MEGA_MBOXCMD_ADAPTERINQ command and
 	 * update enquiry3 structure
 	 */
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	inquiry3 = (mega_inquiry3 *)adapter->mega_buffer;
 
@@ -762,10 +762,10 @@
 
 		inq = &ext_inq->raid_inq;
 
-		mbox->xferaddr = (u32)dma_handle;
+		mbox->m_out.xferaddr = (u32)dma_handle;
 
 		/*issue old 0x04 command to adapter */
-		mbox->cmd = MEGA_MBOXCMD_ADPEXTINQ;
+		mbox->m_out.cmd = MEGA_MBOXCMD_ADPEXTINQ;
 
 		issue_scb_block(adapter, raw_mbox);
 
@@ -790,7 +790,7 @@
 				&adapter->product_info,
 				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
 
-		mbox->xferaddr = prod_info_dma_handle;
+		mbox->m_out.xferaddr = prod_info_dma_handle;
 
 		raw_mbox[0] = FC_NEW_CONFIG;	/* i.e. mbox->cmd=0xA1 */
 		raw_mbox[2] = NC_SUBOP_PRODUCT_INFO;	/* i.e. 0x0E */
@@ -1141,10 +1141,10 @@
 			memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
 
 			if( adapter->has_64bit_addr ) {
-				mbox->cmd = MEGA_MBOXCMD_PASSTHRU64;
+				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
-				mbox->cmd = MEGA_MBOXCMD_PASSTHRU;
+				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
 			}
 
 			scb->dma_direction = PCI_DMA_FROMDEVICE;
@@ -1152,7 +1152,7 @@
 			pthru->numsgelements = mega_build_sglist(adapter, scb,
 				&pthru->dataxferaddr, &pthru->dataxferlen);
 
-			mbox->xferaddr = scb->pthru_dma_addr;
+			mbox->m_out.xferaddr = scb->pthru_dma_addr;
 
 			return scb;
 
@@ -1175,19 +1175,19 @@
 			mbox = (mbox_t *)scb->raw_mbox;
 
 			memset(mbox, 0, sizeof(scb->raw_mbox));
-			mbox->logdrv = ldrv_num;
+			mbox->m_out.logdrv = ldrv_num;
 
 			/*
 			 * A little hack: 2nd bit is zero for all scsi read
 			 * commands and is set for all scsi write commands
 			 */
 			if( adapter->has_64bit_addr ) {
-				mbox->cmd = (*cmd->cmnd & 0x02) ?
+				mbox->m_out.cmd = (*cmd->cmnd & 0x02) ?
 					MEGA_MBOXCMD_LWRITE64:
 					MEGA_MBOXCMD_LREAD64 ;
 			}
 			else {
-				mbox->cmd = (*cmd->cmnd & 0x02) ?
+				mbox->m_out.cmd = (*cmd->cmnd & 0x02) ?
 					MEGA_MBOXCMD_LWRITE:
 					MEGA_MBOXCMD_LREAD ;
 			}
@@ -1196,13 +1196,13 @@
 			 * 6-byte READ(0x08) or WRITE(0x0A) cdb
 			 */
 			if( cmd->cmd_len == 6 ) {
-				mbox->numsectors = (u32) cmd->cmnd[4];
-				mbox->lba =
+				mbox->m_out.numsectors = (u32) cmd->cmnd[4];
+				mbox->m_out.lba =
 					((u32)cmd->cmnd[1] << 16) |
 					((u32)cmd->cmnd[2] << 8) |
 					(u32)cmd->cmnd[3];
 
-				mbox->lba &= 0x1FFFFF;
+				mbox->m_out.lba &= 0x1FFFFF;
 
 #if MEGA_HAVE_STATS
 				/*
@@ -1213,11 +1213,11 @@
 				if (*cmd->cmnd == READ_6) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				}
 #endif
 			}
@@ -1226,10 +1226,10 @@
 			 * 10-byte READ(0x28) or WRITE(0x2A) cdb
 			 */
 			if( cmd->cmd_len == 10 ) {
-				mbox->numsectors =
+				mbox->m_out.numsectors =
 					(u32)cmd->cmnd[8] |
 					((u32)cmd->cmnd[7] << 8);
-				mbox->lba =
+				mbox->m_out.lba =
 					((u32)cmd->cmnd[2] << 24) |
 					((u32)cmd->cmnd[3] << 16) |
 					((u32)cmd->cmnd[4] << 8) |
@@ -1239,11 +1239,11 @@
 				if (*cmd->cmnd == READ_10) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				}
 #endif
 			}
@@ -1252,13 +1252,13 @@
 			 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
 			 */
 			if( cmd->cmd_len == 12 ) {
-				mbox->lba =
+				mbox->m_out.lba =
 					((u32)cmd->cmnd[2] << 24) |
 					((u32)cmd->cmnd[3] << 16) |
 					((u32)cmd->cmnd[4] << 8) |
 					(u32)cmd->cmnd[5];
 
-				mbox->numsectors =
+				mbox->m_out.numsectors =
 					((u32)cmd->cmnd[6] << 24) |
 					((u32)cmd->cmnd[7] << 16) |
 					((u32)cmd->cmnd[8] << 8) |
@@ -1268,11 +1268,11 @@
 				if (*cmd->cmnd == READ_12) {
 					adapter->nreads[ldrv_num%0x80]++;
 					adapter->nreadblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				} else {
 					adapter->nwrites[ldrv_num%0x80]++;
 					adapter->nwriteblocks[ldrv_num%0x80] +=
-						mbox->numsectors;
+						mbox->m_out.numsectors;
 				}
 #endif
 			}
@@ -1288,8 +1288,8 @@
 			}
 
 			/* Calculate Scatter-Gather info */
-			mbox->numsgelements = mega_build_sglist(adapter, scb,
-					(u32 *)&mbox->xferaddr, (u32 *)&seg);
+			mbox->m_out.numsgelements = mega_build_sglist(adapter, scb,
+					(u32 *)&mbox->m_out.xferaddr, (u32 *)&seg);
 
 			return scb;
 
@@ -1357,9 +1357,9 @@
 			epthru = mega_prepare_extpassthru(adapter, scb, cmd,
 					channel, target);
 
-			mbox->cmd = MEGA_MBOXCMD_EXTPTHRU;
+			mbox->m_out.cmd = MEGA_MBOXCMD_EXTPTHRU;
 
-			mbox->xferaddr = scb->epthru_dma_addr;
+			mbox->m_out.xferaddr = scb->epthru_dma_addr;
 
 		}
 		else {
@@ -1369,13 +1369,13 @@
 
 			/* Initialize mailbox */
 			if( adapter->has_64bit_addr ) {
-				mbox->cmd = MEGA_MBOXCMD_PASSTHRU64;
+				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
-				mbox->cmd = MEGA_MBOXCMD_PASSTHRU;
+				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
 			}
 
-			mbox->xferaddr = scb->pthru_dma_addr;
+			mbox->m_out.xferaddr = scb->pthru_dma_addr;
 
 		}
 		return scb;
@@ -1593,20 +1593,21 @@
 	volatile mbox_t		*mbox = adapter->mbox;
 	unsigned int	i = 0;
 
-	if(unlikely(mbox->busy)) {
+	if(unlikely(mbox->m_in.busy)) {
 		do {
 			udelay(1);
 			i++;
-		} while( mbox->busy && (i < max_mbox_busy_wait) );
+		} while( mbox->m_in.busy && (i < max_mbox_busy_wait) );
 
-		if(mbox->busy) return -1;
+		if(mbox->m_in.busy) return -1;
 	}
 
 	/* Copy mailbox data into host structure */
-	memcpy((char *)mbox, (char *)scb->raw_mbox, 16);
+	memcpy((char *)&mbox->m_out, (char *)scb->raw_mbox, 
+			sizeof(struct mbox_out));
 
-	mbox->cmdid = scb->idx;	/* Set cmdid */
-	mbox->busy = 1;		/* Set busy */
+	mbox->m_out.cmdid = scb->idx;	/* Set cmdid */
+	mbox->m_in.busy = 1;		/* Set busy */
 
 
 	/*
@@ -1614,14 +1615,14 @@
 	 */
 	atomic_inc(&adapter->pend_cmds);
 
-	switch (mbox->cmd) {
+	switch (mbox->m_out.cmd) {
 	case MEGA_MBOXCMD_LREAD64:
 	case MEGA_MBOXCMD_LWRITE64:
 	case MEGA_MBOXCMD_PASSTHRU64:
 	case MEGA_MBOXCMD_EXTPTHRU:
-		mbox64->xfer_segment_lo = mbox->xferaddr;
+		mbox64->xfer_segment_lo = mbox->m_out.xferaddr;
 		mbox64->xfer_segment_hi = 0;
-		mbox->xferaddr = 0xFFFFFFFF;
+		mbox->m_out.xferaddr = 0xFFFFFFFF;
 		break;
 	default:
 		mbox64->xfer_segment_lo = 0;
@@ -1634,8 +1635,8 @@
 	scb->state |= SCB_ISSUED;
 
 	if( likely(adapter->flag & BOARD_MEMMAP) ) {
-		mbox->poll = 0;
-		mbox->ack = 0;
+		mbox->m_in.poll = 0;
+		mbox->m_in.ack = 0;
 		WRINDOOR(adapter, adapter->mbox_dma | 0x1);
 	}
 	else {
@@ -1661,24 +1662,23 @@
 	volatile mbox_t *mbox = adapter->mbox;
 	u8	byte;
 
-	raw_mbox[0x1] = 0xFE;	/* Set cmdid */
-	raw_mbox[0xF] = 1;	/* Set busy */
-
 	/* Wait until mailbox is free */
 	if(mega_busywait_mbox (adapter))
 		goto bug_blocked_mailbox;
 
 	/* Copy mailbox data into host structure */
-	memcpy((char *) mbox, raw_mbox, 16);
+	memcpy((char *) mbox, raw_mbox, sizeof(struct mbox_out));
+	mbox->m_out.cmdid = 0xFE;
+	mbox->m_in.busy = 1;
 
 	switch (raw_mbox[0]) {
 	case MEGA_MBOXCMD_LREAD64:
 	case MEGA_MBOXCMD_LWRITE64:
 	case MEGA_MBOXCMD_PASSTHRU64:
 	case MEGA_MBOXCMD_EXTPTHRU:
-		mbox64->xfer_segment_lo = mbox->xferaddr;
+		mbox64->xfer_segment_lo = mbox->m_out.xferaddr;
 		mbox64->xfer_segment_hi = 0;
-		mbox->xferaddr = 0xFFFFFFFF;
+		mbox->m_out.xferaddr = 0xFFFFFFFF;
 		break;
 	default:
 		mbox64->xfer_segment_lo = 0;
@@ -1686,22 +1686,22 @@
 	}
 
 	if( likely(adapter->flag & BOARD_MEMMAP) ) {
-		mbox->poll = 0;
-		mbox->ack = 0;
-		mbox->numstatus = 0xFF;
-		mbox->status = 0xFF;
+		mbox->m_in.poll = 0;
+		mbox->m_in.ack = 0;
+		mbox->m_in.numstatus = 0xFF;
+		mbox->m_in.status = 0xFF;
 		WRINDOOR(adapter, adapter->mbox_dma | 0x1);
 
-		while((volatile u8)mbox->numstatus == 0xFF)
+		while((volatile u8)mbox->m_in.numstatus == 0xFF)
 			cpu_relax();
 
-		mbox->numstatus = 0xFF;
+		mbox->m_in.numstatus = 0xFF;
 
-		while( (volatile u8)mbox->poll != 0x77 )
+		while( (volatile u8)mbox->m_in.poll != 0x77 )
 			cpu_relax();
 
-		mbox->poll = 0;
-		mbox->ack = 0x77;
+		mbox->m_in.poll = 0;
+		mbox->m_in.ack = 0x77;
 
 		WRINDOOR(adapter, adapter->mbox_dma | 0x2);
 
@@ -1720,7 +1720,7 @@
 		irq_ack(adapter);
 	}
 
-	return mbox->status;
+	return mbox->m_in.status;
 
 bug_blocked_mailbox:
 	printk(KERN_WARNING "megaraid: Blocked mailbox......!!\n");
@@ -1767,19 +1767,20 @@
 		}
 		set_irq_state(adapter, byte);
 
-		while((nstatus = (volatile u8)adapter->mbox->numstatus)
+		while((nstatus = (volatile u8)adapter->mbox->m_in.numstatus)
 				== 0xFF)
 			cpu_relax();
-		adapter->mbox->numstatus = 0xFF;
+		adapter->mbox->m_in.numstatus = 0xFF;
 
-		status = adapter->mbox->status;
+		status = adapter->mbox->m_in.status;
 
 		/*
 		 * decrement the pending queue counter
 		 */
 		atomic_sub(nstatus, &adapter->pend_cmds);
 
-		memcpy(completed, (void *)adapter->mbox->completed, nstatus);
+		memcpy(completed, (void *)adapter->mbox->m_in.completed, 
+				nstatus);
 
 		/* Acknowledge interrupt */
 		irq_ack(adapter);
@@ -1843,20 +1844,21 @@
 		}
 		WROUTDOOR(adapter, 0x10001234);
 
-		while((nstatus = (volatile u8)adapter->mbox->numstatus)
+		while((nstatus = (volatile u8)adapter->mbox->m_in.numstatus)
 				== 0xFF) {
 			cpu_relax();
 		}
-		adapter->mbox->numstatus = 0xFF;
+		adapter->mbox->m_in.numstatus = 0xFF;
 
-		status = adapter->mbox->status;
+		status = adapter->mbox->m_in.status;
 
 		/*
 		 * decrement the pending queue counter
 		 */
 		atomic_sub(nstatus, &adapter->pend_cmds);
 
-		memcpy(completed, (void *)adapter->mbox->completed, nstatus);
+		memcpy(completed, (void *)adapter->mbox->m_in.completed, 
+				nstatus);
 
 		/* Acknowledge interrupt */
 		WRINDOOR(adapter, 0x2);
@@ -1986,7 +1988,7 @@
 #if MEGA_HAVE_STATS
 			{
 
-			int	logdrv = mbox->logdrv;
+			int	logdrv = mbox->m_out.logdrv;
 
 			islogical = adapter->logdrv_chan[cmd->channel];
 			/*
@@ -2065,8 +2067,8 @@
 				   SCSI_STATUS_CHECK_CONDITION */
 
 			/* set sense_buffer and result fields */
-			if( mbox->cmd == MEGA_MBOXCMD_PASSTHRU ||
-				mbox->cmd == MEGA_MBOXCMD_PASSTHRU64 ) {
+			if( mbox->m_out.cmd == MEGA_MBOXCMD_PASSTHRU ||
+				mbox->m_out.cmd == MEGA_MBOXCMD_PASSTHRU64 ) {
 
 				memcpy(cmd->sense_buffer, pthru->reqsensearea,
 						14);
@@ -2076,7 +2078,7 @@
 					(CHECK_CONDITION << 1);
 			}
 			else {
-				if (mbox->cmd == MEGA_MBOXCMD_EXTPTHRU) {
+				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
 
 					memcpy(cmd->sense_buffer,
 						epthru->reqsensearea, 14);
@@ -2233,7 +2235,7 @@
 static inline int
 mega_busywait_mbox (adapter_t *adapter)
 {
-	if (adapter->mbox->busy)
+	if (adapter->mbox->m_in.busy)
 		return __mega_busywait_mbox(adapter);
 	return 0;
 }
@@ -2245,7 +2247,7 @@
 	long counter;
 
 	for (counter = 0; counter < 10000; counter++) {
-		if (!mbox->busy)
+		if (!mbox->m_in.busy)
 			return 0;
 		udelay(100); yield();
 	}
@@ -2400,7 +2402,7 @@
 {
 	adapter_t	*adapter;
 	mbox_t	*mbox;
-	u_char	raw_mbox[sizeof(mbox_t)];
+	u_char	raw_mbox[sizeof(struct mbox_out)];
 	char	buf[12] = { 0 };
 
 	adapter = (adapter_t *)host->hostdata;
@@ -2409,7 +2411,7 @@
 	printk(KERN_NOTICE "megaraid: being unloaded...");
 
 	/* Flush adapter cache */
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 	raw_mbox[0] = FLUSH_ADAPTER;
 
 	irq_disable(adapter);
@@ -2419,7 +2421,7 @@
 	issue_scb_block(adapter, raw_mbox);
 
 	/* Flush disks cache */
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 	raw_mbox[0] = FLUSH_SYSTEM;
 
 	/* Issue a blocking (interrupts disabled) command to the card */
@@ -2979,16 +2981,24 @@
 	int	len = 0;
 
 	len = sprintf(page, "Contents of Mail Box Structure\n");
-	len += sprintf(page+len, "  Fw Command   = 0x%02x\n", mbox->cmd);
-	len += sprintf(page+len, "  Cmd Sequence = 0x%02x\n", mbox->cmdid);
-	len += sprintf(page+len, "  No of Sectors= %04d\n", mbox->numsectors);
-	len += sprintf(page+len, "  LBA          = 0x%02x\n", mbox->lba);
-	len += sprintf(page+len, "  DTA          = 0x%08x\n", mbox->xferaddr);
-	len += sprintf(page+len, "  Logical Drive= 0x%02x\n", mbox->logdrv);
+	len += sprintf(page+len, "  Fw Command   = 0x%02x\n", 
+			mbox->m_out.cmd);
+	len += sprintf(page+len, "  Cmd Sequence = 0x%02x\n", 
+			mbox->m_out.cmdid);
+	len += sprintf(page+len, "  No of Sectors= %04d\n", 
+			mbox->m_out.numsectors);
+	len += sprintf(page+len, "  LBA          = 0x%02x\n", 
+			mbox->m_out.lba);
+	len += sprintf(page+len, "  DTA          = 0x%08x\n", 
+			mbox->m_out.xferaddr);
+	len += sprintf(page+len, "  Logical Drive= 0x%02x\n", 
+			mbox->m_out.logdrv);
 	len += sprintf(page+len, "  No of SG Elmt= 0x%02x\n",
-			mbox->numsgelements);
-	len += sprintf(page+len, "  Busy         = %01x\n", mbox->busy);
-	len += sprintf(page+len, "  Status       = 0x%02x\n", mbox->status);
+			mbox->m_out.numsgelements);
+	len += sprintf(page+len, "  Busy         = %01x\n", 
+			mbox->m_in.busy);
+	len += sprintf(page+len, "  Status       = 0x%02x\n", 
+			mbox->m_in.status);
 
 	*eof = 1;
 
@@ -3881,7 +3891,7 @@
 {
 	adapter_t *adapter;
 	struct Scsi_Host *host;
-	u8 raw_mbox[sizeof(mbox_t)];
+	u8 raw_mbox[sizeof(struct mbox_out)];
 	mbox_t *mbox;
 	int i,j;
 
@@ -3897,7 +3907,7 @@
 		mbox = (mbox_t *)raw_mbox;
 
 		/* Flush adapter cache */
-		memset(mbox, 0, sizeof(*mbox));
+		memset(&mbox->m_out, 0, sizeof(raw_mbox));
 		raw_mbox[0] = FLUSH_ADAPTER;
 
 		irq_disable(adapter);
@@ -3910,7 +3920,7 @@
 		issue_scb_block(adapter, raw_mbox);
 
 		/* Flush disks cache */
-		memset(mbox, 0, sizeof(*mbox));
+		memset(&mbox->m_out, 0, sizeof(raw_mbox));
 		raw_mbox[0] = FLUSH_SYSTEM;
 
 		issue_scb_block(adapter, raw_mbox);
@@ -4643,17 +4653,17 @@
 static int
 mega_is_bios_enabled(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(mbox_t)];
+	unsigned char	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
 	int	ret;
 
 	mbox = (mbox_t *)raw_mbox;
 
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
 
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	raw_mbox[0] = IS_BIOS_ENABLED;
 	raw_mbox[2] = GET_BIOS;
@@ -4676,13 +4686,13 @@
 static void
 mega_enum_raid_scsi(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(mbox_t)];
+	unsigned char raw_mbox[sizeof(struct mbox_out)];
 	mbox_t *mbox;
 	int i;
 
 	mbox = (mbox_t *)raw_mbox;
 
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 
 	/*
 	 * issue command to find out what channels are raid/scsi
@@ -4692,7 +4702,7 @@
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
 
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	/*
 	 * Non-ROMB firware fail this command, so all channels
@@ -4731,7 +4741,7 @@
 mega_get_boot_drv(adapter_t *adapter)
 {
 	struct private_bios_data	*prv_bios_data;
-	unsigned char	raw_mbox[sizeof(mbox_t)];
+	unsigned char	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
 	u16	cksum = 0;
 	u8	*cksum_p;
@@ -4740,14 +4750,14 @@
 
 	mbox = (mbox_t *)raw_mbox;
 
-	memset(mbox, 0, sizeof(raw_mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 
 	raw_mbox[0] = BIOS_PVT_DATA;
 	raw_mbox[2] = GET_BIOS_PVT_DATA;
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
 
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	adapter->boot_ldrv_enabled = 0;
 	adapter->boot_ldrv = 0;
@@ -4797,13 +4807,13 @@
 static int
 mega_support_random_del(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(mbox_t)];
+	unsigned char raw_mbox[sizeof(struct mbox_out)];
 	mbox_t *mbox;
 	int rval;
 
 	mbox = (mbox_t *)raw_mbox;
 
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 
 	/*
 	 * issue command
@@ -4826,13 +4836,13 @@
 static int
 mega_support_ext_cdb(adapter_t *adapter)
 {
-	unsigned char raw_mbox[sizeof(mbox_t)];
+	unsigned char raw_mbox[sizeof(struct mbox_out)];
 	mbox_t *mbox;
 	int rval;
 
 	mbox = (mbox_t *)raw_mbox;
 
-	memset(mbox, 0, sizeof(*mbox));
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
 	/*
 	 * issue command to find out if controller supports extended CDBs.
 	 */
@@ -4944,7 +4954,7 @@
 static void
 mega_get_max_sgl(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(mbox_t)];
+	unsigned char	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
 
 	mbox = (mbox_t *)raw_mbox;
@@ -4953,7 +4963,7 @@
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
 
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	raw_mbox[0] = MAIN_MISC_OPCODE;
 	raw_mbox[2] = GET_MAX_SG_SUPPORT;
@@ -4989,7 +4999,7 @@
 static int
 mega_support_cluster(adapter_t *adapter)
 {
-	unsigned char	raw_mbox[sizeof(mbox_t)];
+	unsigned char	raw_mbox[sizeof(struct mbox_out)];
 	mbox_t	*mbox;
 
 	mbox = (mbox_t *)raw_mbox;
@@ -4998,7 +5008,7 @@
 
 	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
 
-	mbox->xferaddr = (u32)adapter->buf_dma_handle;
+	mbox->m_out.xferaddr = (u32)adapter->buf_dma_handle;
 
 	/*
 	 * Try to get the initiator id. This command will succeed iff the
===== drivers/scsi/megaraid.h 1.19 vs edited =====
--- 1.19/drivers/scsi/megaraid.h	Mon May 12 07:26:13 2003
+++ edited/drivers/scsi/megaraid.h	Fri Jun  6 09:33:13 2003
@@ -120,8 +120,7 @@
 
 #define NVIRT_CHAN		4	/* # of virtual channels to represent
 					   up to 60 logical drives */
-
-typedef struct {
+struct mbox_out {
 	/* 0x0 */ u8 cmd;
 	/* 0x1 */ u8 cmdid;
 	/* 0x2 */ u16 numsectors;
@@ -130,12 +129,20 @@
 	/* 0xC */ u8 logdrv;
 	/* 0xD */ u8 numsgelements;
 	/* 0xE */ u8 resvd;
+} __attribute__ ((packed));
+
+struct mbox_in {
 	/* 0xF */ volatile u8 busy;
 	/* 0x10 */ volatile u8 numstatus;
 	/* 0x11 */ volatile u8 status;
 	/* 0x12 */ volatile u8 completed[MAX_FIRMWARE_STATUS];
 	volatile u8 poll;
 	volatile u8 ack;
+} __attribute__ ((packed));
+
+typedef struct {
+	struct mbox_out	m_out;
+	struct mbox_in	m_in;
 } __attribute__ ((packed)) mbox_t;
 
 typedef struct {


-- 
Mark Haverkamp <markh@osdl.org>


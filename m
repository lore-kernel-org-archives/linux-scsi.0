From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 3/5] [ARM] rpc: acornscsi: convert hardware accessors to take 'AS_Host *'
Date: Mon, 12 May 2008 18:02:14 +0100
Message-ID: <git-1210611733-626564f695ac62d2e7ee490370bbbc7b5da72969@dyn-67.arm.linux.org.uk>
References: <git-1210611733-8fdb3936a9ea1b925c5d8e961026d547835b4cfc@dyn-67.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39305 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYELRON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:14:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/acornscsi.c |  243 +++++++++++++++++++++---------------------
 1 files changed, 120 insertions(+), 123 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index fa58d02..157ac1b 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -203,44 +203,41 @@ static void acornscsi_abortcmd(AS_Host *host, unsigned char tag);
  * Miscellaneous
  */
 
-static inline void
-sbic_arm_write(unsigned int io_port, int reg, int value)
+static inline void sbic_arm_write(AS_Host *host, unsigned int reg, unsigned int value)
 {
-    __raw_writeb(reg, io_port);
-    __raw_writeb(value, io_port + 4);
+    __raw_writeb(reg, host->scsi.io_port);
+    __raw_writeb(value, host->scsi.io_port + 4);
 }
 
-#define sbic_arm_writenext(io,val) \
-	__raw_writeb((val), (io) + 4)
+#define sbic_arm_writenext(host,val) \
+	__raw_writeb((val), (host)->scsi.io_port + 4)
 
-static inline
-int sbic_arm_read(unsigned int io_port, int reg)
+static inline int sbic_arm_read(AS_Host *host, unsigned int reg)
 {
     if(reg == SBIC_ASR)
-	   return __raw_readl(io_port) & 255;
-    __raw_writeb(reg, io_port);
-    return __raw_readl(io_port + 4) & 255;
+	   return __raw_readl(host->scsi.io_port) & 255;
+    __raw_writeb(reg, host->scsi.io_port);
+    return __raw_readl(host->scsi.io_port + 4) & 255;
 }
 
-#define sbic_arm_readnext(io) \
-	__raw_readb((io) + 4)
+#define sbic_arm_readnext(host) \
+	__raw_readb((host)->scsi.io_port + 4)
 
 #ifdef USE_DMAC
-#define dmac_read(io_port,reg) \
-	inb((io_port) + (reg))
+#define dmac_read(host,reg) \
+	inb((host)->dma.io_port + (reg))
 
-#define dmac_write(io_port,reg,value) \
-	({ outb((value), (io_port) + (reg)); })
+#define dmac_write(host,reg,value) \
+	({ outb((value), (host)->dma.io_port + (reg)); })
 
-#define dmac_clearintr(io_port) \
-	({ outb(0, (io_port)); })
+#define dmac_clearintr(host) \
+	({ outb(0, (host)->dma.io_intr_clear); })
 
-static inline
-unsigned int dmac_address(unsigned int io_port)
+static inline unsigned int dmac_address(AS_Host *host)
 {
-    return dmac_read(io_port, DMAC_TXADRHI) << 16 |
-	   dmac_read(io_port, DMAC_TXADRMD) << 8 |
-	   dmac_read(io_port, DMAC_TXADRLO);
+    return dmac_read(host, DMAC_TXADRHI) << 16 |
+	   dmac_read(host, DMAC_TXADRMD) << 8 |
+	   dmac_read(host, DMAC_TXADRLO);
 }
 
 static
@@ -248,15 +245,15 @@ void acornscsi_dumpdma(AS_Host *host, char *where)
 {
 	unsigned int mode, addr, len;
 
-	mode = dmac_read(host->dma.io_port, DMAC_MODECON);
-	addr = dmac_address(host->dma.io_port);
-	len  = dmac_read(host->dma.io_port, DMAC_TXCNTHI) << 8 |
-	       dmac_read(host->dma.io_port, DMAC_TXCNTLO);
+	mode = dmac_read(host, DMAC_MODECON);
+	addr = dmac_address(host);
+	len  = dmac_read(host, DMAC_TXCNTHI) << 8 |
+	       dmac_read(host, DMAC_TXCNTLO);
 
 	printk("scsi%d: %s: DMAC %02x @%06x+%04x msk %02x, ",
 		host->host->host_no, where,
 		mode, addr, (len + 1) & 0xffff,
-		dmac_read(host->dma.io_port, DMAC_MASKREG));
+		dmac_read(host, DMAC_MASKREG));
 
 	printk("DMA @%06x, ", host->dma.start_addr);
 	printk("BH @%p +%04x, ", host->scsi.SCp.ptr,
@@ -272,9 +269,9 @@ unsigned long acornscsi_sbic_xfcount(AS_Host *host)
 {
     unsigned long length;
 
-    length = sbic_arm_read(host->scsi.io_port, SBIC_TRANSCNTH) << 16;
-    length |= sbic_arm_readnext(host->scsi.io_port) << 8;
-    length |= sbic_arm_readnext(host->scsi.io_port);
+    length = sbic_arm_read(host, SBIC_TRANSCNTH) << 16;
+    length |= sbic_arm_readnext(host) << 8;
+    length |= sbic_arm_readnext(host);
 
     return length;
 }
@@ -285,7 +282,7 @@ acornscsi_sbic_wait(AS_Host *host, int stat_mask, int stat, int timeout, char *m
 	int asr;
 
 	do {
-		asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
+		asr = sbic_arm_read(host, SBIC_ASR);
 
 		if ((asr & stat_mask) == stat)
 			return 0;
@@ -304,7 +301,7 @@ int acornscsi_sbic_issuecmd(AS_Host *host, int command)
     if (acornscsi_sbic_wait(host, ASR_CIP, 0, 1000, "issuing command"))
 	return -1;
 
-    sbic_arm_write(host->scsi.io_port, SBIC_CMND, command);
+    sbic_arm_write(host, SBIC_CMND, command);
 
     return 0;
 }
@@ -353,12 +350,12 @@ void acornscsi_resetcard(AS_Host *host)
 	printk("scsi%d: timeout while resetting card\n",
 		host->host->host_no);
 
-    sbic_arm_read(host->scsi.io_port, SBIC_ASR);
-    sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+    sbic_arm_read(host, SBIC_ASR);
+    sbic_arm_read(host, SBIC_SSR);
 
     /* setup sbic - WD33C93A */
-    sbic_arm_write(host->scsi.io_port, SBIC_OWNID, OWNID_EAF | host->host->this_id);
-    sbic_arm_write(host->scsi.io_port, SBIC_CMND, CMND_RESET);
+    sbic_arm_write(host, SBIC_OWNID, OWNID_EAF | host->host->this_id);
+    sbic_arm_write(host, SBIC_CMND, CMND_RESET);
 
     /*
      * Command should cause a reset interrupt
@@ -374,26 +371,26 @@ void acornscsi_resetcard(AS_Host *host)
 	printk("scsi%d: timeout while resetting card\n",
 		host->host->host_no);
 
-    sbic_arm_read(host->scsi.io_port, SBIC_ASR);
-    if (sbic_arm_read(host->scsi.io_port, SBIC_SSR) != 0x01)
+    sbic_arm_read(host, SBIC_ASR);
+    if (sbic_arm_read(host, SBIC_SSR) != 0x01)
 	printk(KERN_CRIT "scsi%d: WD33C93A didn't give enhanced reset interrupt\n",
 		host->host->host_no);
 
-    sbic_arm_write(host->scsi.io_port, SBIC_CTRL, INIT_SBICDMA | CTRL_IDI);
-    sbic_arm_write(host->scsi.io_port, SBIC_TIMEOUT, TIMEOUT_TIME);
-    sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, SYNCHTRANSFER_2DBA);
-    sbic_arm_write(host->scsi.io_port, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
+    sbic_arm_write(host, SBIC_CTRL, INIT_SBICDMA | CTRL_IDI);
+    sbic_arm_write(host, SBIC_TIMEOUT, TIMEOUT_TIME);
+    sbic_arm_write(host, SBIC_SYNCHTRANSFER, SYNCHTRANSFER_2DBA);
+    sbic_arm_write(host, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
 
     host->card.page_reg = 0x40;
     outb(host->card.page_reg, host->card.io_page);
 
     /* setup dmac - uPC71071 */
-    dmac_write(host->dma.io_port, DMAC_INIT, 0);
+    dmac_write(host, DMAC_INIT, 0);
 #ifdef USE_DMAC
-    dmac_write(host->dma.io_port, DMAC_INIT, INIT_8BIT);
-    dmac_write(host->dma.io_port, DMAC_CHANNEL, CHANNEL_0);
-    dmac_write(host->dma.io_port, DMAC_DEVCON0, INIT_DEVCON0);
-    dmac_write(host->dma.io_port, DMAC_DEVCON1, INIT_DEVCON1);
+    dmac_write(host, DMAC_INIT, INIT_8BIT);
+    dmac_write(host, DMAC_CHANNEL, CHANNEL_0);
+    dmac_write(host, DMAC_DEVCON0, INIT_DEVCON0);
+    dmac_write(host, DMAC_DEVCON1, INIT_DEVCON1);
 #endif
 
     host->SCpnt = NULL;
@@ -741,9 +738,9 @@ intr_ret_t acornscsi_kick(AS_Host *host)
      * If we have an interrupt pending, then we may have been reselected.
      * In this case, we don't want to write to the registers
      */
-    if (!(sbic_arm_read(host->scsi.io_port, SBIC_ASR) & (ASR_INT|ASR_BSY|ASR_CIP))) {
-	sbic_arm_write(host->scsi.io_port, SBIC_DESTID, SCpnt->device->id);
-	sbic_arm_write(host->scsi.io_port, SBIC_CMND, CMND_SELWITHATN);
+    if (!(sbic_arm_read(host, SBIC_ASR) & (ASR_INT|ASR_BSY|ASR_CIP))) {
+	sbic_arm_write(host, SBIC_DESTID, SCpnt->device->id);
+	sbic_arm_write(host, SBIC_CMND, CMND_SELWITHATN);
     }
 
     /*
@@ -807,7 +804,7 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 	struct scsi_cmnd *SCpnt = *SCpntp;
 
     /* clean up */
-    sbic_arm_write(host->scsi.io_port, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
+    sbic_arm_write(host, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
 
     host->stats.fins += 1;
 
@@ -1008,8 +1005,8 @@ void acornscsi_data_write(AS_Host *host, char *ptr,
 static inline
 void acornscsi_dma_stop(AS_Host *host)
 {
-    dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_ON);
-    dmac_clearintr(host->dma.io_intr_clear);
+    dmac_write(host, DMAC_MASKREG, MASK_ON);
+    dmac_clearintr(host);
 
 #if (DEBUG & DEBUG_DMA)
     DBG(host->SCpnt, acornscsi_dumpdma(host, "stop"));
@@ -1031,7 +1028,7 @@ void acornscsi_dma_setup(AS_Host *host, dmadir_t direction)
 
     host->dma.direction = direction;
 
-    dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_ON);
+    dmac_write(host, DMAC_MASKREG, MASK_ON);
 
     if (direction == DMA_OUT) {
 #if (DEBUG & DEBUG_NO_WRITE)
@@ -1062,13 +1059,13 @@ void acornscsi_dma_setup(AS_Host *host, dmadir_t direction)
 				length);
 
 	length -= 1;
-	dmac_write(host->dma.io_port, DMAC_TXCNTLO, length);
-	dmac_write(host->dma.io_port, DMAC_TXCNTHI, length >> 8);
-	dmac_write(host->dma.io_port, DMAC_TXADRLO, address);
-	dmac_write(host->dma.io_port, DMAC_TXADRMD, address >> 8);
-	dmac_write(host->dma.io_port, DMAC_TXADRHI, 0);
-	dmac_write(host->dma.io_port, DMAC_MODECON, mode);
-	dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_OFF);
+	dmac_write(host, DMAC_TXCNTLO, length);
+	dmac_write(host, DMAC_TXCNTHI, length >> 8);
+	dmac_write(host, DMAC_TXADRLO, address);
+	dmac_write(host, DMAC_TXADRMD, address >> 8);
+	dmac_write(host, DMAC_TXADRHI, 0);
+	dmac_write(host, DMAC_MODECON, mode);
+	dmac_write(host, DMAC_MASKREG, MASK_OFF);
 
 #if (DEBUG & DEBUG_DMA)
 	DBG(host->SCpnt, acornscsi_dumpdma(host, "strt"));
@@ -1088,8 +1085,8 @@ void acornscsi_dma_setup(AS_Host *host, dmadir_t direction)
 static
 void acornscsi_dma_cleanup(AS_Host *host)
 {
-    dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_ON);
-    dmac_clearintr(host->dma.io_intr_clear);
+    dmac_write(host, DMAC_MASKREG, MASK_ON);
+    dmac_clearintr(host);
 
     /*
      * Check for a pending transfer
@@ -1116,7 +1113,7 @@ void acornscsi_dma_cleanup(AS_Host *host)
 	/*
 	 * Calculate number of bytes transferred from DMA.
 	 */
-	transferred = dmac_address(host->dma.io_port) - host->dma.start_addr;
+	transferred = dmac_address(host) - host->dma.start_addr;
 	host->dma.transferred += transferred;
 
 	if (host->dma.direction == DMA_IN)
@@ -1152,13 +1149,13 @@ void acornscsi_dma_intr(AS_Host *host)
     DBG(host->SCpnt, acornscsi_dumpdma(host, "inti"));
 #endif
 
-    dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_ON);
-    dmac_clearintr(host->dma.io_intr_clear);
+    dmac_write(host, DMAC_MASKREG, MASK_ON);
+    dmac_clearintr(host);
 
     /*
      * Calculate amount transferred via DMA
      */
-    transferred = dmac_address(host->dma.io_port) - host->dma.start_addr;
+    transferred = dmac_address(host) - host->dma.start_addr;
     host->dma.transferred += transferred;
 
     /*
@@ -1190,12 +1187,12 @@ void acornscsi_dma_intr(AS_Host *host)
 				length);
 
 	length -= 1;
-	dmac_write(host->dma.io_port, DMAC_TXCNTLO, length);
-	dmac_write(host->dma.io_port, DMAC_TXCNTHI, length >> 8);
-	dmac_write(host->dma.io_port, DMAC_TXADRLO, address);
-	dmac_write(host->dma.io_port, DMAC_TXADRMD, address >> 8);
-	dmac_write(host->dma.io_port, DMAC_TXADRHI, 0);
-	dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_OFF);
+	dmac_write(host, DMAC_TXCNTLO, length);
+	dmac_write(host, DMAC_TXCNTHI, length >> 8);
+	dmac_write(host, DMAC_TXADRLO, address);
+	dmac_write(host, DMAC_TXADRMD, address >> 8);
+	dmac_write(host, DMAC_TXADRHI, 0);
+	dmac_write(host, DMAC_MASKREG, MASK_OFF);
 
 #if (DEBUG & DEBUG_DMA)
 	DBG(host->SCpnt, acornscsi_dumpdma(host, "into"));
@@ -1209,15 +1206,15 @@ void acornscsi_dma_intr(AS_Host *host)
 	 * attention condition.  We continue giving one byte until
 	 * the device recognises the attention.
 	 */
-	if (dmac_read(host->dma.io_port, DMAC_STATUS) & STATUS_RQ0) {
+	if (dmac_read(host, DMAC_STATUS) & STATUS_RQ0) {
 	    acornscsi_abortcmd(host, host->SCpnt->tag);
 
-	    dmac_write(host->dma.io_port, DMAC_TXCNTLO, 0);
-	    dmac_write(host->dma.io_port, DMAC_TXCNTHI, 0);
-	    dmac_write(host->dma.io_port, DMAC_TXADRLO, 0);
-	    dmac_write(host->dma.io_port, DMAC_TXADRMD, 0);
-	    dmac_write(host->dma.io_port, DMAC_TXADRHI, 0);
-	    dmac_write(host->dma.io_port, DMAC_MASKREG, MASK_OFF);
+	    dmac_write(host, DMAC_TXCNTLO, 0);
+	    dmac_write(host, DMAC_TXCNTHI, 0);
+	    dmac_write(host, DMAC_TXADRLO, 0);
+	    dmac_write(host, DMAC_TXADRMD, 0);
+	    dmac_write(host, DMAC_TXADRHI, 0);
+	    dmac_write(host, DMAC_MASKREG, MASK_OFF);
 	}
 #endif
     }
@@ -1271,9 +1268,9 @@ void acornscsi_dma_adjust(AS_Host *host)
 	    host->dma.xfer_setup = 0;
 	else {
 	    transferred += host->dma.start_addr;
-	    dmac_write(host->dma.io_port, DMAC_TXADRLO, transferred);
-	    dmac_write(host->dma.io_port, DMAC_TXADRMD, transferred >> 8);
-	    dmac_write(host->dma.io_port, DMAC_TXADRHI, transferred >> 16);
+	    dmac_write(host, DMAC_TXADRLO, transferred);
+	    dmac_write(host, DMAC_TXADRMD, transferred >> 8);
+	    dmac_write(host, DMAC_TXADRHI, transferred >> 16);
 #if (DEBUG & (DEBUG_DMA|DEBUG_WRITE))
 	    DBG(host->SCpnt, acornscsi_dumpdma(host, "adjo"));
 #endif
@@ -1292,12 +1289,12 @@ acornscsi_write_pio(AS_Host *host, char *bytes, int *ptr, int len, unsigned int
 	int my_ptr = *ptr;
 
 	while (my_ptr < len) {
-		asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
+		asr = sbic_arm_read(host, SBIC_ASR);
 
 		if (asr & ASR_DBR) {
 			timeout = max_timeout;
 
-			sbic_arm_write(host->scsi.io_port, SBIC_DATA, bytes[my_ptr++]);
+			sbic_arm_write(host, SBIC_DATA, bytes[my_ptr++]);
 		} else if (asr & ASR_INT)
 			break;
 		else if (--timeout == 0)
@@ -1320,9 +1317,9 @@ acornscsi_sendcommand(AS_Host *host)
 {
 	struct scsi_cmnd *SCpnt = host->SCpnt;
 
-    sbic_arm_write(host->scsi.io_port, SBIC_TRANSCNTH, 0);
-    sbic_arm_writenext(host->scsi.io_port, 0);
-    sbic_arm_writenext(host->scsi.io_port, SCpnt->cmd_len - host->scsi.SCp.sent_command);
+    sbic_arm_write(host, SBIC_TRANSCNTH, 0);
+    sbic_arm_writenext(host, 0);
+    sbic_arm_writenext(host, SCpnt->cmd_len - host->scsi.SCp.sent_command);
 
     acornscsi_sbic_issuecmd(host, CMND_XFERINFO);
 
@@ -1351,7 +1348,7 @@ void acornscsi_sendmessage(AS_Host *host)
 
 	acornscsi_sbic_wait(host, ASR_DBR, ASR_DBR, 1000, "sending message 1");
 
-	sbic_arm_write(host->scsi.io_port, SBIC_DATA, NOP);
+	sbic_arm_write(host, SBIC_DATA, NOP);
 
 	host->scsi.last_message = NOP;
 #if (DEBUG & DEBUG_MESSAGES)
@@ -1365,7 +1362,7 @@ void acornscsi_sendmessage(AS_Host *host)
 
 	acornscsi_sbic_wait(host, ASR_DBR, ASR_DBR, 1000, "sending message 2");
 
-	sbic_arm_write(host->scsi.io_port, SBIC_DATA, msg->msg[0]);
+	sbic_arm_write(host, SBIC_DATA, msg->msg[0]);
 
 	host->scsi.last_message = msg->msg[0];
 #if (DEBUG & DEBUG_MESSAGES)
@@ -1382,9 +1379,9 @@ void acornscsi_sendmessage(AS_Host *host)
 	 *  initiator.  This provides an interlock so that the
 	 *  initiator can determine which message byte is rejected.
 	 */
-	sbic_arm_write(host->scsi.io_port, SBIC_TRANSCNTH, 0);
-	sbic_arm_writenext(host->scsi.io_port, 0);
-	sbic_arm_writenext(host->scsi.io_port, message_length);
+	sbic_arm_write(host, SBIC_TRANSCNTH, 0);
+	sbic_arm_writenext(host, 0);
+	sbic_arm_writenext(host, message_length);
 	acornscsi_sbic_issuecmd(host, CMND_XFERINFO);
 
 	msgnr = 0;
@@ -1421,7 +1418,7 @@ void acornscsi_readstatusbyte(AS_Host *host)
 {
     acornscsi_sbic_issuecmd(host, CMND_XFERINFO|CMND_SBT);
     acornscsi_sbic_wait(host, ASR_DBR, ASR_DBR, 1000, "reading status byte");
-    host->scsi.SCp.Status = sbic_arm_read(host->scsi.io_port, SBIC_DATA);
+    host->scsi.SCp.Status = sbic_arm_read(host, SBIC_DATA);
 }
 
 /*
@@ -1438,12 +1435,12 @@ unsigned char acornscsi_readmessagebyte(AS_Host *host)
 
     acornscsi_sbic_wait(host, ASR_DBR, ASR_DBR, 1000, "for message byte");
 
-    message = sbic_arm_read(host->scsi.io_port, SBIC_DATA);
+    message = sbic_arm_read(host, SBIC_DATA);
 
     /* wait for MSGIN-XFER-PAUSED */
     acornscsi_sbic_wait(host, ASR_INT, ASR_INT, 1000, "for interrupt after message byte");
 
-    sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+    sbic_arm_read(host, SBIC_SSR);
 
     return message;
 }
@@ -1480,7 +1477,7 @@ void acornscsi_message(AS_Host *host)
 
 	    /* wait for next msg-in */
 	    acornscsi_sbic_wait(host, ASR_INT, ASR_INT, 1000, "for interrupt after negate ack");
-	    sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+	    sbic_arm_read(host, SBIC_SSR);
 	}
     } while (msgidx < msglen);
 
@@ -1602,7 +1599,7 @@ void acornscsi_message(AS_Host *host)
 		    host->host->host_no, acornscsi_target(host));
 	    host->device[host->SCpnt->device->id].sync_xfer = SYNCHTRANSFER_2DBA;
 	    host->device[host->SCpnt->device->id].sync_state = SYNC_ASYNCHRONOUS;
-	    sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
+	    sbic_arm_write(host, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
 	    break;
 
 	default:
@@ -1652,7 +1649,7 @@ void acornscsi_message(AS_Host *host)
 		host->device[host->SCpnt->device->id].sync_xfer =
 			calc_sync_xfer(period * 4, length);
 	    }
-	    sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
+	    sbic_arm_write(host, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
 	    break;
 #else
 	    /* We do not accept synchronous transfers.  Respond with a
@@ -1792,10 +1789,10 @@ int acornscsi_starttransfer(AS_Host *host)
 
     residual = scsi_bufflen(host->SCpnt) - host->scsi.SCp.scsi_xferred;
 
-    sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
-    sbic_arm_writenext(host->scsi.io_port, residual >> 16);
-    sbic_arm_writenext(host->scsi.io_port, residual >> 8);
-    sbic_arm_writenext(host->scsi.io_port, residual);
+    sbic_arm_write(host, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
+    sbic_arm_writenext(host, residual >> 16);
+    sbic_arm_writenext(host, residual >> 8);
+    sbic_arm_writenext(host, residual);
     acornscsi_sbic_issuecmd(host, CMND_XFERINFO);
     return 1;
 }
@@ -1816,7 +1813,7 @@ int acornscsi_reconnect(AS_Host *host)
 {
     unsigned int target, lun, ok = 0;
 
-    target = sbic_arm_read(host->scsi.io_port, SBIC_SOURCEID);
+    target = sbic_arm_read(host, SBIC_SOURCEID);
 
     if (!(target & 8))
 	printk(KERN_ERR "scsi%d: invalid source id after reselection "
@@ -1832,7 +1829,7 @@ int acornscsi_reconnect(AS_Host *host)
 	host->SCpnt = NULL;
     }
 
-    lun = sbic_arm_read(host->scsi.io_port, SBIC_DATA) & 7;
+    lun = sbic_arm_read(host, SBIC_DATA) & 7;
 
     host->scsi.reconnected.target = target;
     host->scsi.reconnected.lun = lun;
@@ -1952,7 +1949,7 @@ static
 void acornscsi_abortcmd(AS_Host *host, unsigned char tag)
 {
     host->scsi.phase = PHASE_ABORTED;
-    sbic_arm_write(host->scsi.io_port, SBIC_CMND, CMND_ASSERTATN);
+    sbic_arm_write(host, SBIC_CMND, CMND_ASSERTATN);
 
     msgqueue_flush(&host->scsi.msgs);
 #ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
@@ -1979,11 +1976,11 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 {
     unsigned int asr, ssr;
 
-    asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
+    asr = sbic_arm_read(host, SBIC_ASR);
     if (!(asr & ASR_INT))
 	return INTR_IDLE;
 
-    ssr = sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+    ssr = sbic_arm_read(host, SBIC_SSR);
 
 #if (DEBUG & DEBUG_PHASES)
     print_sbic_status(asr, ssr, host->scsi.phase);
@@ -1999,15 +1996,15 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	printk(KERN_ERR "scsi%d: reset in standard mode but wanted advanced mode.\n",
 		host->host->host_no);
 	/* setup sbic - WD33C93A */
-	sbic_arm_write(host->scsi.io_port, SBIC_OWNID, OWNID_EAF | host->host->this_id);
-	sbic_arm_write(host->scsi.io_port, SBIC_CMND, CMND_RESET);
+	sbic_arm_write(host, SBIC_OWNID, OWNID_EAF | host->host->this_id);
+	sbic_arm_write(host, SBIC_CMND, CMND_RESET);
 	return INTR_IDLE;
 
     case 0x01:				/* reset state - advanced			*/
-	sbic_arm_write(host->scsi.io_port, SBIC_CTRL, INIT_SBICDMA | CTRL_IDI);
-	sbic_arm_write(host->scsi.io_port, SBIC_TIMEOUT, TIMEOUT_TIME);
-	sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, SYNCHTRANSFER_2DBA);
-	sbic_arm_write(host->scsi.io_port, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
+	sbic_arm_write(host, SBIC_CTRL, INIT_SBICDMA | CTRL_IDI);
+	sbic_arm_write(host, SBIC_TIMEOUT, TIMEOUT_TIME);
+	sbic_arm_write(host, SBIC_SYNCHTRANSFER, SYNCHTRANSFER_2DBA);
+	sbic_arm_write(host, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
 	msgqueue_flush(&host->scsi.msgs);
 	return INTR_IDLE;
 
@@ -2025,10 +2022,10 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	    msgqueue_flush(&host->scsi.msgs);
 	    host->dma.transferred = host->scsi.SCp.scsi_xferred;
 	    /* 33C93 gives next interrupt indicating bus phase */
-	    asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
+	    asr = sbic_arm_read(host, SBIC_ASR);
 	    if (!(asr & ASR_INT))
 		break;
-	    ssr = sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+	    ssr = sbic_arm_read(host, SBIC_SSR);
 	    ADD_STATUS(8, ssr, host->scsi.phase, 1);
 	    ADD_STATUS(host->SCpnt->device->id, ssr, host->scsi.phase, 1);
 	    goto connected;
@@ -2655,7 +2652,7 @@ static enum res_abort acornscsi_do_abort(AS_Host *host, struct scsi_cmnd *SCpnt)
 		 * busylun bit.
 		 */
 		case PHASE_CONNECTED:
-			sbic_arm_write(host->scsi.io_port, SBIC_CMND, CMND_DISCONNECT);
+			sbic_arm_write(host, SBIC_CMND, CMND_DISCONNECT);
 			host->SCpnt = NULL;
 			res = res_success_clear;
 			break;
@@ -2699,8 +2696,8 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 #if (DEBUG & DEBUG_ABORT)
 	{
 		int asr, ssr;
-		asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
-		ssr = sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+		asr = sbic_arm_read(host, SBIC_ASR);
+		ssr = sbic_arm_read(host, SBIC_SSR);
 
 		printk(KERN_WARNING "acornscsi_abort: ");
 		print_sbic_status(asr, ssr, host->scsi.phase);
@@ -2780,8 +2777,8 @@ int acornscsi_bus_reset(struct scsi_cmnd *SCpnt)
     {
 	int asr, ssr;
 
-	asr = sbic_arm_read(host->scsi.io_port, SBIC_ASR);
-	ssr = sbic_arm_read(host->scsi.io_port, SBIC_SSR);
+	asr = sbic_arm_read(host, SBIC_ASR);
+	ssr = sbic_arm_read(host, SBIC_SSR);
 
 	printk(KERN_WARNING "acornscsi_reset: ");
 	print_sbic_status(asr, ssr, host->scsi.phase);

From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Interrupt function cleanup
Date: Tue, 02 Nov 2004 10:53:12 -0800
Message-ID: <1099421593.32382.5.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:47064 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261326AbUKBSxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 13:53:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


This patch updates the adapter health check function and cleans up some
unused interrupt related functions and macros.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


===== drivers/scsi/aacraid/aacraid.h 1.26 vs edited =====
--- 1.26/drivers/scsi/aacraid/aacraid.h	2004-11-01 09:05:44 -08:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-11-01 13:09:31 -08:00
@@ -421,8 +421,6 @@
 {
 	void (*adapter_interrupt)(struct aac_dev *dev);
 	void (*adapter_notify)(struct aac_dev *dev, u32 event);
-	void (*adapter_enable_int)(struct aac_dev *dev, u32 event);
-	void (*adapter_disable_int)(struct aac_dev *dev, u32 event);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 *status);
 	int  (*adapter_check_health)(struct aac_dev *dev);
 };
@@ -884,23 +882,12 @@
 	u8			raid_scsi_mode;
 };
 
-#define AllocateAndMapFibSpace(dev, MapFibContext) \
-	(dev)->a_ops.AllocateAndMapFibSpace(dev, MapFibContext)
-
-#define UnmapAndFreeFibSpace(dev, MapFibContext) \
-	(dev)->a_ops.UnmapAndFreeFibSpace(dev, MapFibContext)
-
 #define aac_adapter_interrupt(dev) \
 	(dev)->a_ops.adapter_interrupt(dev)
 
 #define aac_adapter_notify(dev, event) \
 	(dev)->a_ops.adapter_notify(dev, event)
 
-#define aac_adapter_enable_int(dev, event) \
-	(dev)->a_ops.adapter_enable_int(dev, event)
-
-#define aac_adapter_disable_int(dev, event) \
-	dev->a_ops.adapter_disable_int(dev, event)
 
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
===== drivers/scsi/aacraid/rkt.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/rkt.c	2004-10-20 06:46:11 -07:00
+++ edited/drivers/scsi/aacraid/rkt.c	2004-11-01 13:09:31 -08:00
@@ -88,66 +88,6 @@
 }
 
 /**
- *	aac_rkt_enable_interrupt	-	Enable event reporting
- *	@dev: Adapter
- *	@event: Event to enable
- *
- *	Enable event reporting from the i960 for a given event.
- */
- 
-static void aac_rkt_enable_interrupt(struct aac_dev * dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_4);
-		break;
-	}
-}
-
-/**
- *	aac_rkt_disable_interrupt	-	Disable event reporting
- *	@dev: Adapter
- *	@event: Event to enable
- *
- *	Disable event reporting from the i960 for a given event.
- */
-
-static void aac_rkt_disable_interrupt(struct aac_dev *dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_4);
-		break;
-	}
-}
-
-/**
  *	rkt_sync_cmd	-	send a command and wait
  *	@dev: Adapter
  *	@command: Command to execute
@@ -180,7 +120,7 @@
 	/*
 	 *	Disable doorbell interrupts
 	 */
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR |= 0x04);
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	/*
 	 *	Force the completion of the mask register write before issuing
 	 *	the interrupt.
@@ -221,13 +161,14 @@
 		/*
 		 *	Restore interrupt mask even though we timed out
 		 */
-		rkt_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+		rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 		return -ETIMEDOUT;
 	}
 	/*
 	 *	Pull the synch status from Mailbox 0.
 	 */
-	*status = le32_to_cpu(rkt_readl(dev, IndexRegs.Mailbox[0]));
+	if (status)
+		*status = le32_to_cpu(rkt_readl(dev, IndexRegs.Mailbox[0]));
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -235,7 +176,7 @@
 	/*
 	 *	Restore interrupt mask
 	 */
-	rkt_writeb(dev, MUnit.OIMR, dev->OIMR &= 0xfb);
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 	return 0;
 
 }
@@ -334,7 +275,7 @@
  */
 static int aac_rkt_check_health(struct aac_dev *dev)
 {
-	long status = rkt_readl(dev, IndexRegs.Mailbox[7]);
+	u32 status = le32_to_cpu(rkt_readl(dev, MUnit.OMRx[0]));
 
 	/*
 	 *	Check to see if the board failed any self tests.
@@ -344,34 +285,42 @@
 	/*
 	 *	Check to see if the board panic'd.
 	 */
-	if (status & KERNEL_PANIC)
-	{
-		char * buffer = kmalloc(512, GFP_KERNEL|__GFP_DMA);
+	if (status & KERNEL_PANIC) {
+		char * buffer;
 		struct POSTSTATUS {
 			u32 Post_Command;
 			u32 Post_Address;
-		} * post = kmalloc(sizeof(struct POSTSTATUS), GFP_KERNEL);
-		dma_addr_t paddr = pci_map_single(dev->pdev, post, sizeof(struct POSTSTATUS), 2);
-		dma_addr_t baddr = pci_map_single(dev->pdev, buffer, 512, 1);
-		u32 status = -1;
-		int ret = -2;
-		
-		memset(buffer, 0, 512);
-		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
-		post->Post_Address = cpu_to_le32(baddr);
-		rkt_writel(dev, MUnit.IMRx[0], cpu_to_le32(paddr));
-		rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
-		pci_unmap_single(dev->pdev, paddr, sizeof(struct POSTSTATUS),2);
-		kfree(post);
-		if ((buffer[0] == '0') && (buffer[1] == 'x')) {
-			ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
-			ret <<= 4;
-			ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
+		} * post;
+		dma_addr_t paddr, baddr;
+		int ret;
+
+		if ((status & 0xFF000000L) == 0xBC000000L)
+			return (status >> 16) & 0xFF;
+		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
+		ret = -2;
+		if (buffer == NULL)
+			return ret;
+		post = pci_alloc_consistent(dev->pdev,
+		  sizeof(struct POSTSTATUS), &paddr);
+		if (post == NULL) {
+			pci_free_consistent(dev->pdev, 512, buffer, baddr);
+			return ret;
 		}
-		pci_unmap_single(dev->pdev, baddr, 512, 1);
-		kfree(buffer);
-		return ret;
-	}
+                memset(buffer, 0, 512);
+                post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
+                post->Post_Address = cpu_to_le32(baddr);
+                rkt_writel(dev, MUnit.IMRx[0], cpu_to_le32(paddr));
+                rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
+		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
+		  post, paddr);
+                if ((buffer[0] == '0') && (buffer[1] == 'x')) {
+                        ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
+                        ret <<= 4;
+                        ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
+                }
+		pci_free_consistent(dev->pdev, 512, buffer, baddr);
+                return ret;
+        }
 	/*
 	 *	Wait for the adapter to be up and running.
 	 */
@@ -455,8 +404,6 @@
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
-	dev->a_ops.adapter_enable_int = aac_rkt_enable_interrupt;
-	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rkt_check_health;
===== drivers/scsi/aacraid/rx.c 1.11 vs edited =====
--- 1.11/drivers/scsi/aacraid/rx.c	2004-10-20 06:46:13 -07:00
+++ edited/drivers/scsi/aacraid/rx.c	2004-11-01 13:09:31 -08:00
@@ -88,66 +88,6 @@
 }
 
 /**
- *	aac_rx_enable_interrupt	-	Enable event reporting
- *	@dev: Adapter
- *	@event: Event to enable
- *
- *	Enable event reporting from the i960 for a given event.
- */
- 
-static void aac_rx_enable_interrupt(struct aac_dev * dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		dev->irq_mask &= ~(OUTBOUNDDOORBELL_4);
-		break;
-	}
-}
-
-/**
- *	aac_rx_disable_interrupt	-	Disable event reporting
- *	@dev: Adapter
- *	@event: Event to enable
- *
- *	Disable event reporting from the i960 for a given event.
- */
-
-static void aac_rx_disable_interrupt(struct aac_dev *dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		dev->irq_mask |= (OUTBOUNDDOORBELL_4);
-		break;
-	}
-}
-
-/**
  *	rx_sync_cmd	-	send a command and wait
  *	@dev: Adapter
  *	@command: Command to execute
@@ -454,8 +394,6 @@
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
-	dev->a_ops.adapter_enable_int = aac_rx_enable_interrupt;
-	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
===== drivers/scsi/aacraid/sa.c 1.12 vs edited =====
--- 1.12/drivers/scsi/aacraid/sa.c	2004-10-20 06:46:15 -07:00
+++ edited/drivers/scsi/aacraid/sa.c	2004-11-01 13:09:31 -08:00
@@ -82,68 +82,6 @@
 }
 
 /**
- *	aac_sa_enable_interrupt	-	enable an interrupt event
- *	@dev: Which adapter to enable.
- *	@event: Which adapter event.
- *
- *	This routine will enable the corresponding adapter event to cause an interrupt on 
- * 	the host.
- */
- 
-void aac_sa_enable_interrupt(struct aac_dev *dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, DOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, DOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, DOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, DOORBELL_4);
-		break;
-	}
-}
-
-/**
- *	aac_sa_disable_interrupt	-	disable an interrupt event
- *	@dev: Which adapter to enable.
- *	@event: Which adapter event.
- *
- *	This routine will enable the corresponding adapter event to cause an interrupt on 
- * 	the host.
- */
-
-void aac_sa_disable_interrupt (struct aac_dev *dev, u32 event)
-{
-	switch (event) {
-
-	case HostNormCmdQue:
-		sa_writew(dev, SaDbCSR.PRISETIRQMASK, DOORBELL_1);
-		break;
-
-	case HostNormRespQue:
-		sa_writew(dev, SaDbCSR.PRISETIRQMASK, DOORBELL_2);
-		break;
-
-	case AdapNormCmdNotFull:
-		sa_writew(dev, SaDbCSR.PRISETIRQMASK, DOORBELL_3);
-		break;
-
-	case AdapNormRespNotFull:
-		sa_writew(dev, SaDbCSR.PRISETIRQMASK, DOORBELL_4);
-		break;
-	}
-}
-
-/**
  *	aac_sa_notify_adapter		-	handle adapter notification
  *	@dev:	Adapter that notification is for
  *	@event:	Event to notidy
@@ -401,8 +339,6 @@
 	 */
 
 	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
-	dev->a_ops.adapter_enable_int = aac_sa_enable_interrupt;
-	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;

-- 
Mark Haverkamp <markh@osdl.org>


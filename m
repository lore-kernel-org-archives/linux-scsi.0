From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] 3w-9xxx iomem annotations
Date: Sun, 21 Nov 2004 18:32:55 +0000
Message-ID: <20041121183255.GC26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22428 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261779AbUKUSc5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 13:32:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk6-dpt/drivers/scsi/3w-9xxx.h RC10-rc2-bk6-3w-9xxx/drivers/scsi/3w-9xxx.h
--- RC10-rc2-bk6-dpt/drivers/scsi/3w-9xxx.h	Mon Oct 18 17:55:36 2004
+++ RC10-rc2-bk6-3w-9xxx/drivers/scsi/3w-9xxx.h	Sun Nov 21 10:50:56 2004
@@ -453,13 +453,13 @@
 
 /* Macros */
 #define TW_CONTROL_REG_ADDR(x) (x->base_addr)
-#define TW_STATUS_REG_ADDR(x) ((unsigned char *)x->base_addr + 0x4)
+#define TW_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0x4)
 #if BITS_PER_LONG > 32
-#define TW_COMMAND_QUEUE_REG_ADDR(x) ((unsigned char *)x->base_addr + 0x20)
+#define TW_COMMAND_QUEUE_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0x20)
 #else
-#define TW_COMMAND_QUEUE_REG_ADDR(x) ((unsigned char *)x->base_addr + 0x8)
+#define TW_COMMAND_QUEUE_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0x8)
 #endif
-#define TW_RESPONSE_QUEUE_REG_ADDR(x) ((unsigned char *)x->base_addr + 0xC)
+#define TW_RESPONSE_QUEUE_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0xC)
 #define TW_CLEAR_ALL_INTERRUPTS(x) (writel(TW_STATUS_VALID_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
 #define TW_CLEAR_ATTENTION_INTERRUPT(x) (writel(TW_CONTROL_CLEAR_ATTENTION_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
 #define TW_CLEAR_HOST_INTERRUPT(x) (writel(TW_CONTROL_CLEAR_HOST_INTERRUPT, TW_CONTROL_REG_ADDR(x)))
@@ -655,7 +655,7 @@
 } TW_Compatibility_Info;
 
 typedef struct TAG_TW_Device_Extension {
-	u32                     *base_addr;
+	u32                     __iomem *base_addr;
 	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
 	unsigned long	       	generic_buffer_phys[TW_Q_LENGTH];
 	TW_Command_Full	       	*command_packet_virt[TW_Q_LENGTH];

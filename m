From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: rx check health function update
Date: Thu, 04 Nov 2004 16:09:52 -0800
Message-ID: <1099613392.6249.16.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:6035 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S262515AbUKEAJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2004 19:09:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch updates the rx check health function.  My previous only
updated the rkt check health code.  This and the previous patch should
fix the kmalloc return checking bug:

http://bugme.osdl.org/show_bug.cgi?id=3699 

Signed-off-by: Mark Haverkamp <markh@osdl.org>


===== drivers/scsi/aacraid/rx.c 1.12 vs edited =====
--- 1.12/drivers/scsi/aacraid/rx.c	2004-11-04 09:32:56 -08:00
+++ edited/drivers/scsi/aacraid/rx.c	2004-11-04 09:37:33 -08:00
@@ -274,7 +274,7 @@
  */
 static int aac_rx_check_health(struct aac_dev *dev)
 {
-	long status = rx_readl(dev, IndexRegs.Mailbox[7]);
+	u32 status = le32_to_cpu(rx_readl(dev, MUnit.OMRx[0]));
 
 	/*
 	 *	Check to see if the board failed any self tests.
@@ -285,29 +285,39 @@
 	 *	Check to see if the board panic'd.
 	 */
 	if (status & KERNEL_PANIC) {
-		char * buffer = kmalloc(512, GFP_KERNEL);
+		char * buffer;
 		struct POSTSTATUS {
 			u32 Post_Command;
 			u32 Post_Address;
-		} * post = kmalloc(sizeof(struct POSTSTATUS), GFP_KERNEL);
-		dma_addr_t paddr = pci_map_single(dev->pdev, post, sizeof(struct POSTSTATUS), 2);
-		dma_addr_t baddr = pci_map_single(dev->pdev, buffer, 512, 1);
-		u32 status = -1;
-		int ret = -2;
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
+		}
 		memset(buffer, 0, 512);
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
 		post->Post_Address = cpu_to_le32(baddr);
 		rx_writel(dev, MUnit.IMRx[0], cpu_to_le32(paddr));
 		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
-		pci_unmap_single(dev->pdev, paddr, sizeof(struct POSTSTATUS), 2);
-		kfree(post);
+		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
+		  post, paddr);
 		if ((buffer[0] == '0') && (buffer[1] == 'x')) {
 			ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
 			ret <<= 4;
 			ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
 		}
-		pci_unmap_single(dev->pdev, baddr, 512, 1);
-		kfree(buffer);
+		pci_free_consistent(dev->pdev, 512, buffer, baddr);
 		return ret;
 	}
 	/*
@@ -319,7 +329,7 @@
 	 *	Everything is OK
 	 */
 	return 0;
-} /* aac_rx_check_health */
+}
 
 /**
  *	aac_rx_init	-	initialize an i960 based AAC card

-- 
Mark Haverkamp <markh@osdl.org>


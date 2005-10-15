From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] dec_esp: Use the right address space macro
Date: Sat, 15 Oct 2005 02:44:26 +0100
Message-ID: <20051015014426.GA25340@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:48908 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S932218AbVJQKLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:11:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>

FYI.

Index: manual.git/drivers/scsi/dec_esp.c
===================================================================
--- manual.git.orig/drivers/scsi/dec_esp.c
+++ manual.git/drivers/scsi/dec_esp.c
@@ -513,14 +513,15 @@ static void dma_advance_sg(struct scsi_c
 static void pmaz_dma_drain(struct NCR_ESP *esp)
 {
 	memcpy(phys_to_virt(esp_virt_buffer),
-		(void *)KSEG1ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
-		scsi_current_length);
+	       (void *)CKSEG1ADDR(esp->slot + DEC_SCSI_SRAM +
+				  ESP_TGT_DMA_SIZE),
+	       scsi_current_length);
 }
 
 static void pmaz_dma_init_read(struct NCR_ESP *esp, u32 vaddress, int length)
 {
 	volatile u32 *dmareg =
-		(volatile u32 *)KSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
+		(volatile u32 *)CKSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
 
 	if (length > ESP_TGT_DMA_SIZE)
 		length = ESP_TGT_DMA_SIZE;
@@ -536,9 +537,10 @@ static void pmaz_dma_init_read(struct NC
 static void pmaz_dma_init_write(struct NCR_ESP *esp, u32 vaddress, int length)
 {
 	volatile u32 *dmareg =
-		(volatile u32 *)KSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
+		(volatile u32 *)CKSEG1ADDR(esp->slot + DEC_SCSI_DMAREG);
 
-	memcpy((void *)KSEG1ADDR(esp->slot + DEC_SCSI_SRAM + ESP_TGT_DMA_SIZE),
+	memcpy((void *)CKSEG1ADDR(esp->slot + DEC_SCSI_SRAM +
+				  ESP_TGT_DMA_SIZE),
 	       phys_to_virt(vaddress), length);
 
 	wmb();

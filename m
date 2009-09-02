From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/6] mptsas : PAE Kernel more than 4 GB kernel panic
Date: Wed, 2 Sep 2009 11:44:57 +0530
Message-ID: <20090902061446.GD20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:43092 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbZIBGiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:38:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


This patch is solving problem for PAE kernel DMA operation.
On PAE system dma_addr and unsigned long will have different
values.
Now dma_addr is not type casted using unsigned long.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 8ab7b37..76fa2ee 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1015,9 +1015,9 @@ mpt_add_sge_64bit(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
 {
 	SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
 	pSge->Address.Low = cpu_to_le32
-			(lower_32_bits((unsigned long)(dma_addr)));
+			(lower_32_bits(dma_addr));
 	pSge->Address.High = cpu_to_le32
-			(upper_32_bits((unsigned long)dma_addr));
+			(upper_32_bits(dma_addr));
 	pSge->FlagsLength = cpu_to_le32
 			((flagslength | MPT_SGE_FLAGS_64_BIT_ADDRESSING));
 }
@@ -1038,8 +1038,8 @@ mpt_add_sge_64bit_1078(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
 	u32 tmp;
 
 	pSge->Address.Low = cpu_to_le32
-			(lower_32_bits((unsigned long)(dma_addr)));
-	tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+			(lower_32_bits(dma_addr));
+	tmp = (u32)(upper_32_bits(dma_addr));
 
 	/*
 	 * 1078 errata workaround for the 36GB limitation
@@ -1101,7 +1101,7 @@ mpt_add_chain_64bit(void *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
 		pChain->NextChainOffset = next;
 
 		pChain->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+		tmp = (u32)(upper_32_bits(dma_addr));
 		pChain->Address.High = cpu_to_le32(tmp);
 }
 

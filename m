From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 14/19] aacraid: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:44 +0900 (JST)
Message-ID: <20070512184227Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55506 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXELKGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:06:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aacraid/aachba.c |   64 ++++-------------------------------------
 1 files changed, 6 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 1e82c69..5cdfea3 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -343,19 +343,14 @@ static void aac_internal_transfer(struct
 	unsigned int transfer_len;
 	struct scatterlist *sg = scsicmd->request_buffer;
 
-	if (scsicmd->use_sg) {
-		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
-		transfer_len = min(sg->length, len + offset);
-	} else {
-		buf = scsicmd->request_buffer;
-		transfer_len = min(scsicmd->request_bufflen, len + offset);
-	}
+	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	transfer_len = min(sg->length, len + offset);
+
 	transfer_len -= offset;
 	if (buf && transfer_len)
 		memcpy(buf + offset, data, transfer_len);
 
-	if (scsicmd->use_sg) 
-		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	kunmap_atomic(buf - sg->offset, KM_IRQ0);
 
 }
 
@@ -1374,10 +1369,7 @@ static void io_callback(void *context, s
 			(struct scatterlist *)scsicmd->request_buffer,
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
-	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
-				 scsicmd->request_bufflen,
-				 scsicmd->sc_data_direction);
+
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	if (le32_to_cpu(readreply->status) == ST_OK)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -2152,9 +2144,6 @@ static void aac_srb_callback(void *conte
 			(struct scatterlist *)scsicmd->request_buffer,
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
-	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle, scsicmd->request_bufflen,
-			scsicmd->sc_data_direction);
 
 	/*
 	 * First check the fib status
@@ -2375,18 +2364,6 @@ static unsigned long aac_build_sg(struct
 					byte_count, scsicmd->underflow);
 		}
 	}
-	else if(scsicmd->request_bufflen) {
-		u32 addr;
-		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
-				scsicmd->request_bufflen,
-				scsicmd->sc_data_direction);
-		addr = scsicmd->SCp.dma_handle;
-		psg->count = cpu_to_le32(1);
-		psg->sg[0].addr = cpu_to_le32(addr);
-		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		byte_count = scsicmd->request_bufflen;
-	}
 	return byte_count;
 }
 
@@ -2435,18 +2412,6 @@ static unsigned long aac_build_sg64(stru
 					byte_count, scsicmd->underflow);
 		}
 	}
-	else if(scsicmd->request_bufflen) {
-		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
-				scsicmd->request_bufflen,
-				scsicmd->sc_data_direction);
-		addr = scsicmd->SCp.dma_handle;
-		psg->count = cpu_to_le32(1);
-		psg->sg[0].addr[0] = cpu_to_le32(addr & 0xffffffff);
-		psg->sg[0].addr[1] = cpu_to_le32(addr >> 32);
-		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		byte_count = scsicmd->request_bufflen;
-	}
 	return byte_count;
 }
 
@@ -2464,6 +2429,7 @@ static unsigned long aac_build_sgraw(str
 	psg->sg[0].addr[1] = 0;
 	psg->sg[0].count = 0;
 	psg->sg[0].flags = 0;
+
 	if (scsicmd->use_sg) {
 		struct scatterlist *sg;
 		int i;
@@ -2499,24 +2465,6 @@ static unsigned long aac_build_sgraw(str
 					byte_count, scsicmd->underflow);
 		}
 	}
-	else if(scsicmd->request_bufflen) {
-		int count;
-		u64 addr;
-		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
-				scsicmd->request_bufflen,
-				scsicmd->sc_data_direction);
-		addr = scsicmd->SCp.dma_handle;
-		count = scsicmd->request_bufflen;
-		psg->count = cpu_to_le32(1);
-		psg->sg[0].next = 0;
-		psg->sg[0].prev = 0;
-		psg->sg[0].addr[1] = cpu_to_le32((u32)(addr>>32));
-		psg->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
-		psg->sg[0].count = cpu_to_le32(count);
-		psg->sg[0].flags = 0;
-		byte_count = scsicmd->request_bufflen;
-	}
 	return byte_count;
 }
 
-- 
1.4.3.2


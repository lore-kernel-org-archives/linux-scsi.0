From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/5] aacraid: update dma mapping
Date: Wed, 30 Nov 2005 10:36:18 -0800
Message-ID: <1133375778.2288.23.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32142 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751500AbVK3SgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:36:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch changes map_single to map_page in compliance with
recommendations made in the IO-Perf howto document to prevent bounce
buffering of DMA requests.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


Index: scsi-misc-aac/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2005-11-28 15:15:02.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2005-11-28 15:15:13.000000000 -0800
@@ -955,9 +955,9 @@
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
-				 scsicmd->request_bufflen,
-				 scsicmd->sc_data_direction);
+		pci_unmap_page(dev->pdev, scsicmd->SCp.dma_handle,
+			 scsicmd->request_bufflen,
+			 scsicmd->sc_data_direction);
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	if (le32_to_cpu(readreply->status) == ST_OK)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -1936,7 +1936,8 @@
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle, scsicmd->request_bufflen,
+		pci_unmap_page(dev->pdev, scsicmd->SCp.dma_handle,
+			scsicmd->request_bufflen,
 			scsicmd->sc_data_direction);
 
 	/*
@@ -2239,15 +2240,16 @@
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		dma_addr_t addr; 
-		addr = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
+		u32 addr;
+		scsicmd->SCp.dma_handle = pci_map_page(dev->pdev,
+				virt_to_page(scsicmd->request_buffer),
+				offset_in_page(scsicmd->request_buffer),
 				scsicmd->request_bufflen,
 				scsicmd->sc_data_direction);
+		addr = scsicmd->SCp.dma_handle;
 		psg->count = cpu_to_le32(1);
 		psg->sg[0].addr = cpu_to_le32(addr);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.dma_handle = addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;
@@ -2300,16 +2302,17 @@
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		u64 addr; 
-		addr = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
+		u64 addr;
+		scsicmd->SCp.dma_handle = pci_map_page(dev->pdev,
+				virt_to_page(scsicmd->request_buffer),
+				offset_in_page(scsicmd->request_buffer),
 				scsicmd->request_bufflen,
 				scsicmd->sc_data_direction);
+		addr = scsicmd->SCp.dma_handle;
 		psg->count = cpu_to_le32(1);
 		psg->sg[0].addr[0] = cpu_to_le32(addr & 0xffffffff);
 		psg->sg[0].addr[1] = cpu_to_le32(addr >> 32);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.dma_handle = addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;
@@ -2367,8 +2370,9 @@
 	else if(scsicmd->request_bufflen) {
 		int count;
 		u64 addr;
-		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
-				scsicmd->request_buffer,
+		scsicmd->SCp.dma_handle = pci_map_page(dev->pdev,
+				virt_to_page(scsicmd->request_buffer),
+				offset_in_page(scsicmd->request_buffer),
 				scsicmd->request_bufflen,
 				scsicmd->sc_data_direction);
 		addr = scsicmd->SCp.dma_handle;
Index: scsi-misc-aac/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2005-11-28 15:15:09.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2005-11-28 15:15:13.000000000 -0800
@@ -590,7 +590,9 @@
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+			addr = pci_map_page(dev->pdev, virt_to_page(p),
+			  	offset_in_page(p),
+				usg->sg[i].count, data_dir);
 
 			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
@@ -640,7 +642,8 @@
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p,
+			addr = pci_map_page(dev->pdev, virt_to_page(p),
+				offset_in_page(p),
 				upsg->sg[i].count, data_dir);
 
 			psg->sg[i].addr = cpu_to_le32(addr);

-- 
Mark Haverkamp <markh@osdl.org>


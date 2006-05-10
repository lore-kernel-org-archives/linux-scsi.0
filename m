From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/5] aacraid: optimize sg alloc
Date: Wed, 10 May 2006 09:12:05 -0700
Message-ID: <1147277525.29108.32.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:3204 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965004AbWEJQMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:12:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn

Slight space and speed efficiency improvement.


Signed-off-by: Mark Haverkamp <markh@osdl.org>

---
Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-04-17 13:22:34.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-04-17 13:23:57.000000000 -0700
@@ -2218,15 +2218,15 @@
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		dma_addr_t addr; 
-		addr = pci_map_single(dev->pdev,
+		u32 addr;
+		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
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

-- 
Mark Haverkamp <markh@osdl.org>


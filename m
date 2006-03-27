From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 7/11] aacraid: General driver cleanup
Date: Mon, 27 Mar 2006 09:44:23 -0800
Message-ID: <1143481463.21975.42.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40383 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751127AbWC0RoZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Remove superfluous code, optimize code, harden code, cast code, correct
some text, use msleep instead of schedule_timeout_interruptible. No
bugs.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-03-22 11:17:41.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-03-22 11:17:52.000000000 -0800
@@ -1606,13 +1606,14 @@
 		cp[11] = 0;
 		cp[12] = 0;
 		aac_internal_transfer(scsicmd, cp, 0,
-		  min((unsigned int)scsicmd->cmnd[13], sizeof(cp)));
+		  min_t(size_t, scsicmd->cmnd[13], sizeof(cp)));
 		if (sizeof(cp) < scsicmd->cmnd[13]) {
 			unsigned int len, offset = sizeof(cp);
 
 			memset(cp, 0, offset);
 			do {
-				len = min(scsicmd->cmnd[13]-offset, sizeof(cp));
+				len = min_t(size_t, scsicmd->cmnd[13] - offset,
+						sizeof(cp));
 				aac_internal_transfer(scsicmd, cp, offset, len);
 			} while ((offset += len) < scsicmd->cmnd[13]);
 		}
@@ -2079,7 +2080,6 @@
 		return 0;
 	}
 
-	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	switch(scsicmd->sc_data_direction){
 	case DMA_TO_DEVICE:
 		flag = SRB_DataOut;
@@ -2197,8 +2197,6 @@
 			scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(sg_count);
 
-		byte_count = 0;
-
 		for (i = 0; i < sg_count; i++) {
 			psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
 			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
@@ -2254,18 +2252,17 @@
 
 		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
 			scsicmd->sc_data_direction);
-		psg->count = cpu_to_le32(sg_count);
-
-		byte_count = 0;
 
 		for (i = 0; i < sg_count; i++) {
+			int count = sg_dma_len(sg);
 			addr = sg_dma_address(sg);
 			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
-			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
-			byte_count += sg_dma_len(sg);
+			psg->sg[i].count = cpu_to_le32(count);
+			byte_count += count;
 			sg++;
 		}
+		psg->count = cpu_to_le32(sg_count);
 		/* hba wants the size to be exact */
 		if(byte_count > scsicmd->request_bufflen){
 			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
@@ -2280,16 +2277,15 @@
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		u64 addr; 
-		addr = pci_map_single(dev->pdev,
+		scsicmd->SCp.dma_handle = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
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
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-03-22 11:17:44.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-03-22 11:17:52.000000000 -0800
@@ -767,9 +767,9 @@
 		if (cp[length] != 0)
 			cp[length] = 0;
 		if (level == LOG_AAC_HIGH_ERROR)
-			printk(KERN_WARNING "aacraid:%s", cp);
+			printk(KERN_WARNING "%s:%s", dev->name, cp);
 		else
-			printk(KERN_INFO "aacraid:%s", cp);
+			printk(KERN_INFO "%s:%s", dev->name, cp);
 	}
 	memset(cp, 0,  256);
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:50.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:52.000000000 -0800
@@ -72,7 +72,7 @@
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
 MODULE_DESCRIPTION("Dell PERC2, 2/Si, 3/Si, 3/Di, "
 		   "Adaptec Advanced Raid Products, "
-		   "and HP NetRAID-4M SCSI driver");
+		   "HP NetRAID-4M, IBM ServeRAID & ICP SCSI driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
 
@@ -776,6 +776,7 @@
 	.cmd_per_lun    		= AAC_NUM_IO_FIB, 
 #endif	
 	.use_clustering			= ENABLE_CLUSTERING,
+	.emulated                       = 1,
 };
 
 
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rkt.c	2006-03-22 11:12:21.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/rkt.c	2006-03-22 11:17:52.000000000 -0800
@@ -183,7 +183,7 @@
 		/*
 		 *	Yield the processor in case we are slow 
 		 */
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 	if (ok != 1) {
 		/*
@@ -343,7 +343,7 @@
 		  NULL, NULL, NULL, NULL, NULL);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
-                if ((buffer[0] == '0') && (buffer[1] == 'x')) {
+                if ((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X'))) {
                         ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
                         ret <<= 4;
                         ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/rx.c	2006-03-22 11:12:21.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/rx.c	2006-03-22 11:17:52.000000000 -0800
@@ -183,7 +183,7 @@
 		/*
 		 *	Yield the processor in case we are slow 
 		 */
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 	if (ok != 1) {
 		/*
@@ -342,7 +342,7 @@
 		  NULL, NULL, NULL, NULL, NULL);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
-		if ((buffer[0] == '0') && (buffer[1] == 'x')) {
+		if ((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X'))) {
 			ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
 			ret <<= 4;
 			ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/sa.c	2006-03-22 11:12:21.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/sa.c	2006-03-22 11:17:52.000000000 -0800
@@ -189,7 +189,7 @@
 			ok = 1;
 			break;
 		}
-		schedule_timeout_uninterruptible(1);
+		msleep(1);
 	}
 
 	if (ok != 1)

-- 
Mark Haverkamp <markh@osdl.org>


From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid driver update
Date: Tue, 10 Aug 2004 09:34:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092155692.31138.39.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:64183 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S267491AbUHJQe4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 12:34:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Here are some changes from Adaptec for the AACRAID driver.

Change the pae_support flag to dac_support.  This was suggested sometime
last year and never made it in.
Fix some cast problems in pci_set_dma_mask.  Was casting the mask to
dma_addr_t when it should be a u64.
Fix SCp.ptr problem, should be SCp.dma_handle.

Applies to the scsi-misc bk tree.

Signed-off by: Mark Haverkamp <markh@osdl.org>


===== drivers/scsi/aacraid/aachba.c 1.25 vs edited =====
--- 1.25/drivers/scsi/aacraid/aachba.c	2004-07-12 01:00:54 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-08-10 09:26:16 -07:00
@@ -179,6 +179,20 @@
 static char *aac_get_status_string(u32 status);
 #endif
 
+/*
+ *	Non dasd selection is handled entirely in aachba now
+ */	
+ 
+MODULE_PARM(nondasd, "i");
+MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
+MODULE_PARM(dacmode, "i");
+MODULE_PARM_DESC(dacmode, "Control whether dma addressing is using 64 bit DAC. 0=off, 1=on");
+MODULE_PARM(commit, "i");
+MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the adapter for foreign arrays.\nThis is typically needed in systems that do not have a BIOS. 0=off, 1=on");
+
+static int nondasd = -1;
+static int dacmode = -1;
+
 /**
  *	aac_get_containers	-	list containers
  *	@common: adapter to probe
@@ -481,8 +495,7 @@
 
 	dev->nondasd_support = 0;
 	if(dev->adapter_info.options & AAC_OPT_NONDASD){
-//		dev->nondasd_support = 1;
-// dmb - temporarily disable nondasd
+		dev->nondasd_support = 1;
 	}
 	if(nondasd != -1) {  
 		dev->nondasd_support = (nondasd!=0);
@@ -491,18 +504,30 @@
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 	}
 
-	dev->pae_support = 0;
+	dev->dac_support = 0;
 	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
 		printk(KERN_INFO "%s%d: 64bit support enabled.\n", dev->name, dev->id);
-		dev->pae_support = 1;
+		dev->dac_support = 1;
 	}
 
-	if(paemode != -1){
-		dev->pae_support = (paemode!=0);
+	if(dacmode != -1) {
+		dev->dac_support = (dacmode!=0);
 	}
-	if(dev->pae_support != 0) {
-		printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", dev->name, dev->id);
-		pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
+	if(dev->dac_support != 0) {
+		if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL) &&
+			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL)) {
+			printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
+				dev->name, dev->id);
+		} else if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFULL) &&
+			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFULL)) {
+			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
+				dev->name, dev->id);
+			dev->dac_support = 0;
+		} else {
+			printk(KERN_WARNING"%s%d: No suitable DMA available.\n",
+				dev->name, dev->id);
+			rcode = -ENOMEM;
+		}
 	}
 
 	fib_complete(fibptr);
@@ -537,7 +562,7 @@
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
 				 scsicmd->request_bufflen,
 				 scsicmd->sc_data_direction);
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
@@ -582,7 +607,7 @@
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle,
 				 scsicmd->request_bufflen,
 				 scsicmd->sc_data_direction);
 
@@ -644,7 +669,7 @@
 
 	fib_init(cmd_fibcontext);
 
-	if(dev->pae_support == 1){
+	if(dev->dac_support == 1) {
 		struct aac_read64 *readcmd;
 		readcmd = (struct aac_read64 *) fib_data(cmd_fibcontext);
 		readcmd->command = cpu_to_le32(VM_CtHostRead64);
@@ -752,7 +777,7 @@
 	}
 	fib_init(cmd_fibcontext);
 
-	if(dev->pae_support == 1){
+	if(dev->dac_support == 1) {
 		struct aac_write64 *writecmd;
 		writecmd = (struct aac_write64 *) fib_data(cmd_fibcontext);
 		writecmd->command = cpu_to_le32(VM_CtHostWrite64);
@@ -1220,7 +1245,7 @@
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
-		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
+		pci_unmap_single(dev->pdev, scsicmd->SCp.dma_handle, scsicmd->request_bufflen,
 			scsicmd->sc_data_direction);
 
 	/*
@@ -1348,7 +1373,12 @@
 	case SRB_STATUS_DOMAIN_VALIDATION_FAIL:
 	default:
 #ifdef AAC_DETAILED_STATUS_INFO
-		printk("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",le32_to_cpu(srbreply->srb_status&0x3f),aac_get_status_string(le32_to_cpu(srbreply->srb_status)), scsicmd->cmnd[0], le32_to_cpu(srbreply->scsi_status) );
+		printk("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
+			le32_to_cpu(srbreply->srb_status & 0x3F),
+			aac_get_status_string(
+				le32_to_cpu(srbreply->srb_status) & 0x3F), 
+			scsicmd->cmnd[0], 
+			le32_to_cpu(srbreply->scsi_status));
 #endif
 		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 		break;
@@ -1358,7 +1388,10 @@
 		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
 		len = (srbreply->sense_data_size > sizeof(scsicmd->sense_buffer))?
 				sizeof(scsicmd->sense_buffer):srbreply->sense_data_size;
-		dprintk((KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n", le32_to_cpu(srbreply->status), len));
+#ifdef AAC_DETAILED_STATUS_INFO
+		dprintk((KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n", 
+					le32_to_cpu(srbreply->status), len));
+#endif
 		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
 		
 	}
@@ -1437,7 +1470,7 @@
 	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(scsicmd->cmd_len);
 	
-	if( dev->pae_support ==1 ) {
+	if( dev->dac_support == 1 ) {
 		aac_build_sg64(scsicmd, (struct sgmap64*) &srbcmd->sg);
 		srbcmd->count = cpu_to_le32(scsicmd->request_bufflen);
 
@@ -1532,7 +1565,7 @@
 		psg->count = cpu_to_le32(1);
 		psg->sg[0].addr = cpu_to_le32(addr);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.ptr = (char *)(ulong)addr;
+		scsicmd->SCp.dma_handle = addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;
@@ -1593,7 +1626,7 @@
 		psg->sg[0].addr[1] = (u32)(le_addr>>32);
 		psg->sg[0].addr[0] = (u32)(le_addr & 0xffffffff);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
-		scsicmd->SCp.ptr = (char *)(ulong)addr;
+		scsicmd->SCp.dma_handle = addr;
 		byte_count = scsicmd->request_bufflen;
 	}
 	return byte_count;
===== drivers/scsi/aacraid/aacraid.h 1.18 vs edited =====
--- 1.18/drivers/scsi/aacraid/aacraid.h	2004-07-26 14:39:04 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-08-10 08:12:00 -07:00
@@ -28,10 +28,7 @@
 #define aac_phys_to_logical(x)  (x+1)
 #define aac_logical_to_phys(x)  (x?x-1:0)
 
-#define AAC_DETAILED_STATUS_INFO
-
-extern int nondasd;
-extern int paemode;
+/* #define AAC_DETAILED_STATUS_INFO */
 
 struct diskparm
 {
@@ -841,7 +838,7 @@
 	 * lets break them out so we don't have to do an AND to check them
 	 */
 	u8			nondasd_support; 
-	u8			pae_support;
+	u8			dac_support;
 };
 
 #define AllocateAndMapFibSpace(dev, MapFibContext) \
===== drivers/scsi/aacraid/commctrl.c 1.8 vs edited =====
--- 1.8/drivers/scsi/aacraid/commctrl.c	2004-07-12 01:00:54 -07:00
+++ edited/drivers/scsi/aacraid/commctrl.c	2004-08-09 15:07:39 -07:00
@@ -480,7 +480,7 @@
 	default:
 		data_dir = DMA_NONE;
 	}
-	if (dev->pae_support == 1) {
+	if (dev->dac_support == 1) {
 		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
 		byte_count = 0;
 
===== drivers/scsi/aacraid/linit.c 1.35 vs edited =====
--- 1.35/drivers/scsi/aacraid/linit.c	2004-08-09 14:56:25 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-08-09 15:07:34 -07:00
@@ -64,15 +64,6 @@
 MODULE_LICENSE("GPL");
 MODULE_VERSION(AAC_DRIVER_VERSION);
 
-
-int nondasd = -1;
-module_param(nondasd, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
-
-int paemode = -1;
-module_param(paemode, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(paemode, "Control whether dma addressing is using PAE. 0=off, 1=on");
-
 struct aac_dev *aac_devices[MAXIMUM_NUM_ADAPTERS];
 static unsigned aac_count;
 static int aac_cfg_major = -1;

-- 
Mark Haverkamp <markh@osdl.org>


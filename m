From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: [PATCH] ips driver for 2.4.23-pre4
Date: Wed, 07 Jan 2004 20:17:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFC5B2C.6000302@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080402020808090605020907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.eresmas.com ([62.81.235.111]:12248 "EHLO
	smtp11.eresmas.com") by vger.kernel.org with ESMTP id S265431AbUAGTSJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 14:18:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

This is a multi-part message in MIME format.
--------------080402020808090605020907
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

hi,

latest driver update for 2.4 kernel:
- Get VersionInfo buffer off the stack !
- Make Logical Drive Info structure safe for DMA
- Support for x86_64

-thanks-


--------------080402020808090605020907
Content-Type: text/plain;
 name="ips.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ips.patch"

diff -Nuar o/drivers/scsi/ips.c n/drivers/scsi/ips.c
--- o/drivers/scsi/ips.c	2004-01-07 20:12:06.000000000 +0100
+++ n/drivers/scsi/ips.c	2003-11-21 17:06:02.000000000 +0100
@@ -131,6 +131,8 @@
 /* 5.30.00  - use __devexit_p()                                              */
 /* 6.00.00  - Add 6x Adapters and Battery Flash                              */
 /* 6.10.00  - Remove 1G Addressing Limitations                               */
+/* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS 60401 */
+/* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS 60639 */
 /*****************************************************************************/
 
 /*
@@ -196,11 +198,11 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "6.10"
-#define IPS_VERSION_LOW         ".24 "
+#define IPS_VERSION_HIGH        "6.11"
+#define IPS_VERSION_LOW         ".07 "
 
-#if !defined(__i386__) && !defined(__ia64__)
-#error "This driver has only been tested on the x86/ia64 platforms"
+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
+#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
 #endif
 
 #if LINUX_VERSION_CODE <= LinuxVersionCode(2,5,0)
@@ -245,6 +247,7 @@
 static int ips_ioctlsize = IPS_IOCTL_SIZE;	/* Size of the ioctl buffer        */
 static int ips_cd_boot;		/* Booting from Manager CD         */
 static char *ips_FlashData = NULL;	/* CD Boot - Flash Data Buffer      */
+static dma_addr_t ips_flashbusaddr;
 static long ips_FlashDataInUse;	/* CD Boot - Flash Data In Use Flag */
 static uint32_t MaxLiteCmds = 32;	/* Max Active Cmds for a Lite Adapter */
 static Scsi_Host_Template ips_driver_template = IPS;
@@ -468,8 +471,7 @@
 static int ips_host_info(ips_ha_t *, char *, off_t, int);
 static void copy_mem_info(IPS_INFOSTR *, char *, int);
 static int copy_info(IPS_INFOSTR *, char *, ...);
-static int ips_get_version_info(ips_ha_t * ha, IPS_VERSION_DATA * Buffer,
-				int intr);
+static int ips_get_version_info(ips_ha_t * ha, dma_addr_t, int intr);
 static void ips_version_check(ips_ha_t * ha, int intr);
 static int ips_abort_init(ips_ha_t * ha, int index);
 static int ips_init_phase2(int index);
@@ -559,17 +561,6 @@
 		ips_setup(ips);
 #endif
 
-	/* If Booting from the Manager CD, Allocate a large Flash        */
-	/* Buffer ( so we won't need to allocate one for each adapter ). */
-	if (ips_cd_boot) {
-		ips_FlashData = (char *) __get_free_pages(IPS_INIT_GFP, 7);
-		if (ips_FlashData == NULL) {
-			/* The validity of this pointer is checked in ips_make_passthru() before it is used */
-			printk(KERN_WARNING
-			       "ERROR: Can't Allocate Large Buffer for Flashing\n");
-		}
-	}
-
 	SHT->proc_info = ips_proc_info;
 	SHT->proc_name = "ips";
 
@@ -1578,21 +1569,20 @@
 ips_alloc_passthru_buffer(ips_ha_t * ha, int length)
 {
 	void *bigger_buf;
-	int count;
-	int order;
+	dma_addr_t dma_busaddr;
 
-	if (ha->ioctl_data && length <= (PAGE_SIZE << ha->ioctl_order))
+	if (ha->ioctl_data && length <= ha->ioctl_len)
 		return 0;
 	/* there is no buffer or it's not big enough, allocate a new one */
-	for (count = PAGE_SIZE, order = 0;
-	     count < length; order++, count <<= 1) ;
-	bigger_buf = (void *) __get_free_pages(IPS_ATOMIC_GFP, order);
+	bigger_buf = pci_alloc_consistent(ha->pcidev, length, &dma_busaddr);
 	if (bigger_buf) {
 		/* free the old memory */
-		free_pages((unsigned long) ha->ioctl_data, ha->ioctl_order);
+		pci_free_consistent(ha->pcidev, ha->ioctl_len, ha->ioctl_data,
+				    ha->ioctl_busaddr);
 		/* use the new memory */
 		ha->ioctl_data = (char *) bigger_buf;
-		ha->ioctl_order = order;
+		ha->ioctl_len = length;
+		ha->ioctl_busaddr = dma_busaddr;
 	} else {
 		return -1;
 	}
@@ -1708,7 +1698,7 @@
 static int
 ips_flash_copperhead(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 {
-	int datasize, count;
+	int datasize;
 
 	/* Trombone is the only copperhead that can do packet flash, but only
 	 * for firmware. No one said it had to make sence. */
@@ -1728,24 +1718,28 @@
 		pt->BasicStatus = 0;
 		return ips_flash_bios(ha, pt, scb);
 	} else if (pt->CoppCP.cmd.flashfw.packet_num == 0) {
-		if (ips_FlashData && !test_and_set_bit(0, &ips_FlashDataInUse)) {
+		if (ips_FlashData && !test_and_set_bit(0, &ips_FlashDataInUse)){
 			ha->flash_data = ips_FlashData;
-			ha->flash_order = 7;
+			ha->flash_busaddr = ips_flashbusaddr;
+			ha->flash_len = PAGE_SIZE << 7;
 			ha->flash_datasize = 0;
 		} else if (!ha->flash_data) {
 			datasize = pt->CoppCP.cmd.flashfw.total_packets *
 			    pt->CoppCP.cmd.flashfw.count;
-			for (count = PAGE_SIZE, ha->flash_order = 0;
-			     count < datasize; ha->flash_order++, count <<= 1) ;
-			ha->flash_data =
-			    (char *) __get_free_pages(IPS_ATOMIC_GFP,
-						      ha->flash_order);
+			ha->flash_data = pci_alloc_consistent(ha->pcidev,
+					                      datasize,
+							      &ha->flash_busaddr);
+			if (!ha->flash_data){
+				printk(KERN_WARNING "Unable to allocate a flash buffer\n");
+				return IPS_FAILURE;
+			}
 			ha->flash_datasize = 0;
+			ha->flash_len = datasize;
 		} else
 			return IPS_FAILURE;
 	} else {
 		if (pt->CoppCP.cmd.flashfw.count + ha->flash_datasize >
-		    (PAGE_SIZE << ha->flash_order)) {
+		    ha->flash_len) {
 			ips_free_flash_copperhead(ha);
 			printk(KERN_WARNING "failed size sanity check\n");
 			return IPS_FAILURE;
@@ -1928,7 +1922,8 @@
 	if (ha->flash_data == ips_FlashData)
 		test_and_clear_bit(0, &ips_FlashDataInUse);
 	else if (ha->flash_data)
-		free_pages((unsigned long) ha->flash_data, ha->flash_order);
+		pci_free_consistent(ha->pcidev, ha->flash_len, ha->flash_data,
+				    ha->flash_busaddr);
 	ha->flash_data = NULL;
 }
 
@@ -1981,12 +1976,7 @@
 
 	if (pt->CmdBSize) {
 		scb->data_len = pt->CmdBSize;
-		scb->data_busaddr = pci_map_single(ha->pcidev,
-						   ha->ioctl_data +
-						   sizeof (ips_passthru_t),
-						   pt->CmdBSize,
-						   IPS_DMA_DIR(scb));
-		scb->flags |= IPS_SCB_MAP_SINGLE;
+		scb->data_busaddr = ha->ioctl_busaddr + sizeof (ips_passthru_t);
 	} else {
 		scb->data_busaddr = 0L;
 	}
@@ -2410,9 +2400,7 @@
 	} else {
 		/* Morpheus Family - Send Command to the card */
 
-		buffer = kmalloc(0x1000, IPS_ATOMIC_GFP);
-		if (!buffer)
-			return;
+		buffer = ha->ioctl_data;
 
 		memset(buffer, 0, 0x1000);
 
@@ -2431,11 +2419,7 @@
 		scb->cmd.flashfw.total_packets = 1;
 		scb->cmd.flashfw.packet_num = 0;
 		scb->data_len = 0x1000;
-		scb->data_busaddr =
-		    pci_map_single(ha->pcidev, buffer, scb->data_len,
-				   IPS_DMA_DIR(scb));
-		scb->cmd.flashfw.buffer_addr = scb->data_busaddr;
-		scb->flags |= IPS_SCB_MAP_SINGLE;
+		scb->cmd.flashfw.buffer_addr = ha->ioctl_busaddr;
 
 		/* issue the command */
 		if (
@@ -2443,7 +2427,6 @@
 		     IPS_FAILURE) || (ret == IPS_SUCCESS_IMM)
 		    || ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1)) {
 			/* Error occurred */
-			kfree(buffer);
 
 			return;
 		}
@@ -2453,11 +2436,8 @@
 			minor = buffer[0x1fe + 0xC0];	/* Offset 0x1fe after the header (0xc0) */
 			subminor = buffer[0x1fd + 0xC0];	/* Offset 0x1fd after the header (0xc0) */
 		} else {
-			kfree(buffer);
 			return;
 		}
-
-		kfree(buffer);
 	}
 
 	ha->bios_version[0] = hexDigits[(major & 0xF0) >> 4];
@@ -2806,6 +2786,11 @@
 		scb->dcdb.cmd_attribute =
 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
+        /* Allow a WRITE BUFFER Command to Have no Data */
+        /* This is Used by Tape Flash Utilites          */
+        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
+            scb->dcdb.cmd_attribute = 0;                  
+
 		if (!(scb->dcdb.cmd_attribute & 0x3))
 			scb->dcdb.transfer_length = 0;
 
@@ -3786,23 +3771,14 @@
 					scb->scsi_cmd->result = DID_OK << 16;
 				}
 			} else {
-				scb->cmd.logical_info.op_code =
-				    IPS_CMD_GET_LD_INFO;
-				scb->cmd.logical_info.command_id =
-				    IPS_COMMAND_ID(ha, scb);
+				scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
+				scb->cmd.logical_info.command_id = IPS_COMMAND_ID(ha, scb);
 				scb->cmd.logical_info.reserved = 0;
 				scb->cmd.logical_info.reserved2 = 0;
-				scb->data_len =
-				    sizeof (ha->adapt->logical_drive_info);
-				scb->data_busaddr =
-				    pci_map_single(ha->pcidev,
-						   &ha->adapt->
-						   logical_drive_info,
-						   scb->data_len,
-						   IPS_DMA_DIR(scb));
-				scb->flags |= IPS_SCB_MAP_SINGLE;
-				scb->cmd.logical_info.buffer_addr =
-				    scb->data_busaddr;
+				scb->data_len = sizeof (IPS_LD_INFO);
+				scb->data_busaddr = ha->logical_drive_info_dma_addr;
+				scb->flags = 0;
+				scb->cmd.logical_info.buffer_addr = scb->data_busaddr;
 				ret = IPS_SUCCESS;
 			}
 
@@ -3930,28 +3906,19 @@
 			scb->cmd.basic_io.segment_4G = 0;
 			scb->cmd.basic_io.enhanced_sg = 0;
 			scb->data_len = sizeof (*ha->enq);
-			scb->data_busaddr = pci_map_single(ha->pcidev, ha->enq,
-							   scb->data_len,
-							   IPS_DMA_DIR(scb));
-			scb->cmd.basic_io.sg_addr = scb->data_busaddr;
-			scb->flags |= IPS_SCB_MAP_SINGLE;
+			scb->cmd.basic_io.sg_addr = ha->enq_busaddr;
 			ret = IPS_SUCCESS;
 			break;
 
 		case READ_CAPACITY:
 			scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
-			scb->cmd.logical_info.command_id =
-			    IPS_COMMAND_ID(ha, scb);
+			scb->cmd.logical_info.command_id = IPS_COMMAND_ID(ha, scb);
 			scb->cmd.logical_info.reserved = 0;
 			scb->cmd.logical_info.reserved2 = 0;
 			scb->cmd.logical_info.reserved3 = 0;
-			scb->data_len = sizeof (ha->adapt->logical_drive_info);
-			scb->data_busaddr = pci_map_single(ha->pcidev,
-							   &ha->adapt->
-							   logical_drive_info,
-							   scb->data_len,
-							   IPS_DMA_DIR(scb));
-			scb->flags |= IPS_SCB_MAP_SINGLE;
+			scb->data_len = sizeof (IPS_LD_INFO);
+            scb->data_busaddr = ha->logical_drive_info_dma_addr;
+			scb->flags = 0;
 			scb->cmd.logical_info.buffer_addr = scb->data_busaddr;
 			ret = IPS_SUCCESS;
 			break;
@@ -4275,19 +4242,17 @@
 		return (0);
 
 	if ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1) {
-		memset(&ha->adapt->logical_drive_info, 0,
-		       sizeof (ha->adapt->logical_drive_info));
-
-		return (0);
+		memset(ha->logical_drive_info, 0, sizeof (IPS_LD_INFO));
+        return (0);
 	}
 
-	if (ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	if (ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_OFFLINE
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_FREE
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_CRS
-	    && ha->adapt->logical_drive_info.drive_info[scb->target_id].state !=
+	    && ha->logical_drive_info->drive_info[scb->target_id].state !=
 	    IPS_LD_SYS) return (1);
 	else
 		return (0);
@@ -4349,7 +4314,7 @@
 
 	cap.lba =
 	    cpu_to_be32(le32_to_cpu
-			(ha->adapt->logical_drive_info.
+			(ha->logical_drive_info->
 			 drive_info[scb->target_id].sector_count) - 1);
 	cap.len = cpu_to_be32((uint32_t) IPS_BLKSIZE);
 
@@ -4488,7 +4453,8 @@
 
 	if (ha) {
 		if (ha->enq) {
-			kfree(ha->enq);
+			pci_free_consistent(ha->pcidev, sizeof(IPS_ENQ),
+					    ha->enq, ha->enq_busaddr);
 			ha->enq = NULL;
 		}
 
@@ -4503,6 +4469,14 @@
 					    sizeof (IPS_IO_CMD), ha->adapt,
 					    ha->adapt->hw_status_start);
 			ha->adapt = NULL;
+		}  	
+        	
+        if (ha->logical_drive_info) {
+			pci_free_consistent(ha->pcidev,
+					    sizeof (IPS_LD_INFO),
+                        ha->logical_drive_info,
+					    ha->logical_drive_info_dma_addr);
+			ha->logical_drive_info = NULL;
 		}
 
 		if (ha->nvram) {
@@ -4516,11 +4490,11 @@
 		}
 
 		if (ha->ioctl_data) {
-			free_pages((unsigned long) ha->ioctl_data,
-				   ha->ioctl_order);
+			pci_free_consistent(ha->pcidev, ha->ioctl_len,
+					    ha->ioctl_data, ha->ioctl_busaddr);
 			ha->ioctl_data = NULL;
 			ha->ioctl_datasize = 0;
-			ha->ioctl_order = 0;
+			ha->ioctl_len = 0;
 		}
 		ips_deallocatescbs(ha, ha->max_cmds);
 
@@ -4694,6 +4668,7 @@
 	}
 
 	ha->scb_freelist = scb->q_next;
+    scb->flags = 0;
 	scb->q_next = NULL;
 
 	ips_init_scb(ha, scb);
@@ -5861,10 +5836,7 @@
 	scb->cmd.basic_io.sector_count = 0;
 	scb->cmd.basic_io.log_drv = 0;
 	scb->data_len = sizeof (*ha->enq);
-	scb->data_busaddr = pci_map_single(ha->pcidev, ha->enq, scb->data_len,
-					   IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr = ha->enq_busaddr;
 
 	/* send command */
 	if (
@@ -5907,10 +5879,7 @@
 	scb->cmd.basic_io.sector_count = 0;
 	scb->cmd.basic_io.log_drv = 0;
 	scb->data_len = sizeof (*ha->subsys);
-	scb->data_busaddr = pci_map_single(ha->pcidev, ha->subsys,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr = ha->ioctl_busaddr;
 
 	/* send command */
 	if (
@@ -5919,6 +5888,7 @@
 	    || ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1))
 		return (0);
 
+	memcpy(ha->subsys, ha->ioctl_data, sizeof(*ha->subsys));
 	return (1);
 }
 
@@ -5954,10 +5924,7 @@
 	scb->cmd.basic_io.op_code = IPS_CMD_READ_CONF;
 	scb->cmd.basic_io.command_id = IPS_COMMAND_ID(ha, scb);
 	scb->data_len = sizeof (*ha->conf);
-	scb->data_busaddr = pci_map_single(ha->pcidev, ha->conf,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr = ha->ioctl_busaddr;
 
 	/* send command */
 	if (
@@ -5977,7 +5944,8 @@
 
 		return (0);
 	}
-
+	
+	memcpy(ha->conf, ha->ioctl_data, sizeof(*ha->conf));
 	return (1);
 }
 
@@ -6012,11 +5980,10 @@
 	scb->cmd.nvram.reserved = 0;
 	scb->cmd.nvram.reserved2 = 0;
 	scb->data_len = sizeof (*ha->nvram);
-	scb->data_busaddr = pci_map_single(ha->pcidev, ha->nvram,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.nvram.buffer_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
-
+	scb->cmd.nvram.buffer_addr = ha->ioctl_busaddr;
+	if (write)
+		memcpy(ha->ioctl_data, ha->nvram, sizeof(*ha->nvram));
+	
 	/* issue the command */
 	if (
 	    ((ret = ips_send_wait(ha, scb, ips_cmd_timeout, intr)) ==
@@ -6027,7 +5994,8 @@
 
 		return (0);
 	}
-
+	if (!write)
+		memcpy(ha->nvram, ha->ioctl_data, sizeof(*ha->nvram));
 	return (1);
 }
 
@@ -6155,7 +6123,7 @@
 	scb->cmd.ffdc.op_code = IPS_CMD_FFDC;
 	scb->cmd.ffdc.command_id = IPS_COMMAND_ID(ha, scb);
 	scb->cmd.ffdc.reset_count = 0;
-	scb->cmd.ffdc.reset_type = 0x80;
+	scb->cmd.ffdc.reset_type = 0;
 
 	/* convert time to what the card wants */
 	ips_fix_ffdc_time(ha, scb, ha->last_ffdc);
@@ -6750,16 +6718,18 @@
 static void
 ips_version_check(ips_ha_t * ha, int intr)
 {
-	IPS_VERSION_DATA VersionInfo;
+	IPS_VERSION_DATA *VersionInfo;
 	uint8_t FirmwareVersion[IPS_COMPAT_ID_LENGTH + 1];
 	uint8_t BiosVersion[IPS_COMPAT_ID_LENGTH + 1];
 	int MatchError;
-	int rc;
+	int  rc;
 	char BiosString[10];
 	char FirmwareString[10];
 
 	METHOD_TRACE("ips_version_check", 1);
 
+    VersionInfo = ( IPS_VERSION_DATA * ) ha->ioctl_data;
+
 	memset(FirmwareVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
 	memset(BiosVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
 
@@ -6769,10 +6739,11 @@
 
 	rc = IPS_FAILURE;
 	if (ha->subsys->param[4] & IPS_GET_VERSION_SUPPORT) {	/* If Versioning is Supported */
+        memset( VersionInfo, 0, sizeof (IPS_VERSION_DATA));
 		/* Get the Version Info with a Get Version Command */
-		rc = ips_get_version_info(ha, &VersionInfo, intr);
+		rc = ips_get_version_info(ha, ha->ioctl_busaddr, intr);
 		if (rc == IPS_SUCCESS)
-			memcpy(FirmwareVersion, VersionInfo.compatibilityId,
+			memcpy(FirmwareVersion, VersionInfo->compatibilityId,
 			       IPS_COMPAT_ID_LENGTH);
 	}
 
@@ -6835,14 +6806,13 @@
 /*     0 if Successful, else non-zero                                        */
 /*---------------------------------------------------------------------------*/
 static int
-ips_get_version_info(ips_ha_t * ha, IPS_VERSION_DATA * Buffer, int intr)
+ips_get_version_info(ips_ha_t * ha, dma_addr_t Buffer, int intr)
 {
 	ips_scb_t *scb;
 	int rc;
 
 	METHOD_TRACE("ips_get_version_info", 1);
 
-	memset(Buffer, 0, sizeof (IPS_VERSION_DATA));
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -6854,11 +6824,10 @@
 	scb->cmd.version_info.reserved = 0;
 	scb->cmd.version_info.count = sizeof (IPS_VERSION_DATA);
 	scb->cmd.version_info.reserved2 = 0;
-	scb->data_len = sizeof (*Buffer);
-	scb->data_busaddr = pci_map_single(ha->pcidev, Buffer,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.version_info.buffer_addr = scb->data_busaddr;
-	scb->flags |= IPS_SCB_MAP_SINGLE;
+	scb->data_len = sizeof (IPS_VERSION_DATA);
+    scb->data_busaddr = Buffer;
+	scb->cmd.version_info.buffer_addr = Buffer;
+	scb->flags = 0;
 
 	/* issue command */
 	rc = ips_send_wait(ha, scb, ips_cmd_timeout, intr);
@@ -7176,7 +7145,6 @@
 	uint16_t subdevice_id;
 	int j;
 	int index;
-	uint32_t count;
 	dma_addr_t dma_address;
 	char *ioremap_ptr;
 	char *mem_ptr;
@@ -7292,17 +7260,21 @@
 	 * are guaranteed to be < 4G.
 	 */
 	if (IPS_ENABLE_DMA64 && IPS_HAS_ENH_SGLIST(ha) &&
-	    !pci_set_dma_mask(ha->pcidev, (u64) 0xffffffffffffffff)) {
+	    !pci_set_dma_mask(ha->pcidev, 0xffffffffffffffffULL)) {
 		(ha)->flags |= IPS_HA_ENH_SG;
 	} else {
-		if (pci_set_dma_mask(ha->pcidev, (u64) 0xffffffff) != 0) {
+		if (pci_set_dma_mask(ha->pcidev, 0xffffffffULL) != 0) {
 			printk(KERN_WARNING "Unable to set DMA Mask\n");
 			return ips_abort_init(ha, index);
 		}
 	}
-
-	ha->enq = kmalloc(sizeof (IPS_ENQ), IPS_INIT_GFP);
-
+	if(ips_cd_boot && !ips_FlashData){
+		ips_FlashData = pci_alloc_consistent(pci_dev, PAGE_SIZE << 7,
+						     &ips_flashbusaddr);
+	}
+	
+	ha->enq = pci_alloc_consistent(pci_dev, sizeof (IPS_ENQ),
+				       &ha->enq_busaddr);
 	if (!ha->enq) {
 		printk(KERN_WARNING
 		       "Unable to allocate host inquiry structure\n");
@@ -7318,15 +7290,24 @@
 	}
 	ha->adapt->hw_status_start = dma_address;
 	ha->dummy = (void *) (ha->adapt + 1);
-
-	ha->conf = kmalloc(sizeof (IPS_CONF), IPS_INIT_GFP);
+    
+	ha->logical_drive_info = pci_alloc_consistent(pci_dev, sizeof (IPS_LD_INFO),
+                                                  &dma_address);
+	if (!ha->logical_drive_info) {
+		printk(KERN_WARNING
+		       "Unable to allocate host logical drive info structure\n");
+		return ips_abort_init(ha, index);
+	}
+	ha->logical_drive_info_dma_addr = dma_address;
+    
+	ha->conf = kmalloc(sizeof (IPS_CONF), GFP_KERNEL);
 
 	if (!ha->conf) {
 		printk(KERN_WARNING "Unable to allocate host conf structure\n");
 		return ips_abort_init(ha, index);
 	}
 
-	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), IPS_INIT_GFP);
+	ha->nvram = kmalloc(sizeof (IPS_NVRAM_P5), GFP_KERNEL);
 
 	if (!ha->nvram) {
 		printk(KERN_WARNING
@@ -7334,7 +7315,7 @@
 		return ips_abort_init(ha, index);
 	}
 
-	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), IPS_INIT_GFP);
+	ha->subsys = kmalloc(sizeof (IPS_SUBSYS), GFP_KERNEL);
 
 	if (!ha->subsys) {
 		printk(KERN_WARNING
@@ -7342,18 +7323,18 @@
 		return ips_abort_init(ha, index);
 	}
 
-	for (count = PAGE_SIZE, ha->ioctl_order = 0;
-	     count < ips_ioctlsize; ha->ioctl_order++, count <<= 1) ;
-
-	ha->ioctl_data =
-	    (char *) __get_free_pages(IPS_INIT_GFP, ha->ioctl_order);
-	ha->ioctl_datasize = count;
+	/* the ioctl buffer is now used during adapter initialization, so its
+	 * successful allocation is now required */
+	if (ips_ioctlsize < PAGE_SIZE)
+		ips_ioctlsize = PAGE_SIZE;
+	
+	ha->ioctl_data = pci_alloc_consistent(pci_dev, ips_ioctlsize,
+					      &ha->ioctl_busaddr);
+	ha->ioctl_len = ips_ioctlsize;
 
 	if (!ha->ioctl_data) {
 		printk(KERN_WARNING "Unable to allocate IOCTL data\n");
-		ha->ioctl_data = NULL;
-		ha->ioctl_order = 0;
-		ha->ioctl_datasize = 0;
+		return ips_abort_init(ha, index);
 	}
 
 	/*
diff -Nuar o/drivers/scsi/ips.h n/drivers/scsi/ips.h
--- o/drivers/scsi/ips.h	2004-01-07 20:12:06.000000000 +0100
+++ n/drivers/scsi/ips.h	2003-11-21 17:06:02.000000000 +0100
@@ -111,22 +111,13 @@
       #define min(x,y) ((x) < (y) ? x : y)
    #endif
 
+   #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
 
    #if (BITS_PER_LONG > 32) || (defined CONFIG_HIGHMEM64G && defined IPS_HIGHIO)
       #define IPS_ENABLE_DMA64        (1)
-      #define pci_dma_hi32(a)         (a >> 32)
    #else
       #define IPS_ENABLE_DMA64        (0)
-      #define pci_dma_hi32(a)         (0)
-   #endif
-
-   #if defined(__ia64__)
-      #define IPS_ATOMIC_GFP	(GFP_DMA | GFP_ATOMIC)
-      #define IPS_INIT_GFP	GFP_DMA
-   #else
-      #define IPS_ATOMIC_GFP    GFP_ATOMIC
-      #define IPS_INIT_GFP	GFP_KERNEL
    #endif
 
    /*
@@ -734,7 +725,6 @@
    volatile PIPS_STATUS p_status_tail;
    volatile uint32_t    hw_status_start;
    volatile uint32_t    hw_status_tail;
-   IPS_LD_INFO          logical_drive_info;
 } IPS_ADAPTER, *PIPS_ADAPTER;
 
 typedef struct {
@@ -1092,6 +1082,8 @@
    ips_scb_queue_t    scb_activelist;     /* Active SCB list            */
    IPS_IO_CMD        *dummy;              /* dummy command              */
    IPS_ADAPTER       *adapt;              /* Adapter status area        */
+   IPS_LD_INFO       *logical_drive_info; /* Logical Drive Info         */
+   dma_addr_t         logical_drive_info_dma_addr; /* Logical Drive Info DMA Address */
    IPS_ENQ           *enq;                /* Adapter Enquiry data       */
    IPS_CONF          *conf;               /* Adapter config data        */
    IPS_NVRAM_P5      *nvram;              /* NVRAM page 5 data          */
@@ -1109,7 +1101,8 @@
    uint16_t           device_id;          /* PCI device ID              */
    uint8_t            slot_num;           /* PCI Slot Number            */
    uint16_t           subdevice_id;       /* Subsystem device ID        */
-   uint8_t            ioctl_order;        /* Number of pages in ioctl   */
+   int                ioctl_len;          /* size of ioctl buffer       */
+   dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
    uint8_t            bios_version[8];    /* BIOS Revision              */
    uint32_t           mem_addr;           /* Memory mapped address      */
    uint32_t           io_len;             /* Size of IO Address         */
@@ -1119,8 +1112,10 @@
    ips_hw_func_t      func;               /* hw function pointers       */
    struct pci_dev    *pcidev;             /* PCI device handle          */
    char              *flash_data;         /* Save Area for flash data   */
-   u8                 flash_order;        /* Save Area for flash size order */
+   int                flash_len;          /* length of flash buffer     */
    u32                flash_datasize;     /* Save Area for flash data size */
+   dma_addr_t         flash_busaddr;      /* dma address of flash buffer*/
+   dma_addr_t         enq_busaddr;        /* dma address of enq struct  */
    uint8_t            requires_esl;       /* Requires an EraseStripeLock */
 } ips_ha_t;
 
@@ -1136,8 +1131,8 @@
    uint8_t           bus;
    uint8_t           lun;
    uint8_t           cdb[12];
-   uint32_t          scb_busaddr;
-   uint32_t          data_busaddr;
+   uint32_t          scb_busaddr;      
+   uint32_t          old_data_busaddr;         // Obsolete field left in to not break utilities
    uint32_t          timeout;
    uint8_t           basic_status;
    uint8_t           extended_status;
@@ -1153,6 +1148,7 @@
    ips_scb_callback  callback;
    uint32_t          sg_busaddr;
    int               sg_count;
+   dma_addr_t        data_busaddr;
 } ips_scb_t;
 
 typedef struct ips_scb_pt {
@@ -1208,13 +1204,13 @@
 
 #define IPS_VER_MAJOR 6
 #define IPS_VER_MAJOR_STRING "6"
-#define IPS_VER_MINOR 10
-#define IPS_VER_MINOR_STRING "10"
-#define IPS_VER_BUILD 24
-#define IPS_VER_BUILD_STRING "24"
-#define IPS_VER_STRING "6.10.24"
-#define IPS_RELEASE_ID 0x00010000
-#define IPS_BUILD_IDENT 1250
+#define IPS_VER_MINOR 11
+#define IPS_VER_MINOR_STRING "11"
+#define IPS_VER_BUILD 07
+#define IPS_VER_BUILD_STRING "07"
+#define IPS_VER_STRING "6.11.07"
+#define IPS_RELEASE_ID 0x00010001
+#define IPS_BUILD_IDENT 2224
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003. All Rights Reserved."
 #define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002 to present. All Rights Reserved."
 #define IPS_NT_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003."
@@ -1224,11 +1220,11 @@
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
 #define IPS_VER_SERVERAID3 "6.10.24"
-#define IPS_VER_SERVERAID4H "6.10.24"
-#define IPS_VER_SERVERAID4MLx "6.10.24"
-#define IPS_VER_SARASOTA "6.10.24"
-#define IPS_VER_MARCO "6.10.24"
-#define IPS_VER_SEBRING "6.10.24"
+#define IPS_VER_SERVERAID4H "6.11.07"
+#define IPS_VER_SERVERAID4MLx "6.11.07"
+#define IPS_VER_SARASOTA "6.11.07"
+#define IPS_VER_MARCO "6.11.07"
+#define IPS_VER_SEBRING "6.11.07"
 
 /* Compatability IDs for various adapters */
 #define IPS_COMPAT_UNKNOWN ""

--------------080402020808090605020907--


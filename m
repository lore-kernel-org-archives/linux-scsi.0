From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: endian cleanup (update)
Date: Wed, 30 Mar 2005 11:00:55 -0800
Message-ID: <1112209255.26014.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:5546 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262398AbVC3TBS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 14:01:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

An update to the patch from Adaptec with byte order changes:
 - drop byte swapping on all 0's and all 1's content
 - fix up missing swapping directives
 - ensure swapping on 16 bit values does not use 32 bit swap
 - Made hardware registers __le* types.
 - hopefully caught the style issues.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aachba.c 1.34 vs edited =====
--- 1.34/drivers/scsi/aacraid/aachba.c	2005-02-02 00:12:13 -08:00
+++ edited/drivers/scsi/aacraid/aachba.c	2005-03-30 09:40:26 -08:00
@@ -195,10 +195,12 @@
 		  = (struct aac_get_config_status_resp *) fib_data(fibptr);
 		dprintk((KERN_WARNING
 		  "aac_get_config_status: response=%d status=%d action=%d\n",
-		  reply->response, reply->status, reply->data.action));
-		if ((reply->response != ST_OK)
-		 || (reply->status != CT_OK)
-		 || (reply->data.action > CFACT_PAUSE)) {
+		  le32_to_cpu(reply->response),
+		  le32_to_cpu(reply->status),
+		  le32_to_cpu(reply->data.action)));
+		if ((le32_to_cpu(reply->response) != ST_OK) ||
+		     (le32_to_cpu(reply->status) != CT_OK) ||
+		     (le32_to_cpu(reply->data.action) > CFACT_PAUSE)) {
 			printk(KERN_WARNING "aac_get_config_status: Will not issue the Commit Configuration\n");
 			status = -EINVAL;
 		}
@@ -265,7 +267,7 @@
 		    NULL, NULL);
 	if (status >= 0) {
 		dresp = (struct aac_get_container_count_resp *)fib_data(fibptr);
-		maximum_num_containers = dresp->ContainerSwitchEntries;
+		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
 		fib_complete(fibptr);
 	}
 
@@ -624,25 +626,28 @@
 
 	memcpy(&dev->adapter_info, info, sizeof(struct aac_adapter_info));
 
-	tmp = dev->adapter_info.kernelrev;
-	printk(KERN_INFO"%s%d: kernel %d.%d.%d build %d\n", 
+	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
+	printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d]\n", 
+			dev->name, 
+			dev->id,
+			tmp>>24,
+			(tmp>>16)&0xff,
+			tmp&0xff,
+			le32_to_cpu(dev->adapter_info.kernelbuild));
+	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
+	printk(KERN_INFO "%s%d: monitor %d.%d-%d[%d]\n", 
 			dev->name, dev->id,
-			tmp>>24,(tmp>>16)&0xff,(tmp>>8)&0xff,
-			dev->adapter_info.kernelbuild);
-	tmp = dev->adapter_info.monitorrev;
-	printk(KERN_INFO"%s%d: monitor %d.%d.%d build %d\n", 
+			tmp>>24,(tmp>>16)&0xff,tmp&0xff,
+			le32_to_cpu(dev->adapter_info.monitorbuild));
+	tmp = le32_to_cpu(dev->adapter_info.biosrev);
+	printk(KERN_INFO "%s%d: bios %d.%d-%d[%d]\n", 
 			dev->name, dev->id,
-			tmp>>24,(tmp>>16)&0xff,(tmp>>8)&0xff,
-			dev->adapter_info.monitorbuild);
-	tmp = dev->adapter_info.biosrev;
-	printk(KERN_INFO"%s%d: bios %d.%d.%d build %d\n", 
+			tmp>>24,(tmp>>16)&0xff,tmp&0xff,
+			le32_to_cpu(dev->adapter_info.biosbuild));
+	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
+		printk(KERN_INFO "%s%d: serial %x\n",
 			dev->name, dev->id,
-			tmp>>24,(tmp>>16)&0xff,(tmp>>8)&0xff,
-			dev->adapter_info.biosbuild);
-	printk(KERN_INFO"%s%d: serial %x%x\n",
-			dev->name, dev->id,
-			dev->adapter_info.serial[0],
-			dev->adapter_info.serial[1]);
+			le32_to_cpu(dev->adapter_info.serial[0]));
 
 	dev->nondasd_support = 0;
 	dev->raid_scsi_mode = 0;
@@ -742,7 +747,8 @@
 	if (le32_to_cpu(readreply->status) == ST_OK)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
-		printk(KERN_WARNING "read_callback: read failed, status = %d\n", readreply->status);
+		printk(KERN_WARNING "read_callback: read failed, status = %d\n",
+				le32_to_cpu(readreply->status));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				    HARDWARE_ERROR,
@@ -853,13 +859,15 @@
 		readcmd->cid = cpu_to_le16(cid);
 		readcmd->sector_count = cpu_to_le16(count);
 		readcmd->block = cpu_to_le32(lba);
-		readcmd->pad   = cpu_to_le16(0);
-		readcmd->flags = cpu_to_le16(0); 
+		readcmd->pad   = 0;
+		readcmd->flags = 0; 
 
 		aac_build_sg64(scsicmd, &readcmd->sg);
-		if(readcmd->sg.count > MAX_DRIVER_SG_SEGMENT_COUNT)
-			BUG();
-		fibsize = sizeof(struct aac_read64) + ((readcmd->sg.count - 1) * sizeof (struct sgentry64));
+		fibsize = sizeof(struct aac_read64) + 
+			((le32_to_cpu(readcmd->sg.count) - 1) * 
+			 sizeof (struct sgentry64));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
 		 */
@@ -882,9 +890,11 @@
 			BUG();
 
 		aac_build_sg(scsicmd, &readcmd->sg);
-		if(readcmd->sg.count > MAX_DRIVER_SG_SEGMENT_COUNT)
-			BUG();
-		fibsize = sizeof(struct aac_read) + ((readcmd->sg.count - 1) * sizeof (struct sgentry));
+		fibsize = sizeof(struct aac_read) + 
+			((le32_to_cpu(readcmd->sg.count) - 1) * 
+			 sizeof (struct sgentry));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
 		 */
@@ -903,10 +913,7 @@
 	 *	Check that the command queued to the controller
 	 */
 	if (status == -EINPROGRESS) 
-	{
-		dprintk("read queued.\n");
 		return 0;
-	}
 		
 	printk(KERN_WARNING "aac_read: fib_send failed with status: %d.\n", status);
 	/*
@@ -943,7 +950,8 @@
 		lba = (scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
 	}
-	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
+	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %u, t = %ld.\n",
+	  smp_processor_id(), (unsigned long long)lba, jiffies));
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
@@ -961,13 +969,15 @@
 		writecmd->cid = cpu_to_le16(cid);
 		writecmd->sector_count = cpu_to_le16(count); 
 		writecmd->block = cpu_to_le32(lba);
-		writecmd->pad	= cpu_to_le16(0);
-		writecmd->flags	= cpu_to_le16(0);
+		writecmd->pad	= 0;
+		writecmd->flags	= 0;
 
 		aac_build_sg64(scsicmd, &writecmd->sg);
-		if(writecmd->sg.count > MAX_DRIVER_SG_SEGMENT_COUNT)
-			BUG();
-		fibsize = sizeof(struct aac_write64) + ((writecmd->sg.count - 1) * sizeof (struct sgentry64));
+		fibsize = sizeof(struct aac_write64) + 
+			((le32_to_cpu(writecmd->sg.count) - 1) * 
+			 sizeof (struct sgentry64));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
 		 */
@@ -993,9 +1003,11 @@
 		}
 
 		aac_build_sg(scsicmd, &writecmd->sg);
-		if(writecmd->sg.count > MAX_DRIVER_SG_SEGMENT_COUNT)
-			BUG();
-		fibsize = sizeof(struct aac_write) + ((writecmd->sg.count - 1) * sizeof (struct sgentry));
+		fibsize = sizeof(struct aac_write) + 
+			((le32_to_cpu(writecmd->sg.count) - 1) * 
+			 sizeof (struct sgentry));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
 		 */
@@ -1051,7 +1063,7 @@
 		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status = %d\n",
-		     synchronizereply->status);
+		     le32_to_cpu(synchronizereply->status));
 		cmd->result = DID_OK << 16 | 
 			COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *)&dev->fsa_dev[cid].sense_data,
@@ -1538,7 +1550,8 @@
 	 *	Calculate resid for sg 
 	 */
 	 
-	scsicmd->resid = scsicmd->request_bufflen - srbreply->data_xfer_length;
+	scsicmd->resid = scsicmd->request_bufflen - 
+		le32_to_cpu(srbreply->data_xfer_length);
 
 	if(scsicmd->use_sg)
 		pci_unmap_sg(dev->pdev, 
@@ -1556,8 +1569,10 @@
 	if (le32_to_cpu(srbreply->status) != ST_OK){
 		int len;
 		printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
-		len = (srbreply->sense_data_size > sizeof(scsicmd->sense_buffer))?
-				sizeof(scsicmd->sense_buffer):srbreply->sense_data_size;
+		len = (le32_to_cpu(srbreply->sense_data_size) > 
+				sizeof(scsicmd->sense_buffer)) ?
+				sizeof(scsicmd->sense_buffer) : 
+				le32_to_cpu(srbreply->sense_data_size);
 		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
 	}
@@ -1693,7 +1708,7 @@
 	default:
 #ifdef AAC_DETAILED_STATUS_INFO
 		printk("aacraid: SRB ERROR(%u) %s scsi cmd 0x%x - scsi status 0x%x\n",
-			le32_to_cpu(srbreply->srb_status & 0x3F),
+			le32_to_cpu(srbreply->srb_status) & 0x3F,
 			aac_get_status_string(
 				le32_to_cpu(srbreply->srb_status) & 0x3F), 
 			scsicmd->cmnd[0], 
@@ -1705,8 +1720,10 @@
 	if (le32_to_cpu(srbreply->scsi_status) == 0x02 ){  // Check Condition
 		int len;
 		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
-		len = (srbreply->sense_data_size > sizeof(scsicmd->sense_buffer))?
-				sizeof(scsicmd->sense_buffer):srbreply->sense_data_size;
+		len = (le32_to_cpu(srbreply->sense_data_size) > 
+				sizeof(scsicmd->sense_buffer)) ?
+				sizeof(scsicmd->sense_buffer) :
+				le32_to_cpu(srbreply->sense_data_size);
 #ifdef AAC_DETAILED_STATUS_INFO
 		dprintk((KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n", 
 					le32_to_cpu(srbreply->status), len));
@@ -1786,7 +1803,7 @@
 		timeout = 1;
 	}
 	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
-	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
+	srbcmd->retry_limit = 0; /* Obsolete parameter */
 	srbcmd->cdb_size = cpu_to_le32(scsicmd->cmd_len);
 	
 	if( dev->dac_support == 1 ) {
@@ -1798,13 +1815,19 @@
 		/*
 		 *	Build Scatter/Gather list
 		 */
-		fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry64));
+		fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) +
+			((le32_to_cpu(srbcmd->sg.count) & 0xff) * 
+			 sizeof (struct sgentry64));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ScsiPortCommand64, cmd_fibcontext, fibsize, FsaNormal, 0, 1,
-				  (fib_callback) aac_srb_callback, (void *) scsicmd);
+		status = fib_send(ScsiPortCommand64, cmd_fibcontext, 
+				fibsize, FsaNormal, 0, 1,
+				  (fib_callback) aac_srb_callback, 
+				  (void *) scsicmd);
 	} else {
 		aac_build_sg(scsicmd, (struct sgmap*)&srbcmd->sg);
 		srbcmd->count = cpu_to_le32(scsicmd->request_bufflen);
@@ -1814,7 +1837,11 @@
 		/*
 		 *	Build Scatter/Gather list
 		 */
-		fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
+		fibsize = sizeof (struct aac_srb) + 
+			(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * 
+			 sizeof (struct sgentry));
+		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+					sizeof(struct aac_fibhdr)));
 
 		/*
 		 *	Now send the Fib to the adapter
@@ -1843,9 +1870,9 @@
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
-	psg->count = cpu_to_le32(0);
-	psg->sg[0].addr = cpu_to_le32(0);
-	psg->sg[0].count = cpu_to_le32(0);  
+	psg->count = 0;
+	psg->sg[0].addr = 0;
+	psg->sg[0].count = 0;  
 	if (scsicmd->use_sg) {
 		struct scatterlist *sg;
 		int i;
@@ -1899,10 +1926,10 @@
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
-	psg->count = cpu_to_le32(0);
-	psg->sg[0].addr[0] = cpu_to_le32(0);
-	psg->sg[0].addr[1] = cpu_to_le32(0);
-	psg->sg[0].count = cpu_to_le32(0);  
+	psg->count = 0;
+	psg->sg[0].addr[0] = 0;
+	psg->sg[0].addr[1] = 0;
+	psg->sg[0].count = 0;
 	if (scsicmd->use_sg) {
 		struct scatterlist *sg;
 		int i;
===== drivers/scsi/aacraid/aacraid.h 1.29 vs edited =====
--- 1.29/drivers/scsi/aacraid/aacraid.h	2005-01-19 10:48:23 -08:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2005-03-29 09:31:47 -08:00
@@ -507,40 +507,32 @@
  */
  
 struct sa_drawbridge_CSR {
-						//	 Offset |	Name
-	u32	reserved[10];			//	00h-27h |   Reserved
-	u8	LUT_Offset;			//	28h	|	Looup Table Offset
-	u8	reserved1[3];			// 	29h-2bh	|	Reserved
-	u32	LUT_Data;			//	2ch	|	Looup Table Data	
-	u32	reserved2[26];			//	30h-97h	|	Reserved
-	u16	PRICLEARIRQ;			//	98h	|	Primary Clear Irq
-	u16	SECCLEARIRQ;			//	9ah	|	Secondary Clear Irq
-	u16	PRISETIRQ;			//	9ch	|	Primary Set Irq
-	u16	SECSETIRQ;			//	9eh	|	Secondary Set Irq
-	u16	PRICLEARIRQMASK;		//	a0h	|	Primary Clear Irq Mask
-	u16	SECCLEARIRQMASK;		//	a2h	|	Secondary Clear Irq Mask
-	u16	PRISETIRQMASK;			//	a4h	|	Primary Set Irq Mask
-	u16	SECSETIRQMASK;			//	a6h	|	Secondary Set Irq Mask
-	u32	MAILBOX0;			//	a8h	|	Scratchpad 0
-	u32	MAILBOX1;			//	ach	|	Scratchpad 1
-	u32	MAILBOX2;			//	b0h	|	Scratchpad 2
-	u32	MAILBOX3;			//	b4h	|	Scratchpad 3
-	u32	MAILBOX4;			//	b8h	|	Scratchpad 4
-	u32	MAILBOX5;			//	bch	|	Scratchpad 5
-	u32	MAILBOX6;			//	c0h	|	Scratchpad 6
-	u32	MAILBOX7;			//	c4h	|	Scratchpad 7
-
-	u32	ROM_Setup_Data;			//	c8h | 	Rom Setup and Data
-	u32	ROM_Control_Addr;		//	cch | 	Rom Control and Address
-
-	u32	reserved3[12];			//	d0h-ffh	| 	reserved
-	u32	LUT[64];			// 100h-1ffh|	Lookup Table Entries
-
-	//
-	//  TO DO
-	//	need to add DMA, I2O, UART, etc registers form 80h to 364h
-	//
-
+				/*	Offset 	|  Name */
+	__le32	reserved[10];	/*	00h-27h |  Reserved */
+	u8	LUT_Offset;	/*	28h	|  Lookup Table Offset */
+	u8	reserved1[3];	/* 	29h-2bh	|  Reserved */
+	__le32	LUT_Data;	/*	2ch	|  Looup Table Data */
+	__le32	reserved2[26];	/*	30h-97h	|  Reserved */
+	__le16	PRICLEARIRQ;	/*	98h	|  Primary Clear Irq */
+	__le16	SECCLEARIRQ;	/*	9ah	|  Secondary Clear Irq */
+	__le16	PRISETIRQ;	/*	9ch	|  Primary Set Irq */
+	__le16	SECSETIRQ;	/*	9eh	|  Secondary Set Irq */
+	__le16	PRICLEARIRQMASK;/*	a0h	|  Primary Clear Irq Mask */
+	__le16	SECCLEARIRQMASK;/*	a2h	|  Secondary Clear Irq Mask */
+	__le16	PRISETIRQMASK;	/*	a4h	|  Primary Set Irq Mask */
+	__le16	SECSETIRQMASK;	/*	a6h	|  Secondary Set Irq Mask */
+	__le32	MAILBOX0;	/*	a8h	|  Scratchpad 0 */
+	__le32	MAILBOX1;	/*	ach	|  Scratchpad 1 */
+	__le32	MAILBOX2;	/*	b0h	|  Scratchpad 2 */
+	__le32	MAILBOX3;	/*	b4h	|  Scratchpad 3 */
+	__le32	MAILBOX4;	/*	b8h	|  Scratchpad 4 */
+	__le32	MAILBOX5;	/*	bch	|  Scratchpad 5 */
+	__le32	MAILBOX6;	/*	c0h	|  Scratchpad 6 */
+	__le32	MAILBOX7;	/*	c4h	|  Scratchpad 7 */
+	__le32	ROM_Setup_Data;	/*	c8h 	|  Rom Setup and Data */
+	__le32	ROM_Control_Addr;/*	cch 	|  Rom Control and Address */
+	__le32	reserved3[12];	/*	d0h-ffh	|  reserved */
+	__le32	LUT[64];	/*    100h-1ffh	|  Lookup Table Entries */
 };
 
 #define Mailbox0	SaDbCSR.MAILBOX0
@@ -556,13 +548,13 @@
 #define DoorbellClrReg_p SaDbCSR.PRICLEARIRQ
 
 
-#define	DOORBELL_0	cpu_to_le16(0x0001)
-#define DOORBELL_1	cpu_to_le16(0x0002)
-#define DOORBELL_2	cpu_to_le16(0x0004)
-#define DOORBELL_3	cpu_to_le16(0x0008)
-#define DOORBELL_4	cpu_to_le16(0x0010)
-#define DOORBELL_5	cpu_to_le16(0x0020)
-#define DOORBELL_6	cpu_to_le16(0x0040)
+#define	DOORBELL_0	0x0001
+#define DOORBELL_1	0x0002
+#define DOORBELL_2	0x0004
+#define DOORBELL_3	0x0008
+#define DOORBELL_4	0x0010
+#define DOORBELL_5	0x0020
+#define DOORBELL_6	0x0040
 
 	
 #define PrintfReady	DOORBELL_5
@@ -585,25 +577,29 @@
  */
 
 struct rx_mu_registers {
-						//	 Local	|   PCI*	|	Name
-						//			|		|
-	u32	ARSR;				//	1300h	|	00h	|	APIC Register Select Register
-	u32	reserved0;			//	1304h	|	04h	|	Reserved
-	u32	AWR;				//	1308h	|	08h	|	APIC Window Register
-	u32	reserved1;			//	130Ch	|	0Ch	|	Reserved
-	u32	IMRx[2];			//	1310h	|	10h	|	Inbound Message Registers
-	u32	OMRx[2];			//	1318h	|	18h	|	Outbound Message Registers
-	u32	IDR;				//	1320h	|	20h	|	Inbound Doorbell Register
-	u32	IISR;				//	1324h	|	24h	|	Inbound Interrupt Status Register
-	u32	IIMR;				//	1328h	|	28h	|	Inbound Interrupt Mask Register
-	u32	ODR;				//	132Ch	|	2Ch	|	Outbound Doorbell Register
-	u32	OISR;				//	1330h	|	30h	|	Outbound Interrupt Status Register
-	u32	OIMR;				//	1334h	|	34h	|	Outbound Interrupt Mask Register
-						// * Must access through ATU Inbound Translation Window
+			    /*	Local  | PCI*| Name */
+	__le32	ARSR;	    /*	1300h  | 00h | APIC Register Select Register */
+	__le32	reserved0;  /*	1304h  | 04h | Reserved */
+	__le32	AWR;	    /*	1308h  | 08h | APIC Window Register */
+	__le32	reserved1;  /*	130Ch  | 0Ch | Reserved */
+	__le32	IMRx[2];    /*	1310h  | 10h | Inbound Message Registers */
+	__le32	OMRx[2];    /*	1318h  | 18h | Outbound Message Registers */
+	__le32	IDR;	    /*	1320h  | 20h | Inbound Doorbell Register */
+	__le32	IISR;	    /*	1324h  | 24h | Inbound Interrupt 
+						Status Register */
+	__le32	IIMR;	    /*	1328h  | 28h | Inbound Interrupt 
+					 	Mask Register */
+	__le32	ODR;	    /*	132Ch  | 2Ch | Outbound Doorbell Register */
+	__le32	OISR;	    /*	1330h  | 30h | Outbound Interrupt 
+						Status Register */
+	__le32	OIMR;	    /*	1334h  | 34h | Outbound Interrupt 
+						Mask Register */
+			    /* * Must access through ATU Inbound 
+			     	 Translation Window */
 };
 
 struct rx_inbound {
-	u32	Mailbox[8];
+	__le32	Mailbox[8];
 };
 
 #define	InboundMailbox0		IndexRegs.Mailbox[0]
@@ -613,28 +609,27 @@
 #define	InboundMailbox4		IndexRegs.Mailbox[4]
 #define	InboundMailbox5		IndexRegs.Mailbox[5]
 #define	InboundMailbox6		IndexRegs.Mailbox[6]
-#define	InboundMailbox7		IndexRegs.Mailbox[7]
 
-#define	INBOUNDDOORBELL_0	cpu_to_le32(0x00000001)
-#define INBOUNDDOORBELL_1	cpu_to_le32(0x00000002)
-#define INBOUNDDOORBELL_2	cpu_to_le32(0x00000004)
-#define INBOUNDDOORBELL_3	cpu_to_le32(0x00000008)
-#define INBOUNDDOORBELL_4	cpu_to_le32(0x00000010)
-#define INBOUNDDOORBELL_5	cpu_to_le32(0x00000020)
-#define INBOUNDDOORBELL_6	cpu_to_le32(0x00000040)
-
-#define	OUTBOUNDDOORBELL_0	cpu_to_le32(0x00000001)
-#define OUTBOUNDDOORBELL_1	cpu_to_le32(0x00000002)
-#define OUTBOUNDDOORBELL_2	cpu_to_le32(0x00000004)
-#define OUTBOUNDDOORBELL_3	cpu_to_le32(0x00000008)
-#define OUTBOUNDDOORBELL_4	cpu_to_le32(0x00000010)
+#define	INBOUNDDOORBELL_0	0x00000001
+#define INBOUNDDOORBELL_1	0x00000002
+#define INBOUNDDOORBELL_2	0x00000004
+#define INBOUNDDOORBELL_3	0x00000008
+#define INBOUNDDOORBELL_4	0x00000010
+#define INBOUNDDOORBELL_5	0x00000020
+#define INBOUNDDOORBELL_6	0x00000040
+
+#define	OUTBOUNDDOORBELL_0	0x00000001
+#define OUTBOUNDDOORBELL_1	0x00000002
+#define OUTBOUNDDOORBELL_2	0x00000004
+#define OUTBOUNDDOORBELL_3	0x00000008
+#define OUTBOUNDDOORBELL_4	0x00000010
 
 #define InboundDoorbellReg	MUnit.IDR
 #define OutboundDoorbellReg	MUnit.ODR
 
 struct rx_registers {
-	struct rx_mu_registers		MUnit;		// 1300h - 1334h
-	u32				reserved1[6];	// 1338h - 134ch
+	struct rx_mu_registers		MUnit;		/* 1300h - 1334h */
+	__le32				reserved1[6];	/* 1338h - 134ch */
 	struct rx_inbound		IndexRegs;
 };
 
@@ -652,7 +647,7 @@
 
 struct rkt_registers {
 	struct rkt_mu_registers		MUnit;		 /* 1300h - 1334h */
-	u32				reserved1[1010]; /* 1338h - 22fch */
+	__le32				reserved1[1010]; /* 1338h - 22fch */
 	struct rkt_inbound		IndexRegs;	 /* 2300h - */
 };
 
@@ -824,6 +819,9 @@
 #define AAC_OPT_NONDASD			cpu_to_le32(1<<12)
 #define AAC_OPT_SCSI_MANAGED    	cpu_to_le32(1<<13)
 #define AAC_OPT_RAID_SCSI_MODE		cpu_to_le32(1<<14)
+#define AAC_OPT_SUPPLEMENT_ADAPTER_INFO	cpu_to_le32(1<<16)
+#define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
+#define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
 
 struct aac_dev
 {
@@ -1482,15 +1480,19 @@
  *	Monitor/Kernel API
  */
 
-#define	BREAKPOINT_REQUEST		cpu_to_le32(0x00000004)
-#define	INIT_STRUCT_BASE_ADDRESS	cpu_to_le32(0x00000005)
-#define READ_PERMANENT_PARAMETERS	cpu_to_le32(0x0000000a)
-#define WRITE_PERMANENT_PARAMETERS	cpu_to_le32(0x0000000b)
-#define HOST_CRASHING			cpu_to_le32(0x0000000d)
-#define	SEND_SYNCHRONOUS_FIB		cpu_to_le32(0x0000000c)
-#define	COMMAND_POST_RESULTS		cpu_to_le32(0x00000014)
-#define GET_ADAPTER_PROPERTIES		cpu_to_le32(0x00000019)
-#define RE_INIT_ADAPTER			cpu_to_le32(0x000000ee)
+#define	BREAKPOINT_REQUEST		0x00000004
+#define	INIT_STRUCT_BASE_ADDRESS	0x00000005
+#define READ_PERMANENT_PARAMETERS	0x0000000a
+#define WRITE_PERMANENT_PARAMETERS	0x0000000b
+#define HOST_CRASHING			0x0000000d
+#define	SEND_SYNCHRONOUS_FIB		0x0000000c
+#define COMMAND_POST_RESULTS		0x00000014
+#define GET_ADAPTER_PROPERTIES		0x00000019
+#define GET_DRIVER_BUFFER_PROPERTIES	0x00000023
+#define RCV_TEMP_READINGS		0x00000025
+#define GET_COMM_PREFERRED_SETTINGS	0x00000026
+#define IOP_RESET			0x00001000
+#define RE_INIT_ADAPTER			0x000000ee
 
 /*
  *	Adapter Status Register
@@ -1513,22 +1515,22 @@
  *	Phases are bit oriented.  It is NOT valid  to have multiple bits set						
  */					
 
-#define	SELF_TEST_FAILED		(cpu_to_le32(0x00000004))
-#define MONITOR_PANIC			(cpu_to_le32(0x00000020))
-#define	KERNEL_UP_AND_RUNNING		(cpu_to_le32(0x00000080))
-#define	KERNEL_PANIC			(cpu_to_le32(0x00000100))
+#define	SELF_TEST_FAILED		0x00000004
+#define	MONITOR_PANIC			0x00000020
+#define	KERNEL_UP_AND_RUNNING		0x00000080
+#define	KERNEL_PANIC			0x00000100
 
 /*
  *	Doorbell bit defines
  */
 
-#define DoorBellSyncCmdAvailable	cpu_to_le32(1<<0)	// Host -> Adapter
-#define DoorBellPrintfDone		cpu_to_le32(1<<5)	// Host -> Adapter
-#define DoorBellAdapterNormCmdReady	cpu_to_le32(1<<1)	// Adapter -> Host
-#define DoorBellAdapterNormRespReady	cpu_to_le32(1<<2)	// Adapter -> Host
-#define DoorBellAdapterNormCmdNotFull	cpu_to_le32(1<<3)	// Adapter -> Host
-#define DoorBellAdapterNormRespNotFull	cpu_to_le32(1<<4)	// Adapter -> Host
-#define DoorBellPrintfReady		cpu_to_le32(1<<5)	// Adapter -> Host
+#define DoorBellSyncCmdAvailable	(1<<0)	/* Host -> Adapter */
+#define DoorBellPrintfDone		(1<<5)	/* Host -> Adapter */
+#define DoorBellAdapterNormCmdReady	(1<<1)	/* Adapter -> Host */
+#define DoorBellAdapterNormRespReady	(1<<2)	/* Adapter -> Host */
+#define DoorBellAdapterNormCmdNotFull	(1<<3)	/* Adapter -> Host */
+#define DoorBellAdapterNormRespNotFull	(1<<4)	/* Adapter -> Host */
+#define DoorBellPrintfReady		(1<<5)	/* Adapter -> Host */
 
 /*
  *	For FIB communication, we need all of the following things
@@ -1599,7 +1601,6 @@
 void aac_printf(struct aac_dev *dev, u32 val);
 int fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
 int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry);
-int aac_consumer_avail(struct aac_dev * dev, struct aac_queue * q);
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
 int fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
===== drivers/scsi/aacraid/commctrl.c 1.9 vs edited =====
--- 1.9/drivers/scsi/aacraid/commctrl.c	2004-08-09 15:07:39 -07:00
+++ edited/drivers/scsi/aacraid/commctrl.c	2005-03-30 09:43:23 -08:00
@@ -74,12 +74,14 @@
 	 *	will not overrun the buffer when we copy the memory. Return
 	 *	an error if we would.
 	 */
-	if(le32_to_cpu(kfib->header.Size) > sizeof(struct hw_fib) - sizeof(struct aac_fibhdr)) {
+	if (le16_to_cpu(kfib->header.Size) > 
+			sizeof(struct hw_fib) - sizeof(struct aac_fibhdr)) {
 		fib_free(fibptr);
 		return -EINVAL;
 	}
 
-	if (copy_from_user((void *) kfib, arg, le32_to_cpu(kfib->header.Size) + sizeof(struct aac_fibhdr))) {
+	if (copy_from_user(kfib, arg, le16_to_cpu(kfib->header.Size) +
+				sizeof(struct aac_fibhdr))) {
 		fib_free(fibptr);
 		return -EFAULT;
 	}
@@ -93,7 +95,7 @@
 		kfib->header.XferState = 0;
 	} else {
 		int retval = fib_send(kfib->header.Command, fibptr,
-				le32_to_cpu(kfib->header.Size) , FsaNormal,
+				le16_to_cpu(kfib->header.Size) , FsaNormal,
 				1, 1, NULL, NULL);
 		if (retval) {
 			fib_free(fibptr);
@@ -538,7 +540,9 @@
 		struct sgmap* psg = &srbcmd->sg;
 		byte_count = 0;
 
-		actual_fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
+		actual_fibsize = sizeof (struct aac_srb) + 
+			(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * 
+			 sizeof (struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
 			rcode = -EINVAL;
===== drivers/scsi/aacraid/comminit.c 1.10 vs edited =====
--- 1.10/drivers/scsi/aacraid/comminit.c	2004-05-11 12:20:37 -07:00
+++ edited/drivers/scsi/aacraid/comminit.c	2005-03-03 13:01:32 -08:00
@@ -83,7 +83,7 @@
 	 */
 	dev->aif_base_va = (struct hw_fib *)base;
 	
-	init->AdapterFibsVirtualAddress = cpu_to_le32(0);
+	init->AdapterFibsVirtualAddress = 0;
 	init->AdapterFibsPhysicalAddress = cpu_to_le32((u32)phys);
 	init->AdapterFibsSize = cpu_to_le32(fibsize);
 	init->AdapterFibAlign = cpu_to_le32(sizeof(struct hw_fib));
===== drivers/scsi/aacraid/commsup.c 1.10 vs edited =====
--- 1.10/drivers/scsi/aacraid/commsup.c	2005-01-02 16:00:00 -08:00
+++ edited/drivers/scsi/aacraid/commsup.c	2005-03-30 09:45:07 -08:00
@@ -102,7 +102,7 @@
 		fibptr->next = fibptr+1;	/* Forward chain the fibs */
 		init_MUTEX_LOCKED(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
-		hw_fib_va->header.XferState = cpu_to_le32(0xffffffff);
+		hw_fib_va->header.XferState = 0xffffffff;
 		hw_fib_va->header.SenderSize = cpu_to_le16(sizeof(struct hw_fib));
 		fibptr->hw_fib_pa = hw_fib_pa;
 		hw_fib_va = (struct hw_fib *)((unsigned char *)hw_fib_va + sizeof(struct hw_fib));
@@ -148,7 +148,7 @@
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
 	 */
-	fibptr->hw_fib->header.XferState = cpu_to_le32(0);
+	fibptr->hw_fib->header.XferState = 0;
 	fibptr->callback = NULL;
 	fibptr->callback_data = NULL;
 
@@ -175,7 +175,8 @@
 	} else {
 		if (fibptr->hw_fib->header.XferState != 0) {
 			printk(KERN_WARNING "fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n", 
-				 (void*)fibptr, fibptr->hw_fib->header.XferState);
+				 (void*)fibptr, 
+				 le32_to_cpu(fibptr->hw_fib->header.XferState));
 		}
 		fibptr->next = fibptr->dev->free_fib;
 		fibptr->dev->free_fib = fibptr;
@@ -215,7 +216,7 @@
 	struct hw_fib *hw_fib = fibptr->hw_fib;
 	if(hw_fib->header.StructType != FIB_MAGIC) 
 		BUG();
-	hw_fib->header.XferState = cpu_to_le32(0);        
+	hw_fib->header.XferState = 0;        
 }
 
 /*
@@ -344,7 +345,7 @@
 	 *	in the queue entry.
 	 */
 	if (map)
-		entry->addr = fibptr->hw_fib_pa;
+		entry->addr = cpu_to_le32(fibptr->hw_fib_pa);
 	return 0;
 }
 
@@ -418,13 +419,13 @@
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_queue * q;
 	unsigned long flags = 0;
-	if (!(le32_to_cpu(hw_fib->header.XferState) & HostOwned))
+	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
 	/*
 	 *	There are 5 cases with the wait and reponse requested flags. 
 	 *	The only invalid cases are if the caller requests to wait and
 	 *	does not request a response and if the caller does not want a
-	 *	response and the Fibis not allocated from pool. If a response
+	 *	response and the Fib is not allocated from pool. If a response
 	 *	is not requesed the Fib will just be deallocaed by the DPC
 	 *	routine when the response comes back from the adapter. No
 	 *	further processing will be done besides deleting the Fib. We 
@@ -566,12 +567,6 @@
 	return(status);
 }
 
-int aac_consumer_avail(struct aac_dev *dev, struct aac_queue * q)
-{
-	return (le32_to_cpu(*q->headers.producer) != le32_to_cpu(*q->headers.consumer));
-}
-
-
 /**
  *	aac_consumer_free	-	free consumer entry
  *	@dev: Adapter
@@ -632,7 +627,7 @@
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_dev * dev = fibptr->dev;
 	unsigned long nointr = 0;
-	if (le32_to_cpu(hw_fib->header.XferState) == 0)
+	if (hw_fib->header.XferState == 0)
         	return 0;
 	/*
 	 *	If we plan to do anything check the structure type first.
@@ -704,7 +699,7 @@
 	 *	Check for a fib which has already been completed
 	 */
 
-	if (hw_fib->header.XferState == cpu_to_le32(0))
+	if (hw_fib->header.XferState == 0)
         	return 0;
 	/*
 	 *	If we plan to do anything check the structure type first.
===== drivers/scsi/aacraid/rkt.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/rkt.c	2004-11-01 13:09:31 -08:00
+++ edited/drivers/scsi/aacraid/rkt.c	2005-03-30 09:46:46 -08:00
@@ -63,7 +63,7 @@
 	{
 		bellbits = rkt_readl(dev, OutboundDoorbellReg);
 		if (bellbits & DoorBellPrintfReady) {
-			aac_printf(dev, le32_to_cpu(rkt_readl (dev, IndexRegs.Mailbox[5])));
+			aac_printf(dev, rkt_readl(dev, IndexRegs.Mailbox[5]));
 			rkt_writel(dev, MUnit.ODR,DoorBellPrintfReady);
 			rkt_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
 		}
@@ -94,7 +94,7 @@
  *	@p1: first parameter
  *	@ret: adapter status
  *
- *	This routine will send a synchronous comamnd to the adapter and wait 
+ *	This routine will send a synchronous command to the adapter and wait 
  *	for its	completion.
  */
 
@@ -105,11 +105,11 @@
 	/*
 	 *	Write the command into Mailbox 0
 	 */
-	rkt_writel(dev, InboundMailbox0, cpu_to_le32(command));
+	rkt_writel(dev, InboundMailbox0, command);
 	/*
 	 *	Write the parameters into Mailboxes 1 - 4
 	 */
-	rkt_writel(dev, InboundMailbox1, cpu_to_le32(p1));
+	rkt_writel(dev, InboundMailbox1, p1);
 	rkt_writel(dev, InboundMailbox2, 0);
 	rkt_writel(dev, InboundMailbox3, 0);
 	rkt_writel(dev, InboundMailbox4, 0);
@@ -168,7 +168,7 @@
 	 *	Pull the synch status from Mailbox 0.
 	 */
 	if (status)
-		*status = le32_to_cpu(rkt_readl(dev, IndexRegs.Mailbox[0]));
+		*status = rkt_readl(dev, IndexRegs.Mailbox[0]);
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -275,7 +275,7 @@
  */
 static int aac_rkt_check_health(struct aac_dev *dev)
 {
-	u32 status = le32_to_cpu(rkt_readl(dev, MUnit.OMRx[0]));
+	u32 status = rkt_readl(dev, MUnit.OMRx[0]);
 
 	/*
 	 *	Check to see if the board failed any self tests.
@@ -307,9 +307,9 @@
 			return ret;
 		}
                 memset(buffer, 0, 512);
-                post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
+		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
                 post->Post_Address = cpu_to_le32(baddr);
-                rkt_writel(dev, MUnit.IMRx[0], cpu_to_le32(paddr));
+                rkt_writel(dev, MUnit.IMRx[0], paddr);
                 rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
@@ -388,8 +388,9 @@
 	{
 		if(time_after(jiffies, start+180*HZ))
 		{
-			status = rkt_readl(dev, IndexRegs.Mailbox[7]) >> 16;
-			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
+			status = rkt_readl(dev, MUnit.OMRx[0]);
+			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
+					dev->name, instance, status);
 			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
===== drivers/scsi/aacraid/rx.c 1.13 vs edited =====
--- 1.13/drivers/scsi/aacraid/rx.c	2004-11-04 09:37:33 -08:00
+++ edited/drivers/scsi/aacraid/rx.c	2005-03-30 09:47:39 -08:00
@@ -94,7 +94,7 @@
  *	@p1: first parameter
  *	@ret: adapter status
  *
- *	This routine will send a synchronous comamnd to the adapter and wait 
+ *	This routine will send a synchronous command to the adapter and wait 
  *	for its	completion.
  */
 
@@ -105,11 +105,11 @@
 	/*
 	 *	Write the command into Mailbox 0
 	 */
-	rx_writel(dev, InboundMailbox0, cpu_to_le32(command));
+	rx_writel(dev, InboundMailbox0, command);
 	/*
 	 *	Write the parameters into Mailboxes 1 - 4
 	 */
-	rx_writel(dev, InboundMailbox1, cpu_to_le32(p1));
+	rx_writel(dev, InboundMailbox1, p1);
 	rx_writel(dev, InboundMailbox2, 0);
 	rx_writel(dev, InboundMailbox3, 0);
 	rx_writel(dev, InboundMailbox4, 0);
@@ -167,7 +167,8 @@
 	/*
 	 *	Pull the synch status from Mailbox 0.
 	 */
-	*status = le32_to_cpu(rx_readl(dev, IndexRegs.Mailbox[0]));
+	if (status)
+		*status = rx_readl(dev, IndexRegs.Mailbox[0]);
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -274,7 +275,7 @@
  */
 static int aac_rx_check_health(struct aac_dev *dev)
 {
-	u32 status = le32_to_cpu(rx_readl(dev, MUnit.OMRx[0]));
+	u32 status = rx_readl(dev, MUnit.OMRx[0]);
 
 	/*
 	 *	Check to see if the board failed any self tests.
@@ -308,7 +309,7 @@
 		memset(buffer, 0, 512);
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
 		post->Post_Address = cpu_to_le32(baddr);
-		rx_writel(dev, MUnit.IMRx[0], cpu_to_le32(paddr));
+		rx_writel(dev, MUnit.IMRx[0], paddr);
 		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
@@ -388,8 +389,9 @@
 	{
 		if(time_after(jiffies, start+180*HZ))
 		{
-			status = rx_readl(dev, IndexRegs.Mailbox[7]) >> 16;
-			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
+			status = rx_readl(dev, IndexRegs.Mailbox[7]);
+			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %lx.\n", 
+					dev->name, instance, status);
 			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
===== drivers/scsi/aacraid/sa.c 1.13 vs edited =====
--- 1.13/drivers/scsi/aacraid/sa.c	2004-11-01 13:09:31 -08:00
+++ edited/drivers/scsi/aacraid/sa.c	2005-03-30 09:48:15 -08:00
@@ -62,7 +62,7 @@
 
 	if (intstat & mask) {
 		if (intstat & PrintfReady) {
-			aac_printf(dev, le32_to_cpu(sa_readl(dev, Mailbox5)));
+			aac_printf(dev, sa_readl(dev, Mailbox5));
 			sa_writew(dev, DoorbellClrReg_p, PrintfReady); /* clear PrintfReady */
 			sa_writew(dev, DoorbellReg_s, PrintfDone);
 		} else if (intstat & DOORBELL_1) {	// dev -> Host Normal Command Ready
@@ -128,7 +128,7 @@
  *	@p1: first parameter
  *	@ret: adapter status
  *
- *	This routine will send a synchronous comamnd to the adapter and wait 
+ *	This routine will send a synchronous command to the adapter and wait 
  *	for its	completion.
  */
 
@@ -139,11 +139,11 @@
 	/*
 	 *	Write the Command into Mailbox 0
 	 */
-	sa_writel(dev, Mailbox0, cpu_to_le32(command));
+	sa_writel(dev, Mailbox0, command);
 	/*
 	 *	Write the parameters into Mailboxes 1 - 4
 	 */
-	sa_writel(dev, Mailbox1, cpu_to_le32(p1));
+	sa_writel(dev, Mailbox1, p1);
 	sa_writel(dev, Mailbox2, 0);
 	sa_writel(dev, Mailbox3, 0);
 	sa_writel(dev, Mailbox4, 0);
@@ -186,7 +186,8 @@
 	/*
 	 *	Pull the synch status from Mailbox 0.
 	 */
-	*ret = le32_to_cpu(sa_readl(dev, Mailbox0));
+	if (ret)
+		*ret = sa_readl(dev, Mailbox0);
 	return 0;
 }
 
@@ -218,9 +219,8 @@
 	 * Fill in the remaining pieces of the init.
 	 */
 	init = dev->init;
-	init->HostElapsedSeconds = cpu_to_le32(jiffies/HZ);
+	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
 
-	dprintk(("INIT\n"));
 	/*
 	 * Tell the adapter we are back and up and running so it will scan its command
 	 * queues and enable our interrupts
@@ -230,10 +230,8 @@
 	 *	First clear out all interrupts.  Then enable the one's that 
 	 *	we can handle.
 	 */
-	dprintk(("MASK\n"));
 	sa_writew(dev, SaDbCSR.PRISETIRQMASK, cpu_to_le16(0xffff));
 	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
-	dprintk(("SYNCCMD\n"));
 	/* We can only use a 32 bit address here */
 	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &ret);
 }
@@ -286,14 +284,12 @@
 	int instance;
 	const char *name;
 
-	dprintk(("PREINST\n"));
 	instance = dev->id;
 	name     = dev->name;
 
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-	dprintk(("PREMAP\n"));
 
 	if((dev->regs.sa = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
@@ -320,15 +316,15 @@
 	 */
 	while (!(sa_readl(dev, Mailbox7) & KERNEL_UP_AND_RUNNING)) {
 		if (time_after(jiffies, start+180*HZ)) {
-			status = sa_readl(dev, Mailbox7) >> 16;
-			printk(KERN_WARNING "%s%d: adapter kernel failed to start, init status = %d.\n", name, instance, le32_to_cpu(status));
+			status = sa_readl(dev, Mailbox7);
+			printk(KERN_WARNING "%s%d: adapter kernel failed to start, init status = %lx.\n", 
+					name, instance, status);
 			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
 	}
 
-	dprintk(("ATIRQ\n"));
 	if (request_irq(dev->scsi_host_ptr->irq, aac_sa_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev ) < 0) {
 		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n", name, instance);
 		goto error_iounmap;
@@ -343,12 +339,10 @@
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
 
-	dprintk(("FUNCDONE\n"));
 
 	if(aac_init_adapter(dev) == NULL)
 		goto error_irq;
 
-	dprintk(("NEWADAPTDONE\n"));
 	/*
 	 *	Start any kernel threads needed
 	 */
@@ -362,9 +356,7 @@
 	 *	Tell the adapter that all is configure, and it can start 
 	 *	accepting requests
 	 */
-	dprintk(("STARTING\n"));
 	aac_sa_start_adapter(dev);
-	dprintk(("STARTED\n"));
 	return 0;
 
 

-- 
Mark Haverkamp <markh@osdl.org>


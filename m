From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: Sun, 3 Aug 2003 18:27:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030803082759.GA4611@twibble.org>
References: <20030803082718.GA4594@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:34483 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S270473AbTHCI2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 04:28:04 -0400
Content-Disposition: inline
In-Reply-To: <20030803082718.GA4594@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Move the eeprom details from a static struct indexed by adapter
number into the adapter information block of the adapter. This
removes the fixed size static array and removes the need to count the
number of adapters.


diff -r -du a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-03 17:01:45.000000000 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-03 18:07:05.912280016 +1000
@@ -264,6 +264,44 @@
 };
 
 
+/*
+ * The SEEPROM structure for TRM_S1040 
+ */
+struct NVRamTarget {
+	u8 cfg0;		/* Target configuration byte 0  */
+	u8 period;		/* Target period                */
+	u8 cfg2;		/* Target configuration byte 2  */
+	u8 cfg3;		/* Target configuration byte 3  */
+};
+
+
+struct NvRamType {
+	u8 sub_vendor_id[2];	/* 0,1  Sub Vendor ID   */
+	u8 sub_sys_id[2];	/* 2,3  Sub System ID   */
+	u8 sub_class;		/* 4    Sub Class       */
+	u8 vendor_id[2];	/* 5,6  Vendor ID       */
+	u8 device_id[2];	/* 7,8  Device ID       */
+	u8 reserved;		/* 9    Reserved        */
+	struct NVRamTarget target[DC395x_MAX_SCSI_ID];
+						/** 10,11,12,13
+						 ** 14,15,16,17
+						 ** ....
+						 ** ....
+						 ** 70,71,72,73
+						 */
+	u8 scsi_id;		/* 74 Host Adapter SCSI ID      */
+	u8 channel_cfg;		/* 75 Channel configuration     */
+	u8 delay_time;		/* 76 Power on delay time       */
+	u8 max_tag;		/* 77 Maximum tags              */
+	u8 reserved0;		/* 78  */
+	u8 boot_target;		/* 79  */
+	u8 boot_lun;		/* 80  */
+	u8 reserved1;		/* 81  */
+	u16 reserved2[22];	/* 82,..125 */
+	u16 cksum;		/* 126,127 */
+};
+
+
 /*-----------------------------------------------------------------------
   SCSI Request Block
   -----------------------------------------------------------------------*/
@@ -365,7 +403,6 @@
 	struct timer_list selto_timer;
 
 	u16 srb_count;
-	u16 adapter_index;	/* nth Adapter this driver */
 
 	u8 dcb_count;
 	u8 sel_timeout;
@@ -389,45 +426,11 @@
 
 	struct ScsiReqBlk srb_array[DC395x_MAX_SRB_CNT];
 	struct ScsiReqBlk srb;
-};
 
-
-/*
- * The SEEPROM structure for TRM_S1040 
- */
-struct NVRamTarget {
-	u8 cfg0;		/* Target configuration byte 0  */
-	u8 period;		/* Target period                */
-	u8 cfg2;		/* Target configuration byte 2  */
-	u8 cfg3;		/* Target configuration byte 3  */
+	struct NvRamType eeprom;	/* eeprom settings for this adapter */
 };
 
 
-struct NvRamType {
-	u8 sub_vendor_id[2];	/* 0,1  Sub Vendor ID   */
-	u8 sub_sys_id[2];	/* 2,3  Sub System ID   */
-	u8 sub_class;		/* 4    Sub Class       */
-	u8 vendor_id[2];	/* 5,6  Vendor ID       */
-	u8 device_id[2];	/* 7,8  Device ID       */
-	u8 reserved;		/* 9    Reserved        */
-	struct NVRamTarget target[DC395x_MAX_SCSI_ID];
-						/** 10,11,12,13
-						 ** 14,15,16,17
-						 ** ....
-						 ** ....
-						 ** 70,71,72,73
-						 */
-	u8 scsi_id;		/* 74 Host Adapter SCSI ID      */
-	u8 channel_cfg;		/* 75 Channel configuration     */
-	u8 delay_time;		/* 76 Power on delay time       */
-	u8 max_tag;		/* 77 Maximum tags              */
-	u8 reserved0;		/* 78  */
-	u8 boot_target;		/* 79  */
-	u8 boot_lun;		/* 80  */
-	u8 reserved1;		/* 81  */
-	u16 reserved2[22];	/* 82,..125 */
-	u16 cksum;		/* 126,127 */
-};
 
 
 /*---------------------------------------------------------------------------
@@ -514,7 +517,6 @@
  ---------------------------------------------------------------------------*/
 static struct AdapterCtlBlk *acb_list_head = NULL;
 static struct AdapterCtlBlk *acb_list_tail = NULL;
-static u16 adapter_count = 0;
 static u16 current_sync_offset = 0;
 static char monitor_next_irq = 0;
 
@@ -546,7 +548,6 @@
 	msgin_phase1,	/* phase:7 */
 };
 
-struct NvRamType eeprom_buf[DC395x_MAX_ADAPTER_NUM];
 /*
  *Fast20:	000	 50ns, 20.0 MHz
  *		001	 75ns, 13.3 MHz
@@ -1611,14 +1612,12 @@
  */
 static void reset_dev_param(struct AdapterCtlBlk *acb)
 {
-	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb = acb->link_dcb;
 	struct DeviceCtlBlk *dcb_temp;
-	struct NvRamType *eeprom;
+	struct NvRamType *eeprom = &acb->eeprom;
 	u8 period_index;
-	u16 index;
 
 	dprintkdbg(DBG_0, "reset_dev_param..............\n");
-	dcb = acb->link_dcb;
 	if (dcb == NULL)
 		return;
 
@@ -1627,8 +1626,6 @@
 		dcb->sync_mode &= ~(SYNC_NEGO_DONE + WIDE_NEGO_DONE);
 		dcb->sync_period = 0;
 		dcb->sync_offset = 0;
-		index = acb->adapter_index;
-		eeprom = &eeprom_buf[index];
 
 		dcb->dev_mode = eeprom->target[dcb->target_id].cfg0;
 		/*dcb->AdpMode = eeprom->channel_cfg; */
@@ -1679,7 +1676,7 @@
 	/* We may be in serious trouble. Wait some seconds */
 	acb->scsi_host->last_reset =
 	    jiffies + 3 * HZ / 2 +
-	    HZ * eeprom_buf[acb->adapter_index].delay_time;
+	    HZ * acb->eeprom.delay_time;
 
 	/*
 	 * re-enable interrupt      
@@ -3832,9 +3829,7 @@
 		/* Suspend queue for a while */
 		acb->scsi_host->last_reset =
 		    jiffies + HZ / 2 +
-		    HZ *
-		    eeprom_buf[acb->adapter_index].
-		    delay_time;
+		    HZ * acb->eeprom.delay_time;
 		clear_fifo(acb, "DiscEx");
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT);
 		return;
@@ -4640,7 +4635,7 @@
 	/* Maybe we locked up the bus? Then lets wait even longer ... */
 	acb->scsi_host->last_reset =
 	    jiffies + 5 * HZ / 2 +
-	    HZ * eeprom_buf[acb->adapter_index].delay_time;
+	    HZ * acb->eeprom.delay_time;
 
 	clear_fifo(acb, "RstDet");
 	set_basic_config(acb);
@@ -4731,9 +4726,8 @@
 void init_dcb(struct AdapterCtlBlk *acb, struct DeviceCtlBlk **pdcb,
 	      u8 target, u8 lun)
 {
-	struct NvRamType *eeprom;
+	struct NvRamType *eeprom = &acb->eeprom;
 	u8 period_index;
-	u16 index;
 	struct DeviceCtlBlk *dcb;
 	struct DeviceCtlBlk *dcb2;
 
@@ -4771,8 +4765,6 @@
 	dcb->flag = 0;
 	dcb->max_command = 1;
 	/* $$$$$$$ */
-	index = acb->adapter_index;
-	eeprom = &eeprom_buf[index];
 	dcb->dev_mode = eeprom->target[target].cfg0;
 	/*dcb->AdpMode = eeprom->channel_cfg; */
 	dcb->inquiry7 = 0;
@@ -4951,13 +4943,12 @@
  ***********************************************************************
  */
 static
-int __init init_acb(struct Scsi_Host *host, u32 io_port, u8 irq, u16 index)
+int __init init_acb(struct Scsi_Host *host, u32 io_port, u8 irq)
 {
-	struct NvRamType *eeprom;
-	struct AdapterCtlBlk *acb;
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
+	struct NvRamType *eeprom = &acb->eeprom;
 	u16 i;
 
-	eeprom = &eeprom_buf[index];
 	host->max_cmd_len = 24;
 	host->can_queue = DC395x_MAX_CMD_QUEUE;
 	host->cmd_per_lun = DC395x_MAX_CMD_PER_LUN;
@@ -4969,7 +4960,6 @@
 	host->irq = irq;
 	host->last_reset = jiffies;
 
-	acb = (struct AdapterCtlBlk *) host->hostdata;
 
 	host->max_id = 16;
 	if (host->max_id - 1 == eeprom->scsi_id)
@@ -4991,7 +4981,6 @@
 	acb->dcb_run_robin = NULL;
 	acb->active_dcb = NULL;
 	acb->srb_count = DC395x_MAX_SRB_CNT;
-	acb->adapter_index = index;
 	acb->scsi_host->this_id = eeprom->scsi_id;
 	acb->hostid_bit = (1 << acb->scsi_host->this_id);
 	/*acb->scsi_host->this_lun = 0; */
@@ -5050,16 +5039,14 @@
  * @host:	This hosts adapter strcuture
  * @io_port:	The base I/O port
  * @irq:	IRQ
- * @index:	Card instance number
  *
  * Returns 0 if the initialization succeeds, any other value on failure.
  **/
 static
-int __init init_adapter(struct Scsi_Host *host, u32 io_port,
-			u8 irq, u16 index)
+int __init init_adapter(struct Scsi_Host *host, u32 io_port, u8 irq)
 {
-	struct NvRamType *eeprom = &eeprom_buf[index];
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
+	struct NvRamType *eeprom = &acb->eeprom;
 
 	if (!request_region(io_port, host->n_io_port, DC395X_NAME)) {
 		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
@@ -5106,9 +5093,7 @@
 
 		acb->scsi_host->last_reset =
 		    jiffies + HZ / 2 +
-		    HZ *
-		    eeprom_buf[acb->adapter_index].
-		    delay_time;
+		    HZ * acb->eeprom.delay_time;
 
 		/*spin_lock_irq (&io_request_lock); */
 	}
@@ -5465,22 +5450,22 @@
  * print_eeprom_settings - output the eeprom settings
  * to the kernel log so people can see what they were.
  *
- * @index: Adapter number
+ * @eeprom: The eeprom data strucutre to show details for.
  **/
 static
-void __init print_eeprom_settings(u16 index)
+void __init print_eeprom_settings(struct NvRamType *eeprom)
 {
 	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
-	       eeprom_buf[index].scsi_id,
-	       eeprom_buf[index].target[0].period,
-	       clock_speed[eeprom_buf[index].target[0].period] / 10,
-	       clock_speed[eeprom_buf[index].target[0].period] % 10,
-	       eeprom_buf[index].target[0].cfg0);
+	       eeprom->scsi_id,
+	       eeprom->target[0].period,
+	       clock_speed[eeprom->target[0].period] / 10,
+	       clock_speed[eeprom->target[0].period] % 10,
+	       eeprom->target[0].cfg0);
 	dprintkl(KERN_INFO, "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
-	       eeprom_buf[index].channel_cfg,
-	       eeprom_buf[index].max_tag,
-	       1 << eeprom_buf[index].max_tag,
-	       eeprom_buf[index].delay_time);
+	       eeprom->channel_cfg,
+	       eeprom->max_tag,
+	       1 << eeprom->max_tag,
+	       eeprom->delay_time);
 }
 
 
@@ -5497,39 +5482,27 @@
  */
 static
 struct Scsi_Host *__init host_init(Scsi_Host_Template * host_template,
-				   u32 io_port, u8 irq,
-				   u16 index)
+				   u32 io_port, u8 irq)
 {
 	struct Scsi_Host *host;
 	struct AdapterCtlBlk *acb;
 
-	/*
-	 * Read the eeprom contents info the buffer we supply. Use
-	 * defaults is eeprom checksum is wrong.
-	 */
-	check_eeprom(&eeprom_buf[index], (u16) io_port);
-
-	/*
-	 *$$$$$$$$$$$  MEMORY ALLOCATE FOR ADAPTER CONTROL BLOCK $$$$$$$$$$$$
-	 */
 	host = scsi_host_alloc(host_template, sizeof(struct AdapterCtlBlk));
 	if (!host) {
-		dprintkl(KERN_INFO, "pSH scsi_host_alloc ERROR\n");
-		return 0;
+		dprintkl(KERN_INFO, "scsi_host_alloc failed\n");
+		goto failed;
 	}
- 	print_eeprom_settings(index);
+ 	acb = (struct AdapterCtlBlk *)host->hostdata;
 
- 	acb = (struct AdapterCtlBlk *) host->hostdata;
- 	if (init_acb(host, io_port, irq, index)) {
-		scsi_host_put(host);
-		return 0;
+	check_eeprom(&acb->eeprom, (u16)io_port);
+ 	print_eeprom_settings(&acb->eeprom);
+
+ 	if (init_acb(host, io_port, irq)) {
+		goto failed;
 	}
  	print_config(acb);
 
-       /*
-        *$$$$$$$$$$$$$$$$$ INITIAL ADAPTER $$$$$$$$$$$$$$$$$
-        */
- 	if (!init_adapter(host, io_port, irq, index)) {
+ 	if (!init_adapter(host, io_port, irq)) {
  		if (!acb_list_head) {
  			acb_list_head = acb;
   		} else {
@@ -5539,10 +5512,15 @@
  		acb->next_acb = NULL;
 	} else {
 		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
-		scsi_host_put(host);
-		host = NULL;
+		goto failed;
 	}
+
 	return host;
+
+failed:
+	if (host)
+		scsi_host_put(host);
+	return NULL;
 }
 
 #undef SEARCH
@@ -5607,9 +5585,8 @@
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	SPRINTF("SCSI Host Nr %i, ", shpnt->host_no);
-	SPRINTF("DC395U/UW/F DC315/U %s Adapter Nr %i\n",
-		(acb->config & HCC_WIDE_CARD) ? "Wide" : "",
-		acb->adapter_index);
+	SPRINTF("DC395U/UW/F DC315/U %s\n",
+		(acb->config & HCC_WIDE_CARD) ? "Wide" : "");
 	SPRINTF("IOPortBase 0x%04x, ", acb->IOPortBase);
 	SPRINTF("irq_level 0x%02x, ", acb->irq_level);
 	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
@@ -5621,8 +5598,7 @@
 	/*SPRINTF(", DMA_Status %i\n", DC395x_read8(acb, TRM_S1040_DMA_STATUS)); */
 	SPRINTF(", FilterCfg 0x%02x",
 		DC395x_read8(acb, TRM_S1040_SCSI_CONFIG1));
-	SPRINTF(", DelayReset %is\n",
-		eeprom_buf[acb->adapter_index].delay_time);
+	SPRINTF(", DelayReset %is\n", acb->eeprom.delay_time);
 	/*SPRINTF("\n"); */
 
 	SPRINTF("Nr of DCBs: %i\n", acb->dcb_count);
@@ -5871,7 +5847,7 @@
 	irq = dev->irq;
 	dprintkdbg(DBG_0, "IO_PORT=%04x,IRQ=%x\n", (unsigned int) io_port, irq);
 
-	scsi_host = host_init(&dc395x_driver_template, io_port, irq, adapter_count);
+	scsi_host = host_init(&dc395x_driver_template, io_port, irq);
 	if (!scsi_host)
 	{
 		dprintkdbg(DBG_0, "host_init failed\n");
@@ -5883,9 +5859,6 @@
 	/* store pci devices in out host data object. */
 	((struct AdapterCtlBlk *)(scsi_host->hostdata))->dev = dev;
 
-	/* increment adaptor count */
-	adapter_count++;
-
 	/* store ptr to scsi host in the PCI device structure */
 	pci_set_drvdata(dev, scsi_host);
 
diff -r -du a/drivers/scsi/dc395x.h b/drivers/scsi/dc395x.h
--- a/drivers/scsi/dc395x.h	2003-08-03 17:01:45.000000000 +1000
+++ b/drivers/scsi/dc395x.h	2003-08-03 18:06:26.406285840 +1000
@@ -28,7 +28,6 @@
 #define DC395x_MAX_CMD_QUEUE		32
 /* #define DC395x_MAX_QTAGS		32 */
 #define DC395x_MAX_QTAGS		16
-#define DC395x_MAX_ADAPTER_NUM		4
 #define DC395x_MAX_SCSI_ID		16
 #define DC395x_MAX_CMD_PER_LUN		DC395x_MAX_QTAGS
 #define DC395x_MAX_SG_TABLESIZE		64	/* HW limitation			*/

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au

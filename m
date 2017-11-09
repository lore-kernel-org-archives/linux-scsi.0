From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 9/13] scsi: arcmsr: add a function arcmsr_set_iop_datetime
 and driver option set_date_time to set date and time to firmware
Date: Thu, 09 Nov 2017 08:22:09 +0800
Message-ID: <1510186929.4523.88.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:45761 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbdKIIWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 03:22:18 -0500
Received: by mail-io0-f182.google.com with SMTP id i38so8924791iod.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 00:22:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

add a function arcmsr_set_iop_datetime and driver option set_date_time to set date and time to firmware

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 18:39:18.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-11-07 16:18:22.000000000 +0800
@@ -85,6 +85,8 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1884
 	#define PCI_DEVICE_ID_ARECA_1884	0x1884
 #endif
+#define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
+#define	ARCMSR_MINUTES			(1000 * 60 * 60)
 /*
 **********************************************************************************
 **
@@ -285,6 +287,7 @@ struct FIRMWARE_INFO
 #define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008
 /* (ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
 #define ARCMSR_MESSAGE_START_BGRB		      0x00060008
+#define ARCMSR_MESSAGE_SYNC_TIMER			0x00080008
 #define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008
 #define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008
 #define ARCMSR_MESSAGE_ACTIVE_EOI_MODE		    0x00100008
@@ -842,6 +845,7 @@ struct AdapterControlBlock
 	uint32_t	maxOutstanding;
 	int		vector_count;
 	uint32_t		maxFreeCCB;
+	struct timer_list	refresh_timer;
 	uint32_t		doneq_index;
 	uint32_t		ccbsize;
 	uint32_t		in_doorbell;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:53:30.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:54:18.000000000 +0800
@@ -83,6 +83,10 @@ static int cmd_per_lun = ARCMSR_DEFAULT_
 module_param(cmd_per_lun, int, S_IRUGO);
 MODULE_PARM_DESC(cmd_per_lun, " device queue depth(1 ~ 128), default is 32");
 
+static int set_date_time = 0;
+module_param(set_date_time, int, S_IRUGO);
+MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1), set_date_time=1(enable), default(=0) is disable");
+
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
@@ -125,6 +129,7 @@ static const char *arcmsr_info(struct Sc
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
 static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb);
+static void arcmsr_set_iop_datetime(unsigned long acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
@@ -852,6 +857,15 @@ out_free_irq:
 	return FAILED;
 }
 
+static void arcmsr_init_set_datetime_timer(struct AdapterControlBlock *pacb)
+{
+	init_timer(&pacb->refresh_timer);
+	pacb->refresh_timer.expires = jiffies + msecs_to_jiffies(60 * 1000);
+	pacb->refresh_timer.data = (unsigned long)pacb;
+	pacb->refresh_timer.function = &arcmsr_set_iop_datetime;
+	add_timer(&pacb->refresh_timer);
+}
+
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct Scsi_Host *host;
@@ -943,11 +957,15 @@ static int arcmsr_probe(struct pci_dev *
 	acb->eternal_timer.data = (unsigned long) acb;
 	acb->eternal_timer.function = &arcmsr_request_device_map;
 	add_timer(&acb->eternal_timer);
+	if (set_date_time)
+		arcmsr_init_set_datetime_timer(acb);
 	if(arcmsr_alloc_sysfs_attr(acb))
 		goto out_free_sysfs;
 	scsi_scan_host(host);
 	return 0;
 out_free_sysfs:
+	if (set_date_time)
+		del_timer_sync(&acb->refresh_timer);
 	del_timer_sync(&acb->eternal_timer);
 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
@@ -990,6 +1008,8 @@ static int arcmsr_suspend(struct pci_dev
 	intmask_org = arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	del_timer_sync(&acb->eternal_timer);
+	if (set_date_time)
+		del_timer_sync(&acb->refresh_timer);
 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
@@ -1036,6 +1056,8 @@ static int arcmsr_resume(struct pci_dev 
 	acb->eternal_timer.data = (unsigned long) acb;
 	acb->eternal_timer.function = &arcmsr_request_device_map;
 	add_timer(&acb->eternal_timer);
+	if (set_date_time)
+		arcmsr_init_set_datetime_timer(acb);
 	return 0;
 controller_stop:
 	arcmsr_stop_adapter_bgrb(acb);
@@ -1426,6 +1448,8 @@ static void arcmsr_remove(struct pci_dev
 	scsi_remove_host(host);
 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	del_timer_sync(&acb->eternal_timer);
+	if (set_date_time)
+		del_timer_sync(&acb->refresh_timer);
 	arcmsr_disable_outbound_ints(acb);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);	
@@ -1468,6 +1492,8 @@ static void arcmsr_shutdown(struct pci_d
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
 	del_timer_sync(&acb->eternal_timer);
+	if (set_date_time)
+		del_timer_sync(&acb->refresh_timer);
 	arcmsr_disable_outbound_ints(acb);
 	arcmsr_free_irq(pdev, acb);
 	flush_work(&acb->arcmsr_do_message_isr_bh);
@@ -3618,6 +3644,109 @@ static int arcmsr_polling_ccbdone(struct
 	return rtn;
 }
 
+static void arcmsr_set_iop_datetime(unsigned long acb)
+{
+	struct AdapterControlBlock *pacb = (struct AdapterControlBlock *)acb;
+	unsigned int days, j, i, a, b, c, d, e, m, year, mon, day, hour, min, sec, secs, next_time;
+	struct timeval tv;
+	union {
+		struct	{
+		uint16_t	signature;
+		uint8_t		year;
+		uint8_t		month;
+		uint8_t		date;
+		uint8_t		hour;
+		uint8_t		minute;
+		uint8_t		second;
+		} a;
+		struct	{
+		uint32_t	msg_time[2];
+		} b;
+	} datetime;
+
+	do_gettimeofday(&tv);
+	secs = (u32)(tv.tv_sec - (sys_tz.tz_minuteswest * 60));
+	days = secs / 86400;
+	secs = secs - 86400 * days;
+	if (secs < 0) {
+		days = days - 1;
+		secs = secs + 86400;
+	}
+	j = days / 146097;
+	i = days - 146097 * j;
+	a = i + 719468;
+	b = ( 4 * a + 3 ) / 146097;
+	c = a - ( 146097 * b ) / 4;
+	d = ( 4 * c + 3 ) / 1461 ;
+	e = c - ( 1461 * d ) / 4 ;
+	m = ( 5 * e + 2 ) / 153 ;
+	year = 400 * j + 100 * b + d + m / 10 - 2000;
+	mon = m + 3 - 12 * ( m /10 );
+	day = e - ( 153 * m + 2 ) / 5 + 1;
+	hour = secs / 3600;
+	secs = secs - 3600 * hour;
+	min = secs / 60;
+	sec = secs - 60 * min;
+
+	datetime.a.signature = 0x55AA;
+	datetime.a.year = year;
+	datetime.a.month = mon;
+	datetime.a.date = day;
+	datetime.a.hour = hour;
+	datetime.a.minute = min;
+	datetime.a.second = sec;
+
+	switch (pacb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			struct MessageUnit_A __iomem *reg = pacb->pmuA;
+			writel(datetime.b.msg_time[0], &reg->message_rwbuffer[0]);
+			writel(datetime.b.msg_time[1], &reg->message_rwbuffer[1]);
+			writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, &reg->inbound_msgaddr0);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_B: {
+			uint32_t __iomem *rwbuffer;
+			struct MessageUnit_B *reg = pacb->pmuB;
+			rwbuffer = reg->message_rwbuffer;
+			writel(datetime.b.msg_time[0], rwbuffer++);
+			writel(datetime.b.msg_time[1], rwbuffer++);
+			writel(ARCMSR_MESSAGE_SYNC_TIMER, reg->drv2iop_doorbell);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_C: {
+			struct MessageUnit_C __iomem *reg = pacb->pmuC;
+			writel(datetime.b.msg_time[0], &reg->msgcode_rwbuffer[0]);
+			writel(datetime.b.msg_time[1], &reg->msgcode_rwbuffer[1]);
+			writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, &reg->inbound_msgaddr0);
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_D: {
+			uint32_t __iomem *rwbuffer;
+			struct MessageUnit_D *reg = pacb->pmuD;
+			rwbuffer = reg->msgcode_rwbuffer;
+			writel(datetime.b.msg_time[0], rwbuffer++);
+			writel(datetime.b.msg_time[1], rwbuffer++);
+			writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, reg->inbound_msgaddr0);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_E: {
+			struct MessageUnit_E __iomem *reg = pacb->pmuE;
+			writel(datetime.b.msg_time[0], &reg->msgcode_rwbuffer[0]);
+			writel(datetime.b.msg_time[1], &reg->msgcode_rwbuffer[1]);
+			writel(ARCMSR_INBOUND_MESG0_SYNC_TIMER, &reg->inbound_msgaddr0);
+			pacb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+			writel(pacb->out_doorbell, &reg->iobound_doorbell);
+			break;
+		}
+	}
+	if (sys_tz.tz_minuteswest)
+		next_time = ARCMSR_HOURS;
+	else
+		next_time = ARCMSR_MINUTES;
+	mod_timer(&pacb->refresh_timer, jiffies + msecs_to_jiffies(next_time));
+}
+
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;

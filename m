From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 5/13] scsi: arcmsr: add driver option host_can_queue to set
 host->can_queue value by user. It's value expands up to 1024
Date: Thu, 09 Nov 2017 08:00:58 +0800
Message-ID: <1510185658.4523.74.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

add driver option host_can_queue to set host->can_queue value by user. It's value expands up to 1024

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 17:07:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 17:40:54.000000000 +0800
@@ -49,9 +49,11 @@ struct device_attribute;
 	#define ARCMSR_MAX_FREECCB_NUM	160
 #define ARCMSR_MAX_OUTSTANDING_CMD	155
 #else
-	#define ARCMSR_MAX_FREECCB_NUM	320
-#define ARCMSR_MAX_OUTSTANDING_CMD	255
+	#define ARCMSR_MAX_FREECCB_NUM	1024
+#define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #endif
+#define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
+#define ARCMSR_MIN_OUTSTANDING_CMD	32
 #define ARCMSR_DRIVER_VERSION		"v1.30.00.22-20151126"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:50:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:51:20.000000000 +0800
@@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
+static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
+module_param(host_can_queue, int, S_IRUGO);
+MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
+
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
@@ -133,7 +137,7 @@ static struct scsi_host_template arcmsr_
 	.eh_bus_reset_handler	= arcmsr_bus_reset,
 	.bios_param		= arcmsr_bios_param,
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
-	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
+	.can_queue		= ARCMSR_DEFAULT_OUTSTANDING_CMD,
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
 	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
 	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
@@ -877,7 +881,9 @@ static int arcmsr_probe(struct pci_dev *
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
 	host->max_id = ARCMSR_MAX_TARGETID;		/*16:8*/
 	host->max_cmd_len = 16;	 			/*this is issue of 64bit LBA ,over 2T byte*/
-	host->can_queue = ARCMSR_MAX_OUTSTANDING_CMD;
+	if ((host_can_queue < ARCMSR_MIN_OUTSTANDING_CMD) || (host_can_queue > ARCMSR_MAX_OUTSTANDING_CMD))
+		host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
+	host->can_queue = host_can_queue;	/* max simultaneous cmds */		
 	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;	    
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
@@ -3238,11 +3244,11 @@ static bool arcmsr_get_firmware_spec(str
 	default:
 		break;
 	}
-	if (acb->firm_numbers_queue > ARCMSR_MAX_OUTSTANDING_CMD)
-		acb->maxOutstanding = ARCMSR_MAX_OUTSTANDING_CMD;
+	acb->maxOutstanding = acb->firm_numbers_queue - 1;
+	if (acb->host->can_queue >= acb->firm_numbers_queue)
+		acb->host->can_queue = acb->maxOutstanding;
 	else
-		acb->maxOutstanding = acb->firm_numbers_queue - 1;
-	acb->host->can_queue = acb->maxOutstanding;
+		acb->maxOutstanding = acb->host->can_queue;
 	acb->maxFreeCCB = acb->host->can_queue;
 	if (acb->maxFreeCCB < ARCMSR_MAX_FREECCB_NUM)
 		acb->maxFreeCCB += 64;

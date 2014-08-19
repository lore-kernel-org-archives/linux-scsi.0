From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 4/17] arcmsr: limit max. number of SCSI command request
Date: Tue, 19 Aug 2014 14:43:07 +0800
Message-ID: <1408430587.4748.28.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47899 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHSGnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 02:43:14 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so9417272pab.14
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2014 23:43:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch limits the max. number of SCSI command request to avoid command overflow.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:24:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:22:36.000000000 +0800
@@ -45,11 +45,12 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#define ARCMSR_MAX_OUTSTANDING_CMD						256
 #ifdef CONFIG_XEN
 	#define ARCMSR_MAX_FREECCB_NUM	160
+#define ARCMSR_MAX_OUTSTANDING_CMD	155
 #else
 	#define ARCMSR_MAX_FREECCB_NUM	320
+#define ARCMSR_MAX_OUTSTANDING_CMD	255
 #endif
 #define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140428"
 #define ARCMSR_SCSI_INITIATOR_ID						255
@@ -598,6 +599,7 @@ struct AdapterControlBlock
 				#define	FW_DEADLOCK	0x0010
 	atomic_t 			rq_map_token;
 	atomic_t			ante_token_value;
+	uint32_t	maxOutstanding;
 	int		msix_vector_count;
 };/* HW_DEVICE_EXTENSION */
 /*
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-08 19:03:48.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-08 19:35:46.000000000 +0800
@@ -134,7 +134,7 @@ static struct scsi_host_template arcmsr_
 	.eh_bus_reset_handler	= arcmsr_bus_reset,
 	.bios_param		= arcmsr_bios_param,
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
-	.can_queue		= ARCMSR_MAX_FREECCB_NUM,
+	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
 	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
 	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
@@ -693,7 +693,7 @@ static int arcmsr_probe(struct pci_dev *
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
 	host->max_id = ARCMSR_MAX_TARGETID;		/*16:8*/
 	host->max_cmd_len = 16;	 			/*this is issue of 64bit LBA ,over 2T byte*/
-	host->can_queue = ARCMSR_MAX_FREECCB_NUM;	/* max simultaneous cmds */		
+	host->can_queue = ARCMSR_MAX_OUTSTANDING_CMD;	/* max simultaneous cmds */		
 	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;	    
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
@@ -2215,9 +2215,6 @@ static int arcmsr_queue_command_lck(stru
 		arcmsr_handle_virtual_command(acb, cmd);
 		return 0;
 	}
-	if (atomic_read(&acb->ccboutstandingcount) >=
-			ARCMSR_MAX_OUTSTANDING_CMD)
-		return SCSI_MLQUEUE_HOST_BUSY;
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2427,12 +2424,27 @@ static bool arcmsr_get_hbc_config(struct
 }
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-	if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
-		return arcmsr_get_hba_config(acb);
-	else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
-		return arcmsr_get_hbb_config(acb);
+	bool rtn = false;
+
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A:
+		rtn = arcmsr_get_hba_config(acb);
+		break;
+	case ACB_ADAPTER_TYPE_B:
+		rtn = arcmsr_get_hbb_config(acb);
+		break;
+	case ACB_ADAPTER_TYPE_C:
+		rtn = arcmsr_get_hbc_config(acb);
+		break;
+	default:
+		break;
+	}
+	if(acb->firm_numbers_queue > ARCMSR_MAX_OUTSTANDING_CMD)
+		acb->maxOutstanding = ARCMSR_MAX_OUTSTANDING_CMD;
 	else
-		return arcmsr_get_hbc_config(acb);
+		acb->maxOutstanding = acb->firm_numbers_queue - 1;
+	acb->host->can_queue = acb->maxOutstanding;
+	return rtn;
 }
 
 static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,



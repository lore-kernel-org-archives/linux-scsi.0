From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 8/17] scsi: arcmsr: add driver option cmd_per_lun to set
 host->cmd_per_lun value by user
Date: Tue, 05 Dec 2017 09:55:02 +0800
Message-ID: <1512438902.4577.55.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

add driver option cmd_per_lun to set host->cmd_per_lun value by user

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:26:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:26:32.000000000 +0800
@@ -56,7 +56,9 @@ struct device_attribute;
 #define ARCMSR_MAX_XFER_SECTORS_C						304
 #define ARCMSR_MAX_TARGETID							17
 #define ARCMSR_MAX_TARGETLUN							8
-#define ARCMSR_MAX_CMD_PERLUN		                 ARCMSR_MAX_OUTSTANDING_CMD
+#define ARCMSR_MAX_CMD_PERLUN		128
+#define ARCMSR_DEFAULT_CMD_PERLUN	32
+#define ARCMSR_MIN_CMD_PERLUN		1
 #define ARCMSR_MAX_QBUFFER							4096
 #define ARCMSR_DEFAULT_SG_ENTRIES						38
 #define ARCMSR_MAX_HBB_POSTQUEUE						264
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:30.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:18.000000000 +0800
@@ -79,6 +79,10 @@ static int host_can_queue = ARCMSR_DEFAU
 module_param(host_can_queue, int, S_IRUGO);
 MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
 
+static int cmd_per_lun = ARCMSR_DEFAULT_CMD_PERLUN;
+module_param(cmd_per_lun, int, S_IRUGO);
+MODULE_PARM_DESC(cmd_per_lun, " device queue depth(1 ~ 128), default is 32");
+
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
@@ -141,7 +145,7 @@ static struct scsi_host_template arcmsr_
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
 	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
 	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
-	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
+	.cmd_per_lun		= ARCMSR_DEFAULT_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
 	.no_write_same		= 1,
@@ -884,7 +888,9 @@ static int arcmsr_probe(struct pci_dev *
 	if ((host_can_queue < ARCMSR_MIN_OUTSTANDING_CMD) || (host_can_queue > ARCMSR_MAX_OUTSTANDING_CMD))
 		host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
 	host->can_queue = host_can_queue;	/* max simultaneous cmds */		
-	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;	    
+	if ((cmd_per_lun < ARCMSR_MIN_CMD_PERLUN) || (cmd_per_lun > ARCMSR_MAX_CMD_PERLUN))
+		cmd_per_lun = ARCMSR_DEFAULT_CMD_PERLUN;
+	host->cmd_per_lun = cmd_per_lun;	    
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
 	pci_set_drvdata(pdev, host);

From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.2 9/16] arcmsr: modify printing adapter model number and
 F/W messages
Date: Wed, 14 May 2014 19:31:22 +0800
Message-ID: <1400067082.6957.39.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Revise printing model name and firmware version order.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:46:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:47:20.000000000 +0800
@@ -2230,10 +2230,10 @@ static bool arcmsr_get_hba_config(struct
 		iop_device_map++;
 		count--;
 	}
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n", 
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		acb->host->host_no,
-		acb->firm_version,
-		acb->firm_model);
+		acb->firm_model,
+		acb->firm_version);
 	acb->signature = readl(&reg->message_rwbuffer[0]);
 	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
 	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
@@ -2306,10 +2306,10 @@ static bool arcmsr_get_hbb_config(struct
 		count--;
 	}
 	
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		acb->host->host_no,
-		acb->firm_version,
-		acb->firm_model);
+		acb->firm_model,
+		acb->firm_version);
 
 	acb->signature = readl(&reg->message_rwbuffer[1]);
 	/*firm_signature,1,00-03*/
@@ -2372,10 +2372,10 @@ static bool arcmsr_get_hbc_config(struct
 		iop_firm_version++;
 		count--;
 	}
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		pACB->host->host_no,
-		pACB->firm_version,
-		pACB->firm_model);
+		pACB->firm_model,
+		pACB->firm_version);
 	pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);   /*firm_request_len,1,04-07*/
 	pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]); /*firm_numbers_queue,2,08-11*/
 	pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);    /*firm_sdram_size,3,12-15*/

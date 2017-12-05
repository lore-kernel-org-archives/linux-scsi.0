From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 9/17] scsi: arcmsr: add ACB_F_MSG_GET_CONFIG to
 acb->acb_flags for for message interrupt checking before schedule work for
 get device map
Date: Tue, 05 Dec 2017 09:57:23 +0800
Message-ID: <1512439043.4577.57.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:39442 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbdLEJ5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 04:57:32 -0500
Received: by mail-it0-f51.google.com with SMTP id 68so135524ite.4
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 01:57:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

From: Ching Huang <ching2048@areca.com.tw>

add ACB_F_MSG_GET_CONFIG to acb->acb_flags for for message interrupt checking before schedule work for get device map

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:26:32.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:27:04.000000000 +0800
@@ -782,6 +782,7 @@ struct AdapterControlBlock
 	/* iop init */
 	#define ACB_F_ABORT				0x0200
 	#define ACB_F_FIRMWARE_TRAP           		0x0400
+	#define ACB_F_MSG_GET_CONFIG		0x1000
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:18.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:06.000000000 +0800
@@ -743,6 +743,7 @@ static void arcmsr_message_isr_bh_fn(str
 	struct scsi_device *psdev;
 	char diff, temp;
 
+	acb->acb_flags &= ~ACB_F_MSG_GET_CONFIG;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg  = acb->pmuA;
@@ -2328,7 +2329,8 @@ static void arcmsr_hbaA_message_isr(stru
 	struct MessageUnit_A __iomem *reg  = acb->pmuA;
 	/*clear interrupt and message state*/
 	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
-	schedule_work(&acb->arcmsr_do_message_isr_bh);
+	if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
+		schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 static void arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
@@ -2336,7 +2338,8 @@ static void arcmsr_hbaB_message_isr(stru
 
 	/*clear interrupt and message state*/
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
-	schedule_work(&acb->arcmsr_do_message_isr_bh);
+	if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
+		schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 /*
 **********************************************************************************
@@ -2352,7 +2355,8 @@ static void arcmsr_hbaC_message_isr(stru
 	struct MessageUnit_C __iomem *reg  = acb->pmuC;
 	/*clear interrupt and message state*/
 	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, &reg->outbound_doorbell_clear);
-	schedule_work(&acb->arcmsr_do_message_isr_bh);
+	if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
+		schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
 static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)
@@ -2361,7 +2365,8 @@ static void arcmsr_hbaD_message_isr(stru
 
 	writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE, reg->outbound_doorbell);
 	readl(reg->outbound_doorbell);
-	schedule_work(&acb->arcmsr_do_message_isr_bh);
+	if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
+		schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
 static void arcmsr_hbaE_message_isr(struct AdapterControlBlock *acb)
@@ -2369,7 +2374,8 @@ static void arcmsr_hbaE_message_isr(stru
 	struct MessageUnit_E __iomem *reg  = acb->pmuE;
 
 	writel(0, &reg->host_int_status);
-	schedule_work(&acb->arcmsr_do_message_isr_bh);
+	if (acb->acb_flags & ACB_F_MSG_GET_CONFIG)
+		schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
 static int arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
@@ -3826,6 +3832,7 @@ static void arcmsr_hbaA_request_device_m
 			return;
 		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
 	return;
@@ -3848,6 +3855,7 @@ static void arcmsr_hbaB_request_device_m
 			return;
 		}
 		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
 	return;
@@ -3871,6 +3879,7 @@ static void arcmsr_hbaC_request_device_m
 		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
 	return;
@@ -3900,6 +3909,7 @@ static void arcmsr_hbaD_request_device_m
 		}
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
 			reg->inbound_msgaddr0);
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
 	}
@@ -3930,6 +3940,7 @@ static void arcmsr_hbaE_request_device_m
 		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
 		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
 	}

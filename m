From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 5/4] scsi: arcmsr: simplify arcmsr_request_device_map
 routine
Date: Wed, 13 Dec 2017 16:33:36 +0800
Message-ID: <1513154016.8691.9.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

simplify arcmsr_request_device_map routine

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 95c9f08..4774559 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -122,9 +122,6 @@ static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(struct timer_list *t);
-static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
@@ -3789,113 +3786,12 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	}
 }
 
-static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-		return;
-	} else {
-		acb->fw_flag = FW_NORMAL;
-		if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)){
-			atomic_set(&acb->rq_map_token, 16);
-		}
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-			return;
-		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-	}
-	return;
-}
-
-static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_B *reg = acb->pmuB;
-	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-		return;
-	} else {
-		acb->fw_flag = FW_NORMAL;
-		if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token, 16);
-		}
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-			return;
-		}
-		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-	}
-	return;
-}
-
-static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_C __iomem *reg = acb->pmuC;
-	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags & ACB_F_ABORT) != 0)) {
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-		return;
-	} else {
-		acb->fw_flag = FW_NORMAL;
-		if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token, 16);
-		}
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-			return;
-		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
-	}
-	return;
-}
-
-static void arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit_D *reg = acb->pmuD;
-
-	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
-		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
-		((acb->acb_flags & ACB_F_ABORT) != 0)) {
-		mod_timer(&acb->eternal_timer,
-			jiffies + msecs_to_jiffies(6 * HZ));
-	} else {
-		acb->fw_flag = FW_NORMAL;
-		if (atomic_read(&acb->ante_token_value) ==
-			atomic_read(&acb->rq_map_token)) {
-			atomic_set(&acb->rq_map_token, 16);
-		}
-		atomic_set(&acb->ante_token_value,
-			atomic_read(&acb->rq_map_token));
-		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies +
-				msecs_to_jiffies(6 * HZ));
-			return;
-		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
-			reg->inbound_msgaddr0);
-		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies +
-			msecs_to_jiffies(6 * HZ));
-	}
-}
-
-static void arcmsr_hbaE_request_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_request_device_map(struct timer_list *t)
 {
-	struct MessageUnit_E __iomem *reg = acb->pmuE;
-
+	struct AdapterControlBlock *acb = from_timer(acb, t, eternal_timer);
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
-		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
-		((acb->acb_flags & ACB_F_ABORT) != 0)) {
+		(acb->acb_flags & ACB_F_BUS_RESET) ||
+		(acb->acb_flags & ACB_F_ABORT)) {
 		mod_timer(&acb->eternal_timer,
 			jiffies + msecs_to_jiffies(6 * HZ));
 	} else {
@@ -3911,37 +3807,40 @@ static void arcmsr_hbaE_request_device_map(struct AdapterControlBlock *acb)
 				msecs_to_jiffies(6 * HZ));
 			return;
 		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
-		writel(acb->out_doorbell, &reg->iobound_doorbell);
-		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies +
-			msecs_to_jiffies(6 * HZ));
-	}
-}
-
-static void arcmsr_request_device_map(struct timer_list *t)
-{
-	struct AdapterControlBlock *acb = from_timer(acb, t, eternal_timer);
-	switch (acb->adapter_type) {
+		switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A: {
-			arcmsr_hbaA_request_device_map(acb);
-		}
-		break;
+			struct MessageUnit_A __iomem *reg = acb->pmuA;
+			writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+			break;
+			}
 		case ACB_ADAPTER_TYPE_B: {
-			arcmsr_hbaB_request_device_map(acb);
-		}
-		break;
+			struct MessageUnit_B *reg = acb->pmuB;
+			writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+			break;
+			}
 		case ACB_ADAPTER_TYPE_C: {
-			arcmsr_hbaC_request_device_map(acb);
+			struct MessageUnit_C __iomem *reg = acb->pmuC;
+			writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+			break;
+			}
+		case ACB_ADAPTER_TYPE_D: {
+			struct MessageUnit_D *reg = acb->pmuD;
+			writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
+			break;
+			}
+		case ACB_ADAPTER_TYPE_E: {
+			struct MessageUnit_E __iomem *reg = acb->pmuE;
+			writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+			acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+			writel(acb->out_doorbell, &reg->iobound_doorbell);
+			break;
+			}
+		default:
+			return;
 		}
-		break;
-		case ACB_ADAPTER_TYPE_D:
-			arcmsr_hbaD_request_device_map(acb);
-		break;
-		case ACB_ADAPTER_TYPE_E:
-			arcmsr_hbaE_request_device_map(acb);
-		break;
+		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
 	}
 }
 

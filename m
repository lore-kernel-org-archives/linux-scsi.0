From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2] megaraid_sas: add an i/o barrier
Date: Mon, 1 Feb 2016 15:12:04 +0100
Message-ID: <56AF67B4.2010702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A barrier should be added to ensure proper
ordering of memory mapped writes.

V2: - added the barrier also to megasas_fire_cmd_skinny,
as suggested by Kashyap Desai

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 1 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index cc92c8198d..9f7689515c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -749,6 +749,7 @@ megasas_fire_cmd_skinny(struct megasas_instance *instance,
 	       &(regs)->inbound_high_queue_port);
 	writel((lower_32_bits(frame_phys_addr) | (frame_count<<1))|1,
 	       &(regs)->inbound_low_queue_port);
+	mmiowb();
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d9d0029fb1..98a848bdfd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -204,6 +204,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 		&instance->reg_set->inbound_low_queue_port);
 	writel(le32_to_cpu(req_desc->u.high),
 		&instance->reg_set->inbound_high_queue_port);
+	mmiowb();
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
 }
-- 
2.4.3

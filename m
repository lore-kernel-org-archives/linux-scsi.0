From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 06/19] megaraid_sas: reduce size of fusion_context and use kmalloc for allocation
Date: Thu, 19 Oct 2017 02:48:53 -0700
Message-ID: <1508406546-25944-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:51416 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdJSJuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:14 -0400
Received: by mail-pf0-f194.google.com with SMTP id n14so6186893pfh.8
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:14 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

fusion_context structure is very large around 180kB
and most of the size is contributed by log_to_span
array. Move log_to_span out of fusion context and have
separate allocation for log_to_span. And use kmalloc
to allocate fusion_context.
Currently kmemleak reports 1000s of false positives for
fusion->cmd_list[]. kmemleak does not track page allocation
for fusion_context. This change will also fix the false positives
reported by kmemleak.

Ref: https://marc.info/?l=linux-scsi&m=150545293900917

Reported-by: Shu Wang <shuwang@redhat.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 43 +++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  3 +-
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5b36a0103895..1f34577d8982 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2218,7 +2218,6 @@ struct megasas_instance {
 
 	/* Ptr to hba specific information */
 	void *ctrl_context;
-	u32 ctrl_context_pages;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned int msix_vectors;
 	struct megasas_irq_context irq_context[MEGASAS_MAX_MSIX_QUEUES];
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 01d42eb6486b..a8055341e875 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4502,20 +4502,31 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
 
-	instance->ctrl_context_pages = get_order(sizeof(struct fusion_context));
-	instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-		instance->ctrl_context_pages);
+	instance->ctrl_context = kzalloc(sizeof(struct fusion_context),
+					 GFP_KERNEL);
 	if (!instance->ctrl_context) {
-		/* fall back to using vmalloc for fusion_context */
-		instance->ctrl_context = vzalloc(sizeof(struct fusion_context));
-		if (!instance->ctrl_context) {
-			dev_err(&instance->pdev->dev, "Failed from %s %d\n", __func__, __LINE__);
-			return -ENOMEM;
-		}
+		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
+			__func__, __LINE__);
+		return -ENOMEM;
 	}
 
 	fusion = instance->ctrl_context;
 
+	fusion->log_to_span_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
+					      sizeof(LD_SPAN_INFO));
+	fusion->log_to_span =
+		(PLD_SPAN_INFO)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						fusion->log_to_span_pages);
+	if (!fusion->log_to_span) {
+		fusion->log_to_span = vzalloc(MAX_LOGICAL_DRIVES_EXT *
+					      sizeof(LD_SPAN_INFO));
+		if (!fusion->log_to_span) {
+			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
+				__func__, __LINE__);
+			return -ENOMEM;
+		}
+	}
+
 	fusion->load_balance_info_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
 		sizeof(struct LD_LOAD_BALANCE_INFO));
 	fusion->load_balance_info =
@@ -4546,11 +4557,15 @@ megasas_free_fusion_context(struct megasas_instance *instance)
 					fusion->load_balance_info_pages);
 		}
 
-		if (is_vmalloc_addr(fusion))
-			vfree(fusion);
-		else
-			free_pages((ulong)fusion,
-				instance->ctrl_context_pages);
+		if (fusion->log_to_span) {
+			if (is_vmalloc_addr(fusion->log_to_span))
+				vfree(fusion->log_to_span);
+			else
+				free_pages((ulong)fusion->log_to_span,
+					   fusion->log_to_span_pages);
+		}
+
+		kfree(fusion);
 	}
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 7c1f7ccf031d..a2b56913f382 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1312,7 +1312,8 @@ struct fusion_context {
 	u8 fast_path_io;
 	struct LD_LOAD_BALANCE_INFO *load_balance_info;
 	u32 load_balance_info_pages;
-	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
+	LD_SPAN_INFO *log_to_span;
+	u32 log_to_span_pages;
 	struct LD_STREAM_DETECT **stream_detect_by_ld;
 };
 
-- 
2.14.1.dirty

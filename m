Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC341C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbiE3XPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241288AbiE3XPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:40 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C123719D6
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:39 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B42815A1518;
        Mon, 30 May 2022 23:15:38 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E5F315A0DAC;
        Mon, 30 May 2022 23:15:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952538; a=rsa-sha256;
        cv=none;
        b=9QudtMIFBZ1WPKlRhCQcIC0vLXRroBpNRoh/JmRzUWOoNwfE7b+jHfipz8K7Ik9n3neDxa
        +ntzSCuHRUr7+u/OUvhqoIYBx2y5XlnYEdmhXOZub4DYrb7vkjc0my1W3OmRMKQBZrYEU1
        fsGbG9+eODwVNAk2/2m1pwjeIuO3aFCXS2bnXVzT7jLZ/3w+K0V+LQ0p4IpoY4A73thb+G
        gWLEJnXK2bh2ImU2W75XhV+LUSSJmygog70mUtasfGkldtE8+hcqhrlJk93lNXPhidHGdh
        QZ0ZszzCjlNI9FYyM59JZiiNmUhHj+6Dr/oIB19AK7p7OWrgx+iNwQUvFq8Xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=p8DH74stFBo7CpSD7rNUh3UUX+QVa3hFJlyJeiZ5J+M=;
        b=WhAZ2CgafQVvQ2ABfWQ3su8GxBhCdD8IvIoMZMqRAYsG0t56odCgRjWVmVQiZLoNTQ784I
        Q71blF2M3TDklaaL56IeHqLJcLUD+hjszsKASk5SbDl34ucG7lW95+eEDga1r7bNqvWye5
        RZFMHj3ikqrfjH3A9uNL5z1mjUtg5ASfX9zPNDcJa75qYXXRJvE3pbNL06mu7TV2DV4TvD
        bUQrEEARuLRo5R8LEmTfCHbjGfkcwElZQYbAfS3iJKUKc+T3x1ppwSk+bwICSgmWoy0R0n
        +x8j7m88+RQN1ySYn0nrF6SOE5H93/TVoKLGISZKodHJ2/PsJBF96rKYKZJ/Gg==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-qckb2;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Thoughtful-Dime: 510ca72b0838ae5f_1653952538283_514468687
X-MC-Loop-Signature: 1653952538283:266591513
X-MC-Ingress-Time: 1653952538283
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.115.45.17 (trex/6.7.1);
        Mon, 30 May 2022 23:15:38 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqX67RCz15;
        Mon, 30 May 2022 16:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952537;
        bh=p8DH74stFBo7CpSD7rNUh3UUX+QVa3hFJlyJeiZ5J+M=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=m1p1vDS+YOFOPpOXqw02UxWjPpBQNn3350FDvz1/pVlFDIh540ZYq//kcICj1j914
         nCKIiiHRg3Z6+XsOyNF8y4PcnA9dSNoGrO6jEV8G2saBZ+dtiuWzqP3QSWzAPl8vsj
         IDzIem+h1ubH9/7eu3TFEQFwMKDpJxk8W+WsSxI/NZl8BDmDGMFRVBdoe44iwi5fdG
         4IB4aEQtMIyKSLKfGjJ9l55pY5SfuV2tsoAgoUR/SwjTT+mTPEXSZzIt0/ywzftCNL
         iu/RJkFFMn5c6ZXzYZb0aydx2NHPq+gnRoEBanqrI54Rlom6z2pX9ntdjrk6akeNg9
         79F87Lwc1aNdQ==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 03/10] scsi/megaraid_sas: Replace instance->tasklet with threaded irq
Date:   Mon, 30 May 2022 16:15:05 -0700
Message-Id: <20220530231512.9729-4-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tasklets have long been deprecated as being too heavy on the system
by running in irq context - and this is not a performance critical
path. If a higher priority process wants to run, it must wait for
the tasklet to finish before doing so. A more suitable equivalent
is to converted to threaded irq instead and deal with the command
completion in task context.

While tasklets do not run concurrently amongst themselves, the
callback can compete vs megasas_wait_for_outstanding() so any races
with threads will also be present with the async thread completing
the command.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 51 ++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 18 +++++---
 3 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4919ea54b827..d119c02f0a9c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2387,7 +2387,6 @@ struct megasas_instance {
 	atomic64_t high_iops_outstanding;
 
 	struct megasas_instance_template *instancet;
-	struct tasklet_struct isr_tasklet;
 	struct work_struct work_init;
 	struct delayed_work fw_fault_work;
 	struct workqueue_struct *fw_fault_work_q;
@@ -2549,7 +2548,7 @@ struct megasas_instance_template {
 	int (*check_reset)(struct megasas_instance *, \
 		struct megasas_register_set __iomem *);
 	irqreturn_t (*service_isr)(int irq, void *devp);
-	void (*tasklet)(unsigned long);
+	irqreturn_t (*service_thr)(int irq, void *devp);
 	u32 (*init_adapter)(struct megasas_instance *);
 	u32 (*build_and_issue_cmd) (struct megasas_instance *,
 				    struct scsi_cmnd *);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c95360a3c186..24f31ebad877 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -229,12 +229,12 @@ static int
 megasas_adp_reset_gen2(struct megasas_instance *instance,
 		       struct megasas_register_set __iomem *reg_set);
 static irqreturn_t megasas_isr(int irq, void *devp);
+static irqreturn_t megasas_complete_cmd_dpc_irq(int irq, void *devp);
 static u32
 megasas_init_adapter_mfi(struct megasas_instance *instance);
 u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
-static void megasas_complete_cmd_dpc(unsigned long instance_addr);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	int seconds);
@@ -615,7 +615,7 @@ static struct megasas_instance_template megasas_instance_template_xscale = {
 	.adp_reset = megasas_adp_reset_xscale,
 	.check_reset = megasas_check_reset_xscale,
 	.service_isr = megasas_isr,
-	.tasklet = megasas_complete_cmd_dpc,
+	.service_thr = megasas_complete_cmd_dpc_irq,
 	.init_adapter = megasas_init_adapter_mfi,
 	.build_and_issue_cmd = megasas_build_and_issue_cmd,
 	.issue_dcmd = megasas_issue_dcmd,
@@ -754,7 +754,7 @@ static struct megasas_instance_template megasas_instance_template_ppc = {
 	.adp_reset = megasas_adp_reset_xscale,
 	.check_reset = megasas_check_reset_ppc,
 	.service_isr = megasas_isr,
-	.tasklet = megasas_complete_cmd_dpc,
+	.service_thr = megasas_complete_cmd_dpc_irq,
 	.init_adapter = megasas_init_adapter_mfi,
 	.build_and_issue_cmd = megasas_build_and_issue_cmd,
 	.issue_dcmd = megasas_issue_dcmd,
@@ -895,7 +895,7 @@ static struct megasas_instance_template megasas_instance_template_skinny = {
 	.adp_reset = megasas_adp_reset_gen2,
 	.check_reset = megasas_check_reset_skinny,
 	.service_isr = megasas_isr,
-	.tasklet = megasas_complete_cmd_dpc,
+	.service_thr = megasas_complete_cmd_dpc_irq,
 	.init_adapter = megasas_init_adapter_mfi,
 	.build_and_issue_cmd = megasas_build_and_issue_cmd,
 	.issue_dcmd = megasas_issue_dcmd,
@@ -1095,7 +1095,7 @@ static struct megasas_instance_template megasas_instance_template_gen2 = {
 	.adp_reset = megasas_adp_reset_gen2,
 	.check_reset = megasas_check_reset_gen2,
 	.service_isr = megasas_isr,
-	.tasklet = megasas_complete_cmd_dpc,
+	.service_thr = megasas_complete_cmd_dpc_irq,
 	.init_adapter = megasas_init_adapter_mfi,
 	.build_and_issue_cmd = megasas_build_and_issue_cmd,
 	.issue_dcmd = megasas_issue_dcmd,
@@ -2268,19 +2268,16 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 }
 
 /**
- * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
- * @instance_addr:			Address of adapter soft state
+ * megasas_complete_cmd_dpc	 -	Completes command
+ * @instance:			        Adapter soft state instance
  *
- * Tasklet to complete cmds
  */
-static void megasas_complete_cmd_dpc(unsigned long instance_addr)
+static void megasas_complete_cmd_dpc(struct megasas_instance *instance)
 {
 	u32 producer;
 	u32 consumer;
 	u32 context;
 	struct megasas_cmd *cmd;
-	struct megasas_instance *instance =
-				(struct megasas_instance *)instance_addr;
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
@@ -2320,6 +2317,15 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 	megasas_check_and_restore_queue_depth(instance);
 }
 
+/* Called from threaded IRQ, runs in task context. */
+static irqreturn_t megasas_complete_cmd_dpc_irq(int irq, void *devp)
+{
+	struct megasas_instance *instance = (struct megasas_instance *)devp;
+
+	megasas_complete_cmd_dpc(instance);
+	return IRQ_HANDLED;
+}
+
 static void megasas_sriov_heartbeat_handler(struct timer_list *t);
 
 /**
@@ -2825,7 +2831,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
 			 */
-			megasas_complete_cmd_dpc((unsigned long)instance);
+			megasas_complete_cmd_dpc(instance);
 		}
 
 		msleep(1000);
@@ -4078,8 +4084,7 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 		}
 	}
 
-	tasklet_schedule(&instance->isr_tasklet);
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 /**
@@ -5682,9 +5687,11 @@ megasas_setup_irqs_ioapic(struct megasas_instance *instance)
 	instance->irq_context[0].MSIxIndex = 0;
 	snprintf(instance->irq_context->name, MEGASAS_MSIX_NAME_LEN, "%s%u",
 		"megasas", instance->host->host_no);
-	if (request_irq(pci_irq_vector(pdev, 0),
-			instance->instancet->service_isr, IRQF_SHARED,
-			instance->irq_context->name, &instance->irq_context[0])) {
+	if (request_threaded_irq(pci_irq_vector(pdev, 0),
+			instance->instancet->service_isr,
+			instance->instancet->service_thr, IRQF_SHARED,
+			instance->irq_context->name,
+			&instance->irq_context[0])) {
 		dev_err(&instance->pdev->dev,
 				"Failed to register IRQ from %s %d\n",
 				__func__, __LINE__);
@@ -6322,9 +6329,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	dev_info(&instance->pdev->dev,
 		"RDPQ mode\t: (%s)\n", instance->is_rdpq ? "enabled" : "disabled");
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
-
 	/*
 	 * Below are default value for legacy Firmware.
 	 * non-fusion based controllers
@@ -7771,8 +7775,6 @@ megasas_suspend(struct device *dev)
 		instance->ev = NULL;
 	}
 
-	tasklet_kill(&instance->isr_tasklet);
-
 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance);
 
@@ -7879,9 +7881,6 @@ megasas_resume(struct device *dev)
 	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
 		goto fail_init_mfi;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		     (unsigned long)instance);
-
 	if (instance->msix_vectors ?
 			megasas_setup_irqs_msix(instance, 0) :
 			megasas_setup_irqs_ioapic(instance))
@@ -8011,8 +8010,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	/* cancel all wait events */
 	wake_up_all(&instance->int_cmd_wait_q);
 
-	tasklet_kill(&instance->isr_tasklet);
-
 	/*
 	 * Take the instance off the instance array. Note that we will not
 	 * decrement the max_index. We let this array be sparse array
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5b5885d9732b..5887e3cb725e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3819,15 +3819,12 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 
 /**
  * megasas_complete_cmd_dpc_fusion -	Completes command
- * @instance_addr:			Adapter soft state address
+ * @instance:				Adapter soft state instance
  *
- * Tasklet to complete cmds
  */
 static void
-megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+megasas_complete_cmd_dpc_fusion(struct megasas_instance *instance)
 {
-	struct megasas_instance *instance =
-		(struct megasas_instance *)instance_addr;
 	struct megasas_irq_context *irq_ctx = NULL;
 	u32 count, MSIxIndex;
 
@@ -3843,6 +3840,15 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 	}
 }
 
+/* Called from threaded IRQ, runs in task context. */
+static irqreturn_t megasas_complete_cmd_dpc_fusion_irq(int irq, void *devp)
+{
+	struct megasas_instance *instance = (struct megasas_instance *)devp;
+
+	megasas_complete_cmd_dpc_fusion(instance);
+	return IRQ_HANDLED;
+}
+
 /**
  * megasas_isr_fusion - isr entry point
  * @irq:	IRQ number
@@ -5367,8 +5373,7 @@ struct megasas_instance_template megasas_instance_template_fusion = {
 	.adp_reset = megasas_adp_reset_fusion,
 	.check_reset = megasas_check_reset_fusion,
 	.service_isr = megasas_isr_fusion,
-	.tasklet = megasas_complete_cmd_dpc_fusion,
+	.service_thr = megasas_complete_cmd_dpc_fusion_irq,
 	.init_adapter = megasas_init_adapter_fusion,
 	.build_and_issue_cmd = megasas_build_and_issue_cmd_fusion,
 	.issue_dcmd = megasas_issue_dcmd_fusion,
--
2.36.1


Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763A6C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A252067C
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="loCQsImr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHQIy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgHQIyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C394C061388;
        Mon, 17 Aug 2020 01:54:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so7378201pjb.2;
        Mon, 17 Aug 2020 01:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yq+b5nPjc4iZMxReL6k7yjDpixSDgaW+QE7HBoO3x5k=;
        b=loCQsImr30+2ucixIdXtUZyrsxcpF9c9ekbfECYqaiqjPXRc1D2R25LSxmM22pxWyU
         X8Zpx7DDyKIexKOQEly53OTTQSi4SPuWNa55LAAofpgDunXjZ0ymnlziD86amt6Ya2Ba
         iG8ecGAB86SnRZndrVePVFVGuxF8qdd1Dt2UHzrm1rG5ZjueLEkZZn9Aggnw3/M+rwbm
         nFw7IjkjVF9S+Ykiw8Verw6GhxQYJshZGNs4of9Xf6ve+DKzbSiXN4cuurHkXaPL171o
         USZ1jmPQLZ8cImyN2plZOFXqBAUd0Jc9lca+jZ7MqQ8k25vVEecxfJlEGNgzGFX7uTip
         h/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yq+b5nPjc4iZMxReL6k7yjDpixSDgaW+QE7HBoO3x5k=;
        b=RXXkOeJKRBvJ8MzweQC70lGHo7yKXi58oc0Qazj2bGM4DbYjxqvJs01qEMabc3Di6/
         WTlOCHOqoGOEJAEAGPZ0HmCemj8G4qjuZIvUe/t4rV2iZsKsC2X8CL1mgWiRqfRH9x6B
         OPXBOrgpgPw0LtRoAISMrwBZ+NaG3q5NSstI2DNHmHOcpdzgFGBndgjVeV9s3/t0ZM3B
         gxp3CGAi515t/g0ynE/yo5fTHqlIYZeA4btiwuoRgRT7AW6d6noGnRntdwh2zB94FZt0
         uCw6kKcqAohqpMgERptzviPK9qGWjMT8vq/p/90tQzMncYv0l3WndQgINVVP9PiUjMRz
         nFTw==
X-Gm-Message-State: AOAM533netJkPO4rPIcVy6HjMzzcBMnNC/yRsFnIlrFBwQLjVfFLZqjW
        VdGcRjEO51V6aQ+lsGifMwM=
X-Google-Smtp-Source: ABdhPJy8TyZl8UDeVE5PjNQnDPaUpnMNoPVRID812Vgnf927pC7NbQzFDhCan7ziLkYRXhbjzmsnXg==
X-Received: by 2002:a17:90a:e292:: with SMTP id d18mr11895790pjz.181.1597654493079;
        Mon, 17 Aug 2020 01:54:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:52 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 5/8] scsi: megaraid: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:06 +0530
Message-Id: <20200817085409.25268-6-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c       |  9 ++++-----
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 +++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++++++-------
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 19469a2c0ea3..47b2d8045c9d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -119,7 +119,7 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 
 static irqreturn_t megaraid_isr(int, void *);
 
-static void megaraid_mbox_dpc(unsigned long);
+static void megaraid_mbox_dpc(struct tasklet_struct *t);
 
 static ssize_t megaraid_sysfs_show_app_hndl(struct device *, struct device_attribute *attr, char *);
 static ssize_t megaraid_sysfs_show_ldnum(struct device *, struct device_attribute *attr, char *);
@@ -878,8 +878,7 @@ megaraid_init_mbox(adapter_t *adapter)
 	}
 
 	// setup tasklet for DPC
-	tasklet_init(&adapter->dpc_h, megaraid_mbox_dpc,
-			(unsigned long)adapter);
+	tasklet_setup(&adapter->dpc_h, megaraid_mbox_dpc);
 
 	con_log(CL_DLEVEL1, (KERN_INFO
 		"megaraid mbox hba successfully initialized\n"));
@@ -2168,9 +2167,9 @@ megaraid_isr(int irq, void *devp)
  * it is being called.
  */
 static void
-megaraid_mbox_dpc(unsigned long devp)
+megaraid_mbox_dpc(struct tasklet_struct *t)
 {
-	adapter_t		*adapter = (adapter_t *)devp;
+	adapter_t		*adapter = from_tasklet(adapter, t, dpc_h);
 	mraid_device_t		*raid_dev;
 	struct list_head	clist;
 	struct scatterlist	*sgl;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5e4137f10e0e..ce361b2b9f14 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2531,7 +2531,7 @@ struct megasas_instance_template {
 	int (*check_reset)(struct megasas_instance *, \
 		struct megasas_register_set __iomem *);
 	irqreturn_t (*service_isr)(int irq, void *devp);
-	void (*tasklet)(unsigned long);
+	void (*tasklet)(struct tasklet_struct *t);
 	u32 (*init_adapter)(struct megasas_instance *);
 	u32 (*build_and_issue_cmd) (struct megasas_instance *,
 				    struct scsi_cmnd *);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 861f7140f52e..dba60cc1cf41 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -217,7 +217,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance);
 u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
-static void megasas_complete_cmd_dpc(unsigned long instance_addr);
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	int seconds);
@@ -2217,14 +2217,14 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
  *
  * Tasklet to complete cmds
  */
-static void megasas_complete_cmd_dpc(unsigned long instance_addr)
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t)
 {
 	u32 producer;
 	u32 consumer;
 	u32 context;
 	struct megasas_cmd *cmd;
-	struct megasas_instance *instance =
-				(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t,
+							 isr_tasklet);
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
@@ -2769,7 +2769,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
 			 */
-			megasas_complete_cmd_dpc((unsigned long)instance);
+			megasas_complete_cmd_dpc(&instance->isr_tasklet);
 		}
 
 		msleep(1000);
@@ -6180,8 +6180,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	dev_info(&instance->pdev->dev,
 		"RDPQ mode\t: (%s)\n", instance->is_rdpq ? "enabled" : "disabled");
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	/*
 	 * Below are default value for legacy Firmware.
@@ -7719,8 +7718,7 @@ megasas_resume(struct pci_dev *pdev)
 	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
 		goto fail_init_mfi;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		     (unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	if (instance->msix_vectors ?
 			megasas_setup_irqs_msix(instance, 0) :
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0824410f78f8..67b07660971a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3705,15 +3705,15 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 
 /**
  * megasas_complete_cmd_dpc_fusion -	Completes command
- * @instance_addr:			Adapter soft state address
+ * @t:	Instance of the tasklet being run
  *
  * Tasklet to complete cmds
  */
 static void
-megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+megasas_complete_cmd_dpc_fusion(struct tasklet_struct *t)
 {
-	struct megasas_instance *instance =
-		(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t,
+							 isr_tasklet);
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -4062,7 +4062,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	if (reason == MFI_IO_TIMEOUT_OCR) {
 		dev_info(&instance->pdev->dev,
 			"MFI command is timed out\n");
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		if (instance->snapdump_wait_time)
 			megasas_trigger_snap_dump(instance);
 		retval = 1;
@@ -4078,7 +4078,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				   "FW in FAULT state Fault code:0x%x subcode:0x%x func:%s\n",
 				   abs_state & MFI_STATE_FAULT_CODE,
 				   abs_state & MFI_STATE_FAULT_SUBCODE, __func__);
-			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+			megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 			if (instance->requestorId && reason) {
 				dev_warn(&instance->pdev->dev, "SR-IOV Found FW in FAULT"
 				" state while polling during"
@@ -4122,7 +4122,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			}
 		}
 
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		outstanding = atomic_read(&instance->fw_outstanding);
 		if (!outstanding)
 			goto out;
-- 
2.17.1


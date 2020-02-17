Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F63C7619F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 11:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5F9207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 11:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="V8SQMpo2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgBQL4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 06:56:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46749 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgBQL4D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 06:56:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so19340204wrl.13
        for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2020 03:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yF0P9wDxyFWDFuyJ5CtBgV3diKtXFyslbtY9psnK0LM=;
        b=V8SQMpo2eclZjR9LBzjkmAr9QgyvUq9cnj3YHXiz599PoZezOcm2hw5883FJZ9rhQf
         zpfYT+1kTharVfTa6qL0kWbtiN7huH/QXYPcAySH1ZeHaq+qcRxEHmC0YN1cqvrQqb8b
         XWG1QGvclRgimZ95gZlxPlBix6V44Rk3rcDxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yF0P9wDxyFWDFuyJ5CtBgV3diKtXFyslbtY9psnK0LM=;
        b=nukgzJNRu5KIrXfokSmZjzsZRYz6l1mrzdaztl8eIxWZKGq7O9bICujG404LICeGxt
         dLBhxBpT6ULs/zby6vmzOE5pKq609WpU1Ao1eLCmjyIBJ72373bJW1wpUaFy1qe6xhvw
         8HaDq13KGXd/bnCqauO8vkDsbfTOjdAu9aOp4woDzOxjOseiGS/jG7qpjITTQ6rRwsNC
         znP7JOx7uZrYHkdD71Pm6T1KRviuuys8JGVR8QhGp8dRluoYFefUryV+e7K31vncIq/r
         1POfp3hOEhEaL+UfVwZrd9Q5DtFOjP52XNOC1LNahn8vmcItjV5AKS5wM+VaqGhV2xD3
         Em5g==
X-Gm-Message-State: APjAAAV3CQLbIZIEVpC9JkWTRRzdMMJLdu+9TMYZNpkMFk0+qmEYfD5B
        0xKf+S+dms3ZYtZqSJ7mTUs9Ga+AA6diKRUy4+e6TlfZqVwXZnDs0P2tzu7l3twOKFkhZ8q86yY
        wA8wQdpWGR2UkMk303iZkyrkAu3joQSewI0AZQDy4ZrkkBTfNj6c0BQ/NJtNB7n860NkABKfOvU
        /atXo=
X-Google-Smtp-Source: APXvYqwvB/G/591E88LlaJ8rJ1vacGNNqk7G2bihkjdczRBIXXtaS1eoQCoc0h4o5nfYq0e5OkOgMg==
X-Received: by 2002:adf:fe83:: with SMTP id l3mr22762418wrr.41.1581940559503;
        Mon, 17 Feb 2020 03:55:59 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i4sm311571wmd.23.2020.02.17.03.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 03:55:58 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kbusch@kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
        linux-nvme@lists.infradead.org, ming.lei@redhat.com,
        sumanesh.samanta@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [RFC PATCH] megaraid_sas : threaded irq hybrid polling
Date:   Mon, 17 Feb 2020 17:25:33 +0530
Message-Id: <1581940533-13795-1-git-send-email-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

High performance HBAs under scsi layer can reach more than 3.0M IOPs.
MegaRaid Aero controller can achieve to 3.3M IOPs.In future there may be requirement to reach 6.0+ M IOPs.
One of the key bottlenecks is serving interrupts for each IO completion.
Block layer has interface blk_poll which can be used as zero interrupt poll queue.
Extending blk_poll to scsi mid layer helps and I was able to get max IOPs same as nvme <poll_queues> interface.

blk_poll is currently merged with io_uring interface and it requires application change to adopt blk_poll.

This RFC covers the logic of handling irq polling in driver using threaded ISR interface.
Changes in this RFC is described as below -

- Use Threaded ISR interface.
- Primary ISR handler runs from h/w interrupt context.
- Secondary ISR handler runs from thread context.
- Driver will drain reply queue from Primary ISR handler for every interrupt it receives.
- Primary handler will decide to call Secondary handler or not.
  This interface can be optimized later, if driver or block layer keep submission and completion stats per each h/w queue.
  Current megaraid_sas driver is single h/w queue based, so I have picked below decision maker.
  If per scsi device has outstanding command more than 8, mark that msix index as “attempt_irq_poll”.
- Every time secondary ISR handler runs, primary handler will disable IRQ.
  Once secondary handler completes the task, it will re-enable IRQ.
  If there is no completion, let's wait for some time and retry polling as enable/disable irq is expensive operation.
  Without this wait in threaded IRQ polling, we will not allow submitter to use CPU and pump more IO.

NVME driver is also trying something similar to reduce ISR overhead.
Discussion started in Dec-2019.
https://lore.kernel.org/linux-nvme/20191209175622.1964-1-kbusch@kernel.org/


Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---

 drivers/scsi/megaraid/megaraid_sas.h        |  3 ++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 11 +++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 73 +++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 83d8c4c..f4f898a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2212,6 +2212,7 @@ struct megasas_irq_context {
 	struct irq_poll irqpoll;
 	bool irq_poll_scheduled;
 	bool irq_line_enable;
+	bool attempt_irq_poll;
 };
 
 struct MR_DRV_SYSTEM_INFO {
@@ -2709,4 +2710,6 @@ int megasas_adp_reset_wait_for_ready(struct megasas_instance *instance,
 				     int ocr_context);
 int megasas_irqpoll(struct irq_poll *irqpoll, int budget);
 void megasas_dump_fusion_io(struct scsi_cmnd *scmd);
+irqreturn_t megasas_irq_check_fusion(int irq, void *devp);
+irqreturn_t megasas_irq_fusion_thread(int irq, void *devp);
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index fd4b5ac..6120bd0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5585,7 +5585,7 @@ megasas_setup_irqs_ioapic(struct megasas_instance *instance)
 static int
 megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 {
-	int i, j;
+	int i, j, ret;
 	struct pci_dev *pdev;
 
 	pdev = instance->pdev;
@@ -5596,9 +5596,12 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 		instance->irq_context[i].MSIxIndex = i;
 		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%u",
 			"megasas", instance->host->host_no, i);
-		if (request_irq(pci_irq_vector(pdev, i),
-			instance->instancet->service_isr, 0, instance->irq_context[i].name,
-			&instance->irq_context[i])) {
+		ret = request_threaded_irq(pci_irq_vector(pdev, i), 
+				megasas_irq_check_fusion,
+				megasas_irq_fusion_thread, IRQF_ONESHOT ,
+				instance->irq_context[i].name, 
+				&instance->irq_context[i]);
+		if (ret) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
 			for (j = 0; j < i; j++)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f3b36fd..5000c36 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -371,6 +371,7 @@ megasas_get_msix_index(struct megasas_instance *instance,
 		       struct megasas_cmd_fusion *cmd,
 		       u8 data_arms)
 {
+	struct megasas_irq_context *irq_ctx;
 	int sdev_busy;
 
 	/* nr_hw_queue = 1 for MegaRAID */
@@ -391,6 +392,12 @@ megasas_get_msix_index(struct megasas_instance *instance,
 	else
 		cmd->request_desc->SCSIIO.MSIxIndex =
 			instance->reply_map[raw_smp_processor_id()];
+	
+	irq_ctx = &instance->irq_context[cmd->request_desc->SCSIIO.MSIxIndex];
+
+	/* More outstanding IOs, so let's attempt polling on this reply queue.*/	
+	if (sdev_busy > data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)
+		irq_ctx->attempt_irq_poll = true;
 }
 
 /**
@@ -2754,6 +2761,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	u16 ld;
 	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0;
 	u32 scsi_buff_len;
+	struct megasas_irq_context *irq_ctx;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	struct IO_REQUEST_INFO io_info;
 	struct fusion_context *fusion;
@@ -3101,6 +3109,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	u16 pd_index = 0;
 	u16 os_timeout_value;
 	u16 timeout_limit;
+	struct megasas_irq_context *irq_ctx;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct RAID_CONTEXT	*pRAID_Context;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
@@ -3817,6 +3826,70 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 			? IRQ_HANDLED : IRQ_NONE;
 }
 
+/*
+ * megasas_irq_fusion_thread: 
+ */
+irqreturn_t megasas_irq_fusion_thread(int irq, void *devp)
+{
+	int total_count = 0, num_completed = 0;
+	struct megasas_irq_context *irq_context = devp;
+	struct megasas_instance *instance = irq_context->instance;
+
+	do {	
+		num_completed = complete_cmd_fusion(instance, irq_context->MSIxIndex, irq_context);
+
+		/* If there is no completion, let's sleep and poll once again
+		 * since enable/disable irq is expensive operation.
+		 * It will not help polling without any sleep since submission and 
+		 * completion happens on the same cpu.
+		 * Polling in tight loop blocks activity on submission.  
+		 */
+		if (!num_completed) {
+			usleep_range(2, 20);
+			num_completed = complete_cmd_fusion(instance, irq_context->MSIxIndex, irq_context);
+		}
+
+		total_count += num_completed;
+	} while (num_completed && total_count < instance->cur_can_queue);
+	
+	irq_context->attempt_irq_poll = false;
+	enable_irq(irq_context->os_irq);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * megasas_irq_check_fusion: 
+ *
+ * For threaded interrupts, this handler will be called and its job is to 
+ * complete command in first attempt before it calls threaded isr handler.
+ *
+ * Threaded ISR handler will be called if there is a prediction of more
+ * completion pending. 
+ */
+irqreturn_t megasas_irq_check_fusion(int irq, void *devp)
+{
+	irqreturn_t ret;
+	struct megasas_irq_context *irq_context = devp;
+	struct megasas_instance *instance = irq_context->instance;
+
+	if (instance->mask_interrupts)
+		return IRQ_NONE;
+
+	/* First attempt from primary handler */
+	ret = megasas_isr_fusion(irq, devp);
+
+	/* Primary handler predict more IO in completion queue,
+ 	 * so let's use threaded irq poll.
+ 	 */	
+	if (!irq_context->attempt_irq_poll)
+		return IRQ_HANDLED;
+
+	disable_irq_nosync(irq_context->os_irq);
+	return IRQ_WAKE_THREAD;
+}
+
+
 /**
  * build_mpt_mfi_pass_thru - builds a cmd fo MFI Pass thru
  * @instance:			Adapter soft state
-- 
2.9.5


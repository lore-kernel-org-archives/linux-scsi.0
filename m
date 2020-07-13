Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89009C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693CA20702
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NjKr/QMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgGMIAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgGMIAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3672EC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:23 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so12352772wmj.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5nB3Mt8dSammYcSx/DeGO6fJUxNEtSbs7LNv2ZUITw=;
        b=NjKr/QMsSjWfSO/JOmYC84C++guFd+WrL/eGfj3JVVdCNTjdwTfdKFL9YTmY/5SHUy
         KCO/MIRUrzZ1BEGCsbfhP1qRr2N7nVLGi/R+2ygcqF1CR5w08/8Jf653kIwLuqYfeTn7
         U/3BIeOrHfhHjCz11ZZZIBa6v+H/yDoLElJQ7G9rCSBP+JtRs2PyLBIMVPJg5yZ1Da5A
         N9iztupbtEz54GTddfIoqpuVn3/rgSg1qF3rIxLUnMxnYjfybObBUNCMSOvL2XMgSlcq
         EwpQZ5T2VpxX+JfNHLNyqfwUfQasb4LrLq2ZyRebBAdEAbgVs7IslxW2KlrNnLNpYKvU
         Vkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5nB3Mt8dSammYcSx/DeGO6fJUxNEtSbs7LNv2ZUITw=;
        b=BlxLr5jIZKDYtN1GT78YKv0AzrwcYU6DgOKPijXQmUfXRz/6u/dFQ0jHXkWatgW1n2
         mxtTXRZolI+IBhVUEiMQ3i0eK/sZvHitNfyqS6lUIO3oDW9/A6G3KHRlWKiwf6S08IaM
         UX6MA6m66c3vy8xD14XJJl9krc8sLBy6drTFC+nS6ZqzNxbt05uDjfvQmBR+PBybr/rg
         BOwNA9D7Tw/SayUB6CAw60gUYS4A5MFLQg5WpE/LNBkVNVaeS5AkwSl3VoEZ+BP01Jo7
         5Bijp9xflyfI841fE1KhiJHJGaZ+L+bT8DR1Cxu8QcftxgZHbzi+2UDntmG63XQm57dm
         zQiA==
X-Gm-Message-State: AOAM533psJWsbU02xiHNYgn9+YNV7eWMGTWY1Cev19EKewDF8H+qxsxF
        LFWvHvNKOMcr0NNOi2YQl72mnQ==
X-Google-Smtp-Source: ABdhPJwdUokMvqL7sikcMv8bqMd5aZXm73mSqk4KvPAjc+r5Fjyx6Saf9GETthw87muoS4x2d3OhJA==
X-Received: by 2002:a1c:a589:: with SMTP id o131mr16640575wme.12.1594627221961;
        Mon, 13 Jul 2020 01:00:21 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Brian King <brking@us.ibm.com>
Subject: [PATCH v2 13/24] scsi: ipr: Remove a bunch of set but checked variables
Date:   Mon, 13 Jul 2020 08:59:50 +0100
Message-Id: <20200713080001.128044-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

In file included from  drivers/scsi/ipr.c:73:
 drivers/scsi/ipr.c: In function ‘ipr_mask_and_clear_interrupts’:
 drivers/scsi/ipr.c:740:15: warning: variable ‘int_reg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/ipr.c: In function ‘ipr_cancel_op’:
 drivers/scsi/ipr.c:5497:13: warning: variable ‘int_reg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/ipr.c: In function ‘ipr_iopoll’:
 drivers/scsi/ipr.c:5765:22: warning: variable ‘ioa_cfg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/ipr.c: In function ‘ipr_reset_restore_cfg_space’:
 drivers/scsi/ipr.c:8662:6: warning: variable ‘int_reg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/ipr.c: In function ‘ipr_test_msi’:

Cc: Brian King <brking@us.ibm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ipr.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f85020904099e..b0aa58d117cc9 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -738,7 +738,6 @@ struct ipr_cmnd *ipr_get_free_ipr_cmnd(struct ipr_ioa_cfg *ioa_cfg)
 static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 					  u32 clr_ints)
 {
-	volatile u32 int_reg;
 	int i;
 
 	/* Stop new interrupts */
@@ -758,7 +757,7 @@ static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 	if (ioa_cfg->sis64)
 		writel(~0, ioa_cfg->regs.clr_interrupt_reg);
 	writel(clr_ints, ioa_cfg->regs.clr_interrupt_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	readl(ioa_cfg->regs.sense_interrupt_reg);
 }
 
 /**
@@ -5510,7 +5509,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	struct ipr_cmd_pkt *cmd_pkt;
-	u32 ioasc, int_reg;
+	u32 ioasc;
 	int i, op_found = 0;
 	struct ipr_hrr_queue *hrrq;
 
@@ -5533,7 +5532,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 	 * by a still not detected EEH error. In such cases, reading a register will
 	 * trigger the EEH recovery infrastructure.
 	 */
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	readl(ioa_cfg->regs.sense_interrupt_reg);
 
 	if (!ipr_is_gscsi(res))
 		return FAILED;
@@ -5780,7 +5779,6 @@ static int ipr_process_hrrq(struct ipr_hrr_queue *hrr_queue, int budget,
 
 static int ipr_iopoll(struct irq_poll *iop, int budget)
 {
-	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_hrr_queue *hrrq;
 	struct ipr_cmnd *ipr_cmd, *temp;
 	unsigned long hrrq_flags;
@@ -5788,7 +5786,6 @@ static int ipr_iopoll(struct irq_poll *iop, int budget)
 	LIST_HEAD(doneq);
 
 	hrrq = container_of(iop, struct ipr_hrr_queue, iopoll);
-	ioa_cfg = hrrq->ioa_cfg;
 
 	spin_lock_irqsave(hrrq->lock, hrrq_flags);
 	completed_ops = ipr_process_hrrq(hrrq, budget, &doneq);
@@ -8681,7 +8678,6 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	u32 int_reg;
 
 	ENTER;
 	ioa_cfg->pdev->state_saved = true;
@@ -8697,7 +8693,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 	if (ioa_cfg->sis64) {
 		/* Set the adapter to the correct endian mode. */
 		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
-		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
+		readl(ioa_cfg->regs.endian_swap_reg);
 	}
 
 	if (ioa_cfg->ioa_unit_checked) {
@@ -10120,7 +10116,6 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
 static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 {
 	int rc;
-	volatile u32 int_reg;
 	unsigned long lock_flags = 0;
 	int irq = pci_irq_vector(pdev, 0);
 
@@ -10131,7 +10126,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	ioa_cfg->msi_received = 0;
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.clr_interrupt_mask_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	rc = request_irq(irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
@@ -10142,7 +10137,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 		dev_info(&pdev->dev, "IRQ assigned: %d\n", irq);
 
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.sense_interrupt_reg32);
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	readl(ioa_cfg->regs.sense_interrupt_reg);
 	wait_event_timeout(ioa_cfg->msi_wait_q, ioa_cfg->msi_received, HZ);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
-- 
2.25.1


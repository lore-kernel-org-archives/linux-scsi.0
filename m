Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7ECBC4742C
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 00:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8053B2224D
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 00:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nyh/KyKo";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nyh/KyKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKNAUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgKNAUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2020 19:20:16 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9518BC0613D1;
        Fri, 13 Nov 2020 16:20:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6077412802B1;
        Fri, 13 Nov 2020 16:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1605313214;
        bh=hCiFpbtu4tRe/21UE+k4vBaDJWTKnUi1s/8pkffq9H0=;
        h=Message-ID:Subject:From:To:Date:From;
        b=nyh/KyKoBEGTNQgn7iCO5JCYecxuFRZFN0XH9SF4MawxqB3HtsMr4O0xRbYf+6BcG
         RDe8VMEbGfsbV9Pe8hGjBWV0kX/MVZhdW17XSSEpIxfwaH3+3scMW35nIGscNf1d3s
         4nToU/tpCARp8zUG7056LkLmOhzUtNYG+fa40H98=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D6g80Y8BxA6x; Fri, 13 Nov 2020 16:20:14 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0FB06128029E;
        Fri, 13 Nov 2020 16:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1605313214;
        bh=hCiFpbtu4tRe/21UE+k4vBaDJWTKnUi1s/8pkffq9H0=;
        h=Message-ID:Subject:From:To:Date:From;
        b=nyh/KyKoBEGTNQgn7iCO5JCYecxuFRZFN0XH9SF4MawxqB3HtsMr4O0xRbYf+6BcG
         RDe8VMEbGfsbV9Pe8hGjBWV0kX/MVZhdW17XSSEpIxfwaH3+3scMW35nIGscNf1d3s
         4nToU/tpCARp8zUG7056LkLmOhzUtNYG+fa40H98=
Message-ID: <595dbda885e4d8f0666fe49aaf52a54f2b0c8c73.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 13 Nov 2020 16:20:13 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three small fixes, all in the embedded ufs driver subsystem.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (2):
      scsi: ufs: Try to save power mode change and UIC cmd completion timeout
      scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()

Qinglang Miao (1):
      scsi: ufshcd: Fix missing destroy_workqueue()

And the diffstat:

 drivers/scsi/ufs/ufshcd.c | 34 +++++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 31 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..7a160b86adc6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1627,12 +1627,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		fallthrough;
 	case CLKS_OFF:
-		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		queue_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.ungate_work);
+		if (queue_work(hba->clk_gating.clk_gating_workq,
+			       &hba->clk_gating.ungate_work))
+			ufshcd_scsi_block_requests(hba);
 		/*
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
@@ -2115,10 +2115,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	unsigned long flags;
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
+					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
-	else
+	} else {
 		ret = -ETIMEDOUT;
+		dev_err(hba->dev,
+			"uic cmd 0x%x with arg3 0x%x completion timeout\n",
+			uic_cmd->command, uic_cmd->argument3);
+
+		if (!uic_cmd->cmd_active) {
+			dev_err(hba->dev, "%s: UIC cmd has been completed, return the result\n",
+				__func__);
+			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
+		}
+	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
@@ -2150,6 +2160,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 	if (completion)
 		init_completion(&uic_cmd->done);
 
+	uic_cmd->cmd_active = 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
 
 	return 0;
@@ -3807,10 +3818,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
+
+		if (!cmd->cmd_active) {
+			dev_err(hba->dev, "%s: Power Mode Change operation has been completed, go check UPMCRS\n",
+				__func__);
+			goto check_upmcrs;
+		}
+
 		ret = -ETIMEDOUT;
 		goto out;
 	}
 
+check_upmcrs:
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
@@ -4902,11 +4921,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 			ufshcd_get_uic_cmd_result(hba);
 		hba->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
+		if (!hba->uic_async_done)
+			hba->active_uic_cmd->cmd_active = 0;
 		complete(&hba->active_uic_cmd->done);
 		retval = IRQ_HANDLED;
 	}
 
 	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
+		hba->active_uic_cmd->cmd_active = 0;
 		complete(hba->uic_async_done);
 		retval = IRQ_HANDLED;
 	}
@@ -8906,6 +8928,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
+	destroy_workqueue(hba->eh_wq);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -9206,6 +9229,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 exit_gating:
 	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
+	destroy_workqueue(hba->eh_wq);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 47eb1430274c..e0f00a42371c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -64,6 +64,7 @@ enum dev_cmd_type {
  * @argument1: UIC command argument 1
  * @argument2: UIC command argument 2
  * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding
  * @done: UIC command completion
  */
 struct uic_command {
@@ -71,6 +72,7 @@ struct uic_command {
 	u32 argument1;
 	u32 argument2;
 	u32 argument3;
+	int cmd_active;
 	struct completion done;
 };
 


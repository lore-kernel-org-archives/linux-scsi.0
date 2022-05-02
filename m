Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED951C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387805AbiEBWEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387776AbiEBWDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0938F261E
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9D97A1F74A;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UouVL6NHMD7jslsWPvTjzgbNmTH0cJ9J/Qvv7QZUAfQ=;
        b=EYyHJ2M05LTHg4Wcj6tAZbsWbJFVfJigtFnD9Px15BNsWcHMuM6fEq6NwFwBp79UMNpHtK
        GXP9+v9Rhte8/XvfU7um15FaQuHbJkVSOhod+L2gcETnGGDxYRlA108uJs55qYA7o4WYSl
        ya/XAeo7DrHnFWxEb6pOcGKhNTmb0I8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UouVL6NHMD7jslsWPvTjzgbNmTH0cJ9J/Qvv7QZUAfQ=;
        b=/f605gozQl19juDVg8aV8rBRPfJdC5ZwcxhqoVJ29Q1uADgaBm36wyU4k9n+6A4bWcGfcL
        sq/MCoYF+qEyfcBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9544F2C149;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9185F5194148; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 02/11] sym53c8xx_2: rework reset handling
Date:   Mon,  2 May 2022 23:59:39 +0200
Message-Id: <20220502215953.5463-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split off the combined abort and device reset handling into
distinct functions.
And the current device reset handler really is a target reset,
so rename it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 82 +++++++++++++++++++----------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 9166af69bbb4..cb8885eb5a5b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -564,7 +564,10 @@ static void sym53c8xx_timer(struct timer_list *t)
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
-static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
+/*
+ * Error handlers called from the eh thread (one thread per HBA).
+ */
+static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
 	struct Scsi_Host *shost = cmd->device->host;
@@ -576,7 +579,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	int sts = -1;
 	struct completion eh_done;
 
-	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
+	scmd_printk(KERN_WARNING, cmd, "ABORT operation started\n");
 
 	/*
 	 * Escalate to host reset if the PCI bus went down
@@ -594,19 +597,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		}
 	}
 
-	/* Try to proceed the operation we have been asked for */
-	sts = -1;
-	switch(op) {
-	case SYM_EH_ABORT:
-		sts = sym_abort_scsiio(np, cmd, 1);
-		break;
-	case SYM_EH_DEVICE_RESET:
-		sts = sym_reset_scsi_target(np, cmd->device->id);
-		break;
-	default:
-		break;
-	}
-
+	sts = sym_abort_scsiio(np, cmd, 1);
 	/* On error, restore everything and cross fingers :) */
 	if (sts)
 		cmd_queued = 0;
@@ -623,23 +614,60 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
+	dev_warn(&cmd->device->sdev_gendev, "ABORT operation %s.\n",
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
 }
 
-
-/*
- * Error handlers called from the eh thread (one thread per HBA).
- */
-static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
-}
+	struct scsi_target *starget = scsi_target(cmd->device);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	SYM_QUEHEAD *qp;
+	int sts;
+	struct completion eh_done;
 
-static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
-{
-	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	starget_printk(KERN_WARNING, starget,
+		       "TARGET RESET operation started\n");
+
+	/*
+	 * Escalate to host reset if the PCI bus went down
+	 */
+	if (pci_channel_offline(pdev))
+		return SCSI_FAILED;
+
+	spin_lock_irq(shost->host_lock);
+	sts = sym_reset_scsi_target(np, starget->id);
+	if (!sts) {
+		FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
+			struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb,
+							   link_ccbq);
+			struct scsi_cmnd *cmd = cp->cmd;
+			struct sym_ucmd *ucmd;
+
+			if (!cmd || cmd->device->channel != starget->channel ||
+			    cmd->device->id != starget->id)
+				continue;
+
+			ucmd = SYM_UCMD_PTR(cmd);
+			init_completion(&eh_done);
+			ucmd->eh_done = &eh_done;
+			spin_unlock_irq(shost->host_lock);
+			if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
+				ucmd->eh_done = NULL;
+				sts = -2;
+			}
+			spin_lock_irq(shost->host_lock);
+		}
+	}
+	spin_unlock_irq(shost->host_lock);
+
+	starget_printk(KERN_WARNING, starget, "TARGET RESET operation %s.\n",
+			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
+	return SCSI_SUCCESS;
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
@@ -1660,7 +1688,7 @@ static struct scsi_host_template sym2_template = {
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
-	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
+	.eh_target_reset_handler = sym53c8xx_eh_target_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-- 
2.29.2


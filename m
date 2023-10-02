Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9950DE743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbjJBPoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbjJBPnw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A90D93
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BC2A421872;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxPgedMzxjUPx2jzUy/0DKGY5tsr7s2uH5vzGcskRJ8=;
        b=NaffFDS7MOgsjkfXD7UyaBawIhlqV9rP/gzKv2peQbh0wV5DzQYzLZc1Eeza3adb20gWaw
        THB0Fc13G9Z1WWUfKwObKqq+afW60vrzlXVBffDOud0VXNbr+9w7Vuru0vRDc5oglVrGlD
        XGUp6BbAkRlffA+dS+doDL+owDGawDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxPgedMzxjUPx2jzUy/0DKGY5tsr7s2uH5vzGcskRJ8=;
        b=pX5CbmlJcfpTVYhg7IVncIK+Rl8umQIbcFONIUV1J7dukHTYDXdrgeA+vlGgkr+4SaxJm/
        Wn4hYMtn3M5OUZCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9CB122C15F;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B4BBA51E7553; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/18] sym53c8xx_2: rework reset handling
Date:   Mon,  2 Oct 2023 17:43:24 +0200
Message-Id: <20231002154328.43718-15-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split off the combined abort and device reset handling into
distinct functions. And rename the current device reset handler
into a target reset handler, seeing that it really is a target
reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 82 +++++++++++++++++++----------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 77e6c3a2a94e..a2560cc807d3 100644
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
@@ -1660,7 +1688,7 @@ static const struct scsi_host_template sym2_template = {
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
-	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
+	.eh_target_reset_handler = sym53c8xx_eh_target_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-- 
2.35.3


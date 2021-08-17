Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBDFC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66BE660F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbhHQJRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47546 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239474AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 71A3220024;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2BFk28My2JNIp6T2foNXVrxjFcL7k+sAuDlYqrlhjo=;
        b=RqjbO9eUJ8Tebq7UIOcYoduQLv4GEZ2tJxe347Q5r55Jy+AJxJ//zO5dryxHmaWr6pQtio
        +fV0QpQ8WzuArV791ZXmtL0oL3IEKg3mwZsGDGsHonGEB1UuS5fIs3aKofBclTxUKiEWGn
        5uqZ7hHcjRDrlq5PfajUZoErJcSR9CI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2BFk28My2JNIp6T2foNXVrxjFcL7k+sAuDlYqrlhjo=;
        b=q9ewdiRoXf9EdKwSWKKG9dtFsxcACRM87kqSaSrcuXtKz+8De5YvHNRrrruGVny1qhEAI7
        pmiL6LtGbmb3fWDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 6B99DA3BB0;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 68965518CE9F; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 32/51] sym53c8xx_2: rework reset handling
Date:   Tue, 17 Aug 2021 11:14:37 +0200
Message-Id: <20210817091456.73342-33-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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
index 2e5ab844fe09..3d00afd8cbca 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -567,7 +567,10 @@ static void sym53c8xx_timer(struct timer_list *t)
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
@@ -579,7 +582,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	int sts = -1;
 	struct completion eh_done;
 
-	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
+	scmd_printk(KERN_WARNING, cmd, "ABORT operation started\n");
 
 	/*
 	 * Escalate to host reset if the PCI bus went down
@@ -597,19 +600,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
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
@@ -626,23 +617,60 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
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
 
 static int sym53c8xx_eh_bus_reset_handler(struct Scsi_Host *shost, int channel)
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


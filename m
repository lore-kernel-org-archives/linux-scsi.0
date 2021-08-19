Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17686C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0191161151
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhHSJIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:08:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60242 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbhHSJIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:08:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E9DED21BDD;
        Thu, 19 Aug 2021 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXnMvkw0hihOFWADfDSWmtHiZimH6I6lGU6S4XzOVKU=;
        b=K1GjPK8mSFP2+pgYoJSbU+Ou2bzN1onJFC2iLuFQ0w32siLn4ps45tarNmTDwmRx+LT7Hj
        qszm1EJk1msHjvIW0HEUuL7UivdK7KOyv+8BfEl1647L1IwBLxf+6GeedyVqqPQhUdf2n6
        Jo2rmjuBX6XEU+5dP1BOvfbRZmctKBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXnMvkw0hihOFWADfDSWmtHiZimH6I6lGU6S4XzOVKU=;
        b=/H/ERfLRHNi+EUAUWP0ANv4mm7HnM+Pzn+j5Ar82gNytfhSRt3UotV00SrxaSBVStYx/il
        wC63NIjBC4CBt6BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 29177A3BAB;
        Thu, 19 Aug 2021 09:07:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D58C5518D27B; Thu, 19 Aug 2021 11:07:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 4/4] sym53c8xx_2: rework reset handling
Date:   Thu, 19 Aug 2021 11:07:16 +0200
Message-Id: <20210819090716.94049-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819090716.94049-1-hare@suse.de>
References: <20210819090716.94049-1-hare@suse.de>
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
 drivers/scsi/sym53c8xx_2/sym_glue.c | 86 ++++++++++++++++-------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 817b2584b4aa..8773fbdfd559 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -585,13 +585,12 @@ static int sym_eh_wait_for_commands(struct Scsi_Host *shost)
 }
 
 /*
- *  Generic method for our eh processing.
- *  The 'op' argument tells what we have to do.
+ * Error handlers called from the eh thread (one thread per HBA).
  */
-static int sym_eh_handler(struct Scsi_Host *shost, int op,
-			  char *opname, struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
+	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct sym_hcb *np = sym_data->ncb;
 	SYM_QUEHEAD *qp;
@@ -599,7 +598,7 @@ static int sym_eh_handler(struct Scsi_Host *shost, int op,
 	int sts = -1;
 	struct completion eh_done;
 
-	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
+	scmd_printk(KERN_WARNING, cmd, "ABORT operation started\n");
 
 	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
@@ -611,19 +610,7 @@ static int sym_eh_handler(struct Scsi_Host *shost, int op,
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
@@ -640,35 +627,60 @@ static int sym_eh_handler(struct Scsi_Host *shost, int op,
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
-	struct Scsi_Host *shost = cmd->device->host;
+	struct scsi_target *starget = scsi_target(cmd->device);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	SYM_QUEHEAD *qp;
+	int sts;
+	struct completion eh_done;
 
+	starget_printk(KERN_WARNING, starget,
+		       "TARGET RESET operation started\n");
+
+	/*
+	 * Escalate to host reset if the PCI bus went down
+	 */
 	if (pci_channel_offline(pdev))
-		return FAILED;
-	return sym_eh_handler(shost, SYM_EH_ABORT, "ABORT", cmd);
-}
+		return SCSI_FAILED;
 
-static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *shost = cmd->device->host;
-	struct sym_data *sym_data = shost_priv(shost);
-	struct pci_dev *pdev = sym_data->pdev;
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
 
-	if (pci_channel_offline(pdev))
-		return FAILED;
-	return sym_eh_handler(shost, SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
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
@@ -1699,7 +1711,7 @@ static struct scsi_host_template sym2_template = {
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


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F839C4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82945600CC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhHQJRS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33168 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BCE5121D08;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c47dIEKZmJqzOul7fIkV9q99tYgQbS7A1BMCgn22Rd0=;
        b=hJtsjV7etjpRi9MDaIZtv1DrFQdZ9/80pRMti5N0M2yodc4EJKXlzl+/ITWFYW1uTm6LN3
        kFMy2NPjg4ISggwPICxUxR1mXnHYtqCENm7F4S735+M3tf30KvfmtR62jdYb7vTSZgWVWR
        27eziC4lShxG3A5pXlQzAs9r+XQtfeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c47dIEKZmJqzOul7fIkV9q99tYgQbS7A1BMCgn22Rd0=;
        b=Baw2tmfkGJZ3NhPL4oqvCb2CdJTp1bOtnpteHvGbvzcKIGTyqLBRPqHxp+aoJQGxoW1RxO
        8fV7GPe40vZlXDDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B4EBDA3B94;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A6A5F518CE65; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 03/51] sym53c8xx_2: split off bus reset from host reset
Date:   Tue, 17 Aug 2021 11:14:08 +0200
Message-Id: <20210817091456.73342-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current handler does both, bus reset and host reset.
So split them off into two distinct functions.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 107 +++++++++++++++++-----------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 16b65fc4405c..2042bd132339 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -562,8 +562,6 @@ static void sym53c8xx_timer(struct timer_list *t)
  */
 #define SYM_EH_ABORT		0
 #define SYM_EH_DEVICE_RESET	1
-#define SYM_EH_BUS_RESET	2
-#define SYM_EH_HOST_RESET	3
 
 /*
  *  Generic method for our eh processing.
@@ -583,35 +581,11 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
 	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
 
-	/* We may be in an error condition because the PCI bus
-	 * went down. In this case, we need to wait until the
-	 * PCI bus is reset, the card is reset, and only then
-	 * proceed with the scsi error recovery.  There's no
-	 * point in hurrying; take a leisurely wait.
+	/*
+	 * Escalate to host reset if the PCI bus went down
 	 */
-#define WAIT_FOR_PCI_RECOVERY	35
-	if (pci_channel_offline(pdev)) {
-		int finished_reset = 0;
-		init_completion(&eh_done);
-		spin_lock_irq(shost->host_lock);
-		/* Make sure we didn't race */
-		if (pci_channel_offline(pdev)) {
-			BUG_ON(sym_data->io_reset);
-			sym_data->io_reset = &eh_done;
-		} else {
-			finished_reset = 1;
-		}
-		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			finished_reset = wait_for_completion_timeout
-						(sym_data->io_reset,
-						WAIT_FOR_PCI_RECOVERY*HZ);
-		spin_lock_irq(shost->host_lock);
-		sym_data->io_reset = NULL;
-		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			return SCSI_FAILED;
-	}
+	if (pci_channel_offline(pdev))
+		return SCSI_FAILED;
 
 	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
@@ -632,15 +606,6 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	case SYM_EH_DEVICE_RESET:
 		sts = sym_reset_scsi_target(np, cmd->device->id);
 		break;
-	case SYM_EH_BUS_RESET:
-		sym_reset_scsi_bus(np, 1);
-		sts = 0;
-		break;
-	case SYM_EH_HOST_RESET:
-		sym_reset_scsi_bus(np, 0);
-		sym_start_up(shost, 1);
-		sts = 0;
-		break;
 	default:
 		break;
 	}
@@ -682,12 +647,72 @@ static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+
+	scmd_printk(KERN_WARNING, cmd, "BUS RESET operation started\n");
+
+	/*
+	 * Escalate to host reset if the PCI bus went down
+	 */
+	if (pci_channel_offline(pdev))
+		return SCSI_FAILED;
+
+	spin_lock_irq(shost->host_lock);
+	sym_reset_scsi_bus(np, 1);
+	spin_unlock_irq(shost->host_lock);
+
+	dev_warn(&cmd->device->sdev_gendev, "BUS RESET operation complete.\n");
+	return SCSI_SUCCESS;
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	struct completion eh_done;
+	int finished_reset = 1;
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation started\n");
+
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  There's no
+	 * point in hurrying; take a leisurely wait.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	35
+	if (pci_channel_offline(pdev)) {
+		init_completion(&eh_done);
+		spin_lock_irq(shost->host_lock);
+		/* Make sure we didn't race */
+		if (pci_channel_offline(pdev)) {
+			BUG_ON(sym_data->io_reset);
+			sym_data->io_reset = &eh_done;
+			finished_reset = 0;
+		}
+		spin_unlock_irq(shost->host_lock);
+		if (!finished_reset)
+			finished_reset = wait_for_completion_timeout
+						(sym_data->io_reset,
+						WAIT_FOR_PCI_RECOVERY*HZ);
+		spin_lock_irq(shost->host_lock);
+		sym_data->io_reset = NULL;
+		spin_unlock_irq(shost->host_lock);
+	}
+
+	if (finished_reset) {
+		sym_reset_scsi_bus(np, 0);
+		sym_start_up(shost, 1);
+	}
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation %s.\n",
+			finished_reset==1 ? "complete" : "failed");
+	return finished_reset ? SCSI_SUCCESS : SCSI_FAILED;
 }
 
 /*
-- 
2.29.2


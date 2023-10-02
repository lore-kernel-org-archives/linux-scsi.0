Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746D7E784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbjJBPoA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbjJBPnw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7473B3
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B6A011F85D;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0U4r1E7PfZ01B8aERIX1qFaDuIkSUc1oXPzz28zjDY=;
        b=wAMF2Z/27hBNcXVD0LTGpeLJ+yZiUPxx/irMet3T7Fm8xc8GupQhjMWyBoExmt3Z8cHLDb
        qUOAr5cqtqavwSCdV4oaj0ofZNJVu0yNEdiDnpJOY1LgMgQBD3ZoCy6OCkA6W3GpKU2MM5
        Ru8kc5OSlh2QPrm05l78reqVoZ+O6lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0U4r1E7PfZ01B8aERIX1qFaDuIkSUc1oXPzz28zjDY=;
        b=xEYJGPKTAJld7nqj07/3e6zVowrzshGuPXUgPgIiUxYx/hFcN6UehILL+9NzPn6E+9Rk2b
        eZ/kBuxJOUzqnaDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 94F312C15D;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id AC90751E7551; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 13/18] sym53c8xx_2: split off bus reset from host reset
Date:   Mon,  2 Oct 2023 17:43:23 +0200
Message-Id: <20231002154328.43718-14-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current handler does both, bus reset and host reset.
So split them off into two distinct functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 107 +++++++++++++++++-----------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 17491ba10439..77e6c3a2a94e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -559,8 +559,6 @@ static void sym53c8xx_timer(struct timer_list *t)
  */
 #define SYM_EH_ABORT		0
 #define SYM_EH_DEVICE_RESET	1
-#define SYM_EH_BUS_RESET	2
-#define SYM_EH_HOST_RESET	3
 
 /*
  *  Generic method for our eh processing.
@@ -580,35 +578,11 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
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
@@ -629,15 +603,6 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
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
@@ -679,12 +644,72 @@ static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
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
2.35.3


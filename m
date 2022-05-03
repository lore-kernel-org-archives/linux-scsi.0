Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC6FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbiECULY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiECUKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D6A403CE
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 65F2A2187F;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9/miu49ZnOthLFlwDZkKU8qD9uTCVbYcRBejDMPxXY=;
        b=wiRJIwqBz0n4sLZB0TTp6xV865wBkS2JKcfn8fj6gCeD02z/y/JzwyARma3MfQO68RP4B7
        vx2cOZJArEjIsLpqKXv8MK1eKB4shvUIvG1ZdH6MqH/XdEqv6eP3HvrW58wQYz9V/NCEGo
        1WM+Nn9gM7aB79h7YgwG+JqurpxsW3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9/miu49ZnOthLFlwDZkKU8qD9uTCVbYcRBejDMPxXY=;
        b=OCbP5WJk24AKmy/hAUyh2Y6RYthdDDgu+ggQaXIg4eo16wkOEy92L5Cql4FdbWlTAFf2jk
        AF2k91lHkqJe4rBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4D4372C16E;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 5C8E851941EE; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 20/24] sym53c8xx_2: split off bus reset from host reset
Date:   Tue,  3 May 2022 22:07:00 +0200
Message-Id: <20220503200704.88003-21-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current handler does both, bus reset and host reset.
So split them off into two distinct functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 107 +++++++++++++++++-----------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 2e2852bd5860..9166af69bbb4 100644
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
2.29.2


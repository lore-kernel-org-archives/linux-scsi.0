Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC83C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 122F861131
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhHSJII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:08:08 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36568 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbhHSJIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:08:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DC89F1FD81;
        Thu, 19 Aug 2021 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzVADz+Kf84Em2VIqSo+kGQ/+/AN5K492O7aD2WADc0=;
        b=CBEz2Ryvq55TkvnUCcAYmIYrI7Ix93aJbi0Pp19/HnE6FiCLzXVJSyd7FSicUlfCMdR/SW
        O+qJl5dRGqa4Of0oEwaSQFfmM1CiFwjITeJWcI67Y07QmoVtZJmtbJXyGakZ36hWLOF6bN
        /SlKsmoRhSNwljwqc+MmGnjz0LvuvOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzVADz+Kf84Em2VIqSo+kGQ/+/AN5K492O7aD2WADc0=;
        b=YTBQz2OTgJruAmBIiFGcp32n7l5dBE4nW3tUuba60MSfTYXF/H3nBAPF6eGbuw7GVhBawJ
        BLCKvQlNKsbSluDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1F30AA3BA7;
        Thu, 19 Aug 2021 09:07:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C5B11518D275; Thu, 19 Aug 2021 11:07:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] sym53c8xx_2: move PCI EEH handling to host reset
Date:   Thu, 19 Aug 2021 11:07:13 +0200
Message-Id: <20210819090716.94049-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819090716.94049-1-hare@suse.de>
References: <20210819090716.94049-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When PCI EEH is active the entire card will be reset; which means
that we _have_ to do the equivalent of a eh_host_reset().
So trying to do it from other EH callbacks is pointless, and we
should delegate it to eh_host_reset().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 97 ++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 16b65fc4405c..dafdab5869fa 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -569,12 +569,11 @@ static void sym53c8xx_timer(struct timer_list *t)
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
-static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
+static int sym_eh_handler(struct Scsi_Host *shost, int op,
+			  char *opname, struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
-	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
 	SYM_QUEHEAD *qp;
 	int cmd_queued = 0;
@@ -583,36 +582,6 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
 	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
 
-	/* We may be in an error condition because the PCI bus
-	 * went down. In this case, we need to wait until the
-	 * PCI bus is reset, the card is reset, and only then
-	 * proceed with the scsi error recovery.  There's no
-	 * point in hurrying; take a leisurely wait.
-	 */
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
-
 	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
@@ -672,22 +641,76 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
  */
 static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+
+	if (pci_channel_offline(pdev))
+		return FAILED;
+	return sym_eh_handler(shost, SYM_EH_ABORT, "ABORT", cmd);
 }
 
 static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+
+	if (pci_channel_offline(pdev))
+		return FAILED;
+	return sym_eh_handler(shost, SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+
+	if (pci_channel_offline(pdev))
+		return FAILED;
+	return sym_eh_handler(shost, SYM_EH_BUS_RESET, "BUS RESET", cmd);
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+	struct sym_data *sym_data = shost_priv(shost);
+	struct pci_dev *pdev = sym_data->pdev;
+
+	/* We may be in an error condition because the PCI bus
+	 * went down. In this case, we need to wait until the
+	 * PCI bus is reset, the card is reset, and only then
+	 * proceed with the scsi error recovery.  There's no
+	 * point in hurrying; take a leisurely wait.
+	 */
+#define WAIT_FOR_PCI_RECOVERY	35
+	if (pci_channel_offline(pdev)) {
+		struct completion eh_done;
+		int finished_reset = 0;
+
+		init_completion(&eh_done);
+		spin_lock_irq(shost->host_lock);
+		/* Make sure we didn't race */
+		if (pci_channel_offline(pdev)) {
+			BUG_ON(sym_data->io_reset);
+			sym_data->io_reset = &eh_done;
+		} else {
+			finished_reset = 1;
+		}
+		spin_unlock_irq(shost->host_lock);
+		if (!finished_reset)
+			finished_reset = wait_for_completion_timeout
+						(sym_data->io_reset,
+						WAIT_FOR_PCI_RECOVERY*HZ);
+		spin_lock_irq(shost->host_lock);
+		sym_data->io_reset = NULL;
+		spin_unlock_irq(shost->host_lock);
+		if (!finished_reset)
+			return SCSI_FAILED;
+	}
+
+	return sym_eh_handler(shost, SYM_EH_HOST_RESET, "HOST RESET", cmd);
 }
 
 /*
-- 
2.29.2


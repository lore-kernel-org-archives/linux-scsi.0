Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEC6C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C79EE61158
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhHSJIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:08:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36574 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbhHSJIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:08:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E26FC1FD82;
        Thu, 19 Aug 2021 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1PVoZnm72z63Pj+wvu55uGHBd3Y0RSTl4RzZxajjSY=;
        b=mPGoZi/epaGu6jVxgtmfidGywlkpylEXBfSBbdrNgejx+hRE7pHY8/6sGwga9vl8DM1Wh5
        jvzrViLQsrRcOMz/kBjsIno0oXg056/EL73UjAsmxmrgepFoPfZWpcahS8Uvjdnlb34Dqc
        kjGkqJAEwhbL7tqniiSgZbjHJzVQHz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1PVoZnm72z63Pj+wvu55uGHBd3Y0RSTl4RzZxajjSY=;
        b=Q9fQ3oJDmQMsHXaSnHdDvgEew1Cw2F/EXFSv+pZBN3TNkkyP/2rMZPC84Cw5vaM4Bl0hIS
        M42gGIOAhMf5tgDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 236E7A3BA9;
        Thu, 19 Aug 2021 09:07:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CA50F518D277; Thu, 19 Aug 2021 11:07:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] sym53c8xx_2: split off host reset from sym_eh_handler()
Date:   Thu, 19 Aug 2021 11:07:14 +0200
Message-Id: <20210819090716.94049-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819090716.94049-1-hare@suse.de>
References: <20210819090716.94049-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For host reset we need to wait for all pending command to complete;
there might be more than one command queued and we'll need to wait
for all of them.
So split off the host reset functionality from sym_eh_handler()
and add a wait loop for all commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 42 ++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index dafdab5869fa..86cba915b62d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -563,7 +563,27 @@ static void sym53c8xx_timer(struct timer_list *t)
 #define SYM_EH_ABORT		0
 #define SYM_EH_DEVICE_RESET	1
 #define SYM_EH_BUS_RESET	2
-#define SYM_EH_HOST_RESET	3
+
+static int sym_eh_wait_for_commands(struct Scsi_Host *shost)
+{
+	struct sym_data *sym_data = shost_priv(shost);
+	struct sym_hcb *np = sym_data->ncb;
+	int rval = SUCCESS, count = 10; /* 5 seconds */
+
+	/* Wait for any queued commands to complete */
+	spin_lock_irq(shost->host_lock);
+	while (!sym_que_empty(&np->busy_ccbq)) {
+		if (--count == 0) {
+			rval = FAILED;
+			break;
+		}
+		spin_unlock_irq(shost->host_lock);
+		msleep(500);
+		spin_lock_irq(shost->host_lock);
+	}
+	spin_unlock_irq(shost->host_lock);
+	return rval;
+}
 
 /*
  *  Generic method for our eh processing.
@@ -605,11 +625,6 @@ static int sym_eh_handler(struct Scsi_Host *shost, int op,
 		sym_reset_scsi_bus(np, 1);
 		sts = 0;
 		break;
-	case SYM_EH_HOST_RESET:
-		sym_reset_scsi_bus(np, 0);
-		sym_start_up(shost, 1);
-		sts = 0;
-		break;
 	default:
 		break;
 	}
@@ -677,6 +692,10 @@ static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	int rval = SUCCESS;
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation started\n");
 
 	/* We may be in an error condition because the PCI bus
 	 * went down. In this case, we need to wait until the
@@ -710,7 +729,16 @@ static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 			return SCSI_FAILED;
 	}
 
-	return sym_eh_handler(shost, SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	spin_lock_irq(shost->host_lock);
+	sym_reset_scsi_bus(np, 0);
+	sym_start_up(shost, 1);
+	spin_unlock_irq(shost->host_lock);
+
+	rval = sym_eh_wait_for_commands(shost);
+
+	shost_printk(KERN_WARNING, shost, "HOST RESET operation %s.\n",
+		     rval == SUCCESS ? "complete" : "failed");
+	return rval;
 }
 
 /*
-- 
2.29.2


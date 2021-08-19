Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB66C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B3F6113C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhHSJIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:08:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60248 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbhHSJIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:08:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EC5FC220BD;
        Thu, 19 Aug 2021 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFUnIWTuLS7lVSUfq5t4Rg4TGq+Tdn43GGf7cSylo24=;
        b=xaOYxFPTfcKvFk9DJKcXtgPV9LzPtarZ9IOXyoZk/HJiSQWfVWWKQ5FkE/jT098KCLGmw2
        7GZGNIcauE9CZFvuoVPw9pk8AJIB9W5jF3Nq1IZ5PKN0xu2ARPuaGaAwhasa9BbMzPrvDs
        5fe7rUs+hKkUc5ieKC+LN/b4BPsib5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFUnIWTuLS7lVSUfq5t4Rg4TGq+Tdn43GGf7cSylo24=;
        b=mwQV43pvZYKtbC/moZ0ld+IGIvH3IlQ1wgN4WJyafCNCFSJY6d/0vWaR3mlwivr6vc2098
        CCSIezsoWa6LTlCA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 25C9EA3BAA;
        Thu, 19 Aug 2021 09:07:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CFD15518D279; Thu, 19 Aug 2021 11:07:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] sym53c8xx_2: split off bus reset from sym_eh_handler()
Date:   Thu, 19 Aug 2021 11:07:15 +0200
Message-Id: <20210819090716.94049-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819090716.94049-1-hare@suse.de>
References: <20210819090716.94049-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bus reset is similar to host reset, and we also need to wait for
all commands to complete. So split off bus reset from sym_eh_handler()
and wait for all commands to complete after resetting the SCSI bus.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 86cba915b62d..817b2584b4aa 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -562,7 +562,6 @@ static void sym53c8xx_timer(struct timer_list *t)
  */
 #define SYM_EH_ABORT		0
 #define SYM_EH_DEVICE_RESET	1
-#define SYM_EH_BUS_RESET	2
 
 static int sym_eh_wait_for_commands(struct Scsi_Host *shost)
 {
@@ -621,10 +620,6 @@ static int sym_eh_handler(struct Scsi_Host *shost, int op,
 	case SYM_EH_DEVICE_RESET:
 		sts = sym_reset_scsi_target(np, cmd->device->id);
 		break;
-	case SYM_EH_BUS_RESET:
-		sym_reset_scsi_bus(np, 1);
-		sts = 0;
-		break;
 	default:
 		break;
 	}
@@ -681,10 +676,26 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
+	struct sym_hcb *np = sym_data->ncb;
+	int rval = SUCCESS;
 
 	if (pci_channel_offline(pdev))
 		return FAILED;
-	return sym_eh_handler(shost, SYM_EH_BUS_RESET, "BUS RESET", cmd);
+
+	shost_printk(KERN_WARNING, shost, "BUS RESET operation started\n");
+
+	spin_lock_irq(shost->host_lock);
+	if (sym_reset_scsi_bus(np, 1))
+		rval = FAILED;
+	spin_unlock_irq(shost->host_lock);
+
+	if (rval == SUCCESS)
+		rval = sym_eh_wait_for_commands(shost);
+
+	shost_printk(KERN_WARNING, shost, "BUS RESET operation %s.\n",
+			rval == SUCCESS ? "complete" : "failed");
+
+	return rval;
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
-- 
2.29.2


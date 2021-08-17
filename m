Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8109FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C2C600CC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhHQJRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47406 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C3CDF20012;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SbPNn5B0V1abBkw0dLk1QsNp6q4ID6MbrxsWXBOvtfI=;
        b=wltYdFeSLXpo9JlOfrXWBvSFlYXpcp/hs3xz78bxmAHG+Li3whiKEun0w8Vu6UGThpOM9F
        EsT80E2afTW06lk///rotCOh8FL1dMYbgpicDs9oJMcA0j9dNMwxtSvbIb9VSkOpzFFjve
        k0Cgf+tMpHaP1UgrSr/nIuimCwe5h4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SbPNn5B0V1abBkw0dLk1QsNp6q4ID6MbrxsWXBOvtfI=;
        b=NpYL+t1Eq3xOpVNmfwtJynOEy6Q9UR4+J0+3UihbLamE9OFsdWkuYas2ihh0xMbJKM0Cy7
        JBjy7sdUc5W3hiBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id BCC1DA3B98;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B997F518CE6B; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 06/51] qla1280: separate out host reset function from qla1280_error_action()
Date:   Tue, 17 Aug 2021 11:14:11 +0200
Message-Id: <20210817091456.73342-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's not much in common between host reset and all other error
handlers, so use a separate function here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla1280.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 928da90b79be..3361e24a1b62 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -726,7 +726,6 @@ enum action {
 	ABORT_COMMAND,
 	DEVICE_RESET,
 	BUS_RESET,
-	ADAPTER_RESET,
 };
 
 
@@ -908,22 +907,9 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
 		}
 		break;
 
-	case ADAPTER_RESET:
 	default:
-		if (qla1280_verbose) {
-			printk(KERN_INFO
-			       "scsi(%ld): Issued ADAPTER RESET\n",
-			       ha->host_no);
-			printk(KERN_INFO "scsi(%ld): I/O processing will "
-			       "continue automatically\n", ha->host_no);
-		}
-		ha->flags.reset_active = 1;
-
-		if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
-			result = FAILED;
-		}
-
-		ha->flags.reset_active = 0;
+		dprintk(1, "RESET invalid action %d\n", action);
+		return FAILED;
 	}
 
 	/*
@@ -1022,10 +1008,26 @@ static int
 qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
+	struct Scsi_Host *shost = cmd->device->host;
+	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, ADAPTER_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	if (qla1280_verbose) {
+		printk(KERN_INFO
+		       "scsi(%ld): Issued ADAPTER RESET\n",
+		       ha->host_no);
+		printk(KERN_INFO "scsi(%ld): I/O processing will "
+		       "continue automatically\n", ha->host_no);
+	}
+	ha->flags.reset_active = 1;
+
+	if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
+		rc = FAILED;
+	}
+
+	ha->flags.reset_active = 0;
+
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
-- 
2.29.2


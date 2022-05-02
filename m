Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B913C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387742AbiEBVmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387716AbiEBVmF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889E0E0DB
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BA0621871;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0soejsjk5swgBAFAO+34W4QG9rW5ror2NNGR4/eZ1VI=;
        b=KxEvFAuqxgCE8F1jdzaBgB3rNPzXkFyKu6ql3nj+uKDnGQ8TW7/D/oDNKD2NUavrwa8Oei
        IZ+KnsmSZ7LgVb+tjHrrEYySzoXhhmXMh87bPG6+R3JJ2W44LzxbIyxRS+KJ7P6epWXyWh
        Zozw6ls0qnVPjXJqXUwBagjUoFT2TDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0soejsjk5swgBAFAO+34W4QG9rW5ror2NNGR4/eZ1VI=;
        b=W4bGbFdQI6EQS8s2dWzllld6DLJ34LnJizP8iYJ5oPyNd3t8R7hRkfMQge+0MT8gl8ffTJ
        gJ5KqAMgFxo2l5DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 265882C143;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 23A835194120; Mon,  2 May 2022 23:38:33 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 22/24] qla1280: separate out host reset function from qla1280_error_action()
Date:   Mon,  2 May 2022 23:38:18 +0200
Message-Id: <20220502213820.3187-23-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
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
index 0ab595c0870a..c4466e4e692f 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -716,7 +716,6 @@ enum action {
 	ABORT_COMMAND,
 	DEVICE_RESET,
 	BUS_RESET,
-	ADAPTER_RESET,
 };
 
 
@@ -898,22 +897,9 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
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
@@ -1012,10 +998,26 @@ static int
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


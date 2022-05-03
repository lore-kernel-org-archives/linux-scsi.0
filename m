Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399B5C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiECUL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiECUKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AE72656D
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 70C5B21880;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvhVw/SGY35D1y4zwlfAN3G0hMz0D0jZYefn3xgS5h0=;
        b=tgvVM5qax0xb1hzNlWjhkZoDD38qKBq8U4zALk1a4M0TDLV5LkOB0TwtwLaEA0rrp2DH3D
        FaWusgFxHGbflHqW6Axf/vzbzegtAe0z99swh4y/PuKGneHKX7SIc4MtH70VKgQuY6yBtQ
        2MT1ieDV2A8OH+1BI6Y1ODwZqys/XFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvhVw/SGY35D1y4zwlfAN3G0hMz0D0jZYefn3xgS5h0=;
        b=lX5dEIXdkWPnvrqRMxs2sSfiyP7S+RoQOJtHk1cjvittJ7fD+rnh7a2uQjbf/qCpfKMo5o
        Stt6vDXvQY2sM1Bg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 58F802C171;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6854E51941F2; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/24] qla1280: separate out host reset function from qla1280_error_action()
Date:   Tue,  3 May 2022 22:07:02 +0200
Message-Id: <20220503200704.88003-23-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's not much in common between host reset and all other error
handlers, so use a separate function here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla1280.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 0ab595c0870a..cd1b7d8c6f31 100644
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
@@ -1011,11 +997,27 @@ qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
 static int
 qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 {
-	int rc;
+	int rc = SUCCESS;
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


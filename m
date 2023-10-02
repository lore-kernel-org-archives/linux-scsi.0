Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C84E784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbjJBPoI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbjJBPnw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F0BD
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C608C1F86A;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xskjwynT95EH6gax9fj/3ykbCeIbEUTsdja11nrUKg4=;
        b=EU9bpE2YBVNTl0x0xSghjE+A8LUoSxdKbzr2bdT/wFyXkBrCeo0yUWGNP+HR//p9gBF0/l
        Jg6AAp4F/hFZo1NugF7l8WGlWS/plmh7c9BnSdxXT1Ng0b0FYylvmcsaXN9RI62MpFkJvX
        EDUA/ey4k9X1NTf5HSWUBGIQu4XxT58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xskjwynT95EH6gax9fj/3ykbCeIbEUTsdja11nrUKg4=;
        b=zPy2/pF2Wx4QqsdKhA213ZNpoErCgl927gvJq92HdwraG72z0UvvZrftBXUmzbsmyDoV0m
        LSUxhNUfXBYK8NCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A5E892C161;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BD5A751E7555; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 15/18] qla1280: separate out host reset function from qla1280_error_action()
Date:   Mon,  2 Oct 2023 17:43:25 +0200
Message-Id: <20231002154328.43718-16-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's not much in common between host reset and all other error
handlers, so use a separate function here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/qla1280.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6e5e89aaa283..27bce80262c2 100644
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
2.35.3


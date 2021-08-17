Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F442C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8989360FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhHQJRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47570 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 410792001F;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESQWh2Y2DOmrJhSx6b6KuX/7q2iX56teg3hpJ4YA9pE=;
        b=u/54hoNIvrHmF0zN8WoU8XvdpaaDPkl5Fuq24QGL3AqzCskQwcqVu1Vj8jpuktrEHtckJI
        6P/9FWGJsUItlNcCIFExDT21BP3ETwkQdTxLhWpkxzy/5gl8bDv2JaWl2V2hFNMpEixpk9
        DtZ3BCnpRTW0Jz2TSMgRkYt0b45Nbn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESQWh2Y2DOmrJhSx6b6KuX/7q2iX56teg3hpJ4YA9pE=;
        b=/Ii9VtIbC/Oq2G03pYv9DgjjR3oIF473bU26W0adSBZZL7ygW/YWGaqZmUi900mMRZ3myz
        Ix3+oqHnTPUGbwBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 3ABF5A3BA8;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 37DCC518CE8F; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 24/51] ibmvfc: open-code reset loop for target reset
Date:   Tue, 17 Aug 2021 11:14:29 +0200
Message-Id: <20210817091456.73342-25-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

For target reset we need a device to send the target reset to,
so open-code the loop in target reset to send the target reset TMF
to the correct device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 42 +++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 0a946aad66e5..1a5e2c2cc189 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2909,18 +2909,6 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
 	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
 }
 
-/**
- * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
- * @sdev:	scsi device struct
- * @data:	return code
- *
- **/
-static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
-{
-	unsigned long *rc = data;
-	*rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_TGT_RESET);
-}
-
 /**
  * ibmvfc_eh_target_reset_handler - Reset the target
  * @cmd:	scsi command struct
@@ -2930,22 +2918,38 @@ static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
  **/
 static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct scsi_device *sdev = cmd->device;
-	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	struct scsi_target *starget = scsi_target(sdev);
+	struct scsi_target *starget = scsi_target(cmd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct ibmvfc_host *vhost = shost_priv(shost);
 	int block_rc;
 	int reset_rc = 0;
 	int rc = FAILED;
 	unsigned long cancel_rc = 0;
+	bool tgt_reset = false;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
-		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
-		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
+		struct scsi_device *sdev;
+
+		shost_for_each_device(sdev, shost) {
+			if ((sdev->channel != starget->channel) ||
+			    (sdev->id != starget->id))
+				continue;
+
+			cancel_rc |= ibmvfc_cancel_all(sdev,
+						       IBMVFC_TMF_TGT_RESET);
+			if (!tgt_reset) {
+				reset_rc = ibmvfc_reset_device(sdev,
+					IBMVFC_TARGET_RESET, "target");
+				tgt_reset = true;
+			}
+		}
 	} else
-		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_noreset);
+		starget_for_each_device(starget, &cancel_rc,
+					ibmvfc_dev_cancel_all_noreset);
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
-- 
2.29.2


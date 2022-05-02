Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59C4C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387740AbiEBVmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387717AbiEBVmF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A7E0E9
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EEAB01F74B;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yB1N5HDUweHnsaCtKNjiOaZxhl/QDfvvbQjXcfc9fUQ=;
        b=WnAzlk5OlYkI6Q6FUIudIbfgX5WsnVGDm04coZ4urFmL3RY8AR8hfgoUfoHf+9yQQeh1+k
        n+88G+eNs+TBR8rZALM1F+fkZ6CzGwJ3GvQMEpNVaTLTYpyov+Pz6A/cKQNGuX8FU/qnje
        NObLslW8QlbP1ZCWkDsN5k8VM/ldJzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yB1N5HDUweHnsaCtKNjiOaZxhl/QDfvvbQjXcfc9fUQ=;
        b=buWzhkXy3Bv+jGOTEeHhsO7AbOUZy08a1KUJpmkqplh2+uyzqZNv6fRnoM67RVYqsGg4AE
        YDclzS25+ui7NeAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E91702C152;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E5BD15194106; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 09/24] ibmvfc: open-code reset loop for target reset
Date:   Mon,  2 May 2022 23:38:05 +0200
Message-Id: <20220502213820.3187-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
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
index d0eab5700dc5..721d965f4b0e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2925,18 +2925,6 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
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
@@ -2946,22 +2934,38 @@ static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
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


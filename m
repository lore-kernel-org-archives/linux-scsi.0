Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7F2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiECULK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiECUKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DFC26AC3
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BC7721871;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FDzwj623m4ERVeuC9SXdcTfFCidDKGHCEKdBxQiSFiI=;
        b=Uw3xQ7XzYHYoFei3jC5nXqDB906TcoDVItOGjvorQbBRr3M03+ihpUDnjcdwBGs4FBTopQ
        X/ZZtEfNuvWXtEzQ9WLW7VJHUXqRPpe017b0E0y44UKrfuoUKEVYWfYzk1HHH9XRYIvnM8
        Xp5uWyfS4NlQb8xU/sWGoJO81AxX5N0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FDzwj623m4ERVeuC9SXdcTfFCidDKGHCEKdBxQiSFiI=;
        b=ds2489h91ndJYS4UUKi2P+XONHEhf+M5fiSEQ4kWnq6bgObgyvRjYtCNtX8Frdy1PI2fzA
        S5QREX7ewGEoCSCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 0EF0E2C15B;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 1DEE651941D8; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 09/24] ibmvfc: open-code reset loop for target reset
Date:   Tue,  3 May 2022 22:06:49 +0200
Message-Id: <20220503200704.88003-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For target reset we need a device to send the target reset to,
so open-code the loop in target reset to send the target reset TMF
to the correct device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


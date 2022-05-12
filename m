Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D36C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353084AbiELLNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353039AbiELLM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D9B63521
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5D2761F930;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqdTVzWjiLJjpb7bUhPa6LCa34TWr0guwfSyy9UJc6o=;
        b=UdIVrYP5iQdEJs19GkXvPwUYqBSlVM1iDQDFhYaUJbTbkFQuyzoWPqvJW/BE2WSh1wI7vs
        pMMJgcgObWzvtKNmSgWw+sFVkb4jkX+MkO+nEIS3QJ3j1lobO3d7Uyk+bLZ+840EpqeiWN
        4UrQDk3CPopvWLt4LF8ZiU7tw5ps/QM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqdTVzWjiLJjpb7bUhPa6LCa34TWr0guwfSyy9UJc6o=;
        b=8waA1xEo7LmbpAn7UeZ/mAvUBgW3/qa0XT9ntRlOSQ0604j+H14FdA6Nzk6GvbYwbz+ZzW
        9WUR/3kr6qjw4LDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4CC4F2C14F;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 10B6851943E8; Thu, 12 May 2022 13:12:46 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 08/20] ibmvfc: open-code reset loop for target reset
Date:   Thu, 12 May 2022 13:12:24 +0200
Message-Id: <20220512111236.109851-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220512111236.109851-1-hare@suse.de>
References: <20220512111236.109851-1-hare@suse.de>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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


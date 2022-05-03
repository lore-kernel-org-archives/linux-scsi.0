Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D627C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiECULL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbiECUKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB83F27143
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3263A21877;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9UB9kJ6U1pVAk42Xta6NNAD1V/34OuqVF/7U7UCYBo=;
        b=rnmmuXTgTYE+zzyBZJz5p1JxVQVhm6zr++DTC0HkJoMK4RHHgXqB/de1u72F3AUhjQT+Ye
        xf7h60SUtw2QZgaNjQn068hoBPlz+YHLMO4l21VBDaDmU+61pysPuClaLB9qjyGcdzkGOC
        88Zk8k0ee7SmFrfCA9wkyb/4KxRAnt0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9UB9kJ6U1pVAk42Xta6NNAD1V/34OuqVF/7U7UCYBo=;
        b=XgIgZnxRoVO05WvWWFjI2P75wtjUfPxS4FCnlEkpBkWaQN9Z/29dHqXT2RlIa08BpC+Qyk
        E8g58/wqMZN52rAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 125212C15D;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2133F51941DA; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 10/24] ibmvfc: use fc_block_rport()
Date:   Tue,  3 May 2022 22:06:50 +0200
Message-Id: <20220503200704.88003-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
will be deprecated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 721d965f4b0e..2e7128f0d905 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2857,12 +2857,13 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
@@ -2890,12 +2891,13 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
-- 
2.29.2


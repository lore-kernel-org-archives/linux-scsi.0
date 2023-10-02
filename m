Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C83E748E9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbjJBPts (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbjJBPtj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A82BCE
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D1CA421871;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yw7ecjbeA43kaVmuPNe+9ZVUm6zeAaOKO49YzPA6pW4=;
        b=pWDIQpyYBD+Wkxxbd4JKdU8CohJAgKK8v6M79Bl4FSfTnqGOVbKh16My/gYL1YzoSRK6ba
        Nqyt5UvaYZHNCnf1UFTr8llttBIZsafzTIiQjalDjpgTkdBDABCPi+NTorzxgopPrpEceS
        DkXS7+aYOPKT0jSlZjK+rRghDd7H+EM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yw7ecjbeA43kaVmuPNe+9ZVUm6zeAaOKO49YzPA6pW4=;
        b=IUVvx+e+uRKyblbJYp0Lfjr58yvu11C2xletoKqiS1++3sewcXeshX41OE3FL05TIdDSN/
        +8UHPc9viaftYjDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B2F182C14F;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CADB551E756B; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/15] xen-scsifront: rework scsifront_action_handler()
Date:   Mon,  2 Oct 2023 17:49:19 +0200
Message-Id: <20231002154927.68643-8-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework scsifront_action_handler() to add the SCSI device as the
first argument, and select between abort and device reset by
checking whether the scsi_cmnd argument is NULL.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/xen-scsifront.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index a0c13200d53a..26dd229aeb22 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -668,11 +668,11 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
  * We have to wait until an answer is returned. This answer contains the
  * result to be returned to the requestor.
  */
-static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+static int scsifront_action_handler(struct scsi_device *sdev, struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct vscsifrnt_info *info = shost_priv(host);
-	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
+	struct vscsifrnt_shadow *shadow;
 	int err = 0;
 
 	if (info->host_active == STATE_ERROR)
@@ -682,10 +682,14 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	if (!shadow)
 		return FAILED;
 
-	shadow->act = act;
+	shadow->act = sc ? VSCSIIF_ACT_SCSI_ABORT : VSCSIIF_ACT_SCSI_RESET;
 	shadow->rslt_reset = RSLT_RESET_WAITING;
 	shadow->sc = sc;
-	shadow->ref_rqid = s->rqid;
+	if (sc) {
+		struct vscsifrnt_shadow *s = scsi_cmd_priv(sc);
+
+		shadow->ref_rqid = s->rqid;
+	}
 	init_waitqueue_head(&shadow->wq_reset);
 
 	spin_lock_irq(host->host_lock);
@@ -735,13 +739,13 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+	return scsifront_action_handler(sc->device, sc);
 }
 
 static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+	return scsifront_action_handler(sc->device, NULL);
 }
 
 static int scsifront_sdev_configure(struct scsi_device *sdev)
-- 
2.35.3

